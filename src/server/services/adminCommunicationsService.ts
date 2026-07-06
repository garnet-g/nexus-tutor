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

  const { data: existingLog } = await admin
    .from("admin_communication_logs")
    .select("id, status")
    .eq("idempotency_key", input.send.idempotencyKey)
    .maybeSingle();

  if (existingLog) {
    const { data: batchRows } = await admin
      .from("admin_communication_logs")
      .select("status")
      .eq("idempotency_key", input.send.idempotencyKey);
    const rows = batchRows ?? [];
    const sent = rows.filter((row) => row.status === "sent" || row.status === "mocked").length;
    const failed = rows.filter((row) => row.status === "failed").length;
    return {
      idempotentReplay: true,
      sent,
      failed,
      recipientCount: rows.length,
    };
  }

  const template = await getActiveTemplate(input.send.templateKey);
  if (!template) {
    throw new Error("Template not found.");
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

      const status = result.ok ? "sent" : "failed";
      if (result.ok) {
        sent += 1;
      } else {
        failed += 1;
      }

      await admin.from("admin_communication_logs").insert({
        template_id: template.id,
        channel: template.channel,
        target_student_id: studentId,
        message_body: template.body,
        status,
        idempotency_key: input.send.idempotencyKey,
        created_by: input.actorUserId,
      });
    } else {
      await admin.from("admin_communication_logs").insert({
        template_id: template.id,
        channel: template.channel,
        target_student_id: studentId,
        message_body: template.body,
        status: "mocked",
        idempotency_key: input.send.idempotencyKey,
        created_by: input.actorUserId,
      });
      sent += 1;
    }
  }

  return {
    idempotentReplay: false,
    sent,
    failed,
    recipientCount: input.send.studentIds.length,
  };
}
