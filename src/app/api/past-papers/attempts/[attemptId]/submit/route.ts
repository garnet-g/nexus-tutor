import "server-only";

import { NextResponse } from "next/server";

import { pastPaperSubmitSchema } from "@/schemas/pastPaperSchemas";
import { submitPastPaperAttempt } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ attemptId: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  try {
    const { attemptId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = await request.json();
    const parsed = pastPaperSubmitSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const result = await submitPastPaperAttempt(
      attemptId,
      studentContext.profile.id,
      parsed.data.answers,
    );

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Attempt not found.", 404);
    }

    if (message === "ALREADY_SUBMITTED") {
      return apiErrorResponse("CONFLICT", "Attempt already submitted.", 409);
    }

    console.error("PAST_PAPER_SUBMIT_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not submit attempt.", 500);
  }
}
