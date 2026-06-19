"use server";

import { redirect } from "next/navigation";

import { onboardingSchema } from "@/schemas/authSchemas";
import { createClient } from "@/lib/supabase/server";
import {
  getPostAuthRedirectPath,
  getSessionUser,
} from "@/server/services/authService";

export type OnboardingActionState = {
  error?: string;
  success?: boolean;
};

export async function completeOnboardingAction(
  _prevState: OnboardingActionState,
  formData: FormData,
): Promise<OnboardingActionState> {
  const sessionUser = await getSessionUser();

  if (!sessionUser || sessionUser.role !== "student") {
    return { error: "You must be signed in as a student to complete onboarding." };
  }

  const parsed = onboardingSchema.safeParse({
    curriculum: formData.get("curriculum"),
    gradeLevel: formData.get("gradeLevel"),
    schoolName: formData.get("schoolName") ?? "",
    targetGrade: formData.get("targetGrade"),
  });

  if (!parsed.success) {
    return {
      error: parsed.error.issues[0]?.message ?? "Invalid onboarding data",
    };
  }

  const { curriculum, gradeLevel, schoolName, targetGrade } = parsed.data;
  const supabase = await createClient();

  const { error } = await supabase
    .from("student_profiles")
    .update({
      curriculum,
      grade_level: gradeLevel,
      school_name: schoolName || null,
      target_grade: targetGrade,
    })
    .eq("user_id", sessionUser.id);

  if (error) {
    return { error: error.message };
  }

  redirect(getPostAuthRedirectPath({
    ...sessionUser,
    studentProfile: sessionUser.studentProfile
      ? {
          ...sessionUser.studentProfile,
          curriculum,
          grade_level: gradeLevel,
          school_name: schoolName || null,
          target_grade: targetGrade,
        }
      : null,
  }));
}
