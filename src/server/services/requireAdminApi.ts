import "server-only";

import { NextResponse } from "next/server";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import {
  type AdminRole,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export type RequireAdminApiResult =
  | { ok: true; userId: string; role: AdminRole }
  | { ok: false; response: NextResponse };

export async function requireAdminApi(
  request: Request,
  allowedRoles: readonly AdminRole[],
): Promise<RequireAdminApiResult> {
  const auth = await requireAdminRole(allowedRoles);

  if (!auth.ok) {
    return {
      ok: false,
      response: NextResponse.json(
        {
          success: false,
          error: {
            code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
            message: auth.message,
          },
        },
        { status: auth.status },
      ),
    };
  }

  // Central CSRF origin check, body-size ceiling, and per-admin burst limit for
  // every privileged mutation that routes through this guard (PR-049, PR-089,
  // PR-090). No-ops on non-mutating methods, so admin GET routes are unaffected.
  const guardError = await enforceAdminMutationGuards(request, auth.userId);

  if (guardError) {
    return { ok: false, response: guardError };
  }

  return { ok: true, userId: auth.userId, role: auth.role };
}
