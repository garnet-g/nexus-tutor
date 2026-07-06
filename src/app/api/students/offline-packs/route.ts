import "server-only";

import { NextResponse } from "next/server";

import {
  offlinePackSchema,
  offlinePackUpdateSchema,
} from "@/schemas/studentExperienceSchemas";
import {
  apiErrorResponse,
  requireStudentProfile,
} from "@/server/services/studentContext";
import { requireStudentFeatureApi } from "@/server/services/studentFeatureGuard";
import {
  listOfflinePacks,
  updateOfflinePackStatus,
  upsertOfflinePack,
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

    const featureError = await requireStudentFeatureApi(
      studentContext.profile,
      "student.offline_packs",
    );
    if (featureError) {
      return featureError;
    }

    const packs = await listOfflinePacks(studentContext.profile.id);
    return NextResponse.json({ success: true, data: { packs } });
  } catch (error) {
    console.error("STUDENT_OFFLINE_PACKS_GET_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not load offline packs.", 500);
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

    const featureError = await requireStudentFeatureApi(
      studentContext.profile,
      "student.offline_packs",
    );
    if (featureError) {
      return featureError;
    }

    const parsed = offlinePackSchema.safeParse(await request.json().catch(() => ({})));
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid offline pack.",
        400,
        parsed.error.flatten(),
      );
    }

    const pack = await upsertOfflinePack(studentContext.profile.id, parsed.data);
    return NextResponse.json({ success: true, data: { pack } }, { status: 201 });
  } catch (error) {
    console.error("STUDENT_OFFLINE_PACKS_POST_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not save offline pack.", 500);
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

    const featureError = await requireStudentFeatureApi(
      studentContext.profile,
      "student.offline_packs",
    );
    if (featureError) {
      return featureError;
    }

    const parsed = offlinePackUpdateSchema.safeParse(
      await request.json().catch(() => ({})),
    );
    if (!parsed.success) {
      return apiErrorResponse(
        "VALIDATION_ERROR",
        "Invalid offline pack update.",
        400,
        parsed.error.flatten(),
      );
    }

    const pack = await updateOfflinePackStatus(
      studentContext.profile.id,
      parsed.data.id,
      parsed.data.status,
    );
    return NextResponse.json({ success: true, data: { pack } });
  } catch (error) {
    console.error("STUDENT_OFFLINE_PACKS_PATCH_FAILED", error);
    return apiErrorResponse("INTERNAL_ERROR", "Could not update offline pack.", 500);
  }
}
