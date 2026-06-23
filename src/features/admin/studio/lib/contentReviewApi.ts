import type { ContentReviewQueueItem } from "@/types/contentAdmin";
import type { LessonContent } from "@/types/curriculum";

import type { AdminApiResponse } from "@/features/admin/studio/lib/studioApi";

export type ReviewActionResult = {
  id: string;
  kind: "lesson" | "question";
  reviewStatus: string;
  isActive: boolean;
  autoPublished?: boolean;
};

export type LessonVersionSummary = {
  id: string;
  versionNumber: number;
  title: string;
  estimatedMinutes: number;
  publishedBy: string | null;
  createdAt: string;
};

type ReviewApiError = {
  code: string;
  message: string;
  gateErrors?: string[];
};

async function parseReviewResponse<T>(response: Response): Promise<T> {
  const payload = (await response.json()) as AdminApiResponse<T> & {
    error?: ReviewApiError;
  };

  if (!response.ok || !payload.success) {
    const gateMessage =
      payload.error?.gateErrors?.length ? `\n${payload.error.gateErrors.join("\n")}` : "";
    throw new Error(`${payload.error?.message ?? "Request failed."}${gateMessage}`);
  }

  return payload.data;
}

export async function fetchReviewQueue(): Promise<ContentReviewQueueItem[]> {
  const response = await fetch("/api/admin/content/review/queue");
  return parseReviewResponse<ContentReviewQueueItem[]>(response);
}

export async function submitContentForReview(input: {
  kind: "lesson" | "question";
  id: string;
}): Promise<ReviewActionResult> {
  const response = await fetch("/api/admin/content/review/submit", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  return parseReviewResponse<ReviewActionResult>(response);
}

export async function approveReviewItem(input: {
  kind: "lesson" | "question";
  id: string;
}): Promise<ReviewActionResult> {
  const response = await fetch("/api/admin/content/review/approve", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  return parseReviewResponse<ReviewActionResult>(response);
}

export async function requestReviewChanges(input: {
  kind: "lesson" | "question";
  id: string;
  notes?: string;
}): Promise<ReviewActionResult> {
  const response = await fetch("/api/admin/content/review/request-changes", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  return parseReviewResponse<ReviewActionResult>(response);
}

export async function archiveReviewItem(input: {
  kind: "lesson" | "question";
  id: string;
}): Promise<ReviewActionResult> {
  const response = await fetch("/api/admin/content/review/archive", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  return parseReviewResponse<ReviewActionResult>(response);
}

export async function fetchLessonVersions(lessonId: string): Promise<LessonVersionSummary[]> {
  const response = await fetch(`/api/admin/content/review/lessons/${lessonId}/versions`);
  return parseReviewResponse<LessonVersionSummary[]>(response);
}

export async function restoreLessonVersion(input: {
  lessonId: string;
  versionId: string;
}): Promise<{
  id: string;
  title: string;
  estimatedMinutes: number;
  content: LessonContent;
}> {
  const response = await fetch(
    `/api/admin/content/review/lessons/${input.lessonId}/versions/restore`,
    {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ versionId: input.versionId }),
    },
  );
  return parseReviewResponse(response);
}

export async function fetchReviewLessonPreview(lessonId: string) {
  const response = await fetch(`/api/admin/content/drafts/lesson/${lessonId}`);
  return parseReviewResponse<{
    id: string;
    title: string;
    content: LessonContent;
    estimatedMinutes: number;
    curriculumCode: string;
    topicTitle: string;
    subtopicTitle: string;
    topicId: string;
  }>(response);
}
