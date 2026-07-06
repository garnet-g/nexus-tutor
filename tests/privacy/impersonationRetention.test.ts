/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

const deletedTables: string[] = [];

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table === "parent_reports") {
        return {
          select: () => ({
            lt: async () => ({ data: [], error: null }),
          }),
          delete: () => ({
            lt: async () => ({ count: 0, error: null }),
          }),
        };
      }

      const chain: Record<string, unknown> = {};
      chain.delete = () => chain;
      chain.lt = () => chain;
      chain.in = () => chain;
      chain.select = () => chain;
      chain.then = (resolve: (value: { count: number; error: null }) => void) => {
        deletedTables.push(table);
        resolve({ count: 1, error: null });
      };
      return chain;
    },
  })),
}));

describe("PR-128 impersonation session retention", () => {
  it("purges expired view-as sessions past the retention window", async () => {
    const { enforceDataRetentionPolicies } = await import(
      "@/server/services/retentionEnforcementService"
    );

    const result = await enforceDataRetentionPolicies();

    expect(deletedTables).toContain("admin_impersonation_sessions");
    expect(result.impersonationSessionsDeleted).toBeGreaterThan(0);
  });
});
