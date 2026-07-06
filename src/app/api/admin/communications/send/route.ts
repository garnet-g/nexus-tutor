import "server-only";

import { NextResponse } from "next/server";

import {
  previewOperationalTemplateSend,
  sendOperationalTemplate,
  adminCommunicationPreviewSchema,
  adminCommunicationSendSchema,
} from "@/server/services/adminCommunicationsService";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const mode = typeof body.mode === "string" ? body.mode : "send";

    if (mode === "preview") {
      const parsed = adminCommunicationPreviewSchema.safeParse(body);
      if (!parsed.success) {
        return NextResponse.json(
          {
            success: false,
            error: {
              code: "VALIDATION_ERROR",
              message: "Invalid preview body.",
              details: parsed.error.flatten(),
            },
          },
          { status: 400 },
        );
      }

      const preview = await previewOperationalTemplateSend(parsed.data);
      return NextResponse.json({ success: true, data: { preview } });
    }

    const parsed = adminCommunicationSendSchema.safeParse(body);
    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid send body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const result = await sendOperationalTemplate({
      send: parsed.data,
      actorUserId: auth.userId,
    });

    if (!result.idempotentReplay) {
      await recordAdminAudit({
        actorUserId: auth.userId,
        actorRole: auth.role,
        action: "admin_communication.send",
        targetType: "admin_communication_template",
        targetId: parsed.data.templateKey,
        metadata: {
          templateKey: parsed.data.templateKey,
          idempotencyKey: parsed.data.idempotencyKey,
          recipientCount: result.recipientCount,
          sent: result.sent,
          failed: result.failed,
        },
        request,
      });
    }

    return NextResponse.json({ success: true, data: { result } });
  } catch (error) {
    console.error("ADMIN_COMMUNICATIONS_SEND_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message:
            error instanceof Error
              ? error.message
              : "Could not send communication.",
        },
      },
      { status: 500 },
    );
  }
}
