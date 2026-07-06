import { ConceptLibraryBrowser } from "@/features/student/components/ConceptLibraryBrowser";
import { StudentPageHeader } from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentFeature } from "@/features/student/server/requireStudentFeature";
import { listConceptReferences } from "@/server/services/conceptLibraryService";

export default async function ConceptLibraryPage() {
  const experience = await requireStudentFeature("student.concept_library");
  const references = await listConceptReferences(experience.profile);

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Study"
        title="Concept library"
        description="Published formulas, definitions, and key points from your curriculum — linked back to lessons."
      />

      <ConceptLibraryBrowser
        references={references}
        curriculum={experience.profile.curriculum}
      />
    </div>
  );
}
