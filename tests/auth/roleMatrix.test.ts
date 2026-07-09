import { readFileSync } from "node:fs";
import { join } from "node:path";

import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { GET as familyInviteGet } from "@/app/api/family/invite-code/route";
import { GET as usageStatsGet } from "@/app/api/admin/usage-stats/route";
import {
  listApiFiles,
  listPageFiles,
} from "../../scripts/extractRouteGuards";
import {
  LAYOUT_GATED_STUDENT_ROUTES,
  ROLE_MATRIX_MANIFEST,
  SERVER_ACTION_CONTRACT,
  STUDENT_ONLY_API_PATHS,
  SUPER_ADMIN_ONLY_API_PATHS,
  SUPER_ADMIN_ONLY_PAGE_PATHS,
} from "./roleMatrix.manifest";

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
  getSession.mockResolvedValue({
    data: {
      session: {
        id: "session-123",
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

describe("role matrix committed contract", () => {
  it("covers all page.tsx and route.ts files", () => {
    const pages = listPageFiles();
    const apis = listApiFiles();
    const manifestFiles = new Set(ROLE_MATRIX_MANIFEST.map((entry) => entry.filePath));

    expect(pages).toHaveLength(74);
    expect(apis).toHaveLength(97);
    expect(ROLE_MATRIX_MANIFEST).toHaveLength(pages.length + apis.length);

    for (const filePath of [...pages, ...apis]) {
      expect(manifestFiles.has(filePath), `missing manifest entry for ${filePath}`).toBe(
        true,
      );
    }
  });

  it("covers every server action file with explicit tiers", () => {
    const actionFiles = [
      "src/server/actions/authActions.ts",
      "src/server/actions/profileActions.ts",
      "src/server/actions/onboardingActions.ts",
    ];

    expect(SERVER_ACTION_CONTRACT.map((entry) => entry.filePath)).toEqual(actionFiles);

    for (const filePath of actionFiles) {
      const entry = SERVER_ACTION_CONTRACT.find((item) => item.filePath === filePath);
      expect(entry, `missing server action contract for ${filePath}`).toBeTruthy();
      expect(entry!.actions.length).toBeGreaterThan(0);
    }
  });

  it("classifies /api/family/* as student-only in the committed contract", () => {
    for (const apiPath of STUDENT_ONLY_API_PATHS) {
      const entry = ROLE_MATRIX_MANIFEST.find((item) => item.path === apiPath);
      expect(entry?.tier, `${apiPath} must be student tier`).toBe("student");
    }
  });

  it("documents layout-gated student routes for proxy audit", () => {
    const proxySource = readFileSync(join(process.cwd(), "src/proxy.ts"), "utf8");

    for (const route of LAYOUT_GATED_STUDENT_ROUTES) {
      expect(proxySource.includes(route)).toBe(false);
    }
  });

  it("requires super-admin guards on sensitive SSR pages", () => {
    for (const pagePath of SUPER_ADMIN_ONLY_PAGE_PATHS) {
      const filePath = ROLE_MATRIX_MANIFEST.find((entry) => entry.path === pagePath)?.filePath;
      expect(filePath, `manifest path missing for ${pagePath}`).toBeTruthy();

      const source = readFileSync(join(process.cwd(), filePath!), "utf8");
      expect(source).toContain("requireSuperAdmin");
      expect(source).toContain('redirect("/login")');
    }
  });
});

describe("role matrix negative API cases", () => {
  it("returns 403 for support on /api/admin/usage-stats", async () => {
    authedAs("support");

    const response = await usageStatsGet();
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body).toEqual({
      success: false,
      error: {
        code: "FORBIDDEN",
        message: "Super admin access required.",
      },
    });
  });

  it("returns 401 for unauthenticated /api/admin/usage-stats", async () => {
    getUser.mockResolvedValue({ data: { user: null }, error: null });
    getSession.mockResolvedValue({ data: { session: null }, error: null });

    const response = await usageStatsGet();
    const body = await response.json();

    expect(response.status).toBe(401);
    expect(body.error.code).toBe("UNAUTHORIZED");
  });

  it("returns 401 for parent on /api/family/invite-code", async () => {
    authedAs("parent");

    const response = await familyInviteGet();
    expect(response.status).toBe(401);
  });

  it("returns 401 for support on /api/family/invite-code", async () => {
    authedAs("support");

    const response = await familyInviteGet();
    expect(response.status).toBe(401);
  });
});

describe("committed super-admin API contract", () => {
  it("marks super-admin-only APIs in manifest", () => {
    for (const apiPath of SUPER_ADMIN_ONLY_API_PATHS) {
      const entry = ROLE_MATRIX_MANIFEST.find((item) => item.path === apiPath);
      expect(entry?.tier, `missing super-admin API manifest entry for ${apiPath}`).toBe(
        "super_admin",
      );
    }
  });
});
