import { readdirSync, readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const landingDir = join(process.cwd(), "src/app/(public)/_landing");
const source = [
  readFileSync(join(process.cwd(), "src/app/(public)/page.tsx"), "utf8"),
  ...readdirSync(landingDir)
    .filter((file) => file.endsWith(".tsx"))
    .map((file) => readFileSync(join(landingDir, file), "utf8")),
].join("\n");

describe("public landing page positioning", () => {
  it("positions Nexus as a student-voiced AI tutor for KCSE exam prep", () => {
    expect(source).toContain("Your AI tutor for KCSE");
    expect(source).toContain("Form 1");
    expect(source).toContain("Form 4");
    expect(source).toContain("mock");
    expect(source).toContain("Topics still costing you marks");
  });

  it("bans internal jargon on the public page", () => {
    expect(source).not.toContain("Socratic");
    expect(source).not.toContain("control room");
    expect(source).not.toContain("weak-topic");
    expect(source).not.toContain("mastery");
  });

  it("keeps the public page away from generic three-card marketing structure", () => {
    expect(source).not.toContain("PILLARS.map");
    expect(source).not.toContain("md:grid-cols-3");
    expect(source).not.toContain("One companion, from your first question");
  });
});
