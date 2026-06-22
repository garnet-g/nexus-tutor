import Link from "next/link";
import { notFound, redirect } from "next/navigation";

import { ViewAsStudentEndButton } from "@/features/admin/components/ViewAsStudentEndButton";
import { PageHeader, Panel, StatCard } from "@/features/admin/components/adminUi";
import { createAdminClient } from "@/lib/supabase/admin";
import { unwrapSupabaseRelation } from "@/lib/utils";
import { getActiveImpersonation } from "@/server/services/adminImpersonationService";
import {
  type UserDetail,
  getUserDetail,
} from "@/server/services/adminUserReadService";
import { requireAdminRole } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function formatDateTime(iso: string | null): string {
  if (!iso) {
    return "—";
  }
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

function formatTime(iso: string): string {
  return new Intl.DateTimeFormat("en-GB", {
    timeZone: "Africa/Nairobi",
    hour: "2-digit",
    minute: "2-digit",
    hour12: false,
  }).format(new Date(iso));
}

type MasteryRow = {
  topicTitle: string;
  masteryPercentage: number;
  lastPracticedAt: string | null;
};

type ActivityRow = {
  id: string;
  activityType: string;
  durationSeconds: number;
  loggedAt: string;
};

type StudyPlanSummary = {
  title: string;
  planType: string;
  targetCompletionDate: string | null;
  taskCount: number;
  completedCount: number;
};

async function loadReadOnlyDashboard(studentId: string): Promise<{
  mastery: MasteryRow[];
  activity: ActivityRow[];
  studyPlan: StudyPlanSummary | null;
}> {
  const admin = createAdminClient();

  const { data: masteryRows } = await admin
    .from("topic_mastery")
    .select("mastery_percentage, last_practiced_at, topics(title)")
    .eq("student_id", studentId)
    .order("mastery_percentage", { ascending: false })
    .limit(10);

  const mastery: MasteryRow[] = (masteryRows ?? []).map((row) => {
    const topic = unwrapSupabaseRelation<{ title?: string }>(row.topics);
    return {
      topicTitle: topic?.title ?? "—",
      masteryPercentage: Number(row.mastery_percentage ?? 0),
      lastPracticedAt: row.last_practiced_at ?? null,
    };
  });

  const { data: activityRows } = await admin
    .from("study_time_logs")
    .select("id, activity_type, duration_seconds, logged_at")
    .eq("student_id", studentId)
    .order("logged_at", { ascending: false })
    .limit(10);

  const activity: ActivityRow[] = (activityRows ?? []).map((row) => ({
    id: row.id,
    activityType: row.activity_type ?? "—",
    durationSeconds: row.duration_seconds ?? 0,
    loggedAt: row.logged_at,
  }));

  const { data: planRow } = await admin
    .from("study_plans")
    .select("id, title, plan_type, target_completion_date")
    .eq("student_id", studentId)
    .eq("is_active", true)
    .order("created_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  let studyPlan: StudyPlanSummary | null = null;
  if (planRow) {
    const { data: taskRows } = await admin
      .from("study_tasks")
      .select("is_completed")
      .eq("study_plan_id", planRow.id);

    const taskCount = (taskRows ?? []).length;
    const completedCount = (taskRows ?? []).filter(
      (task) => task.is_completed,
    ).length;

    studyPlan = {
      title: planRow.title ?? "—",
      planType: planRow.plan_type ?? "—",
      targetCompletionDate: planRow.target_completion_date ?? null,
      taskCount,
      completedCount,
    };
  }

  return { mastery, activity, studyPlan };
}

export default async function ViewAsStudentPage({
  params,
  searchParams,
}: {
  params: Promise<{ id: string }>;
  searchParams: Promise<Record<string, string | string[] | undefined>>;
}) {
  // SENSITIVE read-only render: super_admin only.
  const auth = await requireAdminRole(["super_admin"]);
  if (!auth.ok) {
    redirect("/login");
  }

  const { id } = await params;
  const search = await searchParams;
  const sessionId =
    typeof search.session === "string" ? search.session : undefined;

  if (!sessionId) {
    redirect(`/admin/users/${id}`);
  }

  const session = await getActiveImpersonation(sessionId);
  if (
    !session ||
    session.targetStudentId !== id ||
    session.adminUserId !== auth.userId
  ) {
    // Expired, ended, or not the owner — bounce back to detail.
    redirect(`/admin/users/${id}`);
  }

  let detail: UserDetail | null = null;
  try {
    detail = await getUserDetail(id);
  } catch {
    detail = null;
  }

  if (!detail) {
    notFound();
  }

  const { mastery, activity, studyPlan } = await loadReadOnlyDashboard(id);
  const { usage, health } = detail;

  return (
    <>
      <div
        role="status"
        className="flex flex-wrap items-start justify-between gap-4 rounded-2xl border border-nexus-accent bg-nexus-accent-soft px-5 py-4 text-sm text-nexus-warning"
      >
        <div>
          <p className="font-semibold">Admin read-only view</p>
          <p className="mt-0.5">
            You are viewing <strong>{detail.fullName}</strong> as a super admin.
            Session expires at {formatTime(session.expiresAt)} (Nairobi time). No
            changes can be made from this view.
          </p>
        </div>
        <ViewAsStudentEndButton studentId={id} sessionId={session.id} />
      </div>

      <PageHeader
        eyebrow="View as student"
        title={`${detail.fullName} · dashboard`}
        description={
          <>
            Read-only snapshot of the student&apos;s own data.{" "}
            <Link
              href={`/admin/users/${id}`}
              className="text-primary hover:underline"
            >
              Back to account detail
            </Link>
          </>
        }
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Health score"
          value={health ? health.healthScore.toFixed(1) : "—"}
          hint={health ? `Predicted ${health.predictedGrade ?? "—"}` : "No scores"}
        />
        <StatCard
          label="Nex messages (today)"
          value={usage.todayNexMessages.toLocaleString()}
          hint={`${usage.last7dNexMessages.toLocaleString()} in last 7 days`}
        />
        <StatCard
          label="Practice sessions (today)"
          value={usage.todayPracticeSessions.toLocaleString()}
          hint={`${usage.last7dPracticeSessions.toLocaleString()} in last 7 days`}
        />
        <StatCard
          label="Active study plan"
          value={studyPlan ? `${studyPlan.completedCount}/${studyPlan.taskCount}` : "—"}
          hint={studyPlan ? studyPlan.title : "No active plan"}
        />
      </section>

      <div className="grid gap-6 lg:grid-cols-2">
        <Panel
          title="Topic mastery"
          description="Top topics by mastery."
        >
          {mastery.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              No mastery data yet.
            </p>
          ) : (
            <ul className="space-y-2.5">
              {mastery.map((row) => (
                <li
                  key={row.topicTitle}
                  className="flex items-center justify-between gap-3 rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm"
                >
                  <span className="font-medium text-foreground">
                    {row.topicTitle}
                  </span>
                  <span className="font-mono tabular-nums text-muted-foreground">
                    {row.masteryPercentage.toFixed(0)}%
                  </span>
                </li>
              ))}
            </ul>
          )}
        </Panel>

        <Panel
          title="Recent activity"
          description="Latest study-time entries."
        >
          {activity.length === 0 ? (
            <p className="text-sm text-muted-foreground">
              No recent activity.
            </p>
          ) : (
            <ul className="space-y-2.5">
              {activity.map((row) => (
                <li
                  key={row.id}
                  className="flex items-center justify-between gap-3 rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm"
                >
                  <span className="font-medium capitalize text-foreground">
                    {row.activityType}
                  </span>
                  <span className="text-xs text-muted-foreground">
                    {Math.round(row.durationSeconds / 60)} min ·{" "}
                    {formatDateTime(row.loggedAt)}
                  </span>
                </li>
              ))}
            </ul>
          )}
        </Panel>
      </div>

      <Panel title="Study plan summary">
        {studyPlan ? (
          <div className="grid gap-4 sm:grid-cols-3">
            <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <p className="text-sm text-muted-foreground">Plan</p>
              <p className="mt-1 font-medium text-foreground">
                {studyPlan.title}
              </p>
              <p className="text-xs capitalize text-muted-foreground">
                {studyPlan.planType}
              </p>
            </div>
            <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <p className="text-sm text-muted-foreground">Progress</p>
              <p className="mt-1 font-heading text-2xl font-semibold tabular-nums text-foreground">
                {studyPlan.completedCount}/{studyPlan.taskCount}
              </p>
              <p className="text-xs text-muted-foreground">tasks complete</p>
            </div>
            <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <p className="text-sm text-muted-foreground">Target date</p>
              <p className="mt-1 font-medium text-foreground">
                {studyPlan.targetCompletionDate ?? "—"}
              </p>
            </div>
          </div>
        ) : (
          <p className="text-sm text-muted-foreground">
            No active study plan.
          </p>
        )}
      </Panel>
    </>
  );
}
