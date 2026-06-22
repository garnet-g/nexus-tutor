import "server-only";

import { NextResponse } from "next/server";

import {
  kcseCalibrationIntakeSchema,
  kcseCalibrationSourcePolicy,
} from "@/schemas/kcseCalibrationSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { createKcseCalibration } from "@/server/services/kcseCalibrationService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

function mapServiceError(error: unknown): { status: number; code: string; message: string } {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  return { status: 500, code: "INTERNAL_ERROR", message };
}

export async function POST(request: Request) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      {
        success: false,
        error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message },
      },
      { status: auth.status },
    );
  }

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json(
      {
        success: false,
        error: { code: "INVALID_JSON", message: "Request body must be valid JSON." },
      },
      { status: 400 },
    );
  }

  const parsed = kcseCalibrationIntakeSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: parsed.error.issues.map((issue) => issue.message).join("; "),
        },
      },
      { status: 400 },
    );
  }

  try {
    const result = await createKcseCalibration({
      subjectCode: parsed.data.subjectCode,
      paperNumber: parsed.data.paperNumber,
      sourceLabel: parsed.data.sourceLabel,
      extractionStatus: parsed.data.extractionStatus,
      commandVerbs: parsed.data.commandVerbs,
      markAllocation: parsed.data.markAllocation,
      topicSignals: parsed.data.topicSignals,
      notes: parsed.data.notes,
      adminId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "assessment.calibration.create",
      targetType: "kcse_paper_calibration",
      targetId: result.id,
      metadata: {
        subjectCode: result.subjectCode,
        paperNumber: result.paperNumber,
        extractionStatus: result.extractionStatus,
      },
      request,
    });

    return NextResponse.json({
      success: true,
      data: {
        ...result,
        sourcePolicy: kcseCalibrationSourcePolicy,
      },
    });
  } catch (error) {
    const mapped = mapServiceError(error);
    return NextResponse.json(
      {
        success: false,
        error: { code: mapped.code, message: mapped.message },
      },
      { status: mapped.status },
    );
  }
}
