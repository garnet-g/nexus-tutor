export interface StkPushParams {
  phoneNumber: string;
  amountKes: number;
  accountReference: string;
  transactionDesc: string;
}

export interface StkPushResult {
  checkoutRequestId: string;
  merchantRequestId: string;
  isMock: boolean;
}

function isMpesaConfigured(): boolean {
  return Boolean(
    process.env.MPESA_CONSUMER_KEY &&
      process.env.MPESA_CONSUMER_SECRET &&
      process.env.MPESA_PASSKEY &&
      process.env.MPESA_SHORTCODE,
  );
}

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
  if (!isMpesaConfigured()) {
    const mockId = `MOCK-${Date.now()}`;
    return {
      checkoutRequestId: mockId,
      merchantRequestId: `MRQ-${mockId}`,
      isMock: true,
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

  const callbackUrl =
    process.env.MPESA_CALLBACK_URL ??
    `${process.env.NEXT_PUBLIC_APP_URL ?? "http://localhost:3000"}/api/mpesa/callback`;

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
        CallBackURL: callbackUrl,
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

export function mapMpesaResultCodeToStatus(resultCode: number): string {
  if (resultCode === 0) {
    return "paid";
  }
  if (resultCode === 1032) {
    return "cancelled";
  }
  if (resultCode === 1037) {
    return "expired";
  }
  return "failed";
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
