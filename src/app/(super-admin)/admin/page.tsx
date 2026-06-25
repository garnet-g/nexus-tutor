import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import {
  EmptyState,
  PageHeader,
  Panel,
  StatCard,
  StatusBadge,
} from "@/features/admin/components/adminUi";
import { getAdminCommandCenterData } from "@/server/services/adminOpsService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function severityTone(severity: string) {
  if (severity === "critical") {
    return "danger";
  }
  if (severity === "urgent") {
    return "warning";
  }
  return "neutral";
}

export default async function AdminCommandCenterPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  const data = await getAdminCommandCenterData();

  return (
    <>
      <PageHeader
        eyebrow="Operations"
        title="Dashboard"
        description="Daily view across growth, learning quality, Nex safety, support, revenue, and controlled rollouts."
        actions={
          <>
            <Button render={<Link href="/admin/support" />} variant="outline">
              Support
            </Button>
            <Button render={<Link href="/admin/rollouts" />}>
              Rollouts
            </Button>
          </>
        }
      />

      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <StatCard label="Students" value={data.kpis.totalStudents.toLocaleString()} />
        <StatCard
          label="Open support"
          value={data.kpis.openSupportCases.toLocaleString()}
          hint="Unresolved internal cases"
        />
        <StatCard
          label="Content review"
          value={data.kpis.contentReviewItems.toLocaleString()}
          hint="Lessons/questions awaiting review"
        />
        <StatCard
          label="Enabled rollouts"
          value={data.kpis.enabledRollouts.toLocaleString()}
          hint="Feature flags currently on"
        />
        <StatCard
          label="Nex today"
          value={data.kpis.nexMessagesToday.toLocaleString()}
          hint={`7d est. KES ${data.kpis.estimatedNexCostKes7d.toLocaleString()}`}
        />
        <StatCard
          label="Failed payments"
          value={data.kpis.failedPayments.toLocaleString()}
          hint="All-time ledger count"
        />
        <StatCard
          label="At risk"
          value={data.kpis.atRiskStudents.toLocaleString()}
          hint="Outcome dashboard threshold"
        />
        <StatCard
          label="Campaign uses"
          value={data.campaignSummary.inviteUses.toLocaleString()}
          hint={`${data.campaignSummary.activeInvites} active invite${data.campaignSummary.activeInvites === 1 ? "" : "s"}`}
        />
      </section>

      <section className="grid gap-5 xl:grid-cols-[1.1fr_0.9fr]">
        <Panel
          title="Lifecycle funnel"
          description="Signup to paid conversion, computed from current product tables."
        >
          <div className="space-y-3">
            {data.lifecycle.map((step) => (
              <div key={step.key} className="grid gap-2 sm:grid-cols-[150px_1fr_70px] sm:items-center">
                <div>
                  <p className="text-sm font-medium text-foreground">{step.label}</p>
                  <p className="text-xs text-muted-foreground">
                    {step.value.toLocaleString()} users
                  </p>
                </div>
                <div className="h-2 overflow-hidden rounded-full bg-nexus-sunken">
                  <div
                    className="h-full rounded-full bg-primary"
                    style={{ width: `${Math.min(step.rateFromPrevious, 100)}%` }}
                  />
                </div>
                <p className="text-right font-mono text-sm tabular-nums text-muted-foreground">
                  {step.rateFromPrevious}%
                </p>
              </div>
            ))}
          </div>
        </Panel>

        <Panel
          title="Campaign ops"
          description="Private beta and coupon capacity."
          action={<Button render={<Link href="/admin/campaigns" />} variant="outline" size="sm">Open</Button>}
        >
          <div className="grid gap-3 sm:grid-cols-2">
            <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <p className="text-sm text-muted-foreground">Active invites</p>
              <p className="mt-1 font-heading text-2xl font-semibold">
                {data.campaignSummary.activeInvites.toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground">
                {data.campaignSummary.inviteUses.toLocaleString()} total uses
              </p>
            </div>
            <div className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <p className="text-sm text-muted-foreground">Active coupons</p>
              <p className="mt-1 font-heading text-2xl font-semibold">
                {data.campaignSummary.activeCoupons.toLocaleString()}
              </p>
              <p className="text-xs text-muted-foreground">
                {data.campaignSummary.couponUses.toLocaleString()} total uses
              </p>
            </div>
          </div>
        </Panel>
      </section>

      <section className="grid gap-5 xl:grid-cols-2">
        <Panel
          title="Student intervention queue"
          description="Students with diagnostic, activity, health, or Nex/practice mismatch risk."
          padded={false}
          action={<Button render={<Link href="/admin/outcomes" />} variant="outline" size="sm">Outcomes</Button>}
        >
          <div className="overflow-x-auto">
            <table className="w-full text-sm">
              <thead>
                <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                  <th className="px-5 py-3 font-medium">Student</th>
                  <th className="px-5 py-3 font-medium">Signal</th>
                  <th className="px-5 py-3 font-medium">Severity</th>
                  <th className="px-5 py-3 text-right font-medium">Action</th>
                </tr>
              </thead>
              <tbody>
                {data.interventions.length === 0 ? (
                  <tr>
                    <td colSpan={4}>
                      <EmptyState title="No intervention signals" description="Student risk signals will appear here as activity accumulates." />
                    </td>
                  </tr>
                ) : (
                  data.interventions.map((item) => (
                    <tr key={item.studentId} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                      <td className="px-5 py-3">
                        <p className="font-medium text-foreground">{item.studentName}</p>
                        <p className="text-xs text-muted-foreground">
                          {item.curriculum} / {item.gradeLevel}
                        </p>
                      </td>
                      <td className="px-5 py-3 text-muted-foreground">
                        {item.reasons.slice(0, 2).join(", ")}
                      </td>
                      <td className="px-5 py-3">
                        <StatusBadge tone={severityTone(item.severity)}>{item.severity}</StatusBadge>
                      </td>
                      <td className="px-5 py-3 text-right">
                        <Button
                          render={<Link href={`/admin/users/${item.studentId}`} />}
                          variant="outline"
                          size="sm"
                        >
                          Review
                        </Button>
                      </td>
                    </tr>
                  ))
                )}
              </tbody>
            </table>
          </div>
        </Panel>

        <Panel
          title="Content quality"
          description="Coverage gaps across active subjects."
          action={<Button render={<Link href="/admin/studio" />} variant="outline" size="sm">Studio</Button>}
        >
          <div className="mb-4 grid gap-3 sm:grid-cols-3">
            <div>
              <p className="text-xs text-muted-foreground">Topics</p>
              <p className="font-heading text-2xl font-semibold">
                {data.contentQuality.topicCount.toLocaleString()}
              </p>
            </div>
            <div>
              <p className="text-xs text-muted-foreground">Missing lessons</p>
              <p className="font-heading text-2xl font-semibold">
                {data.contentQuality.missingLessonTopics.toLocaleString()}
              </p>
            </div>
            <div>
              <p className="text-xs text-muted-foreground">Weak question sets</p>
              <p className="font-heading text-2xl font-semibold">
                {data.contentQuality.weakQuestionTopics.toLocaleString()}
              </p>
            </div>
          </div>
          <div className="space-y-2">
            {data.contentQuality.topGaps.length === 0 ? (
              <p className="text-sm text-muted-foreground">No content gaps detected.</p>
            ) : (
              data.contentQuality.topGaps.slice(0, 5).map((gap) => (
                <div key={`${gap.subject}-${gap.curriculum}-${gap.title}`} className="flex items-center justify-between gap-3 rounded-xl bg-nexus-sunken px-3 py-2">
                  <div>
                    <p className="text-sm font-medium text-foreground">{gap.title}</p>
                    <p className="text-xs text-muted-foreground">
                      {gap.subject} / {gap.curriculum} / {gap.readinessLabel}
                    </p>
                  </div>
                  <StatusBadge tone={gap.missingLesson ? "danger" : "warning"}>
                    {gap.missingLesson ? "lesson gap" : `${gap.questionCount} questions`}
                  </StatusBadge>
                </div>
              ))
            )}
          </div>
        </Panel>
      </section>

      <section className="grid gap-5 xl:grid-cols-3">
        <Panel
          title="Nex safety"
          description={`${data.openFlags.length} open flag${data.openFlags.length === 1 ? "" : "s"}`}
          action={<Button render={<Link href="/admin/nex-ops" />} variant="outline" size="sm">Review</Button>}
        >
          <div className="space-y-3">
            {data.openFlags.length === 0 ? (
              <p className="text-sm text-muted-foreground">No open Nex flags.</p>
            ) : (
              data.openFlags.slice(0, 5).map((flag) => (
                <div key={flag.id} className="rounded-xl bg-nexus-sunken p-3">
                  <p className="text-sm font-medium text-foreground">
                    {flag.studentName ?? "Unknown student"}
                  </p>
                  <p className="mt-1 line-clamp-2 text-xs text-muted-foreground">
                    {flag.reason ?? flag.messagePreview ?? "No reason provided"}
                  </p>
                </div>
              ))
            )}
          </div>
        </Panel>

        <Panel
          title="Support desk"
          description={`${data.supportCases.length} recent case${data.supportCases.length === 1 ? "" : "s"}`}
          action={<Button render={<Link href="/admin/support" />} variant="outline" size="sm">Open</Button>}
        >
          <div className="space-y-2">
            {data.supportCases.length === 0 ? (
              <p className="text-sm text-muted-foreground">No support cases yet.</p>
            ) : (
              data.supportCases.slice(0, 5).map((supportCase) => (
                <div key={supportCase.id} className="rounded-xl bg-nexus-sunken p-3">
                  <div className="flex items-start justify-between gap-2">
                    <p className="text-sm font-medium text-foreground">{supportCase.title}</p>
                    <StatusBadge tone={supportCase.priority === "urgent" ? "danger" : "neutral"}>
                      {supportCase.priority}
                    </StatusBadge>
                  </div>
                  <p className="mt-1 text-xs text-muted-foreground">{supportCase.status}</p>
                </div>
              ))
            )}
          </div>
        </Panel>

        <Panel
          title="Rollouts"
          description={`${data.rollouts.length} configured feature flag${data.rollouts.length === 1 ? "" : "s"}`}
          action={<Button render={<Link href="/admin/rollouts" />} variant="outline" size="sm">Manage</Button>}
        >
          <div className="space-y-2">
            {data.rollouts.length === 0 ? (
              <p className="text-sm text-muted-foreground">No rollout controls configured yet.</p>
            ) : (
              data.rollouts.slice(0, 5).map((rollout) => (
                <div key={rollout.id} className="flex items-center justify-between gap-3 rounded-xl bg-nexus-sunken px-3 py-2">
                  <div>
                    <p className="text-sm font-medium text-foreground">{rollout.displayName}</p>
                    <p className="text-xs text-muted-foreground">
                      {rollout.scope}
                      {rollout.scopeValue ? `: ${rollout.scopeValue}` : ""}
                    </p>
                  </div>
                  <StatusBadge tone={rollout.isEnabled ? "success" : "neutral"}>
                    {rollout.isEnabled ? "on" : "off"}
                  </StatusBadge>
                </div>
              ))
            )}
          </div>
        </Panel>
      </section>
    </>
  );
}
