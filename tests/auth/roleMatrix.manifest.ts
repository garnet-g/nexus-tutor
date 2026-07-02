import contract from "./role-matrix.contract.json";

export type AccessTier =
  | "public"
  | "student"
  | "parent"
  | "admin"
  | "super_admin"
  | "content_author"
  | "cron_secret"
  | "webhook";

export type RouteEntry = {
  path: string;
  tier: AccessTier;
  filePath: string;
  methods?: string[];
  notes?: string;
};

export type ServerActionEntry = {
  filePath: string;
  tier: AccessTier;
  actions: string[];
  notes?: string;
};

/** Committed expected-access contract — do not derive from live code at runtime. */
export const ROLE_MATRIX_MANIFEST: RouteEntry[] = contract as RouteEntry[];

export const SERVER_ACTION_CONTRACT: ServerActionEntry[] = [
  {
    filePath: "src/server/actions/authActions.ts",
    tier: "public",
    actions: ["signupAction", "loginAction", "signInWithGoogleAction"],
    notes: "Pre-auth entry points; post-auth redirect uses getSessionUser.",
  },
  {
    filePath: "src/server/actions/profileActions.ts",
    tier: "student",
    actions: ["updateProfileAction"],
    notes: "Requires authenticated student session via getSessionUser.",
  },
  {
    filePath: "src/server/actions/onboardingActions.ts",
    tier: "student",
    actions: ["completeOnboardingAction"],
    notes: "Requires authenticated student session via getSessionUser.",
  },
];

export const LAYOUT_GATED_STUDENT_ROUTES = [
  "/readiness",
  "/library",
  "/tasks",
  "/weak-areas",
  "/nex-memory",
  "/offline",
  "/focus",
  "/saved",
  "/mistakes",
  "/weekly-goal",
  "/study-search",
  "/continue",
] as const;

export const SUPER_ADMIN_ONLY_PAGE_PATHS = [
  "/admin/usage-stats",
  "/admin/beta-invites",
  "/admin/platform-settings",
  "/admin/assessment",
  "/admin/campaigns",
  "/admin/rollouts",
] as const;

export const SUPER_ADMIN_ONLY_API_PATHS = [
  "/api/admin/usage-stats",
  "/api/admin/users/[id]/impersonate",
  "/api/admin/users/[id]/profile",
  "/api/admin/nex-ops/flags",
  "/api/admin/nex-ops/flags/[id]",
  "/api/admin/outcomes/parent-sms",
  "/api/admin/payments/coupons",
] as const;

export const STUDENT_ONLY_API_PATHS = [
  "/api/family/invite-code",
  "/api/family/join",
] as const;
