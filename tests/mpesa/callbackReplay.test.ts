/**
 * @vitest-environment node
 */
import { beforeAll, expect, it, vi } from "vitest";

import { POST as callbackPost } from "@/app/api/mpesa/callback/[secret]/route";
import {
  generateCallbackSecret,
  hashCallbackSecret,
} from "@/lib/mpesa/paymentProof";
import { createAdminClient } from "@/lib/supabase/admin";
import { resetEnvCacheForTests } from "@/lib/env/providerModes";
import {
  assertIsolatedTestDatabase,
  describeIfIsolatedTestDatabase,
  registerTestUserCleanup,
} from "../helpers/isolatedSupabase";

const { queryStkPush } = vi.hoisted(() => ({
  queryStkPush: vi.fn(async () => ({
    resultCode: 0,
    resultDesc: "Success",
    checkoutRequestId: "ws_CO_REPLAY",
  })),
}));

vi.mock("@/lib/mpesa/mpesaClient", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/mpesa/mpesaClient")>();
  return {
    ...actual,
    queryStkPush,
  };
});

vi.mock("@/server/services/notificationService", () => ({
  sendPaymentSuccessNotifications: vi.fn(async () => undefined),
  sendPaymentFailedNotification: vi.fn(async () => undefined),
}));

vi.mock("@/server/services/subscriptionService", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/server/services/subscriptionService")>();
  return {
    ...actual,
    processVerifiedMpesaPayment: vi.fn(async () => ({
      activated: true,
      subscriptionId: "00000000-0000-4000-8000-000000000099",
    })),
  };
});

async function provisionIsolatedStudent(): Promise<string> {
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

  return student.id;
}

const testUserIds: string[] = [];
registerTestUserCleanup(testUserIds);

describeIfIsolatedTestDatabase("M-Pesa callback replay", () => {
  let premiumPlanId: string;
  let studentId: string;

  beforeAll(async () => {
    assertIsolatedTestDatabase();
    process.env.APP_ENV = "test";
    process.env.MPESA_PROVIDER_MODE = "mock";
    process.env.MPESA_CALLBACK_PEPPER = "test-pepper";
    resetEnvCacheForTests();

    studentId = await provisionIsolatedStudent();

    const admin = createAdminClient();
    const { data: plan } = await admin
      .from("subscription_plans")
      .select("id")
      .eq("plan_code", "premium")
      .maybeSingle();
    if (!plan) throw new Error("Premium plan missing");
    premiumPlanId = plan.id;
  });

  it("accepts duplicate callback idempotently without double activation", async () => {
    const admin = createAdminClient();
    const callbackSecret = generateCallbackSecret();
    const checkoutRequestId = `ws_CO_REPLAY_${Date.now()}`;
    const receipt = `RCPREPLAY${Date.now()}`;

    const { data: payment } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentId,
        subscription_plan_id: premiumPlanId,
        phone_number: "+254712345678",
        amount_kes: 799,
        payment_status: "processing",
        checkout_request_id: checkoutRequestId,
        callback_secret_hash: hashCallbackSecret(callbackSecret),
        expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString(),
      })
      .select("id")
      .single();

    const body = {
      Body: {
        stkCallback: {
          MerchantRequestID: "MRQ-REPLAY",
          CheckoutRequestID: checkoutRequestId,
          ResultCode: 0,
          ResultDesc: "OK",
          CallbackMetadata: {
            Item: [
              { Name: "Amount", Value: 799 },
              { Name: "MpesaReceiptNumber", Value: receipt },
              { Name: "PhoneNumber", Value: 254712345678 },
            ],
          },
        },
      },
    };

    const request = new Request(`http://localhost/api/mpesa/callback/${callbackSecret}`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify(body),
    });
    const context = { params: Promise.resolve({ secret: callbackSecret }) };

    const first = await callbackPost(request.clone(), context);
    const second = await callbackPost(request.clone(), context);

    expect(first.status).toBe(200);
    expect(second.status).toBe(200);

    const { data: updated } = await admin
      .from("mpesa_payments")
      .select("payment_status")
      .eq("id", payment!.id)
      .maybeSingle();

    expect(updated?.payment_status).toBe("verified-paid");

    const { count } = await admin
      .from("mpesa_callback_events")
      .select("id", { count: "exact", head: true })
      .eq("checkout_request_id", checkoutRequestId);

    expect(count).toBe(1);
  }, 30_000);
});
