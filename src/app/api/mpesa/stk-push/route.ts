import "server-only";

import { NextResponse } from "next/server";

import { initiateStkPush } from "@/lib/mpesa/mpesaClient";
import { getEffectiveSubscriptionConfig } from "@/lib/platform/getPlatformSettings";
import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { mpesaStkPushSchema } from "@/schemas/mpesaSchemas";
import { resolvePlanAmountKes } from "@/server/services/subscriptionService";

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

    await getEffectiveSubscriptionConfig();
    const amountKes = await resolvePlanAmountKes(plan.plan_code);
    const expiresAt = new Date(Date.now() + 5 * 60 * 1000).toISOString();

    const { data: payment, error: paymentError } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: studentProfile.id,
        subscription_plan_id: plan.id,
        phone_number: parsed.data.phoneNumber,
        amount_kes: amountKes,
        payment_status: "pending",
        expires_at: expiresAt,
      })
      .select("id")
      .single();

    if (paymentError || !payment) {
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
      });
    } catch (error) {
      await admin
        .from("mpesa_payments")
        .update({ payment_status: "failed" })
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

    if (stkResult.isMock) {
      await admin
        .from("mpesa_payments")
        .update({
          payment_status: "paid",
          mpesa_receipt_number: `MOCK-${stkResult.checkoutRequestId}`,
          paid_at: new Date().toISOString(),
        })
        .eq("id", payment.id);

      const { activateSubscriptionFromPayment } = await import(
        "@/server/services/subscriptionService"
      );
      const { sendPaymentSuccessNotifications } = await import(
        "@/server/services/notificationService"
      );

      await activateSubscriptionFromPayment(payment.id);
      await sendPaymentSuccessNotifications({
        studentId: studentProfile.id,
        phoneNumber: parsed.data.phoneNumber,
        recipientEmail: studentProfile.email,
        amountKes,
        mpesaReceiptNumber: `MOCK-${stkResult.checkoutRequestId}`,
        planName: plan.name,
      });
    }

    return NextResponse.json({
      success: true,
      data: {
        mpesaPaymentId: payment.id,
        checkoutRequestId: stkResult.checkoutRequestId,
        amountKes,
        isMock: stkResult.isMock,
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
