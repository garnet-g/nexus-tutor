import { redirect } from "next/navigation";

import { ExamPrepWizard } from "@/features/examPrep/components/ExamPrepWizard";
import { studentHasMockExamAccess } from "@/schemas/mockExamSchemas";
import { getSessionUser } from "@/server/services/authService";
import {
  getSubjectsForStudent,
  getTopics,
} from "@/server/services/curriculumService";
import { getStudentPlanCode } from "@/server/services/nexUsageService";

export default async function ExamPrepPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  const [allSubjects, planCode] = await Promise.all([
    getSubjectsForStudent(profile.curriculum, profile.grade_level),
    getStudentPlanCode(profile.id),
  ]);
  const subjects = allSubjects.filter((subject) => subject.code === "mathematics");
  const isUpperForm =
    profile.grade_level.toLowerCase().includes("form 3") ||
    profile.grade_level.toLowerCase().includes("form 4");

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
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground sm:text-3xl">
          Exam Prep
        </h1>
        <p className="text-sm text-muted-foreground sm:text-base">
          Build a KCSE-style math exam run from your current readiness and start
          a timed simulator in one flow.
        </p>
        {isUpperForm ? (
          <p className="inline-flex rounded-full border border-border px-3 py-1 text-xs font-medium text-foreground">
            {profile.grade_level} exam track
          </p>
        ) : null}
      </div>

      <ExamPrepWizard
        curriculum={profile.curriculum}
        gradeLevel={profile.grade_level}
        subjects={subjects}
        topicsBySubjectId={topicsBySubjectId}
        premiumAccess={studentHasMockExamAccess(planCode)}
      />
    </div>
  );
}
