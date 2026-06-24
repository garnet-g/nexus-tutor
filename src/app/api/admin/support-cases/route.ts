import "server-only";

import { NextResponse } from "next/server";

import {
  adminSupportCaseCreateSchema,
  adminSupportCaseStatusSchema,
  adminSupportCaseUpdateSchema,
} from "@/schemas/adminOpsSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createSupportCase,
  listSupportCases,
  updateSupportCase,
} from "@/server/services/adminOpsService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const statusValue = searchParams.get("status") ?? undefined;
    const parsedStatus = statusValue
      ? adminSupportCaseStatusSchema.safeParse(statusValue)
      : null;

    if (parsedStatus && !parsedStatus.success) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "VALIDATION_ERROR", message: "Invalid status filter." },
        },
        { status: 400 },
      );
    }

    const cases = await listSupportCases({
      status: parsedStatus?.success ? parsedStatus.data : undefined,
      limit: 100,
    });
    return NextResponse.json({ success: true, data: { cases } });
  } catch (error) {
    console.error("ADMIN_SUPPORT_CASES_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load support cases." },
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

    const body = await request.json();
    const parsed = adminSupportCaseCreateSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid support case body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const supportCase = await createSupportCase({
      case: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "support_case.create",
      targetType: "admin_support_case",
      targetId: supportCase.id,
      metadata: {
        title: supportCase.title,
        issueType: supportCase.issueType,
        priority: supportCase.priority,
        targetStudentId: supportCase.targetStudentId,
        targetParentId: supportCase.targetParentId,
      },
      request,
    });

    return NextResponse.json(
      { success: true, data: { case: supportCase } },
      { status: 201 },
    );
  } catch (error) {
    console.error("ADMIN_SUPPORT_CASES_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create support case." },
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

    const body = await request.json();
    const parsed = adminSupportCaseUpdateSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid support case update.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const supportCase = await updateSupportCase({
      update: parsed.data,
      actorUserId: auth.userId,
    });
    if (!supportCase) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Support case not found." },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "support_case.update",
      targetType: "admin_support_case",
      targetId: supportCase.id,
      metadata: {
        status: supportCase.status,
        priority: supportCase.priority,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { case: supportCase } });
  } catch (error) {
    console.error("ADMIN_SUPPORT_CASES_PATCH_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not update support case." },
      },
      { status: 500 },
    );
  }
}
