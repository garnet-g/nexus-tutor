import "server-only";

import { NextResponse } from "next/server";

import {
  savedItemSchema,
} from "@/schemas/studentExperienceSchemas";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import {
  deleteSavedItem,
  deleteSavedItemByReference,
  listSavedItems,
  saveStudentItem,
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

    const items = await listSavedItems(studentContext.profile.id);
    return NextResponse.json({ success: true, data: { items } });
  } catch (error) {
    console.error("STUDENT_SAVED_ITEMS_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load saved items.", 500);
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

    const parsed = savedItemSchema.safeParse(await request.json().catch(() => ({})));
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid saved item.",
        400,
        parsed.error.flatten(),
      );
    }

    const item = await saveStudentItem(studentContext.profile.id, parsed.data);
    return NextResponse.json({ success: true, data: { item } }, { status: 201 });
  } catch (error) {
    console.error("STUDENT_SAVED_ITEMS_POST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not save item.", 500);
  }
}

export async function DELETE(request: Request) {
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
    const id = url.searchParams.get("id");
    const itemType = url.searchParams.get("itemType");
    const itemId = url.searchParams.get("itemId");

    if (itemType && itemId) {
      await deleteSavedItemByReference(
        studentContext.profile.id,
        itemType as "question" | "lesson" | "topic" | "note",
        itemId,
      );
      return NextResponse.json({ success: true, data: { deleted: true } });
    }

    if (!id) {
      return apiErrorResponse("VALIDATION_ERROR", "Saved item id is required.", 400);
    }

    await deleteSavedItem(studentContext.profile.id, id);
    return NextResponse.json({ success: true, data: { deleted: true } });
  } catch (error) {
    console.error("STUDENT_SAVED_ITEMS_DELETE_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not delete saved item.", 500);
  }
}
