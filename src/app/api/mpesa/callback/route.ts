import "server-only";

import { NextResponse } from "next/server";

import {
  buildMpesaAcceptResponse,
  mapMpesaResultCodeToStatus,
  parseMpesaCallbackPayload,
} from "@/lib/mpesa/mpesaClient";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  activateSubscriptionFromPayment,
  findPaymentByCheckoutRequestId,
  isCallbackAlreadyProcessed,
  logMpesaCallback,
  markCallbackProcessed,
  markPaymentPaidFromCallback,
  updatePaymentStatus,
} from "@/server/services/subscriptionService";
import {
  sendPaymentFailedNotification,
  sendPaymentSuccessNotifications,
} from "@/server/services/notificationService";

export async function POST(request: Request) {
  try {
    const body = await request.json();
    const parsed = parseMpesaCallbackPayload(body);

    if (!parsed?.checkoutRequestId) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    if (
      await isCallbackAlreadyProcessed(
        parsed.checkoutRequestId,
        parsed.resultCode,
      )
    ) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    const payment = await findPaymentByCheckoutRequestId(parsed.checkoutRequestId);

    if (!payment) {
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    const callbackId = await logMpesaCallback({
      mpesaPaymentId: payment.id,
      checkoutRequestId: parsed.checkoutRequestId,
      callbackPayload: body,
      resultCode: parsed.resultCode,
      resultDescription: parsed.resultDescription,
    });

    if (payment.payment_status === "paid") {
      await markCallbackProcessed(callbackId);
      return NextResponse.json(buildMpesaAcceptResponse());
    }

    if (parsed.resultCode === 0 && parsed.mpesaReceiptNumber) {
      await markPaymentPaidFromCallback({
        mpesaPaymentId: payment.id,
        mpesaReceiptNumber: parsed.mpesaReceiptNumber,
      });

      const activation = await activateSubscriptionFromPayment(payment.id);

      if (activation.activated) {
        const admin = createAdminClient();
        const { data: paymentDetails } = await admin
          .from("mpesa_payments")
          .select(
            "student_id, amount_kes, phone_number, subscription_plans(name), student_profiles(email)",
          )
          .eq("id", payment.id)
          .maybeSingle();

        const planName =
          paymentDetails?.subscription_plans &&
          typeof paymentDetails.subscription_plans === "object" &&
          "name" in paymentDetails.subscription_plans
            ? String((paymentDetails.subscription_plans as { name?: string }).name)
            : "Premium";

        const studentEmail =
          paymentDetails?.student_profiles &&
          typeof paymentDetails.student_profiles === "object" &&
          "email" in paymentDetails.student_profiles
            ? String((paymentDetails.student_profiles as { email?: string }).email ?? "")
            : null;

        if (paymentDetails) {
          await sendPaymentSuccessNotifications({
            studentId: paymentDetails.student_id,
            phoneNumber: paymentDetails.phone_number,
            recipientEmail: studentEmail,
            amountKes: paymentDetails.amount_kes,
            mpesaReceiptNumber: parsed.mpesaReceiptNumber,
            planName,
          });
        }
      }
    } else {
      const nextStatus = mapMpesaResultCodeToStatus(parsed.resultCode);
      await updatePaymentStatus(payment.id, nextStatus);

      if (nextStatus === "failed" || nextStatus === "cancelled") {
        const admin = createAdminClient();
        const { data: paymentDetails } = await admin
          .from("mpesa_payments")
          .select("student_id, amount_kes, phone_number")
          .eq("id", payment.id)
          .maybeSingle();

        if (paymentDetails) {
          await sendPaymentFailedNotification({
            studentId: paymentDetails.student_id,
            phoneNumber: paymentDetails.phone_number,
            amountKes: paymentDetails.amount_kes,
          });
        }
      }
    }

    await markCallbackProcessed(callbackId);
    return NextResponse.json(buildMpesaAcceptResponse());
  } catch (error) {
    console.error("MPESA_CALLBACK_FAILED", error);
    return NextResponse.json(buildMpesaAcceptResponse());
  }
}
