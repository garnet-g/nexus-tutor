import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import type {
  CouponCreateInput,
  CouponsQueryInput,
} from "@/schemas/adminSchemas";

const DEFAULT_COUPON_LIMIT = 100;

type CouponRow = {
  id: string;
  code: string;
  discount_type: "percent" | "fixed";
  discount_value: number | string;
  applies_to_plan: "premium" | "family" | "any";
  max_uses: number | null;
  used_count: number;
  expires_at: string | null;
  is_active: boolean;
  created_by: string | null;
  created_at: string;
};

export type AdminCoupon = {
  id: string;
  code: string;
  discountType: "percent" | "fixed";
  discountValue: number;
  appliesToPlan: "premium" | "family" | "any";
  maxUses: number | null;
  usedCount: number;
  expiresAt: string | null;
  isActive: boolean;
  createdBy: string | null;
  createdAt: string;
};

function mapCoupon(row: CouponRow): AdminCoupon {
  return {
    id: row.id,
    code: row.code,
    discountType: row.discount_type,
    discountValue: Number(row.discount_value),
    appliesToPlan: row.applies_to_plan,
    maxUses: row.max_uses,
    usedCount: row.used_count,
    expiresAt: row.expires_at,
    isActive: row.is_active,
    createdBy: row.created_by,
    createdAt: row.created_at,
  };
}

export async function listCoupons(
  filters: Partial<CouponsQueryInput> = {},
): Promise<AdminCoupon[]> {
  const admin = createAdminClient();
  const limit = filters.limit ?? DEFAULT_COUPON_LIMIT;

  let query = admin
    .from("coupons")
    .select(
      "id, code, discount_type, discount_value, applies_to_plan, max_uses, used_count, expires_at, is_active, created_by, created_at",
    )
    .order("created_at", { ascending: false })
    .limit(limit);

  if (filters.activeOnly) {
    query = query.eq("is_active", true);
  }

  const { data, error } = await query;

  if (error) {
    throw new Error(error.message);
  }

  return ((data ?? []) as CouponRow[]).map(mapCoupon);
}

export async function createCoupon(input: {
  coupon: CouponCreateInput;
  createdBy: string;
}): Promise<AdminCoupon> {
  const admin = createAdminClient();
  const coupon = input.coupon;
  const code = coupon.code.trim().toUpperCase();

  const { data: existing, error: existingError } = await admin
    .from("coupons")
    .select("id")
    .eq("code", code)
    .maybeSingle();

  if (existingError) {
    throw new Error(existingError.message);
  }

  if (existing) {
    const error = new Error("A coupon with this code already exists.");
    error.name = "CouponConflictError";
    throw error;
  }

  const { data, error } = await admin
    .from("coupons")
    .insert({
      code,
      discount_type: coupon.discountType,
      discount_value: coupon.discountValue,
      applies_to_plan: coupon.appliesToPlan,
      max_uses: coupon.maxUses ?? null,
      expires_at: coupon.expiresAt ?? null,
      created_by: input.createdBy,
    })
    .select(
      "id, code, discount_type, discount_value, applies_to_plan, max_uses, used_count, expires_at, is_active, created_by, created_at",
    )
    .single();

  if (error) {
    throw new Error(error.message);
  }

  return mapCoupon(data as CouponRow);
}

export async function deactivateCoupon(
  couponId: string,
): Promise<AdminCoupon | null> {
  const admin = createAdminClient();

  const { data, error } = await admin
    .from("coupons")
    .update({ is_active: false })
    .eq("id", couponId)
    .select(
      "id, code, discount_type, discount_value, applies_to_plan, max_uses, used_count, expires_at, is_active, created_by, created_at",
    )
    .maybeSingle();

  if (error) {
    throw new Error(error.message);
  }

  return data ? mapCoupon(data as CouponRow) : null;
}
