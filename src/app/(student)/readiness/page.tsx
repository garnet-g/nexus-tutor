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
        action={{ href: "/exam-prep", label: "Open exam prep" }}
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
            href="/exam-prep"
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
            href="/exam-prep"
            label="Start exam prep"
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

      {experience.recentMockResults.length > 0 ? (
        <section className="rounded-2xl border border-nexus-border bg-nexus-surface p-4">
          <p className="text-sm font-semibold uppercase tracking-wide text-muted-foreground">
            Recent KCSE-style mocks
          </p>
          <div className="mt-3 space-y-2">
            {experience.recentMockResults.map((result) => (
              <div
                key={result.id}
                className="flex items-center justify-between rounded-xl border border-nexus-border px-3 py-2 text-sm"
              >
                <span className="text-foreground">
                  {new Date(result.createdAt).toLocaleDateString()} · {result.scorePercentage}%
                </span>
                <span className="text-muted-foreground">
                  Grade {result.predictedGrade ?? "N/A"}
                </span>
              </div>
            ))}
          </div>
        </section>
      ) : null}

      <section className="grid gap-4 lg:grid-cols-2">
        <LinkedPanel
          href="/exam-prep"
          title="Exam prep"
          description="Build a guided exam plan from your current performance."
          icon={Clock3}
        />
        <LinkedPanel
          href="/exam-prep"
          title="Exam prep"
          description="Generate KCSE-style mocks and review your recent results."
          icon={Clock3}
        />
      </section>
    </div>
  );
}
