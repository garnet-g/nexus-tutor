import "server-only";

import { NextResponse } from "next/server";

import { startDiagnosticAssessment } from "@/server/services/diagnosticService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(_request: Request, context: RouteContext) {
  try {
    const { id } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const data = await startDiagnosticAssessment(id, studentContext.profile);

    return NextResponse.json(
      {
        success: true,
        data,
      },
      { status: 201 },
    );
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "CONFLICT") {
      return apiErrorResponse(
        "CONFLICT",
        "Diagnostic assessment already completed.",
        409,
      );
    }

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Assessment not found.", 404);
    }

    if (message === "FORBIDDEN") {
      return apiErrorResponse(
        "FORBIDDEN",
        "Assessment does not match your curriculum.",
        403,
      );
    }

    if (message === "NO_QUESTIONS") {
      return apiErrorResponse(
        "NOT_FOUND",
        "No diagnostic questions are available yet.",
        404,
      );
    }

    console.error("DIAGNOSTIC_START_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not start diagnostic assessment.",
      500,
    );
  }
}
