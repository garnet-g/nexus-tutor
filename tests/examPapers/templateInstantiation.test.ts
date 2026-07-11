import { describe, expect, it } from "vitest";

import { instantiateTemplate, type ExamPaperTemplateBody } from "@/lib/examPapers/templateInstantiation";
import { mulberry32 } from "@/lib/examPapers/paramSampler";

const isoscelesTemplate: ExamPaperTemplateBody = {
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
  markScheme: [
    { code: "M1", text: "Base angles equal: {angle} degrees each" },
    { code: "A1", text: "180 - 2 x {angle} = {answer_a}" },
  ],
};

describe("templateInstantiation", () => {
  it("substitutes sampled params into the stem", () => {
    const rng = mulberry32(1);
    const result = instantiateTemplate(isoscelesTemplate, rng);
    expect(result.renderedStem).toContain(`angle ABC = ${result.params.angle} degrees`);
  });

  it("computes a numeric part answer from the sampled params", () => {
    const rng = mulberry32(1);
    const result = instantiateTemplate(isoscelesTemplate, rng);
    const expected = 180 - 2 * result.params.angle;
    expect(result.parts[0].computedAnswer).toBe(String(expected));
  });

  it("interpolates the computed answer into the mark scheme", () => {
    const rng = mulberry32(2);
    const result = instantiateTemplate(isoscelesTemplate, rng);
    const expected = 180 - 2 * result.params.angle;
    const finalStep = result.markScheme.find((step) => step.code === "A1");
    expect(finalStep?.text).toContain(String(expected));
  });

  it("passes through a short_answer part verbatim", () => {
    const template: ExamPaperTemplateBody = {
      params: [],
      stem: "State the SI unit of length.",
      parts: [{ label: "a", prompt: "State the unit.", marks: 1, answerType: "short_answer", answerText: "metre" }],
      markScheme: [{ code: "B1", text: "metre" }],
    };
    const result = instantiateTemplate(template, mulberry32(1));
    expect(result.parts[0].computedAnswer).toBe("metre");
  });

  it("produces different params across seeds", () => {
    const resultA = instantiateTemplate(isoscelesTemplate, mulberry32(1));
    const resultB = instantiateTemplate(isoscelesTemplate, mulberry32(999));
    const anyDifferent = resultA.params.angle !== resultB.params.angle;
    expect(anyDifferent).toBe(true);
  });

  it("throws when a numeric part is missing answerExpr", () => {
    const template: ExamPaperTemplateBody = {
      params: [],
      stem: "x",
      parts: [{ label: "a", prompt: "x", marks: 1, answerType: "numeric" }],
      markScheme: [],
    };
    expect(() => instantiateTemplate(template, mulberry32(1))).toThrow(/answerExpr/);
  });

  it("throws when the stem references an undefined value", () => {
    const template: ExamPaperTemplateBody = {
      params: [],
      stem: "Value is {missing}.",
      parts: [],
      markScheme: [],
    };
    expect(() => instantiateTemplate(template, mulberry32(1))).toThrow(/undefined value/);
  });
});
