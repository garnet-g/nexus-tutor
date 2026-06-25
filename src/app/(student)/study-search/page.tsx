import { BookOpen, BookMarked, Search, Target } from "lucide-react";

import {
  EmptyStudentState,
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function StudySearchPage() {
  const experience = await requireStudentExperience();
  const items = [
    ...experience.weakAreas.slice(0, 4).map((topic) => ({
      href: `/practice?topicId=${topic.topicId}`,
      title: topic.title,
      description: `${topic.masteryPercentage}% mastery`,
      eyebrow: "Topic",
      icon: Target,
    })),
    ...experience.savedItems.slice(0, 4).map((item) => ({
      href: item.href,
      title: item.title,
      description: item.description ?? `Saved ${item.itemType}`,
      eyebrow: "Saved",
      icon: BookMarked,
    })),
    ...experience.recentLessons.slice(0, 4).map((lesson) => ({
      href: lesson.href,
      title: lesson.lessonTitle,
      description: lesson.topicTitle,
      eyebrow: "Lesson",
      icon: BookOpen,
    })),
  ];

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Study"
        title="Study search"
        description="A useful starting point for lessons, weak topics, saved items, and recent study activity."
      />

      <div className="rounded-2xl border border-nexus-border bg-nexus-surface p-4">
        <div className="flex items-center gap-3 rounded-xl bg-nexus-sunken px-3 py-3 text-muted-foreground">
          <Search className="size-5" />
          <span className="text-sm">Use Ctrl K anywhere to find pages and study actions.</span>
        </div>
      </div>

      <section className="grid gap-4 lg:grid-cols-2">
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
      </section>
    </div>
  );
}
