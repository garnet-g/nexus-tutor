/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const maybeSingle = vi.fn();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: () => ({
      select: () => ({
        eq: () => ({
          eq: () => ({
            eq: () => ({
              maybeSingle,
            }),
          }),
        }),
      }),
    }),
  })),
}));

import { getParentVisibleWeeklyGoal } from "@/server/services/parentLinkService";

describe("getParentVisibleWeeklyGoal", () => {
  beforeEach(() => {
    maybeSingle.mockReset();
  });

  it("returns null when no parent-visible goal exists", async () => {
    maybeSingle.mockResolvedValue({ data: null, error: null });

    await expect(getParentVisibleWeeklyGoal("student-1")).resolves.toBeNull();
  });

  it("returns mapped goal when parent_visible row exists", async () => {
    maybeSingle.mockResolvedValue({
      data: {
        target_minutes: 180,
        target_tasks: 6,
        note: "Finish algebra revision",
        week_start_date: "2026-07-06",
      },
      error: null,
    });

    await expect(getParentVisibleWeeklyGoal("student-1")).resolves.toEqual({
      targetMinutes: 180,
      targetTasks: 6,
      note: "Finish algebra revision",
      weekStartDate: "2026-07-06",
    });
  });
});
