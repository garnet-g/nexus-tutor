import { redirect } from "next/navigation";

import { NewLessonStudioForm } from "@/features/admin/studio/components/NewLessonStudioForm";
import { getActiveSubjectsContentCoverage } from "@/server/services/contentAdminReadService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function StudioNewLessonPage({
  searchParams,
}: {
  searchParams: Promise<{ subtopicId?: string }>;
}) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const subjects = await getActiveSubjectsContentCoverage();
  const params = await searchParams;

  return (
    <NewLessonStudioForm subjects={subjects} initialSubtopicId={params.subtopicId} />
  );
}
