import type { GeneratedLesson, GeneratedQuestion } from "@/schemas/contentGenerationSchemas";
import type { LessonContentBlock } from "@/types/curriculum";
import type { Curriculum } from "@/types/database";

import type { AdminApiResponse } from "@/features/admin/studio/lib/studioApi";

type AssistApiError = { code: string; message: string };

async function parseAssistResponse<T>(response: Response): Promise<T & { model: string }> {
  const payload = (await response.json()) as AdminApiResponse<T & { model: string }> & {
    error?: AssistApiError;
  };

  if (!response.ok || !payload.success) {
    throw new Error(payload.error?.message ?? "Assist request failed.");
  }

  return payload.data;
}

export async function assistDraftLesson(input: {
  subtopicId: string;
  curriculum: Curriculum;
  gradeLevel: string;
}): Promise<GeneratedLesson & { model: string }> {
  const response = await fetch("/api/admin/content/assist", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ action: "draft_lesson", ...input }),
  });
  return parseAssistResponse<GeneratedLesson>(response);
}

export async function assistExpandSection(input: {
  subtopicId: string;
  curriculum: Curriculum;
  gradeLevel: string;
  blockId: string;
  blocks: LessonContentBlock[];
}): Promise<{ blocks: LessonContentBlock[]; model: string }> {
  const response = await fetch("/api/admin/content/assist", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ action: "expand_section", ...input }),
  });
  return parseAssistResponse<{ blocks: LessonContentBlock[] }>(response);
}

export async function assistSimplifyLesson(input: {
  subtopicId: string;
  curriculum: Curriculum;
  targetGradeLevel: string;
  blocks: LessonContentBlock[];
}): Promise<{ blocks: LessonContentBlock[]; model: string }> {
  const response = await fetch("/api/admin/content/assist", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ action: "simplify", ...input }),
  });
  return parseAssistResponse<{ blocks: LessonContentBlock[] }>(response);
}

export async function assistRewriteBlock(input: {
  subtopicId: string;
  curriculum: Curriculum;
  gradeLevel: string;
  block: LessonContentBlock;
  instruction?: string;
}): Promise<{ block: LessonContentBlock; model: string }> {
  const response = await fetch("/api/admin/content/assist", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ action: "rewrite_block", ...input }),
  });
  return parseAssistResponse<{ block: LessonContentBlock }>(response);
}

export async function assistGenerateQuestions(input: {
  topicId: string;
  subtopicId?: string;
  curriculum: Curriculum;
  gradeLevel: string;
  difficulty: "easy" | "medium" | "hard";
  count: number;
}): Promise<{ questions: GeneratedQuestion[]; model: string }> {
  const response = await fetch("/api/admin/content/assist", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({ action: "generate_questions", ...input }),
  });
  return parseAssistResponse<{ questions: GeneratedQuestion[] }>(response);
}
