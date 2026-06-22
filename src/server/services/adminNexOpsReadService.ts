import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import type { NexOpsQueryInput } from "@/schemas/adminSchemas";

/**
 * Read-only Nex cost/ops service for the super-admin dashboard (Phase 2).
 *
 * Source tables:
 *  - nex_daily_usage (usage_date, nex_message_count) — volume today / last 7d + top students
 *  - nex_messages (role='nex' metadata.provider) — provider/fallback split + token estimate
 *      from message_content length, AND mode join via nex_sessions
 *  - nex_sessions (session_mode) — usage-by-mode breakdown
 *  - student_profiles (full_name, curriculum, grade_level) — top students join
 *
 * ASSUMPTIONS (tracer must verify):
 *  1. Tokens are NOT persisted anywhere in the schema. We ESTIMATE tokens from
 *     message_content length using ~4 chars/token (industry rough heuristic).
 *  2. PRICING below is a clearly-labeled constant (USD per 1K tokens), blended
 *     input+output, since modelConfig.ts exposes no pricing. Adjust when real
 *     usage metering lands.
 *  3. Provider attribution comes from nex_messages.metadata.provider written by
 *     /api/nex/chat ("gemini" = primary, "openai" = fallback, "mock" = local).
 *     Only role='nex' rows carry a provider.
 */

// USD per 1,000 tokens (blended). Clearly-labeled assumption — replace with real pricing.
export const NEX_MODEL_PRICING_USD_PER_1K: Record<string, number> = {
  gemini: 0.0005,
  openai: 0.0006,
  mock: 0,
};
// Display conversion for KES (approximate). Labeled assumption.
export const USD_TO_KES = 130;
const CHARS_PER_TOKEN = 4;
const MESSAGE_SCAN_LIMIT = 5000;
const TOP_STUDENTS_DEFAULT_LIMIT = 100;
const RECENT_WINDOW_DAYS = 7;

type StudentProfileLite = {
  full_name?: string;
  curriculum?: string;
  grade_level?: string;
};

export type NexCostByProvider = {
  provider: string;
  messageCount: number;
  estimatedTokens: number;
  estimatedCostUsd: number;
  estimatedCostKes: number;
};

export type NexUsageByMode = {
  mode: string;
  sessionCount: number;
};

export type NexTopStudent = {
  studentId: string;
  studentName: string;
  curriculum: string;
  gradeLevel: string;
  nexMessages: number;
};

export type NexOpsDashboardData = {
  messagesToday: number;
  messagesLast7d: number;
  estimatedTokensLast7d: number;
  estimatedCostUsdLast7d: number;
  estimatedCostKesLast7d: number;
  costByProvider: NexCostByProvider[];
  usageByMode: NexUsageByMode[];
  fallbackRate: number | null;
  topStudents: NexTopStudent[];
};

function getNairobiDateString(date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

function estimateTokens(text: string): number {
  return Math.ceil(text.length / CHARS_PER_TOKEN);
}

function round2(value: number): number {
  return Math.round(value * 100) / 100;
}

export async function getNexOpsDashboard(
  filters: NexOpsQueryInput = {},
): Promise<NexOpsDashboardData> {
  const admin = createAdminClient();
  const topLimit = filters.limit ?? TOP_STUDENTS_DEFAULT_LIMIT;
  const today = getNairobiDateString();
  const windowStart = getNairobiDateString(
    new Date(Date.now() - (RECENT_WINDOW_DAYS - 1) * 24 * 60 * 60 * 1000),
  );

  // --- Volume from nex_daily_usage ---
  const { data: todayUsage, error: todayError } = await admin
    .from("nex_daily_usage")
    .select("nex_message_count")
    .eq("usage_date", today);
  if (todayError) {
    throw new Error(todayError.message);
  }
  const messagesToday = (todayUsage ?? []).reduce(
    (sum, row) => sum + (row.nex_message_count ?? 0),
    0,
  );

  const { data: weekUsage, error: weekError } = await admin
    .from("nex_daily_usage")
    .select("nex_message_count")
    .gte("usage_date", windowStart)
    .lte("usage_date", today);
  if (weekError) {
    throw new Error(weekError.message);
  }
  const messagesLast7d = (weekUsage ?? []).reduce(
    (sum, row) => sum + (row.nex_message_count ?? 0),
    0,
  );

  // --- Cost + fallback from nex_messages (role='nex') over the recent window ---
  const windowStartIso = new Date(
    Date.now() - RECENT_WINDOW_DAYS * 24 * 60 * 60 * 1000,
  ).toISOString();

  const { data: nexMessages, error: messagesError } = await admin
    .from("nex_messages")
    .select("message_content, metadata, created_at")
    .eq("role", "nex")
    .gte("created_at", windowStartIso)
    .order("created_at", { ascending: false })
    .limit(MESSAGE_SCAN_LIMIT);
  if (messagesError) {
    throw new Error(messagesError.message);
  }

  const providerAgg = new Map<
    string,
    { messageCount: number; estimatedTokens: number }
  >();
  let primaryCount = 0;
  let fallbackCount = 0;

  for (const row of nexMessages ?? []) {
    const metadata =
      row.metadata && typeof row.metadata === "object"
        ? (row.metadata as { provider?: string })
        : null;
    const provider = metadata?.provider ?? "unknown";
    const tokens = estimateTokens(row.message_content ?? "");

    const agg = providerAgg.get(provider) ?? {
      messageCount: 0,
      estimatedTokens: 0,
    };
    agg.messageCount += 1;
    agg.estimatedTokens += tokens;
    providerAgg.set(provider, agg);

    if (provider === "gemini") {
      primaryCount += 1;
    } else if (provider === "openai") {
      fallbackCount += 1;
    }
  }

  const costByProvider: NexCostByProvider[] = Array.from(providerAgg.entries())
    .map(([provider, agg]) => {
      const pricePer1k = NEX_MODEL_PRICING_USD_PER_1K[provider] ?? 0;
      const costUsd = (agg.estimatedTokens / 1000) * pricePer1k;
      return {
        provider,
        messageCount: agg.messageCount,
        estimatedTokens: agg.estimatedTokens,
        estimatedCostUsd: round2(costUsd),
        estimatedCostKes: Math.round(costUsd * USD_TO_KES),
      };
    })
    .sort((a, b) => b.messageCount - a.messageCount);

  const estimatedTokensLast7d = costByProvider.reduce(
    (sum, p) => sum + p.estimatedTokens,
    0,
  );
  const estimatedCostUsdLast7d = round2(
    costByProvider.reduce((sum, p) => sum + p.estimatedCostUsd, 0),
  );
  const estimatedCostKesLast7d = costByProvider.reduce(
    (sum, p) => sum + p.estimatedCostKes,
    0,
  );

  const providerTotal = primaryCount + fallbackCount;
  const fallbackRate =
    providerTotal === 0 ? null : round2(fallbackCount / providerTotal);

  // --- Usage by mode from nex_sessions ---
  const { data: sessions, error: sessionsError } = await admin
    .from("nex_sessions")
    .select("session_mode")
    .gte("started_at", windowStartIso)
    .limit(MESSAGE_SCAN_LIMIT);
  if (sessionsError) {
    throw new Error(sessionsError.message);
  }

  const modeAgg = new Map<string, number>();
  for (const row of sessions ?? []) {
    const mode = row.session_mode ?? "unknown";
    modeAgg.set(mode, (modeAgg.get(mode) ?? 0) + 1);
  }
  const usageByMode: NexUsageByMode[] = Array.from(modeAgg.entries())
    .map(([mode, sessionCount]) => ({ mode, sessionCount }))
    .sort((a, b) => b.sessionCount - a.sessionCount);

  // --- Top students by Nex usage today (mirrors usage-stats join) ---
  const { data: topRows, error: topError } = await admin
    .from("nex_daily_usage")
    .select(
      "student_id, nex_message_count, student_profiles(full_name, curriculum, grade_level)",
    )
    .eq("usage_date", today)
    .order("nex_message_count", { ascending: false })
    .limit(topLimit);
  if (topError) {
    throw new Error(topError.message);
  }

  const topStudents: NexTopStudent[] = (topRows ?? []).map((row) => {
    const profile = unwrapSupabaseRelation<StudentProfileLite>(
      row.student_profiles,
    );
    return {
      studentId: row.student_id,
      studentName: profile?.full_name ?? "Unknown",
      curriculum: profile?.curriculum ?? "—",
      gradeLevel: profile?.grade_level ?? "—",
      nexMessages: row.nex_message_count ?? 0,
    };
  });

  return {
    messagesToday,
    messagesLast7d,
    estimatedTokensLast7d,
    estimatedCostUsdLast7d,
    estimatedCostKesLast7d,
    costByProvider,
    usageByMode,
    fallbackRate,
    topStudents,
  };
}
