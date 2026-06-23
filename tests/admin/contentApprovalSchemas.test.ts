import { describe, expect, it } from "vitest";

import {
  contentReviewActionSchema,
  restoreLessonVersionRequestSchema,
} from "@/schemas/contentApprovalSchemas";

describe("contentApprovalSchemas", () => {
  it("accepts review actions for lessons and questions", () => {
    const parsed = contentReviewActionSchema.parse({
      kind: "lesson",
      id: "00000000-0000-4000-8000-000000000101",
      notes: "Add a worked example.",
    });

    expect(parsed.kind).toBe("lesson");
    expect(parsed.notes).toBe("Add a worked example.");
  });

  it("rejects invalid restore payloads", () => {
    const result = restoreLessonVersionRequestSchema.safeParse({
      lessonId: "not-a-uuid",
      versionId: "00000000-0000-4000-8000-000000000202",
    });

    expect(result.success).toBe(false);
  });
});
