import "server-only";

import { NextResponse } from "next/server";

import {
  adminAlertCreateSchema,
  adminAlertStatusSchema,
  adminAlertUpdateSchema,
} from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createAdminAlert,
  listAdminAlerts,
  updateAdminAlert,
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
    const statusValue = searchParams.get("status") ?? undefined;
    const parsedStatus = statusValue
      ? adminAlertStatusSchema.safeParse(statusValue)
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

    const alerts = await listAdminAlerts(
      parsedStatus?.success ? parsedStatus.data : undefined,
    );
    return NextResponse.json({ success: true, data: { alerts } });
  } catch (error) {
    console.error("ADMIN_ALERTS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load alerts." },
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

    const parsed = adminAlertCreateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid alert body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const alert = await createAdminAlert({
      alert: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_alert.create",
      targetType: "admin_alert",
      targetId: alert.id,
      metadata: {
        alertType: alert.alertType,
        severity: alert.severity,
        source: alert.source,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { alert } }, { status: 201 });
  } catch (error) {
    console.error("ADMIN_ALERTS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create alert." },
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

    const parsed = adminAlertUpdateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid alert update.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const alert = await updateAdminAlert({
      update: parsed.data,
      actorUserId: auth.userId,
    });
    if (!alert) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Alert not found." },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_alert.update",
      targetType: "admin_alert",
      targetId: alert.id,
      metadata: { status: alert.status, severity: alert.severity },
      request,
    });

    return NextResponse.json({ success: true, data: { alert } });
  } catch (error) {
    console.error("ADMIN_ALERTS_PATCH_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not update alert." },
      },
      { status: 500 },
    );
  }
}
