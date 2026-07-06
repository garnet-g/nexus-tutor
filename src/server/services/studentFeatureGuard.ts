import "server-only";

import { NextResponse } from "next/server";

import { isFeatureEnabled } from "@/server/services/featureRolloutService";
import type { StudentProfile } from "@/types/database";

export async function requireStudentFeatureApi(
  profile: StudentProfile,
  featureKey: "student.offline_packs" | "student.study_search" | "student.concept_library",
): Promise<NextResponse | null> {
  const enabled = await isFeatureEnabled(featureKey, {
    studentId: profile.id,
    curriculum: profile.curriculum,
    gradeLevel: profile.grade_level,
    role: "student",
  });

  if (!enabled) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "FEATURE_DISABLED",
          message: "This feature is not available for your account yet.",
        },
      },
      { status: 404 },
    );
  }

  return null;
}
