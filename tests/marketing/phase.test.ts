import { describe, expect, it } from "vitest";

import { phase } from "@/app/(public)/_landing/phase";

describe("phase", () => {
  it("is 0 before the window opens", () => {
    expect(phase(0.1, 0.2, 0.5)).toBe(0);
  });

  it("is 1 after the window closes", () => {
    expect(phase(0.9, 0.2, 0.5)).toBe(1);
  });

  it("is linear inside the window", () => {
    expect(phase(0.35, 0.2, 0.5)).toBeCloseTo(0.5);
  });

  it("clamps exactly at the bounds", () => {
    expect(phase(0.2, 0.2, 0.5)).toBe(0);
    expect(phase(0.5, 0.2, 0.5)).toBe(1);
  });

  it("treats a degenerate window as a step", () => {
    expect(phase(0.3, 0.4, 0.4)).toBe(0);
    expect(phase(0.5, 0.4, 0.4)).toBe(1);
  });
});
