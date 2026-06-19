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

export async function incrementNexDailyUsage(studentId: string): Promise<number> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data: existing, error: readError } = await supabase
    .from("nex_daily_usage")
    .select("id, nex_message_count")
    .eq("student_id", studentId)
    .eq("usage_date", usageDate)
    .maybeSingle();

  if (readError) {
    throw readError;
  }

  const nextCount = (existing?.nex_message_count ?? 0) + 1;

  if (existing?.id) {
    const { error } = await supabase
      .from("nex_daily_usage")
      .update({ nex_message_count: nextCount })
      .eq("id", existing.id);

    if (error) {
      throw error;
    }

    return nextCount;
  }

  const { error } = await supabase.from("nex_daily_usage").insert({
    student_id: studentId,
    usage_date: usageDate,
    nex_message_count: nextCount,
    practice_session_count: 0,
  });

  if (error) {
    throw error;
  }

  return nextCount;
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

export async function incrementPracticeDailyUsage(studentId: string): Promise<number> {
  const supabase = createAdminClient();
  const usageDate = getNairobiDateString();

  const { data: existing, error: readError } = await supabase
    .from("nex_daily_usage")
    .select("id, practice_session_count")
    .eq("student_id", studentId)
    .eq("usage_date", usageDate)
    .maybeSingle();

  if (readError) {
    throw readError;
  }

  const nextCount = (existing?.practice_session_count ?? 0) + 1;

  if (existing?.id) {
    const { error } = await supabase
      .from("nex_daily_usage")
      .update({ practice_session_count: nextCount })
      .eq("id", existing.id);

    if (error) {
      throw error;
    }

    return nextCount;
  }

  const { error } = await supabase.from("nex_daily_usage").insert({
    student_id: studentId,
    usage_date: usageDate,
    nex_message_count: 0,
    practice_session_count: nextCount,
  });

  if (error) {
    throw error;
  }

  return nextCount;
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
