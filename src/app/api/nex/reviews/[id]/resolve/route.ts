import "server-only";

import { NextResponse } from "next/server";

import { enforceSameOrigin } from "@/lib/security/originCheck";
import { createClient } from "@/lib/supabase/server";
import { resolveMisconceptionReview } from "@/server/services/misconceptionService";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(request: Request, context: RouteContext) {
  try {
    const originError = enforceSameOrigin(request);
    if (originError) {
      return originError;
    }

    const { id } = await context.params;
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { success: false, error: { code: "UNAUTHORIZED", message: "Missing or invalid session." } },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("id")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        { success: false, error: { code: "FORBIDDEN", message: "Student profile required." } },
        { status: 403 },
      );
    }

    await resolveMisconceptionReview(studentProfile.id, id);

    return NextResponse.json({ success: true, data: { resolved: true } });
  } catch (error) {
    console.error("NEX_REVIEW_RESOLVE_FAILED", error);
    return NextResponse.json(
      { success: false, error: { code: "INTERNAL_ERROR", message: "Could not resolve review." } },
      { status: 500 },
    );
  }
}
