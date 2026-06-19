import "server-only";

import { NextResponse } from "next/server";

import { practiceCompleteSchema } from "@/schemas/practiceSchemas";
import { completePracticeSession } from "@/server/services/practiceService";
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

    const body = await request.json().catch(() => ({}));
    const parsed = practiceCompleteSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const data = await completePracticeSession(
      sessionId,
      studentContext.profile,
      parsed.data.timeSpentSeconds,
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
        "Practice session already completed.",
        409,
      );
    }

    console.error("PRACTICE_COMPLETE_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not complete practice session.",
      500,
    );
  }
}
