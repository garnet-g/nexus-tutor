import "server-only";

import { NextResponse } from "next/server";

import { contentReviewActionSchema } from "@/schemas/contentApprovalSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { approveAndPublish } from "@/server/services/contentApprovalService";
import { requireContentAuthor } from "@/server/services/contentAuthorGuard";

import { reviewErrorResponse } from "../reviewRouteHelpers";

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

  const parsed = contentReviewActionSchema.safeParse(body);
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
    const result = await approveAndPublish({
      ...parsed.data,
      adminId: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "content.review.approve",
      targetType: parsed.data.kind,
      targetId: parsed.data.id,
      metadata: { reviewStatus: result.reviewStatus },
      request,
    });

    return NextResponse.json({ success: true, data: result });
  } catch (error) {
    return reviewErrorResponse(error);
  }
}
