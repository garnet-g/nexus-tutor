import { describe, expect, it } from "vitest";

import {
  parseCsvOptions,
  questionCsvRowSchema,
} from "@/schemas/contentStudioSchemas";
import {
  editableRowsToCsv,
  parseQuestionCsv,
  type EditableQuestionRow,
} from "@/features/admin/studio/lib/studioWorkspaceApi";

const topicId = "00000000-0000-4000-8000-000000000301";

describe("contentStudioSchemas", () => {
  it("validates CSV question rows with pipe-separated options", () => {
    const parsed = questionCsvRowSchema.parse({
      questionText: "What is 2 + 2?",
      questionType: "multiple_choice",
      options: "3|4|5",
      correctAnswer: "4",
      difficulty: "easy",
      explanation: "Basic addition.",
    });

    expect(parseCsvOptions(parsed.options)).toEqual(["3", "4", "5"]);
  });

  it("rejects multiple choice rows when correctAnswer is not an option", () => {
    const result = questionCsvRowSchema.safeParse({
      questionText: "Pick one",
      questionType: "multiple_choice",
      options: "A|B",
      correctAnswer: "C",
      difficulty: "easy",
      explanation: "Nope.",
    });

    expect(result.success).toBe(false);
  });
});

describe("studioWorkspaceApi CSV helpers", () => {
  it("round-trips editable rows to CSV and back", () => {
    const rows: EditableQuestionRow[] = [
      {
        clientKey: "row-1",
        isNew: false,
        markDelete: false,
        id: "00000000-0000-4000-8000-000000000401",
        topicId,
        subtopicId: null,
        questionText: "What is 3 x 3?",
        questionType: "multiple_choice",
        options: ["6", "9"],
        correctAnswer: "9",
        difficulty: "easy",
        explanation: "Three times three.",
        reviewStatus: "draft",
        isActive: false,
      },
    ];

    const csv = editableRowsToCsv(rows);
    const imported = parseQuestionCsv(csv, topicId);

    expect(imported.ok).toBe(true);
    if (imported.ok) {
      expect(imported.rows[0].questionText).toBe("What is 3 x 3?");
      expect(imported.rows[0].correctAnswer).toBe("9");
    }
  });

  it("reports row-level CSV import errors", () => {
    const csv = [
      "questionText,questionType,options,correctAnswer,difficulty,explanation",
      "Bad question,multiple_choice,A|B,C,easy,Missing option match",
    ].join("\n");

    const imported = parseQuestionCsv(csv, topicId);
    expect(imported.ok).toBe(false);
    if (!imported.ok) {
      expect(imported.errors[0]?.row).toBe(2);
    }
  });
});
