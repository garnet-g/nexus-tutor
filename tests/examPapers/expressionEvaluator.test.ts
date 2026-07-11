import { describe, expect, it } from "vitest";

import { evaluateExpression } from "@/lib/examPapers/expressionEvaluator";

describe("expressionEvaluator", () => {
  it("evaluates basic arithmetic with operator precedence", () => {
    expect(evaluateExpression("2 + 3 * 4", {})).toBe(14);
    expect(evaluateExpression("(2 + 3) * 4", {})).toBe(20);
    expect(evaluateExpression("10 / 2 - 1", {})).toBe(4);
  });

  it("evaluates exponentiation", () => {
    expect(evaluateExpression("2 ^ 3", {})).toBe(8);
    expect(evaluateExpression("2 ^ 3 ^ 2", {})).toBe(512); // right-associative: 2^(3^2)
  });

  it("substitutes params", () => {
    expect(evaluateExpression("180 - 2 * angle", { angle: 50 })).toBe(80);
  });

  it("supports unary minus", () => {
    expect(evaluateExpression("-angle + 10", { angle: 3 })).toBe(7);
    expect(evaluateExpression("-(2 + 3)", {})).toBe(-5);
  });

  it("supports whitelisted functions", () => {
    expect(evaluateExpression("sqrt(16)", {})).toBe(4);
    expect(evaluateExpression("abs(-5)", {})).toBe(5);
    expect(evaluateExpression("round(4.6)", {})).toBe(5);
    expect(evaluateExpression("min(3, 7)", {})).toBe(3);
    expect(evaluateExpression("max(3, 7)", {})).toBe(7);
  });

  it("supports the pi constant", () => {
    expect(evaluateExpression("pi", {})).toBeCloseTo(Math.PI);
  });

  it("throws on an unknown identifier", () => {
    expect(() => evaluateExpression("unknownVar + 1", {})).toThrow(/unknown identifier/i);
  });

  it("throws on an unknown function", () => {
    expect(() => evaluateExpression("notAFunction(1)", {})).toThrow(/unknown function/i);
  });

  it("throws on division by zero", () => {
    expect(() => evaluateExpression("1 / 0", {})).toThrow();
  });

  it("throws on malformed expressions", () => {
    expect(() => evaluateExpression("2 +", {})).toThrow();
    expect(() => evaluateExpression("2 3", {})).toThrow();
    expect(() => evaluateExpression("(2 + 3", {})).toThrow();
  });

  it("throws on unexpected characters (no eval/Function escape hatch)", () => {
    expect(() => evaluateExpression("process.exit()", {})).toThrow();
    expect(() => evaluateExpression("`${1}`", {})).toThrow();
  });
});
