import { redirect } from "next/navigation";

import { AdminSupportCasesPanel } from "@/features/admin/components/AdminSupportCasesPanel";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminSupportCase,
  listSupportCases,
} from "@/server/services/adminOpsService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminSupportPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) {
    redirect("/login");
  }

  let cases: AdminSupportCase[] = [];
  try {
    cases = await listSupportCases({ limit: 100 });
  } catch {
    cases = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Operations"
        title="Support desk"
        description="Lightweight internal cases for account issues, billing follow-up, Nex concerns, content reports, and parent support."
      />
      <AdminSupportCasesPanel initialCases={cases} />
    </>
  );
}
