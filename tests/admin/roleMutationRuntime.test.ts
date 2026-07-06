/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const updateUserById = vi.fn();
const getUserById = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    auth: { admin: { updateUserById, getUserById } },
    from: (table: string) => mockFrom(table),
  })),
}));

vi.mock("@/server/services/sessionRevocationService", () => ({
  revokeAllSessions: vi.fn(async () => undefined),
}));

import {
  assignAdminRole,
  LastSuperAdminError,
} from "@/server/services/adminRoleService";

type MockOptions = {
  superAdminCount: number;
  targetHasSuperAdmin?: boolean;
};

let mockOptions: MockOptions = { superAdminCount: 2 };

function mockFrom(table: string) {
  if (table !== "admin_role_assignments") {
    return {};
  }

  return {
    select: (columns?: string, opts?: { count?: string; head?: boolean }) => {
      if (opts?.count === "exact") {
        return {
          eq: async () => ({
            count: mockOptions.superAdminCount,
            error: null,
          }),
        };
      }

      return {
        eq: (column: string, value?: string) => {
          if (column === "user_id" && value) {
            return {
              eq: (column2: string, value2?: string) => {
                if (column2 === "role_key" && value2 === "super_admin") {
                  return {
                    maybeSingle: async () => ({
                      data: mockOptions.targetHasSuperAdmin ? { id: "sa-1" } : null,
                      error: null,
                    }),
                  };
                }

                return {
                  maybeSingle: async () => ({ data: null, error: null }),
                };
              },
              then: (
                resolve: (value: { data: Array<{ role_key: string }>; error: null }) => void,
              ) =>
                resolve({
                  data: [{ role_key: "support" }],
                  error: null,
                }),
            };
          }

          if (column === "role_key" && value === "super_admin") {
            return {
              eq: async () => ({
                count: mockOptions.superAdminCount,
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
    upsert: () => ({
      select: () => ({
        single: async () => ({
          data: {
            id: "row-1",
            user_id: "00000000-0000-4000-8000-000000000001",
            role_key: "support",
            assigned_by: "actor-1",
            created_at: new Date().toISOString(),
          },
          error: null,
        }),
      }),
    }),
    delete: () => ({
      eq: () => ({
        eq: async () => ({ error: null }),
        in: async () => ({ error: null }),
      }),
      in: async () => ({ error: null }),
    }),
  };
}

describe("assignAdminRole", () => {
  beforeEach(() => {
    mockOptions = { superAdminCount: 2, targetHasSuperAdmin: false };
    updateUserById.mockReset();
    getUserById.mockReset();
    getUserById.mockResolvedValue({
      data: { user: { app_metadata: { userRole: "student", sessionVersion: 1 } } },
      error: null,
    });
    updateUserById.mockResolvedValue({ error: null });
  });

  it("syncs support into app_metadata.userRole", async () => {
    await assignAdminRole({
      assignment: {
        userId: "00000000-0000-4000-8000-000000000001",
        roleKey: "support",
      },
      actorUserId: "actor-1",
    });

    expect(updateUserById).toHaveBeenCalledWith(
      "00000000-0000-4000-8000-000000000001",
      expect.objectContaining({
        app_metadata: expect.objectContaining({ userRole: "support" }),
      }),
    );
  });
});

describe("last super-admin protection", () => {
  beforeEach(() => {
    mockOptions = { superAdminCount: 1, targetHasSuperAdmin: true };
    getUserById.mockResolvedValue({
      data: { user: { app_metadata: { userRole: "super_admin", sessionVersion: 1 } } },
      error: null,
    });
  });

  it("blocks replace_runtime demotion for the only super admin", async () => {
    await expect(
      assignAdminRole({
        assignment: {
          userId: "00000000-0000-4000-8000-000000000001",
          roleKey: "support",
          mode: "replace_runtime",
        },
        actorUserId: "00000000-0000-4000-8000-000000000002",
      }),
    ).rejects.toBeInstanceOf(LastSuperAdminError);
  });
});
