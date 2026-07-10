import { describe, expect, it } from "vitest";
import { readFileSync, readdirSync, statSync } from "node:fs";
import { extname, join } from "node:path";

const ROOT = join(import.meta.dirname, "..", "..");
const TARGET_DIRS = [
  join(ROOT, "src", "app", "(student)", "exam-prep"),
  join(ROOT, "src", "app", "(student)", "exam-papers"),
  join(ROOT, "src", "features", "examPapers"),
];

const BANNED_PATTERNS = [
  /past[- ]paper/i,
  /official past/i,
  /licensed past/i,
];

function walk(dir: string, files: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      walk(full, files);
    } else if ([".ts", ".tsx", ".mdx"].includes(extname(entry))) {
      files.push(full);
    }
  }
  return files;
}

describe("PR-106 exam paper copy audit (DEC-007)", () => {
  it("does not claim licensed or official past papers in student-facing exam surfaces", () => {
    const violations: string[] = [];

    for (const dir of TARGET_DIRS) {
      for (const file of walk(dir)) {
        const content = readFileSync(file, "utf8");
        for (const pattern of BANNED_PATTERNS) {
          if (pattern.test(content)) {
            violations.push(`${file}: ${pattern}`);
          }
        }
      }
    }

    expect(violations).toEqual([]);
  });
});
