/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type Row = Record<string, unknown>;

const manualVerifications: Row[] = [];
const mpesaPayments: Row[] = [];
let insertShouldConflict = false;

function chain(result: Promise<{ data: unknown; error: unknown }>) {
  const builder = {
    select: () => builder,
    eq: () => builder,
    maybeSingle: () => result,
    single: () => result,
  };
  return builder;
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "subscription_plans") {
        return chain(
          Promise.resolve({
            data: { id: "plan-1", plan_code: "premium_daily", amount_kes: 20 },
            error: null,
          }),
        );
      }

      if (table === "mpesa_manual_verifications") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: manualVerifications.find((r) => r.mpesa_receipt_number)
                  ? manualVerifications[0]
                  : null,
                error: null,
              }),
            }),
          }),
          insert: (row: Row) => ({
            select: () => ({
              single: async () => {
                if (insertShouldConflict) {
                  return { data: null, error: { code: "23505", message: "duplicate" } };
                }
                const created = { id: `mv-${manualVerifications.length + 1}`, ...row };
                manualVerifications.push(created);
                return { data: created, error: null };
              },
            }),
          }),
          update: () => ({ eq: async () => ({ data: null, error: null }) }),
        };
      }

      if (table === "mpesa_payments") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: mpesaPayments.find(() => false) ?? null,
                error: null,
              }),
            }),
          }),
          insert: (row: Row) => ({
            select: () => ({
              single: async () => {
                const created = { id: `payment-${mpesaPayments.length + 1}`, ...row };
                mpesaPayments.push(created);
                return { data: created, error: null };
              },
            }),
          }),
        };
      }

      return chain(Promise.resolve({ data: null, error: null }));
    },
  })),
}));

vi.mock("@/lib/env/providerModes", () => ({
  isMpesaMockAllowed: vi.fn(() => true),
  assertMpesaConfiguredForLiveMode: vi.fn(),
  isMpesaConfigured: vi.fn(() => false),
  createMockAdapterMetadata: vi.fn(() => ({ adapter: "explicit-test", isMock: true })),
}));

vi.mock("@/server/services/subscriptionService", () => ({
  processVerifiedMpesaPayment: vi.fn(async () => ({
    activated: true,
    subscriptionId: "sub-1",
  })),
}));

describe("verifyManualMpesaCode", () => {
  beforeEach(() => {
    manualVerifications.length = 0;
    mpesaPayments.length = 0;
    insertShouldConflict = false;
    vi.resetModules();
  });

  it("rejects malformed transaction codes without hitting the database", async () => {
    const { verifyManualMpesaCode } = await import(
      "@/server/services/reconcileService"
    );

    const result = await verifyManualMpesaCode({
      studentId: "student-1",
      subscriptionPlanId: "plan-1",
      mpesaCode: "!!!",
    });

    expect(result.status).toBe("rejected");
    expect(result.activated).toBe(false);
  });

  it("auto-verifies and activates in sandbox mode", async () => {
    const { verifyManualMpesaCode } = await import(
      "@/server/services/reconcileService"
    );
    const { processVerifiedMpesaPayment } = await import(
      "@/server/services/subscriptionService"
    );

    const result = await verifyManualMpesaCode({
      studentId: "student-1",
      subscriptionPlanId: "plan-1",
      mpesaCode: "QAB1C2D3E4",
    });

    expect(result.status).toBe("verified");
    expect(result.activated).toBe(true);
    expect(processVerifiedMpesaPayment).toHaveBeenCalledTimes(1);
  });

  it("rejects a transaction code that has already been used (idempotent dedup)", async () => {
    const { verifyManualMpesaCode } = await import(
      "@/server/services/reconcileService"
    );

    insertShouldConflict = true;

    const result = await verifyManualMpesaCode({
      studentId: "student-1",
      subscriptionPlanId: "plan-1",
      mpesaCode: "QAB1C2D3E4",
    });

    expect(result.status).toBe("rejected");
    expect(result.activated).toBe(false);
  });
});
