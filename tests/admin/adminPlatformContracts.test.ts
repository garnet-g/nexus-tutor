import { describe, expect, it } from "vitest";

import {
  ADMIN_PLATFORM_NAV,
  ADMIN_ROLE_PERMISSIONS,
  buildAdminTaskInbox,
  buildEntitlementDebug,
  buildStudentTimeline,
  canAdminAccessRoute,
  type AdminTaskSourceItem,
} from "@/server/services/adminPlatformSummary";

describe("admin platform contracts", () => {
  it("exposes the new production admin pages in navigation metadata", () => {
    expect(ADMIN_PLATFORM_NAV.map((item) => item.href)).toEqual([
      "/admin/inbox",
      "/admin/alerts",
      "/admin/roles",
      "/admin/communications",
      "/admin/health",
      "/admin/reports",
      "/admin/experiments",
      "/admin/search",
      "/admin/saved-views",
      "/admin/bulk-actions",
      "/admin/approvals",
      "/admin/ai-quality",
      "/admin/content-calendar",
      "/admin/revenue-ops",
    ]);
  });

  it("keeps support admins out of finance and settings routes", () => {
    expect(canAdminAccessRoute("support", "/admin/support")).toBe(true);
    expect(canAdminAccessRoute("support", "/admin/revenue-ops")).toBe(false);
    expect(canAdminAccessRoute("support", "/admin/platform-settings")).toBe(false);
    expect(canAdminAccessRoute("super_admin", "/admin/platform-settings")).toBe(true);
  });

  it("builds one priority-sorted inbox from mixed admin work sources", () => {
    const items: AdminTaskSourceItem[] = [
      {
        id: "support-1",
        source: "support",
        title: "Parent payment issue",
        href: "/admin/support",
        severity: "urgent",
        createdAt: "2026-06-24T08:00:00.000Z",
      },
      {
        id: "content-1",
        source: "content",
        title: "Lesson review",
        href: "/admin/studio/review",
        severity: "watch",
        createdAt: "2026-06-24T09:00:00.000Z",
      },
      {
        id: "nex-1",
        source: "nex",
        title: "Unsafe answer flag",
        href: "/admin/nex-ops",
        severity: "critical",
        createdAt: "2026-06-24T07:00:00.000Z",
      },
    ];

    const inbox = buildAdminTaskInbox(items);

    expect(inbox[0]?.id).toBe("nex-1");
    expect(inbox[1]?.id).toBe("support-1");
    expect(inbox[2]?.id).toBe("content-1");
  });

  it("explains why a student can access premium features", () => {
    const entitlement = buildEntitlementDebug({
      planCode: "premium",
      subscriptionStatus: "active",
      trialActive: false,
      featureEnabled: true,
      dailyLimit: 75,
      dailyUsage: 14,
    });

    expect(entitlement.allowed).toBe(true);
    expect(entitlement.blockers).toEqual([]);
    expect(entitlement.reasons).toContain("Active premium subscription");
  });

  it("explains trial and limit blockers", () => {
    const entitlement = buildEntitlementDebug({
      planCode: "free",
      subscriptionStatus: "active",
      trialActive: false,
      featureEnabled: false,
      dailyLimit: 10,
      dailyUsage: 10,
    });

    expect(entitlement.allowed).toBe(false);
    expect(entitlement.blockers).toEqual([
      "Feature rollout is disabled",
      "Daily limit reached",
    ]);
  });

  it("sorts student timeline events newest first", () => {
    const timeline = buildStudentTimeline([
      {
        kind: "diagnostic",
        title: "Diagnostic completed",
        occurredAt: "2026-06-23T10:00:00.000Z",
      },
      {
        kind: "payment",
        title: "Payment received",
        occurredAt: "2026-06-24T10:00:00.000Z",
      },
    ]);

    expect(timeline.map((event) => event.kind)).toEqual(["payment", "diagnostic"]);
  });

  it("defines permissions for all operational roles", () => {
    expect(Object.keys(ADMIN_ROLE_PERMISSIONS).sort()).toEqual([
      "content_reviewer",
      "finance_admin",
      "growth_admin",
      "ops_admin",
      "super_admin",
      "support",
    ]);
  });
});
