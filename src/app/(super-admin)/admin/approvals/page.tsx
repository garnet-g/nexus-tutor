import { redirect } from "next/navigation";

import { AdminApprovalsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminApprovalRequest,
  listApprovals,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminApprovalsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let approvals: AdminApprovalRequest[] = [];
  try {
    approvals = await listApprovals();
  } catch {
    approvals = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Workflow"
        title="Approvals"
        description="Controlled approval queue for sensitive changes, bulk actions, and operational exceptions."
      />
      <AdminApprovalsPanel initialApprovals={approvals} />
    </>
  );
}
