import "server-only";

import { NextResponse } from "next/server";

import { adminCommunicationTemplateCreateSchema } from "@/schemas/adminPlatformSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createCommunicationTemplate,
  listCommunicationLogs,
  listCommunicationTemplates,
} from "@/server/services/adminPlatformService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const [templates, logs] = await Promise.all([
      listCommunicationTemplates(),
      listCommunicationLogs(),
    ]);
    return NextResponse.json({ success: true, data: { templates, logs } });
  } catch (error) {
    console.error("ADMIN_COMMUNICATIONS_GET_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not load communications.",
        },
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

    const parsed = adminCommunicationTemplateCreateSchema.safeParse(
      await request.json(),
    );
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid template body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const template = await createCommunicationTemplate({
      template: parsed.data,
      actorUserId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "admin_communication_template.create",
      targetType: "admin_communication_template",
      targetId: template.id,
      metadata: {
        templateKey: template.templateKey,
        channel: template.channel,
      },
      request,
    });

    return NextResponse.json(
      { success: true, data: { template } },
      { status: 201 },
    );
  } catch (error) {
    console.error("ADMIN_COMMUNICATIONS_POST_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not create template." },
      },
      { status: 500 },
    );
  }
}
