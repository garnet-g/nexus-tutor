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
        description="A read-only view of what Nexus uses to personalize support — not raw internal data."
        action={{ href: "/profile", label: "Edit profile" }}
      />
      <LearningMemoryView experience={experience} />
    </div>
  );
}
