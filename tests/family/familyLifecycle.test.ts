/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const OWNER_STUDENT = "00000000-0000-4000-8000-000000000301";
const MEMBER_STUDENT = "00000000-0000-4000-8000-000000000302";
const SUBSCRIPTION_ID = "00000000-0000-4000-8000-000000000401";

let groupActive = true;
let memberCount = 2;
let memberPlanCode = "family";
const rpcCalls: string[] = [];

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfig: vi.fn(async () => ({
    limits: { familyMaxStudents: 4 },
    pricing: { familyAmountKes: 1200 },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    rpc: (name: string, args: Record<string, unknown>) => {
      rpcCalls.push(name);

      if (name === "reclaim_family_group_on_lapse") {
        memberCount = 1;
        groupActive = false;
        memberPlanCode = "free";
        return {
          data: { reclaimed: true, removed_members: 1 },
          error: null,
        };
      }

      if (name === "reactivate_family_group_on_resubscribe") {
        groupActive = true;
        return {
          data: {
            family_group_id: "family-group-1",
            invite_code: "FAMILY-ABC123",
            reactivated: true,
          },
          error: null,
        };
      }

      if (name === "process_verified_mpesa_payment") {
        return {
          data: {
            activated: true,
            subscriptionId: SUBSCRIPTION_ID,
            familyGroupId: "family-group-duplicate",
            familyInviteCode: "FAMILY-NEW",
          },
          error: null,
        };
      }

      if (name === "join_family_group") {
        memberCount = 2;
        memberPlanCode = "family";
        return {
          data: { family_group_id: "family-group-1", seats_remaining: 2 },
          error: null,
        };
      }

      return { data: null, error: { message: `unexpected rpc ${name}` } };
    },
    from: (table: string) => {
      if (table === "student_subscriptions") {
        return {
          select: () => ({
            in: () => ({
              order: async () => ({
                data: [
                  {
                    id: SUBSCRIPTION_ID,
                    student_id: OWNER_STUDENT,
                    subscription_plans: { plan_code: "family" },
                  },
                ],
                error: null,
              }),
            }),
          }),
        };
      }

      if (table === "family_groups") {
        return {
          select: () => ({
            eq: (column: string, value: unknown) => {
              const chain: Record<string, unknown> = {};
              chain.eq = (nextColumn: string, nextValue: unknown) => {
                if (column === "owner_student_id" && nextColumn === "is_active") {
                  if (nextValue === false) {
                    return {
                      order: () => ({
                        limit: () => ({
                          maybeSingle: async () => ({
                            data: { id: "family-group-1", invite_code: "FAMILY-ABC123" },
                            error: null,
                          }),
                        }),
                      }),
                    };
                  }

                  return {
                    maybeSingle: async () => ({
                      data: groupActive
                        ? {
                            invite_code: "FAMILY-ABC123",
                            is_active: true,
                            seat_count: memberCount,
                          }
                        : null,
                      error: null,
                    }),
                  };
                }

                return chain;
              };
              chain.order = () => chain;
              chain.limit = () => chain;
              chain.maybeSingle = async () => ({
                data: groupActive
                  ? {
                      invite_code: "FAMILY-ABC123",
                      is_active: true,
                      seat_count: memberCount,
                    }
                  : null,
                error: null,
              });
              return chain;
            },
          }),
          update: () => ({
            eq: async () => ({ data: null, error: null }),
          }),
        };
      }

      if (table === "mpesa_payments") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: {
                  student_id: OWNER_STUDENT,
                  subscription_plans: { plan_code: "family" },
                },
                error: null,
              }),
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({ data: null, error: null }),
          }),
        }),
      };
    },
  })),
}));

vi.mock("@/server/services/subscriptionService", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/server/services/subscriptionService")>();
  return {
    ...actual,
    getStudentPlanCode: vi.fn(async (studentId: string) => {
      if (studentId === MEMBER_STUDENT) {
        return memberPlanCode;
      }
      return "family";
    }),
  };
});

describe("PR-133 / PR-134 family lifecycle", () => {
  beforeEach(() => {
    groupActive = true;
    memberCount = 2;
    memberPlanCode = "family";
    rpcCalls.length = 0;
    vi.resetModules();
  });

  it("subscription lapse reclaims seats and removes member family entitlements", async () => {
    const { processExpiredFamilySubscriptions } = await import(
      "@/server/services/familySubscriptionService"
    );
    const { getStudentPlanCode } = await import("@/server/services/subscriptionService");

    await processExpiredFamilySubscriptions();

    expect(rpcCalls).toContain("reclaim_family_group_on_lapse");
    expect(await getStudentPlanCode(MEMBER_STUDENT)).toBe("free");
    expect(groupActive).toBe(false);
  });

  it("resubscription reactivates the group and members can rejoin via join_family_group", async () => {
    const {
      reclaimFamilyGroupOnLapse,
      joinFamilyGroupWithCode,
    } = await import("@/server/services/familySubscriptionService");
    const { getStudentPlanCode, processVerifiedMpesaPayment } = await import(
      "@/server/services/subscriptionService"
    );

    await reclaimFamilyGroupOnLapse(SUBSCRIPTION_ID);
    expect(await getStudentPlanCode(MEMBER_STUDENT)).toBe("free");

    const activation = await processVerifiedMpesaPayment({
      mpesaPaymentId: "pay-resubscribe",
      mpesaReceiptNumber: "QBD999",
      queryResultCode: 0,
      queryPayload: {},
      verifiedAmountKes: 1200,
    });

    expect(rpcCalls).toContain("reactivate_family_group_on_resubscribe");
    expect(activation.familyInviteCode).toBe("FAMILY-ABC123");
    expect(groupActive).toBe(true);

    const joined = await joinFamilyGroupWithCode({
      studentId: MEMBER_STUDENT,
      inviteCode: activation.familyInviteCode ?? "FAMILY-ABC123",
    });

    expect(joined.familyGroupId).toBe("family-group-1");
    expect(rpcCalls).toContain("join_family_group");
    expect(await getStudentPlanCode(MEMBER_STUDENT)).toBe("family");
  });
});
