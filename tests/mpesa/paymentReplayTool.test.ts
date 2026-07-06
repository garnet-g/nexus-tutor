/**
 * @vitest-environment node
 *
 * PR-077: operator replay of stored callback events must be idempotent.
 */
import { beforeAll, expect, it, vi } from "vitest";

import { replayCallbackEvent } from "@/server/services/paymentReconciliationService";
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
    checkoutRequestId: "ws_CO_REPLAY_TOOL",
  })),
}));

vi.mock("@/lib/mpesa/mpesaClient", async (importOriginal) => {
  const actual = await importOriginal<typeof import("@/lib/mpesa/mpesaClient")>();
  return {
    ...actual,
    queryStkPush,
  };
});

async function provisionIsolatedStudent(): Promise<string> {
  const admin = createAdminClient();
  const suffix = `${Date.now()}-${Math.random().toString(36).slice(2, 8)}`;
  const email = `replay-${suffix}@test.local`;
  const { data: authData, error: authError } = await admin.auth.admin.createUser({
    email,
    password: "ReplayTest1!",
    email_confirm: true,
  });

  if (authError || !authData.user) {
    throw authError ?? new Error("Could not create auth user");
  }
  testUserIds.push(authData.user.id);

  const { data: student, error: studentError } = await admin
    .from("student_profiles")
    .insert({
      user_id: authData.user.id,
      full_name: "Replay Test Student",
      email,
      curriculum: "CBC",
      grade_level: "grade_7",
    })
    .select("id")
    .single();

  if (studentError || !student) {
    throw studentError ?? new Error("Could not create student profile");
  }

  return student.id;
}

const testUserIds: string[] = [];
registerTestUserCleanup(testUserIds);

describeIfIsolatedTestDatabase("payment callback replay tool", () => {
  let studentId: string;
  let premiumPlanId: string;

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

  it("replays a fixture callback event and no-ops on second replay when already processed", async () => {
    const admin = createAdminClient();
    const checkoutRequestId = `ws_CO_TOOL_${Date.now()}`;
    const callbackSecret = generateCallbackSecret();
    const receipt = `RCPTOOL${Date.now()}`;

    const { data: payment } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentId,
        subscription_plan_id: premiumPlanId,
        phone_number: "+254712345678",
        amount_kes: 799,
        payment_status: "verified-paid",
        checkout_request_id: checkoutRequestId,
        mpesa_receipt_number: receipt,
        callback_secret_hash: hashCallbackSecret(callbackSecret),
      })
      .select("id")
      .single();

    if (!payment) throw new Error("payment insert failed");

    const { data: event } = await admin
      .from("mpesa_callback_events")
      .insert({
        mpesa_payment_id: payment.id,
        checkout_request_id: checkoutRequestId,
        callback_payload: { Body: { stkCallback: { ResultCode: 0 } } },
        result_code: 0,
        result_description: "Success",
        idempotency_key: `stk:${checkoutRequestId}:0:${receipt}`,
        event_source: "daraja_callback",
        is_processed: true,
        processed_at: new Date().toISOString(),
      })
      .select("id")
      .single();

    if (!event) throw new Error("event insert failed");

    const first = await replayCallbackEvent(event.id);
    expect(first.replayed).toBe(false);
    expect(first.reason).toBe("already_processed");

    const second = await replayCallbackEvent(event.id);
    expect(second.replayed).toBe(false);
    expect(second.reason).toBe("already_processed");
  });
});
