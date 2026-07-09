import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { getDueMisconceptionReviews } from "@/server/services/misconceptionService";

export async function GET(_request: Request) {
  try {
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

    const reviews = await getDueMisconceptionReviews(studentProfile.id);

    return NextResponse.json({ success: true, data: reviews });
  } catch (error) {
    console.error("NEX_REVIEWS_DUE_FAILED", error);
    return NextResponse.json(
      { success: false, error: { code: "INTERNAL_ERROR", message: "Could not load reviews." } },
      { status: 500 },
    );
  }
}
