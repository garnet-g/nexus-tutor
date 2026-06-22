import {
  getKcseSubjectBlueprint,
  type KcsePaperCalibration,
  type KcseSubjectId,
} from "@/lib/assessment/kcseSubjectBlueprints";

type KcseExtractionStatus = "machine_readable" | "needs_ocr";

export interface KcseCalibrationMetadataInput {
  sourceName: string;
  subject: string;
  paperNumber: number;
  year: number;
  extractionStatus: KcseExtractionStatus;
  commandVerbs?: string[];
  markAllocation?: number[];
  topicSignals?: string[];
  notes?: string[];
  [key: string]: unknown;
}

export interface NormalizedKcseCalibrationMetadata {
  subjectId: KcseSubjectId;
  subjectDisplayName: string;
  paperNumber: number;
  year: number;
  sourceReference: string;
  evidenceType: "metadata_only";
  extractionStatus: KcseExtractionStatus;
  sourceVisibility: "private_reference_only";
  storagePolicy: "metadata_only_no_source_text";
  commandVerbs: string[];
  markAllocation: Array<{ marks: number; observedCount: number }>;
  topicSignals: Array<{ tag: string; observedCount: number }>;
  contentPolicy: "do_not_copy_or_redistribute_source_questions";
  notes: string[];
  discardedFields: string[];
}

const PROHIBITED_FIELDS = new Set([
  "answer",
  "answers",
  "answerKey",
  "answerText",
  "correctAnswer",
  "filePath",
  "markingScheme",
  "markingSchemeText",
  "pdfUrl",
  "question",
  "questions",
  "questionText",
  "rawText",
  "sourcePdf",
  "sourcePdfUrl",
  "sourceText",
]);

export function normalizeKcseCalibrationMetadata(
  input: KcseCalibrationMetadataInput,
): NormalizedKcseCalibrationMetadata {
  const blueprint = getKcseSubjectBlueprint(input.subject);
  if (!blueprint) {
    throw new Error("UNKNOWN_KCSE_SUBJECT");
  }

  return {
    subjectId: blueprint.id,
    subjectDisplayName: blueprint.displayName,
    paperNumber: normalizePaperNumber(input.paperNumber),
    year: normalizeYear(input.year),
    sourceReference: buildSourceReference(
      normalizeYear(input.year),
      blueprint.displayName,
      normalizePaperNumber(input.paperNumber),
    ),
    evidenceType: "metadata_only",
    extractionStatus: input.extractionStatus,
    sourceVisibility: "private_reference_only",
    storagePolicy: "metadata_only_no_source_text",
    commandVerbs: normalizeStringList(input.commandVerbs ?? []),
    markAllocation: countMarkAllocations(input.markAllocation ?? []),
    topicSignals: countTopicSignals(input.topicSignals ?? []),
    contentPolicy: "do_not_copy_or_redistribute_source_questions",
    notes: normalizeNotes(input.notes ?? []),
    discardedFields: Object.keys(input)
      .filter((key) => PROHIBITED_FIELDS.has(key))
      .sort(),
  };
}

export function toKcsePaperCalibration(
  metadata: NormalizedKcseCalibrationMetadata,
): KcsePaperCalibration {
  return {
    calibratedFrom: [metadata.sourceReference],
    evidenceType: metadata.evidenceType,
    extractionStatus: metadata.extractionStatus,
    commandVerbs: metadata.commandVerbs,
    markAllocation: metadata.markAllocation,
    topicSignals: metadata.topicSignals,
    contentPolicy: metadata.contentPolicy,
    notes: metadata.notes,
  };
}

function normalizePaperNumber(value: number): number {
  if (!Number.isInteger(value) || value < 1 || value > 3) {
    throw new Error("INVALID_KCSE_PAPER_NUMBER");
  }
  return value;
}

function normalizeYear(value: number): number {
  if (!Number.isInteger(value) || value < 1989 || value > 2100) {
    throw new Error("INVALID_KCSE_CALIBRATION_YEAR");
  }
  return value;
}

function buildSourceReference(
  year: number,
  subjectDisplayName: string,
  paperNumber: number,
): string {
  return `${year} KCSE ${subjectDisplayName} Paper ${paperNumber} private reference`;
}

function normalizeStringList(values: string[]): string[] {
  const seen = new Set<string>();
  const normalized: string[] = [];

  for (const value of values) {
    const entry = value.trim().toLowerCase();
    if (entry && !seen.has(entry)) {
      seen.add(entry);
      normalized.push(entry);
    }
  }

  return normalized;
}

function normalizeNotes(values: string[]): string[] {
  return values
    .map((value) => value.trim())
    .filter(Boolean)
    .map((value) => value.slice(0, 240));
}

function countMarkAllocations(values: number[]): Array<{ marks: number; observedCount: number }> {
  const counts = new Map<number, number>();

  for (const value of values) {
    if (Number.isInteger(value) && value > 0) {
      counts.set(value, (counts.get(value) ?? 0) + 1);
    }
  }

  return [...counts.entries()]
    .map(([marks, observedCount]) => ({ marks, observedCount }))
    .sort((left, right) => right.observedCount - left.observedCount || right.marks - left.marks);
}

function countTopicSignals(values: string[]): Array<{ tag: string; observedCount: number }> {
  const counts = new Map<string, number>();

  for (const value of values) {
    const tag = slugifyTag(value);
    if (tag) {
      counts.set(tag, (counts.get(tag) ?? 0) + 1);
    }
  }

  return [...counts.entries()]
    .map(([tag, observedCount]) => ({ tag, observedCount }))
    .sort((left, right) => right.observedCount - left.observedCount || left.tag.localeCompare(right.tag));
}

function slugifyTag(value: string): string {
  return value
    .trim()
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9]+/g, "_")
    .replace(/^_|_$/g, "");
}
