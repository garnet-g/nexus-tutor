import { notFound, redirect } from "next/navigation";

import { SectionCard } from "@/components/ui/SectionCard";
import { getSessionUser } from "@/server/services/authService";
import { getPastPaperAttemptResults } from "@/server/services/pastPaperService";

interface ResultsPageProps {
  params: Promise<{ attemptId: string }>;
}

export default async function PracticePaperResultsPage({
  params,
}: ResultsPageProps) {
  const { attemptId } = await params;
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const results = await getPastPaperAttemptResults(
    attemptId,
    sessionUser.studentProfile.id,
  );

  if (!results) {
    notFound();
  }

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          {results.paperName}
        </h1>
        <p className="text-muted-foreground">
          {results.status === "marked"
            ? `Score: ${results.score ?? 0} / ${results.totalMarks}`
            : "AI marking is in progress — check back shortly."}
        </p>
      </div>

      <div className="space-y-4">
        {results.answers.map((answer) => (
          <SectionCard
            key={answer.questionId}
            title={`Question ${answer.questionNumber}`}
            description={
              answer.score !== null
                ? `${answer.score} / ${answer.marks} marks`
                : `${answer.marks} marks · not yet marked`
            }
          >
            <div className="space-y-3 text-sm">
              <p className="text-foreground">{answer.questionText}</p>

              <div className="rounded-[14px] border border-nexus-border bg-nexus-sunken p-3">
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                  Marking scheme
                </p>
                <p className="mt-1 text-foreground">{answer.markingScheme}</p>
              </div>

              {answer.studentAnswer ? (
                <div>
                  <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    Your answer
                  </p>
                  <p className="mt-1 text-foreground">{answer.studentAnswer}</p>
                </div>
              ) : null}

              {answer.ocrImageUrl ? (
                // eslint-disable-next-line @next/next/no-img-element
                <img
                  src={answer.ocrImageUrl}
                  alt={`Working for question ${answer.questionNumber}`}
                  className="max-h-56 rounded-[12px] border border-nexus-border object-contain"
                />
              ) : null}

              {answer.feedback ? (
                <div className="rounded-[14px] border border-nexus-primary/30 bg-nexus-primary/5 p-3">
                  <p className="text-xs font-medium uppercase tracking-wide text-nexus-primary">
                    AI feedback
                  </p>
                  <p className="mt-1 text-foreground">{answer.feedback}</p>
                </div>
              ) : null}
            </div>
          </SectionCard>
        ))}
      </div>
    </div>
  );
}
