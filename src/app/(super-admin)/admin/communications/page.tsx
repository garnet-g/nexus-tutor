import { redirect } from "next/navigation";

import { AdminCommunicationsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminCommunicationLog,
  type AdminCommunicationTemplate,
  listCommunicationLogs,
  listCommunicationTemplates,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminCommunicationsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let templates: AdminCommunicationTemplate[] = [];
  let logs: AdminCommunicationLog[] = [];
  try {
    [templates, logs] = await Promise.all([
      listCommunicationTemplates(),
      listCommunicationLogs(),
    ]);
  } catch {
    templates = [];
    logs = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Lifecycle"
        title="Communications"
        description="Admin-owned SMS and email templates with a log view for operational outreach."
      />
      <AdminCommunicationsPanel initialTemplates={templates} initialLogs={logs} />
    </>
  );
}
