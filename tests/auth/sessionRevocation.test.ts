/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  readSessionVersionFromAccessToken,
  validateSessionFreshness,
} from "@/server/services/sessionFreshnessService";
import {
  disableAccount,
  revokeAllSessions,
} from "@/server/services/sessionRevocationService";

const getUserById = vi.fn();
const updateUserById = vi.fn();
const signOut = vi.fn();
const rpc = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    auth: {
      admin: {
        getUserById,
        updateUserById,
        signOut,
      },
    },
    rpc,
  })),
}));

function buildAccessToken(sessionVersion: number, sessionId = "session-1"): string {
  const header = Buffer.from(JSON.stringify({ alg: "none", typ: "JWT" })).toString(
    "base64url",
  );
  const payload = Buffer.from(
    JSON.stringify({
      app_metadata: { sessionVersion },
      session_id: sessionId,
    }),
  ).toString("base64url");

  return `${header}.${payload}.signature`;
}

beforeEach(() => {
  getUserById.mockReset();
  updateUserById.mockReset();
  signOut.mockReset();
  rpc.mockReset();
});

describe("session revocation freshness", () => {
  it("rejects an already-issued JWT after session version bump", async () => {
    const userId = "user-revoke-1";
    const staleToken = buildAccessToken(1);

    getUserById.mockResolvedValue({
      data: {
        user: {
          id: userId,
          banned_until: null,
          app_metadata: { sessionVersion: 2, userRole: "student" },
        },
      },
      error: null,
    });
    rpc.mockResolvedValue({ data: true, error: null });

    const result = await validateSessionFreshness({
      userId,
      accessToken: staleToken,
    });

    expect(result).toEqual({ ok: false, reason: "session_version_stale" });
  });

  it("rejects revoked sessions when auth.sessions row is gone", async () => {
    const userId = "user-revoke-2";
    const token = buildAccessToken(3);

    getUserById.mockResolvedValue({
      data: {
        user: {
          id: userId,
          banned_until: null,
          app_metadata: { sessionVersion: 3, userRole: "parent" },
        },
      },
      error: null,
    });
    rpc.mockResolvedValue({ data: false, error: null });

    const result = await validateSessionFreshness({
      userId,
      accessToken: token,
    });

    expect(result).toEqual({ ok: false, reason: "session_not_active" });
  });

  it("rejects disabled accounts", async () => {
    const userId = "user-disabled";
    const token = buildAccessToken(1);

    getUserById.mockResolvedValue({
      data: {
        user: {
          id: userId,
          banned_until: new Date(Date.now() + 60_000).toISOString(),
          app_metadata: { sessionVersion: 1, userRole: "student" },
        },
      },
      error: null,
    });

    const result = await validateSessionFreshness({
      userId,
      accessToken: token,
    });

    expect(result).toEqual({ ok: false, reason: "account_disabled" });
  });

  it("reads session version from JWT payload", () => {
    expect(readSessionVersionFromAccessToken(buildAccessToken(4))).toBe(4);
  });

  it("bumps session version and signs out on role revocation", async () => {
    getUserById.mockResolvedValue({
      data: {
        user: {
          id: "role-change-user",
          app_metadata: { sessionVersion: 2, userRole: "student" },
        },
      },
      error: null,
    });
    updateUserById.mockResolvedValue({ error: null });
    signOut.mockResolvedValue({ error: null });

    await revokeAllSessions("role-change-user", "role_changed:student->parent");

    expect(updateUserById).toHaveBeenCalledWith(
      "role-change-user",
      expect.objectContaining({
        app_metadata: expect.objectContaining({ sessionVersion: 3 }),
      }),
    );
    expect(signOut).toHaveBeenCalledWith("role-change-user", "global");
  });

  it("disables accounts after revoking sessions", async () => {
    getUserById.mockResolvedValue({
      data: {
        user: {
          id: "disable-user",
          app_metadata: { sessionVersion: 1 },
        },
      },
      error: null,
    });
    updateUserById.mockResolvedValue({ error: null });
    signOut.mockResolvedValue({ error: null });

    await disableAccount("disable-user", "admin_disabled");

    expect(signOut).toHaveBeenCalledWith("disable-user", "global");
    expect(updateUserById).toHaveBeenLastCalledWith("disable-user", {
      ban_duration: "876000h",
    });
  });
});

describe("session revocation integration", () => {
  it("uses admin client factory", () => {
    expect(createAdminClient).toBeDefined();
  });
});
