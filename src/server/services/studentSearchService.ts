import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { StudentProfile } from "@/types/database";

export type StudySearchHit = {
  id: string;
  kind: "lesson" | "question";
  title: string;
  excerpt: string;
  href: string;
  topicTitle: string | null;
};

function sanitizeQuery(query: string): string {
  return query.trim().replace(/[^\p{L}\p{N}\s]/gu, " ").replace(/\s+/g, " ").slice(0, 120);
}

export async function searchStudentContent(
  profile: StudentProfile,
  rawQuery: string,
  limit = 20,
): Promise<StudySearchHit[]> {
  const query = sanitizeQuery(rawQuery);
  if (query.length < 2) {
    return [];
  }

  const admin = createAdminClient();
  const tsQuery = query.split(" ").filter(Boolean).join(" & ");

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("id")
    .eq("code", profile.curriculum)
    .maybeSingle();

  if (!curriculumRow?.id) {
    return [];
  }

  const { data: gradeRow } = await admin
    .from("grade_levels")
    .select("sort_order")
    .eq("curriculum_id", curriculumRow.id)
    .eq("code", profile.grade_level)
    .maybeSingle();

  const gradeSortOrder = gradeRow?.sort_order ?? 0;

  const { data: topics } = await admin
    .from("topics")
    .select("id, title, min_grade_sort_order, subjects!inner(curriculum_id)")
    .eq("subjects.curriculum_id", curriculumRow.id)
    .lte("min_grade_sort_order", gradeSortOrder);

  const topicIds = (topics ?? []).map((topic) => String(topic.id));
  if (topicIds.length === 0) {
    return [];
  }

  const { data: subtopics } = await admin
    .from("subtopics")
    .select("id, topic_id, topics(title)")
    .in("topic_id", topicIds);

  const subtopicIds = (subtopics ?? []).map((row) => String(row.id));
  if (subtopicIds.length === 0) {
    return [];
  }

  const subtopicTopicTitle = new Map<string, string | null>();
  for (const row of subtopics ?? []) {
    const topic = unwrapSupabaseRelation(
      row.topics as { title?: string } | Array<{ title?: string }> | null,
    );
    subtopicTopicTitle.set(String(row.id), topic?.title ?? null);
    subtopicTopicTitle.set(String(row.topic_id), topic?.title ?? null);
  }

  const [lessonResult, questionResult] = await Promise.all([
    admin
      .from("lessons")
      .select("id, title, subtopic_id, subtopics(topic_id)")
      .in("subtopic_id", subtopicIds)
      .eq("review_status", "published")
      .eq("is_active", true)
      .textSearch("search_vector", tsQuery)
      .limit(limit),
    admin
      .from("practice_questions")
      .select("id, question_text, subtopic_id, subtopics(topic_id)")
      .in("subtopic_id", subtopicIds)
      .eq("review_status", "published")
      .eq("is_active", true)
      .textSearch("search_vector", tsQuery)
      .limit(limit),
  ]);

  const hits: StudySearchHit[] = [];

  for (const lesson of lessonResult.data ?? []) {
    const subtopic = unwrapSupabaseRelation(
      lesson.subtopics as { topic_id?: string } | Array<{ topic_id?: string }> | null,
    );
    const topicId = subtopic?.topic_id ? String(subtopic.topic_id) : null;
    if (!topicId) continue;

    hits.push({
      id: String(lesson.id),
      kind: "lesson",
      title: String(lesson.title),
      excerpt: "Published lesson",
      href: `/learn/${topicId}/${lesson.id}`,
      topicTitle: subtopicTopicTitle.get(String(lesson.subtopic_id)) ?? null,
    });
  }

  for (const question of questionResult.data ?? []) {
    const subtopic = unwrapSupabaseRelation(
      question.subtopics as { topic_id?: string } | Array<{ topic_id?: string }> | null,
    );
    const topicId = subtopic?.topic_id ? String(subtopic.topic_id) : null;
    if (!topicId) continue;

    hits.push({
      id: String(question.id),
      kind: "question",
      title: String(question.question_text).slice(0, 160),
      excerpt: "Practice question",
      href: `/practice?topicId=${topicId}`,
      topicTitle: subtopicTopicTitle.get(String(question.subtopic_id)) ?? null,
    });
  }

  return hits.slice(0, limit);
}
