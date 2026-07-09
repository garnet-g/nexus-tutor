import { LearningMemoryView } from "@/features/student/components/LearningMemoryView";
import { StudentPageHeader } from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function LearningMemoryPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Nex"
        title="Learning memory"
        description="A simple view of what Nex is using right now to guide your learning."
        action={{ href: "/profile", label: "Edit profile" }}
      />
      <LearningMemoryView experience={experience} />
    </div>
  );
}
