import { notFound, redirect } from "next/navigation";

import { Breadcrumbs } from "@/components/layout/breadcrumbs";
import { LessonRenderer } from "@/features/learn/components/LessonRenderer";
import { getSessionUser } from "@/server/services/authService";
import { getLesson, getTopicDetail } from "@/server/services/curriculumService";

import { getLessonProgressState } from "@/server/services/lessonProgressService";

interface LessonPageProps {
  params: Promise<{ topicId: string; lessonId: string }>;
}

export default async function LessonPage({ params }: LessonPageProps) {
  const { topicId, lessonId } = await params;
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  const [lesson, topic, progressState] = await Promise.all([
    getLesson(lessonId, profile.curriculum, profile.grade_level),
    getTopicDetail(topicId, profile.curriculum, profile.grade_level),
    getLessonProgressState(profile.id, lessonId).catch(() => ({
      status: null,
      completedAt: null,
      lastViewedAt: null,
    })),
  ]);

  if (!lesson || lesson.topicId !== topicId || !topic) {
    notFound();
  }

  const orderedLessonIds = topic.subtopics.flatMap((subtopic) =>
    subtopic.lessons.map((entry) => entry.id),
  );

  return (
    <div className="space-y-8">
      <Breadcrumbs
        items={[
          { label: "Learn", href: "/learn" },
          { label: lesson.topicTitle, href: `/learn/${topicId}` },
          { label: lesson.title },
        ]}
      />

      <LessonRenderer
        lesson={lesson}
        orderedLessonIds={orderedLessonIds}
        initialProgress={progressState}
      />
    </div>
  );
}
