/**
 * @vitest-environment node
 *
 * PR-031: critical admin mutations must fail closed when audit insert fails.
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const updateUserById = vi.fn();
const getUserById = vi.fn();
const insertAudit = vi.fn();

type AssignmentRow = {
  id: string;
  user_id: string;
  role_key: string;
  assigned_by: string | null;
  created_at: string;
};

let assignmentRows: AssignmentRow[] = [];
let runtimeRole = "student";

function mockFrom(table: string) {
  if (table === "admin_audit_log") {
    return { insert: insertAudit };
  }

  if (table !== "admin_role_assignments") {
    return {};
  }

  return {
    select: (columns?: string, opts?: { count?: string; head?: boolean }) => {
      if (opts?.count === "exact") {
        return {
          eq: async () => ({
            count: assignmentRows.filter((row) => row.role_key === "super_admin")
              .length,
            error: null,
          }),
        };
      }

      return {
        eq: (column: string, value?: string) => {
          if (column === "user_id" && value) {
            const rowsForUser = assignmentRows.filter((row) => row.user_id === value);

            return {
              eq: (column2: string, value2?: string) => {
                if (column2 === "role_key" && value2 === "super_admin") {
                  const row = rowsForUser.find((row) => row.role_key === "super_admin");
                  return {
                    maybeSingle: async () => ({
                      data: row ?? null,
                      error: null,
                    }),
                  };
                }

                return {
                  maybeSingle: async () => ({ data: null, error: null }),
                };
              },
              then: (
                resolve: (value: {
                  data: Array<{ role_key: string }>;
                  error: null;
                }) => void,
              ) =>
                resolve({
                  data: rowsForUser.map((row) => ({ role_key: row.role_key })),
                  error: null,
                }),
            };
          }

          return {
            maybeSingle: async () => ({ data: null, error: null }),
          };
        },
      };
    },
    upsert: (payload: {
      user_id: string;
      role_key: string;
      assigned_by: string;
    }) => ({
      select: () => ({
        single: async () => {
          const existing = assignmentRows.find(
            (row) =>
              row.user_id === payload.user_id && row.role_key === payload.role_key,
          );

          const row: AssignmentRow = existing ?? {
            id: `assign-${assignmentRows.length + 1}`,
            user_id: payload.user_id,
            role_key: payload.role_key,
            assigned_by: payload.assigned_by,
            created_at: new Date().toISOString(),
          };

          if (!existing) {
            assignmentRows.push(row);
          } else {
            existing.assigned_by = payload.assigned_by;
          }

          return { data: row, error: null };
        },
      }),
    }),
    delete: () => ({
      eq: (column: string, value: string) => ({
        eq: async (column2: string, value2: string) => {
          assignmentRows = assignmentRows.filter(
            (row) =>
              !(row.user_id === value && row.role_key === value2),
          );
          return { error: null };
        },
        in: async (_column2: string, values: string[]) => {
          assignmentRows = assignmentRows.filter(
            (row) => !(row.user_id === value && values.includes(row.role_key)),
          );
          return { error: null };
        },
      }),
      in: async (_column: string, values: string[]) => ({
        error: null,
      }),
    }),
    insert: async (rows: AssignmentRow[]) => {
      assignmentRows.push(...rows);
      return { error: null };
    },
  };
}

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    auth: { admin: { updateUserById, getUserById } },
    from: (table: string) => mockFrom(table),
  })),
}));

vi.mock("@/server/services/sessionRevocationService", () => ({
  revokeAllSessions: vi.fn(async () => undefined),
}));

vi.mock("@/server/services/requireAdminApi", () => ({
  requireAdminApi: vi.fn(async () => ({
    ok: true,
    userId: "super-1",
    role: "super_admin",
  })),
}));

import { POST as rolesPost } from "@/app/api/admin/roles/route";
import { AdminAuditWriteError } from "@/server/services/adminAuditService";
import { assignAdminRoleWithAudit } from "@/server/services/adminRoleService";

const targetUserId = "00000000-0000-4000-8000-000000000002";

describe("assignAdminRoleWithAudit compensation", () => {
  beforeEach(() => {
    assignmentRows = [];
    runtimeRole = "student";
    updateUserById.mockReset();
    getUserById.mockReset();
    insertAudit.mockReset();

    getUserById.mockImplementation(async () => ({
      data: {
        user: {
          app_metadata: { userRole: runtimeRole, sessionVersion: 1 },
        },
      },
      error: null,
    }));
    updateUserById.mockImplementation(async (_userId, payload) => {
      runtimeRole = String(
        (payload as { app_metadata?: { userRole?: string } }).app_metadata
          ?.userRole ?? runtimeRole,
      );
      return { error: null };
    });
    insertAudit.mockResolvedValue({ error: null });
  });

  it("reverts ledger + runtime role when audit write fails", async () => {
    insertAudit.mockResolvedValueOnce({ error: { message: "audit down" } });

    await expect(
      assignAdminRoleWithAudit({
        assignment: { userId: targetUserId, roleKey: "support" },
        actorUserId: "super-1",
        writeAudit: async (assignment) => {
          const { recordAdminAudit } = await import(
            "@/server/services/adminAuditService"
          );
          await recordAdminAudit({
            actorUserId: "super-1",
            actorRole: "super_admin",
            action: "admin_role.assign",
            targetType: "admin_role_assignment",
            targetId: assignment.id,
          });
        },
      }),
    ).rejects.toBeInstanceOf(AdminAuditWriteError);

    expect(assignmentRows).toEqual([]);
    expect(runtimeRole).toBe("student");
  });

  it("keeps assignment when audit succeeds", async () => {
    const assignment = await assignAdminRoleWithAudit({
      assignment: { userId: targetUserId, roleKey: "support" },
      actorUserId: "super-1",
      writeAudit: async (created) => {
        const { recordAdminAudit } = await import(
          "@/server/services/adminAuditService"
        );
        await recordAdminAudit({
          actorUserId: "super-1",
          actorRole: "super_admin",
          action: "admin_role.assign",
          targetType: "admin_role_assignment",
          targetId: created.id,
        });
      },
    });

    expect(assignment.roleKey).toBe("support");
    expect(assignmentRows).toHaveLength(1);
    expect(runtimeRole).toBe("support");
  });
});

describe("admin roles route — audit fail-closed", () => {
  beforeEach(() => {
    assignmentRows = [];
    runtimeRole = "student";
    updateUserById.mockReset();
    getUserById.mockReset();
    insertAudit.mockReset();

    getUserById.mockImplementation(async () => ({
      data: {
        user: {
          app_metadata: { userRole: runtimeRole, sessionVersion: 1 },
        },
      },
      error: null,
    }));
    updateUserById.mockImplementation(async (_userId, payload) => {
      runtimeRole = String(
        (payload as { app_metadata?: { userRole?: string } }).app_metadata
          ?.userRole ?? runtimeRole,
      );
      return { error: null };
    });
    insertAudit.mockResolvedValue({ error: { message: "audit down" } });
  });

  it("returns 503 and does not persist role assignment when audit fails", async () => {
    const response = await rolesPost(
      new Request("https://app.nexus.co/api/admin/roles", {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          cookie: "s=1",
          origin: "https://app.nexus.co",
        },
        body: JSON.stringify({
          userId: targetUserId,
          roleKey: "support",
        }),
      }),
    );

    expect(response.status).toBe(503);
    const body = (await response.json()) as {
      error?: { code?: string };
    };
    expect(body.error?.code).toBe("AUDIT_WRITE_FAILED");
    expect(assignmentRows).toEqual([]);
    expect(runtimeRole).toBe("student");
  });
});
