import "server-only";

import { queryStkPush } from "@/lib/mpesa/mpesaClient";
import { validateQueryProof } from "@/lib/mpesa/paymentProof";
import { createAdminClient } from "@/lib/supabase/admin";
import {
  processVerifiedMpesaPayment,
  transitionMpesaPayment,
} from "@/server/services/subscriptionService";

export async function expireStalePayments(): Promise<number> {
  const supabase = createAdminClient();
  const now = new Date().toISOString();

  const { data: stalePayments } = await supabase
    .from("mpesa_payments")
    .select("id")
    .in("payment_status", ["processing", "provider-pending", "pending"])
    .lt("expires_at", now);

  let expiredCount = 0;

  for (const payment of stalePayments ?? []) {
    const transitioned = await transitionMpesaPayment({
      mpesaPaymentId: payment.id,
      toStatus: "expired",
      expectedFrom: ["pending", "processing", "provider-pending"],
    });

    if (transitioned) {
      expiredCount += 1;
    }
  }

  return expiredCount;
}

export async function reconcilePayment(mpesaPaymentId: string): Promise<{
  status: string;
  activated: boolean;
}> {
  const supabase = createAdminClient();

  const { data: payment } = await supabase
    .from("mpesa_payments")
    .select(
      "id, payment_status, checkout_request_id, amount_kes, phone_number, mpesa_receipt_number, expires_at",
    )
    .eq("id", mpesaPaymentId)
    .maybeSingle();

  if (!payment) {
    throw new Error("M-Pesa payment not found");
  }

  if (
    payment.payment_status === "verified-paid" ||
    payment.payment_status === "verified-failed" ||
    payment.payment_status === "expired"
  ) {
    return { status: payment.payment_status, activated: false };
  }

  if (payment.expires_at && new Date(payment.expires_at).getTime() < Date.now()) {
    await transitionMpesaPayment({
      mpesaPaymentId: payment.id,
      toStatus: "expired",
      expectedFrom: ["pending", "processing", "provider-pending"],
    });
    return { status: "expired", activated: false };
  }

  if (!payment.checkout_request_id) {
    return { status: payment.payment_status, activated: false };
  }

  await transitionMpesaPayment({
    mpesaPaymentId: payment.id,
    toStatus: "provider-pending",
    expectedFrom: ["processing", "provider-pending"],
  });

  const queryResult = await queryStkPush(payment.checkout_request_id);
  const proof = validateQueryProof(
    {
      amount_kes: payment.amount_kes,
      phone_number: payment.phone_number,
    },
    queryResult,
    {
      amountKes: payment.amount_kes,
      phoneNumber: payment.phone_number,
      mpesaReceiptNumber: payment.mpesa_receipt_number,
    },
  );

  if (!proof.valid || !payment.mpesa_receipt_number) {
    await transitionMpesaPayment({
      mpesaPaymentId: payment.id,
      toStatus: "verified-failed",
      expectedFrom: ["processing", "provider-pending"],
    });
    return { status: "verified-failed", activated: false };
  }

  const activation = await processVerifiedMpesaPayment({
    mpesaPaymentId: payment.id,
    mpesaReceiptNumber: payment.mpesa_receipt_number,
    queryResultCode: queryResult.resultCode,
    queryPayload: queryResult,
    verifiedAmountKes: payment.amount_kes,
  });

  return {
    status: "verified-paid",
    activated: activation.activated,
  };
}

/** PR-077 stub: replay a stored callback event for ops reconciliation */
export async function replayCallbackEvent(eventId: string): Promise<{ replayed: boolean }> {
  const supabase = createAdminClient();

  const { data: event } = await supabase
    .from("mpesa_callback_events")
    .select("mpesa_payment_id")
    .eq("id", eventId)
    .maybeSingle();

  if (!event?.mpesa_payment_id) {
    return { replayed: false };
  }

  await reconcilePayment(event.mpesa_payment_id);
  return { replayed: true };
}
