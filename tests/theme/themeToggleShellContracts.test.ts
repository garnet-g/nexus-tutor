import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const root = process.cwd();

function readWorkspaceFile(path: string) {
  return readFileSync(join(root, path), "utf8");
}

describe("theme toggle shell coverage", () => {
  it("keeps the root localStorage theme bootstrap in place", () => {
    const source = readWorkspaceFile("src/app/layout.tsx");
    expect(source).toContain("nexus-theme");
    expect(source).toContain("document.documentElement.classList.add(\"dark\")");
  });

  it("exposes ThemeToggle from public, parent, student, and admin shells", () => {
    const shellFiles = [
      "src/features/marketing/components/PublicShell.tsx",
      "src/app/(parent)/layout.tsx",
      "src/components/student/StudentAppShell.tsx",
      "src/app/(super-admin)/layout.tsx",
    ];

    for (const file of shellFiles) {
      const source = readWorkspaceFile(file);
      expect(source, `${file} should import ThemeToggle`).toContain("ThemeToggle");
      expect(source, `${file} should render ThemeToggle`).toContain("<ThemeToggle");
    }
  });
});
