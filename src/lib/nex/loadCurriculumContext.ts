import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type { CurriculumContext } from "./types";

function extractBlockText(block: Record<string, unknown>): string {
  if (block.type === "heading" || block.type === "paragraph" || block.type === "tip") {
    return String(block.content ?? "");
  }

  if (block.type === "example") {
    const steps = Array.isArray(block.steps)
      ? block.steps.map((step) => String(step)).join("; ")
      : "";
    return `${String(block.title ?? "")} ${steps}`.trim();
  }

  return "";
}

function extractLessonText(content: unknown): string {
  if (typeof content === "string") {
    return content.slice(0, 2000);
  }

  if (content && typeof content === "object" && "blocks" in content) {
    const blocks = (content as { blocks?: unknown }).blocks;
    if (Array.isArray(blocks)) {
      return blocks
        .map((block) =>
          block && typeof block === "object"
            ? extractBlockText(block as Record<string, unknown>)
            : "",
        )
        .filter(Boolean)
        .join("\n")
        .slice(0, 2000);
    }
  }

  if (Array.isArray(content)) {
    return content
      .map((block) => {
        if (typeof block === "string") {
          return block;
        }
        if (block && typeof block === "object" && "text" in block) {
          return String((block as { text?: string }).text ?? "");
        }
        return "";
      })
      .filter(Boolean)
      .join("\n")
      .slice(0, 2000);
  }

  if (content && typeof content === "object") {
    return JSON.stringify(content).slice(0, 2000);
  }

  return "";
}

export async function loadCurriculumContext(
  topicId?: string | null,
): Promise<CurriculumContext | null> {
  if (!topicId) {
    return null;
  }

  try {
    const supabase = createAdminClient();

    const { data: topic, error: topicError } = await supabase
      .from("topics")
      .select("id, title, description, subjects(code, name)")
      .eq("id", topicId)
      .maybeSingle();

    if (topicError || !topic) {
      return null;
    }

    const subject =
      topic.subjects && typeof topic.subjects === "object" && "code" in topic.subjects
        ? (topic.subjects as { code?: string; name?: string })
        : null;

    const { data: subtopics } = await supabase
      .from("subtopics")
      .select("id, title, description")
      .eq("topic_id", topicId)
      .order("sort_order", { ascending: true })
      .limit(1);

    const subtopic = subtopics?.[0] ?? null;

    let lessonExcerpts = topic.description ?? "";

    if (subtopic) {
      const { data: lessons } = await supabase
        .from("lessons")
        .select("title, content")
        .eq("subtopic_id", subtopic.id)
        .eq("is_active", true)
        .order("sort_order", { ascending: true })
        .limit(2);

      if (lessons?.length) {
        lessonExcerpts = lessons
          .map(
            (lesson) =>
              `${lesson.title}\n${extractLessonText(lesson.content)}`,
          )
          .join("\n\n");
      }
    }

    return {
      subject: subject?.name ?? null,
      subjectCode: subject?.code ?? null,
      topic: topic.title,
      subtopic: subtopic?.title ?? null,
      learningOutcome: subtopic?.description ?? topic.description ?? null,
      lessonExcerpts,
    };
  } catch {
    return null;
  }
}
