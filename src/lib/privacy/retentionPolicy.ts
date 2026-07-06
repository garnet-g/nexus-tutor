/**
 * Data retention policy constants — implements DEC-006 option (A): keep the
 * repository's established 90-day notification log retention unless legal/product
 * records a different authority in DECISION-REGISTER.md.
 */
export const DEC_006_NOTIFICATION_LOG_RETENTION_DAYS = 90;
export const DEC_006_IMPERSONATION_SESSION_RETENTION_DAYS = 90;
export const PARENT_LEARNING_REPORT_RETENTION_DAYS = 365;

export type RetentionDomain =
  | "notification_logs"
  | "parent_learning_reports"
  | "impersonation_sessions";

export const RETENTION_POLICY: Record<
  RetentionDomain,
  { days: number; tables: string[]; description: string }
> = {
  notification_logs: {
    days: DEC_006_NOTIFICATION_LOG_RETENTION_DAYS,
    tables: ["celcom_sms_logs", "resend_email_logs", "notification_outbox"],
    description: "SMS/email delivery logs and completed outbox rows.",
  },
  parent_learning_reports: {
    days: PARENT_LEARNING_REPORT_RETENTION_DAYS,
    tables: ["parent_reports", "weekly_reports"],
    description: "Parent-facing weekly learning summaries (not account identity).",
  },
  impersonation_sessions: {
    days: DEC_006_IMPERSONATION_SESSION_RETENTION_DAYS,
    tables: ["admin_impersonation_sessions"],
    description: "View-as session evidence for admin support.",
  },
};

export function getRetentionCutoffIso(days: number, now: Date = new Date()): string {
  const cutoff = new Date(now.getTime() - days * 24 * 60 * 60 * 1000);
  return cutoff.toISOString();
}
