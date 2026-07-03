import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { canTransition } from "@/lib/mpesa/paymentStateMachine";
import {
  buildCallbackIdempotencyKey,
  hashCallbackSecret,
} from "@/lib/mpesa/paymentProof";

const TRIAL_DAYS = 7;

export async function getStudentPlanCode(studentId: string): Promise<string> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("student_subscriptions")
    .select("subscription_status, subscription_plans(plan_code)")
    .eq("student_id", studentId)
    .in("subscription_status", ["trialing", "active"])
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const planCode =
    data?.subscription_plans &&
    typeof data.subscription_plans === "object" &&
    "plan_code" in data.subscription_plans
      ? String((data.subscription_plans as { plan_code?: string }).plan_code ?? "free")
      : "free";

  return planCode;
}

export async function hasUsedFreeTrial(studentId: string): Promise<boolean> {
  const supabase = createAdminClient();
  const { data } = await supabase
    .from("subscription_trials")
    .select("id")
    .eq("student_id", studentId)
    .maybeSingle();

  return Boolean(data);
}

export function canAccessExamStudyPlan(planCode: string): boolean {
  return planCode === "premium" || planCode === "family";
}

async function getFreePlanId(): Promise<string> {
  const supabase = createAdminClient();
  const { data, error } = await supabase
    .from("subscription_plans")
    .select("id")
    .eq("plan_code", "free")
    .maybeSingle();

  if (error || !data) {
    throw new Error("Free subscription plan not found");
  }

  return data.id;
}

export async function ensureFreeSubscription(studentId: string): Promise<void> {
  const supabase = createAdminClient();

  const { data: existing } = await supabase
    .from("student_subscriptions")
    .select("id")
    .eq("student_id", studentId)
    .limit(1)
    .maybeSingle();

  if (existing) {
    return;
  }

  const freePlanId = await getFreePlanId();
  const now = new Date();

  await supabase.from("student_subscriptions").insert({
    student_id: studentId,
    subscription_plan_id: freePlanId,
    subscription_status: "active",
    current_period_start: now.toISOString(),
    current_period_end: null,
  });
}

export async function startFreeTrial(studentId: string): Promise<{
  trialEndsAt: string;
}> {
  const supabase = createAdminClient();

  const { data: premiumPlan } = await supabase
    .from("subscription_plans")
    .select("id")
    .eq("plan_code", "premium")
    .maybeSingle();

  if (!premiumPlan) {
    throw new Error("Premium subscription plan not found");
  }

  // Trial row (unique per student), trialing subscription, and billing event are
  // inserted in one transaction (start_trial_atomic). ON CONFLICT DO NOTHING on
  // subscription_trials makes concurrent trial starts race-safe: only the first
  // succeeds, the rest raise TRIAL_ALREADY_USED (PR-091).
  const { data, error } = await supabase.rpc("start_trial_atomic", {
    p_student_id: studentId,
    p_premium_plan_id: premiumPlan.id,
    p_trial_days: TRIAL_DAYS,
  });

  if (error) {
    if (error.message.includes("TRIAL_ALREADY_USED")) {
      throw new Error("Trial already used for this student");
    }
    throw new Error(error.message || "Could not start trial subscription");
  }

  if (!data || typeof data !== "object") {
    throw new Error("Could not start trial subscription");
  }

  const trialEndsAt = new Date(
    String((data as Record<string, unknown>).trial_ends_at),
  );

  const { data: studentProfile } = await supabase
    .from("student_profiles")
    .select("phone_number")
    .eq("id", studentId)
    .maybeSingle();

  const { sendTrialEndingNotification } = await import(
    "@/server/services/notificationService"
  );
  await sendTrialEndingNotification({
    studentId,
    phoneNumber: studentProfile?.phone_number ?? null,
    daysRemaining: TRIAL_DAYS,
  }).catch(() => undefined);

  return { trialEndsAt: trialEndsAt.toISOString() };
}

export async function resolvePlanAmountKes(planCode: string): Promise<number> {
  const config = await getEffectiveSubscriptionConfig();

  if (planCode === "family") {
    return config.pricing.familyAmountKes;
  }

  if (planCode === "premium") {
    return config.pricing.premiumAmountKes;
  }

  return 0;
}

export interface ProcessVerifiedMpesaPaymentInput {
  mpesaPaymentId: string;
  mpesaReceiptNumber: string;
  queryResultCode: number;
  queryPayload: unknown;
  verifiedAmountKes: number;
}

export interface ProcessVerifiedMpesaPaymentResult {
  activated: boolean;
  subscriptionId?: string;
  familyGroupId?: string;
  familyInviteCode?: string;
}

export async function processVerifiedMpesaPayment(
  input: ProcessVerifiedMpesaPaymentInput,
): Promise<ProcessVerifiedMpesaPaymentResult> {
  const supabase = createAdminClient();
  const config = await getEffectiveSubscriptionConfig();
  const { data, error } = await supabase.rpc("process_verified_mpesa_payment", {
    p_payment_id: input.mpesaPaymentId,
    p_receipt: input.mpesaReceiptNumber,
    p_query_result_code: input.queryResultCode,
    p_query_payload: input.queryPayload,
    p_expected_amount: input.verifiedAmountKes,
    p_family_max_seats: config.limits.familyMaxStudents,
  });

  if (error) {
    throw new Error(error.message);
  }

  if (!data || typeof data !== "object") {
    throw new Error("Payment activation returned an invalid result");
  }

  const result = data as Record<string, unknown>;
  return {
    activated: result.activated === true,
    subscriptionId:
      typeof result.subscriptionId === "string" ? result.subscriptionId : undefined,
    familyGroupId:
      typeof result.familyGroupId === "string" ? result.familyGroupId : undefined,
    familyInviteCode:
      typeof result.familyInviteCode === "string"
        ? result.familyInviteCode
        : undefined,
  };
}

export async function updatePaymentStatus(
  mpesaPaymentId: string,
  paymentStatus: string,
): Promise<void> {
  const supabase = createAdminClient();

  const { data: payment } = await supabase
    .from("mpesa_payments")
    .select("payment_status")
    .eq("id", mpesaPaymentId)
    .maybeSingle();

  if (!payment) {
    throw new Error("M-Pesa payment not found");
  }

  if (!canTransition(payment.payment_status, paymentStatus)) {
    return;
  }

  await supabase
    .from("mpesa_payments")
    .update({ payment_status: paymentStatus })
    .eq("id", mpesaPaymentId);
}

export async function transitionMpesaPayment(input: {
  mpesaPaymentId: string;
  toStatus: string;
  expectedFrom: string[];
}): Promise<boolean> {
  const supabase = createAdminClient();

  const { data, error } = await supabase.rpc("transition_mpesa_payment", {
    p_payment_id: input.mpesaPaymentId,
    p_to_status: input.toStatus,
    p_expected_from: input.expectedFrom,
  });

  if (error) {
    throw new Error(error.message);
  }

  return Boolean(data);
}

export async function verifyAndMarkMpesaPaid(input: {
  mpesaPaymentId: string;
  mpesaReceiptNumber: string;
  queryResultCode: number;
  queryPayload?: unknown;
}): Promise<boolean> {
  const supabase = createAdminClient();

  const { data, error } = await supabase.rpc("verify_and_mark_mpesa_paid", {
    p_payment_id: input.mpesaPaymentId,
    p_receipt: input.mpesaReceiptNumber,
    p_query_result_code: input.queryResultCode,
    p_query_payload: input.queryPayload ?? {},
  });

  if (error) {
    throw new Error(error.message);
  }

  return Boolean(data);
}

export async function findActivePendingPayment(
  studentId: string,
  subscriptionPlanId: string,
): Promise<{
  id: string;
  amount_kes: number;
  expires_at: string | null;
} | null> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("mpesa_payments")
    .select("id, amount_kes, expires_at")
    .eq("student_id", studentId)
    .eq("subscription_plan_id", subscriptionPlanId)
    .in("payment_status", ["pending", "processing", "provider-pending"])
    .maybeSingle();

  if (!data) {
    return null;
  }

  if (data.expires_at && new Date(data.expires_at).getTime() < Date.now()) {
    return null;
  }

  return data;
}

export async function findPaymentByCallbackSecret(secret: string): Promise<{
  id: string;
  payment_status: string;
  checkout_request_id: string | null;
  amount_kes: number;
  phone_number: string;
  student_id: string;
  subscription_plan_id: string;
  mpesa_receipt_number: string | null;
} | null> {
  const supabase = createAdminClient();
  const secretHash = hashCallbackSecret(secret);

  const { data } = await supabase
    .from("mpesa_payments")
    .select(
      "id, payment_status, checkout_request_id, amount_kes, phone_number, student_id, subscription_plan_id, mpesa_receipt_number",
    )
    .eq("callback_secret_hash", secretHash)
    .maybeSingle();

  return data;
}

export async function findPaymentByCheckoutRequestId(
  checkoutRequestId: string,
): Promise<{
  id: string;
  payment_status: string;
} | null> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("mpesa_payments")
    .select("id, payment_status")
    .eq("checkout_request_id", checkoutRequestId)
    .maybeSingle();

  return data;
}

export async function isCallbackAlreadyProcessed(
  checkoutRequestId: string,
  resultCode: number,
  mpesaReceiptNumber: string | null = null,
): Promise<boolean> {
  const supabase = createAdminClient();
  const idempotencyKey = buildCallbackIdempotencyKey({
    checkoutRequestId,
    resultCode,
    mpesaReceiptNumber,
  });

  const { data } = await supabase
    .from("mpesa_callback_events")
    .select("id")
    .eq("idempotency_key", idempotencyKey)
    .limit(1)
    .maybeSingle();

  return Boolean(data);
}

export async function recordMpesaCallbackEvent(input: {
  mpesaPaymentId: string;
  checkoutRequestId: string;
  callbackPayload: unknown;
  resultCode: number;
  resultDescription: string;
  mpesaReceiptNumber?: string | null;
  eventSource?: "daraja_callback" | "stk_query" | "reconciliation";
}): Promise<string | null> {
  const supabase = createAdminClient();
  const idempotencyKey = buildCallbackIdempotencyKey({
    checkoutRequestId: input.checkoutRequestId,
    resultCode: input.resultCode,
    mpesaReceiptNumber: input.mpesaReceiptNumber ?? null,
  });

  const { data, error } = await supabase.rpc("record_mpesa_callback_event", {
    p_idempotency_key: idempotencyKey,
    p_mpesa_payment_id: input.mpesaPaymentId,
    p_checkout_request_id: input.checkoutRequestId,
    p_callback_payload: input.callbackPayload,
    p_result_code: input.resultCode,
    p_result_description: input.resultDescription,
    p_event_source: input.eventSource ?? "daraja_callback",
  });

  if (error) {
    throw new Error(error.message);
  }

  return data ? String(data) : null;
}

export async function markCallbackProcessed(callbackId: string): Promise<void> {
  const supabase = createAdminClient();

  await supabase
    .from("mpesa_callback_events")
    .update({
      is_processed: true,
      processed_at: new Date().toISOString(),
    })
    .eq("id", callbackId);
}

/** @deprecated Use recordMpesaCallbackEvent — kept for transitional imports */
export async function logMpesaCallback(input: {
  mpesaPaymentId: string | null;
  checkoutRequestId: string;
  callbackPayload: unknown;
  resultCode: number;
  resultDescription: string;
}): Promise<string> {
  if (!input.mpesaPaymentId) {
    throw new Error("mpesaPaymentId required");
  }

  const eventId = await recordMpesaCallbackEvent({
    mpesaPaymentId: input.mpesaPaymentId,
    checkoutRequestId: input.checkoutRequestId,
    callbackPayload: input.callbackPayload,
    resultCode: input.resultCode,
    resultDescription: input.resultDescription,
  });

  if (!eventId) {
    throw new Error("Duplicate callback event");
  }

  return eventId;
}

export async function markPaymentVerifiedFailed(mpesaPaymentId: string): Promise<void> {
  await transitionMpesaPayment({
    mpesaPaymentId,
    toStatus: "verified-failed",
    expectedFrom: ["processing", "provider-pending"],
  });
}
