import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { listCoupons } from "@/server/services/adminCouponService";
import { listFlags } from "@/server/services/adminNexReviewService";
import { getNexOpsDashboard } from "@/server/services/adminNexOpsReadService";
import { getPaymentsDashboard } from "@/server/services/adminPaymentsReadService";
import { isFeatureEnabled } from "@/server/services/featureRolloutService";
import {
  getEffectiveSubscriptionConfigWithFallback,
  getNexDailyLimit,
} from "@/lib/platform/getPlatformSettings";
import {
  getStudentPlanCode,
} from "@/server/services/subscriptionService";
import { listSupportCases } from "@/server/services/adminOpsService";
import {
  ADMIN_PLATFORM_NAV,
  ADMIN_ROLE_PERMISSIONS,
  buildAdminTaskInbox,
  buildEntitlementDebug,
  buildStudentTimeline,
  type AdminOperationalRole,
  type AdminTaskSourceItem,
  type EntitlementDebug,
  type StudentTimelineEvent,
} from "@/server/services/adminPlatformSummary";
import { getContentReviewQueue } from "@/server/services/contentAdminReadService";
import type {
  AdminAlertCreateInput,
  AdminAlertUpdateInput,
  AdminApprovalCreateInput,
  AdminApprovalUpdateInput,
  AdminCommunicationTemplateCreateInput,
  AdminExperimentCreateInput,
  AdminSavedViewCreateInput,
} from "@/schemas/adminPlatformSchemas";

const DEFAULT_LIMIT = 100;

export type AdminAlert = {
  id: string;
  alertType: string;
  severity: "critical" | "urgent" | "watch";
  title: string;
  description: string | null;
  source: string;
  status: "open" | "acknowledged" | "resolved";
  targetType: string | null;
  targetId: string | null;
  createdAt: string;
  updatedAt: string;
};

export type AdminRoleAssignment = {
  id: string;
  userId: string;
  roleKey: AdminOperationalRole;
  assignedBy: string | null;
  createdAt: string;
};

export type AdminCommunicationTemplate = {
  id: string;
  templateKey: string;
  channel: "sms" | "email";
  title: string;
  body: string;
  isActive: boolean;
  createdAt: string;
};

export type AdminCommunicationLog = {
  id: string;
  channel: "sms" | "email";
  recipient: string | null;
  status: "queued" | "sent" | "failed" | "mocked";
  messageBody: string;
  createdAt: string;
};

export type AdminExperiment = {
  id: string;
  experimentKey: string;
  title: string;
  hypothesis: string | null;
  status: "draft" | "running" | "paused" | "completed";
  metricKey: string;
  variants: string[];
  createdAt: string;
};

export type AdminSavedView = {
  id: string;
  viewKey: string;
  title: string;
  route: string;
  filters: Record<string, unknown>;
  isShared: boolean;
  createdAt: string;
};

export type AdminApprovalRequest = {
  id: string;
  requestType: string;
  title: string;
  description: string | null;
  targetType: string | null;
  targetId: string | null;
  status: "pending" | "approved" | "rejected" | "cancelled";
  requestedBy: string | null;
  reviewedBy: string | null;
  createdAt: string;
  metadata?: Record<string, unknown>;
};

export type AdminSystemHealthItem = {
  name: string;
  status: "healthy" | "watch" | "critical";
  detail: string;
};

export type AdminReportCard = {
  title: string;
  href: string;
  description: string;
  exportKey: string;
};

export type AdminSearchItem = {
  title: string;
  href: string;
  type: string;
  description: string;
};

export type Student360Data = {
  timeline: StudentTimelineEvent[];
  entitlement: EntitlementDebug;
  supportCaseCount: number;
};

function asRecord(row: unknown): Record<string, unknown> {
  return row && typeof row === "object" ? (row as Record<string, unknown>) : {};
}

function mapAlert(row: unknown): AdminAlert {
  const data = asRecord(row);
  return {
    id: data.id as string,
    alertType: data.alert_type as string,
    severity: data.severity as AdminAlert["severity"],
    title: data.title as string,
    description: (data.description as string | null) ?? null,
    source: data.source as string,
    status: data.status as AdminAlert["status"],
    targetType: (data.target_type as string | null) ?? null,
    targetId: (data.target_id as string | null) ?? null,
    createdAt: data.created_at as string,
    updatedAt: data.updated_at as string,
  };
}

function mapRole(row: unknown): AdminRoleAssignment {
  const data = asRecord(row);
  return {
    id: data.id as string,
    userId: data.user_id as string,
    roleKey: data.role_key as AdminOperationalRole,
    assignedBy: (data.assigned_by as string | null) ?? null,
    createdAt: data.created_at as string,
  };
}

function mapTemplate(row: unknown): AdminCommunicationTemplate {
  const data = asRecord(row);
  return {
    id: data.id as string,
    templateKey: data.template_key as string,
    channel: data.channel as AdminCommunicationTemplate["channel"],
    title: data.title as string,
    body: data.body as string,
    isActive: Boolean(data.is_active),
    createdAt: data.created_at as string,
  };
}

function mapCommunicationLog(row: unknown): AdminCommunicationLog {
  const data = asRecord(row);
  return {
    id: data.id as string,
    channel: data.channel as AdminCommunicationLog["channel"],
    recipient: (data.recipient as string | null) ?? null,
    status: data.status as AdminCommunicationLog["status"],
    messageBody: data.message_body as string,
    createdAt: data.created_at as string,
  };
}

function mapExperiment(row: unknown): AdminExperiment {
  const data = asRecord(row);
  return {
    id: data.id as string,
    experimentKey: data.experiment_key as string,
    title: data.title as string,
    hypothesis: (data.hypothesis as string | null) ?? null,
    status: data.status as AdminExperiment["status"],
    metricKey: data.metric_key as string,
    variants: Array.isArray(data.variants) ? (data.variants as string[]) : [],
    createdAt: data.created_at as string,
  };
}

function mapSavedView(row: unknown): AdminSavedView {
  const data = asRecord(row);
  return {
    id: data.id as string,
    viewKey: data.view_key as string,
    title: data.title as string,
    route: data.route as string,
    filters: asRecord(data.filters),
    isShared: Boolean(data.is_shared),
    createdAt: data.created_at as string,
  };
}

function mapApproval(row: unknown): AdminApprovalRequest {
  const data = asRecord(row);
  return {
    id: data.id as string,
    requestType: data.request_type as string,
    title: data.title as string,
    description: (data.description as string | null) ?? null,
    targetType: (data.target_type as string | null) ?? null,
    targetId: (data.target_id as string | null) ?? null,
    status: data.status as AdminApprovalRequest["status"],
    requestedBy: (data.requested_by as string | null) ?? null,
    reviewedBy: (data.reviewed_by as string | null) ?? null,
    createdAt: data.created_at as string,
    metadata: asRecord(data.metadata),
  };
}

export function isBulkActionRequestType(requestType: string): boolean {
  return requestType.startsWith("bulk_");
}

export async function listAdminAlerts(status?: AdminAlert["status"]) {
  const admin = createAdminClient();
  let query = admin
    .from("admin_alerts")
    .select("id, alert_type, severity, title, description, source, status, target_type, target_id, created_at, updated_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (status) {
    query = query.eq("status", status);
  }
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapAlert);
}

export async function createAdminAlert(input: {
  alert: AdminAlertCreateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_alerts")
    .insert({
      alert_type: input.alert.alertType,
      severity: input.alert.severity,
      title: input.alert.title,
      description: input.alert.description ?? null,
      source: input.alert.source,
      target_type: input.alert.targetType ?? null,
      target_id: input.alert.targetId ?? null,
      metadata: input.alert.metadata,
      assigned_to_user_id: input.actorUserId,
    })
    .select("id, alert_type, severity, title, description, source, status, target_type, target_id, created_at, updated_at")
    .single();
  if (error) throw new Error(error.message);
  return mapAlert(data);
}

export async function updateAdminAlert(input: {
  update: AdminAlertUpdateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const update: Record<string, unknown> = { status: input.update.status };
  if (input.update.status === "resolved") {
    update.resolved_by = input.actorUserId;
    update.resolved_at = new Date().toISOString();
  }
  const { data, error } = await admin
    .from("admin_alerts")
    .update(update)
    .eq("id", input.update.alertId)
    .select("id, alert_type, severity, title, description, source, status, target_type, target_id, created_at, updated_at")
    .maybeSingle();
  if (error) throw new Error(error.message);
  return data ? mapAlert(data) : null;
}

export async function listAdminRoleAssignments() {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_role_assignments")
    .select("id, user_id, role_key, assigned_by, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapRole);
}

export async function assignAdminRole(input: {
  assignment: import("@/schemas/adminPlatformSchemas").AdminRoleAssignmentInput;
  actorUserId: string;
}) {
  const { assignAdminRole: assignRole } = await import(
    "@/server/services/adminRoleService"
  );
  return assignRole(input);
}

export async function listCommunicationTemplates() {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_communication_templates")
    .select("id, template_key, channel, title, body, is_active, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapTemplate);
}

export async function listCommunicationLogs() {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_communication_logs")
    .select("id, channel, recipient, status, message_body, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapCommunicationLog);
}

export async function createCommunicationTemplate(input: {
  template: AdminCommunicationTemplateCreateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_communication_templates")
    .insert({
      template_key: input.template.templateKey,
      channel: input.template.channel,
      title: input.template.title,
      body: input.template.body,
      created_by: input.actorUserId,
      updated_by: input.actorUserId,
    })
    .select("id, template_key, channel, title, body, is_active, created_at")
    .single();
  if (error) throw new Error(error.message);
  return mapTemplate(data);
}

export async function listExperiments() {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_experiments")
    .select("id, experiment_key, title, hypothesis, status, metric_key, variants, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapExperiment);
}

export async function createExperiment(input: {
  experiment: AdminExperimentCreateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_experiments")
    .insert({
      experiment_key: input.experiment.experimentKey,
      title: input.experiment.title,
      hypothesis: input.experiment.hypothesis ?? null,
      metric_key: input.experiment.metricKey,
      variants: input.experiment.variants,
      created_by: input.actorUserId,
      updated_by: input.actorUserId,
    })
    .select("id, experiment_key, title, hypothesis, status, metric_key, variants, created_at")
    .single();
  if (error) throw new Error(error.message);
  return mapExperiment(data);
}

export async function listSavedViews() {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_saved_views")
    .select("id, view_key, title, route, filters, is_shared, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapSavedView);
}

export async function createSavedView(input: {
  view: AdminSavedViewCreateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_saved_views")
    .insert({
      view_key: input.view.viewKey,
      title: input.view.title,
      route: input.view.route,
      filters: input.view.filters,
      is_shared: input.view.isShared,
      owner_user_id: input.actorUserId,
    })
    .select("id, view_key, title, route, filters, is_shared, created_at")
    .single();
  if (error) throw new Error(error.message);
  return mapSavedView(data);
}

export async function getApprovalById(
  approvalId: string,
): Promise<AdminApprovalRequest | null> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_approval_requests")
    .select(
      "id, request_type, title, description, target_type, target_id, status, requested_by, reviewed_by, created_at, metadata",
    )
    .eq("id", approvalId)
    .maybeSingle();
  if (error) throw new Error(error.message);
  return data ? mapApproval(data) : null;
}

export async function listApprovals(status?: AdminApprovalRequest["status"]) {
  const admin = createAdminClient();
  let query = admin
    .from("admin_approval_requests")
    .select("id, request_type, title, description, target_type, target_id, status, requested_by, reviewed_by, created_at")
    .order("created_at", { ascending: false })
    .limit(DEFAULT_LIMIT);
  if (status) {
    query = query.eq("status", status);
  }
  const { data, error } = await query;
  if (error) throw new Error(error.message);
  return (data ?? []).map(mapApproval);
}

export async function createApproval(input: {
  approval: AdminApprovalCreateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_approval_requests")
    .insert({
      request_type: input.approval.requestType,
      title: input.approval.title,
      description: input.approval.description ?? null,
      target_type: input.approval.targetType ?? null,
      target_id: input.approval.targetId ?? null,
      requested_by: input.actorUserId,
      metadata: input.approval.metadata,
    })
    .select("id, request_type, title, description, target_type, target_id, status, requested_by, reviewed_by, created_at")
    .single();
  if (error) throw new Error(error.message);
  return mapApproval(data);
}

export async function markApprovalExecuted(input: {
  approvalId: string;
  executionSummary: Record<string, unknown>;
}) {
  const admin = createAdminClient();
  const existing = await getApprovalById(input.approvalId);
  if (!existing) {
    return null;
  }

  const metadata = {
    ...(existing.metadata ?? {}),
    executedAt: new Date().toISOString(),
    executionSummary: input.executionSummary,
  };

  const { data, error } = await admin
    .from("admin_approval_requests")
    .update({ metadata })
    .eq("id", input.approvalId)
    .select(
      "id, request_type, title, description, target_type, target_id, status, requested_by, reviewed_by, created_at, metadata",
    )
    .maybeSingle();
  if (error) throw new Error(error.message);
  return data ? mapApproval(data) : null;
}

export async function updateApproval(input: {
  update: AdminApprovalUpdateInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_approval_requests")
    .update({
      status: input.update.status,
      reviewed_by: input.actorUserId,
      reviewed_at: new Date().toISOString(),
    })
    .eq("id", input.update.approvalId)
    .select("id, request_type, title, description, target_type, target_id, status, requested_by, reviewed_by, created_at")
    .maybeSingle();
  if (error) throw new Error(error.message);
  return data ? mapApproval(data) : null;
}

export async function getAdminTaskInbox() {
  const [alerts, supportCases, flags, reviewQueue, payments, approvals] =
    await Promise.all([
      listAdminAlerts("open").catch(() => []),
      listSupportCases({ limit: 25 }).catch(() => []),
      listFlags({ status: "open", limit: 25 }).catch(() => []),
      getContentReviewQueue().catch(() => []),
      getPaymentsDashboard({ limit: 25 }).catch(() => null),
      listApprovals("pending").catch(() => []),
    ]);

  const tasks: AdminTaskSourceItem[] = [
    ...alerts.map((alert) => ({
      id: alert.id,
      source: "alert" as const,
      title: alert.title,
      href: "/admin/alerts",
      severity: alert.severity,
      createdAt: alert.createdAt,
      description: alert.description,
    })),
    ...supportCases
      .filter((item) => item.status !== "resolved")
      .map((item) => ({
        id: item.id,
        source: "support" as const,
        title: item.title,
        href: "/admin/support",
        severity:
          item.priority === "urgent"
            ? ("urgent" as const)
            : item.priority === "high"
              ? ("urgent" as const)
              : ("watch" as const),
        createdAt: item.createdAt,
        description: item.issueType,
      })),
    ...flags.map((flag) => ({
      id: flag.id,
      source: "nex" as const,
      title: flag.reason ?? "Nex message flagged",
      href: "/admin/nex-ops",
      severity: "urgent" as const,
      createdAt: flag.createdAt,
      description: flag.studentName,
    })),
    ...reviewQueue.map((item) => ({
      id: `${item.kind}-${item.id}`,
      source: "content" as const,
      title: item.kind === "lesson" ? item.title : item.questionText,
      href: "/admin/studio/review",
      severity: "watch" as const,
      createdAt: item.submittedAt ?? new Date(0).toISOString(),
      description: item.topicTitle,
    })),
    ...(payments && payments.kpis.failedCount > 0
      ? [
          {
            id: "failed-payments",
            source: "payment" as const,
            title: `${payments.kpis.failedCount} failed payments`,
            href: "/admin/revenue-ops",
            severity: "urgent" as const,
            createdAt: new Date().toISOString(),
            description: "Review M-Pesa failures",
          },
        ]
      : []),
    ...approvals.map((approval) => ({
      id: approval.id,
      source: "approval" as const,
      title: approval.title,
      href: "/admin/approvals",
      severity: "urgent" as const,
      createdAt: approval.createdAt,
      description: approval.requestType,
    })),
  ];

  return buildAdminTaskInbox(tasks);
}

export async function getSystemHealth(): Promise<AdminSystemHealthItem[]> {
  const [nexOps, payments, flags, alerts] = await Promise.all([
    getNexOpsDashboard({ limit: 1 }).catch(() => null),
    getPaymentsDashboard({ limit: 1 }).catch(() => null),
    listFlags({ status: "open", limit: 100 }).catch(() => []),
    listAdminAlerts("open").catch(() => []),
  ]);

  return [
    {
      name: "Supabase data",
      status: "healthy",
      detail: "Admin service-role reads are available.",
    },
    {
      name: "Nex provider",
      status:
        nexOps && nexOps.fallbackRate !== null && nexOps.fallbackRate > 0.25
          ? "watch"
          : "healthy",
      detail: nexOps
        ? `${nexOps.messagesToday.toLocaleString()} messages today`
        : "No Nex activity data available.",
    },
    {
      name: "M-Pesa ledger",
      status: payments && payments.kpis.failedCount > 0 ? "watch" : "healthy",
      detail: payments
        ? `${payments.kpis.failedCount.toLocaleString()} failed payments recorded`
        : "Payment ledger unavailable.",
    },
    {
      name: "Nex safety queue",
      status: flags.length > 10 ? "watch" : "healthy",
      detail: `${flags.length.toLocaleString()} open flags`,
    },
    {
      name: "Admin alerts",
      status: alerts.some((alert) => alert.severity === "critical")
        ? "critical"
        : alerts.length > 0
          ? "watch"
          : "healthy",
      detail: `${alerts.length.toLocaleString()} open alerts`,
    },
  ];
}

export function getReportCards(): AdminReportCard[] {
  return [
    {
      title: "Users",
      href: "/admin/users",
      description: "Student and parent directory with status filters.",
      exportKey: "users",
    },
    {
      title: "Payments",
      href: "/admin/payments",
      description: "M-Pesa ledger, subscription funnel, failed payments.",
      exportKey: "payments",
    },
    {
      title: "Content coverage",
      href: "/admin/studio",
      description: "Curriculum coverage and review queue.",
      exportKey: "content",
    },
    {
      title: "Audit log",
      href: "/admin/audit-log",
      description: "Privileged admin actions and mutation history.",
      exportKey: "audit",
    },
  ];
}

export async function getAdminSearchItems(): Promise<AdminSearchItem[]> {
  const [supportCases, alerts, approvals, templates, experiments, savedViews] =
    await Promise.all([
      listSupportCases({ limit: 20 }).catch(() => []),
      listAdminAlerts().catch(() => []),
      listApprovals().catch(() => []),
      listCommunicationTemplates().catch(() => []),
      listExperiments().catch(() => []),
      listSavedViews().catch(() => []),
    ]);

  return [
    ...ADMIN_PLATFORM_NAV.map((item) => ({
      title: item.label,
      href: item.href,
      type: "page",
      description: item.area,
    })),
    ...supportCases.map((item) => ({
      title: item.title,
      href: "/admin/support",
      type: "support",
      description: item.issueType,
    })),
    ...alerts.map((item) => ({
      title: item.title,
      href: "/admin/alerts",
      type: "alert",
      description: item.severity,
    })),
    ...approvals.map((item) => ({
      title: item.title,
      href: "/admin/approvals",
      type: "approval",
      description: item.status,
    })),
    ...templates.map((item) => ({
      title: item.title,
      href: "/admin/communications",
      type: "template",
      description: item.channel,
    })),
    ...experiments.map((item) => ({
      title: item.title,
      href: "/admin/experiments",
      type: "experiment",
      description: item.status,
    })),
    ...savedViews.map((item) => ({
      title: item.title,
      href: item.route,
      type: "saved view",
      description: item.viewKey,
    })),
  ];
}

export async function getAiQualityDashboard() {
  const [nexOps, flags] = await Promise.all([
    getNexOpsDashboard({ limit: 20 }).catch(() => null),
    listFlags({ limit: 50 }).catch(() => []),
  ]);
  return {
    nexOps,
    flags,
    openFlags: flags.filter((flag) => flag.status === "open").length,
    escalatedFlags: flags.filter((flag) => flag.status === "escalated").length,
  };
}

export async function getContentCalendarDashboard() {
  const reviewQueue = await getContentReviewQueue().catch(() => []);
  return {
    reviewQueue,
    dueThisWeek: reviewQueue.slice(0, 12),
  };
}

export async function getRevenueOpsDashboard() {
  const [payments, coupons] = await Promise.all([
    getPaymentsDashboard({ limit: 100 }).catch(() => null),
    listCoupons({ limit: 100 }).catch(() => []),
  ]);
  return { payments, coupons };
}

export async function getStudent360Data(studentId: string): Promise<Student360Data> {
  const admin = createAdminClient();
  const [
    supportCases,
    usageRows,
    healthRows,
    paymentRows,
    planCode,
    config,
    studentProfileRow,
    subscriptionRow,
  ] = await Promise.all([
    listSupportCases({ limit: 100 }).catch(() => []),
    admin
      .from("nex_daily_usage")
      .select("usage_date, nex_message_count, practice_session_count")
      .eq("student_id", studentId)
      .order("usage_date", { ascending: false })
      .limit(10),
    admin
      .from("academic_health_scores")
      .select("health_score, predicted_grade, calculated_at")
      .eq("student_id", studentId)
      .order("calculated_at", { ascending: false })
      .limit(5),
    admin
      .from("mpesa_payments")
      .select("amount_kes, payment_status, created_at")
      .eq("student_id", studentId)
      .order("created_at", { ascending: false })
      .limit(5),
    getStudentPlanCode(studentId).catch(() => "free"),
    getEffectiveSubscriptionConfigWithFallback(),
    admin
      .from("student_profiles")
      .select("curriculum, grade_level")
      .eq("id", studentId)
      .maybeSingle(),
    admin
      .from("student_subscriptions")
      .select("subscription_status")
      .eq("student_id", studentId)
      .in("subscription_status", ["trialing", "active"])
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
  ]);

  const subscriptionStatus =
    (subscriptionRow.data?.subscription_status as string | null) ??
    (planCode === "free" ? "active" : "active");
  const trialActive = subscriptionStatus === "trialing";

  const dailyUsage =
    ((usageRows.data ?? [])[0]?.nex_message_count as number | null) ?? 0;
  const dailyLimit = getNexDailyLimit(config, planCode);
  const featureEnabled = await isFeatureEnabled("student.study_search", {
    studentId,
    curriculum: studentProfileRow.data?.curriculum ?? null,
    gradeLevel: studentProfileRow.data?.grade_level ?? null,
    role: "student",
  });

  const events: StudentTimelineEvent[] = [
    ...((usageRows.data ?? []) as Array<{
      usage_date: string;
      nex_message_count: number | null;
      practice_session_count: number | null;
    }>).map((row) => ({
      kind: "nex" as const,
      title: `${row.nex_message_count ?? 0} Nex / ${row.practice_session_count ?? 0} practice`,
      occurredAt: `${row.usage_date}T00:00:00.000Z`,
      description: "Daily usage rollup",
    })),
    ...((healthRows.data ?? []) as Array<{
      health_score: number | string;
      predicted_grade: string | null;
      calculated_at: string;
    }>).map((row) => ({
      kind: "diagnostic" as const,
      title: `Health score ${Number(row.health_score).toFixed(1)}`,
      occurredAt: row.calculated_at,
      description: row.predicted_grade,
    })),
    ...((paymentRows.data ?? []) as Array<{
      amount_kes: number | null;
      payment_status: string | null;
      created_at: string;
    }>).map((row) => ({
      kind: "payment" as const,
      title: `Payment ${row.payment_status ?? "pending"}`,
      occurredAt: row.created_at,
      description: `KES ${(row.amount_kes ?? 0).toLocaleString()}`,
    })),
    ...supportCases
      .filter((item) => item.targetStudentId === studentId)
      .map((item) => ({
        kind: "support" as const,
        title: item.title,
        occurredAt: item.createdAt,
        description: item.status,
        href: "/admin/support",
      })),
  ];

  return {
    timeline: buildStudentTimeline(events),
    entitlement: buildEntitlementDebug({
      planCode,
      subscriptionStatus,
      trialActive,
      featureEnabled,
      dailyLimit,
      dailyUsage,
    }),
    supportCaseCount: supportCases.filter((item) => item.targetStudentId === studentId)
      .length,
  };
}

export { ADMIN_PLATFORM_NAV, ADMIN_ROLE_PERMISSIONS };
