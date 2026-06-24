import type { ContentCoverageSubject } from "@/types/contentAdmin";

export type LifecycleCounts = {
  signups: number;
  completedOnboarding: number;
  diagnosticsCompleted: number;
  firstNexChats: number;
  firstPracticeSessions: number;
  activeDay7: number;
  trialStarts: number;
  paidSubscriptions: number;
};

export type LifecycleStep = {
  key: keyof LifecycleCounts;
  label: string;
  value: number;
  rateFromPrevious: number;
};

const LIFECYCLE_LABELS: Array<[keyof LifecycleCounts, string]> = [
  ["signups", "Signups"],
  ["completedOnboarding", "Onboarded"],
  ["diagnosticsCompleted", "Diagnostic complete"],
  ["firstNexChats", "First Nex chat"],
  ["firstPracticeSessions", "First practice"],
  ["activeDay7", "Active day 7"],
  ["trialStarts", "Trial started"],
  ["paidSubscriptions", "Paid"],
];

function round1(value: number): number {
  return Math.round(value * 10) / 10;
}

export function buildLifecycleFunnel(counts: LifecycleCounts): LifecycleStep[] {
  let previous = counts.signups;

  return LIFECYCLE_LABELS.map(([key, label], index) => {
    const value = counts[key];
    const rateFromPrevious =
      index === 0 ? 100 : previous === 0 ? 0 : round1((value / previous) * 100);
    previous = value;
    return { key, label, value, rateFromPrevious };
  });
}

export type StudentRiskSignal = {
  studentId: string;
  studentName: string;
  curriculum: string;
  gradeLevel: string;
  hasCompletedDiagnostic: boolean;
  healthScore: number | null;
  lastActivityAt: string | null;
  nexMessagesLast7d: number;
  practiceSessionsLast7d: number;
};

export type InterventionSeverity = "watch" | "urgent" | "critical";

export type InterventionQueueItem = StudentRiskSignal & {
  severity: InterventionSeverity;
  reasons: string[];
  actionLabel: string;
};

function isInactive(lastActivityAt: string | null): boolean {
  if (!lastActivityAt) {
    return true;
  }

  const sevenDaysAgo = Date.now() - 7 * 24 * 60 * 60 * 1000;
  return new Date(lastActivityAt).getTime() < sevenDaysAgo;
}

export function classifyStudentIntervention(
  signal: StudentRiskSignal,
): InterventionQueueItem {
  const reasons: string[] = [];
  let score = 0;

  if (!signal.hasCompletedDiagnostic) {
    reasons.push("Diagnostic incomplete");
    score += 3;
  }

  if (signal.healthScore !== null && signal.healthScore < 50) {
    reasons.push("Low health score");
    score += 3;
  }

  if (isInactive(signal.lastActivityAt)) {
    reasons.push("No recent activity");
    score += 2;
  }

  if (signal.nexMessagesLast7d >= 50 && signal.practiceSessionsLast7d === 0) {
    reasons.push("High Nex usage without practice");
    score += 3;
  }

  if (signal.nexMessagesLast7d === 0 && signal.practiceSessionsLast7d === 0) {
    reasons.push("No learning activity this week");
    score += 1;
  }

  const severity: InterventionSeverity =
    score >= 6 ? "critical" : score >= 3 ? "urgent" : "watch";

  const actionLabel =
    severity === "critical"
      ? "Open support case"
      : severity === "urgent"
        ? "Review profile"
        : "Monitor";

  return {
    ...signal,
    severity,
    reasons: reasons.length > 0 ? reasons : ["Monitor progress"],
    actionLabel,
  };
}

export type ContentQualityGap = {
  subject: string;
  curriculum: string;
  title: string;
  readinessLabel: string;
  missingLesson: boolean;
  questionCount: number;
};

export type ContentQualitySummary = {
  subjectCount: number;
  topicCount: number;
  publishedLessons: number;
  draftLessons: number;
  weakQuestionTopics: number;
  missingLessonTopics: number;
  topGaps: ContentQualityGap[];
};

export function buildContentQualitySummary(
  coverage: ContentCoverageSubject[],
): ContentQualitySummary {
  const gaps: ContentQualityGap[] = [];
  let topicCount = 0;
  let publishedLessons = 0;
  let draftLessons = 0;
  let weakQuestionTopics = 0;
  let missingLessonTopics = 0;

  for (const subject of coverage) {
    for (const curriculum of subject.curricula) {
      for (const topic of curriculum.topics) {
        topicCount += 1;
        publishedLessons += topic.publishedLessonCount;
        draftLessons += topic.draftLessonCount;
        const questionCount =
          topic.questionCounts.easy +
          topic.questionCounts.medium +
          topic.questionCounts.hard;
        const missingLesson = topic.publishedLessonCount === 0;
        const weakQuestions = questionCount < 5;

        if (missingLesson) {
          missingLessonTopics += 1;
        }
        if (weakQuestions) {
          weakQuestionTopics += 1;
        }
        if (missingLesson || weakQuestions) {
          gaps.push({
            subject: subject.name,
            curriculum: curriculum.code,
            title: topic.title,
            readinessLabel: topic.readinessLabel,
            missingLesson,
            questionCount,
          });
        }
      }
    }
  }

  return {
    subjectCount: coverage.length,
    topicCount,
    publishedLessons,
    draftLessons,
    weakQuestionTopics,
    missingLessonTopics,
    topGaps: gaps
      .sort((a, b) => {
        if (a.missingLesson !== b.missingLesson) {
          return a.missingLesson ? -1 : 1;
        }
        return a.questionCount - b.questionCount;
      })
      .slice(0, 8),
  };
}

type CampaignInviteLite = {
  use_count: number;
  max_uses: number;
  is_active: boolean;
  expires_at: string | null;
};

type CampaignCouponLite = {
  usedCount: number;
  maxUses: number | null;
  isActive: boolean;
  expiresAt: string | null;
};

export type CampaignSummary = {
  activeInvites: number;
  inviteCapacity: number;
  inviteUses: number;
  activeCoupons: number;
  couponCapacity: number | null;
  couponUses: number;
};

function isActiveUntil(value: { is_active?: boolean; isActive?: boolean; expires_at?: string | null; expiresAt?: string | null }) {
  const active = value.is_active ?? value.isActive ?? false;
  const expiresAt = value.expires_at ?? value.expiresAt ?? null;
  return active && (!expiresAt || new Date(expiresAt).getTime() > Date.now());
}

export function buildCampaignSummary(input: {
  invites: CampaignInviteLite[];
  coupons: CampaignCouponLite[];
}): CampaignSummary {
  const activeInvites = input.invites.filter(isActiveUntil);
  const activeCoupons = input.coupons.filter(isActiveUntil);
  const finiteCouponCapacity = activeCoupons
    .map((coupon) => coupon.maxUses)
    .filter((value): value is number => value !== null);

  return {
    activeInvites: activeInvites.length,
    inviteCapacity: activeInvites.reduce((sum, invite) => sum + invite.max_uses, 0),
    inviteUses: input.invites.reduce((sum, invite) => sum + invite.use_count, 0),
    activeCoupons: activeCoupons.length,
    couponCapacity:
      finiteCouponCapacity.length === activeCoupons.length
        ? finiteCouponCapacity.reduce((sum, value) => sum + value, 0)
        : null,
    couponUses: input.coupons.reduce((sum, coupon) => sum + coupon.usedCount, 0),
  };
}
