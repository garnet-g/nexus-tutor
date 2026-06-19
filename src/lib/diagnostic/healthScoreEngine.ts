import type { Curriculum } from "@/types/database";

import type { TopicScoreResult } from "@/lib/diagnostic/types";

export interface RollingHealthScoreInput {
  diagnosticBaseline: number;
  averageTopicMastery: number;
  recentPracticePerformance: number;
}

export function predictGrade(
  healthScore: number,
  curriculum: Curriculum,
): string {
  const score = Math.max(0, Math.min(100, Math.round(healthScore)));

  if (curriculum === "CBC") {
    if (score >= 80) return "Exceeding Expectations";
    if (score >= 60) return "Meeting Expectations";
    if (score >= 40) return "Approaching Expectations";
    return "Below Expectations";
  }

  if (score >= 80) return "A";
  if (score >= 75) return "A-";
  if (score >= 70) return "B+";
  if (score >= 65) return "B";
  if (score >= 60) return "B-";
  if (score >= 55) return "C+";
  if (score >= 50) return "C";
  if (score >= 45) return "C-";
  if (score >= 40) return "D+";
  if (score >= 35) return "D";
  if (score >= 30) return "D-";
  return "E";
}

export function buildTopicScoresRecord(
  topicScores: TopicScoreResult[],
): Record<string, number> {
  return Object.fromEntries(
    topicScores.map((topic) => [topic.topicId, topic.topicScore]),
  );
}

export function computeRollingHealthScore(
  input: RollingHealthScoreInput,
): number {
  const healthScore =
    input.diagnosticBaseline * 0.4 +
    input.averageTopicMastery * 0.5 +
    input.recentPracticePerformance * 0.1;

  return Math.max(0, Math.min(100, Math.round(healthScore)));
}

export function computeInitialHealthScore(diagnosticScore: number): number {
  return Math.max(0, Math.min(100, Math.round(diagnosticScore)));
}
