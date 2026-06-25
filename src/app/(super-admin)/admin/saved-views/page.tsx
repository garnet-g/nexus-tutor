import { redirect } from "next/navigation";

import { AdminSavedViewsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminSavedView,
  listSavedViews,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminSavedViewsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let views: AdminSavedView[] = [];
  try {
    views = await listSavedViews();
  } catch {
    views = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Workflow"
        title="Saved views"
        description="Reusable admin filters and routes for recurring operational work."
      />
      <AdminSavedViewsPanel initialViews={views} />
    </>
  );
}
