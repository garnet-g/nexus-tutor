import "server-only";

import { NextResponse } from "next/server";

import { reorderSubtopicLessonsRequestSchema } from "@/schemas/contentStudioSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { reorderSubtopicLessons } from "@/server/services/contentStudioService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

export async function PATCH(
  request: Request,
  context: { params: Promise<{ subtopicId: string }> },
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

  const { subtopicId } = await context.params;

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

  const parsed = reorderSubtopicLessonsRequestSchema.safeParse({
    ...(typeof body === "object" && body ? body : {}),
    subtopicId,
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
    const data = await reorderSubtopicLessons(parsed.data);
    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "content.lessons.reorder",
      targetType: "subtopic",
      targetId: subtopicId,
      metadata: {
        subtopicId,
        lessonCount: data.lessonIds.length,
      },
    });
    return NextResponse.json({ success: true, data });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    const status =
      message === "NOT_FOUND" ? 404 : message === "VALIDATION_ERROR" ? 400 : 500;
    return NextResponse.json(
      {
        success: false,
        error: {
          code:
            status === 404 ? "NOT_FOUND" : status === 400 ? "VALIDATION_ERROR" : "INTERNAL_ERROR",
          message,
        },
      },
      { status },
    );
  }
}
