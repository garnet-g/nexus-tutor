import { execSync } from "node:child_process";

const LOCAL_DATABASE_HOSTS = new Set(["127.0.0.1", "localhost", "::1"]);

function isLocalSupabase(): boolean {
  const rawUrl = process.env.NEXT_PUBLIC_SUPABASE_URL?.trim();
  if (!rawUrl) return false;

  try {
    return LOCAL_DATABASE_HOSTS.has(new URL(rawUrl).hostname);
  } catch {
    return false;
  }
}

export default async function globalSetup(): Promise<void> {
  process.env.E2E_STUDENT_EMAIL ??= "student@nexus.local";
  process.env.E2E_STUDENT_PASSWORD ??= "NexusDev1";
  process.env.E2E_PARENT_EMAIL ??= "parent@nexus.local";
  process.env.E2E_PARENT_PASSWORD ??= "NexusDev1";
  process.env.E2E_SUPPORT_EMAIL ??= "support@nexus.local";
  process.env.E2E_SUPPORT_PASSWORD ??= "NexusDev1";
  process.env.E2E_SUPER_ADMIN_EMAIL ??= "admin@nexus.local";
  process.env.E2E_SUPER_ADMIN_PASSWORD ??= "NexusDev1";

  if (!isLocalSupabase()) {
    return;
  }

  execSync("npx tsx scripts/seed-dev-users.ts", {
    stdio: "inherit",
    cwd: process.cwd(),
  });
}
