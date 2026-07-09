import { beforeEach, describe, expect, it, vi } from "vitest";

const sessionUpdates: Record<string, unknown>[] = [];
let mockSessionMetadata: Record<string, unknown> = {};

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "nex_sessions") {
        const builder = {
          select: () => builder,
          eq: () => builder,
          maybeSingle: async () => ({
            data: { metadata: mockSessionMetadata },
            error: null,
          }),
          single: async () => ({
            data: { metadata: mockSessionMetadata },
            error: null,
          }),
          update: (updates: Record<string, unknown>) => {
            sessionUpdates.push(updates);
            return {
              eq: async () => ({ data: null, error: null }),
            };
          },
        };
        return builder;
      }
      return {};
    },
  })),
}));

describe("getOrCreateContextCache", () => {
  beforeEach(() => {
    sessionUpdates.length = 0;
    mockSessionMetadata = {};
    vi.stubEnv("GEMINI_API_KEY", "test-api-key");
  });

  it("returns null if messages length is less than 6", async () => {
    const { getOrCreateContextCache } = await import(
      "@/server/services/contextCacheService"
    );

    const result = await getOrCreateContextCache({
      sessionId: "session-1",
      systemPrompt: "System instruction",
      messages: [{ role: "student", content: "hello" }],
      model: "gemini-3.5-flash",
    });

    expect(result).toBeNull();
    expect(sessionUpdates).toHaveLength(0);
  });

  it("returns existing cached content name if it exists in session metadata and is not expired", async () => {
    const futureDate = new Date(Date.now() + 120_000).toISOString();
    mockSessionMetadata = {
      contextCacheName: "cachedContents/already-cached",
      contextCacheExpiresAt: futureDate,
    };

    const { getOrCreateContextCache } = await import(
      "@/server/services/contextCacheService"
    );

    const result = await getOrCreateContextCache({
      sessionId: "session-1",
      systemPrompt: "System instruction",
      messages: [
        { role: "student", content: "1" },
        { role: "nex", content: "2" },
        { role: "student", content: "3" },
        { role: "nex", content: "4" },
        { role: "student", content: "5" },
        { role: "nex", content: "6" },
      ],
      model: "gemini-3.5-flash",
    });

    expect(result).toBe("cachedContents/already-cached");
    expect(sessionUpdates).toHaveLength(0);
  });

  it("makes a post request to cachedContents to create a cache and stores it on metadata if expired or missing", async () => {
    const mockFetch = vi.fn().mockResolvedValue({
      ok: true,
      json: async () => ({
        name: "cachedContents/newly-created",
        expireTime: new Date(Date.now() + 300_000).toISOString(),
      }),
    });
    vi.stubGlobal("fetch", mockFetch);

    const { getOrCreateContextCache } = await import(
      "@/server/services/contextCacheService"
    );

    const result = await getOrCreateContextCache({
      sessionId: "session-1",
      systemPrompt: "System instruction",
      messages: [
        { role: "student", content: "1" },
        { role: "nex", content: "2" },
        { role: "student", content: "3" },
        { role: "nex", content: "4" },
        { role: "student", content: "5" },
        { role: "nex", content: "6" },
      ],
      model: "gemini-3.5-flash",
    });

    expect(result).toBe("cachedContents/newly-created");
    expect(mockFetch).toHaveBeenCalled();
    expect(sessionUpdates).toHaveLength(1);
    expect(sessionUpdates[0].metadata).toMatchObject({
      contextCacheName: "cachedContents/newly-created",
    });

    vi.unstubAllGlobals();
  });
});
