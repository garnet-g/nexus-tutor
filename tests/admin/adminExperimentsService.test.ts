import { describe, expect, it } from "vitest";

import { pickDeterministicVariant } from "@/server/services/adminExperimentsService";

describe("adminExperimentsService", () => {
  it("assigns deterministic variants for the same subject", () => {
    const first = pickDeterministicVariant("onboarding_copy", "student-1", [
      "control",
      "variant_a",
    ]);
    const second = pickDeterministicVariant("onboarding_copy", "student-1", [
      "control",
      "variant_a",
    ]);
    expect(first).toBe(second);
  });
});
