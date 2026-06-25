import { redirect } from "next/navigation";

import { AdminAlertsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminAlert,
  listAdminAlerts,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminAlertsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let alerts: AdminAlert[] = [];
  try {
    alerts = await listAdminAlerts();
  } catch {
    alerts = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Risk"
        title="Alerts"
        description="Create, acknowledge, and resolve operational alerts that feed the admin inbox."
      />
      <AdminAlertsPanel initialAlerts={alerts} />
    </>
  );
}
