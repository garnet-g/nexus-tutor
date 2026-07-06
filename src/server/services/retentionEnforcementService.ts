import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  DEC_006_IMPERSONATION_SESSION_RETENTION_DAYS,
  DEC_006_NOTIFICATION_LOG_RETENTION_DAYS,
  getRetentionCutoffIso,
  PARENT_LEARNING_REPORT_RETENTION_DAYS,
} from "@/lib/privacy/retentionPolicy";

export type RetentionEnforcementResult = {
  notificationSmsDeleted: number;
  notificationEmailDeleted: number;
  notificationOutboxDeleted: number;
  parentReportsDeleted: number;
  weeklyReportsDeleted: number;
  impersonationSessionsDeleted: number;
};

async function deleteOlderThan(
  table: string,
  column: string,
  cutoffIso: string,
  extraFilter?: { column: string; values: string[] },
): Promise<number> {
  const admin = createAdminClient();
  let query = admin.from(table).delete({ count: "exact" }).lt(column, cutoffIso);

  if (extraFilter) {
    query = query.in(extraFilter.column, extraFilter.values);
  }

  const { count, error } = await query;

  if (error) {
    throw new Error(`${table} retention delete failed: ${error.message}`);
  }

  return count ?? 0;
}

export async function enforceDataRetentionPolicies(): Promise<RetentionEnforcementResult> {
  const admin = createAdminClient();
  const notificationCutoff = getRetentionCutoffIso(DEC_006_NOTIFICATION_LOG_RETENTION_DAYS);
  const learningCutoff = getRetentionCutoffIso(PARENT_LEARNING_REPORT_RETENTION_DAYS);
  const impersonationCutoff = getRetentionCutoffIso(DEC_006_IMPERSONATION_SESSION_RETENTION_DAYS);

  const notificationSmsDeleted = await deleteOlderThan(
    "celcom_sms_logs",
    "created_at",
    notificationCutoff,
  );
  const notificationEmailDeleted = await deleteOlderThan(
    "resend_email_logs",
    "created_at",
    notificationCutoff,
  );
  const notificationOutboxDeleted = await deleteOlderThan(
    "notification_outbox",
    "created_at",
    notificationCutoff,
    { column: "status", values: ["sent", "dead_letter"] },
  );

  const { data: staleReports, error: staleReportsError } = await admin
    .from("parent_reports")
    .select("id")
    .lt("generated_at", learningCutoff);

  if (staleReportsError) {
    throw new Error(`parent_reports retention lookup failed: ${staleReportsError.message}`);
  }

  const staleReportIds = (staleReports ?? []).map((row) => row.id);
  let weeklyReportsDeleted = 0;

  if (staleReportIds.length > 0) {
    const { count: weeklyCount, error: weeklyError } = await admin
      .from("weekly_reports")
      .delete({ count: "exact" })
      .in("parent_report_id", staleReportIds);

    if (weeklyError) {
      throw new Error(`weekly_reports retention delete failed: ${weeklyError.message}`);
    }

    weeklyReportsDeleted = weeklyCount ?? 0;
  }

  const { count: parentReportsDeletedCount, error: parentDeleteError } = await admin
    .from("parent_reports")
    .delete({ count: "exact" })
    .lt("generated_at", learningCutoff);

  if (parentDeleteError) {
    throw new Error(`parent_reports retention delete failed: ${parentDeleteError.message}`);
  }

  const impersonationSessionsDeleted = await deleteOlderThan(
    "admin_impersonation_sessions",
    "expires_at",
    impersonationCutoff,
  );

  return {
    notificationSmsDeleted,
    notificationEmailDeleted,
    notificationOutboxDeleted,
    parentReportsDeleted: parentReportsDeletedCount ?? 0,
    weeklyReportsDeleted,
    impersonationSessionsDeleted,
  };
}
