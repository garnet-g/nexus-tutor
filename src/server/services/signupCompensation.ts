import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { releaseBetaInvite } from "@/server/services/betaInviteService";

const ROLLBACK_WINDOW_MS = 5 * 60 * 1000;

export async function rollbackFailedSignup(input: {
  userId: string;
  role: "student" | "parent";
  inviteCode?: string;
}): Promise<void> {
  const admin = createAdminClient();
  const { data: userData, error: userError } =
    await admin.auth.admin.getUserById(input.userId);

  if (userError || !userData.user) {
    console.warn("SIGNUP_ROLLBACK_SKIPPED", {
      userId: input.userId,
      reason: "user_not_found",
    });
    return;
  }

  const createdAt = new Date(userData.user.created_at).getTime();
  if (Date.now() - createdAt > ROLLBACK_WINDOW_MS) {
    console.warn("SIGNUP_ROLLBACK_SKIPPED", {
      userId: input.userId,
      reason: "rollback_window_expired",
    });
    return;
  }

  const profileTable =
    input.role === "student" ? "student_profiles" : "parent_profiles";

  await admin.from(profileTable).delete().eq("user_id", input.userId);

  if (input.inviteCode) {
    try {
      await releaseBetaInvite(input.inviteCode, input.userId);
    } catch (releaseError) {
      console.error("SIGNUP_ROLLBACK_INVITE_RELEASE_FAILED", {
        userId: input.userId,
        error:
          releaseError instanceof Error ? releaseError.message : releaseError,
      });
    }
  }

  const { error: deleteError } = await admin.auth.admin.deleteUser(input.userId);

  if (deleteError) {
    console.error("SIGNUP_ROLLBACK_DELETE_FAILED", {
      userId: input.userId,
      error: deleteError.message,
    });
    return;
  }

  console.info("SIGNUP_ROLLBACK", { userId: input.userId, role: input.role });
}
