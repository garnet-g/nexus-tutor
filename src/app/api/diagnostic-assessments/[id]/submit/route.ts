import "server-only";

import { NextResponse } from "next/server";

import { diagnosticSubmitSchema } from "@/schemas/diagnosticSchemas";
import { submitDiagnosticAssessment } from "@/server/services/diagnosticService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  try {
    const { id: assessmentId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = await request.json();
    const parsed = diagnosticSubmitSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const attemptId =
      typeof body.diagnosticAttemptId === "string"
        ? body.diagnosticAttemptId
        : null;

    if (!attemptId) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "diagnosticAttemptId is required.",
        400,
      );
    }

    const data = await submitDiagnosticAssessment(
      assessmentId,
      attemptId,
      studentContext.profile,
      parsed.data.answers,
    );

    return NextResponse.json({
      success: true,
      data,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "CONFLICT") {
      return apiErrorResponse(
        "CONFLICT",
        "Diagnostic attempt already submitted.",
        409,
      );
    }

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Diagnostic attempt not found.", 404);
    }

    if (message === "VALIDATION_ERROR") {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Submitted answers are invalid.",
        400,
      );
    }

    console.error("DIAGNOSTIC_SUBMIT_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not submit diagnostic assessment.",
      500,
    );
  }
}
