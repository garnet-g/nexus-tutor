export const PENDING_PAYMENT_STORAGE_KEY = "nexus:pending-mpesa-payment";

export interface PendingPaymentSnapshot {
  mpesaPaymentId: string;
}

export function savePendingPayment(snapshot: PendingPaymentSnapshot): void {
  if (typeof sessionStorage === "undefined") {
    return;
  }
  sessionStorage.setItem(PENDING_PAYMENT_STORAGE_KEY, JSON.stringify(snapshot));
}

export function readPendingPayment(): PendingPaymentSnapshot | null {
  if (typeof sessionStorage === "undefined") {
    return null;
  }

  const raw = sessionStorage.getItem(PENDING_PAYMENT_STORAGE_KEY);
  if (!raw) {
    return null;
  }

  try {
    const parsed = JSON.parse(raw) as PendingPaymentSnapshot;
    if (typeof parsed.mpesaPaymentId === "string" && parsed.mpesaPaymentId.length > 0) {
      return parsed;
    }
  } catch {
    // Ignore corrupt storage.
  }

  return null;
}

export function clearPendingPayment(): void {
  if (typeof sessionStorage === "undefined") {
    return;
  }
  sessionStorage.removeItem(PENDING_PAYMENT_STORAGE_KEY);
}
