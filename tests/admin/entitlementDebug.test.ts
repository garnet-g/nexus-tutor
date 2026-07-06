/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

vi.mock("@/server/services/featureRolloutService", () => ({
  isFeatureEnabled: vi.fn(async () => false),
}));

import { getStudent360Data } from "@/server/services/adminPlatformService";

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: { curriculum: "CBC", grade_level: "grade_7" },
              }),
            }),
          }),
        };
      }

      if (table === "student_subscriptions") {
        return {
          select: () => ({
            eq: () => ({
              in: () => ({
                order: () => ({
                  limit: () => ({
                    maybeSingle: async () => ({ data: null, error: null }),
                  }),
                }),
              }),
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            order: () => ({
              limit: async () => ({ data: [], error: null }),
            }),
          }),
        }),
      };
    },
  })),
}));

vi.mock("@/server/services/adminOpsService", () => ({
  listSupportCases: vi.fn(async () => []),
}));

vi.mock("@/server/services/subscriptionService", () => ({
  getStudentPlanCode: vi.fn(async () => "free"),
  hasUsedFreeTrial: vi.fn(async () => true),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfigWithFallback: vi.fn(async () => ({
    pricing: { premiumAmountKes: 799, familyAmountKes: 2499 },
    limits: { freeNex: 10, freePractice: 10, premiumNex: 50, premiumPractice: 30, familyMaxStudents: 5 },
    promotion: { isActive: false, title: null, endsAt: null },
  })),
  getNexDailyLimit: vi.fn(() => 10),
}));

describe("entitlement debug rollout truth", () => {
  it("marks feature disabled when rollout evaluation is off", async () => {
    const data = await getStudent360Data("00000000-0000-4000-8000-000000000099");
    expect(data.entitlement.allowed).toBe(false);
    expect(data.entitlement.blockers).toContain("Feature rollout is disabled");
  });
});
