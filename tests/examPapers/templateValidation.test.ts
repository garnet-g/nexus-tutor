import { describe, expect, it } from "vitest";

import { validateTemplateBody } from "@/lib/examPapers/templateValidation";
import type { ExamPaperTemplateBody } from "@/lib/examPapers/templateInstantiation";

const validTemplate: ExamPaperTemplateBody = {
  params: [{ name: "angle", min: 20, max: 70, step: 5 }],
  stem: "In triangle ABC, AB = AC and angle ABC = {angle} degrees.",
  parts: [
    {
      label: "a",
      prompt: "Calculate angle BAC.",
      marks: 3,
      answerType: "numeric",
      answerExpr: "180 - 2 * angle",
      tolerance: 0,
    },
  ],
  markScheme: [{ code: "A1", text: "180 - 2 x {angle} = {answer_a}" }],
};

describe("validateTemplateBody", () => {
  it("passes a well-formed template across all fuzz samples", () => {
    const result = validateTemplateBody(validTemplate);
    expect(result.ok).toBe(true);
    expect(result.errors).toEqual([]);
  });

  it("flags a template with zero parts", () => {
    const result = validateTemplateBody({ ...validTemplate, parts: [] });
    expect(result.ok).toBe(false);
    expect(result.errors.some((e) => /at least one part/.test(e))).toBe(true);
  });

  it("flags a template whose expression fails for some sampled params (division by zero)", () => {
    const brokenTemplate: ExamPaperTemplateBody = {
      params: [{ name: "n", min: -2, max: 2 }],
      stem: "x",
      parts: [{ label: "a", prompt: "x", marks: 1, answerType: "numeric", answerExpr: "10 / n" }],
      markScheme: [],
    };
    const result = validateTemplateBody(brokenTemplate);
    expect(result.ok).toBe(false);
    expect(result.errors.length).toBeGreaterThan(0);
  });

  it("flags a template referencing an undefined interpolation value", () => {
    const brokenTemplate: ExamPaperTemplateBody = {
      params: [],
      stem: "Value is {missing}.",
      parts: [{ label: "a", prompt: "x", marks: 1, answerType: "short_answer", answerText: "x" }],
      markScheme: [],
    };
    const result = validateTemplateBody(brokenTemplate);
    expect(result.ok).toBe(false);
  });
});
