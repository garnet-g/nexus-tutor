import { describe, expect, it } from "vitest";

import { formatStudentQuestionText } from "@/lib/content/questionText";

describe("formatStudentQuestionText", () => {
  it("removes generated KCSE practice title prefixes from student question text", () => {
    expect(formatStudentQuestionText("KCSE algebra practice 1: Solve x + 3 = 9.")).toBe(
      "Solve x + 3 = 9.",
    );
  });

  it("leaves normal question text unchanged", () => {
    expect(formatStudentQuestionText("Solve x + 3 = 9.")).toBe("Solve x + 3 = 9.");
  });
});
