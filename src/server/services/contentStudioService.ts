import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type {
  BulkSaveQuestionsResult,
  ReorderLessonsResult,
  StudioLessonSummary,
  StudioQuestionRow,
  StudioSubtopicContext,
  StudioTopicContext,
} from "@/types/contentStudio";
import type {
  BulkSaveTopicQuestionsRequest,
  CreateManualQuestionRequest,
} from "@/schemas/contentStudioSchemas";
import {
  bulkSaveTopicQuestionsRequestSchema,
  createManualQuestionRequestSchema,
  reorderSubtopicLessonsRequestSchema,
} from "@/schemas/contentStudioSchemas";
import { generatedQuestionSchema } from "@/schemas/contentGenerationSchemas";

import { assertSubjectInGenerationScope } from "@/server/services/contentGenerationService";

function parseOptions(raw: unknown): string[] {
  if (!Array.isArray(raw)) {
    return [];
  }

  return raw.filter((value): value is string => typeof value === "string");
}

function parseCorrectAnswer(raw: unknown): string {
  if (typeof raw === "string") {
    return raw;
  }

  if (raw === null || raw === undefined) {
    return "";
  }

  return String(raw);
}

async function loadTopicContext(topicId: string): Promise<StudioTopicContext> {
  const admin = createAdminClient();
  const { data: topic } = await admin
    .from("topics")
    .select("id, title, subject_id")
    .eq("id", topicId)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    throw new Error("NOT_FOUND");
  }

  const { data: subject } = await admin
    .from("subjects")
    .select("code, curriculum_id")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject) {
    throw new Error("NOT_FOUND");
  }

  const { data: curriculum } = await admin
    .from("curricula")
    .select("code")
    .eq("id", subject.curriculum_id)
    .maybeSingle();

  if (!curriculum) {
    throw new Error("NOT_FOUND");
  }

  assertSubjectInGenerationScope(subject.code);

  return {
    topicId: topic.id,
    topicTitle: topic.title,
    subjectCode: subject.code,
    curriculumCode: curriculum.code as StudioTopicContext["curriculumCode"],
  };
}

async function loadSubtopicContext(subtopicId: string): Promise<StudioSubtopicContext> {
  const admin = createAdminClient();
  const { data: subtopic } = await admin
    .from("subtopics")
    .select("id, title, topic_id")
    .eq("id", subtopicId)
    .eq("is_active", true)
    .maybeSingle();

  if (!subtopic) {
    throw new Error("NOT_FOUND");
  }

  const topic = await loadTopicContext(subtopic.topic_id);

  return {
    subtopicId: subtopic.id,
    subtopicTitle: subtopic.title,
    topicId: topic.topicId,
    topicTitle: topic.topicTitle,
    subjectCode: topic.subjectCode,
    curriculumCode: topic.curriculumCode,
  };
}

export async function listSubtopicLessons(subtopicId: string): Promise<{
  context: StudioSubtopicContext;
  lessons: StudioLessonSummary[];
}> {
  const context = await loadSubtopicContext(subtopicId);
  const admin = createAdminClient();

  const { data: lessons, error } = await admin
    .from("lessons")
    .select("id, title, review_status, is_active, sort_order, estimated_minutes, updated_at")
    .eq("subtopic_id", subtopicId)
    .neq("review_status", "archived")
    .order("sort_order", { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  return {
    context,
    lessons: (lessons ?? []).map((lesson) => ({
      id: lesson.id,
      title: lesson.title,
      reviewStatus: lesson.review_status as StudioLessonSummary["reviewStatus"],
      isActive: lesson.is_active,
      sortOrder: lesson.sort_order,
      estimatedMinutes: lesson.estimated_minutes,
      updatedAt: lesson.updated_at,
    })),
  };
}

export async function listTopicQuestions(topicId: string): Promise<{
  context: StudioTopicContext;
  questions: StudioQuestionRow[];
}> {
  const context = await loadTopicContext(topicId);
  const admin = createAdminClient();

  const { data: questions, error } = await admin
    .from("practice_questions")
    .select(
      "id, topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation, review_status, is_active",
    )
    .eq("topic_id", topicId)
    .neq("review_status", "archived")
    .order("question_text", { ascending: true });

  if (error) {
    throw new Error(error.message);
  }

  return {
    context,
    questions: (questions ?? []).map((question) => ({
      id: question.id,
      topicId: question.topic_id,
      subtopicId: question.subtopic_id,
      questionText: question.question_text,
      questionType: question.question_type as StudioQuestionRow["questionType"],
      options: parseOptions(question.options),
      correctAnswer: parseCorrectAnswer(question.correct_answer),
      difficulty: question.difficulty as StudioQuestionRow["difficulty"],
      explanation: question.explanation,
      reviewStatus: question.review_status as StudioQuestionRow["reviewStatus"],
      isActive: question.is_active,
    })),
  };
}

export async function reorderSubtopicLessons(
  input: Parameters<typeof reorderSubtopicLessonsRequestSchema.parse>[0],
): Promise<ReorderLessonsResult> {
  const parsed = reorderSubtopicLessonsRequestSchema.parse(input);
  await loadSubtopicContext(parsed.subtopicId);

  const admin = createAdminClient();
  const uniqueIds = new Set(parsed.lessonIds);
  if (uniqueIds.size !== parsed.lessonIds.length) {
    throw new Error("VALIDATION_ERROR");
  }

  const { data: existingLessons, error: fetchError } = await admin
    .from("lessons")
    .select("id")
    .eq("subtopic_id", parsed.subtopicId)
    .neq("review_status", "archived");

  if (fetchError) {
    throw new Error(fetchError.message);
  }

  const existingIds = new Set((existingLessons ?? []).map((lesson) => lesson.id));
  if (
    existingIds.size !== parsed.lessonIds.length ||
    !parsed.lessonIds.every((id) => existingIds.has(id))
  ) {
    throw new Error("VALIDATION_ERROR");
  }

  for (const [index, lessonId] of parsed.lessonIds.entries()) {
    const { error } = await admin
      .from("lessons")
      .update({ sort_order: index + 1, updated_at: new Date().toISOString() })
      .eq("id", lessonId)
      .eq("subtopic_id", parsed.subtopicId);

    if (error) {
      throw new Error(error.message);
    }
  }

  return {
    subtopicId: parsed.subtopicId,
    lessonIds: parsed.lessonIds,
  };
}

export async function createManualPracticeQuestion(
  input: CreateManualQuestionRequest,
  adminId: string,
): Promise<{ id: string }> {
  const parsed = createManualQuestionRequestSchema.parse(input);
  await loadTopicContext(parsed.topicId);

  const admin = createAdminClient();
  const { data: inserted, error } = await admin
    .from("practice_questions")
    .insert({
      topic_id: parsed.topicId,
      subtopic_id: parsed.subtopicId ?? null,
      question_text: parsed.questionText,
      question_type: parsed.questionType,
      options: parsed.questionType === "multiple_choice" ? parsed.options : null,
      correct_answer: parsed.correctAnswer,
      difficulty: parsed.difficulty,
      explanation: parsed.explanation,
      is_active: false,
      review_status: "draft",
      generated_by: adminId,
      generated_model: null,
    })
    .select("id")
    .single();

  if (error || !inserted) {
    throw new Error(error?.message ?? "Could not create question draft.");
  }

  return { id: inserted.id };
}

export async function bulkSaveTopicQuestions(
  input: BulkSaveTopicQuestionsRequest,
  adminId: string,
): Promise<BulkSaveQuestionsResult> {
  const parsed = bulkSaveTopicQuestionsRequestSchema.parse(input);
  await loadTopicContext(parsed.topicId);

  const admin = createAdminClient();
  const result: BulkSaveQuestionsResult = {
    createdIds: [],
    updatedIds: [],
    archivedIds: [],
    errors: [],
  };

  for (const [index, row] of parsed.questions.entries()) {
    if (row.delete) {
      if (!row.id) {
        continue;
      }

      const { data: existing } = await admin
        .from("practice_questions")
        .select("id, review_status, topic_id")
        .eq("id", row.id)
        .maybeSingle();

      if (!existing || existing.topic_id !== parsed.topicId) {
        result.errors.push({ index, message: "Question not found for this topic." });
        continue;
      }

      if (existing.review_status !== "draft") {
        result.errors.push({ index, message: "Only draft questions can be archived from bulk save." });
        continue;
      }

      const { error } = await admin
        .from("practice_questions")
        .update({ review_status: "archived", is_active: false })
        .eq("id", row.id);

      if (error) {
        result.errors.push({ index, message: error.message });
        continue;
      }

      result.archivedIds.push(row.id);
      continue;
    }

    const questionPayload = generatedQuestionSchema.safeParse({
      questionText: row.questionText,
      questionType: row.questionType,
      options: row.options,
      correctAnswer: row.correctAnswer,
      difficulty: row.difficulty,
      explanation: row.explanation,
    });

    if (!questionPayload.success) {
      result.errors.push({
        index,
        message: questionPayload.error.issues.map((issue) => issue.message).join("; "),
      });
      continue;
    }

    const question = questionPayload.data;

    if (!row.id) {
      const { data: inserted, error } = await admin
        .from("practice_questions")
        .insert({
          topic_id: parsed.topicId,
          subtopic_id: row.subtopicId ?? null,
          question_text: question.questionText,
          question_type: question.questionType,
          options: question.questionType === "multiple_choice" ? question.options : null,
          correct_answer: question.correctAnswer,
          difficulty: question.difficulty,
          explanation: question.explanation,
          is_active: false,
          review_status: "draft",
          generated_by: adminId,
          generated_model: null,
        })
        .select("id")
        .single();

      if (error || !inserted) {
        result.errors.push({ index, message: error?.message ?? "Insert failed." });
        continue;
      }

      result.createdIds.push(inserted.id);
      continue;
    }

    const { data: existing } = await admin
      .from("practice_questions")
      .select("id, review_status, topic_id")
      .eq("id", row.id)
      .maybeSingle();

    if (!existing || existing.topic_id !== parsed.topicId) {
      result.errors.push({ index, message: "Question not found for this topic." });
      continue;
    }

    if (existing.review_status !== "draft") {
      result.errors.push({ index, message: "Only draft questions can be edited in bulk save." });
      continue;
    }

    const { error } = await admin
      .from("practice_questions")
      .update({
        subtopic_id: row.subtopicId ?? null,
        question_text: question.questionText,
        question_type: question.questionType,
        options: question.questionType === "multiple_choice" ? question.options : null,
        correct_answer: question.correctAnswer,
        difficulty: question.difficulty,
        explanation: question.explanation,
      })
      .eq("id", row.id);

    if (error) {
      result.errors.push({ index, message: error.message });
      continue;
    }

    result.updatedIds.push(row.id);
  }

  return result;
}
