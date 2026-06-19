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

  const [subjects, planCode] = await Promise.all([
    getSubjectsForStudent(profile.curriculum, profile.grade_level),
    getStudentPlanCode(profile.id),
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

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground sm:text-3xl">
          Exam Prep
        </h1>
        <p className="text-sm text-muted-foreground sm:text-base">
          Generate personalized study materials and mock exams based on your
          curriculum.
        </p>
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
