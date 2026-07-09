/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type CacheRow = { content_hash: string; storage_path: string; mime_type: string };
const rows = new Map<string, CacheRow>();
const storedObjects = new Map<string, Uint8Array>();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "nex_voice_cache") {
        throw new Error(`unexpected table ${table}`);
      }
      return {
        select: () => ({
          eq: (_column: string, value: string) => ({
            maybeSingle: async () => ({ data: rows.get(value) ?? null, error: null }),
          }),
        }),
        upsert: (row: CacheRow & Record<string, unknown>) => {
          rows.set(row.content_hash, {
            content_hash: row.content_hash,
            storage_path: row.storage_path as string,
            mime_type: row.mime_type as string,
          });
          return Promise.resolve({ data: null, error: null });
        },
        update: () => ({ eq: async () => ({ data: null, error: null }) }),
      };
    },
    storage: {
      from: () => ({
        upload: async (path: string, bytes: Uint8Array) => {
          storedObjects.set(path, bytes);
          return { data: { path }, error: null };
        },
        download: async (path: string) => {
          const bytes = storedObjects.get(path);
          if (!bytes) {
            return { data: null, error: { message: "not found" } };
          }
          return { data: new Blob([bytes.slice().buffer]), error: null };
        },
      }),
    },
  })),
}));

describe("nexVoiceCacheService", () => {
  beforeEach(() => {
    rows.clear();
    storedObjects.clear();
    vi.resetModules();
  });

  it("produces the same hash for identical text + provider and a different hash otherwise", async () => {
    const { hashVoiceContent } = await import("@/server/services/nexVoiceCacheService");

    const hashA = hashVoiceContent("A fraction is a part of a whole.", "gemini");
    const hashB = hashVoiceContent("A fraction is a part of a whole.", "gemini");
    const hashC = hashVoiceContent("A fraction is a part of a whole.", "openai");

    expect(hashA).toBe(hashB);
    expect(hashA).not.toBe(hashC);
  });

  it("returns null on a cache miss", async () => {
    const { getCachedVoice } = await import("@/server/services/nexVoiceCacheService");
    const result = await getCachedVoice("nonexistent-hash");
    expect(result).toBeNull();
  });

  it("stores and retrieves cached audio bytes", async () => {
    const { hashVoiceContent, storeCachedVoice, getCachedVoice } = await import(
      "@/server/services/nexVoiceCacheService"
    );

    const hash = hashVoiceContent("Hello student.", "gemini");
    const audioBytes = new Uint8Array([1, 2, 3, 4]);

    await storeCachedVoice(hash, audioBytes, "audio/wav", "gemini");
    const cached = await getCachedVoice(hash);

    expect(cached).not.toBeNull();
    expect(cached?.mimeType).toBe("audio/wav");
    expect(Array.from(cached?.audioBytes ?? [])).toEqual([1, 2, 3, 4]);
  });
});
