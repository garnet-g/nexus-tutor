import { redirect } from "next/navigation";

import {
  PageHeader,
  Panel,
  StatusBadge,
  StatCard,
} from "@/features/admin/components/adminUi";
import { getSystemHealth } from "@/server/services/adminPlatformService";
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

export default async function AdminHealthPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const health = await getSystemHealth().catch(() => []);
  const critical = health.filter((item) => item.status === "critical").length;
  const watch = health.filter((item) => item.status === "watch").length;

  return (
    <>
      <PageHeader
        eyebrow="System"
        title="System health"
        description="Operational readout for Supabase, Nex, M-Pesa, safety queues, and admin alerts."
      />
      <section className="grid gap-4 sm:grid-cols-3">
        <StatCard label="Checks" value={health.length.toLocaleString()} />
        <StatCard label="Watch" value={watch.toLocaleString()} />
        <StatCard label="Critical" value={critical.toLocaleString()} />
      </section>
      <Panel title="Health checks">
        <div className="grid gap-3 md:grid-cols-2">
          {health.length === 0 ? (
            <p className="text-sm text-muted-foreground">No health checks available.</p>
          ) : health.map((item) => (
            <div key={item.name} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex items-start justify-between gap-3">
                <p className="font-medium text-foreground">{item.name}</p>
                <StatusBadge tone={tone(item.status)}>{item.status}</StatusBadge>
              </div>
              <p className="mt-2 text-sm text-muted-foreground">{item.detail}</p>
            </div>
          ))}
        </div>
      </Panel>
    </>
  );
}
