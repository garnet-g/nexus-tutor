import {
  assertMpesaConfiguredForLiveMode,
  createMockAdapterMetadata,
  isMpesaConfigured,
  isMpesaMockAllowed,
} from "@/lib/env/providerModes";

export interface StkPushParams {
  phoneNumber: string;
  amountKes: number;
  accountReference: string;
  transactionDesc: string;
  callbackUrl?: string;
}

export interface StkQueryResult {
  resultCode: number;
  resultDesc: string;
  checkoutRequestId: string;
}

export interface StkPushResult {
  checkoutRequestId: string;
  merchantRequestId: string;
  isMock: boolean;
  mockMetadata?: ReturnType<typeof createMockAdapterMetadata>;
}

export { isMpesaConfigured };

function formatPhoneForDaraja(phoneNumber: string): string {
  const digits = phoneNumber.replace(/\D/g, "");
  if (digits.startsWith("254")) {
    return digits;
  }
  if (digits.startsWith("0")) {
    return `254${digits.slice(1)}`;
  }
  return digits;
}

async function getDarajaAccessToken(): Promise<string> {
  const consumerKey = process.env.MPESA_CONSUMER_KEY!;
  const consumerSecret = process.env.MPESA_CONSUMER_SECRET!;
  const credentials = Buffer.from(`${consumerKey}:${consumerSecret}`).toString(
    "base64",
  );

  const baseUrl =
    process.env.MPESA_ENV === "production"
      ? "https://api.safaricom.co.ke"
      : "https://sandbox.safaricom.co.ke";

  const response = await fetch(
    `${baseUrl}/oauth/v1/generate?grant_type=client_credentials`,
    {
      headers: {
        Authorization: `Basic ${credentials}`,
      },
    },
  );

  if (!response.ok) {
    throw new Error("Failed to obtain M-Pesa access token");
  }

  const payload = (await response.json()) as { access_token?: string };

  if (!payload.access_token) {
    throw new Error("M-Pesa access token missing from response");
  }

  return payload.access_token;
}

export async function initiateStkPush(
  params: StkPushParams,
): Promise<StkPushResult> {
  assertMpesaConfiguredForLiveMode();

  if (isMpesaMockAllowed() || !isMpesaConfigured()) {
    if (!isMpesaMockAllowed()) {
      assertMpesaConfiguredForLiveMode();
    }

    const mockId = `MOCK-${Date.now()}`;
    return {
      checkoutRequestId: mockId,
      merchantRequestId: `MRQ-${mockId}`,
      isMock: true,
      mockMetadata: createMockAdapterMetadata(),
    };
  }

  const accessToken = await getDarajaAccessToken();
  const timestamp = new Date()
    .toISOString()
    .replace(/[-:TZ.]/g, "")
    .slice(0, 14);
  const password = Buffer.from(
    `${process.env.MPESA_SHORTCODE}${process.env.MPESA_PASSKEY}${timestamp}`,
  ).toString("base64");

  const baseUrl =
    process.env.MPESA_ENV === "production"
      ? "https://api.safaricom.co.ke"
      : "https://sandbox.safaricom.co.ke";

  if (!params.callbackUrl?.trim()) {
    throw new Error("Per-payment callback URL is required for STK push");
  }

  const response = await fetch(
    `${baseUrl}/mpesa/stkpush/v1/processrequest`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        BusinessShortCode: process.env.MPESA_SHORTCODE,
        Password: password,
        Timestamp: timestamp,
        TransactionType: "CustomerPayBillOnline",
        Amount: params.amountKes,
        PartyA: formatPhoneForDaraja(params.phoneNumber),
        PartyB: process.env.MPESA_SHORTCODE,
        PhoneNumber: formatPhoneForDaraja(params.phoneNumber),
        CallBackURL: params.callbackUrl,
        AccountReference: params.accountReference.slice(0, 12),
        TransactionDesc: params.transactionDesc.slice(0, 13),
      }),
    },
  );

  const payload = (await response.json()) as {
    CheckoutRequestID?: string;
    MerchantRequestID?: string;
    errorMessage?: string;
  };

  if (!response.ok || !payload.CheckoutRequestID) {
    throw new Error(payload.errorMessage ?? "M-Pesa STK push failed");
  }

  return {
    checkoutRequestId: payload.CheckoutRequestID,
    merchantRequestId: payload.MerchantRequestID ?? "",
    isMock: false,
  };
}

export async function queryStkPush(
  checkoutRequestId: string,
): Promise<StkQueryResult> {
  assertMpesaConfiguredForLiveMode();

  if (isMpesaMockAllowed() || !isMpesaConfigured()) {
    if (!isMpesaMockAllowed()) {
      assertMpesaConfiguredForLiveMode();
    }

    return {
      resultCode: 0,
      resultDesc: "The service request is processed successfully.",
      checkoutRequestId,
    };
  }

  const accessToken = await getDarajaAccessToken();
  const timestamp = new Date()
    .toISOString()
    .replace(/[-:TZ.]/g, "")
    .slice(0, 14);
  const password = Buffer.from(
    `${process.env.MPESA_SHORTCODE}${process.env.MPESA_PASSKEY}${timestamp}`,
  ).toString("base64");

  const baseUrl =
    process.env.MPESA_ENV === "production"
      ? "https://api.safaricom.co.ke"
      : "https://sandbox.safaricom.co.ke";

  const response = await fetch(
    `${baseUrl}/mpesa/stkpushquery/v1/query`,
    {
      method: "POST",
      headers: {
        Authorization: `Bearer ${accessToken}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        BusinessShortCode: process.env.MPESA_SHORTCODE,
        Password: password,
        Timestamp: timestamp,
        CheckoutRequestID: checkoutRequestId,
      }),
    },
  );

  const payload = (await response.json()) as {
    ResultCode?: number | string;
    ResultDesc?: string;
    CheckoutRequestID?: string;
    errorMessage?: string;
  };

  if (!response.ok) {
    throw new Error(payload.errorMessage ?? "M-Pesa STK query failed");
  }

  return {
    resultCode: Number(payload.ResultCode ?? -1),
    resultDesc: String(payload.ResultDesc ?? ""),
    checkoutRequestId: String(payload.CheckoutRequestID ?? checkoutRequestId),
  };
}

export function mapMpesaResultCodeToStatus(resultCode: number): string {
  if (resultCode === 0) {
    return "provider-pending";
  }
  if (resultCode === 1032) {
    return "verified-failed";
  }
  if (resultCode === 1037) {
    return "expired";
  }
  return "verified-failed";
}

export interface ParsedMpesaCallback {
  checkoutRequestId: string;
  merchantRequestId: string | null;
  resultCode: number;
  resultDescription: string;
  mpesaReceiptNumber: string | null;
  amountKes: number | null;
  phoneNumber: string | null;
}

export function parseMpesaCallbackPayload(
  body: unknown,
): ParsedMpesaCallback | null {
  if (!body || typeof body !== "object") {
    return null;
  }

  const root = body as Record<string, unknown>;
  const stkCallback =
    root.Body && typeof root.Body === "object"
      ? ((root.Body as Record<string, unknown>).stkCallback as
          | Record<string, unknown>
          | undefined)
      : (root.stkCallback as Record<string, unknown> | undefined);

  if (!stkCallback) {
    return null;
  }

  const metadataItems =
    stkCallback.CallbackMetadata &&
    typeof stkCallback.CallbackMetadata === "object"
      ? ((stkCallback.CallbackMetadata as Record<string, unknown>)
          .Item as Array<{ Name?: string; Value?: unknown }> | undefined)
      : undefined;

  let mpesaReceiptNumber: string | null = null;
  let amountKes: number | null = null;
  let phoneNumber: string | null = null;

  for (const item of metadataItems ?? []) {
    if (item.Name === "MpesaReceiptNumber" && typeof item.Value === "string") {
      mpesaReceiptNumber = item.Value;
    }
    if (item.Name === "Amount" && typeof item.Value === "number") {
      amountKes = item.Value;
    }
    if (item.Name === "PhoneNumber" && typeof item.Value === "number") {
      phoneNumber = String(item.Value);
    }
  }

  return {
    checkoutRequestId: String(stkCallback.CheckoutRequestID ?? ""),
    merchantRequestId: stkCallback.MerchantRequestID
      ? String(stkCallback.MerchantRequestID)
      : null,
    resultCode: Number(stkCallback.ResultCode ?? -1),
    resultDescription: String(stkCallback.ResultDesc ?? ""),
    mpesaReceiptNumber,
    amountKes,
    phoneNumber,
  };
}

export function buildMpesaAcceptResponse() {
  return {
    ResultCode: 0,
    ResultDesc: "Accepted",
  };
}
