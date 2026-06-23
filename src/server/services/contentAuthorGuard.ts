import "server-only";

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
