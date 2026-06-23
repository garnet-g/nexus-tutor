import type {
  LessonBlockType,
  LessonCalloutVariant,
  LessonContent,
  LessonContentBlock,
} from "@/types/curriculum";
import { lessonBlockSchema, lessonContentSchema } from "@/schemas/lessonContentSchemas";

export const STUDIO_BLOCK_MENU: Array<{ type: LessonBlockType; label: string; hint: string }> = [
  { type: "heading", label: "Heading", hint: "Section title" },
  { type: "paragraph", label: "Paragraph", hint: "Plain text" },
  { type: "rich_text", label: "Rich text", hint: "Markdown with formatting" },
  { type: "example", label: "Worked example", hint: "Step-by-step solution" },
  { type: "tip", label: "Key idea", hint: "Short tip" },
  { type: "callout", label: "Callout", hint: "Info, warning, or key point" },
  { type: "image", label: "Image", hint: "Upload or link an image" },
  { type: "table", label: "Table", hint: "Rows and columns" },
  { type: "math_block", label: "Math block", hint: "Display LaTeX formula" },
  { type: "chemical_equation", label: "Chemical equation", hint: "Balanced equation" },
  { type: "comprehension_passage", label: "Passage", hint: "Reading comprehension" },
  { type: "video_embed", label: "Video", hint: "YouTube or Vimeo embed" },
  { type: "question", label: "Self-check", hint: "Inline practice question" },
  { type: "file_attachment", label: "Attachment", hint: "Downloadable file link" },
  { type: "divider", label: "Divider", hint: "Visual break" },
];

export function createDefaultBlock(type: LessonBlockType): LessonContentBlock {
  const id = crypto.randomUUID();

  switch (type) {
    case "heading":
      return { id, type, content: "New section" };
    case "paragraph":
      return { id, type, content: "Start writing here." };
    case "rich_text":
      return { id, type, markdown: "Write **rich** lesson content here." };
    case "example":
      return {
        id,
        type,
        title: "Worked example",
        steps: ["First step"],
        answer: "Answer",
      };
    case "tip":
      return { id, type, content: "Remember this key idea." };
    case "callout":
      return { id, type, variant: "info" satisfies LessonCalloutVariant, content: "Note for students." };
    case "image":
      return { id, type, url: "https://example.com/image.png", alt: "Describe the image" };
    case "table":
      return {
        id,
        type,
        rows: [
          ["Column A", "Column B"],
          ["Value 1", "Value 2"],
        ],
      };
    case "math_block":
      return { id, type, latex: "x^2 + y^2 = r^2" };
    case "chemical_equation":
      return { id, type, equation: "2H_2 + O_2 -> 2H_2O" };
    case "comprehension_passage":
      return { id, type, title: "Passage", passage: "Write the passage here." };
    case "video_embed":
      return {
        id,
        type,
        provider: "youtube",
        url: "https://www.youtube.com/watch?v=dQw4w9WgXcQ",
        title: "Lesson video",
      };
    case "question":
      return {
        id,
        type,
        questionText: "What did you learn?",
        questionType: "multiple_choice",
        options: ["Option A", "Option B"],
        correctAnswer: "Option A",
        explanation: "Review the section above.",
      };
    case "file_attachment":
      return { id, type, url: "https://example.com/resource.pdf", name: "Worksheet.pdf" };
    case "divider":
      return { id, type };
    default: {
      const _exhaustive: never = type;
      return _exhaustive;
    }
  }
}

export function normalizeStudioBlocks(blocks: LessonContentBlock[]): LessonContentBlock[] {
  return blocks.map((block) => {
    const parsed = lessonBlockSchema.parse(block);
    return {
      ...parsed,
      id: parsed.id ?? crypto.randomUUID(),
    };
  });
}

export function blocksToLessonContent(
  blocks: LessonContentBlock[],
  shortQuiz?: LessonContent["shortQuiz"],
): LessonContent {
  return lessonContentSchema.parse({
    blocks: normalizeStudioBlocks(blocks),
    shortQuiz,
  });
}

export function lessonContentToBlocks(content: LessonContent): LessonContentBlock[] {
  return lessonContentSchema.parse(content).blocks;
}

export function serializeStudioBlocks(blocks: LessonContentBlock[]): LessonContentBlock[] {
  return normalizeStudioBlocks(blocks).map((block) => lessonBlockSchema.parse(block));
}
