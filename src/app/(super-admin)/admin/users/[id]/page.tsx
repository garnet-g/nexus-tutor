import Link from "next/link";
import { notFound, redirect } from "next/navigation";

import { CompSubscriptionForm } from "@/features/admin/components/CompSubscriptionForm";
import { PageHeader, Panel, StatCard, StatusBadge } from "@/features/admin/components/adminUi";
import { StudentProfileCorrectionForm } from "@/features/admin/components/StudentProfileCorrectionForm";
import { ViewAsStudentPanel } from "@/features/admin/components/ViewAsStudentPanel";
import { cn } from "@/lib/utils";
import {
  type UserDetail,
  getUserDetail,
} from "@/server/services/adminUserReadService";
import { getStudent360Data } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function formatDate(iso: string | null): string {
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

function DetailRow({
  label,
  value,
}: {
  label: string;
  value: React.ReactNode;
}) {
  return (
    <div className="flex flex-wrap items-start justify-between gap-3 py-2.5">
      <span className="text-sm text-muted-foreground">{label}</span>
      <span className="text-sm font-medium text-foreground">{value}</span>
    </div>
  );
}

export default async function UserDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  const { id } = await params;

  let detail: UserDetail | null = null;
  let student360 = null;
  try {
    [detail, student360] = await Promise.all([
      getUserDetail(id),
      getStudent360Data(id).catch(() => null),
    ]);
  } catch {
    detail = null;
    student360 = null;
  }

  if (!detail) {
    notFound();
  }

  const { subscription, usage, health, linkedParents } = detail;
  const isSuperAdmin = auth.role === "super_admin";

  return (
    <>
      <PageHeader
        eyebrow="Accounts"
        title={detail.fullName}
        description={
          <>
            Student account detail (Nairobi time).{" "}
            <Link href="/admin/users" className="text-primary hover:underline">
              Back to directory
            </Link>
          </>
        }
      />

      <section className="grid gap-4 sm:grid-cols-2 lg:grid-cols-4">
        <StatCard
          label="Subscription"
          value={subscription?.planName ?? subscription?.status ?? "None"}
          hint={subscription ? subscription.status : "No subscription"}
        />
        <StatCard
          label="Health score"
          value={health ? health.healthScore.toFixed(1) : "—"}
          hint={
            health
              ? `Predicted ${health.predictedGrade ?? "—"} · ${formatDate(
                  health.calculatedAt,
                )}`
              : "No scores yet"
          }
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
      </section>

      <div className="grid gap-6 lg:grid-cols-2">
        <Panel title="Profile">
          <div className="divide-y divide-nexus-border">
            <DetailRow label="Full name" value={detail.fullName} />
            <DetailRow label="Email" value={detail.email ?? "—"} />
            <DetailRow label="Phone" value={detail.phoneNumber ?? "—"} />
            <DetailRow
              label="Curriculum"
              value={detail.curriculum ?? "—"}
            />
            <DetailRow label="Grade level" value={detail.gradeLevel ?? "—"} />
            <DetailRow label="School" value={detail.schoolName ?? "—"} />
            <DetailRow
              label="Status"
              value={
                <span
                  className={cn(
                    "inline-flex items-center rounded-full px-2.5 py-0.5 text-xs font-medium",
                    detail.isActive
                      ? "bg-primary/15 text-primary"
                      : "bg-nexus-border/40 text-muted-foreground",
                  )}
                >
                  {detail.isActive ? "Active" : "Inactive"}
                </span>
              }
            />
            <DetailRow label="Joined" value={formatDate(detail.createdAt)} />
          </div>
        </Panel>

        <Panel title="Subscription detail">
          {subscription ? (
            <div className="divide-y divide-nexus-border">
              <DetailRow label="Status" value={subscription.status} />
              <DetailRow label="Plan" value={subscription.planName ?? "—"} />
              <DetailRow
                label="Plan code"
                value={subscription.planCode ?? "—"}
              />
              <DetailRow
                label="Current period ends"
                value={formatDate(subscription.currentPeriodEnd)}
              />
              <DetailRow
                label="Trial active"
                value={subscription.isTrialActive ? "Yes" : "No"}
              />
              <DetailRow
                label="Trial ends"
                value={formatDate(subscription.trialEndsAt)}
              />
            </div>
          ) : (
            <p className="text-sm text-muted-foreground">
              No subscription on record.
            </p>
          )}
        </Panel>
      </div>

      <Panel
        title="Linked parents"
        description={`${linkedParents.length} link${
          linkedParents.length === 1 ? "" : "s"
        }`}
      >
        {linkedParents.length === 0 ? (
          <p className="text-sm text-muted-foreground">
            No parents linked to this student.
          </p>
        ) : (
          <ul className="space-y-2.5">
            {linkedParents.map((parent) => (
              <li
                key={parent.parentId}
                className="flex flex-wrap items-center justify-between gap-3 rounded-xl border border-nexus-border bg-nexus-sunken px-4 py-3 text-sm"
              >
                <div className="space-y-0.5">
                  <p className="font-medium text-foreground">
                    {parent.fullName}
                  </p>
                  <p className="text-xs text-muted-foreground">
                    {parent.email ?? "no email"}
                    {parent.phoneNumber ? ` · ${parent.phoneNumber}` : ""}
                  </p>
                </div>
                <span className="rounded-full bg-nexus-border/40 px-2.5 py-1 text-xs font-medium capitalize text-muted-foreground">
                  {parent.linkStatus}
                </span>
              </li>
            ))}
          </ul>
        )}
      </Panel>

      {student360 ? (
        <section className="grid gap-6 lg:grid-cols-2">
          <Panel
            title="Entitlement debugger"
            description="Why this student can or cannot use gated features today."
          >
            <div className="mb-4 flex flex-wrap items-center justify-between gap-3 rounded-xl bg-nexus-sunken p-4">
              <div>
                <p className="text-sm text-muted-foreground">Decision</p>
                <p className="font-heading text-2xl font-semibold text-foreground">
                  {student360.entitlement.allowed ? "Allowed" : "Blocked"}
                </p>
              </div>
              <StatusBadge tone={student360.entitlement.allowed ? "success" : "danger"}>
                {student360.entitlement.remainingToday} left today
              </StatusBadge>
            </div>
            <div className="space-y-3">
              {student360.entitlement.reasons.map((reason) => (
                <p key={reason} className="rounded-lg bg-primary/10 px-3 py-2 text-sm text-primary">
                  {reason}
                </p>
              ))}
              {student360.entitlement.blockers.map((blocker) => (
                <p key={blocker} className="rounded-lg bg-nexus-danger/10 px-3 py-2 text-sm text-nexus-danger">
                  {blocker}
                </p>
              ))}
            </div>
          </Panel>

          <Panel
            title="Student timeline"
            description={`${student360.supportCaseCount} linked support case${student360.supportCaseCount === 1 ? "" : "s"}`}
          >
            <div className="space-y-3">
              {student360.timeline.length === 0 ? (
                <p className="text-sm text-muted-foreground">No timeline events found.</p>
              ) : student360.timeline.slice(0, 10).map((event) => (
                <div key={`${event.kind}-${event.occurredAt}-${event.title}`} className="rounded-xl bg-nexus-sunken p-3">
                  <div className="flex flex-wrap items-start justify-between gap-3">
                    <div>
                      <p className="text-sm font-medium text-foreground">{event.title}</p>
                      {event.description ? (
                        <p className="mt-1 text-xs text-muted-foreground">{event.description}</p>
                      ) : null}
                    </div>
                    <StatusBadge tone="info">{event.kind}</StatusBadge>
                  </div>
                  <p className="mt-2 text-xs text-muted-foreground">
                    {formatDate(event.occurredAt)}
                  </p>
                </div>
              ))}
            </div>
          </Panel>
        </section>
      ) : null}

      {isSuperAdmin ? (
        <section className="space-y-4">
          <div className="border-b border-nexus-border pb-3">
            <p className="text-xs font-semibold uppercase tracking-[0.14em] text-muted-foreground">
              Super admin controls
            </p>
            <h2 className="mt-1 font-heading text-xl font-semibold tracking-tight text-foreground">
              Account operations
            </h2>
          </div>
          <StudentProfileCorrectionForm
            detail={{
              id: detail.id,
              fullName: detail.fullName,
              email: detail.email,
              phoneNumber: detail.phoneNumber,
              curriculum: detail.curriculum,
              gradeLevel: detail.gradeLevel,
              schoolName: detail.schoolName,
              targetGrade: detail.targetGrade,
              isActive: detail.isActive,
            }}
          />
          <div className="grid gap-6 lg:grid-cols-2">
            <CompSubscriptionForm studentId={detail.id} />
            <ViewAsStudentPanel
              studentId={detail.id}
              studentName={detail.fullName}
            />
          </div>
        </section>
      ) : (
        <Panel title="Admin actions">
          <p className="text-sm text-muted-foreground">
            Comp grants and view-as sessions require super admin access.
          </p>
        </Panel>
      )}
    </>
  );
}
