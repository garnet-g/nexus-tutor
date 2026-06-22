import "server-only";

import { NextResponse } from "next/server";

import { resolveFlagSchema } from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { resolveFlag } from "@/server/services/adminNexReviewService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const { id: flagId } = await context.params;
    const body = await request.json();
    const parsed = resolveFlagSchema.safeParse(body);

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

    const flag = await resolveFlag({
      flagId,
      status: parsed.data.status,
      notes: parsed.data.notes,
      resolvedBy: auth.userId,
    });

    if (!flag) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Nex flag not found." },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "nex_flag.resolve",
      targetType: "nex_message_flag",
      targetId: flag.id,
      metadata: {
        flagId: flag.id,
        status: flag.status,
        messageId: flag.messageId,
        studentId: flag.studentId,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { flag } });
  } catch (error) {
    console.error("ADMIN_NEX_FLAG_PATCH_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not update Nex flag.",
        },
      },
      { status: 500 },
    );
  }
}
