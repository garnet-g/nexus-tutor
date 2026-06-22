import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { Curriculum } from "@/types/database";
import type {
  CurriculumLesson,
  CurriculumSubject,
  CurriculumTopic,
  CurriculumTopicDetail,
  LessonContent,
} from "@/types/curriculum";

import {
  ACTIVE_SUBJECT_CODES,
  isTopicLearnReady,
  isTopicVisibleForGrade,
  TIER1_SUBJECT_CODES,
} from "@/lib/curriculum/contentModel";
import type { ActiveSubjectCode, Tier1SubjectCode } from "@/lib/curriculum/contentModel";

export { ACTIVE_SUBJECT_CODES, isTopicVisibleForGrade, TIER1_SUBJECT_CODES };
export type { ActiveSubjectCode, Tier1SubjectCode };

function parseLessonContent(raw: unknown): LessonContent {
  if (!raw || typeof raw !== "object") {
    return { blocks: [] };
  }

  const content = raw as LessonContent;

  return {
    blocks: Array.isArray(content.blocks) ? content.blocks : [],
    shortQuiz: content.shortQuiz,
  };
}

async function getCurriculumId(curriculum: Curriculum): Promise<string | null> {
  const supabase = await createClient();
  const { data } = await supabase
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .eq("is_active", true)
    .maybeSingle();

  return data?.id ?? null;
}

async function resolveStudentGradeSortOrder(
  curriculum: Curriculum,
  gradeLevel: string,
): Promise<number | null> {
  const normalized = gradeLevel.trim();
  if (!normalized) {
    return null;
  }

  const supabase = await createClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return null;
  }

  const { data: byDisplayName } = await supabase
    .from("grade_levels")
    .select("sort_order")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .eq("display_name", normalized)
    .maybeSingle();

  if (byDisplayName) {
    return byDisplayName.sort_order;
  }

  const normalizedCode = normalized.toLowerCase().replace(/\s+/g, "_");
  const { data: byCode } = await supabase
    .from("grade_levels")
    .select("sort_order")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .eq("code", normalizedCode)
    .maybeSingle();

  return byCode?.sort_order ?? null;
}

export async function getSubjectsForStudent(
  curriculum: Curriculum,
  gradeLevel?: string,
): Promise<CurriculumSubject[]> {
  const supabase = await createClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return [];
  }

  const studentGradeSortOrder = gradeLevel
    ? await resolveStudentGradeSortOrder(curriculum, gradeLevel)
    : null;

  const { data: subjects, error } = await supabase
    .from("subjects")
    .select("id, code, name, curriculum_id")
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .in("code", [...ACTIVE_SUBJECT_CODES])
    .order("name", { ascending: true });

  if (error || !subjects?.length) {
    return [];
  }

  const { data: topics } = await supabase
    .from("topics")
    .select("id, subject_id, min_grade_sort_order")
    .in(
      "subject_id",
      subjects.map((subject) => subject.id),
    )
    .eq("is_active", true);

  const visibleTopicIds = (topics ?? [])
    .filter((topic) =>
      isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder),
    )
    .map((topic) => topic.id);

  const learnReadyCountBySubject = new Map<string, number>();

  if (visibleTopicIds.length) {
    const { data: subtopics } = await supabase
      .from("subtopics")
      .select("id, topic_id")
      .in("topic_id", visibleTopicIds)
      .eq("is_active", true);

    const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
    const { data: lessons } = subtopicIds.length
      ? await supabase
          .from("lessons")
          .select("subtopic_id")
          .in("subtopic_id", subtopicIds)
          .eq("is_active", true)
          .eq("review_status", "published")
      : { data: [] };

    const subtopicsByTopic = new Map<string, string[]>();
    for (const subtopic of subtopics ?? []) {
      const list = subtopicsByTopic.get(subtopic.topic_id) ?? [];
      list.push(subtopic.id);
      subtopicsByTopic.set(subtopic.topic_id, list);
    }

    const publishedLessonsBySubtopic = new Map<string, number>();
    for (const lesson of lessons ?? []) {
      publishedLessonsBySubtopic.set(
        lesson.subtopic_id,
        (publishedLessonsBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
      );
    }

    for (const topic of topics ?? []) {
      if (
        !isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder)
      ) {
        continue;
      }

      const topicSubtopicIds = subtopicsByTopic.get(topic.id) ?? [];
      const publishedLessonCount = topicSubtopicIds.reduce(
        (total, subtopicId) => total + (publishedLessonsBySubtopic.get(subtopicId) ?? 0),
        0,
      );
      const subtopicsWithLesson = topicSubtopicIds.filter(
        (subtopicId) => (publishedLessonsBySubtopic.get(subtopicId) ?? 0) > 0,
      ).length;

      if (
        !isTopicLearnReady(
          publishedLessonCount,
          topicSubtopicIds.length,
          subtopicsWithLesson,
        )
      ) {
        continue;
      }

      learnReadyCountBySubject.set(
        topic.subject_id,
        (learnReadyCountBySubject.get(topic.subject_id) ?? 0) + 1,
      );
    }
  }

  return subjects
    .map((subject) => ({
      id: subject.id,
      code: subject.code,
      name: subject.name,
      curriculumCode: curriculum,
      topicCount: learnReadyCountBySubject.get(subject.id) ?? 0,
    }))
    .filter((subject) => subject.topicCount > 0);
}

export async function getTopics(
  subjectId: string,
  curriculum: Curriculum,
  gradeLevel?: string,
): Promise<CurriculumTopic[]> {
  const supabase = await createClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return [];
  }

  const studentGradeSortOrder = gradeLevel
    ? await resolveStudentGradeSortOrder(curriculum, gradeLevel)
    : null;

  const { data: subject } = await supabase
    .from("subjects")
    .select("id")
    .eq("id", subjectId)
    .eq("curriculum_id", curriculumId)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject) {
    return [];
  }

  const { data: topics, error } = await supabase
    .from("topics")
    .select("id, code, title, description, sort_order, subject_id, min_grade_sort_order")
    .eq("subject_id", subjectId)
    .eq("is_active", true)
    .order("sort_order", { ascending: true });

  if (error || !topics?.length) {
    return [];
  }

  const visibleTopics = topics.filter((topic) =>
    isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder),
  );

  if (!visibleTopics.length) {
    return [];
  }

  const topicIds = visibleTopics.map((topic) => topic.id);
  const { data: subtopics } = await supabase
    .from("subtopics")
    .select("id, topic_id")
    .in("topic_id", topicIds)
    .eq("is_active", true);

  const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
  const { data: lessons } = subtopicIds.length
    ? await supabase
        .from("lessons")
        .select("id, subtopic_id")
        .in("subtopic_id", subtopicIds)
        .eq("is_active", true)
        .eq("review_status", "published")
    : { data: [] };

  const subtopicsByTopic = new Map<string, string[]>();
  for (const subtopic of subtopics ?? []) {
    const list = subtopicsByTopic.get(subtopic.topic_id) ?? [];
    list.push(subtopic.id);
    subtopicsByTopic.set(subtopic.topic_id, list);
  }

  const lessonCountBySubtopic = new Map<string, number>();
  for (const lesson of lessons ?? []) {
    lessonCountBySubtopic.set(
      lesson.subtopic_id,
      (lessonCountBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
    );
  }

  return visibleTopics
    .filter((topic) => {
      const topicSubtopicIds = subtopicsByTopic.get(topic.id) ?? [];
      const publishedLessonCount = topicSubtopicIds.reduce(
        (total, subtopicId) => total + (lessonCountBySubtopic.get(subtopicId) ?? 0),
        0,
      );
      const subtopicsWithLesson = topicSubtopicIds.filter(
        (subtopicId) => (lessonCountBySubtopic.get(subtopicId) ?? 0) > 0,
      ).length;

      return isTopicLearnReady(
        publishedLessonCount,
        topicSubtopicIds.length,
        subtopicsWithLesson,
      );
    })
    .map((topic) => {
      const topicSubtopicIds = subtopicsByTopic.get(topic.id) ?? [];
      const lessonCount = topicSubtopicIds.reduce(
        (total, subtopicId) => total + (lessonCountBySubtopic.get(subtopicId) ?? 0),
        0,
      );

      return {
        id: topic.id,
        code: topic.code,
        title: topic.title,
        description: topic.description,
        sortOrder: topic.sort_order,
        subjectId: topic.subject_id,
        lessonCount,
      };
    });
}

async function isTopicLearnReadyForStudent(
  topicId: string,
  studentGradeSortOrder: number | null,
): Promise<boolean> {
  const supabase = await createClient();
  const { data: topic } = await supabase
    .from("topics")
    .select("id, min_grade_sort_order")
    .eq("id", topicId)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    return false;
  }

  if (!isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder)) {
    return false;
  }

  const { data: subtopics } = await supabase
    .from("subtopics")
    .select("id")
    .eq("topic_id", topicId)
    .eq("is_active", true);

  const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
  if (!subtopicIds.length) {
    return false;
  }

  const { data: lessons } = await supabase
    .from("lessons")
    .select("subtopic_id")
    .in("subtopic_id", subtopicIds)
    .eq("is_active", true)
    .eq("review_status", "published");

  const publishedLessonsBySubtopic = new Map<string, number>();
  for (const lesson of lessons ?? []) {
    publishedLessonsBySubtopic.set(
      lesson.subtopic_id,
      (publishedLessonsBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
    );
  }

  const publishedLessonCount = subtopicIds.reduce(
    (total, subtopicId) => total + (publishedLessonsBySubtopic.get(subtopicId) ?? 0),
    0,
  );
  const subtopicsWithLesson = subtopicIds.filter(
    (subtopicId) => (publishedLessonsBySubtopic.get(subtopicId) ?? 0) > 0,
  ).length;

  return isTopicLearnReady(publishedLessonCount, subtopicIds.length, subtopicsWithLesson);
}

export async function getTopicDetail(
  topicId: string,
  curriculum: Curriculum,
  gradeLevel?: string,
): Promise<CurriculumTopicDetail | null> {
  const supabase = await createClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return null;
  }

  const studentGradeSortOrder = gradeLevel
    ? await resolveStudentGradeSortOrder(curriculum, gradeLevel)
    : null;

  const { data: topic } = await supabase
    .from("topics")
    .select("id, code, title, description, sort_order, subject_id, min_grade_sort_order")
    .eq("id", topicId)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    return null;
  }

  if (
    !isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder)
  ) {
    return null;
  }

  if (!(await isTopicLearnReadyForStudent(topicId, studentGradeSortOrder))) {
    return null;
  }

  const { data: subject } = await supabase
    .from("subjects")
    .select("id, code, name, curriculum_id")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject || subject.curriculum_id !== curriculumId) {
    return null;
  }

  const { data: subtopics } = await supabase
    .from("subtopics")
    .select("id, code, title, description, sort_order")
    .eq("topic_id", topicId)
    .eq("is_active", true)
    .order("sort_order", { ascending: true });

  const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
  const { data: lessons } = subtopicIds.length
    ? await supabase
        .from("lessons")
        .select("id, title, estimated_minutes, sort_order, subtopic_id")
        .in("subtopic_id", subtopicIds)
        .eq("is_active", true)
        .eq("review_status", "published")
        .order("sort_order", { ascending: true })
    : { data: [] };

  const lessonsBySubtopic = new Map<
    string,
    {
      id: string;
      title: string;
      estimated_minutes: number;
      sort_order: number;
    }[]
  >();

  for (const lesson of lessons ?? []) {
    const list = lessonsBySubtopic.get(lesson.subtopic_id) ?? [];
    list.push(lesson);
    lessonsBySubtopic.set(lesson.subtopic_id, list);
  }

  const subtopicDetails = (subtopics ?? []).map((subtopic) => ({
    id: subtopic.id,
    code: subtopic.code,
    title: subtopic.title,
    description: subtopic.description,
    sortOrder: subtopic.sort_order,
    lessons: (lessonsBySubtopic.get(subtopic.id) ?? []).map((lesson) => ({
      id: lesson.id,
      title: lesson.title,
      estimatedMinutes: lesson.estimated_minutes,
      sortOrder: lesson.sort_order,
    })),
  }));

  const lessonCount = subtopicDetails.reduce(
    (total, subtopic) => total + subtopic.lessons.length,
    0,
  );

  return {
    id: topic.id,
    code: topic.code,
    title: topic.title,
    description: topic.description,
    sortOrder: topic.sort_order,
    subjectId: topic.subject_id,
    subjectCode: subject.code,
    subjectName: subject.name,
    lessonCount,
    subtopics: subtopicDetails,
  };
}

export async function getLesson(
  lessonId: string,
  curriculum: Curriculum,
  gradeLevel?: string,
): Promise<CurriculumLesson | null> {
  const supabase = await createClient();
  const curriculumId = await getCurriculumId(curriculum);

  if (!curriculumId) {
    return null;
  }

  const { data: lesson } = await supabase
    .from("lessons")
    .select("id, title, content, estimated_minutes, sort_order, subtopic_id")
    .eq("id", lessonId)
    .eq("is_active", true)
    .maybeSingle();

  if (!lesson) {
    return null;
  }

  const { data: subtopic } = await supabase
    .from("subtopics")
    .select("id, title, topic_id")
    .eq("id", lesson.subtopic_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subtopic) {
    return null;
  }

  const { data: topic } = await supabase
    .from("topics")
    .select("id, title, subject_id, min_grade_sort_order")
    .eq("id", subtopic.topic_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!topic) {
    return null;
  }

  const studentGradeSortOrder = gradeLevel
    ? await resolveStudentGradeSortOrder(curriculum, gradeLevel)
    : null;

  if (
    !isTopicVisibleForGrade(topic.min_grade_sort_order ?? 1, studentGradeSortOrder)
  ) {
    return null;
  }

  if (!(await isTopicLearnReadyForStudent(topic.id, studentGradeSortOrder))) {
    return null;
  }

  const { data: subject } = await supabase
    .from("subjects")
    .select("id, curriculum_id")
    .eq("id", topic.subject_id)
    .eq("is_active", true)
    .maybeSingle();

  if (!subject || subject.curriculum_id !== curriculumId) {
    return null;
  }

  const { data: curriculumRow } = await supabase
    .from("curricula")
    .select("code")
    .eq("id", subject.curriculum_id)
    .maybeSingle();

  if (!curriculumRow || curriculumRow.code !== curriculum) {
    return null;
  }

  return {
    id: lesson.id,
    title: lesson.title,
    content: parseLessonContent(lesson.content),
    estimatedMinutes: lesson.estimated_minutes,
    sortOrder: lesson.sort_order,
    subtopicId: subtopic.id,
    subtopicTitle: subtopic.title,
    topicId: topic.id,
    topicTitle: topic.title,
    subjectId: subject.id,
    curriculumCode: curriculumRow.code,
  };
}
