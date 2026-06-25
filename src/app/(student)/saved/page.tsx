import { BookMarked } from "lucide-react";

import { SaveQuickNoteForm } from "@/features/student/components/StudentExperienceActions";
import {
  EmptyStudentState,
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function SavedQuestionsPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Tools"
        title="Saved questions"
        description="Keep questions, lessons, topics, and notes you want to revisit."
      />

      <SaveQuickNoteForm />

      <section className="grid gap-4 lg:grid-cols-2">
        {experience.savedItems.length > 0 ? (
          experience.savedItems.map((item) => (
            <LinkedPanel
              key={item.id}
              href={item.href}
              title={item.title}
              description={item.description ?? `Saved ${item.itemType}`}
              eyebrow={item.itemType}
              icon={BookMarked}
            />
          ))
        ) : (
          <EmptyStudentState
            title="Nothing saved yet"
            description="Save questions and lesson notes here when you want a second look later."
          />
        )}
      </section>
    </div>
  );
}
