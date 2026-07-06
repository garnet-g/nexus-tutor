import { Clock3 } from "lucide-react";

import {
  FocusSessionForm,
} from "@/features/student/components/StudentExperienceActions";
import { FocusSessionList } from "@/features/student/components/FocusSessionList";
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
          { label: "Today", value: `${experience.badgeInput.focusMinutesToday ?? 0}m`, detail: "credited focus" },
          { label: "Sessions", value: experience.focusSessions.length, detail: "recent records" },
          { label: "Streak", value: experience.progress.currentStreak, detail: "days active" },
          { label: "Goal left", value: `${experience.snapshot.dailyGoal.left}m`, detail: "today" },
        ]}
      />

      <FocusSessionForm />

      {experience.focusSessions.length > 0 ? (
        <FocusSessionList sessions={experience.focusSessions} />
      ) : (
        <EmptyStudentState
          title="No focus sessions yet"
          description="Start your first timed study block above."
        />
      )}
    </div>
  );
}
