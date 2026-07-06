import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { parentLinkSchema } from "@/schemas/parentSchemas";
import { linkParentToStudent } from "@/server/services/parentLinkService";
import { sendParentLinkSuccessNotification } from "@/server/services/notificationService";

export async function POST(request: Request) {
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

    const { data: parentProfile, error: profileError } = await supabase
      .from("parent_profiles")
      .select("id, full_name, phone_number, email")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !parentProfile) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "FORBIDDEN",
            message: "Parent profile required.",
          },
        },
        { status: 403 },
      );
    }

    const body = await request.json();
    const parsed = parentLinkSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const linkResult = await linkParentToStudent(
      parentProfile.id,
      parsed.data.inviteCode,
    );

    await sendParentLinkSuccessNotification({
      parentId: parentProfile.id,
      studentId: linkResult.studentId,
      parentPhone: parentProfile.phone_number,
      studentName: linkResult.studentName,
    });

    return NextResponse.json({
      success: true,
      data: {
        studentId: linkResult.studentId,
        studentName: linkResult.studentName,
        linkedAt: linkResult.linkedAt,
      },
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Could not link student.";

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "LINK_FAILED",
          message,
        },
      },
      { status: 400 },
    );
  }
}
