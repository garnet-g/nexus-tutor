export type LessonPathStatus = "locked" | "available" | "done";

export function getLessonPathStatus(
  lessonId: string,
  orderedLessonIds: string[],
  completedLessonIds: Set<string> | readonly string[],
): LessonPathStatus {
  const completed = completedLessonIds instanceof Set
    ? completedLessonIds
    : new Set(completedLessonIds);

  if (completed.has(lessonId)) {
    return "done";
  }

  const index = orderedLessonIds.indexOf(lessonId);
  if (index <= 0) {
    return "available";
  }

  const previousId = orderedLessonIds[index - 1];
  if (previousId && completed.has(previousId)) {
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
