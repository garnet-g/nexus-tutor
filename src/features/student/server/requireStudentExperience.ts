import "server-only";

import { redirect } from "next/navigation";

import { getSessionUser } from "@/server/services/authService";
import { getStudentExperienceData } from "@/server/services/studentExperienceService";

export async function requireStudentExperience() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  return getStudentExperienceData(profile);
}
