import "server-only";

import { NextResponse } from "next/server";

import {
  adminApprovalCreateSchema,
  adminApprovalUpdateSchema,
} from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createApproval,
  listApprovals,
  updateApproval,
} from "@/server/services/adminPlatformService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const status = searchParams.get("status") ?? undefined;
    const approvals =
      status === "pending" ||
      status === "approved" ||
      status === "rejected" ||
      status === "cancelled"
        ? await listApprovals(status)
        : await listApprovals();
    return NextResponse.json({ success: true, data: { approvals } });
  } catch (error) {
    console.error("ADMIN_APPROVALS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load approvals." },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const parsed = adminApprovalCreateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid approval body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const approval = await createApproval({
      approval: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_approval.create",
      targetType: "admin_approval_request",
      targetId: approval.id,
      metadata: {
        requestType: approval.requestType,
        targetType: approval.targetType,
        targetId: approval.targetId,
      },
      request,
    });

    return NextResponse.json(
      { success: true, data: { approval } },
      { status: 201 },
    );
  } catch (error) {
    console.error("ADMIN_APPROVALS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create approval." },
      },
      { status: 500 },
    );
  }
}

export async function PATCH(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const parsed = adminApprovalUpdateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid approval update.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const approval = await updateApproval({
      update: parsed.data,
      actorUserId: auth.userId,
    });
    if (!approval) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Approval not found." },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_approval.update",
      targetType: "admin_approval_request",
      targetId: approval.id,
      metadata: { status: approval.status, requestType: approval.requestType },
      request,
    });

    return NextResponse.json({ success: true, data: { approval } });
  } catch (error) {
    console.error("ADMIN_APPROVALS_PATCH_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not update approval." },
      },
      { status: 500 },
    );
  }
}
