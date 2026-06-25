import { describe, expect, it } from "vitest";

import {
  STUDENT_EXPERIENCE_FEATURES,
  STUDENT_NAV_GROUPS,
  buildStudentActionBadges,
  buildStudentExperienceSnapshot,
  getStudentFeatureById,
} from "@/features/student/studentExperience";

const bannedWords = /\b(command center|telemetry)\b/i;

describe("student experience contracts", () => {
  it("exposes all sixteen approved student features with human labels", () => {
    expect(STUDENT_EXPERIENCE_FEATURES).toHaveLength(16);
    expect(STUDENT_EXPERIENCE_FEATURES.map((feature) => feature.id)).toEqual([
      "today",
      "continue-learning",
      "weak-areas",
      "exam-readiness",
      "tasks",
      "saved-questions",
      "mistake-journal",
      "learning-memory",
      "grouped-navigation",
      "smart-badges",
      "student-footer",
      "study-search",
      "offline-packs",
      "weekly-goal",
      "focus-sessions",
      "concept-library",
    ]);

    for (const feature of STUDENT_EXPERIENCE_FEATURES) {
      expect(feature.label).not.toMatch(bannedWords);
      expect(feature.shortLabel).not.toMatch(bannedWords);
      expect(feature.description).not.toMatch(bannedWords);
      expect(feature.href).toMatch(/^\//);
    }
  });

  it("groups student navigation into useful study sections", () => {
    expect(STUDENT_NAV_GROUPS.map((group) => group.label)).toEqual([
      "Today",
      "Study",
      "Practice",
      "Tools",
      "Me",
    ]);

    const navLabels = STUDENT_NAV_GROUPS.flatMap((group) =>
      group.items.map((item) => item.label),
    );

    expect(navLabels).toContain("Dashboard");
    expect(navLabels).toContain("Continue learning");
    expect(navLabels).toContain("Study search");
    expect(navLabels).toContain("Learning memory");
    expect(navLabels.join(" ")).not.toMatch(bannedWords);
  });

  it("builds action badges from real student counts", () => {
    const badges = buildStudentActionBadges({
      dueTasks: 3,
      weakAreas: 2,
      savedItems: 4,
      mistakesToReview: 5,
      focusMinutesToday: 25,
      offlinePacksReady: 1,
    });

    expect(badges["/tasks"]).toBe("3");
    expect(badges["/weak-areas"]).toBe("2");
    expect(badges["/saved"]).toBe("4");
    expect(badges["/mistakes"]).toBe("5");
    expect(badges["/focus"]).toBe("25m");
    expect(badges["/offline"]).toBe("1");
  });

  it("creates a dashboard snapshot that connects the priority student surfaces", () => {
    const snapshot = buildStudentExperienceSnapshot({
      studentFirstName: "Garnet",
      healthScore: 72,
      predictedGrade: "B+",
      currentStreak: 6,
      totalXp: 640,
      recommendedTopic: {
        title: "Linear equations",
        topicId: "topic-1",
        masteryPercentage: 48,
      },
      nextTask: {
        title: "Practice simultaneous equations",
        href: "/practice?topicId=topic-1",
      },
      dailyGoalMinutes: 30,
      completedMinutes: 18,
      weeklyGoalMinutes: 180,
      weeklyCompletedMinutes: 85,
      savedItems: 4,
      mistakesToReview: 5,
      focusMinutesToday: 25,
      offlinePacksReady: 1,
    });

    expect(snapshot.greeting).toContain("Garnet");
    expect(snapshot.primaryAction.href).toBe("/practice?topicId=topic-1");
    expect(snapshot.weeklyGoal.percent).toBe(47);
    expect(snapshot.quickLinks.map((link) => link.href)).toEqual([
      "/continue",
      "/weak-areas",
      "/readiness",
      "/tasks",
      "/saved",
      "/mistakes",
      "/nex-memory",
      "/study-search",
      "/offline",
      "/weekly-goal",
      "/focus",
      "/library",
    ]);
    expect(snapshot.quickLinks.map((link) => link.label).join(" ")).not.toMatch(
      bannedWords,
    );
  });

  it("can look up a single feature for pages and search results", () => {
    expect(getStudentFeatureById("study-search")?.label).toBe("Study search");
    expect(getStudentFeatureById("unknown")).toBeNull();
  });
});
