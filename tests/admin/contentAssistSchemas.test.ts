import { describe, expect, it } from "vitest";

import { contentAssistRequestSchema } from "@/schemas/contentAssistSchemas";

describe("contentAssistSchemas", () => {
  it("accepts draft lesson assist requests", () => {
    const parsed = contentAssistRequestSchema.parse({
      action: "draft_lesson",
      subtopicId: "00000000-0000-4000-8000-000000000301",
      curriculum: "KCSE",
      gradeLevel: "Form 2",
    });

    expect(parsed.action).toBe("draft_lesson");
  });

  it("accepts generate questions assist requests", () => {
    const parsed = contentAssistRequestSchema.parse({
      action: "generate_questions",
      topicId: "00000000-0000-4000-8000-000000000401",
      curriculum: "CBC",
      gradeLevel: "Grade 7",
      difficulty: "medium",
      count: 3,
    });

    expect(parsed.action).toBe("generate_questions");
    if (parsed.action === "generate_questions") {
      expect(parsed.count).toBe(3);
    }
  });
});
