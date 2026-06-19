import "server-only";

import { NextResponse } from "next/server";

import { studyPlanGenerateSchema } from "@/schemas/studyPlanSchemas";
import {
  generateStudyPlanForStudent,
  getActiveStudyPlan,
} from "@/server/services/studyPlanService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

export async function GET() {
  try {
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const plan = await getActiveStudyPlan(studentContext.profile.id);

    return NextResponse.json({
      success: true,
      data: { plan },
    });
  } catch (error) {
    console.error("STUDY_PLAN_GET_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not load study plan.",
      500,
    );
  }
}

export async function POST(request: Request) {
  try {
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    if (!studentContext.profile.has_completed_diagnostic) {
      return apiErrorResponse(
        "DIAGNOSTIC_NOT_COMPLETED",
        "Complete your diagnostic assessment before generating a study plan.",
        403,
      );
    }

    const body = await request.json().catch(() => ({}));
    const parsed = studyPlanGenerateSchema.safeParse(body);

    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid request body.",
        400,
        parsed.error.flatten(),
      );
    }

    const data = await generateStudyPlanForStudent(
      studentContext.profile,
      parsed.data,
    );

    return NextResponse.json(
      {
        success: true,
        data,
      },
      { status: 201 },
    );
  } catch (error) {
    console.error("STUDY_PLAN_GENERATE_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not generate study plan.",
      500,
    );
  }
}
