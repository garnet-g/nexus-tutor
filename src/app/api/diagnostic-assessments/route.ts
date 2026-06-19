import "server-only";

import { NextResponse } from "next/server";

import { listDiagnosticAssessments } from "@/server/services/diagnosticService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

export async function GET() {
  try {
    const context = await requireStudentProfile();

    if (!context.ok) {
      return apiErrorResponse(
        context.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        context.message,
        context.status,
      );
    }

    const assessments = await listDiagnosticAssessments(context.profile);

    return NextResponse.json({
      success: true,
      data: { assessments },
    });
  } catch (error) {
    console.error("DIAGNOSTIC_LIST_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not load diagnostic assessments.",
      500,
    );
  }
}
