import { Target } from "lucide-react";

import {
  EmptyStudentState,
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function WeakAreasPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Practice"
        title="Weak areas"
        description="Topics are sorted from lowest mastery upward so revision time goes where it helps most."
        action={{ href: "/practice", label: "Start practice" }}
      />

      <section className="grid gap-4 lg:grid-cols-2">
        {experience.weakAreas.length > 0 ? (
          experience.weakAreas.map((topic) => (
            <LinkedPanel
              key={topic.topicId}
              href={`/practice?topicId=${topic.topicId}`}
              title={topic.title}
              description="Practice now, then check progress again after the session."
              eyebrow={`${topic.masteryPercentage}% mastery`}
              icon={Target}
              tone={topic.masteryPercentage < 45 ? "accent" : "default"}
            />
          ))
        ) : (
          <EmptyStudentState
            title="No weak areas flagged"
            description="As you complete more practice, this page will keep a focused queue of topics that need attention."
            href="/practice"
            label="Do practice"
          />
        )}
      </section>
    </div>
  );
}
