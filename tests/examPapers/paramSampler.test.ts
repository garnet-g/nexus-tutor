import { describe, expect, it } from "vitest";

import { mulberry32, sampleParams, type TemplateParamDef } from "@/lib/examPapers/paramSampler";

describe("paramSampler", () => {
  it("produces a deterministic sequence for a given seed", () => {
    const a = mulberry32(42);
    const b = mulberry32(42);
    const sequenceA = [a(), a(), a()];
    const sequenceB = [b(), b(), b()];
    expect(sequenceA).toEqual(sequenceB);
  });

  it("produces values in [0, 1)", () => {
    const rng = mulberry32(7);
    for (let i = 0; i < 50; i += 1) {
      const value = rng();
      expect(value).toBeGreaterThanOrEqual(0);
      expect(value).toBeLessThan(1);
    }
  });

  it("samples integers within min/max inclusive", () => {
    const rng = mulberry32(1);
    const defs: TemplateParamDef[] = [{ name: "angle", min: 20, max: 70 }];
    for (let i = 0; i < 100; i += 1) {
      const params = sampleParams(defs, rng);
      expect(params.angle).toBeGreaterThanOrEqual(20);
      expect(params.angle).toBeLessThanOrEqual(70);
      expect(Number.isInteger(params.angle)).toBe(true);
    }
  });

  it("respects a step constraint", () => {
    const rng = mulberry32(3);
    const defs: TemplateParamDef[] = [{ name: "angle", min: 20, max: 70, step: 5 }];
    for (let i = 0; i < 100; i += 1) {
      const params = sampleParams(defs, rng);
      expect((params.angle - 20) % 5).toBe(0);
    }
  });

  it("samples multiple independent params", () => {
    const rng = mulberry32(9);
    const defs: TemplateParamDef[] = [
      { name: "a", min: 1, max: 5 },
      { name: "b", min: 10, max: 20 },
    ];
    const params = sampleParams(defs, rng);
    expect(Object.keys(params).sort()).toEqual(["a", "b"]);
  });

  it("throws on a non-positive step", () => {
    const rng = mulberry32(1);
    const defs: TemplateParamDef[] = [{ name: "angle", min: 20, max: 70, step: 0 }];
    expect(() => sampleParams(defs, rng)).toThrow();
  });

  it("throws on an empty range", () => {
    const rng = mulberry32(1);
    const defs: TemplateParamDef[] = [{ name: "angle", min: 70, max: 20 }];
    expect(() => sampleParams(defs, rng)).toThrow();
  });
});
