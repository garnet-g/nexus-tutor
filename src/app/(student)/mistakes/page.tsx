import { BookMarked } from "lucide-react";

import { MistakeStatusButton } from "@/features/student/components/StudentExperienceActions";
import {
  EmptyStudentState,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function MistakeJournalPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Practice"
        title="Mistake journal"
        description="Track missed or confusing questions, then move them from open to retried to mastered."
        action={{ href: "/practice", label: "Practice" }}
      />

      {experience.mistakes.length > 0 ? (
        <section className="space-y-3">
          {experience.mistakes.map((mistake) => (
            <article
              key={mistake.id}
              className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
            >
              <div className="flex items-start gap-3">
                <span className="flex size-10 flex-none items-center justify-center rounded-xl bg-nexus-sunken text-nexus-primary">
                  <BookMarked className="size-5" />
                </span>
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-semibold uppercase tracking-[0.16em] text-muted-foreground">
                    {mistake.topicTitle ?? mistake.source} - {mistake.status}
                  </p>
                  <p className="mt-1 font-semibold text-foreground">
                    {mistake.questionText}
                  </p>
                  {mistake.explanation ? (
                    <p className="mt-2 text-sm leading-relaxed text-muted-foreground">
                      {mistake.explanation}
                    </p>
                  ) : null}
                  <div className="mt-3 flex flex-wrap gap-2">
                    <MistakeStatusButton id={mistake.id} status="retried" label="Mark retried" />
                    <MistakeStatusButton id={mistake.id} status="mastered" label="Mark mastered" />
                  </div>
                </div>
              </div>
            </article>
          ))}
        </section>
      ) : (
        <EmptyStudentState
          title="No mistakes logged yet"
          description="Mistakes from practice and mock exams will appear here as review work is added."
          href="/practice"
          label="Start practice"
        />
      )}
    </div>
  );
}
