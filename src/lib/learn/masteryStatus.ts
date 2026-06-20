export type TopicMasteryStatus = "not_started" | "in_progress" | "mastered";

export function getTopicMasteryStatus(
  masteryPercentage: number | null | undefined,
): TopicMasteryStatus {
  if (masteryPercentage == null || masteryPercentage <= 0) {
    return "not_started";
  }

  if (masteryPercentage >= 70) {
    return "mastered";
  }

  return "in_progress";
}

export function getTopicMasteryLabel(status: TopicMasteryStatus): string {
  switch (status) {
    case "mastered":
      return "Mastered";
    case "in_progress":
      return "In progress";
    default:
      return "Not started";
  }
}

export function averageMastery(
  masteryByTopicId: Record<string, number>,
  topicIds: string[],
): number {
  if (topicIds.length === 0) {
    return 0;
  }

  const total = topicIds.reduce(
    (sum, topicId) => sum + (masteryByTopicId[topicId] ?? 0),
    0,
  );

  return Math.round(total / topicIds.length);
}

export function formatStrandLabel(topicCode: string): string {
  return topicCode
    .split("_")
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}
