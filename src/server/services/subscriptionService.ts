import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";

const TRIAL_DAYS = 7;
const SUBSCRIPTION_PERIOD_DAYS = 30;

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

  const { data: existingTrial } = await supabase
    .from("subscription_trials")
    .select("id")
    .eq("student_id", studentId)
    .maybeSingle();

  if (existingTrial) {
    throw new Error("Trial already used for this student");
  }

  const { data: premiumPlan } = await supabase
    .from("subscription_plans")
    .select("id")
    .eq("plan_code", "premium")
    .maybeSingle();

  if (!premiumPlan) {
    throw new Error("Premium subscription plan not found");
  }

  const trialStartedAt = new Date();
  const trialEndsAt = new Date(
    trialStartedAt.getTime() + TRIAL_DAYS * 24 * 60 * 60 * 1000,
  );

  await supabase.from("subscription_trials").insert({
    student_id: studentId,
    trial_started_at: trialStartedAt.toISOString(),
    trial_ends_at: trialEndsAt.toISOString(),
    is_trial_active: true,
  });

  const { data: subscription, error: subscriptionError } = await supabase
    .from("student_subscriptions")
    .insert({
      student_id: studentId,
      subscription_plan_id: premiumPlan.id,
      subscription_status: "trialing",
      trial_started_at: trialStartedAt.toISOString(),
      trial_ends_at: trialEndsAt.toISOString(),
      current_period_start: trialStartedAt.toISOString(),
      current_period_end: trialEndsAt.toISOString(),
    })
    .select("id")
    .single();

  if (subscriptionError || !subscription) {
    throw new Error(subscriptionError?.message ?? "Could not start trial subscription");
  }

  await supabase.from("billing_events").insert({
    student_subscription_id: subscription.id,
    event_type: "trial_started",
    event_payload: { trialDays: TRIAL_DAYS },
  });

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

async function billingEventExists(
  mpesaPaymentId: string,
  eventType: string,
): Promise<boolean> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("billing_events")
    .select("id, event_payload")
    .eq("event_type", eventType);

  return (
    data?.some(
      (event) =>
        event.event_payload &&
        typeof event.event_payload === "object" &&
        "mpesaPaymentId" in (event.event_payload as Record<string, unknown>) &&
        (event.event_payload as Record<string, unknown>).mpesaPaymentId ===
          mpesaPaymentId,
    ) ?? false
  );
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

export async function activateSubscriptionFromPayment(
  mpesaPaymentId: string,
): Promise<{ activated: boolean; subscriptionId?: string }> {
  const supabase = createAdminClient();

  if (await billingEventExists(mpesaPaymentId, "payment_received")) {
    return { activated: false };
  }

  const { data: payment, error: paymentError } = await supabase
    .from("mpesa_payments")
    .select(
      "id, student_id, subscription_plan_id, amount_kes, payment_status, mpesa_receipt_number, subscription_plans(plan_code)",
    )
    .eq("id", mpesaPaymentId)
    .maybeSingle();

  if (paymentError || !payment) {
    throw new Error("M-Pesa payment not found");
  }

  if (!payment.mpesa_receipt_number) {
    throw new Error("M-Pesa receipt number required for activation");
  }

  const planCode =
    payment.subscription_plans &&
    typeof payment.subscription_plans === "object" &&
    "plan_code" in payment.subscription_plans
      ? String((payment.subscription_plans as { plan_code?: string }).plan_code)
      : "premium";

  const expectedAmount = await resolvePlanAmountKes(planCode);
  if (payment.amount_kes !== expectedAmount) {
    throw new Error("Payment amount does not match plan price");
  }

  const periodStart = new Date();
  const periodEnd = new Date(
    periodStart.getTime() + SUBSCRIPTION_PERIOD_DAYS * 24 * 60 * 60 * 1000,
  );

  await supabase
    .from("mpesa_payments")
    .update({
      payment_status: "paid",
      paid_at: periodStart.toISOString(),
    })
    .eq("id", mpesaPaymentId);

  const { data: trial } = await supabase
    .from("subscription_trials")
    .select("id")
    .eq("student_id", payment.student_id)
    .eq("is_trial_active", true)
    .maybeSingle();

  if (trial) {
    await supabase
      .from("subscription_trials")
      .update({
        is_trial_active: false,
        converted_at: periodStart.toISOString(),
      })
      .eq("id", trial.id);
  }

  await supabase
    .from("student_subscriptions")
    .update({
      subscription_status: "cancelled",
      cancelled_at: periodStart.toISOString(),
    })
    .eq("student_id", payment.student_id)
    .in("subscription_status", ["trialing", "active"]);

  const { data: subscription, error: subscriptionError } = await supabase
    .from("student_subscriptions")
    .insert({
      student_id: payment.student_id,
      subscription_plan_id: payment.subscription_plan_id,
      subscription_status: "active",
      current_period_start: periodStart.toISOString(),
      current_period_end: periodEnd.toISOString(),
    })
    .select("id")
    .single();

  if (subscriptionError || !subscription) {
    throw new Error(subscriptionError?.message ?? "Could not activate subscription");
  }

  await supabase.from("payment_transactions").insert({
    mpesa_payment_id: mpesaPaymentId,
    student_subscription_id: subscription.id,
    transaction_type: "subscription_payment",
    amount_kes: payment.amount_kes,
  });

  await supabase.from("billing_events").insert({
    student_subscription_id: subscription.id,
    event_type: "payment_received",
    event_payload: {
      mpesaPaymentId,
      mpesaReceiptNumber: payment.mpesa_receipt_number,
      planCode,
    },
  });

  await supabase.from("invoices").insert({
    student_id: payment.student_id,
    mpesa_payment_id: mpesaPaymentId,
    amount_kes: payment.amount_kes,
    invoice_status: "paid",
  });

  if (planCode === "family") {
    const { data: ownerProfile } = await supabase
      .from("student_profiles")
      .select("user_id")
      .eq("id", payment.student_id)
      .maybeSingle();

    if (ownerProfile?.user_id) {
      const { createFamilyGroupForPayment } = await import(
        "@/server/services/familySubscriptionService"
      );
      await createFamilyGroupForPayment({
        ownerUserId: ownerProfile.user_id,
        ownerStudentId: payment.student_id,
        studentSubscriptionId: subscription.id,
      }).catch(() => undefined);
    }
  }

  return { activated: true, subscriptionId: subscription.id };
}

export async function updatePaymentStatus(
  mpesaPaymentId: string,
  paymentStatus: string,
): Promise<void> {
  const supabase = createAdminClient();

  await supabase
    .from("mpesa_payments")
    .update({ payment_status: paymentStatus })
    .eq("id", mpesaPaymentId);
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
): Promise<boolean> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("mpesa_callbacks")
    .select("id")
    .eq("checkout_request_id", checkoutRequestId)
    .eq("result_code", resultCode)
    .eq("is_processed", true)
    .limit(1)
    .maybeSingle();

  return Boolean(data);
}

export async function logMpesaCallback(input: {
  mpesaPaymentId: string | null;
  checkoutRequestId: string;
  callbackPayload: unknown;
  resultCode: number;
  resultDescription: string;
}): Promise<string> {
  const supabase = createAdminClient();

  const { data, error } = await supabase
    .from("mpesa_callbacks")
    .insert({
      mpesa_payment_id: input.mpesaPaymentId,
      checkout_request_id: input.checkoutRequestId,
      callback_payload: input.callbackPayload,
      result_code: input.resultCode,
      result_description: input.resultDescription,
      is_processed: false,
    })
    .select("id")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not log M-Pesa callback");
  }

  return data.id;
}

export async function markCallbackProcessed(callbackId: string): Promise<void> {
  const supabase = createAdminClient();

  await supabase
    .from("mpesa_callbacks")
    .update({
      is_processed: true,
      processed_at: new Date().toISOString(),
    })
    .eq("id", callbackId);
}

export async function markPaymentPaidFromCallback(input: {
  mpesaPaymentId: string;
  mpesaReceiptNumber: string;
}): Promise<void> {
  const supabase = createAdminClient();

  await supabase
    .from("mpesa_payments")
    .update({
      payment_status: "paid",
      mpesa_receipt_number: input.mpesaReceiptNumber,
      paid_at: new Date().toISOString(),
    })
    .eq("id", input.mpesaPaymentId);
}
