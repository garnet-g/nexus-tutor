import "server-only";

import { createClient } from "@/lib/supabase/server";
import type { StudentProfile } from "@/types/database";

export type StudentContextResult =
  | {
      ok: true;
      supabase: Awaited<ReturnType<typeof createClient>>;
      profile: StudentProfile;
    }
  | {
      ok: false;
      status: 401 | 403;
      message: string;
    };

export async function requireStudentProfile(): Promise<StudentContextResult> {
  const supabase = await createClient();
  const {
    data: { user },
    error,
  } = await supabase.auth.getUser();

  if (error || !user) {
    return {
      ok: false,
      status: 401,
      message: "Missing or invalid session.",
    };
  }

  const { data: profile, error: profileError } = await supabase
    .from("student_profiles")
    .select("*")
    .eq("user_id", user.id)
    .maybeSingle();

  if (profileError || !profile) {
    return {
      ok: false,
      status: 403,
      message: "Student profile required.",
    };
  }

  return {
    ok: true,
    supabase,
    profile: profile as StudentProfile,
  };
}

export function apiErrorResponse(
  code: string,
  message: string,
  status: number,
  details?: unknown,
) {
  return Response.json(
    {
      success: false,
      error: {
        code,
        message,
        ...(details !== undefined ? { details } : {}),
      },
    },
    { status },
  );
}

export function apiSuccessResponse<T>(data: T, status = 200) {
  return Response.json(
    {
      success: true,
      data,
    },
    { status },
  );
}
