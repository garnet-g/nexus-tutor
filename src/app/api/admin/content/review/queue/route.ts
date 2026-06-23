import "server-only";

import { NextResponse } from "next/server";

import { getContentReviewQueue } from "@/server/services/contentAdminReadService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

export async function GET() {
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

  const queue = await getContentReviewQueue();
  return NextResponse.json({ success: true, data: queue });
}
