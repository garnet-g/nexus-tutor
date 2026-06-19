export const DEFAULT_EXAM_DURATION_MINUTES = 45;

export function calculateEndsAt(
  startedAt: Date,
  durationMinutes: number,
): Date {
  return new Date(startedAt.getTime() + durationMinutes * 60_000);
}

export function isExamSessionExpired(endsAt: Date, now = new Date()): boolean {
  return now.getTime() >= endsAt.getTime();
}

export function canSubmitExamSession(input: {
  sessionStatus: string;
  endsAt: Date;
  now?: Date;
}): boolean {
  if (input.sessionStatus === "completed") {
    return false;
  }

  if (input.sessionStatus === "expired") {
    return true;
  }

  return input.sessionStatus === "in_progress";
}

export function resolveSessionStatusOnSubmit(input: {
  endsAt: Date;
  now?: Date;
}): "completed" | "expired" {
  return isExamSessionExpired(input.endsAt, input.now) ? "expired" : "completed";
}

export function formatGradeDelta(previous: string | null, next: string): string {
  if (!previous || previous === next) {
    return "unchanged";
  }

  return `${previous} → ${next}`;
}

export function buildExamAnalysis(input: {
  scorePercentage: number;
  weakTopicTitles: string[];
  previousPredictedGrade: string | null;
  nextPredictedGrade: string;
}) {
  return {
    scorePercentage: input.scorePercentage,
    weakTopics: input.weakTopicTitles,
    predictedGrade: input.nextPredictedGrade,
    predictedGradeDelta: formatGradeDelta(
      input.previousPredictedGrade,
      input.nextPredictedGrade,
    ),
    summary:
      input.weakTopicTitles.length > 0
        ? `Focus next on: ${input.weakTopicTitles.slice(0, 3).join(", ")}.`
        : "Strong performance across all topics in this paper.",
  };
}

export function remainingSeconds(endsAt: Date, now = new Date()): number {
  return Math.max(0, Math.floor((endsAt.getTime() - now.getTime()) / 1000));
}
