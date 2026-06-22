import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { UsersQueryInput } from "@/schemas/adminSchemas";

/**
 * Read-only User directory + detail service for the super-admin portal (Phase 3a).
 *
 * Source tables:
 *  - student_profiles (id, user_id, full_name, curriculum, grade_level, is_active, created_at)
 *  - parent_profiles (id, user_id, full_name, is_active, created_at)
 *  - student_subscriptions (subscription_status + subscription_plan_id) — current sub
 *  - subscription_plans (plan_code, name) — labels for current sub
 *  - subscription_trials (is_trial_active, trial_ends_at) — trial state for detail
 *  - nex_daily_usage (nex_message_count, practice_session_count, usage_date) — today / 7d
 *  - academic_health_scores (health_score, predicted_grade, calculated_at) — latest
 *  - student_parent_links (parent_id, link_status) -> parent_profiles — linked parents
 *
 * All reads go through the service-role client and are null-safe.
 */

const DIRECTORY_DEFAULT_LIMIT = 50;

type UserType = "student" | "parent";

export type DirectoryUserRow = {
  id: string;
  fullName: string;
  type: UserType;
  curriculum: string | null;
  gradeLevel: string | null;
  isActive: boolean;
  subscriptionStatus: string | null;
  createdAt: string;
};

type PlanLite = { planCode: string; name: string };
type PlanLookup = Map<string, PlanLite>;

async function loadPlans(
  admin: ReturnType<typeof createAdminClient>,
): Promise<PlanLookup> {
  const { data, error } = await admin
    .from("subscription_plans")
    .select("id, plan_code, name");

  if (error) {
    throw new Error(error.message);
  }

  const lookup: PlanLookup = new Map();
  for (const row of data ?? []) {
    lookup.set(row.id, {
      planCode: row.plan_code ?? "",
      name: row.name ?? "—",
    });
  }
  return lookup;
}

/**
 * Map of student_id -> latest subscription_status. Picks the most recent
 * subscription per student by created_at.
 */
async function loadStudentSubscriptionStatus(
  admin: ReturnType<typeof createAdminClient>,
  studentIds: string[],
): Promise<Map<string, string>> {
  const byStudent = new Map<string, string>();
  if (studentIds.length === 0) {
    return byStudent;
  }

  const { data, error } = await admin
    .from("student_subscriptions")
    .select("student_id, subscription_status, created_at")
    .in("student_id", studentIds)
    .order("created_at", { ascending: false });

  if (error) {
    throw new Error(error.message);
  }

  for (const row of data ?? []) {
    // First row per student wins (descending created_at).
    if (!byStudent.has(row.student_id)) {
      byStudent.set(row.student_id, row.subscription_status ?? "active");
    }
  }
  return byStudent;
}

export async function listUsers(
  filters: UsersQueryInput = {},
): Promise<DirectoryUserRow[]> {
  const admin = createAdminClient();
  const limit = filters.limit ?? DIRECTORY_DEFAULT_LIMIT;
  const includeStudents = filters.type !== "parent";
  const includeParents = filters.type !== "student";

  const rows: DirectoryUserRow[] = [];

  if (includeStudents) {
    let studentQuery = admin
      .from("student_profiles")
      .select("id, full_name, curriculum, grade_level, is_active, created_at")
      .order("created_at", { ascending: false })
      .limit(limit);

    if (filters.query) {
      studentQuery = studentQuery.ilike("full_name", `%${filters.query}%`);
    }
    if (filters.before) {
      studentQuery = studentQuery.lt("created_at", filters.before);
    }

    const { data: students, error: studentError } = await studentQuery;
    if (studentError) {
      throw new Error(studentError.message);
    }

    const studentIds = (students ?? []).map((row) => row.id);
    const statusByStudent = await loadStudentSubscriptionStatus(
      admin,
      studentIds,
    );

    for (const row of students ?? []) {
      rows.push({
        id: row.id,
        fullName: row.full_name ?? "Unknown",
        type: "student",
        curriculum: row.curriculum ?? null,
        gradeLevel: row.grade_level ?? null,
        isActive: row.is_active ?? true,
        subscriptionStatus: statusByStudent.get(row.id) ?? null,
        createdAt: row.created_at,
      });
    }
  }

  if (includeParents) {
    let parentQuery = admin
      .from("parent_profiles")
      .select("id, full_name, is_active, created_at")
      .order("created_at", { ascending: false })
      .limit(limit);

    if (filters.query) {
      parentQuery = parentQuery.ilike("full_name", `%${filters.query}%`);
    }
    if (filters.before) {
      parentQuery = parentQuery.lt("created_at", filters.before);
    }

    const { data: parents, error: parentError } = await parentQuery;
    if (parentError) {
      throw new Error(parentError.message);
    }

    for (const row of parents ?? []) {
      rows.push({
        id: row.id,
        fullName: row.full_name ?? "Unknown",
        type: "parent",
        curriculum: null,
        gradeLevel: null,
        isActive: row.is_active ?? true,
        subscriptionStatus: null,
        createdAt: row.created_at,
      });
    }
  }

  rows.sort((a, b) => b.createdAt.localeCompare(a.createdAt));
  return rows.slice(0, limit);
}

export type UserSubscriptionDetail = {
  status: string;
  planCode: string | null;
  planName: string | null;
  currentPeriodEnd: string | null;
  trialEndsAt: string | null;
  isTrialActive: boolean;
} | null;

export type UserUsageDetail = {
  todayNexMessages: number;
  todayPracticeSessions: number;
  last7dNexMessages: number;
  last7dPracticeSessions: number;
};

export type UserHealthDetail = {
  healthScore: number;
  predictedGrade: string | null;
  calculatedAt: string;
} | null;

export type LinkedParent = {
  parentId: string;
  fullName: string;
  email: string | null;
  phoneNumber: string | null;
  linkStatus: string;
};

export type UserDetail = {
  id: string;
  userId: string;
  fullName: string;
  email: string | null;
  phoneNumber: string | null;
  curriculum: string | null;
  gradeLevel: string | null;
  schoolName: string | null;
  targetGrade: string | null;
  isActive: boolean;
  createdAt: string;
  subscription: UserSubscriptionDetail;
  usage: UserUsageDetail;
  health: UserHealthDetail;
  linkedParents: LinkedParent[];
};

function nairobiDateString(offsetDays: number): string {
  const now = new Date();
  const shifted = new Date(now.getTime() - offsetDays * 24 * 60 * 60 * 1000);
  // en-CA yields YYYY-MM-DD, matching DATE columns stored as Nairobi-local.
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(shifted);
}

export async function getUserDetail(
  studentId: string,
): Promise<UserDetail | null> {
  const admin = createAdminClient();

  const { data: profile, error: profileError } = await admin
    .from("student_profiles")
    .select(
      "id, user_id, full_name, email, phone_number, curriculum, grade_level, school_name, target_grade, is_active, created_at",
    )
    .eq("id", studentId)
    .maybeSingle();

  if (profileError) {
    throw new Error(profileError.message);
  }
  if (!profile) {
    return null;
  }

  const plans = await loadPlans(admin);

  // --- Current subscription (most recent) ---
  const { data: subRow, error: subError } = await admin
    .from("student_subscriptions")
    .select(
      "subscription_status, subscription_plan_id, current_period_end, trial_ends_at, created_at",
    )
    .eq("student_id", studentId)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (subError) {
    throw new Error(subError.message);
  }

  const { data: trialRow, error: trialError } = await admin
    .from("subscription_trials")
    .select("is_trial_active, trial_ends_at")
    .eq("student_id", studentId)
    .maybeSingle();

  if (trialError) {
    throw new Error(trialError.message);
  }

  let subscription: UserSubscriptionDetail = null;
  if (subRow) {
    const plan = subRow.subscription_plan_id
      ? plans.get(subRow.subscription_plan_id)
      : undefined;
    subscription = {
      status: subRow.subscription_status ?? "active",
      planCode: plan?.planCode ?? null,
      planName: plan?.name ?? null,
      currentPeriodEnd: subRow.current_period_end ?? null,
      trialEndsAt: subRow.trial_ends_at ?? trialRow?.trial_ends_at ?? null,
      isTrialActive: trialRow?.is_trial_active ?? false,
    };
  } else if (trialRow) {
    subscription = {
      status: trialRow.is_trial_active ? "trialing" : "expired",
      planCode: null,
      planName: null,
      currentPeriodEnd: null,
      trialEndsAt: trialRow.trial_ends_at ?? null,
      isTrialActive: trialRow.is_trial_active ?? false,
    };
  }

  // --- Usage: today + last 7 days from nex_daily_usage ---
  const today = nairobiDateString(0);
  const sevenDaysAgo = nairobiDateString(6);

  const { data: usageRows, error: usageError } = await admin
    .from("nex_daily_usage")
    .select("usage_date, nex_message_count, practice_session_count")
    .eq("student_id", studentId)
    .gte("usage_date", sevenDaysAgo);

  if (usageError) {
    throw new Error(usageError.message);
  }

  const usage: UserUsageDetail = {
    todayNexMessages: 0,
    todayPracticeSessions: 0,
    last7dNexMessages: 0,
    last7dPracticeSessions: 0,
  };

  for (const row of usageRows ?? []) {
    const nexCount = row.nex_message_count ?? 0;
    const practiceCount = row.practice_session_count ?? 0;
    usage.last7dNexMessages += nexCount;
    usage.last7dPracticeSessions += practiceCount;
    if (row.usage_date === today) {
      usage.todayNexMessages += nexCount;
      usage.todayPracticeSessions += practiceCount;
    }
  }

  // --- Latest health score ---
  const { data: healthRow, error: healthError } = await admin
    .from("academic_health_scores")
    .select("health_score, predicted_grade, calculated_at")
    .eq("student_id", studentId)
    .order("calculated_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  if (healthError) {
    throw new Error(healthError.message);
  }

  const health: UserHealthDetail = healthRow
    ? {
        healthScore: Number(healthRow.health_score ?? 0),
        predictedGrade: healthRow.predicted_grade ?? null,
        calculatedAt: healthRow.calculated_at,
      }
    : null;

  // --- Linked parents via student_parent_links -> parent_profiles ---
  const { data: linkRows, error: linkError } = await admin
    .from("student_parent_links")
    .select(
      "parent_id, link_status, parent_profiles(full_name, email, phone_number)",
    )
    .eq("student_id", studentId);

  if (linkError) {
    throw new Error(linkError.message);
  }

  const linkedParents: LinkedParent[] = (linkRows ?? []).map((row) => {
    const parent = unwrapSupabaseRelation<{
      full_name?: string;
      email?: string | null;
      phone_number?: string | null;
    }>(row.parent_profiles);
    return {
      parentId: row.parent_id,
      fullName: parent?.full_name ?? "Unknown",
      email: parent?.email ?? null,
      phoneNumber: parent?.phone_number ?? null,
      linkStatus: row.link_status ?? "pending",
    };
  });

  return {
    id: profile.id,
    userId: profile.user_id,
    fullName: profile.full_name ?? "Unknown",
    email: profile.email ?? null,
    phoneNumber: profile.phone_number ?? null,
    curriculum: profile.curriculum ?? null,
    gradeLevel: profile.grade_level ?? null,
    schoolName: profile.school_name ?? null,
    targetGrade: profile.target_grade ?? null,
    isActive: profile.is_active ?? true,
    createdAt: profile.created_at,
    subscription,
    usage,
    health,
    linkedParents,
  };
}
