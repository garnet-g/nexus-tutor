import Link from "next/link";

import type { CurriculumSubject, CurriculumTopic } from "@/types/curriculum";

interface SubjectTreeProps {
  subjects: CurriculumSubject[];
  topicsBySubjectId: Record<string, CurriculumTopic[]>;
}

export function SubjectTree({ subjects, topicsBySubjectId }: SubjectTreeProps) {
  if (subjects.length === 0) {
    return (
      <div className="rounded-2xl border border-border bg-card p-8 text-center">
        <p className="text-muted-foreground">
          No subjects are available for your curriculum yet.
        </p>
      </div>
    );
  }

  return (
    <div className="space-y-6">
      {subjects.map((subject) => {
        const topics = topicsBySubjectId[subject.id] ?? [];

        return (
          <section
            key={subject.id}
            className="overflow-hidden rounded-2xl border border-border bg-card"
          >
            <div className="border-b border-border bg-muted/50 px-6 py-4">
              <h2 className="text-lg font-semibold text-foreground">{subject.name}</h2>
              <p className="mt-1 text-sm text-muted-foreground">
                {subject.curriculumCode} · {topics.length} topic
                {topics.length === 1 ? "" : "s"}
              </p>
            </div>

            {topics.length === 0 ? (
              <div className="px-6 py-8 text-sm text-muted-foreground">
                Topics for this subject are coming soon.
              </div>
            ) : (
              <ul className="divide-y divide-border">
                {topics.map((topic) => (
                  <li key={topic.id}>
                    <Link
                      href={`/learn/${topic.id}`}
                      className="flex items-center justify-between gap-4 px-6 py-4 transition hover:bg-muted"
                    >
                      <div>
                        <p className="font-medium text-foreground">{topic.title}</p>
                        {topic.description ? (
                          <p className="mt-1 text-sm text-muted-foreground line-clamp-2">
                            {topic.description}
                          </p>
                        ) : null}
                      </div>
                      <div className="shrink-0 text-right text-sm text-muted-foreground">
                        <span>{topic.lessonCount} lessons</span>
                      </div>
                    </Link>
                  </li>
                ))}
              </ul>
            )}
          </section>
        );
      })}
    </div>
  );
}
