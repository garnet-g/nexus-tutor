/**
 * @vitest-environment node
 *
 * PR-134: production trigger chain must reactivate a reclaimed family group
 * after family-plan payment activation — not only from unit tests.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const OWNER_STUDENT = "00000000-0000-4000-8000-000000000301";
const PAYMENT_ID = "00000000-0000-4000-8000-000000000501";
const NEW_SUBSCRIPTION_ID = "00000000-0000-4000-8000-000000000601";
const RECLAIMED_GROUP_ID = "family-group-reclaimed";
const DUPLICATE_GROUP_ID = "family-group-duplicate";

let groupActive = false;
const rpcCalls: string[] = [];

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfig: vi.fn(async () => ({
    limits: { familyMaxStudents: 4 },
    pricing: { familyAmountKes: 1200, premiumAmountKes: 500 },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    rpc: (name: string) => {
      rpcCalls.push(name);

      if (name === "process_verified_mpesa_payment") {
        return {
          data: {
            activated: true,
            subscriptionId: NEW_SUBSCRIPTION_ID,
            familyGroupId: DUPLICATE_GROUP_ID,
            familyInviteCode: "FAMILY-NEW",
          },
          error: null,
        };
      }

      if (name === "reactivate_family_group_on_resubscribe") {
        groupActive = true;
        return {
          data: {
            family_group_id: RECLAIMED_GROUP_ID,
            invite_code: "FAMILY-ABC123",
            reactivated: true,
          },
          error: null,
        };
      }

      return { data: null, error: { message: `unexpected rpc ${name}` } };
    },
    from: (table: string) => {
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

      if (table === "family_groups") {
        const filters: Record<string, unknown> = {};
        const chain: Record<string, unknown> = {};
        chain.select = () => chain;
        chain.eq = (column: string, value: unknown) => {
          filters[column] = value;
          return chain;
        };
        chain.order = () => chain;
        chain.limit = () => chain;
        chain.maybeSingle = async () => {
          if (filters.is_active === false) {
            return {
              data: { id: RECLAIMED_GROUP_ID, invite_code: "FAMILY-ABC123" },
              error: null,
            };
          }

          if (filters.is_active === true) {
            return {
              data: groupActive ? { id: RECLAIMED_GROUP_ID } : null,
              error: null,
            };
          }

          return { data: null, error: null };
        };
        chain.update = () => ({
          eq: async () => ({ data: null, error: null }),
        });
        return chain;
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

describe("PR-134 family resubscribe production path", () => {
  beforeEach(() => {
    groupActive = false;
    rpcCalls.length = 0;
    vi.resetModules();
  });

  it("processVerifiedMpesaPayment reactivates reclaimed owner group after family payment", async () => {
    const { processVerifiedMpesaPayment } = await import(
      "@/server/services/subscriptionService"
    );
    const { isFamilyGroupActiveForOwner } = await import(
      "@/server/services/familySubscriptionService"
    );

    const activation = await processVerifiedMpesaPayment({
      mpesaPaymentId: PAYMENT_ID,
      mpesaReceiptNumber: "QBD123",
      queryResultCode: 0,
      queryPayload: { ok: true },
      verifiedAmountKes: 1200,
    });

    expect(rpcCalls[0]).toBe("process_verified_mpesa_payment");
    expect(rpcCalls).toContain("reactivate_family_group_on_resubscribe");
    expect(activation.familyGroupId).toBe(RECLAIMED_GROUP_ID);
    expect(activation.familyInviteCode).toBe("FAMILY-ABC123");
    expect(await isFamilyGroupActiveForOwner(OWNER_STUDENT)).toBe(true);
  });
});
