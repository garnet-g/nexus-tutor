const REVIEW_QUEUE_KEY = "nexus-practice-review-queue";

export interface ReviewQuestion {
  practiceQuestionId: string;
  questionText: string;
  questionType: string;
  options: unknown;
  difficulty: string;
  explanation: string | null;
  topicId: string;
  topicTitle: string;
}

function storageKey(studentId: string): string {
  return `${REVIEW_QUEUE_KEY}:${studentId}`;
}

function readQueue(studentId: string): ReviewQuestion[] {
  if (typeof window === "undefined") {
    return [];
  }

  try {
    const raw = window.localStorage.getItem(storageKey(studentId));
    if (!raw) {
      return [];
    }

    const parsed = JSON.parse(raw) as ReviewQuestion[];
    return Array.isArray(parsed) ? parsed : [];
  } catch {
    return [];
  }
}

function writeQueue(studentId: string, queue: ReviewQuestion[]) {
  if (typeof window === "undefined") {
    return;
  }

  window.localStorage.setItem(storageKey(studentId), JSON.stringify(queue));
}

export function getReviewQueue(studentId: string): ReviewQuestion[] {
  return readQueue(studentId);
}

export function getReviewQueueCount(studentId: string): number {
  return readQueue(studentId).length;
}

export function addToReviewQueue(studentId: string, question: ReviewQuestion) {
  const queue = readQueue(studentId);
  if (queue.some((entry) => entry.practiceQuestionId === question.practiceQuestionId)) {
    return;
  }

  writeQueue(studentId, [...queue, question].slice(-30));
}

export function removeFromReviewQueue(studentId: string, practiceQuestionId: string) {
  writeQueue(
    studentId,
    readQueue(studentId).filter(
      (entry) => entry.practiceQuestionId !== practiceQuestionId,
    ),
  );
}

export function clearReviewQueue(studentId: string) {
  writeQueue(studentId, []);
}
