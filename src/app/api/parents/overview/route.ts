import "server-only";

import { NextResponse } from "next/server";

import { getLinkedStudentsOverview } from "@/server/services/parentLinkService";
import { parentApiError, requireParentProfile } from "@/server/services/parentContext";

export async function GET() {
  const parentContext = await requireParentProfile();

  if (!parentContext.ok) {
    return parentApiError(
      parentContext.status,
      parentContext.status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
      parentContext.message,
    );
  }

  const linkedStudents = await getLinkedStudentsOverview(parentContext.parentId);

  return NextResponse.json({
    success: true,
    data: { linkedStudents },
  });
}
