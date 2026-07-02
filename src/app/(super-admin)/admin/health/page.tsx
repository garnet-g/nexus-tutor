import { redirect } from "next/navigation";

import {
  PageHeader,
  Panel,
  StatusBadge,
  StatCard,
} from "@/features/admin/components/adminUi";
import { getDeploymentHealthSummary } from "@/server/services/healthService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function tone(status: string) {
  if (status === "critical") return "danger";
  if (status === "watch") return "warning";
  return "success";
}

function probeTone(status: string) {
  if (status === "misconfigured") return "danger";
  if (status === "degraded" || status === "not_verified") return "warning";
  if (status === "reachable") return "success";
  return "success";
}

export default async function AdminHealthPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const health = await getDeploymentHealthSummary({ checkReachability: true });
  const critical = health.filter((item) => item.status === "critical").length;
  const watch = health.filter((item) => item.status === "watch").length;

  return (
    <>
      <PageHeader
        eyebrow="System"
        title="System health"
        description="Configuration and reachability probes for database, Nex, M-Pesa, notifications, and scheduled jobs."
      />
      <section className="grid gap-4 sm:grid-cols-3">
        <StatCard label="Checks" value={health.length.toLocaleString()} />
        <StatCard label="Watch" value={watch.toLocaleString()} />
        <StatCard label="Critical" value={critical.toLocaleString()} />
      </section>
      <Panel title="Health probes">
        <div className="grid gap-3 md:grid-cols-2">
          {health.length === 0 ? (
            <p className="text-sm text-muted-foreground">No health probes available.</p>
          ) : (
            health.map((item) => (
              <div
                key={item.name}
                className="rounded-xl border border-nexus-border bg-nexus-sunken p-4"
              >
                <div className="flex items-start justify-between gap-3">
                  <p className="font-medium text-foreground">{item.name}</p>
                  <StatusBadge tone={tone(item.status)}>{item.status}</StatusBadge>
                </div>
                <div className="mt-2 flex items-center gap-2">
                  <StatusBadge tone={probeTone(item.probeStatus)}>
                    {item.probeStatus}
                  </StatusBadge>
                </div>
                <p className="mt-2 text-sm text-muted-foreground">{item.detail}</p>
              </div>
            ))
          )}
        </div>
      </Panel>
    </>
  );
}
