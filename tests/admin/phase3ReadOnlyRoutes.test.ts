import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { GET as flagsGET } from "@/app/api/admin/nex-ops/flags/route";
import { GET as nexOpsGET } from "@/app/api/admin/nex-ops/route";
import { GET as outcomesGET } from "@/app/api/admin/outcomes/route";
import { GET as couponsGET } from "@/app/api/admin/payments/coupons/route";
import { GET as paymentsGET } from "@/app/api/admin/payments/route";
import { GET as usersGET } from "@/app/api/admin/users/route";

const requireAdminApi = vi.fn();

vi.mock("@/server/services/requireAdminApi", () => ({
  requireAdminApi: (...args: unknown[]) => requireAdminApi(...args),
}));

vi.mock("@/server/services/superAdminGuard", () => ({
  ADMIN_ROLES: ["super_admin", "support"],
}));

const getPaymentsDashboard = vi.fn();
vi.mock("@/server/services/adminPaymentsReadService", () => ({
  getPaymentsDashboard: (...args: unknown[]) => getPaymentsDashboard(...args),
}));

const getOutcomesDashboard = vi.fn();
vi.mock("@/server/services/adminOutcomesReadService", () => ({
  getOutcomesDashboard: (...args: unknown[]) => getOutcomesDashboard(...args),
}));

const getNexOpsDashboard = vi.fn();
vi.mock("@/server/services/adminNexOpsReadService", () => ({
  getNexOpsDashboard: (...args: unknown[]) => getNexOpsDashboard(...args),
}));

const listFlags = vi.fn();
vi.mock("@/server/services/adminNexReviewService", () => ({
  listFlags: (...args: unknown[]) => listFlags(...args),
}));

const listCoupons = vi.fn();
vi.mock("@/server/services/adminCouponService", () => ({
  listCoupons: (...args: unknown[]) => listCoupons(...args),
}));

const listUsers = vi.fn();
vi.mock("@/server/services/adminUserReadService", () => ({
  listUsers: (...args: unknown[]) => listUsers(...args),
}));

function authedAsSupport() {
  requireAdminApi.mockResolvedValue({
    ok: true,
    userId: "support-1",
    role: "support",
  });
}

beforeEach(() => {
  requireAdminApi.mockReset();
  getPaymentsDashboard.mockReset().mockResolvedValue({ ledger: [] });
  getOutcomesDashboard.mockReset().mockResolvedValue({ atRiskStudents: [] });
  getNexOpsDashboard.mockReset().mockResolvedValue({ topStudents: [] });
  listFlags.mockReset().mockResolvedValue([]);
  listCoupons.mockReset().mockResolvedValue([]);
  listUsers.mockReset().mockResolvedValue([]);
});

afterEach(() => {
  vi.clearAllMocks();
});

describe("support role can read Phase 2/3 admin dashboard endpoints", () => {
  it("allows support to GET payments without mutating payment data", async () => {
    authedAsSupport();

    const response = await paymentsGET(
      new Request("https://nexus.test/api/admin/payments?status=paid&limit=10"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(getPaymentsDashboard).toHaveBeenCalledWith({
      status: "paid",
      from: undefined,
      to: undefined,
      limit: 10,
    });
  });

  it("allows support to GET outcomes", async () => {
    authedAsSupport();

    const response = await outcomesGET(
      new Request("https://nexus.test/api/admin/outcomes?curriculum=KCSE"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(getOutcomesDashboard).toHaveBeenCalledWith({
      curriculum: "KCSE",
      gradeLevel: undefined,
      riskThreshold: undefined,
      limit: undefined,
    });
  });

  it("allows support to GET Nex ops", async () => {
    authedAsSupport();

    const response = await nexOpsGET(
      new Request("https://nexus.test/api/admin/nex-ops?limit=25"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.success).toBe(true);
    expect(getNexOpsDashboard).toHaveBeenCalledWith({ limit: 25 });
  });

  it("allows support to GET users", async () => {
    authedAsSupport();

    const response = await usersGET(
      new Request("https://nexus.test/api/admin/users?type=student"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body).toEqual({ success: true, data: { users: [] } });
    expect(listUsers).toHaveBeenCalledWith({
      query: undefined,
      type: "student",
      limit: undefined,
      before: undefined,
    });
  });

  it("allows support to GET Nex review flags", async () => {
    authedAsSupport();

    const response = await flagsGET(
      new Request("https://nexus.test/api/admin/nex-ops/flags?status=open"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body).toEqual({ success: true, data: { flags: [] } });
    expect(listFlags).toHaveBeenCalledWith({
      status: "open",
      limit: undefined,
      before: undefined,
    });
  });

  it("allows support to GET coupons as a read-only billing surface", async () => {
    authedAsSupport();

    const response = await couponsGET(
      new Request("https://nexus.test/api/admin/payments/coupons?activeOnly=true"),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body).toEqual({ success: true, data: { coupons: [] } });
    expect(listCoupons).toHaveBeenCalledWith({
      activeOnly: true,
      limit: undefined,
    });
  });
});
