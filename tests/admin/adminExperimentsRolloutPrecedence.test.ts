import { beforeEach, describe, expect, it, vi } from "vitest";

const isFeatureEnabled = vi.fn();

vi.mock("@/server/services/featureRolloutService", () => ({
  isFeatureEnabled: (...args: unknown[]) => isFeatureEnabled(...args),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: vi.fn(() => ({
      select: vi.fn(() => ({
        eq: vi.fn(() => ({
          maybeSingle: vi.fn(async () => ({
            data: {
              experiment_key: "nex_chat",
              status: "running",
              variants: ["control", "variant_a"],
            },
            error: null,
          })),
        })),
      })),
      upsert: vi.fn(async () => ({ error: null })),
    })),
  })),
}));

import { isExperimentFeatureEnabled } from "@/server/services/adminExperimentsService";

beforeEach(() => {
  vi.clearAllMocks();
});

describe("isExperimentFeatureEnabled rollout precedence", () => {
  it("returns rollout source when rollout disables the feature", async () => {
    isFeatureEnabled.mockResolvedValue(false);

    const gate = await isExperimentFeatureEnabled({
      featureKey: "nex_chat",
      subjectId: "student-1",
    });

    expect(gate).toEqual({
      enabled: false,
      variant: null,
      source: "rollout",
    });
  });

  it("uses experiment assignment only after rollout passes", async () => {
    isFeatureEnabled.mockResolvedValue(true);

    const gate = await isExperimentFeatureEnabled({
      featureKey: "nex_chat",
      subjectId: "student-1",
    });

    expect(gate.source).toBe("experiment");
    expect(gate.variant).toBeTruthy();
    expect(typeof gate.enabled).toBe("boolean");
  });
});
