import { describe, expect, it } from "vitest";

import { findUnderTargetProdReadyTopics } from "@/server/services/topicCoverageMatrixService";

describe("topic coverage matrix", () => {
  it("flags prod-ready labels that do not meet DEC-002 thresholds", () => {
    const underTarget = findUnderTargetProdReadyTopics([
      {
        curriculumCode: "kcse",
        subjectCode: "mathematics",
        gradeLevel: "Form 2",
        topicId: "topic-1",
        topicTitle: "Fractions",
        publishedLessonCount: 3,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 5, medium: 0, hard: 0 },
        readinessLabel: "PROD_READY",
      },
    ]);

    expect(underTarget).toHaveLength(1);
  });
});
