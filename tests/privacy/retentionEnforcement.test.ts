/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const deleted: Array<{ table: string; column: string; cutoff: string }> = [];

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      const state: { column?: string; cutoff?: string; inColumn?: string; inValues?: string[] } =
        {};

      const chain: Record<string, unknown> = {};
      chain.delete = () => chain;
      chain.select = () => chain;
      chain.lt = (column: string, cutoff: string) => {
        state.column = column;
        state.cutoff = cutoff;
        return chain;
      };
      chain.in = (column: string, values: string[]) => {
        state.inColumn = column;
        state.inValues = values;
        return chain;
      };
      chain.then = undefined;

      Object.defineProperty(chain, "then", {
        value: (resolve: (value: { count: number; data: unknown; error: null }) => void) => {
          if (state.column && state.cutoff) {
            deleted.push({ table, column: state.column, cutoff: state.cutoff });
          }
          resolve({ count: 2, data: null, error: null });
        },
      });

      if (table === "parent_reports") {
        return {
          select: () => ({
            lt: async () => ({ data: [{ id: "report-1" }], error: null }),
          }),
          delete: () => ({
            lt: async () => {
              deleted.push({ table, column: "generated_at", cutoff: "learning" });
              return { count: 1, error: null };
            },
          }),
        };
      }

      return chain;
    },
  })),
}));

describe("PR-057 retention enforcement", () => {
  beforeEach(() => {
    deleted.length = 0;
    vi.resetModules();
  });

  it("deletes notification logs older than the DEC-006 90-day window", async () => {
    const { enforceDataRetentionPolicies } = await import(
      "@/server/services/retentionEnforcementService"
    );

    const result = await enforceDataRetentionPolicies();

    expect(result.notificationSmsDeleted).toBeGreaterThan(0);
    expect(result.notificationEmailDeleted).toBeGreaterThan(0);
    expect(deleted.some((entry) => entry.table === "celcom_sms_logs")).toBe(true);
    expect(deleted.some((entry) => entry.table === "resend_email_logs")).toBe(true);
    expect(deleted.some((entry) => entry.table === "admin_impersonation_sessions")).toBe(
      true,
    );
  });
});
