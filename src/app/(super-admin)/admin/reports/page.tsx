import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { getReportCards } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminReportsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const reports = getReportCards();

  return (
    <>
      <PageHeader
        eyebrow="Reporting"
        title="Reports"
        description="Canonical admin report entry points. Export keys are stable so CSV generation can be layered on without changing report links."
      />
      <Panel title="Available reports">
        <div className="grid gap-3 md:grid-cols-2">
          {reports.map((report) => (
            <div key={report.exportKey} className="rounded-xl border border-nexus-border bg-nexus-sunken p-4">
              <div className="flex flex-wrap items-start justify-between gap-3">
                <div>
                  <p className="font-medium text-foreground">{report.title}</p>
                  <p className="mt-1 text-sm text-muted-foreground">{report.description}</p>
                  <p className="mt-2 font-mono text-xs text-muted-foreground">export:{report.exportKey}</p>
                </div>
                <Button render={<Link href={report.href} />} variant="outline" size="sm">Open</Button>
              </div>
            </div>
          ))}
        </div>
      </Panel>
    </>
  );
}
