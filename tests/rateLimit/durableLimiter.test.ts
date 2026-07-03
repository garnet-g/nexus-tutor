/**
 * @vitest-environment node
 *
 * PR-046/PR-048/PR-049: the rate limiter must be durable and shared across app
 * instances (a single Postgres bucket), not a per-process Map. These tests
 * simulate several instances hitting one shared bucket and assert the migration
 * encodes the atomic fixed-window contract.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { beforeEach, describe, expect, it, vi } from "vitest";

const rpc = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ rpc })),
}));

import { checkRateLimit } from "@/lib/rateLimit/durableLimiter";

const MIGRATION_SQL = readFileSync(
  join(
    process.cwd(),
    "supabase/migrations/20260702090000_atomic_usage_and_seats.sql",
  ),
  "utf8",
);

/**
 * One shared bucket, keyed like the real table. Multiple concurrent callers
 * model multiple app instances hitting the same durable counter.
 */
function installSharedBucket(): void {
  const buckets = new Map<string, number>();

  rpc.mockImplementation(async (name: string, params: Record<string, unknown>) => {
    if (name !== "consume_rate_limit") {
      throw new Error(`unexpected rpc ${name}`);
    }

    const key = params.p_key as string;
    const max = params.p_max as number;
    const next = (buckets.get(key) ?? 0) + 1;
    buckets.set(key, next);

    if (next > max) {
      return { data: { allowed: false, retry_after_seconds: 30 }, error: null };
    }
    return { data: { allowed: true, retry_after_seconds: 0 }, error: null };
  });
}

beforeEach(() => {
  rpc.mockReset();
});

describe("durable rate limiter — shared bucket", () => {
  it("allows exactly `max` requests across simulated instances", async () => {
    installSharedBucket();

    const results = await Promise.all(
      Array.from({ length: 20 }, () =>
        checkRateLimit({ key: "waitlist:teacher:1.2.3.4", windowSeconds: 60, max: 5 }),
      ),
    );

    expect(results.filter((r) => r.allowed)).toHaveLength(5);
    expect(results.filter((r) => !r.allowed)).toHaveLength(15);
  });

  it("separates counters by key", async () => {
    installSharedBucket();

    const a = await checkRateLimit({ key: "k:a", windowSeconds: 60, max: 1 });
    const b = await checkRateLimit({ key: "k:b", windowSeconds: 60, max: 1 });
    const aAgain = await checkRateLimit({ key: "k:a", windowSeconds: 60, max: 1 });

    expect(a.allowed).toBe(true);
    expect(b.allowed).toBe(true);
    expect(aAgain.allowed).toBe(false);
  });

  it("surfaces retryAfterSeconds when throttled", async () => {
    installSharedBucket();
    await checkRateLimit({ key: "k:c", windowSeconds: 60, max: 1 });
    const throttled = await checkRateLimit({ key: "k:c", windowSeconds: 60, max: 1 });

    expect(throttled.allowed).toBe(false);
    expect(throttled.retryAfterSeconds).toBeGreaterThan(0);
  });

  it("fails open when the RPC errors (availability over strict limiting)", async () => {
    rpc.mockResolvedValue({ data: null, error: { message: "db down" } });

    const result = await checkRateLimit({ key: "k:d", windowSeconds: 60, max: 5 });

    expect(result.allowed).toBe(true);
  });
});

describe("durable rate limiter — migration contract", () => {
  it("defines a service-role-only bucket table with a composite key", () => {
    expect(MIGRATION_SQL).toContain("CREATE TABLE public.rate_limit_buckets");
    expect(MIGRATION_SQL).toContain("PRIMARY KEY (key, window_start)");
    expect(MIGRATION_SQL).toContain(
      "ALTER TABLE public.rate_limit_buckets ENABLE ROW LEVEL SECURITY",
    );
    expect(MIGRATION_SQL).toContain(
      "GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE public.rate_limit_buckets TO service_role",
    );
  });

  it("increments the window bucket atomically", () => {
    expect(MIGRATION_SQL).toContain(
      "CREATE OR REPLACE FUNCTION public.consume_rate_limit",
    );
    expect(MIGRATION_SQL).toContain("ON CONFLICT (key, window_start) DO UPDATE");
    expect(MIGRATION_SQL).toContain(
      "GRANT EXECUTE ON FUNCTION public.consume_rate_limit(TEXT, INTEGER, INTEGER) TO service_role",
    );
  });
});
