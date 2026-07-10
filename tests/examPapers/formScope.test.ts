import { describe, expect, it } from "vitest";

import { parseFormLevel } from "@/lib/examPapers/formScope";

describe("formScope", () => {
  it("parses a form number from common grade_level strings", () => {
    expect(parseFormLevel("Form 1")).toBe(1);
    expect(parseFormLevel("Form 2")).toBe(2);
    expect(parseFormLevel("form 3")).toBe(3);
    expect(parseFormLevel("Form  4")).toBe(4);
  });

  it("throws on an unparseable grade level", () => {
    expect(() => parseFormLevel("Grade 7")).toThrow();
  });
});
