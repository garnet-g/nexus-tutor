#!/usr/bin/env tsx
/**
 * Print milestone agent pipeline status from STATUS.md and phase folders.
 */
import { existsSync, readdirSync, readFileSync } from "fs";
import { join } from "path";

const ROOT = join(import.meta.dirname, "..");
const milestone = process.argv[2] ?? "v2-tier-1";
const base = join(ROOT, ".planning", "milestones", milestone);

if (!existsSync(base)) {
  console.error(`Milestone not found: ${milestone}`);
  process.exit(1);
}

const statusPath = join(base, "STATUS.md");
if (existsSync(statusPath)) {
  console.log(readFileSync(statusPath, "utf-8"));
} else {
  console.log(`No STATUS.md for ${milestone}`);
}

const phasesDir = join(base, "phases");
if (existsSync(phasesDir)) {
  console.log("\n## Phase artifacts\n");
  for (const phase of readdirSync(phasesDir)) {
    const dir = join(phasesDir, phase);
    const changelog = join(dir, "CODER-CHANGELOG.md");
    const qa = join(dir, "QA-REPORT.md");
    console.log(
      `- ${phase}: changelog=${existsSync(changelog) ? "yes" : "no"}, qa=${existsSync(qa) ? "yes" : "no"}`,
    );
  }
}
