#!/usr/bin/env tsx
/**
 * Apply Phase 1 skeleton SQL to a Postgres database (additive only).
 * Requires DATABASE_URL (Supabase → Project Settings → Database → Connection string).
 *
 * Usage:
 *   DATABASE_URL="postgresql://..." npx tsx --tsconfig tsconfig.scripts.json scripts/applySkeletonSeeds.ts
 */
import { readFileSync, existsSync } from "fs";
import { join } from "path";
import { spawnSync } from "child_process";

const ROOT = join(import.meta.dirname, "..");

const SQL_FILES = [
  "supabase/migrations/20250615150000_science_english_subjects.sql",
  "supabase/seed/curriculum_math_kcse.sql",
  "supabase/seed/curriculum_english_kcse.sql",
];

async function main() {
  const databaseUrl = process.env.DATABASE_URL?.trim();
  if (!databaseUrl) {
    throw new Error(
      "Set DATABASE_URL to your Supabase Postgres connection string (Settings → Database).",
    );
  }

  const runner = `
import postgres from "postgres";
import { readFileSync } from "fs";
const sql = postgres(process.env.DATABASE_URL, { max: 1 });
const files = ${JSON.stringify(SQL_FILES)};
for (const file of files) {
  const path = ${JSON.stringify(ROOT)} + "/" + file;
  const body = readFileSync(path, "utf-8");
  console.log("Applying", file, "...");
  await sql.unsafe(body);
  console.log("  OK");
}
await sql.end();
`;

  const result = spawnSync(
    "npx",
    ["--yes", "-p", "postgres", "tsx", "-e", runner],
    {
      env: { ...process.env, DATABASE_URL: databaseUrl },
      stdio: "inherit",
      shell: true,
    },
  );

  if (result.status !== 0) {
    process.exit(result.status ?? 1);
  }

  console.log("\nSkeleton seeds applied. Re-run: npm run content:generate-drafts -- --dry-run");
}

main().catch((error) => {
  console.error(error instanceof Error ? error.message : error);
  process.exit(1);
});
