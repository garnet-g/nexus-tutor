import "server-only";

import { createClient } from "@/lib/supabase/server";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): string | null {
  const role = appMetadata?.userRole;
  return typeof role === "string" ? role : null;
}

export type SuperAdminAuthResult =
  | { ok: true; userId: string }
  | { ok: false; status: 401 | 403; message: string };

export async function requireSuperAdmin(): Promise<SuperAdminAuthResult> {
  const supabase = await createClient();
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

  if (getRoleFromAppMetadata(user.app_metadata) !== "super_admin") {
    return {
      ok: false,
      status: 403,
      message: "Super admin access required.",
    };
  }

  return { ok: true, userId: user.id };
}
