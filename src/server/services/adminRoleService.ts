import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type { AdminRoleAssignmentInput } from "@/schemas/adminPlatformSchemas";
import { setCanonicalUserRole } from "@/server/services/authService";
import type { UserRole } from "@/types/database";

export class LastSuperAdminError extends Error {
  readonly code = "LAST_SUPER_ADMIN";

  constructor(message = "Cannot remove the last super admin.") {
    super(message);
    this.name = "LastSuperAdminError";
  }
}

export class SelfDemotionError extends Error {
  readonly code = "SELF_DEMOTION_FORBIDDEN";

  constructor(message = "Cannot demote yourself as the last super admin.") {
    super(message);
    this.name = "SelfDemotionError";
  }
}

const OPERATIONAL_ADMIN_ROLE_KEYS = new Set([
  "super_admin",
  "support",
  "content_reviewer",
  "finance_admin",
  "growth_admin",
  "ops_admin",
]);

function mapRoleKeysToRuntimeRole(roleKeys: string[]): UserRole | null {
  if (roleKeys.includes("super_admin")) {
    return "super_admin";
  }

  if (
    roleKeys.some((key) =>
      ["support", "content_reviewer", "finance_admin", "growth_admin", "ops_admin"].includes(
        key,
      ),
    )
  ) {
    return "support";
  }

  return null;
}

async function countSuperAdminAssignments(): Promise<number> {
  const admin = createAdminClient();
  const { count, error } = await admin
    .from("admin_role_assignments")
    .select("id", { count: "exact", head: true })
    .eq("role_key", "super_admin");

  if (error) {
    throw new Error(error.message);
  }

  return count ?? 0;
}

async function userHasSuperAdminAssignment(userId: string): Promise<boolean> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_role_assignments")
    .select("id")
    .eq("user_id", userId)
    .eq("role_key", "super_admin")
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  return Boolean(data);
}

async function listRoleKeysForUser(userId: string): Promise<string[]> {
  const admin = createAdminClient();
  const { data, error } = await admin
    .from("admin_role_assignments")
    .select("role_key")
    .eq("user_id", userId);

  if (error) {
    throw new Error(error.message);
  }

  return (data ?? []).map((row) => String(row.role_key));
}

async function assertCanRemoveSuperAdmin(
  userId: string,
  actorUserId: string,
): Promise<void> {
  const isSuperAdmin = await userHasSuperAdminAssignment(userId);
  if (!isSuperAdmin) {
    return;
  }

  const superAdminCount = await countSuperAdminAssignments();
  if (superAdminCount > 1) {
    return;
  }

  if (actorUserId === userId) {
    throw new SelfDemotionError();
  }

  throw new LastSuperAdminError();
}

async function syncRuntimeRoleForUser(userId: string): Promise<UserRole | null> {
  const roleKeys = await listRoleKeysForUser(userId);
  const runtimeRole = mapRoleKeysToRuntimeRole(roleKeys);

  if (!runtimeRole) {
    return null;
  }

  await setCanonicalUserRole(userId, runtimeRole);
  return runtimeRole;
}

function mapRole(row: Record<string, unknown>) {
  return {
    id: String(row.id),
    userId: String(row.user_id),
    roleKey: String(row.role_key),
    assignedBy: row.assigned_by ? String(row.assigned_by) : null,
    createdAt: String(row.created_at),
  };
}

export async function assignAdminRole(input: {
  assignment: AdminRoleAssignmentInput;
  actorUserId: string;
}) {
  const admin = createAdminClient();
  const mode = input.assignment.mode ?? "assign";

  if (mode === "replace_runtime") {
    const hadSuperAdmin = await userHasSuperAdminAssignment(input.assignment.userId);
    if (
      hadSuperAdmin &&
      input.assignment.roleKey !== "super_admin"
    ) {
      await assertCanRemoveSuperAdmin(input.assignment.userId, input.actorUserId);
    }

    const { error: deleteError } = await admin
      .from("admin_role_assignments")
      .delete()
      .eq("user_id", input.assignment.userId)
      .in("role_key", [...OPERATIONAL_ADMIN_ROLE_KEYS]);

    if (deleteError) {
      throw new Error(deleteError.message);
    }
  } else if (
    input.assignment.roleKey !== "super_admin" &&
    (await userHasSuperAdminAssignment(input.assignment.userId))
  ) {
    const superAdminCount = await countSuperAdminAssignments();
    if (superAdminCount === 1) {
      throw new LastSuperAdminError(
        "Cannot add a secondary admin role to the only super admin without assigning another super admin first.",
      );
    }
  }

  const { data, error } = await admin
    .from("admin_role_assignments")
    .upsert(
      {
        user_id: input.assignment.userId,
        role_key: input.assignment.roleKey,
        assigned_by: input.actorUserId,
      },
      { onConflict: "user_id,role_key" },
    )
    .select("id, user_id, role_key, assigned_by, created_at")
    .single();

  if (error) {
    throw new Error(error.message);
  }

  await syncRuntimeRoleForUser(input.assignment.userId);

  return mapRole(data);
}

export async function revokeAdminRole(input: {
  userId: string;
  roleKey: string;
  actorUserId: string;
}) {
  if (input.roleKey === "super_admin") {
    await assertCanRemoveSuperAdmin(input.userId, input.actorUserId);
  }

  const admin = createAdminClient();
  const { error } = await admin
    .from("admin_role_assignments")
    .delete()
    .eq("user_id", input.userId)
    .eq("role_key", input.roleKey);

  if (error) {
    throw new Error(error.message);
  }

  await syncRuntimeRoleForUser(input.userId);
}
