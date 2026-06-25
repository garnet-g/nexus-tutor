import "server-only";

import { NextResponse } from "next/server";

import { weeklyGoalSchema } from "@/schemas/studentExperienceSchemas";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import {
  getWeeklyGoal,
  upsertWeeklyGoal,
} from "@/server/services/studentExperienceService";

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

    const goal = await getWeeklyGoal(studentContext.profile.id);
    return NextResponse.json({ success: true, data: { goal } });
  } catch (error) {
    console.error("STUDENT_WEEKLY_GOAL_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load weekly goal.", 500);
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

    const parsed = weeklyGoalSchema.safeParse(await request.json().catch(() => ({})));
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid weekly goal.",
        400,
        parsed.error.flatten(),
      );
    }

    const goal = await upsertWeeklyGoal(studentContext.profile.id, parsed.data);
    return NextResponse.json({ success: true, data: { goal } });
  } catch (error) {
    console.error("STUDENT_WEEKLY_GOAL_POST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not save weekly goal.", 500);
  }
}
