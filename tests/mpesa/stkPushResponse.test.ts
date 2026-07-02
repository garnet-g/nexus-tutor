/**
 * @vitest-environment node
 */
import { beforeAll, beforeEach, expect, it, vi } from "vitest";

import { POST as stkPushPost } from "@/app/api/mpesa/stk-push/route";
import { ConfigurationError, resetEnvCacheForTests } from "@/lib/env/providerModes";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  assertIsolatedTestDatabase,
  describeIfIsolatedTestDatabase,
  registerTestUserCleanup,
} from "../helpers/isolatedSupabase";

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

vi.mock("@/lib/mpesa/mpesaClient", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/mpesa/mpesaClient")>();
  return {
    ...actual,
    initiateStkPush: vi.fn(async (params: { callbackUrl?: string }) => ({
      checkoutRequestId: `ws_CO_STK_${Date.now()}`,
      merchantRequestId: "MRQ-STK",
      isMock: true,
      mockMetadata: params.callbackUrl ? undefined : { adapter: "explicit-test", isMock: true },
    })),
  };
});

async function provisionIsolatedStudent(): Promise<{ studentId: string; userId: string }> {
  const admin = createAdminClient();
  const suffix = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  const email = `mpesa-${suffix}@test.local`;
  const { data: authData, error: authError } = await admin.auth.admin.createUser({
    email,
    password: "MpesaTest1!",
    email_confirm: true,
  });

  if (authError || !authData.user) {
    throw authError ?? new Error("Could not create auth user for mpesa test");
  }
  testUserIds.push(authData.user.id);

  const { data: student, error: studentError } = await admin
    .from("student_profiles")
    .insert({
      user_id: authData.user.id,
      full_name: "Mpesa Test Student",
      email,
      curriculum: "CBC",
      grade_level: "grade_7",
    })
    .select("id")
    .single();

  if (studentError || !student) {
    throw studentError ?? new Error("Could not create student profile for mpesa test");
  }

  return { studentId: student.id, userId: authData.user.id };
}

const testUserIds: string[] = [];
registerTestUserCleanup(testUserIds);

describeIfIsolatedTestDatabase("M-Pesa STK push response shape", () => {
  let studentId: string;
  let userId: string;

  beforeAll(async () => {
    assertIsolatedTestDatabase();
    process.env.APP_ENV = "test";
    process.env.MPESA_PROVIDER_MODE = "mock";
    process.env.MPESA_CALLBACK_PEPPER = "test-pepper";
    resetEnvCacheForTests();

    ({ studentId, userId } = await provisionIsolatedStudent());
  });

  beforeEach(() => {
    vi.clearAllMocks();
    getUser.mockResolvedValue({
      data: { user: { id: userId } },
      error: null,
    });
    from.mockImplementation((table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({
                data: { id: studentId, email: "student@nexus.local" },
                error: null,
              }),
            }),
          }),
        };
      }
      return { select: () => ({ eq: () => ({ maybeSingle: async () => ({ data: null }) }) }) };
    });
  });

  it("omits checkoutRequestId and isMock from stk-push JSON response", async () => {
    const admin = createAdminClient();
    const { data: plan } = await admin
      .from("subscription_plans")
      .select("id")
      .eq("plan_code", "premium")
      .maybeSingle();

    const response = await stkPushPost(
      new Request("http://localhost/api/mpesa/stk-push", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          subscriptionPlanId: plan!.id,
          phoneNumber: "+254712345678",
        }),
      }),
    );

    const payload = await response.json();
    expect(response.status).toBe(200);
    expect(payload.success).toBe(true);
    expect(payload.data).toMatchObject({
      mpesaPaymentId: expect.any(String),
      amountKes: expect.any(Number),
      expiresAt: expect.any(String),
    });
    expect(payload.data.checkoutRequestId).toBeUndefined();
    expect(payload.data.isMock).toBeUndefined();
  });

  it("rejects production live STK without Daraja credentials", async () => {
    const actual = await vi.importActual<typeof import("@/lib/mpesa/mpesaClient")>(
      "@/lib/mpesa/mpesaClient",
    );

    process.env.APP_ENV = "production";
    process.env.MPESA_PROVIDER_MODE = "sandbox";
    delete process.env.MPESA_CONSUMER_KEY;
    delete process.env.MPESA_CONSUMER_SECRET;
    delete process.env.MPESA_PASSKEY;
    delete process.env.MPESA_SHORTCODE;
    resetEnvCacheForTests();

    await expect(
      actual.initiateStkPush({
        phoneNumber: "+254712345678",
        amountKes: 799,
        accountReference: "TEST",
        transactionDesc: "premium plan",
        callbackUrl: "http://localhost:3000/api/mpesa/callback/secret",
      }),
    ).rejects.toBeInstanceOf(ConfigurationError);

    process.env.APP_ENV = "test";
    process.env.MPESA_PROVIDER_MODE = "mock";
    resetEnvCacheForTests();
  });
});
