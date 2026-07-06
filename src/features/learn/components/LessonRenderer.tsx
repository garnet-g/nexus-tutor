import type { CurriculumLesson } from "@/types/curriculum";

import { LessonReader } from "@/features/learn/components/LessonReader";

interface LessonRendererProps {
  lesson: CurriculumLesson;
  orderedLessonIds: string[];
  initialProgress: {
    status: "in_progress" | "completed" | null;
    completedAt: string | null;
    lastViewedAt: string | null;
  };
  initialBookmark?: {
    savedItemId: string;
  } | null;
}

export function LessonRenderer({
  lesson,
  orderedLessonIds,
  initialProgress,
  initialBookmark = null,
}: LessonRendererProps) {
  return (
    <LessonReader
      key={lesson.id}
      lesson={lesson}
      orderedLessonIds={orderedLessonIds}
      initialProgress={initialProgress}
      initialBookmark={initialBookmark}
    />
  );
}
