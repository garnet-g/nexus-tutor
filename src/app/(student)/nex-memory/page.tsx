import { Brain } from "lucide-react";

import {
  LinkedPanel,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function LearningMemoryPage() {
  const experience = await requireStudentExperience();
  const preferences = experience.profile.learning_preferences ?? {};
  const metadata = experience.profile.metadata ?? {};

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Nex"
        title="Learning memory"
        description="A clear, student-readable view of what Nexus uses to personalize support."
        action={{ href: "/profile", label: "Edit profile" }}
      />

      <section className="grid gap-4 lg:grid-cols-2">
        <LinkedPanel
          href="/profile"
          title={experience.profile.curriculum}
          description={`Grade ${experience.profile.grade_level.replace("_", " ")} at ${experience.profile.school_name ?? "your school"}.`}
          eyebrow="School profile"
          icon={Brain}
          tone="primary"
        />
        <LinkedPanel
          href="/weak-areas"
          title={experience.recommendedTopic?.title ?? "Practice history"}
          description="Your current recommendation comes from diagnostic and practice activity."
          eyebrow="Current focus"
          icon={Brain}
          tone="accent"
        />
      </section>

      <section className="grid gap-4 lg:grid-cols-2">
        <pre className="overflow-auto rounded-2xl border border-nexus-border bg-nexus-surface p-4 text-xs leading-relaxed text-muted-foreground">
          {JSON.stringify(preferences, null, 2)}
        </pre>
        <pre className="overflow-auto rounded-2xl border border-nexus-border bg-nexus-surface p-4 text-xs leading-relaxed text-muted-foreground">
          {JSON.stringify(metadata, null, 2)}
        </pre>
      </section>
    </div>
  );
}
