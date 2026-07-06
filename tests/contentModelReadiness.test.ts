import { describe, expect, it } from "vitest";

import {
  getTopicReadinessLabel,
  isTopicLearnReady,
  isTopicProdReady,
  isTopicSessionStartable,
} from "@/lib/curriculum/contentModel";

describe("topic readiness predicates (DEC-002)", () => {
  it("requires every subtopic to have a published lesson for learn-ready", () => {
    expect(isTopicLearnReady(3, 3, 2)).toBe(false);
    expect(isTopicLearnReady(3, 3, 3)).toBe(true);
    expect(isTopicLearnReady(2, 3, 3)).toBe(false);
  });

  it("session-startable requires at least one difficulty to meet the 5-question minimum", () => {
    expect(isTopicSessionStartable({ easy: 4, medium: 0, hard: 0 })).toBe(false);
    expect(isTopicSessionStartable({ easy: 5, medium: 0, hard: 0 })).toBe(true);
    expect(isTopicSessionStartable({ easy: 0, medium: 0, hard: 0 })).toBe(false);
  });

  it("prod-ready requires at least seven questions in every band", () => {
    expect(isTopicProdReady({ easy: 7, medium: 7, hard: 6 })).toBe(false);
    expect(isTopicProdReady({ easy: 7, medium: 7, hard: 7 })).toBe(true);
  });

  it("labels prod-ready only when learn and 21-question production bar pass", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 3,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 5, medium: 0, hard: 0 },
      }),
    ).toBe("PRACTICE_READY");

    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 3,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 7, medium: 7, hard: 7 },
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
