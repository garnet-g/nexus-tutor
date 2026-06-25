import { Clock3 } from "lucide-react";

import {
  FocusSessionForm,
  FocusStatusButton,
} from "@/features/student/components/StudentExperienceActions";
import {
  EmptyStudentState,
  MetricRow,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function FocusSessionsPage() {
  const experience = await requireStudentExperience();

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Tools"
        title="Focus sessions"
        description="Start timed study blocks and turn them into daily study minutes."
      />

      <MetricRow
        metrics={[
          { label: "Today", value: `${experience.badgeInput.focusMinutesToday ?? 0}m`, detail: "completed focus" },
          { label: "Sessions", value: experience.focusSessions.length, detail: "recent records" },
          { label: "Streak", value: experience.progress.currentStreak, detail: "days active" },
          { label: "Goal left", value: `${experience.snapshot.dailyGoal.left}m`, detail: "today" },
        ]}
      />

      <FocusSessionForm />

      {experience.focusSessions.length > 0 ? (
        <section className="space-y-3">
          {experience.focusSessions.map((session) => (
            <article
              key={session.id}
              className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
            >
              <div className="flex items-start gap-3">
                <span className="flex size-10 flex-none items-center justify-center rounded-xl bg-nexus-sunken text-nexus-primary">
                  <Clock3 className="size-5" />
                </span>
                <div className="min-w-0 flex-1">
                  <p className="font-semibold text-foreground">
                    {session.subject || session.topicTitle || "Focus session"}
                  </p>
                  <p className="text-sm text-muted-foreground">
                    {session.durationMinutes} minutes - {session.status.replace("_", " ")}
                  </p>
                  <div className="mt-3 flex flex-wrap gap-2">
                    {session.status !== "completed" ? (
                      <FocusStatusButton id={session.id} status="completed" label="Mark complete" />
                    ) : null}
                    {session.status !== "cancelled" ? (
                      <FocusStatusButton id={session.id} status="cancelled" label="Cancel" />
                    ) : null}
                  </div>
                </div>
              </div>
            </article>
          ))}
        </section>
      ) : (
        <EmptyStudentState
          title="No focus sessions yet"
          description="Start your first timed study block above."
        />
      )}
    </div>
  );
}
