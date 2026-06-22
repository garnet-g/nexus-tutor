import "server-only";

import { NextResponse } from "next/server";

import { recordAdminAudit } from "@/server/services/adminAuditService";
import { deactivateCoupon } from "@/server/services/adminCouponService";
import { requireAdminApi } from "@/server/services/requireAdminApi";

async function handleDeactivate(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const { id: couponId } = await context.params;
    const coupon = await deactivateCoupon(couponId);

    if (!coupon) {
      return NextResponse.json(
        {
          success: false,
          error: { code: "NOT_FOUND", message: "Coupon not found." },
        },
        { status: 404 },
      );
    }

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "coupon.deactivate",
      targetType: "coupon",
      targetId: coupon.id,
      metadata: {
        couponId: coupon.id,
        code: coupon.code,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { coupon } });
  } catch (error) {
    console.error("ADMIN_COUPON_DEACTIVATE_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not deactivate coupon.",
        },
      },
      { status: 500 },
    );
  }
}

export async function PATCH(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  return handleDeactivate(request, context);
}

export async function DELETE(
  request: Request,
  context: { params: Promise<{ id: string }> },
) {
  return handleDeactivate(request, context);
}
