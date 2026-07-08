import "server-only";

import { z } from "zod";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  getApprovalById,
  isBulkActionRequestType,
  markApprovalExecuted,
} from "@/server/services/adminPlatformService";
import { sendParentSms } from "@/server/services/adminParentNotifyService";

export const BULK_ACTION_COMMANDS = [
  "bulk_comp_grant",
  "bulk_parent_notify",
  "bulk_content_publish",
] as const;

export type BulkActionCommand = (typeof BULK_ACTION_COMMANDS)[number];

const bulkCompGrantMetadataSchema = z.object({
  studentIds: z.array(z.string().uuid()).min(1).max(100),
  planCode: z.string().trim().min(1),
  reason: z.string().trim().min(3).max(500),
  expiresAt: z.string().datetime().nullable().optional(),
});

const bulkParentNotifyMetadataSchema = z.object({
  studentIds: z.array(z.string().uuid()).min(1).max(50),
  message: z.string().trim().min(5).max(500),
});

const bulkContentPublishMetadataSchema = z.object({
  lessonIds: z.array(z.string().uuid()).min(1).max(50),
});

export function isAllowlistedBulkCommand(
  requestType: string,
): requestType is BulkActionCommand {
  return (BULK_ACTION_COMMANDS as readonly string[]).includes(requestType);
}

export type BulkActionExecutionResult = {
  command: BulkActionCommand;
  affectedCount: number;
  succeeded: number;
  failed: number;
  errors: Array<{ targetId: string; message: string }>;
  idempotentReplay: boolean;
};

async function grantCompSubscription(input: {
  studentId: string;
  planCode: string;
  reason: string;
  expiresAt: string | null;
  adminUserId: string;
}): Promise<void> {
  const admin = createAdminClient();

  const { data: student, error: studentError } = await admin
    .from("student_profiles")
    .select("id")
    .eq("id", input.studentId)
    .maybeSingle();
  if (studentError) {
    throw new Error(studentError.message);
  }
  if (!student) {
    throw new Error("Student not found.");
  }

  const { data: plan, error: planError } = await admin
    .from("subscription_plans")
    .select("id, plan_code")
    .eq("plan_code", input.planCode)
    .maybeSingle();
  if (planError) {
    throw new Error(planError.message);
  }
  if (!plan) {
    throw new Error(`No subscription plan found for code "${input.planCode}".`);
  }

  const { data: existingSub, error: existingError } = await admin
    .from("student_subscriptions")
    .select("id")
    .eq("student_id", input.studentId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();
  if (existingError) {
    throw new Error(existingError.message);
  }

  if (existingSub) {
    const { error: updateError } = await admin
      .from("student_subscriptions")
      .update({
        subscription_plan_id: plan.id,
        subscription_status: "active",
        current_period_end: input.expiresAt,
        cancelled_at: null,
        updated_at: new Date().toISOString(),
      })
      .eq("id", existingSub.id);
    if (updateError) {
      throw new Error(updateError.message);
    }
  } else {
    const { error: insertError } = await admin
      .from("student_subscriptions")
      .insert({
        student_id: input.studentId,
        subscription_plan_id: plan.id,
        subscription_status: "active",
        current_period_end: input.expiresAt,
      });
    if (insertError) {
      throw new Error(insertError.message);
    }
  }

  const { error: grantError } = await admin.from("admin_subscription_grants").insert({
    admin_user_id: input.adminUserId,
    student_id: input.studentId,
    plan_code: input.planCode,
    reason: input.reason,
    expires_at: input.expiresAt,
  });
  if (grantError) {
    throw new Error(grantError.message);
  }
}

async function executeBulkCompGrant(
  metadata: Record<string, unknown>,
  adminUserId: string,
): Promise<BulkActionExecutionResult> {
  const parsed = bulkCompGrantMetadataSchema.parse(metadata);
  const errors: BulkActionExecutionResult["errors"] = [];
  let succeeded = 0;

  for (const studentId of parsed.studentIds) {
    try {
      await grantCompSubscription({
        studentId,
        planCode: parsed.planCode,
        reason: parsed.reason,
        expiresAt: parsed.expiresAt ?? null,
        adminUserId,
      });
      succeeded += 1;
    } catch (error) {
      errors.push({
        targetId: studentId,
        message: error instanceof Error ? error.message : "Comp grant failed.",
      });
    }
  }

  return {
    command: "bulk_comp_grant",
    affectedCount: parsed.studentIds.length,
    succeeded,
    failed: errors.length,
    errors,
    idempotentReplay: false,
  };
}

async function executeBulkParentNotify(
  metadata: Record<string, unknown>,
  adminUserId: string,
): Promise<BulkActionExecutionResult> {
  const parsed = bulkParentNotifyMetadataSchema.parse(metadata);
  const errors: BulkActionExecutionResult["errors"] = [];
  let succeeded = 0;

  for (const studentId of parsed.studentIds) {
    const result = await sendParentSms({
      studentId,
      message: parsed.message,
      adminUserId,
    });
    if (result.ok) {
      succeeded += 1;
    } else {
      errors.push({
        targetId: studentId,
        message: result.message,
      });
    }
  }

  return {
    command: "bulk_parent_notify",
    affectedCount: parsed.studentIds.length,
    succeeded,
    failed: errors.length,
    errors,
    idempotentReplay: false,
  };
}

async function executeBulkContentPublish(
  metadata: Record<string, unknown>,
): Promise<BulkActionExecutionResult> {
  const parsed = bulkContentPublishMetadataSchema.parse(metadata);
  const admin = createAdminClient();
  const errors: BulkActionExecutionResult["errors"] = [];
  let succeeded = 0;

  for (const lessonId of parsed.lessonIds) {
    const { data, error } = await admin
      .from("lessons")
      .update({
        review_status: "approved",
        updated_at: new Date().toISOString(),
      })
      .eq("id", lessonId)
      .eq("review_status", "in_review")
      .select("id")
      .maybeSingle();

    if (error) {
      errors.push({ targetId: lessonId, message: error.message });
      continue;
    }
    if (!data) {
      errors.push({
        targetId: lessonId,
        message: "Lesson not in review queue.",
      });
      continue;
    }
    succeeded += 1;
  }

  return {
    command: "bulk_content_publish",
    affectedCount: parsed.lessonIds.length,
    succeeded,
    failed: errors.length,
    errors,
    idempotentReplay: false,
  };
}

export class BulkActionExecutionError extends Error {
  readonly code: "NOT_FOUND" | "FORBIDDEN" | "VALIDATION_ERROR";

  constructor(code: BulkActionExecutionError["code"], message: string) {
    super(message);
    this.code = code;
  }
}

export async function executeApprovedBulkAction(input: {
  approvalId: string;
  actorUserId: string;
}): Promise<BulkActionExecutionResult> {
  const approval = await getApprovalById(input.approvalId);
  if (!approval) {
    throw new BulkActionExecutionError("NOT_FOUND", "Approval not found.");
  }

  if (!isBulkActionRequestType(approval.requestType)) {
    throw new BulkActionExecutionError(
      "FORBIDDEN",
      "Approval is not a bulk action request.",
    );
  }

  if (!isAllowlistedBulkCommand(approval.requestType)) {
    throw new BulkActionExecutionError(
      "VALIDATION_ERROR",
      "Bulk command is not allowlisted.",
    );
  }

  if (approval.status !== "approved") {
    throw new BulkActionExecutionError(
      "FORBIDDEN",
      "Bulk actions require an approved request.",
    );
  }

  // Four-eyes: the approver/executor must differ from the requester (DEC-009)
  if (approval.requestedBy === input.actorUserId) {
    throw new BulkActionExecutionError(
      "FORBIDDEN",
      "The actor who requested this bulk action cannot also execute it.",
    );
  }

  const metadata = approval.metadata ?? {};
  if (typeof metadata.executedAt === "string") {
    const summary = asExecutionSummary(metadata.executionSummary);
    return {
      command: approval.requestType,
      affectedCount: Number(summary?.affectedCount ?? 0),
      succeeded: Number(summary?.succeeded ?? 0),
      failed: Number(summary?.failed ?? 0),
      errors: [],
      idempotentReplay: true,
    };
  }

  let result: BulkActionExecutionResult;
  if (approval.requestType === "bulk_comp_grant") {
    result = await executeBulkCompGrant(metadata, input.actorUserId);
  } else if (approval.requestType === "bulk_parent_notify") {
    result = await executeBulkParentNotify(metadata, input.actorUserId);
  } else {
    result = await executeBulkContentPublish(metadata);
  }

  await markApprovalExecuted({
    approvalId: approval.id,
    executionSummary: {
      affectedCount: result.affectedCount,
      succeeded: result.succeeded,
      failed: result.failed,
      command: result.command,
    },
  });

  return result;
}

function asExecutionSummary(value: unknown): Record<string, unknown> | null {
  return value && typeof value === "object"
    ? (value as Record<string, unknown>)
    : null;
}
