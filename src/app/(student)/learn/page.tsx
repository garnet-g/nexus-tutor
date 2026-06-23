import { redirect } from "next/navigation";

import { LearnSubjectExplorer } from "@/features/learn/components/LearnSubjectExplorer";
import { getSessionUser } from "@/server/services/authService";
import {
  getSubjectsForStudent,
  getTopics,
} from "@/server/services/curriculumService";
import { getProgressSummary } from "@/server/services/practiceService";

export default async function LearnPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  const [subjects, progress] = await Promise.all([
    getSubjectsForStudent(profile.curriculum, profile.grade_level),
    getProgressSummary(profile.id).catch(() => null),
  ]);

  const topicsBySubjectId: Record<
    string,
    Awaited<ReturnType<typeof getTopics>>
  > = {};

  for (const subject of subjects) {
    topicsBySubjectId[subject.id] = await getTopics(
      subject.id,
      profile.curriculum,
      profile.grade_level,
    );
  }

  const topicMasteryById = Object.fromEntries(
    (progress?.topicMastery ?? []).map((entry) => [
      entry.topicId,
      entry.masteryPercentage,
    ]),
  );
  const readySubjectNames = subjects.map((subject) => subject.name);
  const subjectSummary =
    readySubjectNames.length > 0
      ? `${readySubjectNames.join(", ")} ready for guided lessons and mastery tracking.`
      : "Learning paths are being prepared for your profile.";

  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <h1 className="font-heading text-3xl font-semibold tracking-tight text-foreground">
          Learn
        </h1>
        <p className="text-muted-foreground">
          {profile.curriculum} · {profile.grade_level.replace("_", " ")} —{" "}
          {subjectSummary}
        </p>
      </div>

      <LearnSubjectExplorer
        subjects={subjects}
        topicsBySubjectId={topicsBySubjectId}
        topicMasteryById={topicMasteryById}
      />
    </div>
  );
}
