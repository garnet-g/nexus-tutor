import { Library } from "lucide-react";

import {
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

const FORMULA_SECTIONS = [
  {
    title: "Algebra",
    description: "Linear equations, expressions, substitution, and factorisation.",
    href: "/learn",
  },
  {
    title: "Geometry",
    description: "Angles, area, volume, similarity, and common theorem reminders.",
    href: "/learn",
  },
  {
    title: "Graphs",
    description: "Gradient, intercepts, coordinates, and interpretation prompts.",
    href: "/learn",
  },
  {
    title: "Statistics",
    description: "Mean, median, mode, range, probability, and data displays.",
    href: "/learn",
  },
];

export default async function ConceptLibraryPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Study"
        title="Concept library"
        description="Fast references for formulas, definitions, and ideas linked back into lessons."
      />

      <section className="grid gap-4 lg:grid-cols-2">
        {FORMULA_SECTIONS.map((section) => (
          <LinkedPanel
            key={section.title}
            href={section.href}
            title={section.title}
            description={section.description}
            eyebrow={experience.profile.curriculum}
            icon={Library}
          />
        ))}
      </section>
    </div>
  );
}
