import Link from "next/link";
import { Brain } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import type { StudentExperienceData } from "@/server/services/studentExperienceService";

function formatPreferenceSummary(preferences: Record<string, unknown>) {
  const studyStyle =
    typeof preferences.studyStyle === "string" ? preferences.studyStyle : null;
  const sessionLength =
    typeof preferences.preferredSessionLength === "number"
      ? `${preferences.preferredSessionLength} min sessions`
      : null;

  return [studyStyle, sessionLength].filter(Boolean).join(" · ") || "No custom preferences saved yet.";
}

export function LearningMemoryView({
  experience,
}: {
  experience: StudentExperienceData;
}) {
  const preferences = (experience.profile.learning_preferences ?? {}) as Record<
    string,
    unknown
  >;
  const metadata = (experience.profile.metadata ?? {}) as Record<string, unknown>;
  const commonErrors = Array.isArray(metadata.commonErrors)
    ? metadata.commonErrors.slice(0, 5).map((entry) => String(entry))
    : [];

  return (
    <div className="space-y-4">
      <SectionCard
        title="What Nex is focusing on now"
        description="This is the learning context used to personalize your next help session."
      >
        <p className="text-sm text-foreground">
          {experience.recommendedTopic?.title ?? "No focus topic yet"}
        </p>
        {experience.recommendedTopic?.masteryPercentage != null ? (
          <p className="mt-1 text-sm text-muted-foreground">
            {experience.recommendedTopic.masteryPercentage}% mastery
          </p>
        ) : null}
      </SectionCard>

      <SectionCard
        title="What Nex has noticed"
        description="Useful learning patterns only — no hidden scoring data."
      >
        {commonErrors.length > 0 ? (
          <ul className="space-y-2 text-sm text-foreground">
            {commonErrors.map((error) => (
              <li key={error} className="rounded-xl bg-nexus-sunken px-3 py-2">
                {error}
              </li>
            ))}
          </ul>
        ) : (
          <p className="text-sm text-muted-foreground">
            Complete practice and chat with Nex to build useful memory here.
          </p>
        )}
      </SectionCard>

      <SectionCard title="Learning preferences" description="Adjust how Nex supports you.">
        <p className="text-sm text-foreground">{formatPreferenceSummary(preferences)}</p>
        <Link href="/profile" className="mt-3 inline-block text-sm font-medium text-nexus-primary">
          Edit on profile
        </Link>
      </SectionCard>

      <div className="flex items-center gap-2 text-sm text-muted-foreground">
        <Brain className="size-4" />
        Memory updates as you learn. This page does not expose raw JSON or answer keys.
      </div>
    </div>
  );
}
