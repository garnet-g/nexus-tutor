import "server-only";

import { NextResponse } from "next/server";

import { getDraftLessonForPreview } from "@/server/services/contentGenerationService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function GET(
  _request: Request,
  context: { params: Promise<{ id: string }> },
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

  const { id } = await context.params;
  const lesson = await getDraftLessonForPreview(id);

  if (!lesson) {
    return NextResponse.json(
      {
        success: false,
        error: { code: "NOT_FOUND", message: "Draft lesson not found." },
      },
      { status: 404 },
    );
  }

  return NextResponse.json({ success: true, data: lesson });
}
