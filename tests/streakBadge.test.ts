import { describe, expect, it } from "vitest";

import {
  BADGE_UPSERT_OPTIONS,
  SEVEN_DAY_STREAK_BADGE,
  sevenDayStreakBadgeRow,
  shouldAwardSevenDayStreakBadge,
} from "@/lib/gamification/streakBadges";

describe("streakBadges", () => {
  it("awards seven_day_streak only on day 7", () => {
    expect(shouldAwardSevenDayStreakBadge(6)).toBe(false);
    expect(shouldAwardSevenDayStreakBadge(7)).toBe(true);
    expect(shouldAwardSevenDayStreakBadge(8)).toBe(false);
  });

  it("builds idempotent badge upsert payload", () => {
    expect(sevenDayStreakBadgeRow("student-1")).toEqual({
      student_id: "student-1",
      badge_code: SEVEN_DAY_STREAK_BADGE,
    });
    expect(BADGE_UPSERT_OPTIONS).toEqual({
      onConflict: "student_id,badge_code",
      ignoreDuplicates: true,
    });
  });
});
