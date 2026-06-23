import "server-only";

import { NextResponse } from "next/server";

import { bulkSaveTopicQuestionsRequestSchema } from "@/schemas/contentStudioSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { bulkSaveTopicQuestions } from "@/server/services/contentStudioService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function PATCH(
  request: Request,
  context: { params: Promise<{ topicId: string }> },
) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    return NextResponse.json(
      {
        success: false,
        error: { code: auth.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN", message: auth.message },
      },
      { status: auth.status },
    );
  }

  const { topicId } = await context.params;

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

  const parsed = bulkSaveTopicQuestionsRequestSchema.safeParse({
    ...(typeof body === "object" && body ? body : {}),
    topicId,
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
    const data = await bulkSaveTopicQuestions(parsed.data, auth.userId);
    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "content.questions.bulk_save",
      targetType: "topic",
      targetId: topicId,
      metadata: {
        topicId,
        createdCount: data.createdIds.length,
        updatedCount: data.updatedIds.length,
        archivedCount: data.archivedIds.length,
        errorCount: data.errors.length,
      },
    });

    return NextResponse.json({ success: true, data });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    const status = message === "NOT_FOUND" ? 404 : 500;
    return NextResponse.json(
      {
        success: false,
        error: { code: status === 404 ? "NOT_FOUND" : "INTERNAL_ERROR", message },
      },
      { status },
    );
  }
}
