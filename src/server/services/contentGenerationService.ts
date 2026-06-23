import "server-only";

import { formatStudentQuestionText } from "@/lib/content/questionText";
import { ACTIVE_SUBJECT_CODES } from "@/lib/curriculum/contentModel";
import { callNexModel } from "@/lib/nex/callNexModel";
import { createAdminClient } from "@/lib/supabase/admin";
import type { Curriculum } from "@/types/database";
import type { LessonContent } from "@/types/curriculum";
import {
  generatedLessonSchema,
  generatedQuestionBankSchema,
  generateLessonDraftInputSchema,
  generateQuestionBankDraftInputSchema,
  publishDraftInputSchema,
  discardDraftInputSchema,
  updateDraftLessonRequestSchema,
  createManualDraftLessonRequestSchema,
  updateDraftQuestionRequestSchema,
  type GeneratedLesson,
  type GeneratedQuestion,
} from "@/schemas/contentGenerationSchemas";
import {
  approveAndPublish,
  archiveReviewContent,
  submitForReview,
} from "@/server/services/contentApprovalService";

interface SubtopicContext {
  subtopicId: string;
  subtopicTitle: string;
  subtopicCode: string;
  topicId: string;
  topicTitle: string;
  topicCode: string;
  subjectId: string;
  subjectCode: string;
  subjectName: string;
  curriculumCode: Curriculum;
}

interface TopicContext {
  topicId: string;
  topicTitle: string;
  topicCode: string;
  subjectId: string;
  subjectCode: string;
  subjectName: string;
  curriculumCode: Curriculum;
  subtopicId?: string;
  subtopicTitle?: string;
}

export interface GeneratedLessonDraftResult {
  lessonId: string;
  title: string;
  content: LessonContent;
  estimatedMinutes: number;
  reviewStatus: "draft";
  isActive: false;
  model: string;
}

export interface GeneratedQuestionDraftResult {
  questionIds: string[];
  count: number;
  reviewStatus: "draft";
  isActive: false;
  model: string;
}

export interface PublishDraftResult {
  id: string;
  kind: "lesson" | "question";
  reviewStatus: "published";
  isActive: true;
}

export interface DiscardDraftResult {
  id: string;
  kind: "lesson" | "question";
  reviewStatus: "archived";
  isActive: false;
}

export function assertSubjectInGenerationScope(subjectCode: string): void {
  if (!(ACTIVE_SUBJECT_CODES as readonly string[]).includes(subjectCode)) {
    throw new Error("SCOPE_VIOLATION");
  }
}

function standardsLabel(curriculum: Curriculum, subjectName: string): string {
  return curriculum === "CBC"
    ? `KICD/CBC ${subjectName} standards`
    : `KNEC/KCSE ${subjectName} standards`;
}

function subjectAuthoringRules(subjectCode: string): string[] {
  switch (subjectCode) {
    case "chemistry":
      return [
        "Use correct IUPAC names and balanced equations. When a chemical equation is central, emit a `chemical_equation` block.",
        "State units. Reference Kenyan industrial/real-life contexts (e.g. soda ash at Magadi) where natural.",
      ];
    case "kiswahili":
      return [
        "Andika kwa Kiswahili sanifu. Kwa ufahamu, tumia kizuizi cha `comprehension_passage`.",
        "Usitumie mtindo wa mfano wa hatua za hesabu; tumia mifano ya lugha, sarufi, na fasihi.",
      ];
    default:
      return [
        "Use Kenyan contexts in word problems (chapati, matatu fares, shillings, local names).",
      ];
  }
}

function lessonRequiredBlocksGuidance(subjectCode: string): string {
  switch (subjectCode) {
    case "kiswahili":
      return "Include heading, paragraph(s), (where relevant) a `comprehension_passage` block, and a tip block.";
    case "chemistry":
      return "Include heading, paragraph, at least one worked `example` OR `chemical_equation` block, and a tip block.";
    default:
      return "Include heading, paragraph, at least one worked example with steps, and a tip block.";
  }
}

function lessonBlockSchemaExample(subjectCode: string): unknown {
  const baseBlocks: unknown[] = [
    { type: "heading", content: "..." },
    { type: "paragraph", content: "..." },
  ];

  if (subjectCode === "kiswahili") {
    baseBlocks.push({
      type: "comprehension_passage",
      title: "Kifungu",
      passage: "...",
    });
  } else if (subjectCode === "chemistry") {
    baseBlocks.push({
      type: "chemical_equation",
      equation: "2H_2 + O_2 -> 2H_2O",
      caption: "...",
    });
  } else {
    baseBlocks.push({
      type: "example",
      title: "Worked Example",
      steps: ["Step 1 ..."],
      answer: "...",
    });
  }

  baseBlocks.push({ type: "tip", content: "..." });

  return {
    title: "string",
    estimatedMinutes: 10,
    blocks: baseBlocks,
    shortQuiz: {
      questions: [
        {
          questionText: "...",
          options: ["A", "B", "C"],
          correctAnswer: "B",
        },
      ],
    },
  };
}

function extractJsonFromModelOutput(raw: string): unknown {
  const trimmed = raw.trim();
  const fenceMatch = trimmed.match(/```(?:json)?\s*([\s\S]*?)```/i);
  const jsonText = fenceMatch ? fenceMatch[1].trim() : trimmed;
  return JSON.parse(jsonText);
}

function buildLessonSystemPrompt(context: SubtopicContext, gradeLevel: string): string {
  const standards = standardsLabel(context.curriculumCode, context.subjectName);
  const authoringRules = subjectAuthoringRules(context.subjectCode);
  const requiredBlocks = lessonRequiredBlocksGuidance(context.subjectCode);

  return [
    `You are a curriculum author for Kenyan ${context.curriculumCode} ${context.subjectName}.`,
    `Write ONE lesson aligned to ${standards} for ${gradeLevel}.`,
    "Rules:",
    ...authoringRules.map((rule) => `- ${rule}`),
    "- Grade-appropriate vocabulary only.",
    "- Focus on ONE concept per lesson.",
    `- ${requiredBlocks}`,
    "- Optional shortQuiz with 1-3 multiple-choice questions.",
    "- Return JSON ONLY matching this schema:",
    JSON.stringify(lessonBlockSchemaExample(context.subjectCode), null, 2),
    "Do not wrap JSON in markdown fences.",
  ].join("\n");
}

export function buildLessonSystemPromptForTest(
  context: SubtopicContext,
  gradeLevel: string,
): string {
  return buildLessonSystemPrompt(context, gradeLevel);
}

function buildQuestionBankSystemPrompt(
  context: TopicContext,
  gradeLevel: string,
  difficulty: string,
  count: number,
): string {
  const standards = standardsLabel(context.curriculumCode, context.subjectName);
  const contextRules =
    context.subjectCode === "kiswahili"
      ? ["- Andika maswali kwa Kiswahili sanifu.", "- Tumia muktadha wa Kenya inapofaa."]
      : context.subjectCode === "chemistry"
        ? [
            "- Use correct IUPAC names, units, and balanced equations where relevant.",
            "- Reference Kenyan industrial/real-life contexts where natural.",
          ]
        : ["- Kenyan contexts in word problems."];

  return [
    `You are a question bank author for Kenyan ${context.curriculumCode} ${context.subjectName}.`,
    `Write ${count} unique ${difficulty} practice questions for ${gradeLevel}.`,
    `Topic: ${context.topicTitle}.`,
    context.subtopicTitle ? `Subtopic: ${context.subtopicTitle}.` : "",
    `Align to ${standards}.`,
    "Rules:",
    ...contextRules,
    "- Each question must be distinct.",
    "- questionText must contain only the actual question prompt. Do not prefix it with titles like \"KCSE algebra practice 1:\" or \"Grade-level medium review:\".",
    "- questionType is multiple_choice or short_answer.",
    "- For multiple_choice, options must include the correctAnswer exactly.",
    "- Return JSON ONLY matching:",
    JSON.stringify(
      {
        questions: [
          {
            questionText: "...",
            questionType: "multiple_choice",
            options: ["...", "...", "..."],
            correctAnswer: "...",
            difficulty,
            explanation: "...",
          },
        ],
      },
      null,
      2,
    ),
    "Do not wrap JSON in markdown fences.",
  ]
    .filter(Boolean)
    .join("\n");
}

async function loadSubtopicContext(
  subtopicId: string,
  curriculum: Curriculum,
): Promise<SubtopicContext> {
  const admin = createAdminClient();

  const { data: subtopic, error } = await admin
    .from("subtopics")
    .select("id, code, title, topic_id")
    .eq("id", subtopicId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !subtopic) {
    throw new Error("NOT_FOUND");
  }

  const { data: topic } = await admin
    .from("topics")
    .select("id, code, title, subject_id")
    .eq("id", subtopic.topic_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    throw new Error("NOT_FOUND");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("id, code, name, curriculum_id")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject) {
    throw new Error("NOT_FOUND");
  }

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("code")
    .eq("id", subject.curriculum_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!curriculumRow || curriculumRow.code !== curriculum) {
    throw new Error("CURRICULUM_MISMATCH");
  }

  assertSubjectInGenerationScope(subject.code);

  return {
    subtopicId: subtopic.id,
    subtopicTitle: subtopic.title,
    subtopicCode: subtopic.code,
    topicId: topic.id,
    topicTitle: topic.title,
    topicCode: topic.code,
    subjectId: subject.id,
    subjectCode: subject.code,
    subjectName: subject.name,
    curriculumCode: curriculumRow.code as Curriculum,
  };
}

async function loadTopicContext(
  topicId: string,
  curriculum: Curriculum,
  subtopicId?: string,
): Promise<TopicContext> {
  const admin = createAdminClient();

  const { data: topic, error } = await admin
    .from("topics")
    .select("id, code, title, subject_id")
    .eq("id", topicId)
    .eq("is_active", true)
    .maybeSingle();

  if (error || !topic) {
    throw new Error("NOT_FOUND");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("id, code, name, curriculum_id")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject) {
    throw new Error("NOT_FOUND");
  }

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("code")
    .eq("id", subject.curriculum_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!curriculumRow || curriculumRow.code !== curriculum) {
    throw new Error("CURRICULUM_MISMATCH");
  }

  assertSubjectInGenerationScope(subject.code);

  let subtopicTitle: string | undefined;
  if (subtopicId) {
    const { data: subtopic } = await admin
      .from("subtopics")
      .select("id, title, topic_id")
      .eq("id", subtopicId)
      .eq("topic_id", topicId)
      .eq("is_active", true)
      .maybeSingle();

    if (!subtopic) {
      throw new Error("NOT_FOUND");
    }

    subtopicTitle = subtopic.title;
  }

  return {
    topicId: topic.id,
    topicTitle: topic.title,
    topicCode: topic.code,
    subjectId: subject.id,
    subjectCode: subject.code,
    subjectName: subject.name,
    curriculumCode: curriculumRow.code as Curriculum,
    subtopicId,
    subtopicTitle,
  };
}

async function callModelForLesson(
  context: SubtopicContext,
  gradeLevel: string,
): Promise<{ lesson: GeneratedLesson; model: string }> {
  const systemPrompt = buildLessonSystemPrompt(context, gradeLevel);
  const userPrompt = [
    `Generate a lesson for subtopic "${context.subtopicTitle}"`,
    `under topic "${context.topicTitle}" (${context.curriculumCode} ${context.subjectName}).`,
    `Target grade: ${gradeLevel}.`,
  ].join(" ");

  let lastError: unknown;

  for (let attempt = 0; attempt < 2; attempt += 1) {
    const retrySuffix =
      attempt === 1
        ? "\n\nYour previous output was invalid JSON. Return ONLY valid JSON matching the schema."
        : "";

    const result = await callNexModel({
      systemPrompt,
      messages: [{ role: "student", content: userPrompt + retrySuffix }],
      maxTokens: 4000,
      allowOpenAIFallback: false,
    });

    try {
      const parsed = extractJsonFromModelOutput(result.content);
      const lesson = generatedLessonSchema.parse(parsed);
      return { lesson, model: result.provider };
    } catch (error) {
      lastError = error;
    }
  }

  throw new Error(
    lastError instanceof Error
      ? `GENERATION_INVALID_OUTPUT: ${lastError.message}`
      : "GENERATION_INVALID_OUTPUT",
  );
}

async function callModelForQuestions(
  context: TopicContext,
  gradeLevel: string,
  difficulty: "easy" | "medium" | "hard",
  count: number,
): Promise<{ questions: GeneratedQuestion[]; model: string }> {
  const systemPrompt = buildQuestionBankSystemPrompt(
    context,
    gradeLevel,
    difficulty,
    count,
  );
  const userPrompt = [
    `Generate ${count} ${difficulty} questions for topic "${context.topicTitle}".`,
    context.subtopicTitle ? `Subtopic: "${context.subtopicTitle}".` : "",
    `Grade: ${gradeLevel}.`,
  ]
    .filter(Boolean)
    .join(" ");

  let lastError: unknown;

  for (let attempt = 0; attempt < 2; attempt += 1) {
    const retrySuffix =
      attempt === 1
        ? "\n\nYour previous output was invalid JSON. Return ONLY valid JSON matching the schema."
        : "";

    const result = await callNexModel({
      systemPrompt,
      messages: [{ role: "student", content: userPrompt + retrySuffix }],
      maxTokens: 4000,
      allowOpenAIFallback: false,
    });

    try {
      const parsed = extractJsonFromModelOutput(result.content);
      const bank = generatedQuestionBankSchema.parse(parsed);
      const questions = bank.questions.slice(0, count).map((question) => ({
        ...question,
        questionText: formatStudentQuestionText(question.questionText),
        difficulty,
      }));
      return { questions, model: result.provider };
    } catch (error) {
      lastError = error;
    }
  }

  throw new Error(
    lastError instanceof Error
      ? `GENERATION_INVALID_OUTPUT: ${lastError.message}`
      : "GENERATION_INVALID_OUTPUT",
  );
}

async function recordGenerationJob(input: {
  adminId: string;
  scopeType: "subtopic" | "topic";
  scopeId: string;
  curriculumCode: string;
  status: "completed" | "failed";
  lessonsCreated: number;
  questionsCreated: number;
  model: string | null;
  error: string | null;
}): Promise<void> {
  const admin = createAdminClient();

  await admin.from("content_generation_jobs").insert({
    admin_id: input.adminId,
    scope_type: input.scopeType,
    scope_id: input.scopeId,
    curriculum_code: input.curriculumCode,
    status: input.status,
    lessons_created: input.lessonsCreated,
    questions_created: input.questionsCreated,
    model: input.model,
    error: input.error,
  });
}

async function getNextLessonSortOrder(subtopicId: string): Promise<number> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("lessons")
    .select("sort_order")
    .eq("subtopic_id", subtopicId)
    .order("sort_order", { ascending: false })
    .limit(1)
    .maybeSingle();

  return (data?.sort_order ?? 0) + 1;
}

async function getExistingQuestionTexts(topicId: string): Promise<Set<string>> {
  const admin = createAdminClient();
  const { data } = await admin
    .from("practice_questions")
    .select("question_text")
    .eq("topic_id", topicId);

  return new Set((data ?? []).map((row) => row.question_text.trim().toLowerCase()));
}

function toLessonContent(lesson: GeneratedLesson): LessonContent {
  return {
    blocks: lesson.blocks,
    shortQuiz: lesson.shortQuiz,
  };
}

export async function getSubtopicAuthoringContext(
  subtopicId: string,
  curriculum: Curriculum,
): Promise<SubtopicContext> {
  return loadSubtopicContext(subtopicId, curriculum);
}

export async function produceLessonFromModel(input: {
  subtopicId: string;
  curriculum: Curriculum;
  gradeLevel: string;
}): Promise<{ lesson: GeneratedLesson; model: string }> {
  const context = await loadSubtopicContext(input.subtopicId, input.curriculum);
  return callModelForLesson(context, input.gradeLevel);
}

export async function produceQuestionsFromModel(input: {
  topicId: string;
  subtopicId?: string;
  curriculum: Curriculum;
  gradeLevel: string;
  difficulty: "easy" | "medium" | "hard";
  count: number;
}): Promise<{ questions: GeneratedQuestion[]; model: string }> {
  const context = await loadTopicContext(input.topicId, input.curriculum, input.subtopicId);
  return callModelForQuestions(
    context,
    input.gradeLevel,
    input.difficulty,
    input.count,
  );
}

export async function generateLessonDraft(
  input: Parameters<typeof generateLessonDraftInputSchema.parse>[0],
): Promise<GeneratedLessonDraftResult> {
  const parsed = generateLessonDraftInputSchema.parse(input);

  try {
    const { lesson, model } = await produceLessonFromModel({
      subtopicId: parsed.subtopicId,
      curriculum: parsed.curriculum,
      gradeLevel: parsed.gradeLevel,
    });
    const admin = createAdminClient();
    const sortOrder = await getNextLessonSortOrder(parsed.subtopicId);
    const content = toLessonContent(lesson);

    const { data: inserted, error } = await admin
      .from("lessons")
      .insert({
        subtopic_id: parsed.subtopicId,
        title: lesson.title,
        content,
        estimated_minutes: lesson.estimatedMinutes,
        sort_order: sortOrder,
        is_active: false,
        review_status: "draft",
        generated_by: parsed.adminId,
        generated_model: model,
      })
      .select("id, title, content, estimated_minutes")
      .single();

    if (error || !inserted) {
      throw new Error(error?.message ?? "Could not save lesson draft.");
    }

    await recordGenerationJob({
      adminId: parsed.adminId,
      scopeType: "subtopic",
      scopeId: parsed.subtopicId,
      curriculumCode: parsed.curriculum,
      status: "completed",
      lessonsCreated: 1,
      questionsCreated: 0,
      model,
      error: null,
    });

    return {
      lessonId: inserted.id,
      title: inserted.title,
      content: toLessonContent(inserted.content),
      estimatedMinutes: inserted.estimated_minutes,
      reviewStatus: "draft",
      isActive: false,
      model,
    };
  } catch (error) {
    await recordGenerationJob({
      adminId: parsed.adminId,
      scopeType: "subtopic",
      scopeId: parsed.subtopicId,
      curriculumCode: parsed.curriculum,
      status: "failed",
      lessonsCreated: 0,
      questionsCreated: 0,
      model: null,
      error: error instanceof Error ? error.message : "Unknown error",
    });
    throw error;
  }
}

export async function generateQuestionBankDraft(
  input: Parameters<typeof generateQuestionBankDraftInputSchema.parse>[0],
): Promise<GeneratedQuestionDraftResult> {
  const parsed = generateQuestionBankDraftInputSchema.parse(input);

  try {
    const { questions, model } = await produceQuestionsFromModel({
      topicId: parsed.topicId,
      subtopicId: parsed.subtopicId,
      curriculum: parsed.curriculum,
      gradeLevel: parsed.gradeLevel,
      difficulty: parsed.difficulty,
      count: parsed.count,
    });

    const existingTexts = await getExistingQuestionTexts(parsed.topicId);
    const uniqueQuestions = questions.filter(
      (question) => !existingTexts.has(question.questionText.trim().toLowerCase()),
    );

    if (!uniqueQuestions.length) {
      throw new Error("GENERATION_DEDUPED");
    }

    const admin = createAdminClient();
    const rows = uniqueQuestions.map((question) => ({
      topic_id: parsed.topicId,
      subtopic_id: parsed.subtopicId ?? null,
      question_text: question.questionText,
      question_type: question.questionType,
      options: question.options,
      correct_answer: question.correctAnswer,
      difficulty: question.difficulty,
      explanation: question.explanation,
      is_active: false,
      review_status: "draft",
      generated_by: parsed.adminId,
      generated_model: model,
    }));

    const { data: inserted, error } = await admin
      .from("practice_questions")
      .insert(rows)
      .select("id");

    if (error || !inserted?.length) {
      throw new Error(error?.message ?? "Could not save question drafts.");
    }

    await recordGenerationJob({
      adminId: parsed.adminId,
      scopeType: "topic",
      scopeId: parsed.topicId,
      curriculumCode: parsed.curriculum,
      status: "completed",
      lessonsCreated: 0,
      questionsCreated: inserted.length,
      model,
      error: null,
    });

    return {
      questionIds: inserted.map((row) => row.id),
      count: inserted.length,
      reviewStatus: "draft",
      isActive: false,
      model,
    };
  } catch (error) {
    await recordGenerationJob({
      adminId: parsed.adminId,
      scopeType: "topic",
      scopeId: parsed.topicId,
      curriculumCode: parsed.curriculum,
      status: "failed",
      lessonsCreated: 0,
      questionsCreated: 0,
      model: null,
      error: error instanceof Error ? error.message : "Unknown error",
    });
    throw error;
  }
}

export async function publishDraft(
  input: Parameters<typeof publishDraftInputSchema.parse>[0],
): Promise<PublishDraftResult> {
  const parsed = publishDraftInputSchema.parse(input);
  const admin = createAdminClient();
  const table = parsed.kind === "lesson" ? "lessons" : "practice_questions";

  const { data: existing, error: fetchError } = await admin
    .from(table)
    .select("id, review_status")
    .eq("id", parsed.id)
    .maybeSingle();

  if (fetchError || !existing) {
    throw new Error("NOT_FOUND");
  }

  if (existing.review_status === "in_review") {
    const result = await approveAndPublish({
      kind: parsed.kind,
      id: parsed.id,
      adminId: parsed.adminId,
    });

    if (result.reviewStatus !== "published" || !result.isActive) {
      throw new Error("CONFLICT");
    }

    return {
      id: result.id,
      kind: result.kind,
      reviewStatus: "published",
      isActive: true,
    };
  }

  if (existing.review_status === "draft") {
    const result = await submitForReview({
      kind: parsed.kind,
      id: parsed.id,
      adminId: parsed.adminId,
    });

    if (result.reviewStatus === "in_review") {
      throw new Error("PENDING_REVIEW");
    }

    if (result.reviewStatus !== "published" || !result.isActive) {
      throw new Error("CONFLICT");
    }

    return {
      id: result.id,
      kind: result.kind,
      reviewStatus: "published",
      isActive: true,
    };
  }

  throw new Error("CONFLICT");
}

export async function discardDraft(
  input: Parameters<typeof discardDraftInputSchema.parse>[0],
): Promise<DiscardDraftResult> {
  const parsed = discardDraftInputSchema.parse(input);
  const admin = createAdminClient();
  const table = parsed.kind === "lesson" ? "lessons" : "practice_questions";

  const { data: existing, error: fetchError } = await admin
    .from(table)
    .select("id, review_status")
    .eq("id", parsed.id)
    .maybeSingle();

  if (fetchError || !existing) {
    throw new Error("NOT_FOUND");
  }

  if (existing.review_status !== "draft" && existing.review_status !== "in_review") {
    throw new Error("CONFLICT");
  }

  const result = await archiveReviewContent({
    kind: parsed.kind,
    id: parsed.id,
    adminId: parsed.adminId,
  });

  if (result.reviewStatus !== "archived" || result.isActive) {
    throw new Error("CONFLICT");
  }

  return {
    id: result.id,
    kind: result.kind,
    reviewStatus: "archived",
    isActive: false,
  };
}

export async function updateDraftLesson(
  input: Parameters<typeof updateDraftLessonRequestSchema.parse>[0],
): Promise<{ id: string; title: string; estimatedMinutes: number; content: LessonContent }> {
  const parsed = updateDraftLessonRequestSchema.parse(input);
  const admin = createAdminClient();
  const content = toLessonContent({
    title: parsed.title,
    estimatedMinutes: parsed.estimatedMinutes,
    blocks: parsed.blocks,
    shortQuiz: parsed.shortQuiz,
  });

  const { data: existing, error: fetchError } = await admin
    .from("lessons")
    .select("id, review_status")
    .eq("id", parsed.id)
    .maybeSingle();

  if (fetchError || !existing) {
    throw new Error("NOT_FOUND");
  }

  if (existing.review_status !== "draft") {
    throw new Error("CONFLICT");
  }

  const { data: updated, error } = await admin
    .from("lessons")
    .update({
      title: parsed.title,
      estimated_minutes: parsed.estimatedMinutes,
      content,
      updated_at: new Date().toISOString(),
    })
    .eq("id", parsed.id)
    .select("id, title, estimated_minutes, content")
    .single();

  if (error || !updated) {
    throw new Error(error?.message ?? "Could not update lesson draft.");
  }

  return {
    id: updated.id,
    title: updated.title,
    estimatedMinutes: updated.estimated_minutes,
    content: toLessonContent(updated.content),
  };
}

export async function updateDraftQuestion(
  input: Parameters<typeof updateDraftQuestionRequestSchema.parse>[0],
): Promise<{ id: string }> {
  const parsed = updateDraftQuestionRequestSchema.parse(input);
  const admin = createAdminClient();

  const { data: existing, error: fetchError } = await admin
    .from("practice_questions")
    .select("id, review_status")
    .eq("id", parsed.id)
    .maybeSingle();

  if (fetchError || !existing) {
    throw new Error("NOT_FOUND");
  }

  if (existing.review_status !== "draft") {
    throw new Error("CONFLICT");
  }

  const { error } = await admin
    .from("practice_questions")
    .update({
      question_text: parsed.questionText,
      question_type: parsed.questionType,
      options: parsed.questionType === "multiple_choice" ? parsed.options : null,
      correct_answer: parsed.correctAnswer,
      difficulty: parsed.difficulty,
      explanation: parsed.explanation,
    })
    .eq("id", parsed.id);

  if (error) {
    throw new Error(error.message);
  }

  return { id: parsed.id };
}

export async function getDraftLessonForPreview(lessonId: string): Promise<{
  id: string;
  title: string;
  content: LessonContent;
  estimatedMinutes: number;
  sortOrder: number;
  subtopicId: string;
  subtopicTitle: string;
  topicId: string;
  topicTitle: string;
  subjectId: string;
  curriculumCode: Curriculum;
  reviewStatus: "draft" | "in_review";
  reviewNotes: string | null;
} | null> {
  const admin = createAdminClient();

  const { data: lesson } = await admin
    .from("lessons")
    .select("id, title, content, estimated_minutes, sort_order, subtopic_id, review_status, review_notes")
    .eq("id", lessonId)
    .in("review_status", ["draft", "in_review"])
    .maybeSingle();

  if (!lesson) {
    return null;
  }

  const { data: subtopic } = await admin
    .from("subtopics")
    .select("id, title, topic_id")
    .eq("id", lesson.subtopic_id)
    .maybeSingle();

  if (!subtopic) {
    return null;
  }

  const { data: topic } = await admin
    .from("topics")
    .select("id, title, subject_id")
    .eq("id", subtopic.topic_id)
    .maybeSingle();

  if (!topic) {
    return null;
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("id, curriculum_id")
    .eq("id", topic.subject_id)
    .maybeSingle();

  if (!subject) {
    return null;
  }

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("code")
    .eq("id", subject.curriculum_id)
    .maybeSingle();

  if (!curriculumRow) {
    return null;
  }

  return {
    id: lesson.id,
    title: lesson.title,
    content: toLessonContent(lesson.content),
    estimatedMinutes: lesson.estimated_minutes,
    sortOrder: lesson.sort_order,
    subtopicId: subtopic.id,
    subtopicTitle: subtopic.title,
    topicId: topic.id,
    topicTitle: topic.title,
    subjectId: subject.id,
    curriculumCode: curriculumRow.code as Curriculum,
    reviewStatus: lesson.review_status as "draft" | "in_review",
    reviewNotes: lesson.review_notes,
  };
}

export async function createManualDraftLesson(
  input: Parameters<typeof createManualDraftLessonRequestSchema.parse>[0],
  adminId: string,
): Promise<{
  lessonId: string;
  title: string;
  estimatedMinutes: number;
  content: LessonContent;
  subtopicId: string;
}> {
  const parsed = createManualDraftLessonRequestSchema.parse(input);
  const admin = createAdminClient();

  const { data: subtopic, error: subtopicError } = await admin
    .from("subtopics")
    .select("id, title, topic_id")
    .eq("id", parsed.subtopicId)
    .eq("is_active", true)
    .maybeSingle();

  if (subtopicError || !subtopic) {
    throw new Error("NOT_FOUND");
  }

  const { data: topic } = await admin
    .from("topics")
    .select("id, subject_id")
    .eq("id", subtopic.topic_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    throw new Error("NOT_FOUND");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("code")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject) {
    throw new Error("NOT_FOUND");
  }

  assertSubjectInGenerationScope(subject.code);

  const title = parsed.title?.trim() || "Untitled lesson";
  const estimatedMinutes = parsed.estimatedMinutes ?? 10;
  const sortOrder = await getNextLessonSortOrder(parsed.subtopicId);
  const content: LessonContent = {
    blocks: [
      { type: "heading", content: title },
      { type: "paragraph", content: "Start writing your lesson here." },
    ],
  };

  const { data: inserted, error } = await admin
    .from("lessons")
    .insert({
      subtopic_id: parsed.subtopicId,
      title,
      content,
      estimated_minutes: estimatedMinutes,
      sort_order: sortOrder,
      is_active: false,
      review_status: "draft",
      generated_by: adminId,
      author_id: adminId,
      generated_model: null,
    })
    .select("id, title, estimated_minutes, content")
    .single();

  if (error || !inserted) {
    throw new Error(error?.message ?? "Could not create lesson draft.");
  }

  return {
    lessonId: inserted.id,
    title: inserted.title,
    estimatedMinutes: inserted.estimated_minutes,
    content: inserted.content as LessonContent,
    subtopicId: parsed.subtopicId,
  };
}
