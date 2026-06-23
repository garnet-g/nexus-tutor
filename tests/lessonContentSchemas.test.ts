import { describe, expect, it } from "vitest";

import {
  lessonBlockSchema,
  lessonContentSchema,
  parseLessonContent,
} from "@/schemas/lessonContentSchemas";

const legacyLessonContent = {
  blocks: [
    { type: "heading", content: "Linear Equations" },
    {
      type: "paragraph",
      content: "A linear equation has one variable raised to the power of one.",
    },
    {
      type: "example",
      title: "Worked Example 1",
      steps: ["Write the equation", "Solve for x"],
      answer: "x = 4",
    },
    { type: "tip", content: "Balance both sides." },
  ],
};

const allBlockTypesFixture = {
  blocks: [
    { type: "heading", content: "Full block vocabulary" },
    { type: "paragraph", content: "Plain paragraph block." },
    {
      type: "rich_text",
      markdown: "Markdown with **bold** and $x^2$.",
    },
    {
      type: "image",
      url: "https://example.com/lesson.png",
      alt: "Diagram",
      caption: "A sample diagram",
    },
    {
      type: "table",
      rows: [
        ["x", "y"],
        ["1", "2"],
        ["2", "4"],
      ],
      caption: "Sample values",
    },
    {
      type: "math_block",
      latex: "E = mc^2",
      caption: "Mass-energy equivalence",
    },
    {
      type: "callout",
      variant: "info",
      content: "Remember to show your working.",
    },
    {
      type: "video_embed",
      provider: "youtube",
      url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
      title: "Revision clip",
    },
    { type: "divider" },
    {
      type: "question",
      questionText: "What is 2 + 2?",
      questionType: "multiple_choice",
      options: ["3", "4", "5"],
      correctAnswer: "4",
      explanation: "Two plus two equals four.",
    },
    {
      type: "file_attachment",
      url: "https://example.com/worksheet.pdf",
      name: "Worksheet.pdf",
    },
    {
      type: "chemical_equation",
      equation: "H_2 + O_2 -> H_2O",
      caption: "Water formation",
    },
    {
      type: "comprehension_passage",
      title: "Passage",
      passage: "Juma aliamka asubuhi na mapema.",
    },
    {
      type: "example",
      title: "Example",
      steps: ["Step one"],
      answer: "Done",
    },
    { type: "tip", content: "Practice daily." },
    {
      type: "callout",
      variant: "warning",
      content: "Check units.",
    },
    {
      type: "callout",
      variant: "key_point",
      content: "Core idea.",
    },
    {
      type: "question",
      questionText: "Solve x + 1 = 3",
      questionType: "short_answer",
      correctAnswer: "2",
    },
  ],
};

describe("lessonContentSchemas", () => {
  it("assigns ids to legacy blocks without id on read", () => {
    const parsed = parseLessonContent(legacyLessonContent);

    expect(parsed.blocks).toHaveLength(4);
    expect(parsed.blocks.every((block) => typeof block.id === "string")).toBe(true);
    expect(parsed.blocks.every((block) => block.id.length > 0)).toBe(true);
  });

  it("round-trips every block type through lessonContentSchema", () => {
    const parsed = lessonContentSchema.parse(allBlockTypesFixture);

    expect(parsed.blocks).toHaveLength(allBlockTypesFixture.blocks.length);
    expect(
      parsed.blocks.every((block) => lessonBlockSchema.safeParse(block).success),
    ).toBe(true);

    const serialized = JSON.parse(JSON.stringify(parsed));
    const reparsed = lessonContentSchema.parse(serialized);

    expect(reparsed.blocks.map((block) => block.type)).toEqual(
      parsed.blocks.map((block) => block.type),
    );
  });

  it("preserves existing block fields after id assignment", () => {
    const parsed = parseLessonContent(legacyLessonContent);
    const heading = parsed.blocks[0];

    expect(heading.type).toBe("heading");
    if (heading.type === "heading") {
      expect(heading.content).toBe("Linear Equations");
    }
  });

  it("rejects invalid inline question options", () => {
    const invalid = {
      blocks: [
        {
          type: "question",
          questionText: "Pick one",
          questionType: "multiple_choice",
          options: ["A", "B"],
          correctAnswer: "C",
        },
      ],
    };

    expect(lessonContentSchema.safeParse(invalid).success).toBe(false);
  });
});
