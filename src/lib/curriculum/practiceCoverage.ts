export type PracticeDifficulty = "easy" | "medium" | "hard";

export type PracticeQuestionCounts = {
  easy: number;
  medium: number;
  hard: number;
};

/** Minimum published questions per topic per difficulty for V1 launch coverage. */
export const TOPIC_QUESTION_COVERAGE_TARGET = 20;

/** Preferred published questions per subtopic per difficulty. */
export const SUBTOPIC_QUESTION_COVERAGE_TARGET = 10;

/** Minimum published questions required to start a practice session. */
export const MIN_QUESTIONS_TO_START_PRACTICE = 5;

export function emptyQuestionCounts(): PracticeQuestionCounts {
  return { easy: 0, medium: 0, hard: 0 };
}

export function isDifficultyPracticeReady(
  counts: PracticeQuestionCounts,
  difficulty: PracticeDifficulty,
): boolean {
  return counts[difficulty] >= MIN_QUESTIONS_TO_START_PRACTICE;
}

export function practiceReadyByDifficulty(
  counts: PracticeQuestionCounts,
): Record<PracticeDifficulty, boolean> {
  return {
    easy: isDifficultyPracticeReady(counts, "easy"),
    medium: isDifficultyPracticeReady(counts, "medium"),
    hard: isDifficultyPracticeReady(counts, "hard"),
  };
}

export function nodeNeedsContent(counts: PracticeQuestionCounts): boolean {
  return counts.easy + counts.medium + counts.hard === 0;
}

export function meetsTopicCoverageTarget(counts: PracticeQuestionCounts): boolean {
  return (
    counts.easy >= TOPIC_QUESTION_COVERAGE_TARGET &&
    counts.medium >= TOPIC_QUESTION_COVERAGE_TARGET &&
    counts.hard >= TOPIC_QUESTION_COVERAGE_TARGET
  );
}

export function meetsSubtopicCoverageTarget(counts: PracticeQuestionCounts): boolean {
  return (
    counts.easy >= SUBTOPIC_QUESTION_COVERAGE_TARGET &&
    counts.medium >= SUBTOPIC_QUESTION_COVERAGE_TARGET &&
    counts.hard >= SUBTOPIC_QUESTION_COVERAGE_TARGET
  );
}

export function incrementQuestionCount(
  counts: PracticeQuestionCounts,
  difficulty: string,
): PracticeQuestionCounts {
  if (difficulty === "easy" || difficulty === "medium" || difficulty === "hard") {
    return { ...counts, [difficulty]: counts[difficulty] + 1 };
  }

  return counts;
}
