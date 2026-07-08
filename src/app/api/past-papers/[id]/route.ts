import "server-only";

import { NextResponse } from "next/server";

import { getPastPaperDetail } from "@/server/services/pastPaperService";
import { apiErrorResponse, requireStudentProfile } from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function GET(_request: Request, context: RouteContext) {
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

    const paper = await getPastPaperDetail(id);

    if (!paper) {
      return apiErrorResponse("NOT_FOUND", "Past paper not found.", 404);
    }

    return NextResponse.json({ success: true, data: paper });
  } catch (error) {
    console.error("PAST_PAPER_DETAIL_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load past paper.", 500);
  }
}
