import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";

export type ParentAuthContext =
  | {
      ok: true;
      parentId: string;
      supabase: Awaited<ReturnType<typeof createClient>>;
    }
  | {
      ok: false;
      status: 401 | 403;
      message: string;
    };

export async function requireParentProfile(): Promise<ParentAuthContext> {
  const supabase = await createClient();
  const {
    data: { user },
    error: authError,
  } = await supabase.auth.getUser();

  if (authError || !user) {
    return {
      ok: false,
      status: 401,
      message: "Missing or invalid session.",
    };
  }

  const { data: parentProfile, error: profileError } = await supabase
    .from("parent_profiles")
    .select("id")
    .eq("user_id", user.id)
    .maybeSingle();

  if (profileError || !parentProfile) {
    return {
      ok: false,
      status: 403,
      message: "Parent profile required.",
    };
  }

  return {
    ok: true,
    parentId: String(parentProfile.id),
    supabase,
  };
}

export function parentApiError(
  status: 401 | 403 | 404,
  code: string,
  message: string,
) {
  return NextResponse.json(
    {
      success: false,
      error: { code, message },
    },
    { status },
  );
}
