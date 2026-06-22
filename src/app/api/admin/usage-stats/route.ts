import "server-only";

import { NextResponse } from "next/server";

import {
  loadNexOpsSnapshot,
  updateNexOpsReviewStatus,
  type NexOpsReviewStatus,
} from "@/server/services/nexOpsService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function errorResponse(status: 401 | 403, message: string) {
  return NextResponse.json(
    {
      success: false,
      error: {
        code: status === 401 ? "UNAUTHORIZED" : "FORBIDDEN",
        message,
      },
    },
    { status },
  );
}

function isReviewStatus(value: unknown): value is Exclude<NexOpsReviewStatus, "open"> {
  return value === "resolved" || value === "escalated";
}

export async function GET() {
  try {
    const auth = await requireSuperAdmin();
    if (!auth.ok) {
      return errorResponse(auth.status, auth.message);
    }

    const data = await loadNexOpsSnapshot();

    return NextResponse.json({
      success: true,
      data,
    });
  } catch (error) {
    console.error("ADMIN_NEX_OPS_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load Nex ops." },
      },
      { status: 500 },
    );
  }
}

export async function PATCH(request: Request) {
  try {
    const auth = await requireSuperAdmin();
    if (!auth.ok) {
      return errorResponse(auth.status, auth.message);
    }

    const body = (await request.json()) as {
      messageId?: unknown;
      status?: unknown;
    };

    if (typeof body.messageId !== "string" || !isReviewStatus(body.status)) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "messageId and status are required.",
          },
        },
        { status: 400 },
      );
    }

    await updateNexOpsReviewStatus(body.messageId, body.status);

    return NextResponse.json({
      success: true,
      data: { messageId: body.messageId, status: body.status },
    });
  } catch (error) {
    console.error("ADMIN_NEX_OPS_REVIEW_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not update Nex ops review status.",
        },
      },
      { status: 500 },
    );
  }
}
