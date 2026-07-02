/**
 * @vitest-environment node
 */
import { beforeAll, beforeEach, expect, it, vi } from "vitest";

import { POST as stkPushPost } from "@/app/api/mpesa/stk-push/route";
import { resetEnvCacheForTests } from "@/lib/env/providerModes";
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
    initiateStkPush: vi.fn(async () => ({
      checkoutRequestId: `ws_CO_DUP_${Date.now()}`,
      merchantRequestId: "MRQ-DUP",
      isMock: true,
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

describeIfIsolatedTestDatabase("M-Pesa duplicate pending suppression", () => {
  let premiumPlanId: string;
  let studentId: string;
  let userId: string;

  beforeAll(async () => {
    assertIsolatedTestDatabase();
    process.env.APP_ENV = "test";
    process.env.MPESA_PROVIDER_MODE = "mock";
    process.env.MPESA_CALLBACK_PEPPER = "test-pepper";
    resetEnvCacheForTests();

    ({ studentId, userId } = await provisionIsolatedStudent());

    const admin = createAdminClient();
    const { data: plan } = await admin
      .from("subscription_plans")
      .select("id")
      .eq("plan_code", "premium")
      .maybeSingle();
    if (!plan) throw new Error("Premium plan missing");
    premiumPlanId = plan.id;
  });

  beforeEach(() => {
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

  it("returns the same mpesaPaymentId when STK push is double-clicked", async () => {
    const admin = createAdminClient();

    const requestBody = JSON.stringify({
      subscriptionPlanId: premiumPlanId,
      phoneNumber: "+254712345678",
    });

    const firstResponse = await stkPushPost(
      new Request("http://localhost/api/mpesa/stk-push", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: requestBody,
      }),
    );

    const secondResponse = await stkPushPost(
      new Request("http://localhost/api/mpesa/stk-push", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: requestBody,
      }),
    );

    const firstPayload = await firstResponse.json();
    const secondPayload = await secondResponse.json();

    expect(firstPayload.success).toBe(true);
    expect(secondPayload.success).toBe(true);
    expect(secondPayload.data.mpesaPaymentId).toBe(firstPayload.data.mpesaPaymentId);

    const { count } = await admin
      .from("mpesa_payments")
      .select("id", { count: "exact", head: true })
      .eq("student_id", studentId)
      .eq("subscription_plan_id", premiumPlanId)
      .in("payment_status", ["pending", "processing", "provider-pending"]);

    expect(count).toBe(1);
  });
});
