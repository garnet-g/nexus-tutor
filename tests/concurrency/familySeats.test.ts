/**
 * @vitest-environment node
 *
 * PR-016: family seat joins must be a single FOR UPDATE transaction so
 * concurrent joins can never oversell seats, with RAISE tokens mapped back to
 * the established user-facing strings.
 */
import { readFileSync } from "node:fs";
import { join } from "node:path";

import { beforeEach, describe, expect, it, vi } from "vitest";

const rpc = vi.fn();
const from = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({ rpc, from })),
}));

import { joinFamilyGroupWithCode } from "@/server/services/familySubscriptionService";

const MIGRATION_SQL = readFileSync(
  join(
    process.cwd(),
    "supabase/migrations/20260702090000_atomic_usage_and_seats.sql",
  ),
  "utf8",
);

/** Atomic in-memory join_family_group: seat check + mutation with no interleave. */
function installAtomicJoinRpc(maxSeats: number): { seats: () => number } {
  let seatCount = 1; // owner occupies the first seat
  const members = new Set<string>(["owner"]);

  rpc.mockImplementation(async (name: string, params: Record<string, unknown>) => {
    if (name !== "join_family_group") {
      throw new Error(`unexpected rpc ${name}`);
    }

    const studentId = params.p_student_id as string;

    if (members.has(studentId)) {
      return { data: null, error: { message: "ALREADY_MEMBER" } };
    }
    if (seatCount >= maxSeats) {
      return { data: null, error: { message: "NO_SEATS" } };
    }

    seatCount += 1;
    members.add(studentId);
    return {
      data: { family_group_id: "group-1", seats_remaining: maxSeats - seatCount },
      error: null,
    };
  });

  return { seats: () => seatCount };
}

beforeEach(() => {
  rpc.mockReset();
  from.mockReset();
});

describe("Family seats — atomic enforcement", () => {
  it("never oversells seats under 20 parallel joins", async () => {
    const maxSeats = 4; // 1 owner + 3 joinable
    const store = installAtomicJoinRpc(maxSeats);

    const outcomes = await Promise.allSettled(
      Array.from({ length: 20 }, (_, i) =>
        joinFamilyGroupWithCode({ studentId: `student-${i}`, inviteCode: "FAMILY-ABC123" }),
      ),
    );

    const joined = outcomes.filter((o) => o.status === "fulfilled");
    const rejected = outcomes.filter((o) => o.status === "rejected");

    expect(joined).toHaveLength(maxSeats - 1);
    expect(store.seats()).toBe(maxSeats);
    for (const r of rejected) {
      expect((r as PromiseRejectedResult).reason).toHaveProperty(
        "message",
        "Family plan has no seats remaining",
      );
    }
    expect(from).not.toHaveBeenCalled();
  });

  it.each([
    ["NO_SEATS", "Family plan has no seats remaining"],
    ["ALREADY_MEMBER", "Student is already on a family plan"],
    ["INVALID_CODE", "Invalid or expired family invite code"],
  ])("maps the %s token to its user-facing message", async (token, message) => {
    rpc.mockResolvedValue({ data: null, error: { message: token } });

    await expect(
      joinFamilyGroupWithCode({ studentId: "s1", inviteCode: "X" }),
    ).rejects.toThrow(message);
  });
});

describe("Family seats — migration contract", () => {
  it("locks the group row and raises seat/membership tokens", () => {
    expect(MIGRATION_SQL).toContain(
      "CREATE OR REPLACE FUNCTION public.join_family_group",
    );
    expect(MIGRATION_SQL).toContain("FOR UPDATE");
    expect(MIGRATION_SQL).toContain("RAISE EXCEPTION 'NO_SEATS'");
    expect(MIGRATION_SQL).toContain("RAISE EXCEPTION 'ALREADY_MEMBER'");
    expect(MIGRATION_SQL).toContain("RAISE EXCEPTION 'INVALID_CODE'");
  });
});
