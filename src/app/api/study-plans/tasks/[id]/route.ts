import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function PATCH(request: Request, context: RouteContext) {
  try {
    const { id: taskId } = await context.params;
    const studentContext = await requireStudentProfile();

    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const body = (await request.json().catch(() => ({}))) as {
      completed?: boolean;
    };
    const completed = Boolean(body.completed);
    const admin = createAdminClient();

    const { data: task, error: taskError } = await admin
      .from("study_tasks")
      .select("id, study_plan_id, study_plans!inner(student_id)")
      .eq("id", taskId)
      .maybeSingle();

    if (taskError || !task) {
      return apiErrorResponse("NOT_FOUND", "Study task not found.", 404);
    }

    const plan = task.study_plans as { student_id?: string } | null;
    if (plan?.student_id !== studentContext.profile.id) {
      return apiErrorResponse("FORBIDDEN", "Task does not belong to you.", 403);
    }

    const { error: updateError } = await admin
      .from("study_tasks")
      .update({
        is_completed: completed,
        completed_at: completed ? new Date().toISOString() : null,
      })
      .eq("id", taskId);

    if (updateError) {
      throw new Error(updateError.message);
    }

    return NextResponse.json({ success: true, data: { completed } });
  } catch (error) {
    console.error("STUDY_TASK_UPDATE_FAILED", error);

    return apiErrorResponse(
      "INTERNAL_ERROR",
      "Could not update study task.",
      500,
    );
  }
}
