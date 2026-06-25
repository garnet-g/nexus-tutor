import "server-only";

import { NextResponse } from "next/server";

import {
  mistakeJournalCreateSchema,
  mistakeJournalUpdateSchema,
} from "@/schemas/studentExperienceSchemas";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import {
  addMistake,
  listMistakes,
  updateMistakeStatus,
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

    const mistakes = await listMistakes(studentContext.profile.id);
    return NextResponse.json({ success: true, data: { mistakes } });
  } catch (error) {
    console.error("STUDENT_MISTAKES_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load mistakes.", 500);
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

    const parsed = mistakeJournalCreateSchema.safeParse(
      await request.json().catch(() => ({})),
    );
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid mistake entry.",
        400,
        parsed.error.flatten(),
      );
    }

    const mistake = await addMistake(studentContext.profile.id, parsed.data);
    return NextResponse.json({ success: true, data: { mistake } }, { status: 201 });
  } catch (error) {
    console.error("STUDENT_MISTAKES_POST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not save mistake.", 500);
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

    const parsed = mistakeJournalUpdateSchema.safeParse(
      await request.json().catch(() => ({})),
    );
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid mistake update.",
        400,
        parsed.error.flatten(),
      );
    }

    const mistake = await updateMistakeStatus(
      studentContext.profile.id,
      parsed.data.id,
      parsed.data.status,
    );
    return NextResponse.json({ success: true, data: { mistake } });
  } catch (error) {
    console.error("STUDENT_MISTAKES_PATCH_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not update mistake.", 500);
  }
}
