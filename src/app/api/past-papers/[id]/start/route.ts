import "server-only";

import { NextResponse } from "next/server";

import { startPastPaperAttempt } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

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

    const result = await startPastPaperAttempt(studentContext.profile.id, id);

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const message = error instanceof Error ? error.message : "INTERNAL_ERROR";

    if (message === "NOT_FOUND") {
      return apiErrorResponse("NOT_FOUND", "Past paper not found.", 404);
    }

    console.error("PAST_PAPER_START_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not start attempt.", 500);
  }
}
