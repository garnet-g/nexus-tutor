import { notFound, redirect } from "next/navigation";

import { ExamPaperSittingShell } from "@/features/examPapers/components/ExamPaperSittingShell";
import { getSessionUser } from "@/server/services/authService";
import { getExamPaperSessionForSitting } from "@/server/services/examPaperService";

export default async function ExamPaperSittingPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  const { id } = await params;
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  const view = await getExamPaperSessionForSitting(id, profile.id);
  if (!view) {
    notFound();
  }

  if (view.status === "submitted" || view.status === "self_marked") {
    redirect(`/exam-papers/${id}/results`);
  }

  return <ExamPaperSittingShell sessionId={id} initialView={view} />;
}
