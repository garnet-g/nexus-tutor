/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

vi.mock("@/lib/rateLimit/durableLimiter", () => ({
  checkRateLimit: vi.fn(),
}));

import { POST as publishPOST } from "@/app/api/admin/content/concept-references/publish/route";
import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser, getSession },
  })),
}));

vi.mock("@/server/services/conceptLibraryService", () => ({
  publishConceptFromLessonBlock: vi.fn(async () => ({ id: "concept-1" })),
}));

const lessonId = "00000000-0000-4000-8000-000000000801";
const SELF = "https://app.nexus.co";

function publishRequest(headers: Record<string, string>) {
  return publishPOST(
    new Request(`${SELF}/api/admin/content/concept-references/publish`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        ...headers,
      },
      body: JSON.stringify({ lessonId, blockIndex: 0 }),
    }),
  );
}

describe("concept reference publish route guards", () => {
  beforeEach(() => {
    vi.mocked(checkRateLimit).mockReset();
    getUser.mockResolvedValue({
      data: { user: { id: "super-1", app_metadata: { userRole: "super_admin" } } },
      error: null,
    });
    getSession.mockResolvedValue({
      data: { session: { access_token: "token" } },
      error: null,
    });
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: true,
      retryAfterSeconds: 0,
    });
  });

  it("rejects cross-origin cookie mutations with 403", async () => {
    const response = await publishRequest({
      cookie: "s=1",
      origin: "https://evil.com",
    });

    expect(response.status).toBe(403);
    expect(checkRateLimit).not.toHaveBeenCalled();
  });

  it("returns 429 when the admin burst limit is exceeded", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: false,
      retryAfterSeconds: 22,
    });

    const response = await publishRequest({
      cookie: "s=1",
      origin: SELF,
    });

    expect(response.status).toBe(429);
    expect(checkRateLimit).toHaveBeenCalledWith(
      expect.objectContaining({ key: "admin:mutations:super-1" }),
    );
  });
});
