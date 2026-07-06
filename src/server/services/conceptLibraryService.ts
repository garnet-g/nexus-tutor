import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { StudentProfile } from "@/types/database";

export type ConceptReferenceHit = {
  id: string;
  title: string;
  summary: string | null;
  body: string;
  category: string;
  topicId: string | null;
  topicTitle: string | null;
  lessonHref: string | null;
  source: "published" | "lesson_block";
};

type LessonBlock = {
  type?: string;
  content?: string;
  latex?: string;
  caption?: string;
  variant?: string;
  title?: string;
};

function extractLessonReferences(
  lesson: {
    id: string;
    title: string;
    content: unknown;
    subtopic_id: string;
  },
  topicId: string,
  topicTitle: string,
): ConceptReferenceHit[] {
  const content = lesson.content as { blocks?: LessonBlock[] } | null;
  const blocks = content?.blocks ?? [];
  const hits: ConceptReferenceHit[] = [];

  for (const block of blocks) {
    if (block.type === "math_block" && block.latex) {
      hits.push({
        id: `lesson-${lesson.id}-math-${hits.length}`,
        title: block.caption ?? lesson.title,
        summary: "Formula from lesson",
        body: block.latex,
        category: "formula",
        topicId,
        topicTitle,
        lessonHref: `/learn/${topicId}/${lesson.id}`,
        source: "lesson_block",
      });
    }

    if (block.type === "callout" && block.variant === "key_point" && block.content) {
      hits.push({
        id: `lesson-${lesson.id}-callout-${hits.length}`,
        title: lesson.title,
        summary: "Key point",
        body: block.content,
        category: "definition",
        topicId,
        topicTitle,
        lessonHref: `/learn/${topicId}/${lesson.id}`,
        source: "lesson_block",
      });
    }
  }

  return hits;
}

async function getVisibleTopicIds(profile: StudentProfile): Promise<Map<string, string>> {
  const admin = createAdminClient();
  const topicTitles = new Map<string, string>();

  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("id")
    .eq("code", profile.curriculum)
    .maybeSingle();

  if (!curriculumRow?.id) {
    return topicTitles;
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
    .select("id, title, subjects!inner(curriculum_id)")
    .eq("subjects.curriculum_id", curriculumRow.id)
    .lte("min_grade_sort_order", gradeSortOrder);

  for (const topic of topics ?? []) {
    topicTitles.set(String(topic.id), String(topic.title));
  }

  return topicTitles;
}

export async function listConceptReferences(
  profile: StudentProfile,
  query = "",
  limit = 40,
): Promise<ConceptReferenceHit[]> {
  const topicTitles = await getVisibleTopicIds(profile);
  const topicIds = [...topicTitles.keys()];

  if (topicIds.length === 0) {
    return [];
  }

  const admin = createAdminClient();
  const sanitized = query.trim().replace(/[^\p{L}\p{N}\s]/gu, " ").replace(/\s+/g, " ");

  let publishedQuery = admin
    .from("concept_references")
    .select("id, title, summary, body, category, topic_id, source_lesson_id, topics(title)")
    .eq("review_status", "published")
    .eq("is_active", true)
    .in("topic_id", topicIds)
    .order("sort_order", { ascending: true })
    .limit(limit);

  if (sanitized.length >= 2) {
    publishedQuery = publishedQuery.or(
      `title.ilike.%${sanitized}%,summary.ilike.%${sanitized}%,body.ilike.%${sanitized}%`,
    );
  }

  const { data: publishedRows } = await publishedQuery;

  const publishedHits: ConceptReferenceHit[] = (publishedRows ?? []).map((row) => {
    const topic = unwrapSupabaseRelation(
      row.topics as { title?: string } | Array<{ title?: string }> | null,
    );
    const topicId = row.topic_id ? String(row.topic_id) : null;
    return {
      id: String(row.id),
      title: String(row.title),
      summary: (row.summary as string | null) ?? null,
      body: String(row.body),
      category: String(row.category),
      topicId,
      topicTitle: topic?.title ?? (topicId ? topicTitles.get(topicId) ?? null : null),
      lessonHref:
        row.source_lesson_id && topicId
          ? `/learn/${topicId}/${row.source_lesson_id}`
          : topicId
            ? `/learn/${topicId}`
            : null,
      source: "published",
    };
  });

  if (publishedHits.length >= limit) {
    return publishedHits.slice(0, limit);
  }

  const { data: subtopics } = await admin
    .from("subtopics")
    .select("id, topic_id")
    .in("topic_id", topicIds);

  const subtopicIds = (subtopics ?? []).map((row) => String(row.id));
  if (subtopicIds.length === 0) {
    return publishedHits;
  }

  const subtopicTopic = new Map(
    (subtopics ?? []).map((row) => [String(row.id), String(row.topic_id)]),
  );

  let lessonQuery = admin
    .from("lessons")
    .select("id, title, content, subtopic_id")
    .in("subtopic_id", subtopicIds)
    .eq("review_status", "published")
    .eq("is_active", true)
    .order("sort_order", { ascending: true })
    .limit(30);

  if (sanitized.length >= 2) {
    lessonQuery = lessonQuery.ilike("title", `%${sanitized}%`);
  }

  const { data: lessons } = await lessonQuery;
  const derivedHits: ConceptReferenceHit[] = [];

  for (const lesson of lessons ?? []) {
    const topicId = subtopicTopic.get(String(lesson.subtopic_id));
    if (!topicId) continue;

    derivedHits.push(
      ...extractLessonReferences(
        {
          id: String(lesson.id),
          title: String(lesson.title),
          content: lesson.content,
          subtopic_id: String(lesson.subtopic_id),
        },
        topicId,
        topicTitles.get(topicId) ?? "Topic",
      ),
    );
  }

  const merged = [...publishedHits];
  const seen = new Set(publishedHits.map((hit) => `${hit.title}:${hit.body}`));

  for (const hit of derivedHits) {
    const key = `${hit.title}:${hit.body}`;
    if (seen.has(key)) continue;
    seen.add(key);
    merged.push(hit);
    if (merged.length >= limit) break;
  }

  return merged.slice(0, limit);
}

export async function publishConceptFromLessonBlock(input: {
  lessonId: string;
  blockIndex: number;
  category?: "formula" | "definition" | "theorem" | "example" | "tip";
  authorId?: string | null;
}) {
  const admin = createAdminClient();
  const { data: lesson, error } = await admin
    .from("lessons")
    .select("id, title, content, subtopic_id, subtopics(topic_id)")
    .eq("id", input.lessonId)
    .maybeSingle();

  if (error || !lesson) {
    throw new Error(error?.message ?? "Lesson not found.");
  }

  const content = lesson.content as { blocks?: LessonBlock[] } | null;
  const block = content?.blocks?.[input.blockIndex];
  if (!block) {
    throw new Error("Lesson block not found.");
  }

  const subtopic = unwrapSupabaseRelation(
    lesson.subtopics as { topic_id?: string } | Array<{ topic_id?: string }> | null,
  );
  const topicId = subtopic?.topic_id ? String(subtopic.topic_id) : null;

  let title = lesson.title as string;
  let body = "";
  let category = input.category ?? "definition";

  if (block.type === "math_block" && block.latex) {
    title = block.caption ?? title;
    body = block.latex;
    category = "formula";
  } else if (block.type === "callout" && block.content) {
    body = block.content;
    category = block.variant === "key_point" ? "definition" : "tip";
  } else if (block.type === "heading" && block.content) {
    body = block.content;
    category = "definition";
  } else if (block.type === "paragraph" && block.content) {
    body = block.content;
    category = "definition";
  } else {
    throw new Error("Block type cannot be published as a concept reference.");
  }

  const { data, error: insertError } = await admin
    .from("concept_references")
    .insert({
      topic_id: topicId,
      subtopic_id: lesson.subtopic_id,
      source_lesson_id: lesson.id,
      title,
      summary: `From lesson: ${lesson.title}`,
      body,
      category,
      review_status: "published",
      is_active: true,
      author_id: input.authorId ?? null,
    })
    .select("*")
    .single();

  if (insertError || !data) {
    throw new Error(insertError?.message ?? "Could not publish concept reference.");
  }

  return data;
}
