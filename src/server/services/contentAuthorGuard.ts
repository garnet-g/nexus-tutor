import "server-only";

import { NextResponse } from "next/server";

import { enforceAdminMutationGuards } from "@/lib/security/originCheck";
import {
  requireAdminRole,
} from "@/server/services/superAdminGuard";

/**
 * Roles allowed to author curriculum content in the Studio.
 * Today: super_admin only.
 * Future: add `teacher_author` here — pair with `author_id` ownership on lessons/questions.
 */
export const CONTENT_AUTHOR_ROLES = ["super_admin"] as const;

export type ContentAuthorRole = (typeof CONTENT_AUTHOR_ROLES)[number];

export type ContentAuthorAuthResult =
  | { ok: true; userId: string; role: ContentAuthorRole }
  | { ok: false; status: 401 | 403; message: string };

export async function requireContentAuthor(): Promise<ContentAuthorAuthResult> {
  const result = await requireAdminRole([...CONTENT_AUTHOR_ROLES]);

  if (!result.ok) {
    return {
      ok: false,
      status: result.status,
      message: result.message,
    };
  }

  return {
    ok: true,
    userId: result.userId,
    role: result.role as ContentAuthorRole,
  };
}

export type ContentAuthorApiAuthResult =
  | { ok: true; userId: string; role: ContentAuthorRole }
  | { ok: false; response: NextResponse };

export async function requireContentAuthorApi(
  request: Request,
): Promise<ContentAuthorApiAuthResult> {
  const auth = await requireContentAuthor();

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

  const guardError = await enforceAdminMutationGuards(request, auth.userId);
  if (guardError) {
    return { ok: false, response: guardError };
  }

  return auth;
}
