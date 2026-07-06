import { BarChart3, Clock3, Target } from "lucide-react";

import { ReadinessExamCta } from "@/features/student/components/ReadinessExamCta";
import {
  EmptyStudentState,
  LinkedPanel,
  MetricRow,
  StudentPageHeader,
} from "@/features/student/components/StudentExperienceBlocks";
import { requireStudentExperience } from "@/features/student/server/requireStudentExperience";
import { getReadinessExamContext } from "@/server/services/readinessExamService";

export default async function ExamReadinessPage() {
  const experience = await requireStudentExperience();
  const latest = experience.recentMockResults[0];
  const examContext = await getReadinessExamContext(experience.profile.id);

  return (
    <div className="space-y-6 nexus-enter">
      <StudentPageHeader
        eyebrow="Exams"
        title="Exam readiness"
        description="A practical view of mock exam performance, current grade direction, and the topics most likely to lift your score."
        action={{ href: "/mock-exams", label: "Open mock exams" }}
      />

      <MetricRow
        metrics={[
          { label: "Health score", value: experience.progress.healthScore, detail: "latest academic score" },
          { label: "Predicted grade", value: experience.progress.predictedGrade ?? "N/A", detail: "from recent work" },
          { label: "Mock exams", value: experience.recentMockResults.length, detail: "recent results" },
          { label: "Weak topics", value: experience.weakAreas.length, detail: "below 70% mastery" },
        ]}
      />

      <div className="grid gap-4 lg:grid-cols-[1.2fr_0.8fr]">
        {latest ? (
          <LinkedPanel
            href="/mock-exams"
            title={`${latest.scorePercentage}% latest mock`}
            description={`Predicted grade ${latest.predictedGrade ?? "not available"} from the most recent result.`}
            eyebrow="Latest result"
            icon={BarChart3}
            tone="primary"
          />
        ) : (
          <EmptyStudentState
            title="No mock exam result yet"
            description="Complete a mock exam to see readiness, weak topics, and predicted grade movement here."
            href="/mock-exams"
            label="Take a mock exam"
          />
        )}

        <LinkedPanel
          href={experience.recommendedTopic?.topicId ? `/practice?topicId=${experience.recommendedTopic.topicId}` : "/practice"}
          title={experience.recommendedTopic?.title ?? "Start with practice"}
          description="The most useful topic to work on before your next mock."
          eyebrow="Score mover"
          icon={Target}
          tone="accent"
        />
      </div>

      <ReadinessExamCta
        planCode={experience.planCode}
        topicId={examContext.topicId ?? experience.recommendedTopic?.topicId ?? null}
        activeSimulatorSessionId={examContext.activeSimulatorSessionId}
        readyMockSessionId={examContext.readyMockSessionId}
      />

      <section className="grid gap-4 lg:grid-cols-2">
        <LinkedPanel
          href="/exam-prep"
          title="Exam prep"
          description="Build a guided exam plan from your current performance."
          icon={Clock3}
        />
        <LinkedPanel
          href="/mock-exams"
          title="Mock exams"
          description="Review generated papers and past results."
          icon={Clock3}
        />
      </section>
    </div>
  );
}
