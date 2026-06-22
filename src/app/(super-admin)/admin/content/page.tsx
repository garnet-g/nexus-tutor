import { redirect } from "next/navigation";

import { ContentPipelinePanel } from "@/features/admin/components/ContentPipelinePanel";
import {
  getActiveSubjectsContentCoverage,
  getContentDraftQueue,
} from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminContentPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const [subjects, drafts] = await Promise.all([
    getActiveSubjectsContentCoverage(),
    getContentDraftQueue(),
  ]);

  return (
    <ContentPipelinePanel
      adminUserId={auth.userId}
      initialSubjects={subjects}
      initialDrafts={drafts}
    />
  );
}
