import { describe, expect, it } from "vitest";

import { shouldShowDashboardEmptyState } from "@/features/dashboard/components/DashboardEmptyStates";
import { teacherWaitlistSchema } from "@/schemas/waitlistSchemas";

describe("teacherWaitlistSchema", () => {
  it("accepts valid submissions", () => {
    const parsed = teacherWaitlistSchema.safeParse({
      email: "teacher@school.ke",
      fullName: "Jane Wanjiku",
      schoolName: "Alliance Girls",
      curriculum: "CBC",
    });

    expect(parsed.success).toBe(true);
  });

  it("rejects invalid email", () => {
    const parsed = teacherWaitlistSchema.safeParse({
      email: "not-an-email",
      fullName: "Jane Wanjiku",
      schoolName: "Alliance Girls",
    });

    expect(parsed.success).toBe(false);
  });

  it("allows optional curriculum", () => {
    const parsed = teacherWaitlistSchema.safeParse({
      email: "teacher@school.ke",
      fullName: "Jane Wanjiku",
      schoolName: "Alliance Girls",
    });

    expect(parsed.success).toBe(true);
  });
});

describe("shouldShowDashboardEmptyState", () => {
  it("shows empty state for brand new students", () => {
    expect(
      shouldShowDashboardEmptyState({
        topicMastery: [],
        totalXp: 0,
        currentStreak: 0,
        hasStudyPlanTasks: false,
      }),
    ).toBe(true);
  });

  it("hides empty state when mastery exists", () => {
    expect(
      shouldShowDashboardEmptyState({
        topicMastery: [{ masteryPercentage: 10 }],
        totalXp: 0,
        currentStreak: 0,
        hasStudyPlanTasks: false,
      }),
    ).toBe(false);
  });
});
