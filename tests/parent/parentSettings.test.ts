/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const PARENT_A = "00000000-0000-4000-8000-000000000101";

let storedPreferences: Record<string, unknown> = {};
let storedFullName = "Parent A";
let storedPhone: string | null = "+254700000001";

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: {
      getUser: async () => ({
        data: { user: { id: "user-parent-a" } },
        error: null,
      }),
    },
    from: (table: string) => {
      if (table === "parent_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: { id: PARENT_A }, error: null }),
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({ data: null, error: null }),
          }),
        }),
      };
    },
  })),
}));

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "parent_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: null, error: null }),
            }),
          }),
        };
      }

      return {
        select: () => ({
          eq: () => ({
            maybeSingle: async () => ({
              data: {
                full_name: storedFullName,
                phone_number: storedPhone,
                product_preferences: storedPreferences,
              },
              error: null,
            }),
            single: async () => ({
              data: {
                full_name: storedFullName,
                phone_number: storedPhone,
                product_preferences: storedPreferences,
              },
              error: null,
            }),
          }),
        }),
        update: (patch: Record<string, unknown>) => ({
          eq: () => ({
            select: () => ({
              single: async () => {
                if (patch.product_preferences) {
                  storedPreferences = patch.product_preferences as Record<string, unknown>;
                }
                if (typeof patch.full_name === "string") {
                  storedFullName = patch.full_name;
                }
                if (patch.phone_number !== undefined) {
                  storedPhone = patch.phone_number as string | null;
                }

                return {
                  data: {
                    full_name: storedFullName,
                    phone_number: storedPhone,
                    product_preferences: storedPreferences,
                  },
                  error: null,
                };
              },
            }),
          }),
        }),
      };
    },
  })),
}));

describe("PR-060 parent settings", () => {
  beforeEach(() => {
    storedPreferences = {};
    storedFullName = "Parent A";
    storedPhone = "+254700000001";
    vi.resetModules();
  });

  it("GET /api/parents/settings returns product preferences", async () => {
    const { GET } = await import("@/app/api/parents/settings/route");
    const response = await GET();
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data.preferences.displayName).toBe("Parent A");
    expect(body.data.preferences.dashboardSummary).toBe("detailed");
  });

  it("PATCH /api/parents/settings persists product preferences", async () => {
    const { PATCH } = await import("@/app/api/parents/settings/route");
    const response = await PATCH(
      new Request("http://localhost/api/parents/settings", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          displayName: "Updated Parent",
          contactPhone: "+254711111111",
          dashboardSummary: "compact",
        }),
      }),
    );
    const body = await response.json();

    expect(response.status).toBe(200);
    expect(body.data.preferences.displayName).toBe("Updated Parent");
    expect(body.data.preferences.contactPhone).toBe("+254711111111");
    expect(body.data.preferences.dashboardSummary).toBe("compact");
    expect(storedPreferences).toMatchObject({
      displayName: "Updated Parent",
      dashboardSummary: "compact",
    });
    expect(storedFullName).toBe("Updated Parent");
    expect(storedPhone).toBe("+254711111111");
  });
});
