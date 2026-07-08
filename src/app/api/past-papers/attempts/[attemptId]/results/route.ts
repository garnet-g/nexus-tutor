import "server-only";

import { NextResponse } from "next/server";

import { getPastPaperAttemptResults } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ attemptId: string }>;
}

export async function GET(_request: Request, context: RouteContext) {
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

    const results = await getPastPaperAttemptResults(
      attemptId,
      studentContext.profile.id,
    );

    if (!results) {
      return apiErrorResponse("NOT_FOUND", "Attempt not found.", 404);
    }

    return NextResponse.json({ success: true, data: results });
  } catch (error) {
    console.error("PAST_PAPER_RESULTS_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load results.", 500);
  }
}
