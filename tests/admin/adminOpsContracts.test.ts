import {
  adminFeatureRolloutUpsertSchema,
  adminSupportCaseCreateSchema,
} from "@/schemas/adminOpsSchemas";
import {
  buildCampaignSummary,
  buildContentQualitySummary,
  buildLifecycleFunnel,
  classifyStudentIntervention,
} from "@/server/services/adminOpsSummary";
import { describe, expect, it } from "vitest";

describe("admin ops contracts", () => {
  it("validates support case creation input", () => {
    const result = adminSupportCaseCreateSchema.safeParse({
      targetStudentId: "11111111-1111-4111-8111-111111111111",
      issueType: "billing",
      priority: "urgent",
      title: "Parent paid but subscription did not activate",
      notes: "M-Pesa receipt exists.",
    });

    expect(result.success).toBe(true);
    if (result.success) {
      expect(result.data.status).toBe("open");
      expect(result.data.priority).toBe("urgent");
    }
  });

  it("rejects rollout flags without a scope value for scoped rollouts", () => {
    const result = adminFeatureRolloutUpsertSchema.safeParse({
      featureKey: "voice_tutor",
      displayName: "Voice tutor",
      isEnabled: true,
      scope: "grade",
    });

    expect(result.success).toBe(false);
  });

  it("builds lifecycle funnel percentages from product counts", () => {
    const funnel = buildLifecycleFunnel({
      signups: 100,
      completedOnboarding: 80,
      diagnosticsCompleted: 60,
      firstNexChats: 45,
      firstPracticeSessions: 30,
      activeDay7: 20,
      trialStarts: 10,
      paidSubscriptions: 5,
    });

    expect(funnel.map((step) => step.rateFromPrevious)).toEqual([
      100, 80, 75, 75, 66.7, 66.7, 50, 50,
    ]);
  });

  it("classifies intervention severity from student risk signals", () => {
    const item = classifyStudentIntervention({
      studentId: "student-1",
      studentName: "Amina",
      curriculum: "KCSE",
      gradeLevel: "Form 2",
      hasCompletedDiagnostic: false,
      healthScore: 42,
      lastActivityAt: null,
      nexMessagesLast7d: 90,
      practiceSessionsLast7d: 0,
    });

    expect(item.severity).toBe("critical");
    expect(item.reasons).toContain("Diagnostic incomplete");
    expect(item.reasons).toContain("High Nex usage without practice");
  });

  it("summarizes content quality gaps across coverage", () => {
    const summary = buildContentQualitySummary([
      {
        code: "mathematics",
        name: "Mathematics",
        curricula: [
          {
            code: "KCSE",
            gradeLevels: ["Form 1"],
            topics: [
              {
                id: "topic-1",
                code: "algebra",
                title: "Algebra",
                publishedLessonCount: 0,
                draftLessonCount: 1,
                readinessLabel: "NOT_READY",
                questionCounts: { easy: 1, medium: 0, hard: 0 },
                subtopics: [],
              },
            ],
          },
        ],
      },
    ]);

    expect(summary.topicCount).toBe(1);
    expect(summary.topGaps[0]?.title).toBe("Algebra");
    expect(summary.topGaps[0]?.missingLesson).toBe(true);
  });

  it("summarizes campaign usage from invites and coupons", () => {
    const summary = buildCampaignSummary({
      invites: [
        { use_count: 2, max_uses: 5, is_active: true, expires_at: null },
        { use_count: 5, max_uses: 5, is_active: false, expires_at: null },
      ],
      coupons: [
        { usedCount: 3, maxUses: 10, isActive: true, expiresAt: null },
      ],
    });

    expect(summary.activeInvites).toBe(1);
    expect(summary.inviteUses).toBe(7);
    expect(summary.activeCoupons).toBe(1);
    expect(summary.couponUses).toBe(3);
  });
});
