import "server-only";

import { NextResponse } from "next/server";

import {
  createFlagSchema,
  nexReviewQuerySchema,
} from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createAdminFlag,
  listFlags,
} from "@/server/services/adminNexReviewService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = nexReviewQuerySchema.safeParse({
      status: searchParams.get("status") ?? undefined,
      limit: searchParams.get("limit") ?? undefined,
      before: searchParams.get("before") ?? undefined,
    });

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid query parameters.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const flags = await listFlags(parsed.data);
    return NextResponse.json({ success: true, data: { flags } });
  } catch (error) {
    console.error("ADMIN_NEX_FLAGS_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not load Nex flags.",
        },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = createFlagSchema.safeParse(body);

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

    const flag = await createAdminFlag(parsed.data);

    if (!flag) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "NOT_FOUND",
            message: "Could not create flag for this message.",
          },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "nex_flag.create",
      targetType: "nex_message_flag",
      targetId: flag.id,
      metadata: {
        flagId: flag.id,
        messageId: flag.messageId,
        studentId: flag.studentId,
        reason: flag.reason,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { flag } }, { status: 201 });
  } catch (error) {
    console.error("ADMIN_NEX_FLAGS_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not create Nex flag.",
        },
      },
      { status: 500 },
    );
  }
}
