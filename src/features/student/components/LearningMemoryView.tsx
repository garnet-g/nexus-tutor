import Link from "next/link";
import { Brain, Sparkles } from "lucide-react";

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
        title="Read-only projection"
        description="Nexus uses this memory to personalize tutoring. Edit school and learning preferences on your profile."
      >
        <p className="text-sm text-muted-foreground">
          Curriculum {experience.profile.curriculum} · Grade{" "}
          {experience.profile.grade_level.replace("_", " ")}
        </p>
      </SectionCard>

      <div className="grid gap-4 lg:grid-cols-2">
        <SectionCard title="Learning preferences" description="From your profile settings">
          <p className="text-sm text-foreground">{formatPreferenceSummary(preferences)}</p>
          <Link href="/profile" className="mt-3 inline-block text-sm font-medium text-nexus-primary">
            Edit on profile
          </Link>
        </SectionCard>

        <SectionCard title="Current focus" description="From diagnostic and practice activity">
          <p className="text-sm text-foreground">
            {experience.recommendedTopic?.title ?? "No recommendation yet"}
          </p>
          {experience.recommendedTopic?.masteryPercentage != null ? (
            <p className="mt-1 text-sm text-muted-foreground">
              {experience.recommendedTopic.masteryPercentage}% mastery
            </p>
          ) : null}
        </SectionCard>
      </div>

      <SectionCard
        title="Patterns Nex noticed"
        description="Summarized from practice and tutoring — not raw internal data"
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

      <SectionCard title="Progress signals" description="Health and streak snapshots">
        <div className="grid gap-3 sm:grid-cols-3">
          <div className="rounded-xl bg-nexus-sunken p-3">
            <p className="text-xs uppercase tracking-wide text-muted-foreground">Health</p>
            <p className="mt-1 text-lg font-semibold text-foreground">
              {experience.progress.healthScore}
            </p>
          </div>
          <div className="rounded-xl bg-nexus-sunken p-3">
            <p className="text-xs uppercase tracking-wide text-muted-foreground">Streak</p>
            <p className="mt-1 text-lg font-semibold text-foreground">
              {experience.progress.currentStreak} days
            </p>
          </div>
          <div className="rounded-xl bg-nexus-sunken p-3">
            <p className="text-xs uppercase tracking-wide text-muted-foreground">XP</p>
            <p className="mt-1 flex items-center gap-1 text-lg font-semibold text-foreground">
              <Sparkles className="size-4 text-nexus-accent" />
              {experience.progress.totalXp}
            </p>
          </div>
        </div>
      </SectionCard>

      <div className="flex items-center gap-2 text-sm text-muted-foreground">
        <Brain className="size-4" />
        Memory updates as you learn. This page does not expose raw JSON or answer keys.
      </div>
    </div>
  );
}
