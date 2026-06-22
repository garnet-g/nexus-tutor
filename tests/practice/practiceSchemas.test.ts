import { describe, expect, it } from "vitest";

import { practiceStartSchema } from "@/schemas/practiceSchemas";

const TOPIC_ID = "11111111-1111-4111-8111-111111111111";
const SUBTOPIC_ID = "22222222-2222-4222-8222-222222222222";

describe("practiceStartSchema", () => {
  it("accepts a valid body without subtopicId", () => {
    const parsed = practiceStartSchema.safeParse({
      topicId: TOPIC_ID,
      difficulty: "medium",
      questionCount: 10,
    });

    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.subtopicId).toBeUndefined();
    }
  });

  it("accepts optional valid subtopicId", () => {
    const parsed = practiceStartSchema.safeParse({
      topicId: TOPIC_ID,
      subtopicId: SUBTOPIC_ID,
      difficulty: "easy",
      questionCount: 5,
    });

    expect(parsed.success).toBe(true);
    if (parsed.success) {
      expect(parsed.data.subtopicId).toBe(SUBTOPIC_ID);
    }
  });

  it("rejects invalid subtopicId", () => {
    const parsed = practiceStartSchema.safeParse({
      topicId: TOPIC_ID,
      subtopicId: "not-a-uuid",
      difficulty: "hard",
    });

    expect(parsed.success).toBe(false);
  });
});
