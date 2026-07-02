import "server-only";

import { timingSafeEqual } from "node:crypto";

import { NextResponse } from "next/server";

import { buildCelcomIdempotencyKey } from "@/lib/mpesa/paymentProof";
import { createAdminClient } from "@/lib/supabase/admin";
import { handleCelcomDeliveryReport } from "@/server/services/notificationService";

function verifyCelcomWebhookSecret(request: Request): boolean {
  const expected = process.env.CELCOM_WEBHOOK_SECRET?.trim();
  if (!expected) {
    return false;
  }

  const provided =
    request.headers.get("x-celcom-webhook-secret")?.trim() ??
    request.headers.get("X-Celcom-Webhook-Secret")?.trim() ??
    "";

  if (!provided) {
    return false;
  }

  const expectedBuffer = Buffer.from(expected);
  const providedBuffer = Buffer.from(provided);

  if (expectedBuffer.length !== providedBuffer.length) {
    return false;
  }

  return timingSafeEqual(expectedBuffer, providedBuffer);
}

export async function POST(request: Request) {
  if (!verifyCelcomWebhookSecret(request)) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  try {
    const body = await request.json();
    const report = body as Record<string, unknown>;
    const messageId =
      typeof report.messageId === "string"
        ? report.messageId
        : typeof report.celcomMessageId === "string"
          ? report.celcomMessageId
          : null;
    const status =
      typeof report.status === "string" ? report.status.toLowerCase() : "delivered";
    const eventTimestamp =
      typeof report.eventTimestamp === "string" ? report.eventTimestamp : null;

    if (messageId) {
      const idempotencyKey = buildCelcomIdempotencyKey({
        messageId,
        status,
        eventTimestamp,
      });

      const admin = createAdminClient();
      const { error: insertError } = await admin.from("celcom_webhook_events").insert({
        idempotency_key: idempotencyKey,
        celcom_message_id: messageId,
        payload: body,
      });

      if (insertError?.code === "23505") {
        return NextResponse.json({
          success: true,
          data: { received: true, duplicate: true },
        });
      }

      if (insertError) {
        throw insertError;
      }
    }

    await handleCelcomDeliveryReport(body);

    return NextResponse.json({
      success: true,
      data: { received: true },
    });
  } catch (error) {
    console.error("CELCOM_WEBHOOK_FAILED", error);

    return NextResponse.json({
      success: true,
      data: { received: true },
    });
  }
}
