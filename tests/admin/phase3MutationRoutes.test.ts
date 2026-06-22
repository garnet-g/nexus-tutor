import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import {
  POST as flagsPOST,
} from "@/app/api/admin/nex-ops/flags/route";
import { PATCH as flagPATCH } from "@/app/api/admin/nex-ops/flags/[id]/route";
import { POST as parentSmsPOST } from "@/app/api/admin/outcomes/parent-sms/route";
import {
  POST as couponsPOST,
} from "@/app/api/admin/payments/coupons/route";
import {
  DELETE as couponDELETE,
  PATCH as couponPATCH,
} from "@/app/api/admin/payments/coupons/[id]/route";
import { POST as compPOST } from "@/app/api/admin/users/[id]/comp/route";
import {
  DELETE as impersonateDELETE,
  POST as impersonatePOST,
} from "@/app/api/admin/users/[id]/impersonate/route";

const requireAdminApi = vi.fn();

vi.mock("@/server/services/requireAdminApi", () => ({
  requireAdminApi: (...args: unknown[]) => requireAdminApi(...args),
}));

const from = vi.fn();
vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ from })),
}));

const recordAdminAudit = vi.fn();
vi.mock("@/server/services/adminAuditService", () => ({
  recordAdminAudit: (...args: unknown[]) => recordAdminAudit(...args),
}));

const startImpersonation = vi.fn();
const endImpersonation = vi.fn();
vi.mock("@/server/services/adminImpersonationService", () => ({
  startImpersonation: (...args: unknown[]) => startImpersonation(...args),
  endImpersonation: (...args: unknown[]) => endImpersonation(...args),
}));

const createCoupon = vi.fn();
const deactivateCoupon = vi.fn();
vi.mock("@/server/services/adminCouponService", () => ({
  createCoupon: (...args: unknown[]) => createCoupon(...args),
  deactivateCoupon: (...args: unknown[]) => deactivateCoupon(...args),
}));

const createAdminFlag = vi.fn();
const resolveFlag = vi.fn();
vi.mock("@/server/services/adminNexReviewService", () => ({
  createAdminFlag: (...args: unknown[]) => createAdminFlag(...args),
  resolveFlag: (...args: unknown[]) => resolveFlag(...args),
}));

const sendParentSms = vi.fn();
vi.mock("@/server/services/adminParentNotifyService", () => ({
  sendParentSms: (...args: unknown[]) => sendParentSms(...args),
}));

const touchedTables: string[] = [];

function params(id = "student-1") {
  return { params: Promise.resolve({ id }) };
}

function allowSuperAdmin() {
  requireAdminApi.mockResolvedValue({
    ok: true,
    userId: "super-1",
    role: "super_admin",
  });
}

function rejectSupport() {
  requireAdminApi.mockResolvedValue({
    ok: false,
    response: Response.json(
      {
        success: false,
        error: {
          code: "FORBIDDEN",
          message: "Super admin access required.",
        },
      },
      { status: 403 },
    ),
  });
}

function makeBuilder(table: string) {
  const builder = {
    select: vi.fn(() => builder),
    eq: vi.fn(() => builder),
    order: vi.fn(() => builder),
    limit: vi.fn(() => builder),
    update: vi.fn(() => builder),
    insert: vi.fn(async () => ({ error: null })),
    maybeSingle: vi.fn(async () => {
      if (table === "student_profiles") {
        return { data: { id: "student-1" }, error: null };
      }
      if (table === "subscription_plans") {
        return {
          data: { id: "plan-premium", plan_code: "premium" },
          error: null,
        };
      }
      if (table === "student_subscriptions") {
        return { data: null, error: null };
      }
      return { data: null, error: null };
    }),
  };

  return builder;
}

beforeEach(() => {
  touchedTables.length = 0;
  requireAdminApi.mockReset();
  recordAdminAudit.mockReset().mockResolvedValue(undefined);
  startImpersonation.mockReset().mockResolvedValue({
    id: "session-1",
    expiresAt: "2026-06-22T12:00:00.000Z",
  });
  endImpersonation.mockReset().mockResolvedValue({
    id: "session-1",
    endedAt: "2026-06-22T12:05:00.000Z",
  });
  createCoupon.mockReset().mockResolvedValue({
    id: "coupon-1",
    code: "SAVE20",
    discountType: "percent",
    discountValue: 20,
    appliesToPlan: "premium",
  });
  deactivateCoupon.mockReset().mockResolvedValue({
    id: "coupon-1",
    code: "SAVE20",
  });
  createAdminFlag.mockReset().mockResolvedValue({
    id: "flag-1",
    messageId: "00000000-0000-4000-8000-000000000001",
    studentId: "student-1",
    reason: "unsafe response",
  });
  resolveFlag.mockReset().mockResolvedValue({
    id: "flag-1",
    status: "escalated",
    messageId: "00000000-0000-4000-8000-000000000001",
    studentId: "student-1",
  });
  sendParentSms.mockReset().mockResolvedValue({
    ok: false,
    code: "NO_PARENT_PHONE",
    message: "No active parent with a phone number is linked to this student.",
  });
  from.mockReset().mockImplementation((table: string) => {
    touchedTables.push(table);
    return makeBuilder(table);
  });
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("Phase 3 admin mutation route contracts", () => {
  it("rejects support on comp subscription before touching write paths", async () => {
    rejectSupport();

    const response = await compPOST(
      new Request("https://nexus.test/api/admin/users/student-1/comp", {
        method: "POST",
        body: JSON.stringify({ planCode: "premium", reason: "QA check" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    expect(from).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("validates comp subscription body before service-role writes", async () => {
    allowSuperAdmin();

    const response = await compPOST(
      new Request("https://nexus.test/api/admin/users/student-1/comp", {
        method: "POST",
        body: JSON.stringify({ planCode: "premium" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
    expect(from).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("lets super_admin grant a comp subscription and records audit without payment tables", async () => {
    allowSuperAdmin();

    const response = await compPOST(
      new Request("https://nexus.test/api/admin/users/student-1/comp", {
        method: "POST",
        body: JSON.stringify({ planCode: "premium", reason: "Launch support" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(touchedTables).toContain("student_subscriptions");
    expect(touchedTables).toContain("admin_subscription_grants");
    expect(touchedTables).not.toContain("mpesa_payments");
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        actorUserId: "super-1",
        actorRole: "super_admin",
        action: "subscription.comp",
        targetType: "student",
        targetId: "student-1",
      }),
    );
  });

  it("rejects support before starting impersonation", async () => {
    rejectSupport();

    const response = await impersonatePOST(
      new Request("https://nexus.test/api/admin/users/student-1/impersonate", {
        method: "POST",
        body: JSON.stringify({ reason: "QA view" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    expect(startImpersonation).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("validates impersonation reason before starting a session", async () => {
    allowSuperAdmin();

    const response = await impersonatePOST(
      new Request("https://nexus.test/api/admin/users/student-1/impersonate", {
        method: "POST",
        body: JSON.stringify({ reason: "" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
    expect(startImpersonation).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("starts super_admin impersonation and records route-owned audit", async () => {
    allowSuperAdmin();

    const response = await impersonatePOST(
      new Request("https://nexus.test/api/admin/users/student-1/impersonate", {
        method: "POST",
        body: JSON.stringify({ reason: "Investigate support ticket" }),
        headers: { "content-type": "application/json" },
      }),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data.sessionId).toBe("session-1");
    expect(startImpersonation).toHaveBeenCalledWith({
      adminUserId: "super-1",
      targetStudentId: "student-1",
      reason: "Investigate support ticket",
    });
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "user.impersonate.start",
        targetType: "student",
        targetId: "student-1",
      }),
    );
  });

  it("ends super_admin impersonation and records route-owned audit", async () => {
    allowSuperAdmin();

    const response = await impersonateDELETE(
      new Request(
        "https://nexus.test/api/admin/users/student-1/impersonate?session=session-1",
        { method: "DELETE" },
      ),
      params(),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data.sessionId).toBe("session-1");
    expect(endImpersonation).toHaveBeenCalledWith("session-1", "super-1");
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "user.impersonate.end",
        targetType: "student",
        targetId: "student-1",
      }),
    );
  });

  it("rejects support before creating coupons", async () => {
    rejectSupport();

    const response = await couponsPOST(
      new Request("https://nexus.test/api/admin/payments/coupons", {
        method: "POST",
        body: JSON.stringify({
          code: "SAVE20",
          discountType: "percent",
          discountValue: 20,
          appliesToPlan: "premium",
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    expect(createCoupon).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("validates coupon create body before calling the write service", async () => {
    allowSuperAdmin();

    const response = await couponsPOST(
      new Request("https://nexus.test/api/admin/payments/coupons", {
        method: "POST",
        body: JSON.stringify({
          code: "SAVE20",
          discountType: "percent",
          discountValue: 120,
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(400);
    expect(body.error.code).toBe("VALIDATION_ERROR");
    expect(createCoupon).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("lets super_admin create coupons and records route-owned audit", async () => {
    allowSuperAdmin();

    const response = await couponsPOST(
      new Request("https://nexus.test/api/admin/payments/coupons", {
        method: "POST",
        body: JSON.stringify({
          code: "SAVE20",
          discountType: "percent",
          discountValue: 20,
          appliesToPlan: "premium",
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(201);
    expect(body.success).toBe(true);
    expect(createCoupon).toHaveBeenCalledWith({
      coupon: {
        code: "SAVE20",
        discountType: "percent",
        discountValue: 20,
        appliesToPlan: "premium",
      },
      createdBy: "super-1",
    });
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "coupon.create",
        targetType: "coupon",
        targetId: "coupon-1",
      }),
    );
  });

  it("lets super_admin deactivate coupons via PATCH and DELETE with audit", async () => {
    allowSuperAdmin();

    const patchResponse = await couponPATCH(
      new Request("https://nexus.test/api/admin/payments/coupons/coupon-1", {
        method: "PATCH",
      }),
      params("coupon-1"),
    );
    const deleteResponse = await couponDELETE(
      new Request("https://nexus.test/api/admin/payments/coupons/coupon-1", {
        method: "DELETE",
      }),
      params("coupon-1"),
    );

    expect(patchResponse.status).toBe(200);
    expect(deleteResponse.status).toBe(200);
    expect(deactivateCoupon).toHaveBeenCalledTimes(2);
    expect(deactivateCoupon).toHaveBeenCalledWith("coupon-1");
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "coupon.deactivate",
        targetType: "coupon",
        targetId: "coupon-1",
      }),
    );
  });

  it("returns NO_PARENT_PHONE from the parent SMS route without hiding the business error", async () => {
    allowSuperAdmin();

    const response = await parentSmsPOST(
      new Request("https://nexus.test/api/admin/outcomes/parent-sms", {
        method: "POST",
        body: JSON.stringify({
          studentId: "00000000-0000-4000-8000-000000000002",
          message: "Please contact Nexus support.",
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(404);
    expect(body.success).toBe(false);
    expect(body.error.code).toBe("NO_PARENT_PHONE");
    expect(sendParentSms).toHaveBeenCalledWith(
      expect.objectContaining({
        studentId: "00000000-0000-4000-8000-000000000002",
        adminUserId: "super-1",
        adminRole: "super_admin",
      }),
    );
  });

  it("rejects support before creating Nex flags", async () => {
    rejectSupport();

    const response = await flagsPOST(
      new Request("https://nexus.test/api/admin/nex-ops/flags", {
        method: "POST",
        body: JSON.stringify({
          messageId: "00000000-0000-4000-8000-000000000001",
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(403);
    expect(body.error.code).toBe("FORBIDDEN");
    expect(createAdminFlag).not.toHaveBeenCalled();
    expect(recordAdminAudit).not.toHaveBeenCalled();
  });

  it("lets super_admin create Nex flags and records audit", async () => {
    allowSuperAdmin();

    const response = await flagsPOST(
      new Request("https://nexus.test/api/admin/nex-ops/flags", {
        method: "POST",
        body: JSON.stringify({
          messageId: "00000000-0000-4000-8000-000000000001",
          reason: "unsafe response",
        }),
        headers: { "content-type": "application/json" },
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(201);
    expect(body.success).toBe(true);
    expect(createAdminFlag).toHaveBeenCalledWith({
      messageId: "00000000-0000-4000-8000-000000000001",
      reason: "unsafe response",
    });
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "nex_flag.create",
        targetType: "nex_message_flag",
        targetId: "flag-1",
      }),
    );
  });

  it("lets super_admin resolve or escalate Nex flags and records audit", async () => {
    allowSuperAdmin();

    const response = await flagPATCH(
      new Request("https://nexus.test/api/admin/nex-ops/flags/flag-1", {
        method: "PATCH",
        body: JSON.stringify({
          status: "escalated",
          notes: "Needs human review",
        }),
        headers: { "content-type": "application/json" },
      }),
      params("flag-1"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(resolveFlag).toHaveBeenCalledWith({
      flagId: "flag-1",
      status: "escalated",
      notes: "Needs human review",
      resolvedBy: "super-1",
    });
    expect(recordAdminAudit).toHaveBeenCalledWith(
      expect.objectContaining({
        action: "nex_flag.resolve",
        targetType: "nex_message_flag",
        targetId: "flag-1",
        metadata: expect.objectContaining({ status: "escalated" }),
      }),
    );
  });
});
