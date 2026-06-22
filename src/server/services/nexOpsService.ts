import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";

export type NexOpsProvider = "gemini" | "openai" | "mock";
export type NexOpsReviewStatus = "open" | "resolved" | "escalated";

export interface NexOpsMessageRow {
  id: string;
  nex_session_id: string;
  student_id: string;
  role: "student" | "nex";
  message_content: string;
  metadata: unknown;
  created_at: string;
  nex_sessions?: { session_mode?: string | null } | Array<{ session_mode?: string | null }> | null;
}

export interface NexOpsPricingConfig {
  charsPerToken: number;
  usdToKesRate: number;
  providerRates: Record<
    NexOpsProvider,
    {
      inputUsdPerMillion: number;
      outputUsdPerMillion: number;
    }
  >;
}

export interface NexOpsProviderSummary {
  provider: string;
  providerKey: NexOpsProvider;
  messages: number;
  estimatedTokens: number;
  estimatedCostUsd: number;
  estimatedCostKes: number;
}

export interface NexOpsModeSummary {
  mode: string;
  messages: number;
}

export interface NexOpsFlaggedMessage {
  messageId: string;
  sessionId: string;
  studentId: string;
  provider: string;
  mode: string;
  status: NexOpsReviewStatus;
  createdAt: string;
  promptPreview: string;
  responsePreview: string;
}

export interface NexOpsSnapshot {
  generatedAt: string;
  date: string;
  pricing: NexOpsPricingConfig;
  summary: {
    messagesToday: number;
    messages7d: number;
    estimatedTokens7d: number;
    estimatedCostUsd: number;
    estimatedCostKes: number;
    fallbackRatePercent: number;
    openFlaggedCount: number;
  };
  byProvider: NexOpsProviderSummary[];
  byMode: NexOpsModeSummary[];
  flagged: NexOpsFlaggedMessage[];
}

interface BuildNexOpsSnapshotInput {
  now?: Date;
  messages: NexOpsMessageRow[];
  pricing?: NexOpsPricingConfig;
  usdToKesRate?: number;
}

interface ModelCallRecord {
  message: NexOpsMessageRow;
  prompt: NexOpsMessageRow | null;
  provider: NexOpsProvider;
  mode: string;
  inputTokens: number;
  outputTokens: number;
  costUsd: number;
}

const DEFAULT_USD_TO_KES_RATE = 130;
const ONE_DAY_MS = 24 * 60 * 60 * 1000;

function readNumberEnv(name: string, fallback: number): number {
  const value = Number(process.env[name]);
  return Number.isFinite(value) && value >= 0 ? value : fallback;
}

export function getNexOpsPricingConfig(): NexOpsPricingConfig {
  return {
    charsPerToken: readNumberEnv("NEX_OPS_CHARS_PER_TOKEN", 4),
    usdToKesRate: readNumberEnv("NEX_USD_TO_KES_RATE", DEFAULT_USD_TO_KES_RATE),
    providerRates: {
      gemini: {
        inputUsdPerMillion: readNumberEnv("NEX_GEMINI_INPUT_USD_PER_MILLION", 1.5),
        outputUsdPerMillion: readNumberEnv("NEX_GEMINI_OUTPUT_USD_PER_MILLION", 9),
      },
      openai: {
        inputUsdPerMillion: readNumberEnv("NEX_OPENAI_INPUT_USD_PER_MILLION", 0.15),
        outputUsdPerMillion: readNumberEnv("NEX_OPENAI_OUTPUT_USD_PER_MILLION", 0.6),
      },
      mock: {
        inputUsdPerMillion: 0,
        outputUsdPerMillion: 0,
      },
    },
  };
}

export function estimateTextTokens(text: string, charsPerToken = 4): number {
  const trimmed = text.trim();
  if (!trimmed) {
    return 0;
  }

  return Math.max(1, Math.ceil(trimmed.length / charsPerToken));
}

function toNairobiDateString(date: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

function parseMetadata(value: unknown): Record<string, unknown> {
  return value && typeof value === "object" && !Array.isArray(value)
    ? (value as Record<string, unknown>)
    : {};
}

function parseProvider(metadata: Record<string, unknown>): NexOpsProvider {
  return metadata.provider === "openai" || metadata.provider === "mock"
    ? metadata.provider
    : "gemini";
}

function parseReviewStatus(metadata: Record<string, unknown>): NexOpsReviewStatus {
  return metadata.opsReviewStatus === "resolved" ||
    metadata.opsReviewStatus === "escalated"
    ? metadata.opsReviewStatus
    : "open";
}

function providerLabel(provider: NexOpsProvider): string {
  if (provider === "openai") {
    return "OpenAI";
  }

  if (provider === "mock") {
    return "Mock";
  }

  return "Gemini";
}

function modeLabel(value: string | null | undefined): string {
  if (!value) {
    return "Unknown";
  }

  return value
    .split(/[-_\s]+/)
    .filter(Boolean)
    .map((part) => part[0]?.toUpperCase() + part.slice(1))
    .join(" ");
}

function getSessionMode(row: NexOpsMessageRow): string {
  const session = unwrapSupabaseRelation(row.nex_sessions);
  return modeLabel(session?.session_mode);
}

function preview(text: string, length = 140): string {
  const compact = text.replace(/\s+/g, " ").trim();
  return compact.length > length ? `${compact.slice(0, length - 1)}...` : compact;
}

function addProviderSummary(
  summaries: Map<NexOpsProvider, NexOpsProviderSummary>,
  call: ModelCallRecord,
  pricing: NexOpsPricingConfig,
): void {
  const existing =
    summaries.get(call.provider) ??
    ({
      provider: providerLabel(call.provider),
      providerKey: call.provider,
      messages: 0,
      estimatedTokens: 0,
      estimatedCostUsd: 0,
      estimatedCostKes: 0,
    } satisfies NexOpsProviderSummary);

  existing.messages += 1;
  existing.estimatedTokens += call.inputTokens + call.outputTokens;
  existing.estimatedCostUsd += call.costUsd;
  existing.estimatedCostKes = existing.estimatedCostUsd * pricing.usdToKesRate;
  summaries.set(call.provider, existing);
}

function buildModelCalls(
  messages: NexOpsMessageRow[],
  pricing: NexOpsPricingConfig,
): ModelCallRecord[] {
  const ordered = [...messages].sort(
    (a, b) => Date.parse(a.created_at) - Date.parse(b.created_at),
  );
  const latestStudentBySession = new Map<string, NexOpsMessageRow>();
  const calls: ModelCallRecord[] = [];

  for (const message of ordered) {
    if (message.role === "student") {
      latestStudentBySession.set(message.nex_session_id, message);
      continue;
    }

    if (message.role !== "nex") {
      continue;
    }

    const metadata = parseMetadata(message.metadata);
    const provider = parseProvider(metadata);
    const prompt = latestStudentBySession.get(message.nex_session_id) ?? null;
    const inputTokens = estimateTextTokens(
      prompt?.message_content ?? "",
      pricing.charsPerToken,
    );
    const outputTokens = estimateTextTokens(
      message.message_content,
      pricing.charsPerToken,
    );
    const rate = pricing.providerRates[provider];
    const costUsd =
      (inputTokens * rate.inputUsdPerMillion +
        outputTokens * rate.outputUsdPerMillion) /
      1_000_000;

    calls.push({
      message,
      prompt,
      provider,
      mode: getSessionMode(message),
      inputTokens,
      outputTokens,
      costUsd,
    });
    latestStudentBySession.delete(message.nex_session_id);
  }

  return calls;
}

export function buildNexOpsSnapshot(input: BuildNexOpsSnapshotInput): NexOpsSnapshot {
  const now = input.now ?? new Date();
  const pricing = {
    ...(input.pricing ?? getNexOpsPricingConfig()),
    usdToKesRate:
      input.usdToKesRate ?? input.pricing?.usdToKesRate ?? getNexOpsPricingConfig().usdToKesRate,
  };
  const today = toNairobiDateString(now);
  const since = new Date(now.getTime() - 7 * ONE_DAY_MS);
  const calls = buildModelCalls(
    input.messages.filter((message) => Date.parse(message.created_at) >= since.getTime()),
    pricing,
  );

  const providerSummaries = new Map<NexOpsProvider, NexOpsProviderSummary>();
  const modeSummaries = new Map<string, NexOpsModeSummary>();
  const flagged: NexOpsFlaggedMessage[] = [];

  for (const call of calls) {
    addProviderSummary(providerSummaries, call, pricing);

    const mode = modeSummaries.get(call.mode) ?? { mode: call.mode, messages: 0 };
    mode.messages += 1;
    modeSummaries.set(call.mode, mode);

    const metadata = parseMetadata(call.message.metadata);
    const status = parseReviewStatus(metadata);
    if (metadata.validationPassed === false || metadata.opsReviewStatus) {
      flagged.push({
        messageId: call.message.id,
        sessionId: call.message.nex_session_id,
        studentId: call.message.student_id,
        provider: providerLabel(call.provider),
        mode: call.mode,
        status,
        createdAt: call.message.created_at,
        promptPreview: preview(call.prompt?.message_content ?? ""),
        responsePreview: preview(call.message.message_content),
      });
    }
  }

  const messagesToday = calls.filter(
    (call) => toNairobiDateString(new Date(call.message.created_at)) === today,
  ).length;
  const estimatedCostUsd = calls.reduce((sum, call) => sum + call.costUsd, 0);
  const fallbackCalls = calls.filter((call) => call.provider === "openai").length;
  const primaryCalls = calls.filter(
    (call) => call.provider === "gemini" || call.provider === "openai",
  ).length;

  return {
    generatedAt: now.toISOString(),
    date: today,
    pricing,
    summary: {
      messagesToday,
      messages7d: calls.length,
      estimatedTokens7d: calls.reduce(
        (sum, call) => sum + call.inputTokens + call.outputTokens,
        0,
      ),
      estimatedCostUsd,
      estimatedCostKes: estimatedCostUsd * pricing.usdToKesRate,
      fallbackRatePercent:
        primaryCalls > 0 ? Number(((fallbackCalls / primaryCalls) * 100).toFixed(1)) : 0,
      openFlaggedCount: flagged.filter((item) => item.status === "open").length,
    },
    byProvider: [...providerSummaries.values()].sort(
      (a, b) => b.estimatedCostUsd - a.estimatedCostUsd,
    ),
    byMode: [...modeSummaries.values()].sort((a, b) => a.mode.localeCompare(b.mode)),
    flagged: flagged.sort((a, b) => {
      if (a.status === "open" && b.status !== "open") {
        return -1;
      }
      if (a.status !== "open" && b.status === "open") {
        return 1;
      }

      return Date.parse(b.createdAt) - Date.parse(a.createdAt);
    }),
  };
}

export async function loadNexOpsSnapshot(): Promise<NexOpsSnapshot> {
  const admin = createAdminClient();
  const since = new Date(Date.now() - 7 * ONE_DAY_MS).toISOString();

  const { data, error } = await admin
    .from("nex_messages")
    .select(
      "id, nex_session_id, student_id, role, message_content, metadata, created_at, nex_sessions(session_mode)",
    )
    .gte("created_at", since)
    .order("created_at", { ascending: true })
    .limit(2000);

  if (error) {
    throw error;
  }

  return buildNexOpsSnapshot({
    messages: (data ?? []) as NexOpsMessageRow[],
  });
}

export async function updateNexOpsReviewStatus(
  messageId: string,
  status: Exclude<NexOpsReviewStatus, "open">,
): Promise<void> {
  const admin = createAdminClient();
  const { data, error: readError } = await admin
    .from("nex_messages")
    .select("metadata")
    .eq("id", messageId)
    .eq("role", "nex")
    .single();

  if (readError) {
    throw readError;
  }

  const metadata = parseMetadata(data?.metadata);
  const { error: updateError } = await admin
    .from("nex_messages")
    .update({
      metadata: {
        ...metadata,
        opsReviewStatus: status,
        opsReviewedAt: new Date().toISOString(),
      },
    })
    .eq("id", messageId)
    .eq("role", "nex");

  if (updateError) {
    throw updateError;
  }
}
