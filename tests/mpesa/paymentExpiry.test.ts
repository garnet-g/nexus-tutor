/**
 * @vitest-environment node
 */
import { beforeAll, expect, it } from "vitest";

import { hashCallbackSecret } from "@/lib/mpesa/paymentProof";
import { createAdminClient } from "@/lib/supabase/admin";
import { expireStalePayments } from "@/server/services/paymentReconciliationService";
import {
  assertIsolatedTestDatabase,
  describeIfIsolatedTestDatabase,
  registerTestUserCleanup,
} from "../helpers/isolatedSupabase";

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

describeIfIsolatedTestDatabase("M-Pesa payment expiry reconciliation", () => {
  let premiumPlanId: string;
  let studentId: string;

  beforeAll(async () => {
    assertIsolatedTestDatabase();
    process.env.MPESA_CALLBACK_PEPPER = "test-pepper";

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

  it("expires stale processing payments via reconciliation sweep", async () => {
    const admin = createAdminClient();
    const checkoutRequestId = `ws_CO_EXPIRE_${Date.now()}`;

    const { data: payment } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentId,
        subscription_plan_id: premiumPlanId,
        phone_number: "+254712345678",
        amount_kes: 2499,
        payment_status: "processing",
        checkout_request_id: checkoutRequestId,
        callback_secret_hash: hashCallbackSecret("expire-secret"),
        expires_at: new Date(Date.now() - 60_000).toISOString(),
      })
      .select("id")
      .single();

    const expiredCount = await expireStalePayments();
    expect(expiredCount).toBeGreaterThanOrEqual(1);

    const { data: updated } = await admin
      .from("mpesa_payments")
      .select("payment_status")
      .eq("id", payment!.id)
      .maybeSingle();

    expect(updated?.payment_status).toBe("expired");
  });
});
