import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { LessonContentBlocks } from "@/features/learn/components/LessonContentBlocks";
import type { CurriculumLesson, LessonContent } from "@/types/curriculum";

vi.mock("next/link", () => ({
  default: ({
    children,
    href,
    ...props
  }: {
    children: React.ReactNode;
    href: string;
  }) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

const legacyContent: LessonContent = {
  blocks: [
    { type: "heading", content: "Introduction to Linear Equations" },
    {
      type: "paragraph",
      content:
        "A linear equation has one variable raised to the power of one. In Kenya, you might use them to work out matatu fares.",
    },
    {
      type: "example",
      title: "Worked Example 1",
      steps: [
        "Write the equation: 2x + 5 = 13",
        "Subtract 5 from both sides",
        "Divide by 2",
      ],
      answer: "x = 4",
    },
    {
      type: "tip",
      content: "Always perform the same operation on both sides of the equation.",
    },
  ],
};

const extendedContent: LessonContent = {
  blocks: [
    { type: "heading", content: "Rich lesson" },
    { type: "rich_text", markdown: "Inline **markdown** block." },
    {
      type: "image",
      url: "https://example.com/diagram.png",
      alt: "Diagram",
      caption: "Labelled diagram",
    },
    {
      type: "table",
      rows: [
        ["Term", "Meaning"],
        ["Variable", "Unknown value"],
      ],
    },
    { type: "math_block", latex: "ax + b = 0" },
    { type: "callout", variant: "key_point", content: "Isolate the variable." },
    {
      type: "video_embed",
      provider: "youtube",
      url: "https://www.youtube.com/watch?v=abc123def45",
      title: "Intro video",
    },
    { type: "divider" },
    {
      type: "question",
      questionText: "What is the solution to x + 3 = 7?",
      questionType: "multiple_choice",
      options: ["x = 3", "x = 4", "x = 10"],
      correctAnswer: "x = 4",
      explanation: "Subtract 3 from both sides.",
    },
    {
      type: "file_attachment",
      url: "https://example.com/notes.pdf",
      name: "Class notes",
    },
    {
      type: "chemical_equation",
      equation: "NaCl -> Na^+ + Cl^-",
      caption: "Dissociation",
    },
    {
      type: "comprehension_passage",
      title: "Reading",
      passage: "The matatu left Nairobi at dawn.",
    },
  ],
};

const topicId = "00000000-0000-4000-8000-000000000099";

function renderBlocks(content: LessonContent) {
  return render(<LessonContentBlocks blocks={content.blocks} topicId={topicId} />);
}

describe("LessonContentBlocks", () => {
  it("renders legacy published lesson blocks identically", () => {
    const { container } = renderBlocks(legacyContent);
    const text = container.textContent ?? "";

    expect(text).toContain("Introduction to Linear Equations");
    expect(text).toContain(
      "A linear equation has one variable raised to the power of one. In Kenya, you might use them to work out matatu fares.",
    );
    expect(text).toContain("Worked Example 1");
    expect(text).toContain("Show next step");
    expect(text).toContain("Key idea");
    expect(text).toContain(
      "Always perform the same operation on both sides of the equation.",
    );

    expect(container).toMatchSnapshot();
  });

  it("renders every new block type without error", () => {
    const { container } = renderBlocks(extendedContent);
    const text = container.textContent ?? "";

    expect(text).toContain("Rich lesson");
    expect(text).toContain("markdown");
    expect(screen.getByAltText("Diagram")).toBeTruthy();
    expect(text).toContain("Variable");
    expect(text).toContain("Intro video");
    expect(text).toContain("Self-check");
    expect(text).toContain("Class notes");
    expect(text).toContain("Dissociation");
    expect(text).toContain("Reading");

    fireEvent.click(screen.getByRole("button", { name: "x = 4" }));
    fireEvent.click(screen.getByRole("button", { name: "Check answer" }));
    expect(container.textContent).toContain("Correct!");
  });
});

describe("LessonRenderer contract", () => {
  it("accepts CurriculumLesson content with legacy blocks", () => {
    const lesson: CurriculumLesson = {
      id: "lesson-1",
      title: "Linear Equations",
      content: legacyContent,
      estimatedMinutes: 12,
      sortOrder: 1,
      subtopicId: "sub-1",
      subtopicTitle: "Linear Equations",
      topicId,
      topicTitle: "Algebra",
      subjectId: "subject-1",
      curriculumCode: "CBC",
    };

    expect(lesson.content.blocks).toHaveLength(4);
  });
});
