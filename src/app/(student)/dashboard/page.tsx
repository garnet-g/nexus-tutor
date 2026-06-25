import Link from "next/link";
import { redirect } from "next/navigation";
import {
  ArrowRight,
  BookMarked,
  Brain,
  CalendarCheck,
  Clock3,
  Download,
  Flame,
  Library,
  ListChecks,
  Search,
  Sparkles,
  Target,
  Zap,
} from "lucide-react";

import { NexMark } from "@/components/NexMark";
import { GoalRing, StreakHeatmap } from "@/components/widgets/StatWidgets";
import {
  LinkedPanel,
  MetricRow,
} from "@/features/student/components/StudentExperienceBlocks";
import { getSessionUser } from "@/server/services/authService";
import { getStudentExperienceData } from "@/server/services/studentExperienceService";

function nairobiGreeting(): string {
  const hour = Number(
    new Intl.DateTimeFormat("en-KE", {
      hour: "numeric",
      hour12: false,
      timeZone: "Africa/Nairobi",
    }).format(new Date()),
  );
  if (hour < 12) return "Morning";
  if (hour < 17) return "Afternoon";
  return "Evening";
}

export default async function StudentDashboardPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const experience = await getStudentExperienceData(profile);
  const firstName = profile.full_name?.split(" ")[0];
  const snapshot = experience.snapshot;

  return (
    <div className="space-y-6 nexus-enter">
      <header className="flex flex-col gap-4 lg:flex-row lg:items-end lg:justify-between">
        <div className="flex items-start gap-3">
          <NexMark size={52} />
          <div className="min-w-0">
            <h1 className="font-heading text-2xl font-medium leading-tight text-foreground sm:text-[1.75rem]">
              {nairobiGreeting()}
              {firstName ? `, ${firstName}` : ""}.
            </h1>
            <p className="mt-1 max-w-2xl text-sm leading-relaxed text-muted-foreground">
              {snapshot.primaryAction.title
                ? `Start with ${snapshot.primaryAction.title}, then clear the next useful study action.`
                : "Start with the best next study action and keep your progress moving."}
            </p>
          </div>
        </div>
        <Link
          href="/study-search"
          className="inline-flex h-10 items-center justify-center gap-2 rounded-xl border border-nexus-border bg-nexus-surface px-4 text-sm font-semibold text-foreground transition-colors hover:bg-nexus-sunken"
        >
          <Search className="size-4" />
          Study search
        </Link>
      </header>

      <section className="grid gap-5 lg:grid-cols-[1.35fr_0.65fr]">
        <div className="relative overflow-hidden rounded-[28px] bg-nexus-primary p-6 text-nexus-text-inverse shadow-nex">
          <div className="pointer-events-none absolute -right-10 -top-10 size-44 rounded-full border-[20px] border-white/[0.07]" />
          {snapshot.predictedGrade ? (
            <span className="absolute right-5 top-5 inline-flex items-center gap-1 rounded-full bg-nexus-accent px-2.5 py-1 text-[11px] font-bold text-nexus-text-primary">
              Predicted {snapshot.predictedGrade}
            </span>
          ) : null}
          <p className="text-xs font-medium text-nexus-text-inverse/80">
            Academic health
          </p>
          <p className="mt-1 font-heading text-6xl font-medium leading-none tabular">
            {snapshot.healthScore}
            <span className="text-xl text-nexus-text-inverse/70">/100</span>
          </p>
          <div className="mt-4 h-1.5 w-full max-w-sm overflow-hidden rounded-full bg-white/15">
            <div
              className="h-full rounded-full bg-nexus-accent transition-all"
              style={{ width: `${snapshot.healthScore}%` }}
            />
          </div>
          <Link
            href={snapshot.primaryAction.href}
            className="mt-5 inline-flex items-center gap-2 rounded-xl bg-white/12 px-4 py-2 text-sm font-semibold text-nexus-text-inverse transition-colors hover:bg-white/18"
          >
            {snapshot.primaryAction.label}
            <ArrowRight className="size-4" />
          </Link>
        </div>

        <div className="space-y-4">
          <div className="flex items-center gap-4 rounded-[22px] border border-nexus-border bg-nexus-surface p-5">
            <GoalRing
              value={snapshot.dailyGoal.completed}
              max={snapshot.dailyGoal.minutes}
              unit="m"
            />
            <div>
              <p className="text-sm font-semibold text-foreground">
                Today&apos;s goal
              </p>
              <p className="mt-0.5 text-xs text-muted-foreground">
                {snapshot.dailyGoal.left > 0
                  ? `${snapshot.dailyGoal.left} min to go`
                  : "Goal complete. Nice work."}
              </p>
            </div>
          </div>
          <div className="rounded-[22px] border border-nexus-border bg-nexus-surface p-5">
            <div className="mb-3 flex items-center gap-2">
              <Flame className="size-4 text-nexus-accent" />
              <p className="text-sm font-semibold text-foreground">
                <span className="tabular">{snapshot.streak}</span>-day streak
              </p>
            </div>
            <StreakHeatmap currentStreak={snapshot.streak} />
          </div>
        </div>
      </section>

      <MetricRow
        metrics={[
          { label: "Weekly goal", value: `${snapshot.weeklyGoal.percent}%`, detail: `${snapshot.weeklyGoal.left}m left` },
          { label: "Tasks", value: experience.badgeInput.dueTasks ?? 0, detail: "due today" },
          { label: "Mistakes", value: experience.badgeInput.mistakesToReview ?? 0, detail: "to review" },
          { label: "XP", value: experience.progress.totalXp, detail: `Level ${experience.level.level}` },
        ]}
      />

      <section className="grid gap-4 lg:grid-cols-2">
        <LinkedPanel
          href={snapshot.primaryAction.href}
          title={snapshot.primaryAction.title}
          description="Resume the most useful activity based on your study plan and recent progress."
          eyebrow="Continue learning"
          icon={Zap}
          tone="primary"
        />
        <LinkedPanel
          href="/weak-areas"
          title="Weak areas"
          description="Work through topics below 70% mastery before they stack up."
          eyebrow="Practice"
          icon={Target}
          count={experience.weakAreas.length}
          tone="accent"
        />
      </section>

      <section className="grid gap-4 sm:grid-cols-2 xl:grid-cols-3">
        <LinkedPanel href="/tasks" title="Tasks" description="Clear today's study plan." icon={ListChecks} count={experience.badgeInput.dueTasks ?? 0} />
        <LinkedPanel href="/saved" title="Saved questions" description="Revisit notes and questions." icon={BookMarked} count={experience.savedItems.length} />
        <LinkedPanel href="/mistakes" title="Mistake journal" description="Retry what went wrong." icon={BookMarked} count={experience.badgeInput.mistakesToReview ?? 0} />
        <LinkedPanel href="/readiness" title="Exam readiness" description="Check grade direction and mocks." icon={CalendarCheck} />
        <LinkedPanel href="/nex-memory" title="Learning memory" description="See how support is personalized." icon={Brain} />
        <LinkedPanel href="/offline" title="Offline packs" description="Prepare low-data study packs." icon={Download} count={experience.badgeInput.offlinePacksReady ?? 0} />
        <LinkedPanel href="/weekly-goal" title="Weekly goal" description="Set a parent-visible target." icon={CalendarCheck} />
        <LinkedPanel href="/focus" title="Focus sessions" description="Start a timed study block." icon={Clock3} count={experience.badgeInput.focusMinutesToday ? `${experience.badgeInput.focusMinutesToday}m` : 0} />
        <LinkedPanel href="/library" title="Concept library" description="Open formulas and concepts." icon={Library} />
      </section>

      {experience.recommendedTopic ? (
        <Link
          href={
            experience.recommendedTopic.topicId
              ? `/practice?topicId=${experience.recommendedTopic.topicId}`
              : "/practice"
          }
          className="flex items-center gap-4 rounded-[22px] border border-nexus-accent/40 bg-nexus-accent-soft p-5 transition-transform active:scale-[0.99]"
        >
          <span className="flex size-12 flex-none items-center justify-center rounded-2xl bg-nexus-accent text-nexus-text-primary">
            <Sparkles className="size-5" />
          </span>
          <span className="min-w-0 flex-1">
            <span className="block text-[11px] font-semibold uppercase tracking-wide text-nexus-warning">
              Suggested review
            </span>
            <span className="block font-heading text-lg font-medium text-foreground">
              {experience.recommendedTopic.title}
            </span>
          </span>
          <ArrowRight className="size-5 text-nexus-text-muted" />
        </Link>
      ) : null}
    </div>
  );
}
