import type { CurriculumLesson } from "@/types/curriculum";

import { LessonReader } from "@/features/learn/components/LessonReader";

interface LessonRendererProps {
  lesson: CurriculumLesson;
  studentId: string;
  orderedLessonIds: string[];
}

export function LessonRenderer({
  lesson,
  studentId,
  orderedLessonIds,
}: LessonRendererProps) {
  return (
    <LessonReader
      key={lesson.id}
      lesson={lesson}
      studentId={studentId}
      orderedLessonIds={orderedLessonIds}
    />
  );
}
