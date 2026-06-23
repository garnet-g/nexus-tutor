export type AdminApiError = {
  code: string;
  message: string;
};

export type AdminApiResponse<T> =
  | { success: true; data: T }
  | { success: false; error: AdminApiError };

export type StudioLessonDetail = {
  id: string;
  title: string;
  content: import("@/types/curriculum").LessonContent;
  estimatedMinutes: number;
  sortOrder: number;
  subtopicId: string;
  subtopicTitle: string;
  topicId: string;
  topicTitle: string;
  subjectId: string;
  curriculumCode: string;
};

export async function fetchStudioLesson(lessonId: string): Promise<StudioLessonDetail> {
  const response = await fetch(`/api/admin/content/drafts/lesson/${lessonId}`);
  const payload = (await response.json()) as AdminApiResponse<StudioLessonDetail>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not load lesson." : payload.error.message);
  }

  return payload.data;
}

export async function saveStudioLesson(input: {
  id: string;
  title: string;
  estimatedMinutes: number;
  blocks: import("@/types/curriculum").LessonContentBlock[];
  shortQuiz?: import("@/types/curriculum").LessonContent["shortQuiz"];
}): Promise<StudioLessonDetail> {
  const response = await fetch("/api/admin/content/drafts/lesson", {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  const payload = (await response.json()) as AdminApiResponse<{
    id: string;
    title: string;
    estimatedMinutes: number;
    content: import("@/types/curriculum").LessonContent;
  }>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not save lesson." : payload.error.message);
  }

  const current = await fetchStudioLesson(input.id);
  return {
    ...current,
    title: payload.data.title,
    estimatedMinutes: payload.data.estimatedMinutes,
    content: payload.data.content,
  };
}

export async function createStudioLesson(input: {
  subtopicId: string;
  title?: string;
  estimatedMinutes?: number;
}): Promise<{ lessonId: string }> {
  const response = await fetch("/api/admin/content/drafts/lesson/create", {
    method: "POST",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify(input),
  });
  const payload = (await response.json()) as AdminApiResponse<{ lessonId: string }>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not create lesson." : payload.error.message);
  }

  return payload.data;
}

export async function uploadStudioMedia(file: File): Promise<{
  publicUrl: string;
  path: string;
  fileName: string;
}> {
  const formData = new FormData();
  formData.append("file", file);

  const response = await fetch("/api/admin/content/media/upload", {
    method: "POST",
    body: formData,
  });
  const payload = (await response.json()) as AdminApiResponse<{
    publicUrl: string;
    path: string;
    fileName: string;
  }>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Upload failed." : payload.error.message);
  }

  return payload.data;
}
