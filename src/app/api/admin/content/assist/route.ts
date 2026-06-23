import "server-only";

import { NextResponse } from "next/server";

import { contentAssistRequestSchema } from "@/schemas/contentAssistSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { runContentAssist } from "@/server/services/contentAssistService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

function mapAssistError(error: unknown): { status: number; code: string; message: string } {
  const message = error instanceof Error ? error.message : "Unexpected error.";

  if (message === "NOT_FOUND") {
    return { status: 404, code: "NOT_FOUND", message: "Scope or block not found." };
  }

  if (message === "SCOPE_VIOLATION") {
    return {
      status: 403,
      code: "SCOPE_VIOLATION",
      message: "Subject is outside the active generation scope.",
    };
  }

  if (message === "CURRICULUM_MISMATCH") {
    return {
      status: 400,
      code: "CURRICULUM_MISMATCH",
      message: "Scope does not belong to the requested curriculum.",
    };
  }

  if (message.startsWith("GENERATION_INVALID_OUTPUT")) {
    return {
      status: 422,
      code: "GENERATION_INVALID_OUTPUT",
      message: "Model output failed validation.",
    };
  }

  return { status: 500, code: "INTERNAL_ERROR", message };
}

const ASSIST_AUDIT_ACTIONS = {
  draft_lesson: "content.assist.draft_lesson",
  expand_section: "content.assist.expand_section",
  simplify: "content.assist.simplify",
  generate_questions: "content.assist.generate_questions",
  rewrite_block: "content.assist.rewrite_block",
} as const;

export async function POST(request: Request) {
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

  const parsed = contentAssistRequestSchema.safeParse(body);
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
    const { model, result } = await runContentAssist({
      ...parsed.data,
      adminId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: ASSIST_AUDIT_ACTIONS[parsed.data.action],
      targetType: parsed.data.action === "generate_questions" ? "topic" : "subtopic",
      targetId:
        parsed.data.action === "generate_questions"
          ? parsed.data.topicId
          : parsed.data.subtopicId,
      metadata: { action: parsed.data.action, model },
      request,
    });

    return NextResponse.json({
      success: true,
      data: {
        model,
        ...(typeof result === "object" && result !== null ? (result as Record<string, unknown>) : {}),
      },
    });
  } catch (error) {
    const mapped = mapAssistError(error);
    return NextResponse.json(
      {
        success: false,
        error: { code: mapped.code, message: mapped.message },
      },
      { status: mapped.status },
    );
  }
}
