import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";
import {
  BADGE_UPSERT_OPTIONS,
  sevenDayStreakBadgeRow,
  shouldAwardSevenDayStreakBadge,
} from "@/lib/gamification/streakBadges";

export type StudyActivityType = "lesson" | "practice" | "nex" | "diagnostic";

export function getNairobiDateString(): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date());
}

function calculateLevel(totalXp: number): number {
  return Math.max(1, Math.floor(totalXp / 100) + 1);
}

export async function updateStudentStreak(studentId: string): Promise<number> {
  const admin = createAdminClient();
  const today = getNairobiDateString();
  const { data: streak } = await admin
    .from("student_streaks")
    .select("*")
    .eq("student_id", studentId)
    .maybeSingle();

  if (!streak) {
    await admin.from("student_streaks").insert({
      student_id: studentId,
      current_streak: 1,
      longest_streak: 1,
      last_activity_date: today,
    });
    return 1;
  }

  const lastDate = streak.last_activity_date;
  let currentStreak = streak.current_streak;

  if (lastDate === today) {
    return currentStreak;
  }

  const yesterday = new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(new Date(Date.now() - 86_400_000));

  currentStreak = lastDate === yesterday ? currentStreak + 1 : 1;

  await admin
    .from("student_streaks")
    .update({
      current_streak: currentStreak,
      longest_streak: Math.max(streak.longest_streak, currentStreak),
      last_activity_date: today,
    })
    .eq("student_id", studentId);

  if (shouldAwardSevenDayStreakBadge(currentStreak)) {
    await admin.from("student_badges").upsert(
      sevenDayStreakBadgeRow(studentId),
      BADGE_UPSERT_OPTIONS,
    );

    const { data: profile } = await admin
      .from("student_profiles")
      .select("full_name, phone_number")
      .eq("id", studentId)
      .maybeSingle();

    const { sendWeeklyStreakNotification } = await import(
      "@/server/services/notificationService"
    );
    await sendWeeklyStreakNotification({
      studentId,
      phoneNumber: profile?.phone_number ?? null,
      studentName: profile?.full_name ?? "Student",
    }).catch(() => undefined);
  }

  return currentStreak;
}

async function awardXp(studentId: string, xpEarned: number): Promise<void> {
  if (xpEarned <= 0) {
    return;
  }

  const admin = createAdminClient();
  const { data: existingXp } = await admin
    .from("student_xp")
    .select("total_xp")
    .eq("student_id", studentId)
    .maybeSingle();

  const totalXp = (existingXp?.total_xp ?? 0) + xpEarned;

  await admin.from("student_xp").upsert(
    {
      student_id: studentId,
      total_xp: totalXp,
      current_level: calculateLevel(totalXp),
    },
    { onConflict: "student_id" },
  );
}

export interface AwardStudyActivityInput {
  studentId: string;
  activityType: StudyActivityType;
  activityId: string;
  durationSeconds: number;
  /** When set, awards this XP amount (lessons). Practice XP stays in awardPracticeGamification. */
  xpEarned?: number;
}

export async function awardStudyActivity(
  input: AwardStudyActivityInput,
): Promise<{ currentStreak: number; xpEarned: number; minutesCompleted: number }> {
  const admin = createAdminClient();
  const durationSeconds = Math.max(0, input.durationSeconds);
  const minutesCompleted = Math.max(1, Math.round(durationSeconds / 60));
  const today = getNairobiDateString();

  const { data: dailyGoal } = await admin
    .from("daily_goals")
    .select("*")
    .eq("student_id", input.studentId)
    .eq("goal_date", today)
    .maybeSingle();

  const nextMinutes = (dailyGoal?.minutes_completed ?? 0) + minutesCompleted;
  const dailyGoalMinutes = dailyGoal?.daily_goal_minutes ?? 20;

  await admin.from("daily_goals").upsert(
    {
      student_id: input.studentId,
      goal_date: today,
      daily_goal_minutes: dailyGoalMinutes,
      minutes_completed: nextMinutes,
      is_completed: nextMinutes >= dailyGoalMinutes,
    },
    { onConflict: "student_id,goal_date" },
  );

  await admin.from("study_time_logs").insert({
    student_id: input.studentId,
    activity_type: input.activityType,
    activity_id: input.activityId,
    duration_seconds: durationSeconds,
  });

  const xpEarned = input.xpEarned ?? 0;
  if (xpEarned > 0) {
    await awardXp(input.studentId, xpEarned);
  }

  const currentStreak = await updateStudentStreak(input.studentId);

  const { data: progress } = await admin
    .from("student_progress")
    .select("*")
    .eq("student_id", input.studentId)
    .maybeSingle();

  if (progress && durationSeconds > 0) {
    await admin
      .from("student_progress")
      .update({
        total_study_time_seconds:
          progress.total_study_time_seconds + durationSeconds,
      })
      .eq("id", progress.id);
  }

  return { currentStreak, xpEarned, minutesCompleted };
}
