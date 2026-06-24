import { redirect } from "next/navigation";

import { AdminFeatureRolloutsPanel } from "@/features/admin/components/AdminFeatureRolloutsPanel";
import { PageHeader } from "@/features/admin/components/adminUi";
import {
  type AdminFeatureRollout,
  listFeatureRollouts,
} from "@/server/services/adminOpsService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminRolloutsPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  let rollouts: AdminFeatureRollout[] = [];
  try {
    rollouts = await listFeatureRollouts();
  } catch {
    rollouts = [];
  }

  return (
    <>
      <PageHeader
        eyebrow="Release control"
        title="Feature rollouts"
        description="Enable v2 features by global, curriculum, grade, cohort, student, or role scope before broader launch."
      />
      <AdminFeatureRolloutsPanel initialRollouts={rollouts} />
    </>
  );
}
