import "server-only";

import { notFound } from "next/navigation";

import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";
import type { FeatureKey } from "@/lib/admin/featureRegistry";
import { isFeatureEnabled } from "@/server/services/featureRolloutService";

export async function requireStudentFeature(featureKey: FeatureKey) {
  const experience = await requireStudentExperience();
  const enabled = await isFeatureEnabled(featureKey, {
    studentId: experience.profile.id,
    curriculum: experience.profile.curriculum,
    gradeLevel: experience.profile.grade_level,
    role: "student",
  });

  if (!enabled) {
    notFound();
  }

  return experience;
}
