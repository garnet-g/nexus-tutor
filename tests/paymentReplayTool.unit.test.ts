/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

vi.mock("@/lib/mpesa/mpesaClient", () => ({
  queryStkPush: vi.fn(),
}));

import { replayCallbackEvent } from "@/server/services/paymentReconciliationService";

describe("replayCallbackEvent — unit", () => {
  it("no-ops when the event is already processed and payment is terminal", async () => {
    from.mockImplementation((table: string) => {
      if (table === "mpesa_callback_events") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: {
                  id: "event-1",
                  mpesa_payment_id: "payment-1",
                  is_processed: true,
                  checkout_request_id: "ws_CO_1",
                  result_code: 0,
                },
              }),
            }),
          }),
          update: () => ({
            eq: async () => ({ error: null }),
          }),
        };
      }

      if (table === "mpesa_payments") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: { payment_status: "verified-paid" },
              }),
            }),
          }),
        };
      }

      return { select: () => ({ eq: () => ({ maybeSingle: async () => ({ data: null }) }) }) };
    });

    const result = await replayCallbackEvent("event-1");
    expect(result).toEqual({
      replayed: false,
      reason: "already_processed",
      status: "verified-paid",
    });
  });
});
