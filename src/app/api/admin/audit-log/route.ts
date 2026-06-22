import "server-only";

import { NextResponse } from "next/server";

import { auditLogQuerySchema } from "@/schemas/adminSchemas";
import { listAdminAuditLog } from "@/server/services/adminAuditService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = auditLogQuerySchema.safeParse({
      action: searchParams.get("action") ?? undefined,
      actorUserId: searchParams.get("actorUserId") ?? undefined,
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

    const entries = await listAdminAuditLog({
      action: parsed.data.action,
      actorUserId: parsed.data.actorUserId,
      limit: parsed.data.limit,
      before: parsed.data.before,
    });

    return NextResponse.json({ success: true, data: { entries } });
  } catch (error) {
    console.error("ADMIN_AUDIT_LOG_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load audit log." },
      },
      { status: 500 },
    );
  }
}
