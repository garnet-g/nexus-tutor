import { notFound, redirect } from "next/navigation";

import { LessonStudioShell } from "@/features/admin/studio/components/LessonStudioShell";
import { getDraftLessonForPreview } from "@/server/services/contentGenerationService";
import { requireSuperAdmin } from "@/server/services/superAdminGuard";

export const dynamic = "force-dynamic";

export default async function StudioLessonPage({
  params,
}: {
  params: Promise<{ lessonId: string }>;
}) {
  const auth = await requireSuperAdmin();
  if (!auth.ok) {
    redirect("/login");
  }

  const { lessonId } = await params;
  const lesson = await getDraftLessonForPreview(lessonId);

  if (!lesson) {
    notFound();
  }

  return <LessonStudioShell initialLesson={lesson} />;
}
