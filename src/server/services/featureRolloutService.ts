import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  FEATURE_REGISTRY,
  type FeatureKey,
  isRegisteredFeatureKey,
} from "@/lib/admin/featureRegistry";

export type RolloutScope =
  | "global"
  | "curriculum"
  | "grade"
  | "cohort"
  | "student"
  | "role";

export type RolloutRow = {
  featureKey: string;
  isEnabled: boolean;
  scope: RolloutScope;
  scopeValue: string | null;
};

export type RolloutEvaluationContext = {
  studentId?: string;
  curriculum?: string | null;
  gradeLevel?: string | null;
  role?: string | null;
  cohortId?: string | null;
};

let cachedRollouts: { expiresAt: number; rows: RolloutRow[] } | null = null;
const CACHE_TTL_MS = 30_000;

async function loadRolloutRows(): Promise<RolloutRow[]> {
  const now = Date.now();
  if (cachedRollouts && cachedRollouts.expiresAt > now) {
    return cachedRollouts.rows;
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_feature_rollouts")
    .select("feature_key, is_enabled, scope, scope_value");

  if (error) {
    throw new Error(error.message);
  }

  const rows = (data ?? []).map((row) => ({
    featureKey: String(row.feature_key),
    isEnabled: Boolean(row.is_enabled),
    scope: row.scope as RolloutScope,
    scopeValue: row.scope_value ? String(row.scope_value) : null,
  }));

  cachedRollouts = { expiresAt: now + CACHE_TTL_MS, rows };
  return rows;
}

export function clearFeatureRolloutCache(): void {
  cachedRollouts = null;
}

function registryDefault(featureKey: string): boolean {
  if (!isRegisteredFeatureKey(featureKey)) {
    return false;
  }
  return FEATURE_REGISTRY[featureKey].defaultEnabled;
}

/**
 * DEC-001 assumption (option A): rollout rows are evaluated before entitlements.
 * Experiments are not wired here yet (Phase 09 / PR-068).
 */
export async function isFeatureEnabled(
  featureKey: string,
  context: RolloutEvaluationContext = {},
): Promise<boolean> {
  const rows = (await loadRolloutRows()).filter(
    (row) => row.featureKey === featureKey,
  );

  if (rows.length === 0) {
    return registryDefault(featureKey);
  }

  const global = rows.find((row) => row.scope === "global");
  if (global && !global.isEnabled) {
    return false;
  }

  const scopedChecks: Array<{ scope: RolloutScope; value?: string | null }> = [
    { scope: "student", value: context.studentId },
    { scope: "grade", value: context.gradeLevel },
    { scope: "curriculum", value: context.curriculum },
    { scope: "cohort", value: context.cohortId },
    { scope: "role", value: context.role },
  ];

  for (const check of scopedChecks) {
    if (!check.value) {
      continue;
    }

    const match = rows.find(
      (row) => row.scope === check.scope && row.scopeValue === check.value,
    );
    if (match) {
      return match.isEnabled;
    }
  }

  if (global) {
    return global.isEnabled;
  }

  return registryDefault(featureKey);
}

export async function evaluateFeatureRollout(
  featureKey: FeatureKey,
  context: RolloutEvaluationContext,
): Promise<{ enabled: boolean; source: "rollout" | "default" }> {
  const enabled = await isFeatureEnabled(featureKey, context);
  const rows = (await loadRolloutRows()).some((row) => row.featureKey === featureKey);
  return {
    enabled,
    source: rows ? "rollout" : "default",
  };
}
