import { Search } from "lucide-react";

import { StudySearchPanel } from "@/features/student/components/StudySearchPanel";
import {
  EmptyStudentState,
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentFeature } from "@/features/student/server/requireStudentFeature";

export default async function StudySearchPage() {
  const experience = await requireStudentFeature("student.study_search");
  const items = [
    ...experience.weakAreas.slice(0, 4).map((topic) => ({
      href: `/practice?topicId=${topic.topicId}`,
      title: topic.title,
      description: `${topic.masteryPercentage}% mastery`,
      eyebrow: "Topic",
    })),
    ...experience.savedItems.slice(0, 4).map((item) => ({
      href: item.href,
      title: item.title,
      description: item.description ?? `Saved ${item.itemType}`,
      eyebrow: "Saved",
    })),
    ...experience.recentLessons.slice(0, 4).map((lesson) => ({
      href: lesson.href,
      title: lesson.lessonTitle,
      description: lesson.topicTitle,
      eyebrow: "Lesson",
    })),
  ];

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Study"
        title="Study search"
        description="Search published lessons and practice questions in your curriculum."
      />

      <StudySearchPanel />

      <section className="space-y-3">
        <div className="flex items-center gap-2 text-sm text-muted-foreground">
          <Search className="size-4" />
          Shortcuts from your recent activity
        </div>
        <div className="grid gap-4 lg:grid-cols-2">
          {items.length > 0 ? (
            items.map((item) => (
              <LinkedPanel key={`${item.eyebrow}-${item.href}-${item.title}`} {...item} />
            ))
          ) : (
            <EmptyStudentState
              title="Search has nothing personal yet"
              description="Complete lessons, save questions, or do practice and this page will fill with useful shortcuts."
              href="/learn"
              label="Browse lessons"
            />
          )}
        </div>
      </section>
    </div>
  );
}
