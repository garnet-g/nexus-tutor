import { redirect } from "next/navigation";

import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { AuditLogTable } from "@/features/admin/components/AuditLogTable";
import {
  type AdminAuditLogEntry,
  listAdminAuditLog,
} from "@/server/services/adminAuditService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AuditLogPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  let entries: AdminAuditLogEntry[] = [];
  try {
    entries = await listAdminAuditLog({ limit: 100 });
  } catch {
    entries = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Security"
        title="Audit log"
        description="Privileged admin actions across the platform, most recent first (Nairobi time)."
      />

      <Panel title="Recent activity" padded={false}>
        <AuditLogTable rows={entries} />
      </Panel>
    </>
  );
}
