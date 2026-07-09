import "server-only";

import { createHash } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";

const CACHE_TTL_MS = 30 * 24 * 60 * 60 * 1000;

function normalizeQuestion(text: string): string {
  return text.trim().toLowerCase().replace(/\s+/g, " ");
}

export function buildCacheKey(topicId: string, studentMessage: string): string {
  const normalized = normalizeQuestion(studentMessage);
  return createHash("sha256").update(`${topicId}:${normalized}`).digest("hex");
}

export async function getCachedExplainResponse(
  topicId: string,
  studentMessage: string,
): Promise<string | null> {
  const cacheKey = buildCacheKey(topicId, studentMessage);
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("nex_response_cache")
    .select("response_text, created_at")
    .eq("cache_key", cacheKey)
    .maybeSingle();

  if (error) {
    console.error("NEX_RESPONSE_CACHE_READ_FAILED", { error });
  }

  if (!data) {
    return null;
  }

  const ageMs = Date.now() - new Date(data.created_at).getTime();
  if (ageMs > CACHE_TTL_MS) {
    return null;
  }

  await admin
    .from("nex_response_cache")
    .update({
      // Fixed to 1 rather than incremented: Supabase .update() can't express
      // hit_count = hit_count + 1 without an RPC. This is an approximate
      // "was hit" signal only, not a true count.
      hit_count: 1,
      last_hit_at: new Date().toISOString(),
    })
    .eq("cache_key", cacheKey);

  return data.response_text;
}

export async function storeExplainResponse(
  topicId: string,
  studentMessage: string,
  responseText: string,
): Promise<void> {
  const cacheKey = buildCacheKey(topicId, studentMessage);
  const admin = createAdminClient();

  const { error } = await admin.from("nex_response_cache").upsert(
    {
      cache_key: cacheKey,
      topic_id: topicId,
      normalized_question: normalizeQuestion(studentMessage),
      response_text: responseText,
      created_at: new Date().toISOString(),
      hit_count: 0,
    },
    { onConflict: "cache_key" },
  );

  if (error) {
    console.error("NEX_RESPONSE_CACHE_WRITE_FAILED", { error });
  }
}
