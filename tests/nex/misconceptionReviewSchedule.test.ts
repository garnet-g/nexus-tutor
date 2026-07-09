import { describe, expect, it } from "vitest";

import { nextReviewIntervalDays } from "@/server/services/misconceptionService";

describe("nextReviewIntervalDays", () => {
  it("follows a 2, 4, 7, 14-day spaced schedule and holds at 14 after that", () => {
    expect(nextReviewIntervalDays(0)).toBe(2);
    expect(nextReviewIntervalDays(1)).toBe(4);
    expect(nextReviewIntervalDays(2)).toBe(7);
    expect(nextReviewIntervalDays(3)).toBe(14);
    expect(nextReviewIntervalDays(4)).toBe(14);
    expect(nextReviewIntervalDays(10)).toBe(14);
  });
});
