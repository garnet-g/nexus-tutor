/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type Row = { cache_key: string; response_text: string; created_at: string };
const rows = new Map<string, Row>();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "nex_response_cache") {
        throw new Error(`unexpected table ${table}`);
      }

      return {
        select: () => ({
          eq: (_column: string, value: string) => ({
            maybeSingle: async () => ({ data: rows.get(value) ?? null, error: null }),
          }),
        }),
        upsert: (row: Row & Record<string, unknown>) => {
          rows.set(row.cache_key, {
            cache_key: row.cache_key,
            response_text: row.response_text,
            created_at: (row.created_at as string) ?? new Date().toISOString(),
          });
          return Promise.resolve({ data: null, error: null });
        },
        update: () => ({ eq: async () => ({ data: null, error: null }) }),
      };
    },
  })),
}));

describe("nexResponseCacheService", () => {
  beforeEach(() => {
    rows.clear();
    vi.resetModules();
  });

  it("builds a stable cache key from topic + normalized question text", async () => {
    const { buildCacheKey } = await import(
      "@/server/services/nexResponseCacheService"
    );

    const keyA = buildCacheKey("topic-1", "What is a Fraction?");
    const keyB = buildCacheKey("topic-1", "  what is a fraction?  ");
    const keyC = buildCacheKey("topic-1", "What is a percentage?");

    expect(keyA).toBe(keyB);
    expect(keyA).not.toBe(keyC);
  });

  it("returns null on a cache miss", async () => {
    const { getCachedExplainResponse } = await import(
      "@/server/services/nexResponseCacheService"
    );

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBeNull();
  });

  it("returns the cached response on a hit within the TTL", async () => {
    const { buildCacheKey, storeExplainResponse, getCachedExplainResponse } =
      await import("@/server/services/nexResponseCacheService");

    await storeExplainResponse("topic-1", "What is a fraction?", "A fraction is a part of a whole.");

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBe("A fraction is a part of a whole.");
    expect(buildCacheKey("topic-1", "What is a fraction?")).toBeTruthy();
  });

  it("treats entries older than the TTL as a miss", async () => {
    const { storeExplainResponse, getCachedExplainResponse, buildCacheKey } =
      await import("@/server/services/nexResponseCacheService");

    await storeExplainResponse("topic-1", "What is a fraction?", "Stale answer.");
    const key = buildCacheKey("topic-1", "What is a fraction?");
    rows.set(key, {
      cache_key: key,
      response_text: "Stale answer.",
      created_at: new Date(Date.now() - 31 * 24 * 60 * 60 * 1000).toISOString(),
    });

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBeNull();
  });
});
