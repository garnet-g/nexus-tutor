import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export function readSessionVersion(
  appMetadata: Record<string, unknown> | undefined,
): number {
  const version = appMetadata?.sessionVersion;
  return typeof version === "number" && Number.isFinite(version) ? version : 1;
}

export async function bumpSessionVersion(userId: string): Promise<number> {
  const admin = createAdminClient();
  const { data: existingUser, error: readError } =
    await admin.auth.admin.getUserById(userId);

  if (readError) {
    throw new Error(readError.message);
  }

  const existingMetadata =
    (existingUser.user?.app_metadata as Record<string, unknown> | undefined) ??
    {};
  const nextVersion = readSessionVersion(existingMetadata) + 1;

  const { error } = await admin.auth.admin.updateUserById(userId, {
    app_metadata: {
      ...existingMetadata,
      sessionVersion: nextVersion,
    },
  });

  if (error) {
    throw new Error(error.message);
  }

  return nextVersion;
}

export async function revokeAllSessions(
  userId: string,
  reason: string,
): Promise<void> {
  await bumpSessionVersion(userId);

  const admin = createAdminClient();
  const { error } = await admin.auth.admin.signOut(userId, "global");

  if (error) {
    throw new Error(error.message);
  }

  console.info("SESSION_REVOKED", { userId, reason });
}

export async function disableAccount(
  userId: string,
  reason: string,
): Promise<void> {
  await revokeAllSessions(userId, reason);

  const admin = createAdminClient();
  const { error } = await admin.auth.admin.updateUserById(userId, {
    ban_duration: "876000h",
  });

  if (error) {
    throw new Error(error.message);
  }

  console.info("ACCOUNT_DISABLED", { userId, reason });
}
