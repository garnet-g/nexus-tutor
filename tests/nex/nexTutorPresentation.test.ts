import { describe, expect, it } from "vitest";

import {
  formatNexAllowanceSummary,
  formatResumedSessionLabel,
  getFollowUpPromptsForMode,
  getModeHelperText,
  parseNexTeachingSections,
} from "@/features/nex/lib/nexTutorPresentation";

describe("nexTutorPresentation", () => {
  it("explains the selected mode in student-facing language", () => {
    expect(getModeHelperText("homework")).toContain("hints before answers");
    expect(getModeHelperText("practice")).toContain("one question at a time");
  });

  it("returns mode-specific follow-up prompts", () => {
    expect(getFollowUpPromptsForMode("practice")).toEqual([
      "Harder",
      "Easier",
      "Another question",
    ]);
    expect(getFollowUpPromptsForMode("homework")).toEqual([
      "Give me a hint",
      "Check my step",
      "What should I try next?",
    ]);
  });

  it("formats resumed session copy with Nairobi-day awareness", () => {
    const label = formatResumedSessionLabel(
      "homework",
      "2026-06-21T06:00:00.000Z",
      new Date("2026-06-21T15:00:00+03:00"),
    );

    expect(label).toBe("Continuing your Homework chat from today");
  });

  it("formats compact allowance copy after the chat starts", () => {
    expect(formatNexAllowanceSummary(7, 10, true)).toBe("3 messages left today");
    expect(formatNexAllowanceSummary(0, 10, false)).toBe(
      "10 of 10 free messages left today",
    );
  });

  it("parses Nex response sections into labelled teaching blocks", () => {
    expect(
      parseNexTeachingSections(
        [
          "1. CONCEPT",
          "A fraction is part of a whole.",
          "",
          "2. EXAMPLE",
          "1/2 means one out of two equal parts.",
        ].join("\n"),
      ),
    ).toEqual([
      {
        label: "Concept",
        content: "A fraction is part of a whole.",
      },
      {
        label: "Example",
        content: "1/2 means one out of two equal parts.",
      },
    ]);
  });
});

describe("getFollowUpPromptsForMode", () => {
  it("returns the static prompts when no topic title is given", () => {
    expect(getFollowUpPromptsForMode("explain")).toEqual([
      "Show another example",
      "Explain simpler",
      "Quiz me",
    ]);
  });

  it("replaces the last prompt with a topic-specific one when a topic title is given", () => {
    const prompts = getFollowUpPromptsForMode("explain", "Fractions");

    expect(prompts).toHaveLength(3);
    expect(prompts[0]).toBe("Show another example");
    expect(prompts[1]).toBe("Explain simpler");
    expect(prompts[2]).toBe("Quiz me on Fractions");
  });

  it("ignores a blank topic title", () => {
    expect(getFollowUpPromptsForMode("homework", "   ")).toEqual([
      "Give me a hint",
      "Check my step",
      "What should I try next?",
    ]);
  });
});
