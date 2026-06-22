import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { OutcomesQueryInput } from "@/schemas/adminSchemas";

/**
 * Read-only Outcomes KPI service for the super-admin dashboard (Phase 2).
 *
 * Source tables:
 *  - academic_health_scores (per-student/subject health_score, calculated_at) — latest vs baseline delta
 *  - diagnostic_results (diagnostic_score as the baseline cohort entry point)
 *  - topic_mastery (mastery_percentage)
 *  - student_profiles (full_name, curriculum, grade_level, is_active)
 *
 * Baseline source for the headline delta: each student's EARLIEST academic_health_scores
 * row vs their LATEST. Diagnostic results provide an additional cohort baseline reference.
 * Deltas are computed in TS because a single SQL can't cleanly express per-student
 * first/last ordering without a window function / view.
 *
 * NOTE (scale): at large row counts a materialized rollup
 * (student_id -> latest_health, baseline_health, avg_mastery) would avoid scanning the
 * full academic_health_scores history on each request.
 */

const DEFAULT_RISK_THRESHOLD = 50;
const AT_RISK_DEFAULT_LIMIT = 100;
// Bound the health-score scan to a recent window to keep the query reasonable.
const HEALTH_SCORE_SCAN_LIMIT = 5000;

type StudentProfileLite = {
  full_name?: string;
  curriculum?: string;
  grade_level?: string;
  is_active?: boolean;
};

export type OutcomesKpis = {
  cohortHealthDelta: number;
  avgCurrentHealthScore: number;
  avgTopicMasteryPct: number;
  activeLearners: number;
  studentsWithScores: number;
};

export type OutcomesBreakdownRow = {
  groupKey: string;
  curriculum: string;
  gradeLevel: string;
  avgHealthScore: number;
  avgMasteryPct: number;
  studentCount: number;
};

export type AtRiskStudent = {
  studentId: string;
  studentName: string;
  gradeLevel: string;
  curriculum: string;
  currentScore: number;
  delta: number;
  lastActive: string | null;
};

export type OutcomesDashboardData = {
  kpis: OutcomesKpis;
  breakdown: OutcomesBreakdownRow[];
  atRisk: AtRiskStudent[];
  riskThreshold: number;
};

type StudentAgg = {
  studentId: string;
  name: string;
  curriculum: string;
  gradeLevel: string;
  isActive: boolean;
  baselineScore: number;
  latestScore: number;
  lastCalculatedAt: string | null;
};

function round1(value: number): number {
  return Math.round(value * 10) / 10;
}

export async function getOutcomesDashboard(
  filters: OutcomesQueryInput = {},
): Promise<OutcomesDashboardData> {
  const admin = createAdminClient();
  const riskThreshold = filters.riskThreshold ?? DEFAULT_RISK_THRESHOLD;
  const atRiskLimit = filters.limit ?? AT_RISK_DEFAULT_LIMIT;

  // Pull health scores ordered so first-seen = baseline, last-seen = latest per student.
  const { data: healthRows, error: healthError } = await admin
    .from("academic_health_scores")
    .select(
      "student_id, health_score, calculated_at, student_profiles(full_name, curriculum, grade_level, is_active)",
    )
    .order("student_id", { ascending: true })
    .order("calculated_at", { ascending: true })
    .limit(HEALTH_SCORE_SCAN_LIMIT);

  if (healthError) {
    throw new Error(healthError.message);
  }

  const byStudent = new Map<string, StudentAgg>();

  for (const row of healthRows ?? []) {
    const profile = unwrapSupabaseRelation<StudentProfileLite>(
      row.student_profiles,
    );
    const score = Number(row.health_score ?? 0);
    const existing = byStudent.get(row.student_id);

    if (!existing) {
      byStudent.set(row.student_id, {
        studentId: row.student_id,
        name: profile?.full_name ?? "Unknown",
        curriculum: profile?.curriculum ?? "—",
        gradeLevel: profile?.grade_level ?? "—",
        isActive: profile?.is_active ?? true,
        baselineScore: score,
        latestScore: score,
        lastCalculatedAt: row.calculated_at ?? null,
      });
    } else {
      // Rows are ascending by calculated_at, so later rows overwrite latest.
      existing.latestScore = score;
      existing.lastCalculatedAt = row.calculated_at ?? existing.lastCalculatedAt;
    }
  }

  // Optional filters by curriculum / grade.
  let students = Array.from(byStudent.values());
  if (filters.curriculum) {
    students = students.filter((s) => s.curriculum === filters.curriculum);
  }
  if (filters.gradeLevel) {
    students = students.filter((s) => s.gradeLevel === filters.gradeLevel);
  }

  // --- Topic mastery (avg per student, then cohort avg) ---
  const { data: masteryRows, error: masteryError } = await admin
    .from("topic_mastery")
    .select("student_id, mastery_percentage")
    .limit(HEALTH_SCORE_SCAN_LIMIT);

  if (masteryError) {
    throw new Error(masteryError.message);
  }

  const masterySum = new Map<string, { total: number; count: number }>();
  for (const row of masteryRows ?? []) {
    const entry = masterySum.get(row.student_id) ?? { total: 0, count: 0 };
    entry.total += Number(row.mastery_percentage ?? 0);
    entry.count += 1;
    masterySum.set(row.student_id, entry);
  }

  function studentMastery(studentId: string): number | null {
    const entry = masterySum.get(studentId);
    if (!entry || entry.count === 0) {
      return null;
    }
    return entry.total / entry.count;
  }

  // --- KPIs ---
  const studentsWithScores = students.length;
  const cohortHealthDelta =
    studentsWithScores === 0
      ? 0
      : round1(
          students.reduce((sum, s) => sum + (s.latestScore - s.baselineScore), 0) /
            studentsWithScores,
        );
  const avgCurrentHealthScore =
    studentsWithScores === 0
      ? 0
      : round1(
          students.reduce((sum, s) => sum + s.latestScore, 0) / studentsWithScores,
        );

  const masteryValues = students
    .map((s) => studentMastery(s.studentId))
    .filter((v): v is number => v !== null);
  const avgTopicMasteryPct =
    masteryValues.length === 0
      ? 0
      : round1(
          masteryValues.reduce((sum, v) => sum + v, 0) / masteryValues.length,
        );

  const activeLearners = students.filter((s) => s.isActive).length;

  // --- Breakdown by curriculum + grade_level ---
  const groups = new Map<
    string,
    {
      curriculum: string;
      gradeLevel: string;
      healthTotal: number;
      masteryTotal: number;
      masteryCount: number;
      count: number;
    }
  >();

  for (const s of students) {
    const key = `${s.curriculum}::${s.gradeLevel}`;
    const group = groups.get(key) ?? {
      curriculum: s.curriculum,
      gradeLevel: s.gradeLevel,
      healthTotal: 0,
      masteryTotal: 0,
      masteryCount: 0,
      count: 0,
    };
    group.healthTotal += s.latestScore;
    group.count += 1;
    const mastery = studentMastery(s.studentId);
    if (mastery !== null) {
      group.masteryTotal += mastery;
      group.masteryCount += 1;
    }
    groups.set(key, group);
  }

  const breakdown: OutcomesBreakdownRow[] = Array.from(groups.entries())
    .map(([key, g]) => ({
      groupKey: key,
      curriculum: g.curriculum,
      gradeLevel: g.gradeLevel,
      avgHealthScore: g.count === 0 ? 0 : round1(g.healthTotal / g.count),
      avgMasteryPct:
        g.masteryCount === 0 ? 0 : round1(g.masteryTotal / g.masteryCount),
      studentCount: g.count,
    }))
    .sort((a, b) => b.studentCount - a.studentCount);

  // --- At-risk list: below threshold OR trending down (latest < baseline) ---
  const atRisk: AtRiskStudent[] = students
    .filter(
      (s) => s.latestScore < riskThreshold || s.latestScore < s.baselineScore,
    )
    .map((s) => ({
      studentId: s.studentId,
      studentName: s.name,
      gradeLevel: s.gradeLevel,
      curriculum: s.curriculum,
      currentScore: round1(s.latestScore),
      delta: round1(s.latestScore - s.baselineScore),
      lastActive: s.lastCalculatedAt,
    }))
    .sort((a, b) => a.currentScore - b.currentScore)
    .slice(0, atRiskLimit);

  return {
    kpis: {
      cohortHealthDelta,
      avgCurrentHealthScore,
      avgTopicMasteryPct,
      activeLearners,
      studentsWithScores,
    },
    breakdown,
    atRisk,
    riskThreshold,
  };
}
