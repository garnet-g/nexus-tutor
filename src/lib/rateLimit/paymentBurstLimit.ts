import "server-only";

import { createHmac } from "node:crypto";

import { NextResponse } from "next/server";

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";

export type PaymentBurstAction = "stk-push" | "status" | "manual-reconcile";

const WINDOW_SECONDS = 60;

const LIMITS: Record<
  PaymentBurstAction,
  { account: number; ip: number; phone?: number }
> = {
  "stk-push": { account: 5, ip: 10, phone: 3 },
  status: { account: 30, ip: 30 },
  "manual-reconcile": { account: 5, ip: 10 },
};

function getRateLimitPepper(): string {
  return process.env.MPESA_CALLBACK_PEPPER?.trim() || "dev-callback-pepper";
}

function hashIdentifier(kind: "ip" | "phone", value: string): string {
  return createHmac("sha256", getRateLimitPepper())
    .update(`${kind}:${value}`)
    .digest("hex");
}

export function getClientIp(request: Request): string {
  const forwarded = request.headers.get("x-forwarded-for");
  if (forwarded) {
    return forwarded.split(",")[0]?.trim() ?? "unknown";
  }
  return request.headers.get("x-real-ip") ?? "unknown";
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

export function buildPaymentRateLimitKeys(input: {
  request: Request;
  studentId: string;
  phoneNumber?: string;
  action: PaymentBurstAction;
}): string[] {
  const keys = [
    `mpesa:${input.action}:account:${input.studentId}`,
    `mpesa:${input.action}:ip:${hashIdentifier("ip", getClientIp(input.request))}`,
  ];

  if (input.phoneNumber) {
    keys.push(
      `mpesa:${input.action}:phone:${hashIdentifier("phone", normalizePhone254(input.phoneNumber))}`,
    );
  }

  return keys;
}

export function paymentRateLimitedResponse(
  retryAfterSeconds: number,
): NextResponse {
  const seconds = Math.max(1, Math.ceil(retryAfterSeconds));

  return NextResponse.json(
    {
      success: false,
      error: {
        code: "RATE_LIMITED",
        message: "Too many payment requests. Please slow down.",
        details: { retryAfterSeconds: seconds },
      },
    },
    {
      status: 429,
      headers: { "Retry-After": String(seconds) },
    },
  );
}

export async function enforcePaymentBurstLimits(input: {
  request: Request;
  studentId: string;
  phoneNumber?: string;
  action: PaymentBurstAction;
}): Promise<NextResponse | null> {
  const limits = LIMITS[input.action];
  const keys = buildPaymentRateLimitKeys(input);

  const checks = await Promise.all(
    keys.map(async (key, index) => {
      const max =
        index === 0
          ? limits.account
          : index === 1
            ? limits.ip
            : (limits.phone ?? limits.account);

      const result = await checkRateLimit({
        key,
        windowSeconds: WINDOW_SECONDS,
        max,
      });

      return result;
    }),
  );

  const denied = checks.find((check) => !check.allowed);

  if (!denied) {
    return null;
  }

  return paymentRateLimitedResponse(denied.retryAfterSeconds);
}
