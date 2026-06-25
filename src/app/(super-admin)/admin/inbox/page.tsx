import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import {
  EmptyState,
  PageHeader,
  Panel,
  StatusBadge,
} from "@/features/admin/components/adminUi";
import { getAdminTaskInbox } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

function severityTone(severity: string) {
  if (severity === "critical") return "danger";
  if (severity === "urgent") return "warning";
  return "neutral";
}

export default async function AdminInboxPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const tasks = await getAdminTaskInbox().catch(() => []);

  return (
    <>
      <PageHeader
        eyebrow="Workflow"
        title="Task inbox"
        description="Prioritized operational queue across alerts, support, Nex safety, payments, content review, and approvals."
        actions={<Button render={<Link href="/admin/alerts" />} variant="outline">New alert</Button>}
      />

      <Panel title="Priority queue" description={`${tasks.length} active task${tasks.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead>
              <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
                <th className="px-5 py-3 font-medium">Task</th>
                <th className="px-5 py-3 font-medium">Source</th>
                <th className="px-5 py-3 font-medium">Severity</th>
                <th className="px-5 py-3 font-medium">Created</th>
                <th className="px-5 py-3 text-right font-medium">Action</th>
              </tr>
            </thead>
            <tbody>
              {tasks.length === 0 ? (
                <tr>
                  <td colSpan={5}>
                    <EmptyState title="No active admin tasks" description="Alerts and operational queues will appear here when they need attention." />
                  </td>
                </tr>
              ) : tasks.map((task) => (
                <tr key={`${task.source}-${task.id}`} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                  <td className="px-5 py-3">
                    <p className="font-medium text-foreground">{task.title}</p>
                    {task.description ? <p className="text-xs text-muted-foreground">{task.description}</p> : null}
                  </td>
                  <td className="px-5 py-3 capitalize text-muted-foreground">{task.source}</td>
                  <td className="px-5 py-3"><StatusBadge tone={severityTone(task.severity)}>{task.severity}</StatusBadge></td>
                  <td className="px-5 py-3 text-xs text-muted-foreground">{new Date(task.createdAt).toLocaleDateString("en-KE")}</td>
                  <td className="px-5 py-3 text-right"><Button render={<Link href={task.href} />} variant="outline" size="sm">Open</Button></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </>
  );
}
