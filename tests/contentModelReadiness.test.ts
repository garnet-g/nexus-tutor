import { describe, expect, it } from "vitest";

import {
  getTopicReadinessLabel,
  isTopicLearnReady,
  isTopicPracticeReady,
} from "@/lib/curriculum/contentModel";

describe("topic readiness predicates", () => {
  it("requires every subtopic to have a published lesson for learn-ready", () => {
    expect(isTopicLearnReady(3, 3, 2)).toBe(false);
    expect(isTopicLearnReady(3, 3, 3)).toBe(true);
    expect(isTopicLearnReady(2, 3, 3)).toBe(false);
  });

  it("requires at least one difficulty to meet practice minimum", () => {
    expect(isTopicPracticeReady({ easy: 4, medium: 0, hard: 0 })).toBe(false);
    expect(isTopicPracticeReady({ easy: 5, medium: 0, hard: 0 })).toBe(true);
    expect(isTopicPracticeReady({ easy: 0, medium: 0, hard: 0 })).toBe(false);
  });

  it("labels prod-ready only when learn and practice gates pass", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 3,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 5, medium: 0, hard: 0 },
      }),
    ).toBe("PROD_READY");

    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 3,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 0, medium: 0, hard: 0 },
      }),
    ).toBe("LEARN_READY");
  });
});
