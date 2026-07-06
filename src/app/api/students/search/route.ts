import "server-only";

import { NextResponse } from "next/server";

import { searchStudentContent } from "@/server/services/studentSearchService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import { isFeatureEnabled } from "@/server/services/featureRolloutService";

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

    const enabled = await isFeatureEnabled("student.study_search", {
      studentId: studentContext.profile.id,
      curriculum: studentContext.profile.curriculum,
      gradeLevel: studentContext.profile.grade_level,
      role: "student",
    });

    if (!enabled) {
      return apiErrorResponse("FEATURE_DISABLED", "Study search is not available yet.", 404);
    }

    const query = new URL(request.url).searchParams.get("q") ?? "";
    const hits = await searchStudentContent(studentContext.profile, query);
    return NextResponse.json({ success: true, data: { hits, query } });
  } catch (error) {
    console.error("STUDENT_SEARCH_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not search study content.", 500);
  }
}
