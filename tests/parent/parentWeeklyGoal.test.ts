/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const maybeSingle = vi.fn();

const supabase = {
  from: () => ({
    select: () => ({
      eq: () => ({
        eq: () => ({
          maybeSingle,
        }),
      }),
    }),
  }),
};

import { getParentVisibleWeeklyGoal } from "@/server/services/parentLinkService";

describe("getParentVisibleWeeklyGoal (parent RLS client)", () => {
  beforeEach(() => {
    maybeSingle.mockReset();
  });

  it("returns null when RLS hides the row", async () => {
    maybeSingle.mockResolvedValue({ data: null, error: null });

    await expect(
      getParentVisibleWeeklyGoal(supabase as never, "student-1"),
    ).resolves.toBeNull();
  });

  it("returns mapped goal when parent RLS allows the row", async () => {
    maybeSingle.mockResolvedValue({
      data: {
        target_minutes: 180,
        target_tasks: 6,
        note: "Finish algebra revision",
        week_start_date: "2026-07-06",
      },
      error: null,
    });

    await expect(
      getParentVisibleWeeklyGoal(supabase as never, "student-1"),
    ).resolves.toEqual({
      targetMinutes: 180,
      targetTasks: 6,
      note: "Finish algebra revision",
      weekStartDate: "2026-07-06",
    });
  });
});
