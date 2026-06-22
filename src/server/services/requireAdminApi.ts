import "server-only";

import { NextResponse } from "next/server";

import {
  type AdminRole,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export type RequireAdminApiResult =
  | { ok: true; userId: string; role: AdminRole }
  | { ok: false; response: NextResponse };

export async function requireAdminApi(
  _request: Request,
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

  return { ok: true, userId: auth.userId, role: auth.role };
}
