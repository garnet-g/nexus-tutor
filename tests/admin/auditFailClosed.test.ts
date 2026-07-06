/**
 * @vitest-environment node
 *
 * PR-031: critical admin mutations must fail closed when audit insert fails.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const assignAdminRole = vi.fn();
const recordAdminAudit = vi.fn();

vi.mock("@/server/services/adminRoleService", () => ({
  assignAdminRole: (...args: unknown[]) => assignAdminRole(...args),
  LastSuperAdminError: class LastSuperAdminError extends Error {
    readonly code = "LAST_SUPER_ADMIN";
  },
  SelfDemotionError: class SelfDemotionError extends Error {
    readonly code = "SELF_DEMOTION_FORBIDDEN";
  },
}));

vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
  AdminAuditWriteError: class AdminAuditWriteError extends Error {
    readonly code = "AUDIT_WRITE_FAILED";
  },
}));

vi.mock("@/server/services/requireAdminApi", () => ({
  requireAdminApi: vi.fn(async () => ({
    ok: true,
    userId: "super-1",
    role: "super_admin",
  })),
}));

import { POST as rolesPost } from "@/app/api/admin/roles/route";

describe("admin roles route — audit fail-closed", () => {
  beforeEach(() => {
    assignAdminRole.mockReset();
    recordAdminAudit.mockReset();
    assignAdminRole.mockResolvedValue({
      id: "assign-1",
      userId: "00000000-0000-4000-8000-000000000002",
      roleKey: "support",
      assignedBy: "super-1",
      createdAt: new Date().toISOString(),
    });
  });

  it("returns 503 when audit persistence fails after role assignment", async () => {
    const { AdminAuditWriteError } = await import(
      "@/server/services/adminAuditService"
    );
    recordAdminAudit.mockRejectedValue(new AdminAuditWriteError("audit down"));

    const response = await rolesPost(
      new Request("https://app.nexus.co/api/admin/roles", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          cookie: "s=1",
          origin: "https://app.nexus.co",
        },
        body: JSON.stringify({
          userId: "00000000-0000-4000-8000-000000000002",
          roleKey: "support",
        }),
      }),
    );

    expect(response.status).toBe(503);
    const body = (await response.json()) as {
      error?: { code?: string };
    };
    expect(body.error?.code).toBe("AUDIT_WRITE_FAILED");
  });
});
