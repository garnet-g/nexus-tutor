import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import {
  generateStudentInviteCode,
  getStudentInviteCode,
} from "@/server/services/parentLinkService";

export async function GET() {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "UNAUTHORIZED",
            message: "Missing or invalid session.",
          },
        },
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
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Student profile required.",
          },
        },
        { status: 403 },
      );
    }

    const existing = await getStudentInviteCode(studentProfile.id);

    if (existing.inviteCode && existing.expiresAt) {
      return NextResponse.json({
        success: true,
        data: {
          inviteCode: existing.inviteCode,
          expiresAt: existing.expiresAt,
        },
      });
    }

    const generated = await generateStudentInviteCode(studentProfile.id);

    return NextResponse.json({
      success: true,
      data: generated,
    });
  } catch (error) {
    console.error("INVITE_CODE_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not generate invite code.",
        },
      },
      { status: 500 },
    );
  }
}
