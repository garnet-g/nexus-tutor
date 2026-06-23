import "server-only";

import { NextResponse } from "next/server";

import { listLessonVersions } from "@/server/services/contentApprovalService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

export async function GET(
  _request: Request,
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

  try {
    const versions = await listLessonVersions(lessonId);
    return NextResponse.json({ success: true, data: versions });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Unexpected error.";
    return NextResponse.json(
      { success: false, error: { code: "INTERNAL_ERROR", message } },
      { status: 500 },
    );
  }
}
