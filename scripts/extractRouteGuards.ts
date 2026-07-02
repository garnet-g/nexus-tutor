import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, relative } from "node:path";

export type AccessTier =
  | "public"
  | "student"
  | "parent"
  | "admin"
  | "super_admin"
  | "content_author"
  | "cron_secret"
  | "webhook";

export type ExtractedGuards = {
  requireSuperAdmin: boolean;
  requireAdminRole: boolean;
  requireStudentExperience: boolean;
  requireContentAuthor: boolean;
  createAdminClient: boolean;
  loadNexOpsSnapshot: boolean;
  requireAdminApi: boolean;
  cronSecret: boolean;
  webhook: boolean;
};

export type RouteGuardEntry = {
  filePath: string;
  urlPath: string;
  tier: AccessTier;
  guards: ExtractedGuards;
  methods?: string[];
};

const ROOT = process.cwd();

function walkPages(dir: string, results: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const fullPath = join(dir, entry);
    const stat = statSync(fullPath);

    if (stat.isDirectory()) {
      walkPages(fullPath, results);
      continue;
    }

    if (entry === "page.tsx") {
      results.push(relative(ROOT, fullPath).replace(/\\/g, "/"));
    }
  }

  return results;
}

export function listPageFiles(): string[] {
  return walkPages(join(ROOT, "src/app")).sort();
}

export function listApiFiles(): string[] {
  const files: string[] = [];

  function walkApi(dir: string) {
    for (const entry of readdirSync(dir)) {
      const fullPath = join(dir, entry);
      const stat = statSync(fullPath);

      if (stat.isDirectory()) {
        walkApi(fullPath);
        continue;
      }

      if (entry === "route.ts") {
        files.push(relative(ROOT, fullPath).replace(/\\/g, "/"));
      }
    }
  }

  walkApi(join(ROOT, "src/app/api"));
  return files.sort();
}

export function filePathToUrlPath(filePath: string): string {
  const normalized = filePath.replace(/\\/g, "/");

  if (normalized.endsWith("/page.tsx")) {
    const withoutPrefix = normalized
      .replace(/^src\/app\//, "")
      .replace(/\/page\.tsx$/, "");
    const segments = withoutPrefix
      .split("/")
      .filter(
        (segment) =>
          !segment.startsWith("(") &&
          !segment.endsWith(")") &&
          segment.length > 0,
      )
      .map((segment) =>
        segment.startsWith("[") && segment.endsWith("]") ? `:${segment.slice(1, -1)}` : segment,
      );

    return segments.length === 0 ? "/" : `/${segments.join("/")}`;
  }

  const withoutPrefix = normalized
    .replace(/^src\/app\//, "")
    .replace(/\/route\.ts$/, "");

  return `/${withoutPrefix}`;
}

const SUPER_ADMIN_PAGE_FILES = new Set([
  "src/app/(super-admin)/admin/usage-stats/page.tsx",
  "src/app/(super-admin)/admin/beta-invites/page.tsx",
  "src/app/(super-admin)/admin/platform-settings/page.tsx",
  "src/app/(super-admin)/admin/assessment/page.tsx",
  "src/app/(super-admin)/admin/campaigns/page.tsx",
  "src/app/(super-admin)/admin/rollouts/page.tsx",
]);

const SUPER_ADMIN_API_FILES = new Set([
  "src/app/api/admin/usage-stats/route.ts",
  "src/app/api/admin/users/[id]/impersonate/route.ts",
  "src/app/api/admin/users/[id]/profile/route.ts",
  "src/app/api/admin/nex-ops/flags/[id]/route.ts",
  "src/app/api/admin/nex-ops/flags/route.ts",
  "src/app/api/admin/outcomes/parent-sms/route.ts",
  "src/app/api/admin/payments/coupons/route.ts",
]);

const CONTENT_AUTHOR_PAGE_FILES = new Set([
  "src/app/(super-admin)/admin/studio/page.tsx",
  "src/app/(super-admin)/admin/studio/new/page.tsx",
  "src/app/(super-admin)/admin/studio/review/page.tsx",
  "src/app/(super-admin)/admin/studio/[lessonId]/page.tsx",
]);

const LAYOUT_GATED_STUDENT_ROUTES = [
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

export function inferTierFromFilePath(filePath: string): AccessTier {
  const normalized = filePath.replace(/\\/g, "/");

  if (SUPER_ADMIN_PAGE_FILES.has(normalized) || SUPER_ADMIN_API_FILES.has(normalized)) {
    return "super_admin";
  }

  if (CONTENT_AUTHOR_PAGE_FILES.has(normalized)) {
    return "content_author";
  }

  if (normalized.includes("/api/cron/")) {
    return "cron_secret";
  }

  if (
    normalized.includes("/api/celcom/webhook/") ||
    normalized.includes("/api/mpesa/callback/")
  ) {
    return "webhook";
  }

  if (normalized.includes("/api/waitlist/")) {
    return "public";
  }

  if (normalized.includes("/(public)/") || normalized === "src/app/(public)/page.tsx") {
    return "public";
  }

  if (normalized.includes("/(parent)/")) {
    return "parent";
  }

  if (normalized.includes("/(student)/")) {
    return "student";
  }

  if (normalized.includes("/(super-admin)/admin/")) {
    return "admin";
  }

  if (normalized.includes("/api/admin/")) {
    return "admin";
  }

  if (normalized.includes("/api/parents/")) {
    return "parent";
  }

  if (normalized.includes("/api/family/")) {
    return "student";
  }

  if (normalized.includes("/api/nex/") || normalized.includes("/api/students/")) {
    return "student";
  }

  if (
    normalized.includes("/api/practice-sessions/") ||
    normalized.includes("/api/mock-exams/") ||
    normalized.includes("/api/diagnostic-assessments/") ||
    normalized.includes("/api/exam-simulator/") ||
    normalized.includes("/api/lessons/") ||
    normalized.includes("/api/study-plans/")
  ) {
    return "student";
  }

  if (normalized.includes("/api/mpesa/") || normalized.includes("/api/subscriptions/")) {
    return "student";
  }

  return "public";
}

export function extractGuardsFromSource(source: string): ExtractedGuards {
  return {
    requireSuperAdmin: source.includes("requireSuperAdmin"),
    requireAdminRole: source.includes("requireAdminRole"),
    requireStudentExperience: source.includes("requireStudentExperience"),
    requireContentAuthor: source.includes("requireContentAuthor"),
    createAdminClient: source.includes("createAdminClient"),
    loadNexOpsSnapshot: source.includes("loadNexOpsSnapshot"),
    requireAdminApi: source.includes("requireAdminApi"),
    cronSecret: source.includes("CRON_SECRET"),
    webhook:
      source.includes("webhook") ||
      source.includes("callback") ||
      source.includes("MPESA_CALLBACK_SECRET"),
  };
}

export function extractRouteGuards(): RouteGuardEntry[] {
  const entries: RouteGuardEntry[] = [];

  for (const filePath of listPageFiles()) {
    const source = readFileSync(join(ROOT, filePath), "utf8");
    entries.push({
      filePath,
      urlPath: filePathToUrlPath(filePath),
      tier: inferTierFromFilePath(filePath),
      guards: extractGuardsFromSource(source),
    });
  }

  for (const filePath of listApiFiles()) {
    const source = readFileSync(join(ROOT, filePath), "utf8");
    const methods = ["GET", "POST", "PATCH", "PUT", "DELETE"].filter((method) =>
      new RegExp(`export\\s+async\\s+function\\s+${method}`).test(source),
    );

    entries.push({
      filePath,
      urlPath: filePathToUrlPath(filePath),
      tier: inferTierFromFilePath(filePath),
      guards: extractGuardsFromSource(source),
      methods,
    });
  }

  return entries.sort((a, b) => a.filePath.localeCompare(b.filePath));
}

export function getLayoutGatedStudentRoutes(): readonly string[] {
  return LAYOUT_GATED_STUDENT_ROUTES;
}

if (import.meta.url === `file://${process.argv[1]?.replace(/\\/g, "/")}`) {
  const entries = extractRouteGuards();
  console.log(
    JSON.stringify(
      {
        pages: entries.filter((entry) => entry.filePath.endsWith("page.tsx")).length,
        apis: entries.filter((entry) => entry.filePath.endsWith("route.ts")).length,
        layoutGatedStudentRoutes: LAYOUT_GATED_STUDENT_ROUTES,
      },
      null,
      2,
    ),
  );
}
