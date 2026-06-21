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
});
