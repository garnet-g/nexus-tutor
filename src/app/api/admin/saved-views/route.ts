import "server-only";

import { NextResponse } from "next/server";

import { adminSavedViewCreateSchema } from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createSavedView,
  listSavedViews,
} from "@/server/services/adminPlatformService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const views = await listSavedViews();
    return NextResponse.json({ success: true, data: { views } });
  } catch (error) {
    console.error("ADMIN_SAVED_VIEWS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load saved views." },
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

    const parsed = adminSavedViewCreateSchema.safeParse(await request.json());
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid saved view body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const view = await createSavedView({
      view: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_saved_view.create",
      targetType: "admin_saved_view",
      targetId: view.id,
      metadata: {
        viewKey: view.viewKey,
        route: view.route,
        isShared: view.isShared,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { view } }, { status: 201 });
  } catch (error) {
    console.error("ADMIN_SAVED_VIEWS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create saved view." },
      },
      { status: 500 },
    );
  }
}
