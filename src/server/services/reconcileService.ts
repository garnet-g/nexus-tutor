import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { isMpesaMockAllowed } from "@/lib/env/providerModes";
import {
  buildTransactionStatusResultUrl,
  buildTransactionStatusTimeoutUrl,
} from "@/lib/mpesa/paymentProof";
import { queryTransactionStatus } from "@/lib/mpesa/mpesaClient";
import { processVerifiedMpesaPayment } from "@/server/services/subscriptionService";

const RECEIPT_PATTERN = /^[A-Za-z0-9]{6,20}$/;

export interface VerifyManualMpesaCodeInput {
  studentId: string;
  subscriptionPlanId: string;
  mpesaCode: string;
}

export type ManualVerificationStatus = "verified" | "pending_review" | "rejected";

export interface VerifyManualMpesaCodeResult {
  status: ManualVerificationStatus;
  activated: boolean;
  subscriptionId?: string;
  message: string;
}

function normalizeReceipt(code: string): string {
  return code.trim().toUpperCase();
}

export async function verifyManualMpesaCode(
  input: VerifyManualMpesaCodeInput,
): Promise<VerifyManualMpesaCodeResult> {
  const receipt = normalizeReceipt(input.mpesaCode);

  if (!RECEIPT_PATTERN.test(receipt)) {
    return {
      status: "rejected",
      activated: false,
      message: "That doesn't look like a valid M-Pesa transaction code.",
    };
  }

  const admin = createAdminClient();

  const { data: plan } = await admin
    .from("subscription_plans")
    .select("id, plan_code, amount_kes")
    .eq("id", input.subscriptionPlanId)
    .eq("is_active", true)
    .maybeSingle();

  if (!plan || plan.plan_code === "free") {
    return {
      status: "rejected",
      activated: false,
      message: "Subscription plan not found.",
    };
  }

  const [{ data: existingVerification }, { data: existingPayment }] =
    await Promise.all([
      admin
        .from("mpesa_manual_verifications")
        .select("id, verification_status")
        .eq("mpesa_receipt_number", receipt)
        .maybeSingle(),
      admin
        .from("mpesa_payments")
        .select("id")
        .eq("mpesa_receipt_number", receipt)
        .maybeSingle(),
    ]);

  if (existingVerification || existingPayment) {
    return {
      status: "rejected",
      activated: false,
      message: "This M-Pesa transaction code has already been used.",
    };
  }

  const { data: manualVerification, error: insertError } = await admin
    .from("mpesa_manual_verifications")
    .insert({
      student_id: input.studentId,
      subscription_plan_id: plan.id,
      mpesa_receipt_number: receipt,
      submitted_amount_kes: plan.amount_kes,
      verification_status: "pending",
    })
    .select("id")
    .single();

  if (insertError || !manualVerification) {
    return {
      status: "rejected",
      activated: false,
      message: "This M-Pesa transaction code has already been used.",
    };
  }

  if (isMpesaMockAllowed()) {
    const { data: payment, error: paymentError } = await admin
      .from("mpesa_payments")
      .insert({
        student_id: input.studentId,
        subscription_plan_id: plan.id,
        phone_number: "manual-reconciliation",
        amount_kes: plan.amount_kes,
        payment_status: "provider-pending",
        mpesa_receipt_number: receipt,
      })
      .select("id")
      .single();

    if (paymentError || !payment) {
      await admin
        .from("mpesa_manual_verifications")
        .update({ verification_status: "rejected", rejection_reason: paymentError?.message ?? "insert_failed", resolved_at: new Date().toISOString() })
        .eq("id", manualVerification.id);

      return {
        status: "rejected",
        activated: false,
        message: "Could not record this payment. Please try again.",
      };
    }

    try {
      const result = await processVerifiedMpesaPayment({
        mpesaPaymentId: payment.id,
        mpesaReceiptNumber: receipt,
        queryResultCode: 0,
        queryPayload: { source: "manual_reconciliation_sandbox" },
        verifiedAmountKes: plan.amount_kes,
      });

      await admin
        .from("mpesa_manual_verifications")
        .update({
          verification_status: "verified",
          verification_source: "sandbox_auto",
          mpesa_payment_id: payment.id,
          resolved_at: new Date().toISOString(),
        })
        .eq("id", manualVerification.id);

      return {
        status: "verified",
        activated: result.activated,
        subscriptionId: result.subscriptionId,
        message: "Payment verified. Your plan is now active.",
      };
    } catch (error) {
      await admin
        .from("mpesa_manual_verifications")
        .update({
          verification_status: "rejected",
          rejection_reason: error instanceof Error ? error.message : "activation_failed",
          resolved_at: new Date().toISOString(),
        })
        .eq("id", manualVerification.id);

      return {
        status: "rejected",
        activated: false,
        message: "Could not activate your plan. Please contact support.",
      };
    }
  }

  // Production: Daraja's TransactionStatusQuery is asynchronous — Safaricom
  // confirms the transaction on a ResultURL callback, not this response. We
  // must never activate a subscription from an unverified user-submitted
  // code, so this queues the code for confirmation and leaves it pending.
  try {
    await queryTransactionStatus({
      mpesaReceiptNumber: receipt,
      resultUrl: buildTransactionStatusResultUrl(),
      queueTimeoutUrl: buildTransactionStatusTimeoutUrl(),
    });

    await admin
      .from("mpesa_manual_verifications")
      .update({ verification_source: "daraja_transaction_status" })
      .eq("id", manualVerification.id);

    return {
      status: "pending_review",
      activated: false,
      message:
        "We're confirming this payment with Safaricom. This can take a few minutes — check back shortly.",
    };
  } catch (error) {
    await admin
      .from("mpesa_manual_verifications")
      .update({
        verification_status: "rejected",
        rejection_reason: error instanceof Error ? error.message : "query_failed",
        resolved_at: new Date().toISOString(),
      })
      .eq("id", manualVerification.id);

    return {
      status: "rejected",
      activated: false,
      message: "Could not verify this transaction code with M-Pesa.",
    };
  }
}
