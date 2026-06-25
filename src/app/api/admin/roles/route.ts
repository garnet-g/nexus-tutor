import "server-only";

import { NextResponse } from "next/server";

import { adminRoleAssignmentSchema } from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  assignAdminRole,
  listAdminRoleAssignments,
} from "@/server/services/adminPlatformService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const assignments = await listAdminRoleAssignments();
    return NextResponse.json({ success: true, data: { assignments } });
  } catch (error) {
    console.error("ADMIN_ROLES_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load roles." },
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

    const parsed = adminRoleAssignmentSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid role assignment.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const assignment = await assignAdminRole({
      assignment: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_role.assign",
      targetType: "admin_role_assignment",
      targetId: assignment.id,
      metadata: {
        userId: assignment.userId,
        roleKey: assignment.roleKey,
      },
      request,
    });

    return NextResponse.json(
      { success: true, data: { assignment } },
      { status: 201 },
    );
  } catch (error) {
    console.error("ADMIN_ROLES_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not assign role." },
      },
      { status: 500 },
    );
  }
}
