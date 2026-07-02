import "server-only";

import { createClient } from "@/lib/supabase/server";
import { validateSessionFreshness } from "@/server/services/sessionFreshnessService";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): string | null {
  const role = appMetadata?.userRole;
  return typeof role === "string" ? role : null;
}

export const ADMIN_ROLES = ["super_admin", "support"] as const;
export type AdminRole = (typeof ADMIN_ROLES)[number];

export type AdminRoleAuthResult =
  | { ok: true; userId: string; role: AdminRole }
  | { ok: false; status: 401 | 403; message: string };

export type SuperAdminAuthResult =
  | { ok: true; userId: string }
  | { ok: false; status: 401 | 403; message: string };

function isAdminRole(role: string | null): role is AdminRole {
  return role !== null && (ADMIN_ROLES as readonly string[]).includes(role);
}

export async function requireAdminRole(
  allowedRoles: readonly AdminRole[],
): Promise<AdminRoleAuthResult> {
  const supabase = await createClient();
  const {
    data: { session },
  } = await supabase.auth.getSession();
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    return {
      ok: false,
      status: 401,
      message: "Missing or invalid session.",
    };
  }

  if (session?.access_token) {
    const freshness = await validateSessionFreshness({
      userId: user.id,
      accessToken: session.access_token,
    });

    if (!freshness.ok) {
      return {
        ok: false,
        status: 401,
        message: "Session has been revoked.",
      };
    }
  }

  const role = getRoleFromAppMetadata(user.app_metadata);

  if (!isAdminRole(role) || !allowedRoles.includes(role)) {
    return {
      ok: false,
      status: 403,
      message: "Super admin access required.",
    };
  }

  return { ok: true, userId: user.id, role };
}

export async function requireSuperAdmin(): Promise<SuperAdminAuthResult> {
  const result = await requireAdminRole(["super_admin"]);

  if (!result.ok) {
    return { ok: false, status: result.status, message: result.message };
  }

  return { ok: true, userId: result.userId };
}
