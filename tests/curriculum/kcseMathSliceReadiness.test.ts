import { describe, expect, it } from "vitest";

import { getTopicReadinessLabel } from "@/lib/curriculum/contentModel";

describe("KCSE math slice readiness bar", () => {
  it("a topic with full lessons and ≥7 per band is PROD_READY", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 9,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 7, medium: 7, hard: 7 },
      }),
    ).toBe("PROD_READY");
  });

  it("missing a subtopic lesson is not PROD_READY", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 9,
        subtopicCount: 3,
        subtopicsWithLesson: 2,
        questionCounts: { easy: 7, medium: 7, hard: 7 },
      }),
    ).not.toBe("PROD_READY");
  });
});
