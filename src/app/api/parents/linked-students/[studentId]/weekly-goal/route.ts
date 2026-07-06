import "server-only";

import { NextResponse } from "next/server";

import { getParentWeeklyGoalForLinkedStudent } from "@/server/services/parentLinkService";
import { parentApiError, requireParentProfile } from "@/server/services/parentContext";

export async function GET(
  _request: Request,
  context: { params: Promise<{ studentId: string }> },
) {
  const parentContext = await requireParentProfile();

  if (!parentContext.ok) {
    return parentApiError(
      parentContext.status,
      parentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
      parentContext.message,
    );
  }

  const { studentId } = await context.params;
  const goal = await getParentWeeklyGoalForLinkedStudent(
    parentContext.parentId,
    studentId,
  );

  if (goal === "NOT_LINKED") {
    return parentApiError(
      404,
      "NOT_LINKED",
      "No active parent link for this student.",
    );
  }

  if (!goal) {
    return NextResponse.json({
      success: true,
      data: { weeklyGoal: null },
    });
  }

  return NextResponse.json({
    success: true,
    data: { weeklyGoal: goal },
  });
}
