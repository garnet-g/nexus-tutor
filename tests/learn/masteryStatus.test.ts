import { describe, expect, it } from "vitest";

import {
  averageMastery,
  formatStrandLabel,
  getTopicMasteryStatus,
} from "@/lib/learn/masteryStatus";

describe("masteryStatus", () => {
  it("classifies mastery thresholds", () => {
    expect(getTopicMasteryStatus(null)).toBe("not_started");
    expect(getTopicMasteryStatus(0)).toBe("not_started");
    expect(getTopicMasteryStatus(42)).toBe("in_progress");
    expect(getTopicMasteryStatus(70)).toBe("mastered");
  });

  it("formats strand labels from topic codes", () => {
    expect(formatStrandLabel("linear_equations")).toBe("Linear Equations");
  });

  it("averages mastery across topics", () => {
    expect(
      averageMastery(
        { a: 50, b: 100 },
        ["a", "b"],
      ),
    ).toBe(75);
  });
});
