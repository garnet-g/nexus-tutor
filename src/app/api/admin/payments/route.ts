import "server-only";

import { NextResponse } from "next/server";

import {
  paymentCallbackReplaySchema,
  paymentsQuerySchema,
} from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import { getPaymentsDashboard } from "@/server/services/adminPaymentsReadService";
import { replayCallbackEvent } from "@/server/services/paymentReconciliationService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = paymentsQuerySchema.safeParse({
      status: searchParams.get("status") ?? undefined,
      from: searchParams.get("from") ?? undefined,
      to: searchParams.get("to") ?? undefined,
      limit: searchParams.get("limit") ?? undefined,
    });

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid query parameters.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const data = await getPaymentsDashboard(parsed.data);

    return NextResponse.json({ success: true, data });
  } catch (error) {
    console.error("ADMIN_PAYMENTS_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: { code: "INTERNAL_ERROR", message: "Could not load payments." },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const body = (await request.json()) as unknown;
    const parsed = paymentCallbackReplaySchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid replay request.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const result = await replayCallbackEvent(parsed.data.eventId);

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "payments.replay_callback",
      targetType: "mpesa_callback_event",
      targetId: parsed.data.eventId,
      metadata: result,
      request,
    });

    return NextResponse.json({
      success: true,
      data: result,
    });
  } catch (error) {
    console.error("ADMIN_PAYMENTS_REPLAY_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not replay callback event.",
        },
      },
      { status: 500 },
    );
  }
}
