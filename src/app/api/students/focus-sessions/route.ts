import "server-only";

import { NextResponse } from "next/server";

import {
  focusSessionCreateSchema,
  focusSessionUpdateSchema,
} from "@/schemas/studentExperienceSchemas";
import {
  FocusSessionConflictError,
  FocusSessionInsufficientElapsedError,
} from "@/server/services/focusSessionService";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import {
  createFocusSession,
  listFocusSessions,
  updateFocusSessionStatus,
} from "@/server/services/focusSessionService";

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

    const sessions = await listFocusSessions(studentContext.profile.id);
    return NextResponse.json({ success: true, data: { sessions } });
  } catch (error) {
    console.error("STUDENT_FOCUS_SESSIONS_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load focus sessions.", 500);
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

    const parsed = focusSessionCreateSchema.safeParse(
      await request.json().catch(() => ({})),
    );
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid focus session.",
        400,
        parsed.error.flatten(),
      );
    }

    const session = await createFocusSession(studentContext.profile.id, parsed.data);
    return NextResponse.json({ success: true, data: { session } }, { status: 201 });
  } catch (error) {
    if (error instanceof FocusSessionConflictError) {
      return apiErrorResponse("FOCUS_SESSION_CONFLICT", error.message, 409);
    }

    console.error("STUDENT_FOCUS_SESSIONS_POST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not create focus session.", 500);
  }
}

export async function PATCH(request: Request) {
  try {
    const studentContext = await requireStudentProfile();
    if (!studentContext.ok) {
      return apiErrorResponse(
        studentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        studentContext.message,
        studentContext.status,
      );
    }

    const parsed = focusSessionUpdateSchema.safeParse(
      await request.json().catch(() => ({})),
    );
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid focus session update.",
        400,
        parsed.error.flatten(),
      );
    }

    const session = await updateFocusSessionStatus(
      studentContext.profile.id,
      parsed.data.id,
      parsed.data.status,
    );
    return NextResponse.json({ success: true, data: { session } });
  } catch (error) {
    if (error instanceof FocusSessionConflictError) {
      return apiErrorResponse("FOCUS_SESSION_CONFLICT", error.message, 409);
    }

    if (error instanceof FocusSessionInsufficientElapsedError) {
      return apiErrorResponse("FOCUS_INSUFFICIENT_ELAPSED", error.message, 400);
    }

    console.error("STUDENT_FOCUS_SESSIONS_PATCH_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not update focus session.", 500);
  }
}
