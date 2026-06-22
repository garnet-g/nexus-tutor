import { kcseCalibrationSourcePolicy } from "@/schemas/kcseCalibrationSchemas";
import type { KcseCalibrationIntake } from "@/schemas/kcseCalibrationSchemas";

export type KcseCalibrationRecordInput = Omit<
  KcseCalibrationIntake,
  "sourcePolicy"
> & {
  adminId: string;
};

export interface KcseCalibrationRecord {
  admin_id: string;
  subject_code: string;
  paper_number: number;
  source_label: string;
  extraction_status: KcseCalibrationIntake["extractionStatus"];
  command_verbs: string[];
  mark_allocation: KcseCalibrationIntake["markAllocation"];
  topic_signals: KcseCalibrationIntake["topicSignals"];
  notes: string[];
  source_policy: typeof kcseCalibrationSourcePolicy;
  approval_status: "approved";
}

function normalizeToken(value: string): string {
  return value.trim().toLowerCase().replace(/\s+/g, "_");
}

function uniqueNormalizedTokens(values: string[]): string[] {
  return [...new Set(values.map(normalizeToken).filter(Boolean))];
}

export function buildKcseCalibrationRecord(
  input: KcseCalibrationRecordInput,
): KcseCalibrationRecord {
  return {
    admin_id: input.adminId,
    subject_code: input.subjectCode,
    paper_number: input.paperNumber,
    source_label: input.sourceLabel.trim(),
    extraction_status: input.extractionStatus,
    command_verbs: uniqueNormalizedTokens(input.commandVerbs),
    mark_allocation: input.markAllocation.map((entry) => ({
      marks: entry.marks,
      observedCount: entry.observedCount,
    })),
    topic_signals: input.topicSignals.map((entry) => ({
      tag: normalizeToken(entry.tag),
      observedCount: entry.observedCount,
    })),
    notes: input.notes.map((note) => note.trim()).filter(Boolean),
    source_policy: kcseCalibrationSourcePolicy,
    approval_status: "approved",
  };
}
