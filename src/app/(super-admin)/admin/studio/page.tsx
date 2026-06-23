import { redirect } from "next/navigation";

import { StudioWorkspaceShell } from "@/features/admin/studio/components/StudioWorkspaceShell";
import { getActiveSubjectsContentCoverage } from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function StudioIndexPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const subjects = await getActiveSubjectsContentCoverage();

  return <StudioWorkspaceShell subjects={subjects} />;
}
