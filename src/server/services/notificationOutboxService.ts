import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { sendCelcomSms, sendCelcomWhatsApp } from "@/lib/celcom/celcomClient";
import { sendResendEmail } from "@/lib/resend/resendClient";
import type { AdminHealthPresentationItem } from "@/lib/health/types";

export type NotificationOutboxChannel = "sms" | "email" | "whatsapp";

export type NotificationOutboxStatus =
  | "pending"
  | "retry_scheduled"
  | "sent"
  | "dead_letter";

export type SmsOutboxPayload = {
  type: "sms";
  phoneNumber: string;
  smsBody: string;
  templateCode?: string;
  studentId?: string;
  parentId?: string;
};

export type EmailOutboxPayload = {
  type: "email";
  recipientEmail: string;
  emailSubject: string;
  emailBody: string;
  templateCode?: string;
  parentId?: string;
};

export type WhatsAppOutboxPayload = {
  type: "whatsapp";
  phoneNumber: string;
  messageBody: string;
  templateCode?: string;
  studentId?: string;
  parentId?: string;
};

export type NotificationOutboxPayload =
  | SmsOutboxPayload
  | EmailOutboxPayload
  | WhatsAppOutboxPayload;

export type NotificationOutboxRow = {
  id: string;
  idempotency_key: string;
  channel: NotificationOutboxChannel;
  status: NotificationOutboxStatus;
  payload: NotificationOutboxPayload;
  attempt_count: number;
  max_attempts: number;
  next_attempt_at: string;
  last_error: string | null;
  sent_at: string | null;
};

const DEFAULT_MAX_ATTEMPTS = 5;
const RETRY_BACKOFF_SECONDS = [30, 120, 600, 1800, 3600];

type OutboxSendHandler = (row: NotificationOutboxRow) => Promise<void>;

let outboxSendHandler: OutboxSendHandler | null = null;

export function __setOutboxSendHandlerForTests(handler: OutboxSendHandler | null) {
  outboxSendHandler = handler;
}

function computeNextAttemptAt(attemptCount: number): string {
  const index = Math.min(Math.max(attemptCount - 1, 0), RETRY_BACKOFF_SECONDS.length - 1);
  const delayMs = RETRY_BACKOFF_SECONDS[index] * 1000;
  return new Date(Date.now() + delayMs).toISOString();
}

async function defaultOutboxSendHandler(row: NotificationOutboxRow): Promise<void> {
  if (row.payload.type === "sms") {
    const result = await sendCelcomSms({
      phoneNumber: row.payload.phoneNumber,
      smsBody: row.payload.smsBody,
      templateCode: row.payload.templateCode,
      studentId: row.payload.studentId,
      parentId: row.payload.parentId,
    });

    if (result.smsStatus === "failed") {
      throw new Error("SMS provider returned failed status.");
    }

    return;
  }

  if (row.payload.type === "whatsapp") {
    const result = await sendCelcomWhatsApp({
      phoneNumber: row.payload.phoneNumber,
      messageBody: row.payload.messageBody,
      templateCode: row.payload.templateCode,
      studentId: row.payload.studentId,
      parentId: row.payload.parentId,
    });

    if (result.whatsappStatus === "failed") {
      throw new Error("WhatsApp provider returned failed status.");
    }

    return;
  }

  await sendResendEmail({
    recipientEmail: row.payload.recipientEmail,
    emailSubject: row.payload.emailSubject,
    emailBody: row.payload.emailBody,
    templateCode: row.payload.templateCode,
  });
}

async function dispatchOutboxRow(row: NotificationOutboxRow): Promise<void> {
  const handler = outboxSendHandler ?? defaultOutboxSendHandler;
  await handler(row);
}

export async function enqueueNotificationOutbox(input: {
  idempotencyKey: string;
  channel: NotificationOutboxChannel;
  payload: NotificationOutboxPayload;
  maxAttempts?: number;
}): Promise<NotificationOutboxRow> {
  const admin = createAdminClient();

  const { data: existing, error: readError } = await admin
    .from("notification_outbox")
    .select("*")
    .eq("idempotency_key", input.idempotencyKey)
    .maybeSingle();

  if (readError) {
    throw new Error(readError.message);
  }

  if (existing) {
    return existing as NotificationOutboxRow;
  }

  const { data, error } = await admin
    .from("notification_outbox")
    .insert({
      idempotency_key: input.idempotencyKey,
      channel: input.channel,
      status: "pending",
      payload: input.payload,
      max_attempts: input.maxAttempts ?? DEFAULT_MAX_ATTEMPTS,
      next_attempt_at: new Date().toISOString(),
    })
    .select("*")
    .single();

  if (error || !data) {
    if (error?.code === "23505") {
      const { data: raced } = await admin
        .from("notification_outbox")
        .select("*")
        .eq("idempotency_key", input.idempotencyKey)
        .maybeSingle();

      if (raced) {
        return raced as NotificationOutboxRow;
      }
    }

    throw new Error(error?.message ?? "Could not enqueue notification.");
  }

  return data as NotificationOutboxRow;
}

async function transitionOutboxRow(
  row: NotificationOutboxRow,
  patch: Partial<NotificationOutboxRow>,
): Promise<NotificationOutboxRow> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("notification_outbox")
    .update(patch)
    .eq("id", row.id)
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not update notification outbox row.");
  }

  return data as NotificationOutboxRow;
}

export async function processOutboxRow(row: NotificationOutboxRow): Promise<NotificationOutboxRow> {
  if (row.status === "sent" || row.status === "dead_letter") {
    return row;
  }

  const nextAttemptCount = row.attempt_count + 1;

  try {
    await dispatchOutboxRow(row);

    return transitionOutboxRow(row, {
      status: "sent",
      attempt_count: nextAttemptCount,
      sent_at: new Date().toISOString(),
      last_error: null,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unknown notification error";

    if (nextAttemptCount >= row.max_attempts) {
      return transitionOutboxRow(row, {
        status: "dead_letter",
        attempt_count: nextAttemptCount,
        last_error: message,
      });
    }

    return transitionOutboxRow(row, {
      status: "retry_scheduled",
      attempt_count: nextAttemptCount,
      last_error: message,
      next_attempt_at: computeNextAttemptAt(nextAttemptCount),
    });
  }
}

export async function processNotificationOutboxBatch(
  limit = 25,
): Promise<{ processed: number; sent: number; retried: number; deadLettered: number }> {
  const admin = createAdminClient();
  const nowIso = new Date().toISOString();

  const { data, error } = await admin
    .from("notification_outbox")
    .select("*")
    .in("status", ["pending", "retry_scheduled"])
    .lte("next_attempt_at", nowIso)
    .order("next_attempt_at", { ascending: true })
    .limit(limit);

  if (error) {
    throw new Error(error.message);
  }

  let processed = 0;
  let sent = 0;
  let retried = 0;
  let deadLettered = 0;

  for (const row of (data ?? []) as NotificationOutboxRow[]) {
    const result = await processOutboxRow(row);
    processed += 1;

    if (result.status === "sent") {
      sent += 1;
    } else if (result.status === "retry_scheduled") {
      retried += 1;
    } else if (result.status === "dead_letter") {
      deadLettered += 1;
    }
  }

  return { processed, sent, retried, deadLettered };
}

export async function enqueueAndTrySendNotification(input: {
  idempotencyKey: string;
  channel: NotificationOutboxChannel;
  payload: NotificationOutboxPayload;
}): Promise<NotificationOutboxRow> {
  const row = await enqueueNotificationOutbox(input);

  if (row.status === "sent" || row.status === "dead_letter") {
    return row;
  }

  return processOutboxRow(row);
}

export async function getNotificationOutboxDlqCount(): Promise<number> {
  const admin = createAdminClient();
  const { count, error } = await admin
    .from("notification_outbox")
    .select("id", { count: "exact", head: true })
    .eq("status", "dead_letter");

  if (error) {
    throw new Error(error.message);
  }

  return count ?? 0;
}

export async function getNotificationOutboxHealthItem(): Promise<AdminHealthPresentationItem> {
  const dlqCount = await getNotificationOutboxDlqCount();

  if (dlqCount === 0) {
    return {
      name: "Notification dead letter",
      status: "healthy",
      detail: "No exhausted notification sends in the dead-letter queue.",
      probeStatus: "reachable",
    };
  }

  return {
    name: "Notification dead letter",
    status: "watch",
    detail: `${dlqCount} notification(s) exhausted retries and require operator review.`,
    probeStatus: "degraded",
  };
}
