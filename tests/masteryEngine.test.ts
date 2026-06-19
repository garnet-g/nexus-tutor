import { describe, expect, it } from "vitest";

import {
  averageTopicMastery,
  clampMastery,
  computeMasteryUpdates,
  getMasteryBand,
  identifyWeakTopics,
  seedMasteryFromDiagnostic,
  updateMasteryFromPractice,
} from "@/lib/mastery/masteryEngine";

describe("masteryEngine", () => {
  it("clamps mastery between 0 and 100", () => {
    expect(clampMastery(-5)).toBe(0);
    expect(clampMastery(150)).toBe(100);
    expect(clampMastery(67.4)).toBe(67);
  });

  it("seeds diagnostic mastery directly", () => {
    expect(seedMasteryFromDiagnostic(63)).toBe(63);
  });

  it("updates mastery using the 70/30 practice blend", () => {
    expect(updateMasteryFromPractice(60, 100)).toBe(72);
    expect(updateMasteryFromPractice(80, 40)).toBe(68);
  });

  it("returns mastery band labels", () => {
    expect(getMasteryBand(25)).toBe("needs_work");
    expect(getMasteryBand(55)).toBe("developing");
    expect(getMasteryBand(75)).toBe("strong");
    expect(getMasteryBand(95)).toBe("mastered");
  });

  it("computes mastery updates for practice topics", () => {
    const updates = computeMasteryUpdates(
      [{ topicId: "algebra", correct: 7, total: 10 }],
      { algebra: 60 },
    );

    expect(updates).toEqual([
      {
        topicId: "algebra",
        previousMastery: 60,
        masteryPercentage: 63,
      },
    ]);
  });

  it("identifies weak topics by mastery and diagnostic list", () => {
    const weakTopics = identifyWeakTopics(
      [
        { topicId: "algebra", masteryPercentage: 42 },
        { topicId: "geometry", masteryPercentage: 78 },
        { topicId: "fractions", masteryPercentage: 45 },
      ],
      ["geometry"],
      3,
    );

    expect(weakTopics.map((topic) => topic.topicId)).toEqual([
      "algebra",
      "fractions",
      "geometry",
    ]);
  });

  it("averages topic mastery", () => {
    expect(
      averageTopicMastery([
        { topicId: "a", masteryPercentage: 60 },
        { topicId: "b", masteryPercentage: 80 },
      ]),
    ).toBe(70);
  });
});
