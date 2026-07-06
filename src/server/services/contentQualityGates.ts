import "server-only";

import { ACTIVE_SUBJECT_CODES, getTopicReadinessLabel, isTopicLearnReady, isTopicProdReady } from "@/lib/curriculum/contentModel";
import { createAdminClient } from "@/lib/supabase/admin";
import { lessonContentSchema } from "@/schemas/lessonContentSchemas";
import { generatedQuestionSchema } from "@/schemas/contentGenerationSchemas";
import type { LessonContent } from "@/types/curriculum";

function assertSubjectInGenerationScope(subjectCode: string): void {
  if (!(ACTIVE_SUBJECT_CODES as readonly string[]).includes(subjectCode)) {
    throw new Error("SUBJECT_OUT_OF_SCOPE");
  }
}

export type ContentGateResult = {
  passed: boolean;
  errors: string[];
};

function fail(errors: string[]): ContentGateResult {
  return { passed: false, errors };
}

function pass(): ContentGateResult {
  return { passed: true, errors: [] };
}

function hasBlockType(content: LessonContent, type: string): boolean {
  return content.blocks.some((block) => block.type === type);
}

function validateRequiredLessonBlocks(
  content: LessonContent,
  subjectCode: string,
): string[] {
  const errors: string[] = [];

  if (!hasBlockType(content, "heading")) {
    errors.push("Lesson must include at least one heading block.");
  }

  if (!hasBlockType(content, "paragraph") && !hasBlockType(content, "rich_text")) {
    errors.push("Lesson must include at least one paragraph or rich text block.");
  }

  if (!hasBlockType(content, "tip") && !hasBlockType(content, "callout")) {
    errors.push("Lesson must include a tip or callout block.");
  }

  if (subjectCode === "kiswahili") {
    if (!hasBlockType(content, "comprehension_passage")) {
      errors.push("Kiswahili lessons require a comprehension passage block.");
    }
  } else if (subjectCode === "chemistry") {
    if (!hasBlockType(content, "chemical_equation") && !hasBlockType(content, "example")) {
      errors.push("Chemistry lessons require a chemical equation or worked example block.");
    }
  } else if (!hasBlockType(content, "example")) {
    errors.push("Lesson must include at least one worked example block.");
  }

  return errors;
}

async function resolveLessonSubjectCode(lessonId: string): Promise<{
  subjectCode: string;
  curriculumCode: string;
  content: LessonContent;
  title: string;
  estimatedMinutes: number;
}> {
  const admin = createAdminClient();
  const { data: lesson } = await admin
    .from("lessons")
    .select("id, title, content, estimated_minutes, subtopic_id")
    .eq("id", lessonId)
    .maybeSingle();

  if (!lesson) {
    throw new Error("NOT_FOUND");
  }

  const { data: subtopic } = await admin
    .from("subtopics")
    .select("id, topic_id, is_active")
    .eq("id", lesson.subtopic_id)
    .maybeSingle();

  if (!subtopic?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  const { data: topic } = await admin
    .from("topics")
    .select("id, subject_id, is_active")
    .eq("id", subtopic.topic_id)
    .maybeSingle();

  if (!topic?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("code, curriculum_id, is_active")
    .eq("id", topic.subject_id)
    .maybeSingle();

  if (!subject?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  const { data: curriculum } = await admin
    .from("curricula")
    .select("code, is_active")
    .eq("id", subject.curriculum_id)
    .maybeSingle();

  if (!curriculum?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  return {
    subjectCode: subject.code,
    curriculumCode: curriculum.code,
    content: lesson.content as LessonContent,
    title: lesson.title,
    estimatedMinutes: lesson.estimated_minutes,
  };
}

async function resolveQuestionSubjectCode(questionId: string): Promise<{
  subjectCode: string;
  question: {
    questionText: string;
    questionType: "multiple_choice" | "short_answer";
    options: string[];
    correctAnswer: string;
    difficulty: "easy" | "medium" | "hard";
    explanation: string;
  };
}> {
  const admin = createAdminClient();
  const { data: question } = await admin
    .from("practice_questions")
    .select(
      "id, topic_id, question_text, question_type, options, correct_answer, difficulty, explanation",
    )
    .eq("id", questionId)
    .maybeSingle();

  if (!question) {
    throw new Error("NOT_FOUND");
  }

  const { data: topic } = await admin
    .from("topics")
    .select("id, subject_id, is_active")
    .eq("id", question.topic_id)
    .maybeSingle();

  if (!topic?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("code, is_active")
    .eq("id", topic.subject_id)
    .maybeSingle();

  if (!subject?.is_active) {
    throw new Error("CURRICULUM_INVALID");
  }

  const options = Array.isArray(question.options)
    ? (question.options as string[])
    : [];

  return {
    subjectCode: subject.code,
    question: {
      questionText: question.question_text,
      questionType: question.question_type as "multiple_choice" | "short_answer",
      options,
      correctAnswer:
        typeof question.correct_answer === "string"
          ? question.correct_answer
          : String(question.correct_answer ?? ""),
      difficulty: question.difficulty as "easy" | "medium" | "hard",
      explanation: question.explanation ?? "",
    },
  };
}

export async function runLessonQualityGates(lessonId: string): Promise<ContentGateResult> {
  try {
    const lesson = await resolveLessonSubjectCode(lessonId);
    const errors: string[] = [];

    try {
      assertSubjectInGenerationScope(lesson.subjectCode);
    } catch {
      errors.push("Subject is outside the active generation scope.");
    }

    if (!(ACTIVE_SUBJECT_CODES as readonly string[]).includes(lesson.subjectCode)) {
      errors.push("Subject is not enabled for student-facing content.");
    }

    const parsed = lessonContentSchema.safeParse(lesson.content);
    if (!parsed.success) {
      errors.push(
        ...parsed.error.issues.map((issue) => issue.message || "Invalid lesson content."),
      );
    } else {
      errors.push(...validateRequiredLessonBlocks(parsed.data, lesson.subjectCode));

      if (parsed.data.shortQuiz?.questions?.length) {
        for (const [index, question] of parsed.data.shortQuiz.questions.entries()) {
          const normalized = question.correctAnswer.trim().toLowerCase();
          const hasMatch = question.options.some(
            (option) => option.trim().toLowerCase() === normalized,
          );
          if (!hasMatch) {
            errors.push(`Short quiz question ${index + 1}: correct answer must match an option.`);
          }
        }
      }
    }

    if (lesson.title.trim().length < 1) {
      errors.push("Lesson title is required.");
    }

    if (lesson.estimatedMinutes < 5 || lesson.estimatedMinutes > 60) {
      errors.push("Estimated minutes must be between 5 and 60.");
    }

    return errors.length ? fail(errors) : pass();
  } catch (error) {
    if (error instanceof Error && error.message === "NOT_FOUND") {
      return fail(["Lesson not found."]);
    }
    if (error instanceof Error && error.message === "CURRICULUM_INVALID") {
      return fail(["Lesson curriculum placement is invalid or inactive."]);
    }
    return fail(["Could not validate lesson quality gates."]);
  }
}

export async function runQuestionQualityGates(questionId: string): Promise<ContentGateResult> {
  try {
    const { subjectCode, question } = await resolveQuestionSubjectCode(questionId);
    const errors: string[] = [];

    try {
      assertSubjectInGenerationScope(subjectCode);
    } catch {
      errors.push("Subject is outside the active generation scope.");
    }

    const parsed = generatedQuestionSchema.safeParse(question);
    if (!parsed.success) {
      errors.push(
        ...parsed.error.issues.map((issue) => issue.message || "Invalid question shape."),
      );
    }

    return errors.length ? fail(errors) : pass();
  } catch (error) {
    if (error instanceof Error && error.message === "NOT_FOUND") {
      return fail(["Question not found."]);
    }
    if (error instanceof Error && error.message === "CURRICULUM_INVALID") {
      return fail(["Question curriculum placement is invalid or inactive."]);
    }
    return fail(["Could not validate question quality gates."]);
  }
}

async function loadTopicReadinessSnapshot(topicId: string): Promise<{
  readinessLabel: ReturnType<typeof getTopicReadinessLabel>;
  questionCounts: { easy: number; medium: number; hard: number };
  publishedLessonCount: number;
  subtopicCount: number;
  subtopicsWithLesson: number;
}> {
  const admin = createAdminClient();

  const { data: subtopics } = await admin
    .from("subtopics")
    .select("id")
    .eq("topic_id", topicId)
    .eq("is_active", true);
  const subtopicIds = (subtopics ?? []).map((row) => row.id);
  const subtopicCount = subtopicIds.length;

  let publishedLessonCount = 0;
  let subtopicsWithLesson = 0;
  if (subtopicIds.length > 0) {
    const { data: lessons } = await admin
      .from("lessons")
      .select("subtopic_id")
      .in("subtopic_id", subtopicIds)
      .eq("review_status", "published")
      .eq("is_active", true);
    publishedLessonCount = lessons?.length ?? 0;
    subtopicsWithLesson = new Set((lessons ?? []).map((row) => row.subtopic_id)).size;
  }

  const { data: questions } = await admin
    .from("practice_questions")
    .select("difficulty")
    .eq("topic_id", topicId)
    .eq("review_status", "published")
    .eq("is_active", true);

  const questionCounts = { easy: 0, medium: 0, hard: 0 };
  for (const question of questions ?? []) {
    const difficulty = question.difficulty as keyof typeof questionCounts;
    if (difficulty in questionCounts) {
      questionCounts[difficulty] += 1;
    }
  }

  return {
    readinessLabel: getTopicReadinessLabel({
      publishedLessonCount,
      subtopicCount,
      subtopicsWithLesson,
      questionCounts,
    }),
    questionCounts,
    publishedLessonCount,
    subtopicCount,
    subtopicsWithLesson,
  };
}

export async function runTopicProdReadyPublishGate(
  topicId: string,
): Promise<ContentGateResult> {
  try {
    const snapshot = await loadTopicReadinessSnapshot(topicId);
    if (snapshot.readinessLabel !== "PROD_READY") {
      return pass();
    }

    const meetsProdBar =
      isTopicLearnReady(
        snapshot.publishedLessonCount,
        snapshot.subtopicCount,
        snapshot.subtopicsWithLesson,
      ) && isTopicProdReady(snapshot.questionCounts);

    if (!meetsProdBar) {
      return fail([
        "Topic cannot be published as production-ready until DEC-002 coverage is met (≥7 questions per difficulty band and a published lesson for every subtopic).",
      ]);
    }

    return pass();
  } catch {
    return fail(["Could not validate topic production readiness gate."]);
  }
}

export async function resolveTopicIdForContent(input: {
  kind: "lesson" | "question";
  id: string;
}): Promise<string> {
  const admin = createAdminClient();

  if (input.kind === "question") {
    const { data, error } = await admin
      .from("practice_questions")
      .select("topic_id")
      .eq("id", input.id)
      .maybeSingle();
    if (error || !data?.topic_id) {
      throw new Error("NOT_FOUND");
    }
    return data.topic_id;
  }

  const { data: lesson, error: lessonError } = await admin
    .from("lessons")
    .select("subtopic_id")
    .eq("id", input.id)
    .maybeSingle();
  if (lessonError || !lesson?.subtopic_id) {
    throw new Error("NOT_FOUND");
  }

  const { data: subtopic, error: subtopicError } = await admin
    .from("subtopics")
    .select("topic_id")
    .eq("id", lesson.subtopic_id)
    .maybeSingle();
  if (subtopicError || !subtopic?.topic_id) {
    throw new Error("NOT_FOUND");
  }

  return subtopic.topic_id;
}

export async function runContentQualityGates(input: {
  kind: "lesson" | "question";
  id: string;
}): Promise<ContentGateResult> {
  return input.kind === "lesson"
    ? runLessonQualityGates(input.id)
    : runQuestionQualityGates(input.id);
}
