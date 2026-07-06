import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export class AdminAuditWriteError extends Error {
  readonly code = "AUDIT_WRITE_FAILED";

  constructor(message: string) {
    super(message);
    this.name = "AdminAuditWriteError";
  }
}

export type AdminAuditRecordResult =
  | { ok: true }
  | { ok: false; error: string };

export type AdminAuditAction =
  | "platform_setting.update"
  | "subscription_plan.update"
  | "beta_invite.create"
  | "content.generate"
  | "content.publish"
  | "content.discard"
  | "content.review.submit"
  | "content.review.approve"
  | "content.review.request_changes"
  | "content.review.archive"
  | "content.version.restore"
  | "content.assist.draft_lesson"
  | "content.assist.expand_section"
  | "content.assist.simplify"
  | "content.assist.generate_questions"
  | "content.assist.rewrite_block"
  | "content.lesson_draft.update"
  | "content.lesson_draft.create"
  | "content.media.upload"
  | "content.lessons.reorder"
  | "content.questions.bulk_save"
  | "content.question_draft.create"
  | "content.question_draft.update"
  | "assessment.calibration.create"
  | "subscription.comp"
  | "user.profile.update"
  | "user.impersonate.start"
  | "user.impersonate.end"
  | "nex_flag.create"
  | "nex_flag.resolve"
  | "parent.sms.send"
  | "coupon.create"
  | "coupon.deactivate"
  | "payments.replay_callback"
  | "support_case.create"
  | "support_case.update"
  | "feature_rollout.upsert"
  | "admin_alert.create"
  | "admin_alert.update"
  | "admin_role.assign"
  | "admin_communication_template.create"
  | "admin_experiment.create"
  | "admin_saved_view.create"
  | "admin_approval.create"
  | "admin_approval.update"
  | "admin_report_export";

/** Mutations that must abort when audit persistence fails (DEC-009 assumption A). */
export const CRITICAL_ADMIN_AUDIT_ACTIONS = new Set<AdminAuditAction>([
  "admin_role.assign",
  "payments.replay_callback",
  "feature_rollout.upsert",
  "user.impersonate.start",
  "coupon.create",
  "support_case.create",
  "platform_setting.update",
]);

export type AdminAuditLogEntry = {
  id: string;
  actor_user_id: string;
  actor_role: string;
  action: string;
  target_type: string | null;
  target_id: string | null;
  metadata: Record<string, unknown>;
  ip_address: string | null;
  user_agent: string | null;
  created_at: string;
};

function getClientIp(request: Request): string | null {
  const forwardedFor = request.headers.get("x-forwarded-for");
  if (forwardedFor) {
    const firstHop = forwardedFor.split(",")[0]?.trim();
    if (firstHop) {
      return firstHop;
    }
  }

  return null;
}

export async function recordAdminAudit(
  input: {
    actorUserId: string;
    actorRole: string;
    action: AdminAuditAction;
    targetType?: string;
    targetId?: string;
    metadata?: Record<string, unknown>;
    request?: Request;
  },
  options?: { failClosed?: boolean },
): Promise<AdminAuditRecordResult> {
  const failClosed =
    options?.failClosed ?? CRITICAL_ADMIN_AUDIT_ACTIONS.has(input.action);

  try {
    const admin = createAdminClient();

    const ipAddress = input.request ? getClientIp(input.request) : null;
    const userAgent = input.request
      ? input.request.headers.get("user-agent")
      : null;

    const { error } = await admin.from("admin_audit_log").insert({
      actor_user_id: input.actorUserId,
      actor_role: input.actorRole,
      action: input.action,
      target_type: input.targetType ?? null,
      target_id: input.targetId ?? null,
      metadata: input.metadata ?? {},
      ip_address: ipAddress,
      user_agent: userAgent,
    });

    if (error) {
      const message = error.message ?? "Audit insert failed";
      console.error("ADMIN_AUDIT_RECORD_FAILED", input.action, message);
      if (failClosed) {
        throw new AdminAuditWriteError(message);
      }
      return { ok: false, error: message };
    }

    return { ok: true };
  } catch (error) {
    if (error instanceof AdminAuditWriteError) {
      throw error;
    }

    const message =
      error instanceof Error ? error.message : "Audit insert failed";
    console.error("ADMIN_AUDIT_RECORD_FAILED", input.action, error);
    if (failClosed) {
      throw new AdminAuditWriteError(message);
    }
    return { ok: false, error: message };
  }
}

export async function listAdminAuditLog(filters: {
  action?: AdminAuditAction;
  actorUserId?: string;
  limit?: number;
  before?: string;
}): Promise<AdminAuditLogEntry[]> {
  const admin = createAdminClient();
  const limit = filters.limit ?? 50;

  let query = admin
    .from("admin_audit_log")
    .select(
      "id, actor_user_id, actor_role, action, target_type, target_id, metadata, ip_address, user_agent, created_at",
    )
    .order("created_at", { ascending: false })
    .limit(limit);

  if (filters.action) {
    query = query.eq("action", filters.action);
  }

  if (filters.actorUserId) {
    query = query.eq("actor_user_id", filters.actorUserId);
  }

  if (filters.before) {
    query = query.lt("created_at", filters.before);
  }

  const { data, error } = await query;

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []) as AdminAuditLogEntry[];
}
