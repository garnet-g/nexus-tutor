import "server-only";

import { createHash } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";

export const NEX_VOICE_CACHE_BUCKET = "nex-voice-cache";
// Matches the text-response cache's TTL (nexResponseCacheService.ts). This
// only stops stale entries from being served on read; it does not reclaim
// storage for hashes that are never looked up again (most Nex responses are
// unique per conversation, so this bucket will still accumulate unread
// objects over time). Reclaiming that requires a periodic cleanup sweep
// (e.g. added to the data-retention cron) — tracked as a follow-up, out of
// scope for this cache-correctness fix.
const CACHE_TTL_MS = 30 * 24 * 60 * 60 * 1000;

export function hashVoiceContent(text: string, provider: string): string {
  return createHash("sha256").update(`${provider}:${text.trim()}`).digest("hex");
}

export interface CachedVoice {
  audioBytes: Uint8Array;
  mimeType: string;
}

export async function getCachedVoice(contentHash: string): Promise<CachedVoice | null> {
  const admin = createAdminClient();

  const { data: row, error: readError } = await admin
    .from("nex_voice_cache")
    .select("storage_path, mime_type, created_at")
    .eq("content_hash", contentHash)
    .maybeSingle();

  if (readError) {
    console.error("NEX_VOICE_CACHE_READ_FAILED", { error: readError });
  }

  if (!row) {
    return null;
  }

  const ageMs = Date.now() - new Date(row.created_at).getTime();
  if (ageMs > CACHE_TTL_MS) {
    return null;
  }

  const { data: blob, error } = await admin.storage
    .from(NEX_VOICE_CACHE_BUCKET)
    .download(row.storage_path);

  if (error || !blob) {
    if (error) {
      console.error("NEX_VOICE_CACHE_READ_FAILED", { error });
    }
    return null;
  }

  const audioBytes = new Uint8Array(await blob.arrayBuffer());

  await admin
    .from("nex_voice_cache")
    // Fixed to 1 rather than incremented: Supabase .update() can't express
    // hit_count = hit_count + 1 without an RPC. This is an approximate "was
    // hit" signal only, not a true count.
    .update({ hit_count: 1, last_hit_at: new Date().toISOString() })
    .eq("content_hash", contentHash);

  return { audioBytes, mimeType: row.mime_type };
}

export async function storeCachedVoice(
  contentHash: string,
  audioBytes: Uint8Array,
  mimeType: string,
  provider: string,
): Promise<void> {
  const admin = createAdminClient();
  const storagePath = `${contentHash}.bin`;

  const { error: uploadError } = await admin.storage
    .from(NEX_VOICE_CACHE_BUCKET)
    .upload(storagePath, audioBytes, { contentType: mimeType, upsert: true });

  if (uploadError) {
    console.error("NEX_VOICE_CACHE_WRITE_FAILED", { error: uploadError });
    return;
  }

  const { error: upsertError } = await admin.from("nex_voice_cache").upsert(
    {
      content_hash: contentHash,
      storage_path: storagePath,
      mime_type: mimeType,
      provider,
      hit_count: 0,
    },
    { onConflict: "content_hash" },
  );

  if (upsertError) {
    console.error("NEX_VOICE_CACHE_WRITE_FAILED", { error: upsertError });
  }
}
