import "server-only";

import { NextResponse } from "next/server";

import { listPastPapers } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

export async function GET(request: Request) {
  try {
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const url = new URL(request.url);
    const subjectId = url.searchParams.get("subjectId") ?? undefined;
    const yearParam = url.searchParams.get("year");
    const paperYear = yearParam ? Number(yearParam) : undefined;

    const papers = await listPastPapers(
      studentContext.profile.curriculum,
      subjectId,
      paperYear,
    );

    return NextResponse.json({ success: true, data: papers });
  } catch (error) {
    console.error("PAST_PAPERS_LIST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load past papers.", 500);
  }
}
