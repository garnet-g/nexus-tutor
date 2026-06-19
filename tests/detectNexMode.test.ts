import { describe, expect, it } from "vitest";

import {
  ASSESSMENT_PATTERNS,
  detectNexMode,
  isAssessmentRequest,
} from "@/lib/nex/detectNexMode";

describe("detectNexMode assessment", () => {
  it("detects assessment intent from specification patterns", () => {
    expect(detectNexMode("Assess me on fractions")).toBe("assessment");
    expect(detectNexMode("Test my understanding of algebra")).toBe("assessment");
    expect(detectNexMode("Quick check on geometry")).toBe("assessment");
  });

  it("exports assessment patterns for documentation parity", () => {
    expect(ASSESSMENT_PATTERNS.length).toBeGreaterThanOrEqual(4);
    expect(isAssessmentRequest("Check my understanding of ratios")).toBe(true);
  });

  it("keeps assessment mode when already in assessment session", () => {
    expect(detectNexMode("My answer is 3/4", "assessment")).toBe("assessment");
  });

  it("does not confuse practice quiz phrasing with assessment", () => {
    expect(detectNexMode("Quiz me on algebra")).toBe("practice");
  });
});
