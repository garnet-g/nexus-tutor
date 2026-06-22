import "server-only";

import type { KcseCalibrationIntake } from "@/schemas/kcseCalibrationSchemas";
import {
  buildKcseCalibrationRecord,
  type KcseCalibrationRecordInput,
} from "@/lib/assessment/kcseCalibration";
import { createAdminClient } from "@/lib/supabase/admin";

export type { KcseCalibrationRecordInput };

export interface KcseCalibrationResult {
  id: string;
  subjectCode: string;
  paperNumber: number;
  extractionStatus: KcseCalibrationIntake["extractionStatus"];
  approvalStatus: "approved";
}

export async function createKcseCalibration(
  input: KcseCalibrationRecordInput,
): Promise<KcseCalibrationResult> {
  const admin = createAdminClient();
  const record = buildKcseCalibrationRecord(input);

  const { data, error } = await admin
    .from("kcse_paper_calibrations")
    .insert(record)
    .select("id, subject_code, paper_number, extraction_status, approval_status")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not save KCSE calibration.");
  }

  return {
    id: data.id,
    subjectCode: data.subject_code,
    paperNumber: data.paper_number,
    extractionStatus: data.extraction_status,
    approvalStatus: data.approval_status,
  };
}
