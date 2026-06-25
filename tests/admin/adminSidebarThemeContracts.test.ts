import { describe, expect, it } from "vitest";

import {
  ADMIN_NAV_GROUPS,
  ADMIN_PRIMARY_HREF,
} from "@/features/admin/components/AdminNav";

describe("admin sidebar navigation contract", () => {
  it("uses Dashboard as the first admin destination at /admin", () => {
    expect(ADMIN_PRIMARY_HREF).toBe("/admin");
    expect(ADMIN_NAV_GROUPS[0]?.items[0]).toMatchObject({
      href: "/admin",
      label: "Dashboard",
    });
  });

  it("groups the expanded admin routes into scannable sections", () => {
    expect(ADMIN_NAV_GROUPS.map((group) => group.label)).toEqual([
      "Overview",
      "People",
      "Learning",
      "Revenue",
      "Growth",
      "Operations",
      "System",
    ]);

    const allRoutes = ADMIN_NAV_GROUPS.flatMap((group) =>
      group.items.map((item) => item.href),
    );
    expect(allRoutes).toContain("/admin/revenue-ops");
    expect(allRoutes).toContain("/admin/content-calendar");
    expect(allRoutes).toContain("/admin/approvals");
  });

  it("keeps each sidebar group short enough to scan", () => {
    for (const group of ADMIN_NAV_GROUPS) {
      expect(group.items.length, group.label).toBeLessThanOrEqual(5);
    }
  });
});
