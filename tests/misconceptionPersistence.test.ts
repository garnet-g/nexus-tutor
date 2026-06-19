import { describe, expect, it } from "vitest";

import { mergeCommonErrors, MAX_COMMON_ERRORS } from "@/lib/nex/misconceptionPersistence";

describe("misconceptionPersistence", () => {
  it("deduplicates common errors case-insensitively", () => {
    const merged = mergeCommonErrors(
      ["Adds fractions incorrectly"],
      "adds fractions incorrectly",
    );

    expect(merged).toHaveLength(1);
  });

  it("appends new misconceptions and caps the list", () => {
    const initial = Array.from({ length: MAX_COMMON_ERRORS }, (_, index) => `error-${index}`);
    const merged = mergeCommonErrors(initial, "New misconception pattern");

    expect(merged).toHaveLength(MAX_COMMON_ERRORS);
    expect(merged.at(-1)).toBe("New misconception pattern");
    expect(merged[0]).toBe("error-1");
  });
});
