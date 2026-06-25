import Link from "next/link";
import { redirect } from "next/navigation";

import { Button } from "@/components/ui/Button";
import { PageHeader, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { getAdminSearchItems } from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminSearchPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  const items = await getAdminSearchItems().catch(() => []);

  return (
    <>
      <PageHeader
        eyebrow="Workflow"
        title="Search"
        description="Unified admin index across pages, support cases, alerts, approvals, templates, experiments, and saved views."
      />
      <Panel title="Search index" description={`${items.length} indexed item${items.length === 1 ? "" : "s"}`} padded={false}>
        <div className="overflow-x-auto">
          <table className="w-full text-sm">
            <thead><tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground"><th className="px-5 py-3 font-medium">Item</th><th className="px-5 py-3 font-medium">Type</th><th className="px-5 py-3 text-right font-medium">Open</th></tr></thead>
            <tbody>
              {items.length === 0 ? <tr><td colSpan={3} className="px-5 py-10 text-center text-muted-foreground">No indexed items.</td></tr> : items.map((item) => (
                <tr key={`${item.type}-${item.href}-${item.title}`} className="border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60">
                  <td className="px-5 py-3"><p className="font-medium text-foreground">{item.title}</p><p className="text-xs text-muted-foreground">{item.description}</p></td>
                  <td className="px-5 py-3"><StatusBadge tone="info">{item.type}</StatusBadge></td>
                  <td className="px-5 py-3 text-right"><Button render={<Link href={item.href} />} variant="outline" size="sm">Open</Button></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      </Panel>
    </>
  );
}
