export type StudentFeatureId =
  | "today"
  | "continue-learning"
  | "weak-areas"
  | "exam-readiness"
  | "tasks"
  | "saved-questions"
  | "mistake-journal"
  | "learning-memory"
  | "grouped-navigation"
  | "smart-badges"
  | "student-footer"
  | "study-search"
  | "offline-packs"
  | "weekly-goal"
  | "focus-sessions"
  | "concept-library";

export type StudentFeature = {
  id: StudentFeatureId;
  label: string;
  shortLabel: string;
  description: string;
  href: string;
};

export type StudentNavItem = {
  href: string;
  label: string;
  featureId?: StudentFeatureId;
  badgeKey?: keyof StudentActionBadgeInput;
};

export type StudentNavGroup = {
  label: "Today" | "Study" | "Practice" | "Tools" | "Me";
  items: StudentNavItem[];
};

export type StudentActionBadgeInput = {
  dueTasks?: number;
  weakAreas?: number;
  savedItems?: number;
  mistakesToReview?: number;
  focusMinutesToday?: number;
  offlinePacksReady?: number;
};

export type StudentExperienceSnapshotInput = StudentActionBadgeInput & {
  studentFirstName?: string | null;
  healthScore?: number | null;
  predictedGrade?: string | null;
  currentStreak?: number;
  totalXp?: number;
  recommendedTopic?: {
    title: string;
    topicId?: string | null;
    masteryPercentage?: number | null;
  } | null;
  nextTask?: {
    title: string;
    href: string;
  } | null;
  dailyGoalMinutes?: number;
  completedMinutes?: number;
  weeklyGoalMinutes?: number;
  weeklyCompletedMinutes?: number;
};

export type StudentExperienceSnapshot = {
  greeting: string;
  healthScore: number;
  predictedGrade: string | null;
  streak: number;
  totalXp: number;
  primaryAction: {
    label: string;
    title: string;
    href: string;
  };
  dailyGoal: {
    minutes: number;
    completed: number;
    left: number;
    percent: number;
  };
  weeklyGoal: {
    minutes: number;
    completed: number;
    left: number;
    percent: number;
  };
  quickLinks: Array<{
    label: string;
    href: string;
    description: string;
    count?: string;
  }>;
};

export const STUDENT_EXPERIENCE_FEATURES: StudentFeature[] = [
  {
    id: "today",
    label: "Dashboard",
    shortLabel: "Today",
    description: "The first stop for the next lesson, goals, progress, and study actions.",
    href: "/dashboard",
  },
  {
    id: "continue-learning",
    label: "Continue learning",
    shortLabel: "Continue",
    description: "Resume the lesson, topic, or practice flow that matters next.",
    href: "/continue",
  },
  {
    id: "weak-areas",
    label: "Weak areas",
    shortLabel: "Weak areas",
    description: "A focused queue of topics that need attention before they become gaps.",
    href: "/weak-areas",
  },
  {
    id: "exam-readiness",
    label: "Exam readiness",
    shortLabel: "Readiness",
    description: "A clear view of mock exams, predicted grade, and what to improve next.",
    href: "/readiness",
  },
  {
    id: "tasks",
    label: "Tasks",
    shortLabel: "Tasks",
    description: "Daily study tasks from the active study plan.",
    href: "/tasks",
  },
  {
    id: "saved-questions",
    label: "Saved questions",
    shortLabel: "Saved",
    description: "Questions, lessons, and topics kept for another look.",
    href: "/saved",
  },
  {
    id: "mistake-journal",
    label: "Mistake journal",
    shortLabel: "Mistakes",
    description: "A review list of missed or confusing questions with retry status.",
    href: "/mistakes",
  },
  {
    id: "learning-memory",
    label: "Learning memory",
    shortLabel: "Memory",
    description: "A student-friendly record of what Nex should remember about study habits.",
    href: "/nex-memory",
  },
  {
    id: "grouped-navigation",
    label: "Grouped navigation",
    shortLabel: "Navigation",
    description: "Student routes grouped by how learners think about their day.",
    href: "/dashboard",
  },
  {
    id: "smart-badges",
    label: "Helpful badges",
    shortLabel: "Badges",
    description: "Small counts that show due tasks, reviews, saved items, and ready packs.",
    href: "/dashboard",
  },
  {
    id: "student-footer",
    label: "Student footer",
    shortLabel: "Footer",
    description: "A clearer student profile area with streak, XP level, plan, and sign out.",
    href: "/profile",
  },
  {
    id: "study-search",
    label: "Study search",
    shortLabel: "Search",
    description: "Find lessons, topics, questions, pages, and next actions from one place.",
    href: "/study-search",
  },
  {
    id: "offline-packs",
    label: "Offline packs",
    shortLabel: "Offline",
    description: "Low-data study packs students can prepare before unreliable connection windows.",
    href: "/offline",
  },
  {
    id: "weekly-goal",
    label: "Weekly goal",
    shortLabel: "Weekly goal",
    description: "A parent-visible weekly target for minutes, tasks, and consistency.",
    href: "/weekly-goal",
  },
  {
    id: "focus-sessions",
    label: "Focus sessions",
    shortLabel: "Focus",
    description: "Timed study sessions for focused work and daily minutes.",
    href: "/focus",
  },
  {
    id: "concept-library",
    label: "Concept library",
    shortLabel: "Library",
    description: "A quick reference for formulas, definitions, and important ideas.",
    href: "/library",
  },
];

export const STUDENT_NAV_GROUPS: StudentNavGroup[] = [
  {
    label: "Today",
    items: [
      { href: "/dashboard", label: "Dashboard", featureId: "today" },
      {
        href: "/continue",
        label: "Continue learning",
        featureId: "continue-learning",
      },
      { href: "/tasks", label: "Tasks", featureId: "tasks", badgeKey: "dueTasks" },
    ],
  },
  {
    label: "Study",
    items: [
      { href: "/learn", label: "Learn" },
      { href: "/study-search", label: "Study search", featureId: "study-search" },
      { href: "/library", label: "Concept library", featureId: "concept-library" },
      { href: "/study-plan", label: "Study plan" },
      { href: "/weekly-goal", label: "Weekly goal", featureId: "weekly-goal" },
    ],
  },
  {
    label: "Practice",
    items: [
      { href: "/practice", label: "Practice" },
      { href: "/revision", label: "Revision" },
      {
        href: "/weak-areas",
        label: "Weak areas",
        featureId: "weak-areas",
        badgeKey: "weakAreas",
      },
      {
        href: "/mistakes",
        label: "Mistake journal",
        featureId: "mistake-journal",
        badgeKey: "mistakesToReview",
      },
      { href: "/readiness", label: "Exam readiness", featureId: "exam-readiness" },
      { href: "/mock-exams", label: "Mock exams" },
    ],
  },
  {
    label: "Tools",
    items: [
      { href: "/nex", label: "Ask Nex" },
      { href: "/nex-memory", label: "Learning memory", featureId: "learning-memory" },
      {
        href: "/saved",
        label: "Saved questions",
        featureId: "saved-questions",
        badgeKey: "savedItems",
      },
      {
        href: "/focus",
        label: "Focus sessions",
        featureId: "focus-sessions",
        badgeKey: "focusMinutesToday",
      },
      {
        href: "/offline",
        label: "Offline packs",
        featureId: "offline-packs",
        badgeKey: "offlinePacksReady",
      },
    ],
  },
  {
    label: "Me",
    items: [
      { href: "/progress", label: "Progress" },
      { href: "/profile", label: "Profile" },
    ],
  },
];

export function getStudentFeatureById(id: string): StudentFeature | null {
  return (
    STUDENT_EXPERIENCE_FEATURES.find((feature) => feature.id === id) ?? null
  );
}

export function buildStudentActionBadges(
  input: StudentActionBadgeInput,
): Record<string, string> {
  const badges: Record<string, string> = {};

  if ((input.dueTasks ?? 0) > 0) badges["/tasks"] = String(input.dueTasks);
  if ((input.weakAreas ?? 0) > 0) badges["/weak-areas"] = String(input.weakAreas);
  if ((input.savedItems ?? 0) > 0) badges["/saved"] = String(input.savedItems);
  if ((input.mistakesToReview ?? 0) > 0) {
    badges["/mistakes"] = String(input.mistakesToReview);
  }
  if ((input.focusMinutesToday ?? 0) > 0) {
    badges["/focus"] = `${input.focusMinutesToday}m`;
  }
  if ((input.offlinePacksReady ?? 0) > 0) {
    badges["/offline"] = String(input.offlinePacksReady);
  }

  return badges;
}

export function buildStudentExperienceSnapshot(
  input: StudentExperienceSnapshotInput,
): StudentExperienceSnapshot {
  const topicTitle = input.recommendedTopic?.title ?? "your next topic";
  const actionHref =
    input.nextTask?.href ??
    (input.recommendedTopic?.topicId
      ? `/practice?topicId=${input.recommendedTopic.topicId}`
      : "/practice");
  const dailyGoalMinutes = input.dailyGoalMinutes ?? 20;
  const completedMinutes = input.completedMinutes ?? 0;
  const weeklyGoalMinutes = input.weeklyGoalMinutes ?? dailyGoalMinutes * 5;
  const weeklyCompletedMinutes = input.weeklyCompletedMinutes ?? completedMinutes;

  return {
    greeting: input.studentFirstName
      ? `Ready for today, ${input.studentFirstName}?`
      : "Ready for today's study plan?",
    healthScore: Math.max(0, Math.min(100, Math.round(input.healthScore ?? 0))),
    predictedGrade: input.predictedGrade ?? null,
    streak: Math.max(0, input.currentStreak ?? 0),
    totalXp: Math.max(0, input.totalXp ?? 0),
    primaryAction: {
      label: "Continue learning",
      title: input.nextTask?.title ?? topicTitle,
      href: actionHref,
    },
    dailyGoal: makeGoal(dailyGoalMinutes, completedMinutes),
    weeklyGoal: makeGoal(weeklyGoalMinutes, weeklyCompletedMinutes),
    quickLinks: [
      quickLink("continue-learning", "Resume the next useful activity"),
      quickLink("weak-areas", "Review topics that need attention", input.weakAreas),
      quickLink("exam-readiness", "Check mock exams and grade direction"),
      quickLink("tasks", "Finish today's study tasks", input.dueTasks),
      quickLink("saved-questions", "Revisit saved questions", input.savedItems),
      quickLink("mistake-journal", "Retry missed questions", input.mistakesToReview),
      quickLink("learning-memory", "Review what Nex remembers"),
      quickLink("study-search", "Find lessons and questions fast"),
      quickLink("offline-packs", "Prepare low-data study packs", input.offlinePacksReady),
      quickLink("weekly-goal", "Track this week's target"),
      quickLink(
        "focus-sessions",
        "Run a timed study session",
        input.focusMinutesToday ? `${input.focusMinutesToday}m` : undefined,
      ),
      quickLink("concept-library", "Open formulas and concepts"),
    ],
  };
}

function makeGoal(minutes: number, completed: number) {
  const safeMinutes = Math.max(1, Math.round(minutes));
  const safeCompleted = Math.max(0, Math.round(completed));
  return {
    minutes: safeMinutes,
    completed: safeCompleted,
    left: Math.max(0, safeMinutes - safeCompleted),
    percent: Math.min(100, Math.round((safeCompleted / safeMinutes) * 100)),
  };
}

function quickLink(
  id: StudentFeatureId,
  description: string,
  count?: number | string,
) {
  const feature = getStudentFeatureById(id);
  if (!feature) {
    throw new Error(`Unknown student feature: ${id}`);
  }
  return {
    label: feature.label,
    href: feature.href,
    description,
    ...(count !== undefined && String(count) !== "0" ? { count: String(count) } : {}),
  };
}
