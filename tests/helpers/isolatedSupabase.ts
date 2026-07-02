import { afterAll, describe } from "vitest";

import { createAdminClient } from "@/lib/supabase/admin";

const LOCAL_DATABASE_HOSTS = new Set(["127.0.0.1", "localhost", "::1"]);

export function isIsolatedTestDatabase(): boolean {
  const rawUrl = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  if (!rawUrl) return false;

  try {
    return LOCAL_DATABASE_HOSTS.has(new URL(rawUrl).hostname);
  } catch {
    return false;
  }
}

export function assertIsolatedTestDatabase(): void {
  if (!isIsolatedTestDatabase()) {
    throw new Error(
      "Refusing to mutate a non-local Supabase project from the test suite. " +
        "Start the local Supabase stack and use its localhost URL.",
    );
  }
}

export const describeIfIsolatedTestDatabase = isIsolatedTestDatabase()
  ? describe
  : describe.skip;

export function registerTestUserCleanup(userIds: string[]): void {
  afterAll(async () => {
    if (userIds.length === 0) return;

    assertIsolatedTestDatabase();
    const admin = createAdminClient();
    for (const userId of userIds) {
      const { error } = await admin.auth.admin.deleteUser(userId);
      if (error) {
        throw new Error(`Could not clean up test auth user ${userId}: ${error.message}`);
      }
    }
  });
}
