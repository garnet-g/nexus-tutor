/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

import {
  clearFeatureRolloutCache,
  isFeatureEnabled,
} from "@/server/services/featureRolloutService";

describe("featureRolloutService", () => {
  beforeEach(() => {
    from.mockReset();
    clearFeatureRolloutCache();
  });

  it("returns false for an off global rollout", async () => {
    from.mockReturnValue({
      select: async () => ({
        data: [
          {
            feature_key: "student.study_search",
            is_enabled: false,
            scope: "global",
            scope_value: null,
          },
        ],
        error: null,
      }),
    });

    const enabled = await isFeatureEnabled("student.study_search", {
      studentId: "student-1",
    });

    expect(enabled).toBe(false);
  });

  it("allows a cohort only when the matching scoped rollout is enabled", async () => {
    from.mockReturnValue({
      select: async () => ({
        data: [
          {
            feature_key: "student.study_search",
            is_enabled: true,
            scope: "student",
            scope_value: "student-allowed",
          },
        ],
        error: null,
      }),
    });

    await expect(
      isFeatureEnabled("student.study_search", { studentId: "student-allowed" }),
    ).resolves.toBe(true);
    await expect(
      isFeatureEnabled("student.study_search", { studentId: "student-blocked" }),
    ).resolves.toBe(false);
  });
});
