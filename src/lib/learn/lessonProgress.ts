const COMPLETED_LESSONS_KEY = "nexus-lesson-completed";
const LAST_LESSON_KEY = "nexus-lesson-last-read";

function storageKey(base: string, studentId: string, suffix: string): string {
  return `${base}:${studentId}:${suffix}`;
}

function readJson<T>(key: string, fallback: T): T {
  if (typeof window === "undefined") {
    return fallback;
  }

  try {
    const raw = window.localStorage.getItem(key);
    if (!raw) {
      return fallback;
    }

    return JSON.parse(raw) as T;
  } catch {
    return fallback;
  }
}

function writeJson(key: string, value: unknown) {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(key, JSON.stringify(value));
}

export function getCompletedLessonIds(studentId: string): Set<string> {
  const ids = readJson<string[]>(storageKey(COMPLETED_LESSONS_KEY, studentId, "all"), []);
  return new Set(ids);
}

export function markLessonComplete(studentId: string, lessonId: string) {
  const completed = getCompletedLessonIds(studentId);
  completed.add(lessonId);
  writeJson(
    storageKey(COMPLETED_LESSONS_KEY, studentId, "all"),
    Array.from(completed),
  );
}

export function getLastReadLessonId(
  studentId: string,
  topicId: string,
): string | null {
  return readJson<string | null>(
    storageKey(LAST_LESSON_KEY, studentId, topicId),
    null,
  );
}

export function setLastReadLessonId(
  studentId: string,
  topicId: string,
  lessonId: string,
) {
  writeJson(storageKey(LAST_LESSON_KEY, studentId, topicId), lessonId);
}

export type LessonPathStatus = "locked" | "available" | "done";

export function getLessonPathStatus(
  lessonId: string,
  orderedLessonIds: string[],
  completedLessonIds: Set<string>,
): LessonPathStatus {
  if (completedLessonIds.has(lessonId)) {
    return "done";
  }

  const index = orderedLessonIds.indexOf(lessonId);
  if (index <= 0) {
    return "available";
  }

  const previousId = orderedLessonIds[index - 1];
  if (previousId && completedLessonIds.has(previousId)) {
    return "available";
  }

  return index === 0 ? "available" : "locked";
}

export function inferLessonType(input: {
  title: string;
  hasExamples: boolean;
  hasQuiz: boolean;
}): "Notes" | "Worked examples" | "Short quiz" {
  if (input.hasQuiz && /quiz|check|checkpoint/i.test(input.title)) {
    return "Short quiz";
  }

  if (input.hasExamples) {
    return "Worked examples";
  }

  if (input.hasQuiz) {
    return "Short quiz";
  }

  return "Notes";
}
