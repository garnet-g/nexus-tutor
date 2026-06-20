import "server-only";

import { NextResponse } from "next/server";

import {
  markLessonViewed,
} from "@/server/services/lessonProgressService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(_request: Request, context: RouteContext) {
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

    const data = await markLessonViewed(
      studentContext.profile.id,
      lessonId,
      studentContext.profile.curriculum,
      studentContext.profile.grade_level,
    );

    return NextResponse.json({ success: true, data });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Lesson not found.", 404);
    }

    console.error("LESSON_VIEWED_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not record lesson view.",
      500,
    );
  }
}
