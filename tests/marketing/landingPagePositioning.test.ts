import { readFileSync } from "node:fs";
import { join } from "node:path";
import { describe, expect, it } from "vitest";

const landingPageSource = readFileSync(
  join(process.cwd(), "src/app/(public)/page.tsx"),
  "utf8",
);

describe("public landing page positioning", () => {
  it("opens with an AI revision control room for Form 1-Form 4 exam prep", () => {
    expect(landingPageSource).toContain("AI revision control room");
    expect(landingPageSource).toContain("Form 1");
    expect(landingPageSource).toContain("Form 4");
    expect(landingPageSource).toContain("mock exam");
    expect(landingPageSource).toContain("weak-topic");
  });

  it("keeps the public page away from generic three-card marketing structure", () => {
    expect(landingPageSource).not.toContain("PILLARS.map");
    expect(landingPageSource).not.toContain("md:grid-cols-3");
    expect(landingPageSource).not.toContain("One companion, from your first question");
  });
});
