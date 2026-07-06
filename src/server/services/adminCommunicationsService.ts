import "server-only";

import { z } from "zod";

import { createAdminClient } from "@/lib/supabase/admin";
import { sendParentSms } from "@/server/services/adminParentNotifyService";

export const adminCommunicationPreviewSchema = z.object({
  templateKey: z.string().trim().min(3).max(80),
  studentIds: z.array(z.string().uuid()).min(1).max(100).optional(),
});

export const adminCommunicationSendSchema = z.object({
  templateKey: z.string().trim().min(3).max(80),
  studentIds: z.array(z.string().uuid()).min(1).max(100),
  idempotencyKey: z.string().trim().min(8).max(120),
});

export type AdminCommunicationPreviewInput = z.infer<
  typeof adminCommunicationPreviewSchema
>;
export type AdminCommunicationSendInput = z.infer<
  typeof adminCommunicationSendSchema
>;

type SendBatchMetadata = {
  templateKey: string;
  studentIds: string[];
  sent: number;
  failed: number;
  recipientCount: number;
  completedAt?: string;
};

function isUniqueViolation(error: unknown): boolean {
  return (
    typeof error === "object" &&
    error !== null &&
    "code" in error &&
    (error as { code: string }).code === "23505"
  );
}

function asSendBatchMetadata(value: unknown): SendBatchMetadata | null {
  if (!value || typeof value !== "object") {
    return null;
  }
  const data = value as Record<string, unknown>;
  if (!Array.isArray(data.studentIds)) {
    return null;
  }
  return {
    templateKey: String(data.templateKey ?? ""),
    studentIds: data.studentIds.map(String),
    sent: Number(data.sent ?? 0),
    failed: Number(data.failed ?? 0),
    recipientCount: Number(data.recipientCount ?? data.studentIds.length),
    completedAt:
      typeof data.completedAt === "string" ? data.completedAt : undefined,
  };
}

function sendResultFromMetadata(
  metadata: SendBatchMetadata,
  idempotentReplay: boolean,
) {
  return {
    idempotentReplay,
    sent: metadata.sent,
    failed: metadata.failed,
    recipientCount: metadata.recipientCount,
  };
}

async function getActiveTemplate(templateKey: string) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_communication_templates")
    .select("id, template_key, channel, title, body, is_active")
    .eq("template_key", templateKey)
    .eq("is_active", true)
    .maybeSingle();
  if (error) {
    throw new Error(error.message);
  }
  return data;
}

async function resolveTargetStudentIds(studentIds?: string[]): Promise<string[]> {
  if (studentIds && studentIds.length > 0) {
    return studentIds;
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("student_profiles")
    .select("id")
    .eq("is_active", true)
    .limit(100);
  if (error) {
    throw new Error(error.message);
  }
  return (data ?? []).map((row) => String(row.id));
}

async function loadExistingSendResult(
  idempotencyKey: string,
): Promise<ReturnType<typeof sendResultFromMetadata> | null> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_communication_logs")
    .select("metadata, status")
    .eq("idempotency_key", idempotencyKey)
    .maybeSingle();
  if (error) {
    throw new Error(error.message);
  }
  if (!data) {
    return null;
  }

  const metadata = asSendBatchMetadata(data.metadata);
  if (!metadata) {
    return null;
  }

  return sendResultFromMetadata(metadata, true);
}

export async function previewOperationalTemplateSend(
  input: AdminCommunicationPreviewInput,
): Promise<{ templateKey: string; channel: string; recipientCount: number }> {
  const template = await getActiveTemplate(input.templateKey);
  if (!template) {
    throw new Error("Template not found.");
  }

  const studentIds = await resolveTargetStudentIds(input.studentIds);
  return {
    templateKey: template.template_key,
    channel: template.channel,
    recipientCount: studentIds.length,
  };
}

export async function sendOperationalTemplate(input: {
  send: AdminCommunicationSendInput;
  actorUserId: string;
}): Promise<{
  idempotentReplay: boolean;
  sent: number;
  failed: number;
  recipientCount: number;
}> {
  const admin = createAdminClient();
  const template = await getActiveTemplate(input.send.templateKey);
  if (!template) {
    throw new Error("Template not found.");
  }

  const batchMetadata: SendBatchMetadata = {
    templateKey: input.send.templateKey,
    studentIds: input.send.studentIds,
    sent: 0,
    failed: 0,
    recipientCount: input.send.studentIds.length,
  };

  const { error: claimError } = await admin.from("admin_communication_logs").insert({
    template_id: template.id,
    channel: template.channel,
    message_body: template.body,
    status: "queued",
    idempotency_key: input.send.idempotencyKey,
    created_by: input.actorUserId,
    metadata: batchMetadata,
  });

  if (claimError) {
    if (isUniqueViolation(claimError)) {
      const existing = await loadExistingSendResult(input.send.idempotencyKey);
      if (existing) {
        return existing;
      }
    }
    throw new Error(claimError.message);
  }

  let sent = 0;
  let failed = 0;

  for (const studentId of input.send.studentIds) {
    if (template.channel === "sms") {
      const result = await sendParentSms({
        studentId,
        message: template.body,
        adminUserId: input.actorUserId,
      });

      if (result.ok) {
        sent += 1;
      } else {
        failed += 1;
      }
    } else {
      sent += 1;
    }
  }

  const completedMetadata: SendBatchMetadata = {
    ...batchMetadata,
    sent,
    failed,
    completedAt: new Date().toISOString(),
  };

  const { error: updateError } = await admin
    .from("admin_communication_logs")
    .update({
      status: failed > 0 && sent === 0 ? "failed" : template.channel === "email" ? "mocked" : "sent",
      metadata: completedMetadata,
    })
    .eq("idempotency_key", input.send.idempotencyKey);

  if (updateError) {
    throw new Error(updateError.message);
  }

  return sendResultFromMetadata(completedMetadata, false);
}
