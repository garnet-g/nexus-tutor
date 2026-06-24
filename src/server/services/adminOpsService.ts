import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type { AdminCoupon } from "@/server/services/adminCouponService";
import { listCoupons } from "@/server/services/adminCouponService";
import { listFlags, type NexFlag } from "@/server/services/adminNexReviewService";
import { getNexOpsDashboard } from "@/server/services/adminNexOpsReadService";
import { getOutcomesDashboard } from "@/server/services/adminOutcomesReadService";
import { getPaymentsDashboard } from "@/server/services/adminPaymentsReadService";
import {
  buildCampaignSummary,
  buildContentQualitySummary,
  buildLifecycleFunnel,
  classifyStudentIntervention,
  type CampaignSummary,
  type ContentQualitySummary,
  type InterventionQueueItem,
  type LifecycleStep,
} from "@/server/services/adminOpsSummary";
import {
  getActiveSubjectsContentCoverage,
  getContentReviewQueue,
} from "@/server/services/contentAdminReadService";
import {
  listBetaInvites,
  type BetaInvite,
} from "@/server/services/betaInviteService";
import type {
  AdminFeatureRolloutUpsertInput,
  AdminSupportCaseCreateInput,
  AdminSupportCaseUpdateInput,
} from "@/schemas/adminOpsSchemas";

const MAX_COMMAND_CENTER_STUDENTS = 5000;
const INTERVENTION_LIMIT = 12;
const SUPPORT_CASE_LIMIT = 50;
const ROLLOUT_LIMIT = 100;

type StudentProfileOpsRow = {
  id: string;
  full_name: string | null;
  curriculum: string | null;
  grade_level: string | null;
  has_completed_diagnostic: boolean | null;
  created_at: string;
};

type HealthScoreRow = {
  student_id: string;
  health_score: number | string | null;
  calculated_at: string | null;
};

type UsageRow = {
  student_id: string;
  usage_date: string;
  nex_message_count: number | null;
  practice_session_count: number | null;
};

export type AdminSupportCase = {
  id: string;
  targetStudentId: string | null;
  targetParentId: string | null;
  targetName: string | null;
  issueType: string;
  priority: "low" | "medium" | "high" | "urgent";
  status: "open" | "in_progress" | "waiting_on_user" | "resolved";
  title: string;
  notes: string | null;
  assignedToUserId: string | null;
  createdBy: string | null;
  updatedBy: string | null;
  createdAt: string;
  updatedAt: string;
};

export type AdminFeatureRollout = {
  id: string;
  featureKey: string;
  displayName: string;
  description: string | null;
  isEnabled: boolean;
  scope: "global" | "curriculum" | "grade" | "cohort" | "student" | "role";
  scopeValue: string | null;
  updatedBy: string | null;
  createdAt: string;
  updatedAt: string;
};

export type AdminCommandCenterData = {
  lifecycle: LifecycleStep[];
  interventions: InterventionQueueItem[];
  contentQuality: ContentQualitySummary;
  campaignSummary: CampaignSummary;
  openFlags: NexFlag[];
  supportCases: AdminSupportCase[];
  rollouts: AdminFeatureRollout[];
  kpis: {
    totalStudents: number;
    openSupportCases: number;
    enabledRollouts: number;
    contentReviewItems: number;
    nexMessagesToday: number;
    estimatedNexCostKes7d: number;
    failedPayments: number;
    atRiskStudents: number;
  };
};

function nairobiDateDaysAgo(days: number): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(new Date(Date.now() - days * 24 * 60 * 60 * 1000));
}

function uniqueCount(rows: Array<{ student_id: string | null }>): number {
  return new Set(rows.map((row) => row.student_id).filter(Boolean)).size;
}

function mapSupportCase(
  row: Record<string, unknown>,
  studentNames: Map<string, string>,
  parentNames: Map<string, string>,
): AdminSupportCase {
  const studentId = (row.target_student_id as string | null) ?? null;
  const parentId = (row.target_parent_id as string | null) ?? null;
  return {
    id: row.id as string,
    targetStudentId: studentId,
    targetParentId: parentId,
    targetName:
      (studentId ? studentNames.get(studentId) : null) ??
      (parentId ? parentNames.get(parentId) : null) ??
      null,
    issueType: row.issue_type as string,
    priority: row.priority as AdminSupportCase["priority"],
    status: row.status as AdminSupportCase["status"],
    title: row.title as string,
    notes: (row.notes as string | null) ?? null,
    assignedToUserId: (row.assigned_to_user_id as string | null) ?? null,
    createdBy: (row.created_by as string | null) ?? null,
    updatedBy: (row.updated_by as string | null) ?? null,
    createdAt: row.created_at as string,
    updatedAt: row.updated_at as string,
  };
}

function mapRollout(row: Record<string, unknown>): AdminFeatureRollout {
  return {
    id: row.id as string,
    featureKey: row.feature_key as string,
    displayName: row.display_name as string,
    description: (row.description as string | null) ?? null,
    isEnabled: Boolean(row.is_enabled),
    scope: row.scope as AdminFeatureRollout["scope"],
    scopeValue: (row.scope_value as string | null) ?? null,
    updatedBy: (row.updated_by as string | null) ?? null,
    createdAt: row.created_at as string,
    updatedAt: row.updated_at as string,
  };
}

async function loadLatestHealthScores(
  studentIds: string[],
): Promise<Map<string, { healthScore: number; calculatedAt: string | null }>> {
  const healthByStudent = new Map<string, { healthScore: number; calculatedAt: string | null }>();
  if (studentIds.length === 0) {
    return healthByStudent;
  }

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("academic_health_scores")
    .select("student_id, health_score, calculated_at")
    .in("student_id", studentIds)
    .order("calculated_at", { ascending: false })
    .limit(MAX_COMMAND_CENTER_STUDENTS);

  if (error) {
    throw new Error(error.message);
  }

  for (const row of (data ?? []) as HealthScoreRow[]) {
    if (!healthByStudent.has(row.student_id)) {
      healthByStudent.set(row.student_id, {
        healthScore: Number(row.health_score ?? 0),
        calculatedAt: row.calculated_at ?? null,
      });
    }
  }

  return healthByStudent;
}

async function buildLifecycleAndInterventions(): Promise<{
  lifecycle: LifecycleStep[];
  interventions: InterventionQueueItem[];
  totalStudents: number;
}> {
  const admin = createAdminClient();
  const { data: students, error: studentError } = await admin
    .from("student_profiles")
    .select(
      "id, full_name, curriculum, grade_level, has_completed_diagnostic, created_at",
    )
    .order("created_at", { ascending: false })
    .limit(MAX_COMMAND_CENTER_STUDENTS);

  if (studentError) {
    throw new Error(studentError.message);
  }

  const studentRows = (students ?? []) as StudentProfileOpsRow[];
  const studentIds = studentRows.map((student) => student.id);
  const healthByStudent = await loadLatestHealthScores(studentIds);
  const weekStartDate = nairobiDateDaysAgo(6);

  const { data: usageRows, error: usageError } = await admin
    .from("nex_daily_usage")
    .select("student_id, usage_date, nex_message_count, practice_session_count")
    .gte("usage_date", weekStartDate);

  if (usageError) {
    throw new Error(usageError.message);
  }

  const usageByStudent = new Map<
    string,
    { nexMessagesLast7d: number; practiceSessionsLast7d: number; lastActivityAt: string | null }
  >();

  for (const row of (usageRows ?? []) as UsageRow[]) {
    const current = usageByStudent.get(row.student_id) ?? {
      nexMessagesLast7d: 0,
      practiceSessionsLast7d: 0,
      lastActivityAt: null,
    };
    current.nexMessagesLast7d += row.nex_message_count ?? 0;
    current.practiceSessionsLast7d += row.practice_session_count ?? 0;
    if (!current.lastActivityAt || row.usage_date > current.lastActivityAt) {
      current.lastActivityAt = row.usage_date;
    }
    usageByStudent.set(row.student_id, current);
  }

  const { data: nexSessions, error: nexError } = await admin
    .from("nex_sessions")
    .select("student_id")
    .limit(MAX_COMMAND_CENTER_STUDENTS);
  if (nexError) {
    throw new Error(nexError.message);
  }

  const { data: practiceSessions, error: practiceError } = await admin
    .from("practice_sessions")
    .select("student_id")
    .limit(MAX_COMMAND_CENTER_STUDENTS);
  if (practiceError) {
    throw new Error(practiceError.message);
  }

  const { data: trials, error: trialError } = await admin
    .from("subscription_trials")
    .select("student_id")
    .limit(MAX_COMMAND_CENTER_STUDENTS);
  if (trialError) {
    throw new Error(trialError.message);
  }

  const { data: subscriptions, error: subscriptionError } = await admin
    .from("student_subscriptions")
    .select("student_id, subscription_status, subscription_plans(plan_code)")
    .eq("subscription_status", "active")
    .limit(MAX_COMMAND_CENTER_STUDENTS);
  if (subscriptionError) {
    throw new Error(subscriptionError.message);
  }

  const paidStudentIds = new Set<string>();
  for (const row of subscriptions ?? []) {
    const relation = row.subscription_plans as
      | { plan_code?: string | null }
      | Array<{ plan_code?: string | null }>
      | null;
    const plan = Array.isArray(relation) ? relation[0] : relation;
    if (plan?.plan_code === "premium" || plan?.plan_code === "family") {
      paidStudentIds.add(row.student_id);
    }
  }

  const activeDay7 = Array.from(usageByStudent.values()).filter(
    (usage) =>
      usage.nexMessagesLast7d > 0 || usage.practiceSessionsLast7d > 0,
  ).length;

  const lifecycle = buildLifecycleFunnel({
    signups: studentRows.length,
    completedOnboarding: studentRows.length,
    diagnosticsCompleted: studentRows.filter(
      (student) => student.has_completed_diagnostic,
    ).length,
    firstNexChats: uniqueCount((nexSessions ?? []) as Array<{ student_id: string | null }>),
    firstPracticeSessions: uniqueCount(
      (practiceSessions ?? []) as Array<{ student_id: string | null }>,
    ),
    activeDay7,
    trialStarts: uniqueCount((trials ?? []) as Array<{ student_id: string | null }>),
    paidSubscriptions: paidStudentIds.size,
  });

  const interventions = studentRows
    .map((student) => {
      const health = healthByStudent.get(student.id);
      const usage = usageByStudent.get(student.id);
      return classifyStudentIntervention({
        studentId: student.id,
        studentName: student.full_name ?? "Unknown",
        curriculum: student.curriculum ?? "-",
        gradeLevel: student.grade_level ?? "-",
        hasCompletedDiagnostic: Boolean(student.has_completed_diagnostic),
        healthScore: health?.healthScore ?? null,
        lastActivityAt: usage?.lastActivityAt ?? health?.calculatedAt ?? null,
        nexMessagesLast7d: usage?.nexMessagesLast7d ?? 0,
        practiceSessionsLast7d: usage?.practiceSessionsLast7d ?? 0,
      });
    })
    .filter((item) => item.severity !== "watch" || item.reasons.length > 1)
    .sort((a, b) => {
      const severityRank = { critical: 0, urgent: 1, watch: 2 };
      return severityRank[a.severity] - severityRank[b.severity];
    })
    .slice(0, INTERVENTION_LIMIT);

  return { lifecycle, interventions, totalStudents: studentRows.length };
}

async function hydrateSupportCaseNames(rows: Record<string, unknown>[]) {
  const admin = createAdminClient();
  const studentIds = rows
    .map((row) => row.target_student_id)
    .filter((value): value is string => typeof value === "string");
  const parentIds = rows
    .map((row) => row.target_parent_id)
    .filter((value): value is string => typeof value === "string");

  const studentNames = new Map<string, string>();
  const parentNames = new Map<string, string>();

  if (studentIds.length > 0) {
    const { data, error } = await admin
      .from("student_profiles")
      .select("id, full_name")
      .in("id", studentIds);
    if (error) {
      throw new Error(error.message);
    }
    for (const row of data ?? []) {
      studentNames.set(row.id, row.full_name ?? "Unknown");
    }
  }

  if (parentIds.length > 0) {
    const { data, error } = await admin
      .from("parent_profiles")
      .select("id, full_name")
      .in("id", parentIds);
    if (error) {
      throw new Error(error.message);
    }
    for (const row of data ?? []) {
      parentNames.set(row.id, row.full_name ?? "Unknown");
    }
  }

  return { studentNames, parentNames };
}

export async function listSupportCases(filters: {
  status?: AdminSupportCase["status"];
  limit?: number;
} = {}): Promise<AdminSupportCase[]> {
  const admin = createAdminClient();
  let query = admin
    .from("admin_support_cases")
    .select(
      "id, target_student_id, target_parent_id, issue_type, priority, status, title, notes, assigned_to_user_id, created_by, updated_by, created_at, updated_at",
    )
    .order("created_at", { ascending: false })
    .limit(filters.limit ?? SUPPORT_CASE_LIMIT);

  if (filters.status) {
    query = query.eq("status", filters.status);
  }

  const { data, error } = await query;
  if (error) {
    throw new Error(error.message);
  }

  const rows = (data ?? []) as Record<string, unknown>[];
  const { studentNames, parentNames } = await hydrateSupportCaseNames(rows);
  return rows.map((row) => mapSupportCase(row, studentNames, parentNames));
}

export async function createSupportCase(input: {
  case: AdminSupportCaseCreateInput;
  actorUserId: string;
}): Promise<AdminSupportCase> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_support_cases")
    .insert({
      target_student_id: input.case.targetStudentId ?? null,
      target_parent_id: input.case.targetParentId ?? null,
      issue_type: input.case.issueType,
      priority: input.case.priority,
      status: input.case.status,
      title: input.case.title,
      notes: input.case.notes ?? null,
      created_by: input.actorUserId,
      updated_by: input.actorUserId,
    })
    .select(
      "id, target_student_id, target_parent_id, issue_type, priority, status, title, notes, assigned_to_user_id, created_by, updated_by, created_at, updated_at",
    )
    .single();

  if (error) {
    throw new Error(error.message);
  }

  const { studentNames, parentNames } = await hydrateSupportCaseNames([
    data as Record<string, unknown>,
  ]);
  return mapSupportCase(data as Record<string, unknown>, studentNames, parentNames);
}

export async function updateSupportCase(input: {
  update: AdminSupportCaseUpdateInput;
  actorUserId: string;
}): Promise<AdminSupportCase | null> {
  const admin = createAdminClient();
  const update: Record<string, unknown> = {
    updated_by: input.actorUserId,
  };

  if (input.update.priority) {
    update.priority = input.update.priority;
  }
  if (input.update.status) {
    update.status = input.update.status;
  }
  if (Object.prototype.hasOwnProperty.call(input.update, "notes")) {
    update.notes = input.update.notes ?? null;
  }
  if (Object.prototype.hasOwnProperty.call(input.update, "assignedToUserId")) {
    update.assigned_to_user_id = input.update.assignedToUserId ?? null;
  }

  const { data, error } = await admin
    .from("admin_support_cases")
    .update(update)
    .eq("id", input.update.caseId)
    .select(
      "id, target_student_id, target_parent_id, issue_type, priority, status, title, notes, assigned_to_user_id, created_by, updated_by, created_at, updated_at",
    )
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }
  if (!data) {
    return null;
  }

  const { studentNames, parentNames } = await hydrateSupportCaseNames([
    data as Record<string, unknown>,
  ]);
  return mapSupportCase(data as Record<string, unknown>, studentNames, parentNames);
}

export async function listFeatureRollouts(): Promise<AdminFeatureRollout[]> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_feature_rollouts")
    .select(
      "id, feature_key, display_name, description, is_enabled, scope, scope_value, updated_by, created_at, updated_at",
    )
    .order("feature_key", { ascending: true })
    .limit(ROLLOUT_LIMIT);

  if (error) {
    throw new Error(error.message);
  }

  return ((data ?? []) as Record<string, unknown>[]).map(mapRollout);
}

export async function upsertFeatureRollout(input: {
  rollout: AdminFeatureRolloutUpsertInput;
  actorUserId: string;
}): Promise<AdminFeatureRollout> {
  const admin = createAdminClient();
  const rollout = input.rollout;
  const { data, error } = await admin
    .from("admin_feature_rollouts")
    .upsert(
      {
        feature_key: rollout.featureKey,
        display_name: rollout.displayName,
        description: rollout.description ?? null,
        is_enabled: rollout.isEnabled,
        scope: rollout.scope,
        scope_value: rollout.scope === "global" ? null : rollout.scopeValue,
        updated_by: input.actorUserId,
      },
      { onConflict: "feature_key,scope,scope_value" },
    )
    .select(
      "id, feature_key, display_name, description, is_enabled, scope, scope_value, updated_by, created_at, updated_at",
    )
    .single();

  if (error) {
    throw new Error(error.message);
  }

  return mapRollout(data as Record<string, unknown>);
}

export async function getAdminCommandCenterData(): Promise<AdminCommandCenterData> {
  const [
    lifecycleResult,
    coverage,
    reviewQueue,
    openFlags,
    supportCases,
    rollouts,
    invites,
    coupons,
    nexOps,
    payments,
    outcomes,
  ] = await Promise.all([
    buildLifecycleAndInterventions(),
    getActiveSubjectsContentCoverage(),
    getContentReviewQueue(),
    listFlags({ status: "open", limit: 8 }),
    listSupportCases({ limit: 8 }),
    listFeatureRollouts(),
    listBetaInvites(),
    listCoupons({ limit: 50 }),
    getNexOpsDashboard({ limit: 8 }),
    getPaymentsDashboard({ limit: 25 }),
    getOutcomesDashboard({ limit: 25 }),
  ]);

  const contentQuality = buildContentQualitySummary(coverage);
  const campaignSummary = buildCampaignSummary({
    invites: invites as BetaInvite[],
    coupons: coupons as AdminCoupon[],
  });

  return {
    lifecycle: lifecycleResult.lifecycle,
    interventions: lifecycleResult.interventions,
    contentQuality,
    campaignSummary,
    openFlags,
    supportCases,
    rollouts,
    kpis: {
      totalStudents: lifecycleResult.totalStudents,
      openSupportCases: supportCases.filter((item) => item.status !== "resolved")
        .length,
      enabledRollouts: rollouts.filter((rollout) => rollout.isEnabled).length,
      contentReviewItems: reviewQueue.length,
      nexMessagesToday: nexOps.messagesToday,
      estimatedNexCostKes7d: nexOps.estimatedCostKesLast7d,
      failedPayments: payments.kpis.failedCount,
      atRiskStudents: outcomes.atRisk.length,
    },
  };
}
