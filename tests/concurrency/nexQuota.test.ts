/**
 * @vitest-environment node
 *
 * PR-014: Nex daily usage must be enforced atomically in Postgres. These tests
 * (1) prove the service delegates to the increment_nex_daily_usage RPC and never
 * does a read-then-write, so 20 parallel calls cannot exceed the cap, and
 * (2) assert the migration encodes the atomic contract.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { beforeEach, describe, expect, it, vi } from "vitest";

const rpc = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ rpc, from })),
}));

import { incrementNexDailyUsage } from "@/server/services/nexUsageService";

const MIGRATION_SQL = readFileSync(
  join(
    process.cwd(),
    "supabase/migrations/20260702090000_atomic_usage_and_seats.sql",
  ),
  "utf8",
);

/**
 * In-memory stand-in for the atomic RPC. The read-modify-write runs
 * synchronously (no await before the mutation), so JS's single thread makes it
 * atomic — exactly the guarantee Postgres gives via ON CONFLICT ... WHERE.
 */
function installAtomicNexRpc(): { current: () => number } {
  let count = 0;

  rpc.mockImplementation(async (name: string, params: Record<string, unknown>) => {
    if (name !== "increment_nex_daily_usage") {
      throw new Error(`unexpected rpc ${name}`);
    }

    const cap = params.p_daily_limit as number;

    if (count < cap) {
      count += 1;
      return { data: { allowed: true, new_count: count }, error: null };
    }

    return { data: { allowed: false, new_count: count }, error: null };
  });

  return { current: () => count };
}

beforeEach(() => {
  rpc.mockReset();
  from.mockReset();
});

describe("Nex daily quota — atomic enforcement", () => {
  it("caps 20 parallel increments at exactly the daily limit", async () => {
    const limit = 5;
    const store = installAtomicNexRpc();

    const results = await Promise.all(
      Array.from({ length: 20 }, () =>
        incrementNexDailyUsage("student-1", limit),
      ),
    );

    const allowed = results.filter((r) => r.allowed);

    expect(allowed).toHaveLength(limit);
    expect(store.current()).toBe(limit);
    expect(Math.max(...results.map((r) => r.newCount))).toBe(limit);
  });

  it("delegates to the RPC and never issues a read-then-write on the table", async () => {
    installAtomicNexRpc();

    await incrementNexDailyUsage("student-1", 10);

    expect(rpc).toHaveBeenCalledWith(
      "increment_nex_daily_usage",
      expect.objectContaining({ p_student_id: "student-1", p_daily_limit: 10 }),
    );
    // The old racy path used .from("nex_daily_usage").update(...); the atomic
    // service must not touch the table client-side at all.
    expect(from).not.toHaveBeenCalled();
  });

  it("propagates RPC errors instead of silently swallowing them", async () => {
    rpc.mockResolvedValue({ data: null, error: { message: "boom" } });

    await expect(incrementNexDailyUsage("student-1", 5)).rejects.toThrow("boom");
  });
});

describe("Nex daily quota — migration contract", () => {
  it("increments atomically with an ON CONFLICT cap guard", () => {
    expect(MIGRATION_SQL).toContain(
      "CREATE OR REPLACE FUNCTION public.increment_nex_daily_usage",
    );
    expect(MIGRATION_SQL).toContain("ON CONFLICT (student_id, usage_date) DO UPDATE");
    expect(MIGRATION_SQL).toMatch(
      /nex_message_count < p_daily_limit/,
    );
  });

  it("follows the SECURITY DEFINER hardening conventions", () => {
    expect(MIGRATION_SQL).toContain("SECURITY DEFINER");
    expect(MIGRATION_SQL).toContain("SET search_path = ''");
    expect(MIGRATION_SQL).toContain(
      "GRANT EXECUTE ON FUNCTION public.increment_nex_daily_usage(UUID, DATE, INTEGER) TO service_role",
    );
    expect(MIGRATION_SQL).toMatch(
      /REVOKE ALL ON FUNCTION public\.increment_nex_daily_usage\(UUID, DATE, INTEGER\) FROM anon, authenticated/,
    );
  });
});
