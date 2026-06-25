import { CalendarCheck } from "lucide-react";

import { WeeklyGoalForm } from "@/features/student/components/StudentExperienceActions";
import {
  LinkedPanel,
  MetricRow,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";

export default async function WeeklyGoalPage() {
  const experience = await requireStudentExperience();
  const goal = experience.weeklyGoal;
  const weekly = experience.snapshot.weeklyGoal;

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Study"
        title="Weekly goal"
        description="Set a realistic weekly target and choose whether linked parents can see it."
      />

      <MetricRow
        metrics={[
          { label: "Target", value: `${weekly.minutes}m`, detail: "this week" },
          { label: "Done", value: `${weekly.completed}m`, detail: "study minutes" },
          { label: "Progress", value: `${weekly.percent}%`, detail: "toward goal" },
          { label: "Tasks", value: goal?.targetTasks ?? 5, detail: "weekly target" },
        ]}
      />

      <WeeklyGoalForm
        targetMinutes={goal?.targetMinutes ?? 120}
        targetTasks={goal?.targetTasks ?? 5}
        parentVisible={goal?.parentVisible ?? true}
        note={goal?.note}
      />

      <LinkedPanel
        href="/progress"
        title="Weekly progress summary"
        description="Review minutes, activity breakdown, health score, and weak topics."
        eyebrow="Progress"
        icon={CalendarCheck}
      />
    </div>
  );
}
