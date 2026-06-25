import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { AdminApprovalsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import {
  type AdminApprovalRequest,
  listApprovals,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

const BULK_ACTIONS = [
  {
    title: "Bulk comp grant",
    target: "subscriptions",
    risk: "high",
    description: "Prepare a controlled approval before granting paid access to a cohort.",
  },
  {
    title: "Bulk parent notify",
    target: "communications",
    risk: "medium",
    description: "Use templates and approval queue before sending parent outreach.",
  },
  {
    title: "Bulk content publish",
    target: "content",
    risk: "high",
    description: "Route review batches through approvals before publication.",
  },
] as const;

export default async function AdminBulkActionsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let approvals: AdminApprovalRequest[] = [];
  try {
    approvals = await listApprovals("pending");
  } catch {
    approvals = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Workflow"
        title="Bulk actions"
        description="Production-safe bulk operations start as auditable approval requests instead of executing immediately."
        actions={<Button render={<Link href="/admin/approvals" />} variant="outline">Approval queue</Button>}
      />
      <Panel title="Action registry" description="Bulk execution is intentionally gated behind approval records.">
        <div className="grid gap-3 md:grid-cols-3">
          {BULK_ACTIONS.map((action) => (
            <div key={action.title} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex items-start justify-between gap-3">
                <p className="font-medium text-foreground">{action.title}</p>
                <StatusBadge tone={action.risk === "high" ? "danger" : "warning"}>{action.risk}</StatusBadge>
              </div>
              <p className="mt-2 text-sm text-muted-foreground">{action.description}</p>
              <p className="mt-3 font-mono text-xs text-muted-foreground">target:{action.target}</p>
            </div>
          ))}
        </div>
      </Panel>
      <AdminApprovalsPanel initialApprovals={approvals} />
    </>
  );
}
