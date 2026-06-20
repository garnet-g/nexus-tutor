import "server-only";

import { NextResponse } from "next/server";

import { getContentDraftQueue } from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export async function GET() {
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

  const drafts = await getContentDraftQueue();
  return NextResponse.json({ success: true, data: drafts });
}
