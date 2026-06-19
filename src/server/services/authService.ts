import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import { createClient } from "@/lib/supabase/server";
import { learningPreferencesToDb } from "@/schemas/profileSchemas";
import type {
  ParentProfile,
  SessionUser,
  StudentProfile,
  UserRole,
} from "@/types/database";

function getRoleFromAppMetadata(
  appMetadata: Record<string, unknown> | undefined,
): UserRole | null {
  const role = appMetadata?.userRole;

  if (role === "student" || role === "parent" || role === "super_admin") {
    return role;
  }

  return null;
}

export async function getSessionUser(): Promise<SessionUser | null> {
  try {
    const supabase = await createClient();
    const authResult = await Promise.race([
      supabase.auth.getUser(),
      new Promise<{ data: { user: null }; error: Error }>((resolve) => {
        setTimeout(
          () =>
            resolve({
              data: { user: null },
              error: new Error("Auth session lookup timed out"),
            }),
          5_000,
        );
      }),
    ]);

    const {
      data: { user },
      error,
    } = authResult;

    if (error || !user) {
      return null;
    }

  const role = getRoleFromAppMetadata(user.app_metadata);

  if (!role) {
    return null;
  }

  let studentProfile: StudentProfile | null = null;
  let parentProfile: ParentProfile | null = null;

  if (role === "student") {
    const { data } = await supabase
      .from("student_profiles")
      .select("*")
      .eq("user_id", user.id)
      .maybeSingle();

    studentProfile = (data as StudentProfile | null) ?? null;
  }

  if (role === "parent") {
    const { data } = await supabase
      .from("parent_profiles")
      .select("*")
      .eq("user_id", user.id)
      .maybeSingle();

    parentProfile = (data as ParentProfile | null) ?? null;
  }

  return {
    id: user.id,
    email: user.email ?? null,
    role,
    studentProfile,
    parentProfile,
  };
  } catch {
    return null;
  }
}

export async function setUserRole(
  userId: string,
  role: Exclude<UserRole, "super_admin">,
): Promise<void> {
  const admin = createAdminClient();
  const { error } = await admin.auth.admin.updateUserById(userId, {
    app_metadata: { userRole: role },
  });

  if (error) {
    throw new Error(error.message);
  }
}

export async function createStudentProfile(input: {
  userId: string;
  fullName: string;
  email: string;
}): Promise<StudentProfile> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("student_profiles")
    .insert({
      user_id: input.userId,
      full_name: input.fullName,
      email: input.email,
      curriculum: "CBC",
      grade_level: "",
      learning_preferences: learningPreferencesToDb({
        explanationDepth: "standard",
        sessionGoalMinutes: 20,
        reminderChannel: "off",
      }),
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Failed to create student profile");
  }

  return data as StudentProfile;
}

export async function createParentProfile(input: {
  userId: string;
  fullName: string;
  email: string;
}): Promise<ParentProfile> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("parent_profiles")
    .insert({
      user_id: input.userId,
      full_name: input.fullName,
      email: input.email,
    })
    .select("*")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Failed to create parent profile");
  }

  return data as ParentProfile;
}

export function isStudentOnboardingComplete(
  profile: StudentProfile | null | undefined,
): boolean {
  if (!profile) {
    return false;
  }

  return profile.grade_level.trim().length > 0;
}

export function getPostAuthRedirectPath(sessionUser: SessionUser): string {
  switch (sessionUser.role) {
    case "super_admin":
      return "/admin/platform-settings";
    case "parent":
      return "/parent";
    case "student":
      if (!isStudentOnboardingComplete(sessionUser.studentProfile)) {
        return "/onboarding";
      }

      if (!sessionUser.studentProfile?.has_completed_diagnostic) {
        return "/diagnostic";
      }

      return "/dashboard";
    default:
      return "/login";
  }
}
