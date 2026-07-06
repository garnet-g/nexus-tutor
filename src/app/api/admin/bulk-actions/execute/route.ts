import "server-only";

import { NextResponse } from "next/server";

import { adminBulkActionExecuteSchema } from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  BulkActionExecutionError,
  executeApprovedBulkAction,
} from "@/server/services/adminBulkActionsService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const parsed = adminBulkActionExecuteSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid bulk execution body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const result = await executeApprovedBulkAction({
      approvalId: parsed.data.approvalId,
      actorUserId: auth.userId,
    });

    if (!result.idempotentReplay) {
      await recordAdminAudit({
        actorUserId: auth.userId,
        actorRole: auth.role,
        action: "admin_bulk_action.execute",
        targetType: "admin_approval_request",
        targetId: parsed.data.approvalId,
        metadata: {
          command: result.command,
          affectedCount: result.affectedCount,
          succeeded: result.succeeded,
          failed: result.failed,
        },
        request,
      });
    }

    return NextResponse.json({ success: true, data: { result } });
  } catch (error) {
    if (error instanceof BulkActionExecutionError) {
      const status =
        error.code === "NOT_FOUND"
          ? 404
          : error.code === "VALIDATION_ERROR"
            ? 400
            : 403;
      return NextResponse.json(
        {
          success: false,
          error: { code: error.code, message: error.message },
        },
        { status },
      );
    }

    console.error("ADMIN_BULK_ACTION_EXECUTE_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not execute bulk action.",
        },
      },
      { status: 500 },
    );
  }
}
