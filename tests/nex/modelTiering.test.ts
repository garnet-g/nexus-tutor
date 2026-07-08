import { describe, expect, it } from "vitest";

import { selectModelTier } from "@/lib/nex/modelTiering";

describe("selectModelTier", () => {
  it("uses the lite tier for short explain-mode turns", () => {
    expect(selectModelTier("explain", "What is a fraction?")).toBe("lite");
  });

  it("uses the lite tier for short revision-mode turns", () => {
    expect(selectModelTier("revision", "Summarise algebra basics")).toBe("lite");
  });

  it("uses the standard tier for homework mode regardless of length", () => {
    expect(selectModelTier("homework", "help")).toBe("standard");
  });

  it("uses the standard tier for practice mode regardless of length", () => {
    expect(selectModelTier("practice", "quiz me")).toBe("standard");
  });

  it("uses the standard tier for assessment mode regardless of length", () => {
    expect(selectModelTier("assessment", "start")).toBe("standard");
  });

  it("escalates explain mode to standard tier for long messages", () => {
    const longMessage = "Explain ".repeat(40);
    expect(selectModelTier("explain", longMessage)).toBe("standard");
  });
});
