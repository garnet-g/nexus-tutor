import "server-only";

import { cache } from "react";

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

  if (
    role === "student" ||
    role === "parent" ||
    role === "super_admin" ||
    role === "support"
  ) {
    return role;
  }

  return null;
}

export const getSessionUser = cache(async (): Promise<SessionUser | null> => {
  try {
    const supabase = await createClient();
    const sessionResult = await supabase.auth.getSession();
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

    const accessToken = sessionResult.data.session?.access_token;
    if (accessToken) {
      const { validateSessionFreshness } = await import(
        "@/server/services/sessionFreshnessService"
      );
      const freshness = await validateSessionFreshness({
        userId: user.id,
        accessToken,
      });

      if (!freshness.ok) {
        return null;
      }
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
});

export async function setUserRole(
  userId: string,
  role: Exclude<UserRole, "super_admin">,
): Promise<void> {
  const admin = createAdminClient();
  const { data: existingUser, error: readError } =
    await admin.auth.admin.getUserById(userId);

  if (readError) {
    throw new Error(readError.message);
  }

  const previousRole = getRoleFromAppMetadata(
    existingUser.user?.app_metadata as Record<string, unknown> | undefined,
  );
  const existingMetadata =
    (existingUser.user?.app_metadata as Record<string, unknown> | undefined) ??
    {};
  const sessionVersion =
    typeof existingMetadata.sessionVersion === "number"
      ? existingMetadata.sessionVersion
      : 1;

  const { error } = await admin.auth.admin.updateUserById(userId, {
    app_metadata: {
      ...existingMetadata,
      userRole: role,
      sessionVersion,
    },
  });

  if (error) {
    throw new Error(error.message);
  }

  if (previousRole && previousRole !== role) {
    const { revokeAllSessions } = await import(
      "@/server/services/sessionRevocationService"
    );
    await revokeAllSessions(userId, `role_changed:${previousRole}->${role}`);
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
      return "/admin";
    case "support":
      return "/admin/support";
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
