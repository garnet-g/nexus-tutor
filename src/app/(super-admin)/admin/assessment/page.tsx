import { redirect } from "next/navigation";

import { AssessmentCalibrationPanel } from "@/features/admin/components/AssessmentCalibrationPanel";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminAssessmentPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  return <AssessmentCalibrationPanel />;
}
