import "server-only";

import { NextResponse } from "next/server";

import { lessonCompleteSchema } from "@/schemas/lessonProgressSchemas";
import { completeLesson } from "@/server/services/lessonProgressService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  try {
    const { id: lessonId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = await request.json().catch(() => ({}));
    const parsed = lessonCompleteSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const data = await completeLesson(
      studentContext.profile.id,
      lessonId,
      studentContext.profile.curriculum,
      studentContext.profile.grade_level,
      parsed.data,
    );

    return NextResponse.json({ success: true, data });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Lesson not found.", 404);
    }

    console.error("LESSON_COMPLETE_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not complete lesson.",
      500,
    );
  }
}
