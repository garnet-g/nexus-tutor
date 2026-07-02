export type MpesaPaymentStatus =
  | "pending"
  | "processing"
  | "provider-pending"
  | "verified-paid"
  | "verified-failed"
  | "expired"
  | "refunded";

const TERMINAL_STATUSES: ReadonlySet<MpesaPaymentStatus> = new Set([
  "verified-paid",
  "verified-failed",
  "expired",
  "refunded",
]);

const TRANSITIONS: Record<MpesaPaymentStatus, ReadonlySet<MpesaPaymentStatus>> = {
  pending: new Set(["processing", "verified-failed", "expired"]),
  processing: new Set(["provider-pending", "verified-failed", "expired"]),
  "provider-pending": new Set(["verified-paid", "verified-failed", "expired"]),
  "verified-paid": new Set(),
  "verified-failed": new Set(),
  expired: new Set(),
  refunded: new Set(),
};

export function isTerminal(status: string): boolean {
  return TERMINAL_STATUSES.has(status as MpesaPaymentStatus);
}

export function canTransition(from: string, to: string): boolean {
  const allowed = TRANSITIONS[from as MpesaPaymentStatus];
  if (!allowed) {
    return false;
  }
  return allowed.has(to as MpesaPaymentStatus);
}

export function mapDarajaResultToHint(resultCode: number): string {
  if (resultCode === 0) {
    return "Payment may have succeeded — confirming with M-Pesa.";
  }
  if (resultCode === 1032) {
    return "Payment was cancelled on your phone.";
  }
  if (resultCode === 1037) {
    return "Payment timed out on your phone.";
  }
  return "Payment could not be completed.";
}

export function clientStatusLabel(status: string): string {
  switch (status) {
    case "pending":
      return "Starting payment…";
    case "processing":
      return "Check your phone";
    case "provider-pending":
      return "Confirming payment…";
    case "verified-paid":
      return "Payment successful";
    case "verified-failed":
      return "Payment failed";
    case "expired":
      return "Payment timed out — try again";
    default:
      return "Processing payment…";
  }
}
