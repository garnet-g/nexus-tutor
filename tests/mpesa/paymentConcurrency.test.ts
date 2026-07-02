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

vi.mock("@/lib/mpesa/mpesaClient", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/mpesa/mpesaClient")>();
  return {
    ...actual,
    queryStkPush: vi.fn(async (checkoutRequestId: string) => ({
      resultCode: 0,
      resultDesc: "Success",
      checkoutRequestId,
    })),
  };
});

vi.mock("@/server/services/notificationService", () => ({
  sendPaymentSuccessNotifications: vi.fn(async () => undefined),
  sendPaymentFailedNotification: vi.fn(async () => undefined),
}));

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

describeIfIsolatedTestDatabase("M-Pesa callback concurrency", () => {
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
      .eq("plan_code", "family")
      .maybeSingle();
    if (!plan) throw new Error("Premium plan missing");
    premiumPlanId = plan.id;
  });

  it("handles parallel identical callbacks with a single verified-paid outcome", async () => {
    const admin = createAdminClient();
    const callbackSecret = generateCallbackSecret();
    const checkoutRequestId = `ws_CO_RACE_${Date.now()}`;
    const receipt = `RCPRACE${Date.now()}`;

    const { data: payment } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentId,
        subscription_plan_id: premiumPlanId,
        phone_number: "+254712345678",
        amount_kes: 2499,
        payment_status: "processing",
        checkout_request_id: checkoutRequestId,
        callback_secret_hash: hashCallbackSecret(callbackSecret),
        expires_at: new Date(Date.now() + 5 * 60 * 1000).toISOString(),
      })
      .select("id")
      .single();

    const body = JSON.stringify({
      Body: {
        stkCallback: {
          MerchantRequestID: "MRQ-RACE",
          CheckoutRequestID: checkoutRequestId,
          ResultCode: 0,
          ResultDesc: "OK",
          CallbackMetadata: {
            Item: [
              { Name: "Amount", Value: 2499 },
              { Name: "MpesaReceiptNumber", Value: receipt },
              { Name: "PhoneNumber", Value: 254712345678 },
            ],
          },
        },
      },
    });

    const context = { params: Promise.resolve({ secret: callbackSecret }) };
    const responses = await Promise.all(
      Array.from({ length: 20 }, () =>
        callbackPost(
          new Request(`http://localhost/api/mpesa/callback/${callbackSecret}`, {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body,
          }),
          context,
        ),
      ),
    );

    expect(responses.every((response) => response.status === 200)).toBe(true);

    const { data: updated } = await admin
      .from("mpesa_payments")
      .select("payment_status, mpesa_receipt_number")
      .eq("id", payment!.id)
      .maybeSingle();

    expect(updated?.payment_status).toBe("verified-paid");
    expect(updated?.mpesa_receipt_number).toBe(receipt);

    const { count } = await admin
      .from("mpesa_callback_events")
      .select("id", { count: "exact", head: true })
      .eq("checkout_request_id", checkoutRequestId);

    expect(count).toBe(1);

    const [{ count: transactionCount }, { count: invoiceCount }] = await Promise.all([
      admin
        .from("payment_transactions")
        .select("id", { count: "exact", head: true })
        .eq("mpesa_payment_id", payment!.id),
      admin
        .from("invoices")
        .select("id", { count: "exact", head: true })
        .eq("mpesa_payment_id", payment!.id),
    ]);

    const { data: billingEvents } = await admin
      .from("billing_events")
      .select("event_payload")
      .eq("event_type", "payment_received");
    const matchingBillingEvents = (billingEvents ?? []).filter(
      (event) =>
        event.event_payload &&
        typeof event.event_payload === "object" &&
        (event.event_payload as { mpesaPaymentId?: string }).mpesaPaymentId ===
          payment!.id,
    );

    const { data: activeSubscriptions } = await admin
      .from("student_subscriptions")
      .select("id")
      .eq("student_id", studentId)
      .eq("subscription_status", "active");

    const subscriptionId = activeSubscriptions?.[0]?.id;
    const { data: familyGroup } = subscriptionId
      ? await admin
          .from("family_groups")
          .select("id")
          .eq("student_subscription_id", subscriptionId)
          .maybeSingle()
      : { data: null };
    const { count: ownerMembershipCount } = familyGroup
      ? await admin
          .from("family_group_members")
          .select("id", { count: "exact", head: true })
          .eq("family_group_id", familyGroup.id)
          .eq("student_id", studentId)
      : { count: 0 };

    expect(transactionCount).toBe(1);
    expect(invoiceCount).toBe(1);
    expect(matchingBillingEvents).toHaveLength(1);
    expect(activeSubscriptions).toHaveLength(1);
    expect(familyGroup?.id).toBeTruthy();
    expect(ownerMembershipCount).toBe(1);
  }, 30_000);
});
