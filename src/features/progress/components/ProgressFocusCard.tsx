import Link from "next/link";
import { ArrowRight, Target } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";

interface ProgressFocusCardProps {
  focusTopicTitle: string | null;
  focusTopicId: string | null;
  focusMastery: number | null;
}

export function ProgressFocusCard({
  focusTopicTitle,
  focusTopicId,
  focusMastery,
}: ProgressFocusCardProps) {
  const practiceHref = focusTopicId
    ? `/practice?topicId=${focusTopicId}`
    : "/practice";
  const learnHref = focusTopicId ? `/learn/${focusTopicId}` : "/learn";

  return (
    <SectionCard
      className="border-nexus-primary/20 bg-nexus-primary-soft/30"
      title={
        focusTopicTitle
          ? `Focus on ${focusTopicTitle} this week`
          : "Build your first mastery milestone"
      }
      description={
        focusTopicTitle && focusMastery != null
          ? `${focusTopicTitle} is at ${focusMastery}% mastery — targeted practice lifts your health score fastest.`
          : "Complete a diagnostic or practice session to unlock personalized focus areas."
      }
    >
      <div className="flex flex-col gap-2 sm:flex-row sm:flex-wrap">
        <Button render={<Link href={practiceHref} />} className="min-h-12">
          <Target className="size-4" data-icon="inline-start" />
          {focusTopicTitle ? `Practice ${focusTopicTitle}` : "Start practice"}
        </Button>
        <Button
          variant="outline"
          render={<Link href={learnHref} />}
          className="min-h-12"
        >
          {focusTopicTitle ? `Review ${focusTopicTitle}` : "Browse Learn"}
        </Button>
        <Button
          variant="ghost"
          render={<Link href="/exam-prep" />}
          className="min-h-12"
        >
          Exam Prep
          <ArrowRight className="size-4" data-icon="inline-end" />
        </Button>
      </div>
    </SectionCard>
  );
}
