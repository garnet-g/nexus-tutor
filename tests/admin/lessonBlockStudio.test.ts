import { describe, expect, it } from "vitest";

import {
  blocksToLessonContent,
  createDefaultBlock,
  lessonContentToBlocks,
  serializeStudioBlocks,
  STUDIO_BLOCK_MENU,
} from "@/features/admin/studio/lib/lessonBlockStudio";
import { lessonContentSchema } from "@/schemas/lessonContentSchemas";

describe("lessonBlockStudio serializer", () => {
  it("creates defaults for every slash-menu block type", () => {
    for (const item of STUDIO_BLOCK_MENU) {
      const block = createDefaultBlock(item.type);
      expect(lessonContentSchema.parse({ blocks: [block] }).blocks[0].type).toBe(item.type);
    }
  });

  it("round-trips editor blocks through lessonContentSchema without data loss", () => {
    const blocks = STUDIO_BLOCK_MENU.map((item) => createDefaultBlock(item.type));
    const content = blocksToLessonContent(blocks);
    const restored = lessonContentToBlocks(content);
    const serialized = serializeStudioBlocks(restored);

    expect(serialized.map((block) => block.type)).toEqual(blocks.map((block) => block.type));

    for (const block of serialized) {
      expect(block.id).toBeTruthy();
    }
  });

  it("preserves edited fields after serialize and parse", () => {
    const blocks = [
      createDefaultBlock("heading"),
      createDefaultBlock("rich_text"),
      createDefaultBlock("question"),
    ];
    blocks[0] = { ...blocks[0], type: "heading", content: "Edited heading" };
    if (blocks[1].type === "rich_text") {
      blocks[1] = { ...blocks[1], markdown: "Custom **markdown** with $x^2$." };
    }
    if (blocks[2].type === "question") {
      blocks[2] = {
        ...blocks[2],
        questionText: "What is 5 + 5?",
        correctAnswer: "10",
        options: ["9", "10"],
      };
    }

    const roundTrip = lessonContentToBlocks(blocksToLessonContent(blocks));
    expect(roundTrip[0]).toMatchObject({ type: "heading", content: "Edited heading" });
    if (roundTrip[1].type === "rich_text") {
      expect(roundTrip[1].markdown).toContain("Custom");
    }
    if (roundTrip[2].type === "question") {
      expect(roundTrip[2].correctAnswer).toBe("10");
    }
  });
});
