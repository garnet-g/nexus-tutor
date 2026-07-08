import { notFound, redirect } from "next/navigation";

import { PracticePaperAttemptSimulator } from "@/features/practice-papers/components/PracticePaperAttemptSimulator";
import { getSessionUser } from "@/server/services/authService";
import {
  getPastPaperDetail,
  startPastPaperAttempt,
} from "@/server/services/pastPaperService";

interface PracticePaperAttemptPageProps {
  params: Promise<{ id: string }>;
}

export default async function PracticePaperAttemptPage({
  params,
}: PracticePaperAttemptPageProps) {
  const { id } = await params;
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const paper = await getPastPaperDetail(id);

  if (!paper) {
    notFound();
  }

  const { attemptId } = await startPastPaperAttempt(
    sessionUser.studentProfile.id,
    id,
  );

  return <PracticePaperAttemptSimulator paper={paper} attemptId={attemptId} />;
}
