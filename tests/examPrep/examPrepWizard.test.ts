import { describe, expect, it } from "vitest";

import { buildGeneratePayload } from "@/features/examPrep/components/ExamPrepWizard";

describe("buildGeneratePayload", () => {
  const topics = [
    { id: "topic-1", code: "alg", title: "Algebra", description: null, sortOrder: 1, subjectId: "sub-1", lessonCount: 1 },
  ];

  it("includes subjectCode for mathematics KCSE style", () => {
    expect(
      buildGeneratePayload({
        examStyle: "kcse_style",
        subjectCode: "mathematics",
        topicId: "topic-1",
        topics,
      }),
    ).toEqual({
      examStyle: "kcse_style",
      subjectCode: "mathematics",
    });
  });

  it("includes topicId for topic_specific mathematics", () => {
    expect(
      buildGeneratePayload({
        examStyle: "topic_specific",
        subjectCode: "mathematics",
        topicId: "topic-1",
        topics,
      }),
    ).toEqual({
      examStyle: "topic_specific",
      subjectCode: "mathematics",
      topicId: "topic-1",
    });
  });

  it("includes topicId for non-mathematics subjects", () => {
    expect(
      buildGeneratePayload({
        examStyle: "cbc_style",
        subjectCode: "science",
        topicId: "topic-1",
        topics,
      }),
    ).toEqual({
      examStyle: "cbc_style",
      subjectCode: "science",
      topicId: "topic-1",
    });
  });
});
