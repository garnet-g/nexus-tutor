/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

vi.mock("@/lib/rateLimit/durableLimiter", () => ({
  checkRateLimit: vi.fn(),
}));

import { PATCH as platformSettingsPatch } from "@/app/api/admin/platform-settings/route";
import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser, getSession },
  })),
}));

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  clearPlatformSettingsCache: vi.fn(),
  getEffectiveSubscriptionConfig: vi.fn(async () => ({
    pricing: { premiumAmountKes: 799, familyAmountKes: 2499 },
    limits: {},
    promotion: { isActive: false, title: null, endsAt: null },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: vi.fn(() => ({
      select: () => ({
        eq: () => ({
          maybeSingle: async () => ({ data: null }),
        }),
      }),
      upsert: async () => ({ error: null }),
      update: () => ({ eq: async () => ({ error: null }) }),
      order: () => ({ limit: async () => ({ data: [] }) }),
    })),
  })),
}));

describe("PR-049b admin burst guards", () => {
  beforeEach(() => {
    vi.mocked(checkRateLimit).mockReset();
    getSession.mockResolvedValue({
      data: { session: { access_token: "token" } },
      error: null,
    });
    getUser.mockResolvedValue({
      data: { user: { id: "admin-1", app_metadata: { userRole: "super_admin" } } },
      error: null,
    });
  });

  it("platform-settings PATCH returns 429 when admin burst limit is exceeded", async () => {
    vi.mocked(checkRateLimit).mockResolvedValue({
      allowed: false,
      retryAfterSeconds: 18,
    });

    const response = await platformSettingsPatch(
      new Request("https://app.nexus.co/api/admin/platform-settings", {
        method: "PATCH",
        headers: {
          "Content-Type": "application/json",
          cookie: "s=1",
          origin: "https://app.nexus.co",
        },
        body: JSON.stringify({ freeDailyNexMessageLimit: 12 }),
      }),
    );

    expect(response.status).toBe(429);
    expect(checkRateLimit).toHaveBeenCalled();
  });
});
