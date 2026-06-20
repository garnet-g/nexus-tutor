export interface DashboardEmptyStateInput {
  topicMastery: Array<{ masteryPercentage: number }>;
  totalXp: number;
  currentStreak: number;
  hasStudyPlanTasks: boolean;
}

/**
 * Pure predicate — server-safe so Server Components (the dashboard page) can
 * call it directly. Kept out of the `"use client"` component module to avoid
 * crossing the client boundary.
 */
export function shouldShowDashboardEmptyState(
  input: DashboardEmptyStateInput,
): boolean {
  const hasMastery =
    input.topicMastery.length > 0 &&
    input.topicMastery.some((topic) => topic.masteryPercentage > 0);

  const hasActivity =
    hasMastery || input.totalXp > 0 || input.currentStreak > 0;

  return !hasActivity && !input.hasStudyPlanTasks;
}
