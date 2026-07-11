import { describe, expect, it } from "vitest";

import { nexChatRequestSchema } from "@/schemas/nexSchemas";

describe("nexChatRequestSchema", () => {
  it("accepts the first chat payload sent before a Nex session exists", () => {
    const result = nexChatRequestSchema.safeParse({
      nexSessionId: null,
      studentMessage: "Explain fractions like I'm in Form 1",
      sessionMode: "explain",
      topicId: null,
    });

    expect(result.success).toBe(true);
  });

  it("accepts optional workflowContext without requiring it", () => {
    const without = nexChatRequestSchema.safeParse({
      studentMessage: "Help me with this",
    });
    expect(without.success).toBe(true);

    const withContext = nexChatRequestSchema.safeParse({
      studentMessage: "Help me with this",
      workflowContext: {
        version: 1,
        source: "lesson",
        label: "Fractions",
        allowedActions: ["explain"],
        protectedAssessment: false,
      },
    });
    expect(withContext.success).toBe(true);
  });

  it("rejects workflowContext with unknown keys", () => {
    const result = nexChatRequestSchema.safeParse({
      studentMessage: "Help me with this",
      workflowContext: {
        version: 1,
        source: "practice",
        label: "Practice",
        allowedActions: ["hint"],
        protectedAssessment: false,
        answerKey: "B",
      },
    });

    expect(result.success).toBe(false);
  });
});
