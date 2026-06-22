import "server-only";

import { NextResponse } from "next/server";

import {
  couponCreateSchema,
  couponsQuerySchema,
} from "@/schemas/adminSchemas";
import { recordAdminAudit } from "@/server/services/adminAuditService";
import {
  createCoupon,
  listCoupons,
} from "@/server/services/adminCouponService";
import { requireAdminApi } from "@/server/services/requireAdminApi";
import { ADMIN_ROLES } from "@/server/services/superAdminGuard";

export async function GET(request: Request) {
  try {
    const auth = await requireAdminApi(request, ADMIN_ROLES);
    if (!auth.ok) {
      return auth.response;
    }

    const { searchParams } = new URL(request.url);
    const parsed = couponsQuerySchema.safeParse({
      activeOnly: searchParams.get("activeOnly") ?? undefined,
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

    const coupons = await listCoupons(parsed.data);
    return NextResponse.json({ success: true, data: { coupons } });
  } catch (error) {
    console.error("ADMIN_COUPONS_GET_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not load coupons.",
        },
      },
      { status: 500 },
    );
  }
}

export async function POST(request: Request) {
  try {
    const auth = await requireAdminApi(request, ["super_admin"]);
    if (!auth.ok) {
      return auth.response;
    }

    const body = await request.json();
    const parsed = couponCreateSchema.safeParse(body);

    if (!parsed.success) {
      return NextResponse.json(
        {
          success: false,
          error: {
            code: "VALIDATION_ERROR",
            message: "Invalid request body.",
            details: parsed.error.flatten(),
          },
        },
        { status: 400 },
      );
    }

    const coupon = await createCoupon({
      coupon: parsed.data,
      createdBy: auth.userId,
    });

    await recordAdminAudit({
      actorUserId: auth.userId,
      actorRole: auth.role,
      action: "coupon.create",
      targetType: "coupon",
      targetId: coupon.id,
      metadata: {
        couponId: coupon.id,
        code: coupon.code,
        discountType: coupon.discountType,
        discountValue: coupon.discountValue,
        appliesToPlan: coupon.appliesToPlan,
      },
      request,
    });

    return NextResponse.json({ success: true, data: { coupon } }, { status: 201 });
  } catch (error) {
    if (error instanceof Error && error.name === "CouponConflictError") {
      return NextResponse.json(
        {
          success: false,
          error: { code: "CONFLICT", message: error.message },
        },
        { status: 409 },
      );
    }

    console.error("ADMIN_COUPONS_POST_FAILED", error);

    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message: "Could not create coupon.",
        },
      },
      { status: 500 },
    );
  }
}
