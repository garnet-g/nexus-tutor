import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { createCoupon, deactivateCoupon } from "@/server/services/adminCouponService";

const from = vi.fn();
const touchedTables: string[] = [];

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const couponRow = {
  id: "coupon-1",
  code: "SAVE20",
  discount_type: "percent",
  discount_value: 20,
  applies_to_plan: "premium",
  max_uses: null,
  used_count: 0,
  expires_at: null,
  is_active: true,
  created_by: "super-1",
  created_at: "2026-06-22T00:00:00.000Z",
};

function couponBuilder() {
  const builder = {
    select: vi.fn(() => builder),
    eq: vi.fn(() => builder),
    order: vi.fn(() => builder),
    limit: vi.fn(() => builder),
    insert: vi.fn(() => builder),
    update: vi.fn(() => builder),
    maybeSingle: vi.fn(async () => ({ data: null, error: null })),
    single: vi.fn(async () => ({ data: couponRow, error: null })),
    then: (resolve: (value: unknown) => unknown) =>
      resolve({ data: [couponRow], error: null }),
  };

  return builder;
}

beforeEach(() => {
  touchedTables.length = 0;
  from.mockReset().mockImplementation((table: string) => {
    touchedTables.push(table);
    return couponBuilder();
  });
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("adminCouponService", () => {
  it("creates coupons only through the coupons table, never payment tables", async () => {
    const coupon = await createCoupon({
      coupon: {
        code: "save20",
        discountType: "percent",
        discountValue: 20,
        appliesToPlan: "premium",
      },
      createdBy: "super-1",
    });

    expect(coupon).toEqual({
      id: "coupon-1",
      code: "SAVE20",
      discountType: "percent",
      discountValue: 20,
      appliesToPlan: "premium",
      maxUses: null,
      usedCount: 0,
      expiresAt: null,
      isActive: true,
      createdBy: "super-1",
      createdAt: "2026-06-22T00:00:00.000Z",
    });
    expect(touchedTables).toEqual(["coupons", "coupons"]);
    expect(touchedTables).not.toContain("mpesa_payments");
    expect(touchedTables).not.toContain("student_subscriptions");
    expect(touchedTables).not.toContain("subscription_plans");
  });

  it("deactivates coupons only through the coupons table", async () => {
    await deactivateCoupon("coupon-1");

    expect(touchedTables).toEqual(["coupons"]);
    expect(touchedTables).not.toContain("mpesa_payments");
    expect(touchedTables).not.toContain("student_subscriptions");
    expect(touchedTables).not.toContain("subscription_plans");
  });
});
