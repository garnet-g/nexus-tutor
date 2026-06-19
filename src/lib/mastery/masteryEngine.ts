export type MasteryBand = "needs_work" | "developing" | "strong" | "mastered";

export interface TopicMasteryRecord {
  topicId: string;
  masteryPercentage: number;
}

export interface PracticeTopicResult {
  topicId: string;
  correct: number;
  total: number;
}

export interface MasteryUpdateResult {
  topicId: string;
  previousMastery: number;
  masteryPercentage: number;
}

const WEAK_TOPIC_THRESHOLD = 50;

export function getSessionTopicScore(correct: number, total: number): number {
  if (total <= 0) {
    return 0;
  }

  return Math.round((correct / total) * 100);
}

export function updateMasteryFromPractice(
  currentMastery: number,
  sessionTopicScore: number,
): number {
  const nextMastery = currentMastery * 0.7 + sessionTopicScore * 0.3;
  return clampMastery(nextMastery);
}

export function bumpMasteryFromLesson(currentMastery: number): number {
  return clampMastery(currentMastery + 2);
}

export function seedMasteryFromDiagnostic(topicScore: number): number {
  return clampMastery(topicScore);
}

export function clampMastery(value: number): number {
  return Math.max(0, Math.min(100, Math.round(value)));
}

export function getMasteryBand(masteryPercentage: number): MasteryBand {
  if (masteryPercentage >= 90) return "mastered";
  if (masteryPercentage >= 70) return "strong";
  if (masteryPercentage >= 40) return "developing";
  return "needs_work";
}

export function getMasteryBandLabel(band: MasteryBand): string {
  switch (band) {
    case "mastered":
      return "Mastered";
    case "strong":
      return "Strong";
    case "developing":
      return "Developing";
    default:
      return "Needs Work";
  }
}

export function computeMasteryUpdates(
  practiceResults: PracticeTopicResult[],
  existingMastery: Record<string, number>,
): MasteryUpdateResult[] {
  return practiceResults.map((result) => {
    const previousMastery = existingMastery[result.topicId] ?? 0;
    const sessionTopicScore = getSessionTopicScore(result.correct, result.total);

    return {
      topicId: result.topicId,
      previousMastery,
      masteryPercentage: updateMasteryFromPractice(
        previousMastery,
        sessionTopicScore,
      ),
    };
  });
}

export function identifyWeakTopics(
  masteryRecords: TopicMasteryRecord[],
  diagnosticWeakTopicIds: string[] = [],
  limit = 5,
): TopicMasteryRecord[] {
  const weakTopicIds = new Set(diagnosticWeakTopicIds);

  return [...masteryRecords]
    .filter(
      (record) =>
        record.masteryPercentage < WEAK_TOPIC_THRESHOLD ||
        weakTopicIds.has(record.topicId),
    )
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage)
    .slice(0, limit);
}

export function averageTopicMastery(masteryRecords: TopicMasteryRecord[]): number {
  if (masteryRecords.length === 0) {
    return 0;
  }

  const total = masteryRecords.reduce(
    (sum, record) => sum + record.masteryPercentage,
    0,
  );

  return Math.round(total / masteryRecords.length);
}
