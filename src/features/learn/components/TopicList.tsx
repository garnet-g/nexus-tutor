import Link from "next/link";

import type { CurriculumTopicDetail } from "@/types/curriculum";

interface TopicListProps {
  topic: CurriculumTopicDetail;
  subjectName?: string;
}

export function TopicList({ topic, subjectName }: TopicListProps) {
  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          {subjectName ?? "Topic"}
        </p>
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          {topic.title}
        </h1>
        {topic.description ? (
          <p className="max-w-2xl text-muted-foreground">{topic.description}</p>
        ) : null}
        <p className="text-sm text-muted-foreground">
          {topic.lessonCount} lesson{topic.lessonCount === 1 ? "" : "s"}
        </p>
      </div>

      <div className="space-y-4">
        {topic.subtopics.map((subtopic) => (
          <section
            key={subtopic.id}
            className="overflow-hidden rounded-2xl border border-border bg-card"
          >
            <div className="border-b border-border px-6 py-4">
              <h2 className="text-base font-semibold text-foreground">
                {subtopic.title}
              </h2>
              {subtopic.description ? (
                <p className="mt-1 text-sm text-muted-foreground">{subtopic.description}</p>
              ) : null}
            </div>

            {subtopic.lessons.length === 0 ? (
              <div className="px-6 py-6 text-sm text-muted-foreground">
                Lessons for this subtopic are coming soon.
              </div>
            ) : (
              <ul className="divide-y divide-border">
                {subtopic.lessons.map((lesson) => (
                  <li key={lesson.id}>
                    <Link
                      href={`/learn/${topic.id}/${lesson.id}`}
                      className="flex items-center justify-between gap-4 px-6 py-4 transition hover:bg-muted"
                    >
                      <span className="font-medium text-foreground">{lesson.title}</span>
                      <span className="text-sm text-muted-foreground">
                        {lesson.estimatedMinutes} min
                      </span>
                    </Link>
                  </li>
                ))}
              </ul>
            )}
          </section>
        ))}
      </div>
    </div>
  );
}
