import { notFound, redirect } from "next/navigation";

import { Breadcrumbs } from "@/components/layout/breadcrumbs";
import { TopicLearningPath } from "@/features/learn/components/TopicLearningPath";
import { getSessionUser } from "@/server/services/authService";
import { getTopicDetail } from "@/server/services/curriculumService";
import { getProgressSummary } from "@/server/services/practiceService";

interface TopicPageProps {
  params: Promise<{ topicId: string }>;
}

export default async function TopicPage({ params }: TopicPageProps) {
  const { topicId } = await params;
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  const [topic, progress] = await Promise.all([
    getTopicDetail(topicId, profile.curriculum, profile.grade_level),
    getProgressSummary(profile.id).catch(() => null),
  ]);

  if (!topic) {
    notFound();
  }

  const masteryPercentage =
    progress?.topicMastery.find((entry) => entry.topicId === topicId)
      ?.masteryPercentage ?? 0;

  return (
    <div className="space-y-8">
      <Breadcrumbs
        items={[
          { label: "Learn", href: "/learn" },
          { label: topic.title },
        ]}
      />

      <TopicLearningPath
        topic={topic}
        studentId={profile.id}
        masteryPercentage={masteryPercentage}
      />
    </div>
  );
}
