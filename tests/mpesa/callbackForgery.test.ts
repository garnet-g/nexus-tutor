/**
 * @vitest-environment node
 */
import { existsSync } from "node:fs";
import { join } from "node:path";
import { afterEach, beforeAll, expect, it, vi } from "vitest";

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

vi.mock("@/lib/mpesa/mpesaClient", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/mpesa/mpesaClient")>();
  return {
    ...actual,
    queryStkPush: vi.fn(async () => ({
      resultCode: 0,
      resultDesc: "Success",
      checkoutRequestId: "ws_CO_CHECKOUT",
    })),
  };
});

vi.mock("@/server/services/notificationService", () => ({
  sendPaymentSuccessNotifications: vi.fn(async () => undefined),
  sendPaymentFailedNotification: vi.fn(async () => undefined),
}));

function buildSuccessCallback(checkoutRequestId: string, amountKes: number) {
  return {
    Body: {
      stkCallback: {
        MerchantRequestID: "MRQ-FORGE",
        CheckoutRequestID: checkoutRequestId,
        ResultCode: 0,
        ResultDesc: "The service request is processed successfully.",
        CallbackMetadata: {
          Item: [
            { Name: "Amount", Value: amountKes },
            { Name: "MpesaReceiptNumber", Value: `RCP${Date.now()}` },
            { Name: "PhoneNumber", Value: 254712345678 },
          ],
        },
      },
    },
  };
}

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

describeIfIsolatedTestDatabase("M-Pesa callback forgery resistance", () => {
  let premiumPlanId: string;
  let studentId: string;

  beforeAll(async () => {
    assertIsolatedTestDatabase();
    process.env.APP_ENV = "test";
    process.env.MPESA_PROVIDER_MODE = "mock";
    process.env.MPESA_CALLBACK_PEPPER = "test-pepper";
    resetEnvCacheForTests();

    ({ studentId } = await provisionIsolatedStudent());

    const admin = createAdminClient();
    const { data: plan } = await admin
      .from("subscription_plans")
      .select("id")
      .eq("plan_code", "premium")
      .maybeSingle();

    if (!plan) {
      throw new Error("Premium plan missing — run npm run db:reset");
    }

    premiumPlanId = plan.id;
  });

  afterEach(() => {
    vi.clearAllMocks();
  });

  it("removed the unauthenticated flat /api/mpesa/callback route", () => {
    const flatRoute = join(process.cwd(), "src/app/api/mpesa/callback/route.ts");
    expect(existsSync(flatRoute)).toBe(false);
  });

  it("returns 403 for unknown callback secret without Daraja accept body", async () => {
    const response = await callbackPost(
      new Request("http://localhost/api/mpesa/callback/bad-secret", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(buildSuccessCallback("ws_CO_GUESSED", 799)),
      }),
      { params: Promise.resolve({ secret: "bad-secret-value" }) },
    );

    expect(response.status).toBe(403);
    const body = await response.json();
    expect(body.ResultCode).toBeUndefined();
  });

  it("does not activate subscription when attacker forges success with guessed checkout id", async () => {
    const admin = createAdminClient();
    const callbackSecret = generateCallbackSecret();
    const checkoutRequestId = `ws_CO_FORGE_${Date.now()}`;

    const { data: payment, error } = await admin
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

    expect(error).toBeNull();
    expect(payment?.id).toBeTruthy();

    const forgedCheckout = `ws_CO_ATTACKER_${Date.now()}`;
    const response = await callbackPost(
      new Request(`http://localhost/api/mpesa/callback/${callbackSecret}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(buildSuccessCallback(forgedCheckout, 799)),
      }),
      { params: Promise.resolve({ secret: callbackSecret }) },
    );

    expect(response.status).toBe(200);
    const accept = await response.json();
    expect(accept.ResultCode).toBe(0);

    const { data: updated } = await admin
      .from("mpesa_payments")
      .select("payment_status")
      .eq("id", payment!.id)
      .maybeSingle();

    expect(updated?.payment_status).not.toBe("verified-paid");

    const { data: billingEvents } = await admin
      .from("billing_events")
      .select("event_payload")
      .eq("event_type", "payment_received");

    const activated = billingEvents?.some(
      (event) =>
        event.event_payload &&
        typeof event.event_payload === "object" &&
        (event.event_payload as { mpesaPaymentId?: string }).mpesaPaymentId ===
          payment!.id,
    );

    expect(activated).toBeFalsy();
  });
});
