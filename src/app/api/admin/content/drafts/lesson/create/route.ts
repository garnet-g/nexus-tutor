import "server-only";

import { NextResponse } from "next/server";

import { createManualDraftLessonRequestSchema } from "@/schemas/contentGenerationSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { createManualDraftLesson } from "@/server/services/contentGenerationService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

function mapServiceError(error: unknown): { status: number; code: string; message: string } {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  if (message === "NOT_FOUND") {
    return { status: 404, code: "NOT_FOUND", message: "Subtopic not found." };
  }

  if (message === "SCOPE_VIOLATION") {
    return {
      status: 400,
      code: "SCOPE_VIOLATION",
      message: "This subject is outside the active generation scope.",
    };
  }

  return { status: 500, code: "INTERNAL_ERROR", message };
}

export async function POST(request: Request) {
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

  const parsed = createManualDraftLessonRequestSchema.safeParse(body);
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
    const result = await createManualDraftLesson(parsed.data, auth.userId);
    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: "super_admin",
      action: "content.lesson_draft.create",
      targetType: "draft_lesson",
      targetId: result.lessonId,
      metadata: {
        lessonId: result.lessonId,
        subtopicId: result.subtopicId,
        title: result.title,
      },
    });
    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    const mapped = mapServiceError(error);
    return NextResponse.json(
      {
        success: false,
        error: { code: mapped.code, message: mapped.message },
      },
      { status: mapped.status },
    );
  }
}
