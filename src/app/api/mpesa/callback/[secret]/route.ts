import "server-only";

import { NextResponse } from "next/server";

import {
  buildMpesaAcceptResponse,
  mapMpesaResultCodeToStatus,
  parseMpesaCallbackPayload,
  queryStkPush,
} from "@/lib/mpesa/mpesaClient";
import { validateQueryProof } from "@/lib/mpesa/paymentProof";
import { isTerminal } from "@/lib/mpesa/paymentStateMachine";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  findPaymentByCallbackSecret,
  markCallbackProcessed,
  processVerifiedMpesaPayment,
  recordMpesaCallbackEvent,
  transitionMpesaPayment,
} from "@/server/services/subscriptionService";
import {
  sendPaymentFailedNotification,
  sendPaymentSuccessNotifications,
} from "@/server/services/notificationService";

interface RouteContext {
  params: Promise<{ secret: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  const { secret } = await context.params;

  const payment = await findPaymentByCallbackSecret(secret);
  if (!payment) {
    return NextResponse.json({ error: "Forbidden" }, { status: 403 });
  }

  try {
    const body = await request.json();
    const parsed = parseMpesaCallbackPayload(body);

    if (!parsed?.checkoutRequestId) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    if (isTerminal(payment.payment_status)) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    if (
      payment.checkout_request_id &&
      parsed.checkoutRequestId !== payment.checkout_request_id
    ) {
      console.error("MPESA_PAYMENT_VERIFY_FAILED", {
        paymentId: payment.id,
        reason: "checkout_mismatch",
      });
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    const eventId = await recordMpesaCallbackEvent({
      mpesaPaymentId: payment.id,
      checkoutRequestId: parsed.checkoutRequestId,
      callbackPayload: body,
      resultCode: parsed.resultCode,
      resultDescription: parsed.resultDescription,
      mpesaReceiptNumber: parsed.mpesaReceiptNumber,
    });

    if (!eventId) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    await transitionMpesaPayment({
      mpesaPaymentId: payment.id,
      toStatus: "provider-pending",
      expectedFrom: ["processing", "provider-pending"],
    });

    if (parsed.resultCode !== 0 || !parsed.mpesaReceiptNumber) {
      const nextStatus = mapMpesaResultCodeToStatus(parsed.resultCode);
      await transitionMpesaPayment({
        mpesaPaymentId: payment.id,
        toStatus: nextStatus,
        expectedFrom: ["processing", "provider-pending"],
      });

      if (nextStatus === "verified-failed" || nextStatus === "expired") {
        await notifyPaymentFailed(payment.id);
      }

      await markCallbackProcessed(eventId);
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    const queryResult = await queryStkPush(parsed.checkoutRequestId);
    const proof = validateQueryProof(
      {
        amount_kes: payment.amount_kes,
        phone_number: payment.phone_number,
      },
      queryResult,
      {
        amountKes: parsed.amountKes,
        phoneNumber: parsed.phoneNumber,
        mpesaReceiptNumber: parsed.mpesaReceiptNumber,
      },
    );

    if (!proof.valid) {
      console.error("MPESA_PAYMENT_VERIFY_FAILED", {
        paymentId: payment.id,
        reason: proof.reason,
      });

      await transitionMpesaPayment({
        mpesaPaymentId: payment.id,
        toStatus: "verified-failed",
        expectedFrom: ["processing", "provider-pending"],
      });
      await notifyPaymentFailed(payment.id);
      await markCallbackProcessed(eventId);
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    const activation = await processVerifiedMpesaPayment({
      mpesaPaymentId: payment.id,
      mpesaReceiptNumber: parsed.mpesaReceiptNumber,
      queryResultCode: queryResult.resultCode,
      queryPayload: queryResult,
      verifiedAmountKes: parsed.amountKes!,
    });

    if (activation.activated) {
      await notifyPaymentSuccess(payment.id, parsed.mpesaReceiptNumber);
    }

    await markCallbackProcessed(eventId);
    return NextResponse.json(buildMpesaAcceptResponse());
  } catch (error) {
    console.error("MPESA_CALLBACK_FAILED", error);
    return NextResponse.json(buildMpesaAcceptResponse());
  }
}

async function notifyPaymentSuccess(
  mpesaPaymentId: string,
  mpesaReceiptNumber: string,
): Promise<void> {
  const admin = createAdminClient();
  const { data: paymentDetails } = await admin
    .from("mpesa_payments")
    .select(
      "student_id, amount_kes, phone_number, subscription_plans(name), student_profiles(email)",
    )
    .eq("id", mpesaPaymentId)
    .maybeSingle();

  if (!paymentDetails) {
    return;
  }

  const planName =
    paymentDetails.subscription_plans &&
    typeof paymentDetails.subscription_plans === "object" &&
    "name" in paymentDetails.subscription_plans
      ? String((paymentDetails.subscription_plans as { name?: string }).name)
      : "Premium";

  const studentEmail =
    paymentDetails.student_profiles &&
    typeof paymentDetails.student_profiles === "object" &&
    "email" in paymentDetails.student_profiles
      ? String((paymentDetails.student_profiles as { email?: string }).email ?? "")
      : null;

  await sendPaymentSuccessNotifications({
    studentId: paymentDetails.student_id,
    phoneNumber: paymentDetails.phone_number,
    recipientEmail: studentEmail,
    amountKes: paymentDetails.amount_kes,
    mpesaReceiptNumber,
    planName,
  });
}

async function notifyPaymentFailed(mpesaPaymentId: string): Promise<void> {
  const admin = createAdminClient();
  const { data: paymentDetails } = await admin
    .from("mpesa_payments")
    .select("student_id, amount_kes, phone_number")
    .eq("id", mpesaPaymentId)
    .maybeSingle();

  if (!paymentDetails) {
    return;
  }

  await sendPaymentFailedNotification({
    studentId: paymentDetails.student_id,
    phoneNumber: paymentDetails.phone_number,
    amountKes: paymentDetails.amount_kes,
  });
}
