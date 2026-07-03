/**
 * @vitest-environment node
 *
 * PR-015: practice daily cap must be enforced atomically in Postgres.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { beforeEach, describe, expect, it, vi } from "vitest";

const rpc = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ rpc, from })),
}));

import { incrementPracticeDailyUsage } from "@/server/services/nexUsageService";

const MIGRATION_SQL = readFileSync(
  join(
    process.cwd(),
    "supabase/migrations/20260702090000_atomic_usage_and_seats.sql",
  ),
  "utf8",
);

function installAtomicPracticeRpc(): { current: () => number } {
  let count = 0;

  rpc.mockImplementation(async (name: string, params: Record<string, unknown>) => {
    if (name !== "increment_practice_daily_usage") {
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

describe("Practice daily quota — atomic enforcement", () => {
  it("caps 20 parallel practice starts at exactly the daily limit", async () => {
    const limit = 3;
    const store = installAtomicPracticeRpc();

    const results = await Promise.all(
      Array.from({ length: 20 }, () =>
        incrementPracticeDailyUsage("student-1", limit),
      ),
    );

    expect(results.filter((r) => r.allowed)).toHaveLength(limit);
    expect(store.current()).toBe(limit);
  });

  it("delegates to the RPC and never issues a read-then-write on the table", async () => {
    installAtomicPracticeRpc();

    await incrementPracticeDailyUsage("student-1", 10);

    expect(rpc).toHaveBeenCalledWith(
      "increment_practice_daily_usage",
      expect.objectContaining({ p_student_id: "student-1", p_daily_limit: 10 }),
    );
    expect(from).not.toHaveBeenCalled();
  });
});

describe("Practice daily quota — migration contract", () => {
  it("increments atomically with an ON CONFLICT cap guard", () => {
    expect(MIGRATION_SQL).toContain(
      "CREATE OR REPLACE FUNCTION public.increment_practice_daily_usage",
    );
    expect(MIGRATION_SQL).toMatch(/practice_session_count < p_daily_limit/);
    expect(MIGRATION_SQL).toContain(
      "GRANT EXECUTE ON FUNCTION public.increment_practice_daily_usage(UUID, DATE, INTEGER) TO service_role",
    );
  });
});
