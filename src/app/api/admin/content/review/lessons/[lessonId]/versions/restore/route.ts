import "server-only";

import { NextResponse } from "next/server";

import { restoreLessonVersionRequestSchema } from "@/schemas/contentApprovalSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { restoreLessonVersion } from "@/server/services/contentApprovalService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

import { reviewErrorResponse } from "../../../../reviewRouteHelpers";

export async function POST(
  request: Request,
  context: { params: Promise<{ lessonId: string }> },
) {
  const auth = await requireContentAuthor();
  if (!auth.ok) {
    return NextResponse.json(
      {
        success: false,
        error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message },
      },
      { status: auth.status },
    );
  }

  const { lessonId } = await context.params;

  let body: unknown;
  try {
    body = await request.json();
  } catch {
    return NextResponse.json(
      {
        success: false,
        error: { code: "INVALID_JSON", message: "Request body must be valid JSON." },
      },
      { status: 400 },
    );
  }

  const parsed = restoreLessonVersionRequestSchema.safeParse({
    ...(typeof body === "object" && body ? body : {}),
    lessonId,
  });

  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: parsed.error.issues.map((issue) => issue.message).join("; "),
        },
      },
      { status: 400 },
    );
  }

  try {
    const result = await restoreLessonVersion({
      lessonId: parsed.data.lessonId,
      versionId: parsed.data.versionId,
      adminId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "content.version.restore",
      targetType: "lesson",
      targetId: parsed.data.lessonId,
      metadata: { versionId: parsed.data.versionId },
      request,
    });

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    return reviewErrorResponse(error);
  }
}
