/**
 * @vitest-environment node
 *
 * PR-047: payment endpoints must enforce durable burst limits with 429 + Retry-After.
 */
import { createHmac } from "node:crypto";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/lib/rateLimit/durableLimiter", () => ({
  checkRateLimit: vi.fn(),
}));

import { GET as statusGet } from "@/app/api/mpesa/status/route";
import { POST as stkPushPost } from "@/app/api/mpesa/stk-push/route";
import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";
import {
  buildPaymentRateLimitKeys,
  enforcePaymentBurstLimits,
  paymentRateLimitedResponse,
} from "@/lib/rateLimit/paymentBurstLimit";

const getUser = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser },
    from: (...args: unknown[]) => from(...args),
  })),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  getEffectiveSubscriptionConfig: vi.fn(async () => ({
    pricing: { premiumAmountKes: 799, familyAmountKes: 2499 },
    limits: {},
  })),
}));

vi.mock("@/lib/mpesa/mpesaClient", () => ({
  initiateStkPush: vi.fn(),
}));

const originalPepper = process.env.MPESA_CALLBACK_PEPPER;

beforeEach(() => {
  process.env.MPESA_CALLBACK_PEPPER = "test-pepper";
  vi.mocked(checkRateLimit).mockReset();
});

afterEach(() => {
  if (originalPepper === undefined) {
    delete process.env.MPESA_CALLBACK_PEPPER;
  } else {
    process.env.MPESA_CALLBACK_PEPPER = originalPepper;
  }
});

describe("payment burst limit helpers", () => {
  it("hashes IP and phone identifiers with HMAC instead of storing raw values", () => {
    const keys = buildPaymentRateLimitKeys({
      request: new Request("https://app.nexus.co/api/mpesa/stk-push", {
        headers: { "x-forwarded-for": "203.0.113.10" },
      }),
      studentId: "student-1",
      phoneNumber: "+254712345678",
      action: "stk-push",
    });

    const expectedIp = createHmac("sha256", "test-pepper")
      .update("ip:203.0.113.10")
      .digest("hex");
    const expectedPhone = createHmac("sha256", "test-pepper")
      .update("phone:254712345678")
      .digest("hex");

    expect(keys).toContain(`mpesa:stk-push:account:student-1`);
    expect(keys).toContain(`mpesa:stk-push:ip:${expectedIp}`);
    expect(keys).toContain(`mpesa:stk-push:phone:${expectedPhone}`);
  });

  it("returns a 429 response with Retry-After header", () => {
    const response = paymentRateLimitedResponse(42);
    expect(response.status).toBe(429);
    expect(response.headers.get("Retry-After")).toBe("42");
  });
});

describe("enforcePaymentBurstLimits", () => {
  it("denies when any bucket is exhausted", async () => {
    vi.mocked(checkRateLimit)
      .mockResolvedValueOnce({ allowed: true, retryAfterSeconds: 0 })
      .mockResolvedValueOnce({ allowed: false, retryAfterSeconds: 17 });

    const result = await enforcePaymentBurstLimits({
      request: new Request("https://app.nexus.co/api/mpesa/stk-push", {
        headers: { "x-forwarded-for": "203.0.113.10" },
      }),
      studentId: "student-1",
      phoneNumber: "+254712345678",
      action: "stk-push",
    });

    expect(result?.status).toBe(429);
    expect(result?.headers.get("Retry-After")).toBe("17");
    expect(checkRateLimit).toHaveBeenCalled();
  });
});

describe("payment routes — burst enforcement", () => {
  it("stk-push returns 429 + Retry-After when burst limit is exceeded", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: false,
      retryAfterSeconds: 25,
    });

    getUser.mockResolvedValue({
      data: { user: { id: "user-1" } },
      error: null,
    });

    from.mockImplementation((table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: { id: "student-1", email: "s@test.local" },
                error: null,
              }),
            }),
          }),
        };
      }
      return { select: () => ({ eq: () => ({ maybeSingle: async () => ({ data: null }) }) }) };
    });

    const response = await stkPushPost(
      new Request("https://app.nexus.co/api/mpesa/stk-push", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "x-forwarded-for": "203.0.113.10",
        },
        body: JSON.stringify({
          subscriptionPlanId: "00000000-0000-4000-8000-000000000001",
          phoneNumber: "+254712345678",
        }),
      }),
    );

    expect(response.status).toBe(429);
    expect(response.headers.get("Retry-After")).toBe("25");
  });

  it("status poll returns 429 + Retry-After when burst limit is exceeded", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: false,
      retryAfterSeconds: 12,
    });

    getUser.mockResolvedValue({
      data: { user: { id: "user-1" } },
      error: null,
    });

    from.mockImplementation((table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: { id: "student-1" },
                error: null,
              }),
            }),
          }),
        };
      }
      return { select: () => ({ eq: () => ({ maybeSingle: async () => ({ data: null }) }) }) };
    });

    const response = await statusGet(
      new Request(
        "https://app.nexus.co/api/mpesa/status?mpesaPaymentId=00000000-0000-4000-8000-000000000001",
        { headers: { "x-forwarded-for": "203.0.113.10" } },
      ),
    );

    expect(response.status).toBe(429);
    expect(response.headers.get("Retry-After")).toBe("12");
  });
});
