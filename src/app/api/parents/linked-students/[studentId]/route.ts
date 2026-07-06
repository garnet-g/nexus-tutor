import "server-only";

import { NextResponse } from "next/server";

import { unlinkParentFromStudent } from "@/server/services/parentLinkService";
import { parentApiError, requireParentProfile } from "@/server/services/parentContext";

export async function DELETE(
  _request: Request,
  context: { params: Promise<{ studentId: string }> },
) {
  const parentContext = await requireParentProfile();

  if (!parentContext.ok) {
    return parentApiError(
      parentContext.status,
      parentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
      parentContext.message,
    );
  }

  const { studentId } = await context.params;

  try {
    await unlinkParentFromStudent(parentContext.parentId, studentId);
    return NextResponse.json({ success: true, data: { studentId, revoked: true } });
  } catch (error) {
    const message = error instanceof Error ? error.message : "Could not unlink student.";

    if (message === "NOT_FOUND") {
      return parentApiError(404, "NOT_FOUND", "No active link for this student.");
    }

    return NextResponse.json(
      {
        success: false,
        error: { code: "UNLINK_FAILED", message },
      },
      { status: 400 },
    );
  }
}
