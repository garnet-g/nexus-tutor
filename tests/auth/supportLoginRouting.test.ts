import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import {
  getPostAuthRedirectPath,
  getSessionUser,
} from "@/server/services/authService";

const getUser = vi.fn();
const getSession = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser, getSession },
    from: vi.fn(),
  })),
}));

vi.mock("@/server/services/sessionFreshnessService", () => ({
  validateSessionFreshness: vi.fn(async () => ({ ok: true })),
}));

function authedAsSupport(userId = "support-1", email = "support@test.local") {
  getUser.mockResolvedValue({
    data: {
      user: {
        id: userId,
        email,
        app_metadata: { userRole: "support" },
      },
    },
    error: null,
  });
  getSession.mockResolvedValue({
    data: {
      session: {
        id: "session-support",
        access_token: "header.payload.signature",
      },
    },
    error: null,
  });
}

beforeEach(() => {
  getUser.mockReset();
  getSession.mockReset();
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("support login routing", () => {
  it("returns a non-null session user for support role", async () => {
    authedAsSupport();

    const sessionUser = await getSessionUser();

    expect(sessionUser).toEqual({
      id: "support-1",
      email: "support@test.local",
      role: "support",
      studentProfile: null,
      parentProfile: null,
    });
  });

  it("routes support users to /admin/support after auth", () => {
    const path = getPostAuthRedirectPath({
      id: "support-1",
      email: "support@test.local",
      role: "support",
      studentProfile: null,
      parentProfile: null,
    });

    expect(path).toBe("/admin/support");
  });

  it("routes super admins to /admin command center", () => {
    const path = getPostAuthRedirectPath({
      id: "admin-1",
      email: "admin@test.local",
      role: "super_admin",
      studentProfile: null,
      parentProfile: null,
    });

    expect(path).toBe("/admin");
  });

  it("still rejects unknown roles", async () => {
    getUser.mockResolvedValue({
      data: {
        user: {
          id: "x",
          email: "x@test.local",
          app_metadata: { userRole: "teacher" },
        },
      },
      error: null,
    });
    getSession.mockResolvedValue({
      data: {
        session: {
          id: "session-x",
          access_token: "header.payload.signature",
        },
      },
      error: null,
    });

    await expect(getSessionUser()).resolves.toBeNull();
  });
});
