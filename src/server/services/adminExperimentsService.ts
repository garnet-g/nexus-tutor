import "server-only";

import { createHash } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";
import { isFeatureEnabled } from "@/server/services/featureRolloutService";

export type ExperimentAssignment = {
  experimentKey: string;
  variant: string;
  exposureRecorded: boolean;
};

function hashSubject(experimentKey: string, subjectId: string): number {
  const digest = createHash("sha256")
    .update(`${experimentKey}:${subjectId}`)
    .digest();
  return digest.readUInt32BE(0);
}

export async function getRunningExperiment(experimentKey: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_experiments")
    .select("experiment_key, status, variants")
    .eq("experiment_key", experimentKey)
    .maybeSingle();
  if (error) {
    throw new Error(error.message);
  }
  if (!data || data.status !== "running") {
    return null;
  }

  const variants = Array.isArray(data.variants)
    ? (data.variants as string[]).filter((variant) => variant.length > 0)
    : [];
  if (variants.length < 2) {
    return null;
  }

  return { experimentKey: data.experiment_key as string, variants };
}

export function pickDeterministicVariant(
  experimentKey: string,
  subjectId: string,
  variants: string[],
): string {
  const index = hashSubject(experimentKey, subjectId) % variants.length;
  return variants[index] ?? variants[0]!;
}

export async function recordExperimentExposure(input: {
  experimentKey: string;
  subjectId: string;
  variant: string;
}): Promise<void> {
  const admin = createAdminClient();
  const { error } = await admin.from("admin_experiment_exposures").upsert(
    {
      experiment_key: input.experimentKey,
      subject_id: input.subjectId,
      variant: input.variant,
      exposed_at: new Date().toISOString(),
    },
    { onConflict: "experiment_key,subject_id" },
  );
  if (error) {
    throw new Error(error.message);
  }
}

export async function assignExperimentVariant(input: {
  experimentKey: string;
  subjectId: string;
  recordExposure?: boolean;
}): Promise<ExperimentAssignment | null> {
  const experiment = await getRunningExperiment(input.experimentKey);
  if (!experiment) {
    return null;
  }

  const variant = pickDeterministicVariant(
    experiment.experimentKey,
    input.subjectId,
    experiment.variants,
  );

  if (input.recordExposure !== false) {
    await recordExperimentExposure({
      experimentKey: experiment.experimentKey,
      subjectId: input.subjectId,
      variant,
    });
  }

  return {
    experimentKey: experiment.experimentKey,
    variant,
    exposureRecorded: input.recordExposure !== false,
  };
}

export async function getExperimentExposureMetrics(experimentKey: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_experiment_exposures")
    .select("variant")
    .eq("experiment_key", experimentKey);
  if (error) {
    throw new Error(error.message);
  }

  const counts: Record<string, number> = {};
  for (const row of data ?? []) {
    const variant = String(row.variant);
    counts[variant] = (counts[variant] ?? 0) + 1;
  }

  return {
    experimentKey,
    totalExposures: data?.length ?? 0,
    variantCounts: counts,
  };
}

/**
 * DEC-001 precedence: rollout/feature gate is evaluated before experiment assignment.
 */
export async function isExperimentFeatureEnabled(input: {
  featureKey: string;
  subjectId: string;
}): Promise<{ enabled: boolean; variant: string | null; source: "rollout" | "experiment" | "none" }> {
  const rolloutEnabled = await isFeatureEnabled(input.featureKey, {
    studentId: input.subjectId,
  });
  if (!rolloutEnabled) {
    return { enabled: false, variant: null, source: "rollout" };
  }

  const assignment = await assignExperimentVariant({
    experimentKey: input.featureKey,
    subjectId: input.subjectId,
  });
  if (!assignment) {
    return { enabled: rolloutEnabled, variant: null, source: "rollout" };
  }

  return {
    enabled: assignment.variant !== "control",
    variant: assignment.variant,
    source: "experiment",
  };
}
