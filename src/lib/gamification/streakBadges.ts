export const SEVEN_DAY_STREAK_BADGE = "seven_day_streak" as const;

export const BADGE_UPSERT_OPTIONS = {
  onConflict: "student_id,badge_code",
  ignoreDuplicates: true,
} as const;

export function shouldAwardSevenDayStreakBadge(currentStreak: number): boolean {
  return currentStreak === 7;
}

export function sevenDayStreakBadgeRow(studentId: string) {
  return {
    student_id: studentId,
    badge_code: SEVEN_DAY_STREAK_BADGE,
  };
}
