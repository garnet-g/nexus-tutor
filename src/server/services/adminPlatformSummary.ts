export type AdminOperationalRole =
  | "super_admin"
  | "support"
  | "content_reviewer"
  | "finance_admin"
  | "growth_admin"
  | "ops_admin";

export type AdminPlatformNavItem = {
  href: string;
  label: string;
  area:
    | "inbox"
    | "risk"
    | "people"
    | "quality"
    | "revenue"
    | "system"
    | "growth"
    | "workflow";
};

export const ADMIN_PLATFORM_NAV: AdminPlatformNavItem[] = [
  { href: "/admin/inbox", label: "Task inbox", area: "inbox" },
  { href: "/admin/alerts", label: "Alerts", area: "risk" },
  { href: "/admin/roles", label: "Roles", area: "people" },
  { href: "/admin/communications", label: "Communications", area: "people" },
  { href: "/admin/health", label: "System health", area: "system" },
  { href: "/admin/reports", label: "Reports", area: "workflow" },
  { href: "/admin/experiments", label: "Experiments", area: "growth" },
  { href: "/admin/search", label: "Search", area: "workflow" },
  { href: "/admin/saved-views", label: "Saved views", area: "workflow" },
  { href: "/admin/bulk-actions", label: "Bulk actions", area: "workflow" },
  { href: "/admin/approvals", label: "Approvals", area: "workflow" },
  { href: "/admin/ai-quality", label: "AI quality", area: "quality" },
  { href: "/admin/content-calendar", label: "Content calendar", area: "quality" },
  { href: "/admin/revenue-ops", label: "Revenue ops", area: "revenue" },
];

export const ADMIN_ROLE_PERMISSIONS: Record<AdminOperationalRole, string[]> = {
  super_admin: ["*"],
  support: [
    "/admin",
    "/admin/inbox",
    "/admin/support",
    "/admin/users",
    "/admin/communications",
    "/admin/search",
    "/admin/saved-views",
  ],
  content_reviewer: [
    "/admin",
    "/admin/inbox",
    "/admin/studio",
    "/admin/content-calendar",
    "/admin/ai-quality",
    "/admin/approvals",
  ],
  finance_admin: [
    "/admin",
    "/admin/inbox",
    "/admin/payments",
    "/admin/revenue-ops",
    "/admin/reports",
    "/admin/campaigns",
  ],
  growth_admin: [
    "/admin",
    "/admin/campaigns",
    "/admin/experiments",
    "/admin/reports",
    "/admin/beta-invites",
    "/admin/search",
  ],
  ops_admin: [
    "/admin",
    "/admin/inbox",
    "/admin/alerts",
    "/admin/health",
    "/admin/nex-ops",
    "/admin/rollouts",
    "/admin/bulk-actions",
    "/admin/saved-views",
  ],
};

export function canAdminAccessRoute(
  role: AdminOperationalRole,
  href: string,
): boolean {
  const permissions = ADMIN_ROLE_PERMISSIONS[role] ?? [];
  if (permissions.includes("*")) {
    return true;
  }

  return permissions.some((allowedHref) => {
    if (allowedHref === "/admin") {
      return href === "/admin";
    }
    return href === allowedHref || href.startsWith(`${allowedHref}/`);
  });
}

export type AdminTaskSeverity = "critical" | "urgent" | "watch";
export type AdminTaskSource =
  | "alert"
  | "support"
  | "nex"
  | "content"
  | "payment"
  | "student"
  | "approval"
  | "system";

export type AdminTaskSourceItem = {
  id: string;
  source: AdminTaskSource;
  title: string;
  href: string;
  severity: AdminTaskSeverity;
  createdAt: string;
  description?: string | null;
};

const SEVERITY_RANK: Record<AdminTaskSeverity, number> = {
  critical: 0,
  urgent: 1,
  watch: 2,
};

export function buildAdminTaskInbox(
  items: AdminTaskSourceItem[],
): AdminTaskSourceItem[] {
  return [...items].sort((left, right) => {
    const severityDelta =
      SEVERITY_RANK[left.severity] - SEVERITY_RANK[right.severity];
    if (severityDelta !== 0) {
      return severityDelta;
    }
    return right.createdAt.localeCompare(left.createdAt);
  });
}

export type EntitlementDebugInput = {
  planCode: string | null;
  subscriptionStatus: string | null;
  trialActive: boolean;
  featureEnabled: boolean;
  dailyLimit: number;
  dailyUsage: number;
};

export type EntitlementDebug = {
  allowed: boolean;
  reasons: string[];
  blockers: string[];
  remainingToday: number;
};

export function buildEntitlementDebug(
  input: EntitlementDebugInput,
): EntitlementDebug {
  const reasons: string[] = [];
  const blockers: string[] = [];
  const remainingToday = Math.max(input.dailyLimit - input.dailyUsage, 0);

  if (input.planCode === "premium" || input.planCode === "family") {
    if (input.subscriptionStatus === "active") {
      reasons.push(`Active ${input.planCode} subscription`);
    } else {
      blockers.push("Paid plan is not active");
    }
  } else if (input.trialActive) {
    reasons.push("Active trial");
  } else {
    reasons.push("Free plan");
  }

  if (!input.featureEnabled) {
    blockers.push("Feature rollout is disabled");
  }

  if (input.dailyUsage >= input.dailyLimit) {
    blockers.push("Daily limit reached");
  } else {
    reasons.push(`${remainingToday} uses remaining today`);
  }

  return {
    allowed: blockers.length === 0,
    reasons,
    blockers,
    remainingToday,
  };
}

export type StudentTimelineKind =
  | "signup"
  | "diagnostic"
  | "lesson"
  | "practice"
  | "nex"
  | "payment"
  | "support"
  | "admin"
  | "parent";

export type StudentTimelineEvent = {
  kind: StudentTimelineKind;
  title: string;
  occurredAt: string;
  description?: string | null;
  href?: string;
};

export function buildStudentTimeline(
  events: StudentTimelineEvent[],
): StudentTimelineEvent[] {
  return [...events].sort((left, right) =>
    right.occurredAt.localeCompare(left.occurredAt),
  );
}

export function getRoleLabel(role: AdminOperationalRole): string {
  return role
    .split("_")
    .map((part) => part[0]?.toUpperCase() + part.slice(1))
    .join(" ");
}
