import {
  parseCsvOptions,
  questionCsvRowSchema,
} from "@/schemas/contentStudioSchemas";
import { formatStudentQuestionText } from "@/lib/content/questionText";
import type {
  BulkSaveQuestionsResult,
  StudioLessonSummary,
  StudioQuestionRow,
  StudioSubtopicContext,
  StudioTopicContext,
} from "@/types/contentStudio";

import type { AdminApiResponse } from "@/features/admin/studio/lib/studioApi";

export type SubtopicLessonsResponse = {
  context: StudioSubtopicContext;
  lessons: StudioLessonSummary[];
};

export type TopicQuestionsResponse = {
  context: StudioTopicContext;
  questions: StudioQuestionRow[];
};

export async function fetchSubtopicLessons(
  subtopicId: string,
): Promise<SubtopicLessonsResponse> {
  const response = await fetch(`/api/admin/content/studio/subtopics/${subtopicId}/lessons`);
  const payload = (await response.json()) as AdminApiResponse<SubtopicLessonsResponse>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not load lessons." : payload.error.message);
  }

  return payload.data;
}

export async function fetchTopicQuestions(topicId: string): Promise<TopicQuestionsResponse> {
  const response = await fetch(`/api/admin/content/studio/topics/${topicId}/questions`);
  const payload = (await response.json()) as AdminApiResponse<TopicQuestionsResponse>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not load questions." : payload.error.message);
  }

  return payload.data;
}

export async function reorderSubtopicLessons(
  subtopicId: string,
  lessonIds: string[],
): Promise<void> {
  const response = await fetch(
    `/api/admin/content/studio/subtopics/${subtopicId}/lessons/reorder`,
    {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ lessonIds }),
    },
  );
  const payload = (await response.json()) as AdminApiResponse<unknown>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Could not reorder lessons." : payload.error.message);
  }
}

export type EditableQuestionRow = StudioQuestionRow & {
  clientKey: string;
  isNew: boolean;
  markDelete: boolean;
};

export function toEditableQuestionRow(question: StudioQuestionRow): EditableQuestionRow {
  return {
    ...question,
    questionText: formatStudentQuestionText(question.questionText),
    clientKey: question.id,
    isNew: false,
    markDelete: false,
  };
}

export function createBlankQuestionRow(topicId: string): EditableQuestionRow {
  return {
    clientKey: crypto.randomUUID(),
    isNew: true,
    markDelete: false,
    id: "",
    topicId,
    subtopicId: null,
    questionText: "",
    questionType: "multiple_choice",
    options: ["", ""],
    correctAnswer: "",
    difficulty: "easy",
    explanation: "",
    reviewStatus: "draft",
    isActive: false,
  };
}

export async function bulkSaveTopicQuestions(
  topicId: string,
  rows: EditableQuestionRow[],
): Promise<BulkSaveQuestionsResult> {
  const response = await fetch(`/api/admin/content/studio/topics/${topicId}/questions/bulk`, {
    method: "PATCH",
    headers: { "Content-Type": "application/json" },
    body: JSON.stringify({
      topicId,
      questions: rows.map((row) => ({
        id: row.isNew ? undefined : row.id,
        subtopicId: row.subtopicId,
        questionText: formatStudentQuestionText(row.questionText),
        questionType: row.questionType,
        options: row.questionType === "multiple_choice" ? row.options : [],
        correctAnswer: row.correctAnswer,
        difficulty: row.difficulty,
        explanation: row.explanation ?? "",
        delete: row.markDelete,
      })),
    }),
  });
  const payload = (await response.json()) as AdminApiResponse<BulkSaveQuestionsResult>;

  if (!response.ok || !payload.success) {
    throw new Error(payload.success ? "Bulk save failed." : payload.error.message);
  }

  return payload.data;
}

export type CsvImportResult =
  | { ok: true; rows: EditableQuestionRow[] }
  | { ok: false; errors: Array<{ row: number; message: string }> };

export function parseQuestionCsv(text: string, topicId: string): CsvImportResult {
  const lines = text
    .split(/\r?\n/)
    .map((line) => line.trim())
    .filter(Boolean);

  if (lines.length < 2) {
    return { ok: false, errors: [{ row: 1, message: "CSV must include a header and one data row." }] };
  }

  const headers = splitCsvLine(lines[0]).map((header) => header.trim());
  const headerIndex = Object.fromEntries(headers.map((header, index) => [header, index]));
  const required = [
    "questionText",
    "questionType",
    "correctAnswer",
    "difficulty",
    "explanation",
  ];

  for (const key of required) {
    if (!(key in headerIndex)) {
      return { ok: false, errors: [{ row: 1, message: `Missing CSV column: ${key}` }] };
    }
  }

  const rows: EditableQuestionRow[] = [];
  const errors: Array<{ row: number; message: string }> = [];

  for (let lineIndex = 1; lineIndex < lines.length; lineIndex += 1) {
    const cells = splitCsvLine(lines[lineIndex]);
    const get = (key: string) => cells[headerIndex[key]]?.trim() ?? "";

    const parsed = questionCsvRowSchema.safeParse({
      questionText: get("questionText"),
      questionType: get("questionType"),
      options: get("options"),
      correctAnswer: get("correctAnswer"),
      difficulty: get("difficulty"),
      explanation: get("explanation"),
      subtopicId: get("subtopicId") || undefined,
    });

    if (!parsed.success) {
      errors.push({
        row: lineIndex + 1,
        message: parsed.error.issues.map((issue) => issue.message).join("; "),
      });
      continue;
    }

    const options = parseCsvOptions(parsed.data.options);
    rows.push({
      clientKey: crypto.randomUUID(),
      isNew: true,
      markDelete: false,
      id: "",
      topicId,
      subtopicId: parsed.data.subtopicId ?? null,
      questionText: formatStudentQuestionText(parsed.data.questionText),
      questionType: parsed.data.questionType,
      options,
      correctAnswer: parsed.data.correctAnswer,
      difficulty: parsed.data.difficulty,
      explanation: parsed.data.explanation,
      reviewStatus: "draft",
      isActive: false,
    });
  }

  if (errors.length > 0) {
    return { ok: false, errors };
  }

  return { ok: true, rows };
}

function splitCsvLine(line: string): string[] {
  const cells: string[] = [];
  let current = "";
  let inQuotes = false;

  for (let index = 0; index < line.length; index += 1) {
    const char = line[index];
    const next = line[index + 1];

    if (char === '"' && inQuotes && next === '"') {
      current += '"';
      index += 1;
      continue;
    }

    if (char === '"') {
      inQuotes = !inQuotes;
      continue;
    }

    if (char === "," && !inQuotes) {
      cells.push(current);
      current = "";
      continue;
    }

    current += char;
  }

  cells.push(current);
  return cells;
}

export function editableRowsToCsv(rows: EditableQuestionRow[]): string {
  const headers = [
    "questionText",
    "questionType",
    "options",
    "correctAnswer",
    "difficulty",
    "explanation",
    "subtopicId",
    "reviewStatus",
  ];

  const escape = (value: string) => {
    if (/[",\n]/.test(value)) {
      return `"${value.replace(/"/g, '""')}"`;
    }
    return value;
  };

  const lines = [
    headers.join(","),
    ...rows
      .filter((row) => !row.markDelete)
      .map((row) =>
        [
          formatStudentQuestionText(row.questionText),
          row.questionType,
          row.options.join("|"),
          row.correctAnswer,
          row.difficulty,
          row.explanation ?? "",
          row.subtopicId ?? "",
          row.reviewStatus,
        ]
          .map(escape)
          .join(","),
      ),
  ];

  return lines.join("\n");
}
