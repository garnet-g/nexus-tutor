import "server-only";

import { NextResponse } from "next/server";

import { updateDraftLessonRequestSchema } from "@/schemas/contentGenerationSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { updateDraftLesson } from "@/server/services/contentGenerationService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

function mapServiceError(error: unknown): { status: number; code: string; message: string } {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  if (message === "NOT_FOUND") {
    return { status: 404, code: "NOT_FOUND", message: "Draft lesson not found." };
  }

  if (message === "CONFLICT") {
    return {
      status: 409,
      code: "CONFLICT",
      message: "Only draft lessons can be edited.",
    };
  }

  return { status: 500, code: "INTERNAL_ERROR", message };
}

export async function PATCH(request: Request) {
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

  const parsed = updateDraftLessonRequestSchema.safeParse(body);
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
    const result = await updateDraftLesson(parsed.data);
    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "content.lesson_draft.update",
      targetType: "draft_lesson",
      targetId: parsed.data.id,
      metadata: {
        lessonId: parsed.data.id,
        title: parsed.data.title,
        blockCount: parsed.data.blocks.length,
        quizQuestionCount: parsed.data.shortQuiz?.questions.length ?? 0,
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
