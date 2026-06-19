import Link from "next/link";
import { redirect } from "next/navigation";

import { LearnSubjectExplorer } from "@/features/learn/components/LearnSubjectExplorer";
import { getSessionUser } from "@/server/services/authService";
import {
  getSubjectsForStudent,
  getTopics,
} from "@/server/services/curriculumService";

export default async function LearnPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  const subjects = await getSubjectsForStudent(
    profile.curriculum,
    profile.grade_level,
  );
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

  return (
    <div className="space-y-8">
      <div className="space-y-2">
        <Link
          href="/dashboard"
          className="text-sm text-muted-foreground transition hover:text-foreground"
        >
          ← Back to dashboard
        </Link>
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          Learn
        </h1>
        <p className="text-muted-foreground">
          {profile.curriculum} subjects for {profile.grade_level} — Mathematics, Science, and English.
        </p>
      </div>

      <LearnSubjectExplorer subjects={subjects} topicsBySubjectId={topicsBySubjectId} />
    </div>
  );
}
