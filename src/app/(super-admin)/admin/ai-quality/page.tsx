import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { PageHeader, Panel, StatCard, StatusBadge } from "@/features/admin/components/adminUi";
import { getAiQualityDashboard } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminAiQualityPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const data = await getAiQualityDashboard().catch(() => ({
    nexOps: null,
    flags: [],
    openFlags: 0,
    escalatedFlags: 0,
  }));

  return (
    <>
      <PageHeader
        eyebrow="Quality"
        title="AI quality"
        description="Nex safety, cost, fallback, and flagged-message review surface."
        actions={<Button render={<Link href="/admin/nex-ops" />} variant="outline">Nex ops</Button>}
      />
      <section className="grid gap-4 sm:grid-cols-4">
        <StatCard label="Messages today" value={(data.nexOps?.messagesToday ?? 0).toLocaleString()} />
        <StatCard label="Open flags" value={data.openFlags.toLocaleString()} />
        <StatCard label="Escalated" value={data.escalatedFlags.toLocaleString()} />
        <StatCard label="Fallback rate" value={data.nexOps?.fallbackRate == null ? "0%" : `${Math.round(data.nexOps.fallbackRate * 100)}%`} />
      </section>
      <Panel title="Flagged messages" description={`${data.flags.length} recent flag${data.flags.length === 1 ? "" : "s"}`}>
        <div className="space-y-3">
          {data.flags.length === 0 ? <p className="text-sm text-muted-foreground">No Nex flags found.</p> : data.flags.map((flag) => (
            <div key={flag.id} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div><p className="font-medium text-foreground">{flag.studentName ?? "Unknown student"}</p><p className="mt-1 line-clamp-2 text-sm text-muted-foreground">{flag.reason ?? flag.messagePreview ?? "No reason provided."}</p></div>
                <StatusBadge tone={flag.status === "open" ? "warning" : "neutral"}>{flag.status}</StatusBadge>
              </div>
            </div>
          ))}
        </div>
      </Panel>
    </>
  );
}
