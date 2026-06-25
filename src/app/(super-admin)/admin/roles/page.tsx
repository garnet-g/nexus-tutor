import { redirect } from "next/navigation";

import { AdminRolesPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminRoleAssignment,
  listAdminRoleAssignments,
} from "@/server/services/adminPlatformService";
import { requireAdminRole } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminRolesPage() {
  const auth = await requireAdminRole(["super_admin"]);
  if (!auth.ok) redirect("/login");

  let assignments: AdminRoleAssignment[] = [];
  try {
    assignments = await listAdminRoleAssignments();
  } catch {
    assignments = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Access"
        title="Roles"
        description="Operational role assignments and route-level permission map for the expanded admin console."
      />
      <AdminRolesPanel initialAssignments={assignments} />
    </>
  );
}
