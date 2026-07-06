import "server-only";

import { NextResponse } from "next/server";

import { enforcePaymentBurstLimits } from "@/lib/rateLimit/paymentBurstLimit";
import { initiateStkPush } from "@/lib/mpesa/mpesaClient";
import {
  buildCallbackUrl,
  generateCallbackSecret,
  hashCallbackSecret,
} from "@/lib/mpesa/paymentProof";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { mpesaStkPushSchema } from "@/schemas/mpesaSchemas";
import {
  findActivePendingPayment,
  resolvePlanAmountKes,
} from "@/server/services/subscriptionService";

export async function POST(request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "UNAUTHORIZED",
            message: "Missing or invalid session.",
          },
        },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("id, email")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Student profile required.",
          },
        },
        { status: 403 },
      );
    }

    const body = await request.json();
    const parsed = mpesaStkPushSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const burstError = await enforcePaymentBurstLimits({
      request,
      studentId: studentProfile.id,
      phoneNumber: parsed.data.phoneNumber,
      action: "stk-push",
    });

    if (burstError) {
      return burstError;
    }

    const admin = createAdminClient();
    const { data: plan, error: planError } = await admin
      .from("subscription_plans")
      .select("id, plan_code, name, is_active")
      .eq("id", parsed.data.subscriptionPlanId)
      .maybeSingle();

    if (planError || !plan || !plan.is_active || plan.plan_code === "free") {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "NOT_FOUND",
            message: "Subscription plan not found.",
          },
        },
        { status: 404 },
      );
    }

    const existingPending = await findActivePendingPayment(
      studentProfile.id,
      plan.id,
    );

    if (existingPending) {
      return NextResponse.json({
        success: true,
        data: {
          mpesaPaymentId: existingPending.id,
          amountKes: existingPending.amount_kes,
          expiresAt: existingPending.expires_at,
        },
      });
    }

    await getEffectiveSubscriptionConfig();
    const amountKes = await resolvePlanAmountKes(plan.plan_code);
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000).toISOString();
    const callbackSecret = generateCallbackSecret();
    const callbackSecretHash = hashCallbackSecret(callbackSecret);

    const { data: payment, error: paymentError } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentProfile.id,
        subscription_plan_id: plan.id,
        phone_number: parsed.data.phoneNumber,
        amount_kes: amountKes,
        payment_status: "pending",
        expires_at: expiresAt,
        callback_secret_hash: callbackSecretHash,
      })
      .select("id")
      .single();

    if (paymentError || !payment) {
      const duplicatePending = await findActivePendingPayment(
        studentProfile.id,
        plan.id,
      );

      if (duplicatePending) {
        return NextResponse.json({
          success: true,
          data: {
            mpesaPaymentId: duplicatePending.id,
            amountKes: duplicatePending.amount_kes,
            expiresAt: duplicatePending.expires_at,
          },
        });
      }

      return NextResponse.json(
        {
          success: false,
          error: {
            code: "INTERNAL_ERROR",
            message: "Could not create payment record.",
          },
        },
        { status: 500 },
      );
    }

    let stkResult;

    try {
      stkResult = await initiateStkPush({
        phoneNumber: parsed.data.phoneNumber,
        amountKes,
        accountReference: payment.id.slice(0, 12),
        transactionDesc: `${plan.plan_code} plan`,
        callbackUrl: buildCallbackUrl(callbackSecret),
      });
    } catch (error) {
      await admin
        .from("mpesa_payments")
        .update({ payment_status: "verified-failed" })
        .eq("id", payment.id);

      return NextResponse.json(
        {
          success: false,
          error: {
            code: "MPESA_PAYMENT_FAILED",
            message:
              error instanceof Error ? error.message : "M-Pesa STK push failed.",
          },
        },
        { status: 502 },
      );
    }

    await admin
      .from("mpesa_payments")
      .update({
        checkout_request_id: stkResult.checkoutRequestId,
        merchant_request_id: stkResult.merchantRequestId,
        payment_status: "processing",
      })
      .eq("id", payment.id);

    return NextResponse.json({
      success: true,
      data: {
        mpesaPaymentId: payment.id,
        amountKes,
        expiresAt,
      },
    });
  } catch (error) {
    console.error("MPESA_STK_PUSH_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not initiate M-Pesa payment.",
        },
      },
      { status: 500 },
    );
  }
}
