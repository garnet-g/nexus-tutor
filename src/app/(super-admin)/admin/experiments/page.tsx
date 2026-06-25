import { redirect } from "next/navigation";

import { AdminExperimentsPanel } from "@/features/admin/components/AdminPlatformCrudPanels";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminExperiment,
  listExperiments,
} from "@/server/services/adminPlatformService";
import {
  ADMIN_ROLES,
  requireAdminRole,
} from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminExperimentsPage() {
  const auth = await requireAdminRole(ADMIN_ROLES);
  if (!auth.ok) redirect("/login");

  let experiments: AdminExperiment[] = [];
  try {
    experiments = await listExperiments();
  } catch {
    experiments = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Growth"
        title="Experiments"
        description="A production ledger for pricing, onboarding, curriculum, and retention experiments."
      />
      <AdminExperimentsPanel initialExperiments={experiments} />
    </>
  );
}
