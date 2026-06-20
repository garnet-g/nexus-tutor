import { redirect } from "next/navigation";

import { ContentPipelinePanel } from "@/features/admin/components/ContentPipelinePanel";
import {
  getContentDraftQueue,
  getMathematicsContentCoverage,
} from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function AdminContentPage() {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const [coverage, drafts] = await Promise.all([
    getMathematicsContentCoverage(),
    getContentDraftQueue(),
  ]);

  return (
    <ContentPipelinePanel
      adminUserId={auth.userId}
      initialCoverage={coverage}
      initialDrafts={drafts}
    />
  );
}
