import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type { Curriculum } from "@/types/database";
import type {
  ContentCoverageCurriculum,
  ContentCoverageSubtopic,
  ContentCoverageTopic,
  ContentDraftQueueItem,
} from "@/types/contentAdmin";
import {
  GRADE_LEVELS_BY_CURRICULUM,
  QUESTION_COVERAGE_TARGET,
} from "@/types/contentAdmin";

const MATHEMATICS_SUBJECT_CODE = "mathematics";

export {
  GRADE_LEVELS_BY_CURRICULUM,
  QUESTION_COVERAGE_TARGET,
} from "@/types/contentAdmin";

export type {
  ContentCoverageCurriculum,
  ContentCoverageSubtopic,
  ContentCoverageTopic,
  ContentDraftQueueItem,
  DraftLessonQueueItem,
  DraftQuestionQueueItem,
} from "@/types/contentAdmin";

function emptyQuestionCounts() {
  return { easy: 0, medium: 0, hard: 0 };
}

export async function getMathematicsContentCoverage(): Promise<
  ContentCoverageCurriculum[]
> {
  const admin = createAdminClient();
  const curricula: Curriculum[] = ["CBC", "KCSE"];
  const result: ContentCoverageCurriculum[] = [];

  for (const curriculumCode of curricula) {
    const { data: curriculum } = await admin
      .from("curricula")
      .select("id")
      .eq("code", curriculumCode)
      .eq("is_active", true)
      .maybeSingle();

    if (!curriculum) {
      continue;
    }

    const { data: subject } = await admin
      .from("subjects")
      .select("id")
      .eq("curriculum_id", curriculum.id)
      .eq("code", MATHEMATICS_SUBJECT_CODE)
      .eq("is_active", true)
      .maybeSingle();

    if (!subject) {
      continue;
    }

    const { data: topics } = await admin
      .from("topics")
      .select("id, code, title, sort_order")
      .eq("subject_id", subject.id)
      .eq("is_active", true)
      .order("sort_order", { ascending: true });

    if (!topics?.length) {
      result.push({
        code: curriculumCode,
        gradeLevels: [...GRADE_LEVELS_BY_CURRICULUM[curriculumCode]],
        topics: [],
      });
      continue;
    }

    const topicIds = topics.map((topic) => topic.id);
    const { data: subtopics } = await admin
      .from("subtopics")
      .select("id, code, title, sort_order, topic_id")
      .in("topic_id", topicIds)
      .eq("is_active", true)
      .order("sort_order", { ascending: true });

    const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
    const { data: lessons } = subtopicIds.length
      ? await admin
          .from("lessons")
          .select("subtopic_id, review_status, is_active")
          .in("subtopic_id", subtopicIds)
      : { data: [] };

    const publishedBySubtopic = new Map<string, number>();
    const draftBySubtopic = new Map<string, number>();

    for (const lesson of lessons ?? []) {
      if (lesson.review_status === "draft") {
        draftBySubtopic.set(
          lesson.subtopic_id,
          (draftBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
        );
        continue;
      }

      if (lesson.review_status === "published" && lesson.is_active) {
        publishedBySubtopic.set(
          lesson.subtopic_id,
          (publishedBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
        );
      }
    }

    const { data: questions } = await admin
      .from("practice_questions")
      .select("topic_id, difficulty")
      .in("topic_id", topicIds)
      .eq("review_status", "published")
      .eq("is_active", true);

    const questionsByTopic = new Map<
      string,
      { easy: number; medium: number; hard: number }
    >();

    for (const question of questions ?? []) {
      const counts = questionsByTopic.get(question.topic_id) ?? emptyQuestionCounts();
      if (question.difficulty === "easy") {
        counts.easy += 1;
      } else if (question.difficulty === "medium") {
        counts.medium += 1;
      } else if (question.difficulty === "hard") {
        counts.hard += 1;
      }
      questionsByTopic.set(question.topic_id, counts);
    }

    const subtopicsByTopic = new Map<string, ContentCoverageSubtopic[]>();
    for (const subtopic of subtopics ?? []) {
      const entry: ContentCoverageSubtopic = {
        id: subtopic.id,
        code: subtopic.code,
        title: subtopic.title,
        publishedLessonCount: publishedBySubtopic.get(subtopic.id) ?? 0,
        draftLessonCount: draftBySubtopic.get(subtopic.id) ?? 0,
      };
      const list = subtopicsByTopic.get(subtopic.topic_id) ?? [];
      list.push(entry);
      subtopicsByTopic.set(subtopic.topic_id, list);
    }

    const coverageTopics: ContentCoverageTopic[] = topics.map((topic) => {
      const subtopicRows = subtopicsByTopic.get(topic.id) ?? [];
      const publishedLessonCount = subtopicRows.reduce(
        (total, subtopic) => total + subtopic.publishedLessonCount,
        0,
      );
      const draftLessonCount = subtopicRows.reduce(
        (total, subtopic) => total + subtopic.draftLessonCount,
        0,
      );

      return {
        id: topic.id,
        code: topic.code,
        title: topic.title,
        publishedLessonCount,
        draftLessonCount,
        questionCounts: questionsByTopic.get(topic.id) ?? emptyQuestionCounts(),
        subtopics: subtopicRows,
      };
    });

    result.push({
      code: curriculumCode,
      gradeLevels: [...GRADE_LEVELS_BY_CURRICULUM[curriculumCode]],
      topics: coverageTopics,
    });
  }

  return result;
}

export async function getContentDraftQueue(): Promise<ContentDraftQueueItem[]> {
  const admin = createAdminClient();
  const items: ContentDraftQueueItem[] = [];

  const { data: draftLessons } = await admin
    .from("lessons")
    .select("id, title, estimated_minutes, updated_at, generated_model, subtopic_id")
    .eq("review_status", "draft")
    .order("updated_at", { ascending: false });

  for (const lesson of draftLessons ?? []) {
    const { data: subtopic } = await admin
      .from("subtopics")
      .select("id, title, topic_id")
      .eq("id", lesson.subtopic_id)
      .maybeSingle();

    if (!subtopic) {
      continue;
    }

    const { data: topic } = await admin
      .from("topics")
      .select("id, title, subject_id")
      .eq("id", subtopic.topic_id)
      .maybeSingle();

    if (!topic) {
      continue;
    }

    const { data: subject } = await admin
      .from("subjects")
      .select("curriculum_id")
      .eq("id", topic.subject_id)
      .maybeSingle();

    if (!subject) {
      continue;
    }

    const { data: curriculumRow } = await admin
      .from("curricula")
      .select("code")
      .eq("id", subject.curriculum_id)
      .maybeSingle();

    if (!curriculumRow) {
      continue;
    }

    items.push({
      kind: "lesson",
      id: lesson.id,
      title: lesson.title,
      estimatedMinutes: lesson.estimated_minutes,
      curriculumCode: curriculumRow.code as Curriculum,
      topicId: topic.id,
      topicTitle: topic.title,
      subtopicId: subtopic.id,
      subtopicTitle: subtopic.title,
      generatedModel: lesson.generated_model,
      updatedAt: lesson.updated_at,
    });
  }

  const { data: draftQuestions } = await admin
    .from("practice_questions")
    .select(
      "id, question_text, question_type, options, correct_answer, difficulty, explanation, generated_model, topic_id, subtopic_id",
    )
    .eq("review_status", "draft")
    .order("question_text", { ascending: true });

  for (const question of draftQuestions ?? []) {
    const { data: topic } = await admin
      .from("topics")
      .select("id, title, subject_id")
      .eq("id", question.topic_id)
      .maybeSingle();

    if (!topic) {
      continue;
    }

    const { data: subject } = await admin
      .from("subjects")
      .select("curriculum_id")
      .eq("id", topic.subject_id)
      .maybeSingle();

    if (!subject) {
      continue;
    }

    const { data: curriculumRow } = await admin
      .from("curricula")
      .select("code")
      .eq("id", subject.curriculum_id)
      .maybeSingle();

    if (!curriculumRow) {
      continue;
    }

    let subtopicTitle: string | null = null;
    if (question.subtopic_id) {
      const { data: subtopic } = await admin
        .from("subtopics")
        .select("id, title")
        .eq("id", question.subtopic_id)
        .maybeSingle();
      subtopicTitle = subtopic?.title ?? null;
    }

    const options = Array.isArray(question.options)
      ? (question.options as string[])
      : null;
    const correctAnswer =
      typeof question.correct_answer === "string"
        ? question.correct_answer
        : String(question.correct_answer ?? "");

    items.push({
      kind: "question",
      id: question.id,
      questionText: question.question_text,
      questionType: question.question_type as "multiple_choice" | "short_answer",
      options,
      correctAnswer,
      difficulty: question.difficulty as "easy" | "medium" | "hard",
      explanation: question.explanation,
      curriculumCode: curriculumRow.code as Curriculum,
      topicId: topic.id,
      topicTitle: topic.title,
      subtopicId: question.subtopic_id,
      subtopicTitle,
      generatedModel: question.generated_model,
    });
  }

  return items.sort((left, right) => {
    if (left.kind !== right.kind) {
      return left.kind === "lesson" ? -1 : 1;
    }

    if (left.kind === "lesson" && right.kind === "lesson") {
      return right.updatedAt.localeCompare(left.updatedAt);
    }

    if (left.kind === "question" && right.kind === "question") {
      return left.questionText.localeCompare(right.questionText);
    }

    return 0;
  });
}

export function getQuestionCoverageLabel(count: number): string {
  return `${count}/${QUESTION_COVERAGE_TARGET}`;
}
