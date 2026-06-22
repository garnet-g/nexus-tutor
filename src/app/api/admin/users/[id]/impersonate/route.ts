import "server-only";

import { NextResponse } from "next/server";

import { createAdminClient } from "@/lib/supabase/admin";
import { impersonationStartSchema } from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  endImpersonation,
  startImpersonation,
} from "@/server/services/adminImpersonationService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function POST(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    // SENSITIVE: starting a view-as session is super_admin only.
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const { id: studentId } = await context.params;

    const body = await request.json();
    const parsed = impersonationStartSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "A reason is required to start a view-as session.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const admin = createAdminClient();
    const { data: student, error: studentError } = await admin
      .from("student_profiles")
      .select("id")
      .eq("id", studentId)
      .maybeSingle();

    if (studentError) {
      throw new Error(studentError.message);
    }
    if (!student) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Student not found." },
        },
        { status: 404 },
      );
    }

    const session = await startImpersonation({
      adminUserId: auth.userId,
      targetStudentId: studentId,
      reason: parsed.data.reason,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "user.impersonate.start",
      targetType: "student",
      targetId: studentId,
      metadata: { targetStudentId: studentId, sessionId: session.id },
      request,
    });

    return NextResponse.json({
      success: true,
      data: {
        sessionId: session.id,
        expiresAt: session.expiresAt,
        viewUrl: `/admin/users/${studentId}/view?session=${session.id}`,
      },
    });
  } catch (error) {
    console.error("ADMIN_USER_IMPERSONATE_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not start view-as session.",
        },
      },
      { status: 500 },
    );
  }
}

export async function DELETE(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const { id: studentId } = await context.params;

    const { searchParams } = new URL(request.url);
    const sessionId = searchParams.get("session");

    if (!sessionId) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "A session id is required to end a view-as session.",
          },
        },
        { status: 400 },
      );
    }

    const session = await endImpersonation(sessionId, auth.userId);

    if (!session) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "NOT_FOUND",
            message: "No active view-as session to end.",
          },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "user.impersonate.end",
      targetType: "student",
      targetId: studentId,
      metadata: { targetStudentId: studentId, sessionId: session.id },
      request,
    });

    return NextResponse.json({
      success: true,
      data: { sessionId: session.id, endedAt: session.endedAt },
    });
  } catch (error) {
    console.error("ADMIN_USER_IMPERSONATE_DELETE_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not end view-as session.",
        },
      },
      { status: 500 },
    );
  }
}
