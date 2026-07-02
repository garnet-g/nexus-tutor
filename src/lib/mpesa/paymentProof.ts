import { createHmac, randomBytes, timingSafeEqual } from "node:crypto";

import type { StkQueryResult } from "@/lib/mpesa/mpesaClient";

export function generateCallbackSecret(): string {
  return randomBytes(32).toString("base64url");
}

function getCallbackPepper(): string {
  return process.env.MPESA_CALLBACK_PEPPER?.trim() || "dev-callback-pepper";
}

export function hashCallbackSecret(secret: string): string {
  return createHmac("sha256", getCallbackPepper()).update(secret).digest("hex");
}

export function verifyCallbackSecret(secret: string, storedHash: string): boolean {
  const computed = hashCallbackSecret(secret);
  if (computed.length !== storedHash.length) {
    return false;
  }
  return timingSafeEqual(Buffer.from(computed), Buffer.from(storedHash));
}

export function buildCallbackUrl(secret: string): string {
  const origin =
    process.env.APP_ORIGIN?.trim() ||
    process.env.NEXT_PUBLIC_APP_URL?.trim() ||
    "http://localhost:3000";
  return `${origin.replace(/\/$/, "")}/api/mpesa/callback/${secret}`;
}

export function buildCallbackIdempotencyKey(input: {
  checkoutRequestId: string;
  resultCode: number;
  mpesaReceiptNumber: string | null;
}): string {
  const receipt = input.mpesaReceiptNumber ?? "none";
  return `stk:${input.checkoutRequestId}:${input.resultCode}:${receipt}`;
}

export function buildCelcomIdempotencyKey(input: {
  messageId: string;
  status: string;
  eventTimestamp?: string | null;
}): string {
  const ts = input.eventTimestamp ?? "none";
  return `celcom:${input.messageId}:${input.status}:${ts}`;
}

function normalizePhone254(phone: string): string {
  const digits = phone.replace(/\D/g, "");
  if (digits.startsWith("254")) {
    return digits;
  }
  if (digits.startsWith("0")) {
    return `254${digits.slice(1)}`;
  }
  return digits;
}

export interface PaymentProofRow {
  amount_kes: number;
  phone_number: string;
}

export interface CallbackProofMeta {
  amountKes: number | null;
  phoneNumber: string | null;
  mpesaReceiptNumber: string | null;
}

export function validateQueryProof(
  payment: PaymentProofRow,
  queryResult: StkQueryResult,
  callbackMeta?: CallbackProofMeta,
): { valid: boolean; reason?: string } {
  if (queryResult.resultCode !== 0) {
    return { valid: false, reason: "query_not_success" };
  }

  if (!callbackMeta) {
    return { valid: false, reason: "callback_metadata_missing" };
  }

  if (callbackMeta.amountKes === null) {
    return { valid: false, reason: "callback_amount_missing" };
  }

  if (callbackMeta.amountKes !== payment.amount_kes) {
    return { valid: false, reason: "amount_mismatch" };
  }

  if (!callbackMeta.phoneNumber) {
    return { valid: false, reason: "callback_phone_missing" };
  }

  if (
    normalizePhone254(callbackMeta.phoneNumber) !==
    normalizePhone254(payment.phone_number)
  ) {
    return { valid: false, reason: "phone_mismatch" };
  }

  if (!callbackMeta.mpesaReceiptNumber) {
    return { valid: false, reason: "callback_receipt_missing" };
  }

  if (!/^[A-Z0-9]+$/i.test(callbackMeta.mpesaReceiptNumber)) {
    return { valid: false, reason: "invalid_receipt" };
  }

  return { valid: true };
}
