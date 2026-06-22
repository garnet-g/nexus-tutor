import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import {
  ADMIN_ROLES,
  requireAdminRole,
  requireSuperAdmin,
} from "@/server/services/superAdminGuard";

// `server-only` throws outside a React Server Component graph; the guard imports
// it at the top of the module, so neutralise it for the test runtime.
vi.mock("server-only", () => ({}));

const getUser = vi.fn();

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      getUser,
    },
  })),
}));

function authedAs(role: string | undefined, userId = "user-123") {
  getUser.mockResolvedValue({
    data: {
      user: {
        id: userId,
        app_metadata: role === undefined ? {} : { userRole: role },
      },
    },
    error: null,
  });
}

beforeEach(() => {
  getUser.mockReset();
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("requireAdminRole", () => {
  it("returns 401 when there is no session", async () => {
    getUser.mockResolvedValue({ data: { user: null }, error: null });

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toEqual({
      ok: false,
      status: 401,
      message: "Missing or invalid session.",
    });
  });

  it("returns 401 when getUser surfaces an error", async () => {
    getUser.mockResolvedValue({
      data: { user: null },
      error: { message: "jwt expired" },
    });

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toMatchObject({ ok: false, status: 401 });
  });

  it("grants a super_admin when super_admin is allowed", async () => {
    authedAs("super_admin", "super-1");

    const result = await requireAdminRole(["super_admin"]);

    expect(result).toEqual({
      ok: true,
      userId: "super-1",
      role: "super_admin",
    });
  });

  it("grants a support user when support is within the admin roles", async () => {
    authedAs("support", "support-1");

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toEqual({
      ok: true,
      userId: "support-1",
      role: "support",
    });
  });

  it("rejects a support user with 403 when only super_admin is allowed", async () => {
    authedAs("support");

    const result = await requireAdminRole(["super_admin"]);

    expect(result).toEqual({
      ok: false,
      status: 403,
      message: "Super admin access required.",
    });
  });

  it("rejects an unknown role with 403", async () => {
    authedAs("teacher");

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toMatchObject({ ok: false, status: 403 });
  });

  it("rejects an absent role with 403", async () => {
    authedAs(undefined);

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toMatchObject({ ok: false, status: 403 });
  });

  it("rejects a non-string role value with 403", async () => {
    getUser.mockResolvedValue({
      data: { user: { id: "x", app_metadata: { userRole: 42 } } },
      error: null,
    });

    const result = await requireAdminRole(ADMIN_ROLES);

    expect(result).toMatchObject({ ok: false, status: 403 });
  });
});

describe("requireSuperAdmin (backward compatibility)", () => {
  it("returns the legacy success shape (no role field) for super_admin", async () => {
    authedAs("super_admin", "super-2");

    const result = await requireSuperAdmin();

    expect(result).toEqual({ ok: true, userId: "super-2" });
    expect(result).not.toHaveProperty("role");
  });

  it("returns 403 for a support user", async () => {
    authedAs("support");

    const result = await requireSuperAdmin();

    expect(result).toEqual({
      ok: false,
      status: 403,
      message: "Super admin access required.",
    });
  });

  it("returns 401 when unauthenticated", async () => {
    getUser.mockResolvedValue({ data: { user: null }, error: null });

    const result = await requireSuperAdmin();

    expect(result).toMatchObject({ ok: false, status: 401 });
  });
});
