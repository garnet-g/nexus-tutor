import { redirect } from "next/navigation";

import { ExamPaperTemplateAuthoringPanel } from "@/features/admin/components/ExamPaperTemplateAuthoringPanel";
import { listExamPaperTemplates } from "@/server/services/examPaperAuthoringService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminExamPapersPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const templates = await listExamPaperTemplates();

  return <ExamPaperTemplateAuthoringPanel templates={templates} />;
}
