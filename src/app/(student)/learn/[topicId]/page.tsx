import { notFound, redirect } from "next/navigation";

import { Breadcrumbs } from "@/components/layout/breadcrumbs";
import { TopicList } from "@/features/learn/components/TopicList";
import { getSessionUser } from "@/server/services/authService";
import { getTopicDetail } from "@/server/services/curriculumService";

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

  const topic = await getTopicDetail(
    topicId,
    profile.curriculum,
    profile.grade_level,
  );

  if (!topic) {
    notFound();
  }

  return (
    <div className="space-y-8">
      <Breadcrumbs
        items={[
          { label: "Learn", href: "/learn" },
          { label: topic.title },
        ]}
      />

      <TopicList topic={topic} subjectName={topic.subjectName} />
    </div>
  );
}
