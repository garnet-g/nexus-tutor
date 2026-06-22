import { describe, expect, it } from "vitest";

import { assemblePrompt } from "@/lib/nex/assemblePrompt";
import { validateNexResponse } from "@/lib/nex/validateNexResponse";

describe("Nex subject scope — tier 2", () => {
  it("does not flag Kiswahili teaching as out-of-scope decline", () => {
    const result = validateNexResponse({
      mode: "explain",
      response: "Hebu tuzungumze kuhusu sarufi ya Kiswahili.",
      studentMessage: "Nisaidie kwa Kiswahili",
      attemptCount: 0,
      hintLevel: 1,
    });

    expect(result.status).toBe("pass");
  });

  it("still recognizes history decline responses", () => {
    const result = validateNexResponse({
      mode: "explain",
      response: "I can teach mathematics, but history is outside Nexus scope.",
      studentMessage: "Teach me history",
      attemptCount: 0,
      hintLevel: 1,
    });

    expect(result.status).toBe("pass");
  });

  it("includes Kiswahili and Chemistry in assembled base scope", () => {
    const prompt = assemblePrompt({
      mode: "explain",
      recentMessages: [],
      curriculumContext: {
        subject: "Kiswahili",
        subjectCode: "kiswahili",
        topic: "Sarufi",
        subtopic: "Viwakilishi",
        learningOutcome: null,
        lessonExcerpts: "",
      },
    });

    expect(prompt.systemPrompt).toContain("Kiswahili");
    expect(prompt.systemPrompt).toContain("Chemistry");
    expect(prompt.systemPrompt).toContain("usimwandikie insha nzima");
  });
});
