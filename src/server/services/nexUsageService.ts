import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

function getNairobiDateString(date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

export async function getNexDailyUsageCount(studentId: string): Promise<number> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data, error } = await supabase
    .from("nex_daily_usage")
    .select("nex_message_count")
    .eq("student_id", studentId)
    .eq("usage_date", usageDate)
    .maybeSingle();

  if (error) {
    return 0;
  }

  return data?.nex_message_count ?? 0;
}

export interface DailyUsageIncrementResult {
  /** False when the atomic increment was refused because the cap was reached. */
  allowed: boolean;
  /** Authoritative post-increment count from Postgres. */
  newCount: number;
}

/**
 * Atomically increments the Nex daily counter, enforcing `dailyLimit` inside a
 * single Postgres statement (increment_nex_daily_usage). Concurrent callers can
 * never push the stored count past the cap — the pre-check in the route is only
 * a fast path; this is the authoritative gate (PR-014).
 */
export async function incrementNexDailyUsage(
  studentId: string,
  dailyLimit: number,
): Promise<DailyUsageIncrementResult> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data, error } = await supabase.rpc("increment_nex_daily_usage", {
    p_student_id: studentId,
    p_usage_date: usageDate,
    p_daily_limit: dailyLimit,
  });

  if (error) {
    throw new Error(error.message);
  }

  const result = (data ?? {}) as Record<string, unknown>;

  return {
    allowed: result.allowed === true,
    newCount: typeof result.new_count === "number" ? result.new_count : 0,
  };
}

export function getSecondsUntilNairobiMidnight(now = new Date()): number {
  const formatter = new Intl.DateTimeFormat("en-US", {
    timeZone: "Africa/Nairobi",
    hour: "numeric",
    minute: "numeric",
    second: "numeric",
    hour12: false,
  });

  const parts = formatter.formatToParts(now);
  const hour = Number(parts.find((part) => part.type === "hour")?.value ?? 0);
  const minute = Number(parts.find((part) => part.type === "minute")?.value ?? 0);
  const second = Number(parts.find((part) => part.type === "second")?.value ?? 0);

  const elapsedSeconds = hour * 3600 + minute * 60 + second;
  return Math.max(86400 - elapsedSeconds, 0);
}

export { studentHasVoiceAccess } from "@/schemas/voiceSchemas";

export async function getPracticeDailyUsageCount(studentId: string): Promise<number> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data, error } = await supabase
    .from("nex_daily_usage")
    .select("practice_session_count")
    .eq("student_id", studentId)
    .eq("usage_date", usageDate)
    .maybeSingle();

  if (error) {
    return 0;
  }

  return data?.practice_session_count ?? 0;
}

/**
 * Atomically increments the practice daily counter, enforcing `dailyLimit`
 * inside a single Postgres statement (increment_practice_daily_usage). See
 * incrementNexDailyUsage for the concurrency contract (PR-015).
 */
export async function incrementPracticeDailyUsage(
  studentId: string,
  dailyLimit: number,
): Promise<DailyUsageIncrementResult> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data, error } = await supabase.rpc("increment_practice_daily_usage", {
    p_student_id: studentId,
    p_usage_date: usageDate,
    p_daily_limit: dailyLimit,
  });

  if (error) {
    throw new Error(error.message);
  }

  const result = (data ?? {}) as Record<string, unknown>;

  return {
    allowed: result.allowed === true,
    newCount: typeof result.new_count === "number" ? result.new_count : 0,
  };
}

export async function getStudentPlanCode(studentId: string): Promise<string> {
  const supabase = createAdminClient();

  const { data } = await supabase
    .from("student_subscriptions")
    .select("subscription_status, subscription_plans(plan_code)")
    .eq("student_id", studentId)
    .in("subscription_status", ["trialing", "active"])
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  const planCode =
    data?.subscription_plans &&
    typeof data.subscription_plans === "object" &&
    "plan_code" in data.subscription_plans
      ? String((data.subscription_plans as { plan_code?: string }).plan_code ?? "free")
      : "free";

  return planCode;
}
