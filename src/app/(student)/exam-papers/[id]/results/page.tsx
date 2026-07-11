import { notFound, redirect } from "next/navigation";

import { ExamPaperResultsShell } from "@/features/examPapers/components/ExamPaperResultsShell";
import { getSessionUser } from "@/server/services/authService";
import { getExamPaperResults } from "@/server/services/examPaperService";

export default async function ExamPaperResultsPage({
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

  const results = await getExamPaperResults(id, profile.id);
  if (!results) {
    notFound();
  }

  return <ExamPaperResultsShell sessionId={id} initialResults={results} />;
}
