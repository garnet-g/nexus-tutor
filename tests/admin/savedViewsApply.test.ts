import { describe, expect, it } from "vitest";

import { buildSavedViewHref } from "@/lib/admin/savedViews";

describe("buildSavedViewHref", () => {
  it("appends saved filters as query params", () => {
    expect(
      buildSavedViewHref({
        route: "/admin/payments",
        filters: { status: "failed" },
      }),
    ).toBe("/admin/payments?status=failed");
  });
});
