import "server-only";

import { NextResponse } from "next/server";

import { practiceAnswerSchema } from "@/schemas/practiceSchemas";
import { submitPracticeAnswer } from "@/server/services/practiceService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  try {
    const { id: sessionId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = await request.json();
    const parsed = practiceAnswerSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const data = await submitPracticeAnswer(
      sessionId,
      studentContext.profile,
      parsed.data,
    );

    return NextResponse.json({
      success: true,
      data,
    });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Practice session not found.", 404);
    }

    if (message === "CONFLICT") {
      return apiErrorResponse(
        "CONFLICT",
        "Practice session is no longer active.",
        409,
      );
    }

    console.error("PRACTICE_ANSWER_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not save practice answer.",
      500,
    );
  }
}
