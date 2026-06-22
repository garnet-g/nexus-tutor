import "server-only";

import { NextResponse } from "next/server";

import {
  getActiveSubjectsContentCoverage,
  getMathematicsContentCoverage,
  getSubjectContentCoverage,
} from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
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

  const { searchParams } = new URL(request.url);
  const subjectCode = searchParams.get("subject");
  const allSubjects = searchParams.get("all") === "true";

  if (allSubjects) {
    const subjects = await getActiveSubjectsContentCoverage();
    return NextResponse.json({ success: true, data: { subjects } });
  }

  if (subjectCode) {
    const subject = await getSubjectContentCoverage(subjectCode);
    if (!subject) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Unknown subject code." },
        },
        { status: 404 },
      );
    }
    return NextResponse.json({ success: true, data: subject.curricula });
  }

  const coverage = await getMathematicsContentCoverage();
  return NextResponse.json({ success: true, data: coverage });
}
