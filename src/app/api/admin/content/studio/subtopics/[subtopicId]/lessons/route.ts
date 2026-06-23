import "server-only";

import { NextResponse } from "next/server";

import { listSubtopicLessons } from "@/server/services/contentStudioService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function GET(
  _request: Request,
  context: { params: Promise<{ subtopicId: string }> },
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

  const { subtopicId } = await context.params;

  try {
    const data = await listSubtopicLessons(subtopicId);
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
