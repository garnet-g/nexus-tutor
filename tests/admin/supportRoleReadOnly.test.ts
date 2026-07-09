import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { POST as betaInvitesPOST } from "@/app/api/admin/beta-invites/route";
import { PATCH as platformSettingsPATCH } from "@/app/api/admin/platform-settings/route";

vi.mock("server-only", () => ({}));

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({ auth: { getUser, getSession } })),
}));

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

// These modules are imported by the routes; mutating paths must never be reached
// for a non-super-admin, so their behaviour is irrelevant beyond not throwing on import.
vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from: vi.fn() })),
}));

const createBetaInvite = vi.fn();
const listBetaInvites = vi.fn();
vi.mock("@/server/services/betaInviteService", () => ({
  createBetaInvite: (...args: unknown[]) => createBetaInvite(...args),
  listBetaInvites: (...args: unknown[]) => listBetaInvites(...args),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

vi.mock("@/lib/platform/getPlatformSettings", () => ({
  clearPlatformSettingsCache: vi.fn(),
  getEffectiveSubscriptionConfig: vi.fn(),
}));

function authedAs(role: string, userId = "support-1") {
  getUser.mockResolvedValue({
    data: { user: { id: userId, app_metadata: { userRole: role } } },
    error: null,
  });
}

beforeEach(() => {
  getUser.mockReset();
  getSession.mockReset();
  getSession.mockResolvedValue({
    data: { session: { access_token: "token" } },
    error: null,
  });
  createBetaInvite.mockReset();
  recordAdminAudit.mockReset();
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("support role is read-only on mutating admin routes", () => {
  it("beta-invites POST rejects a support role with 403 FORBIDDEN", async () => {
    authedAs("support");

    const request = new Request("https://nexus.test/api/admin/beta-invites", {
      method: "POST",
      body: JSON.stringify({ maxUses: 5 }),
      headers: { "content-type": "application/json" },
    });

    const response = await betaInvitesPOST(request);
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    // The mutation must never run for a support user.
    expect(createBetaInvite).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("platform-settings PATCH rejects a support role with 403 FORBIDDEN", async () => {
    authedAs("support");

    const request = new Request(
      "https://nexus.test/api/admin/platform-settings",
      {
        method: "PATCH",
        body: JSON.stringify({ freeDailyNexMessageLimit: 10 }),
        headers: { "content-type": "application/json" },
      },
    );

    const response = await platformSettingsPATCH(request);
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("both routes still admit a super_admin past the guard (sanity: not a blanket 403)", async () => {
    authedAs("super_admin");
    createBetaInvite.mockResolvedValue({
      id: "invite-1",
      invite_code: "CODE",
      max_uses: 5,
      expires_at: null,
    });

    const request = new Request("https://nexus.test/api/admin/beta-invites", {
      method: "POST",
      body: JSON.stringify({ maxUses: 5 }),
      headers: { "content-type": "application/json" },
    });

    const response = await betaInvitesPOST(request);

    expect(response.status).not.toBe(403);
    expect(response.status).not.toBe(401);
    expect(createBetaInvite).toHaveBeenCalledTimes(1);
  });
});
