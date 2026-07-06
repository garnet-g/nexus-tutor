import "server-only";

import {
  getTopicReadinessLabel,
  isTopicLearnReady,
  isTopicProdReady,
} from "@/lib/curriculum/contentModel";
import { createAdminClient } from "@/lib/supabase/admin";

export type TopicCoverageRow = {
  curriculumCode: string;
  subjectCode: string;
  gradeLevel: string | null;
  topicId: string;
  topicTitle: string;
  publishedLessonCount: number;
  subtopicCount: number;
  subtopicsWithLesson: number;
  questionCounts: { easy: number; medium: number; hard: number };
  readinessLabel: ReturnType<typeof getTopicReadinessLabel>;
};

export async function loadTopicCoverageMatrix(): Promise<TopicCoverageRow[]> {
  const admin = createAdminClient();
  const rows: TopicCoverageRow[] = [];

  const { data: topics, error: topicsError } = await admin
    .from("topics")
    .select("id, title, subject_id, grade_level, is_active")
    .eq("is_active", true);
  if (topicsError) {
    throw new Error(topicsError.message);
  }

  for (const topic of topics ?? []) {
    const { data: subject } = await admin
      .from("subjects")
      .select("code, curriculum_id")
      .eq("id", topic.subject_id)
      .maybeSingle();
    if (!subject) {
      continue;
    }

    const { data: curriculum } = await admin
      .from("curricula")
      .select("code")
      .eq("id", subject.curriculum_id)
      .maybeSingle();
    if (!curriculum) {
      continue;
    }

    const { data: subtopics } = await admin
      .from("subtopics")
      .select("id")
      .eq("topic_id", topic.id)
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
      .eq("topic_id", topic.id)
      .eq("review_status", "published")
      .eq("is_active", true);

    const questionCounts = { easy: 0, medium: 0, hard: 0 };
    for (const question of questions ?? []) {
      const difficulty = question.difficulty as keyof typeof questionCounts;
      if (difficulty in questionCounts) {
        questionCounts[difficulty] += 1;
      }
    }

    const readinessLabel = getTopicReadinessLabel({
      publishedLessonCount,
      subtopicCount,
      subtopicsWithLesson,
      questionCounts,
    });

    rows.push({
      curriculumCode: curriculum.code,
      subjectCode: subject.code,
      gradeLevel: topic.grade_level,
      topicId: topic.id,
      topicTitle: topic.title,
      publishedLessonCount,
      subtopicCount,
      subtopicsWithLesson,
      questionCounts,
      readinessLabel,
    });
  }

  return rows.sort((left, right) =>
    `${left.curriculumCode}:${left.subjectCode}:${left.topicTitle}`.localeCompare(
      `${right.curriculumCode}:${right.subjectCode}:${right.topicTitle}`,
    ),
  );
}

export function findUnderTargetProdReadyTopics(rows: TopicCoverageRow[]): TopicCoverageRow[] {
  return rows.filter((row) => {
    if (row.readinessLabel !== "PROD_READY") {
      return false;
    }
    return !(
      isTopicLearnReady(
        row.publishedLessonCount,
        row.subtopicCount,
        row.subtopicsWithLesson,
      ) && isTopicProdReady(row.questionCounts)
    );
  });
}
