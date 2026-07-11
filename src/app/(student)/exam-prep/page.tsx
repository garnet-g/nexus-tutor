import { redirect } from "next/navigation";

import { ExamPaperPicker } from "@/features/examPapers/components/ExamPaperPicker";
import { getSessionUser } from "@/server/services/authService";

export default async function ExamPrepPage() {
  const sessionUser = await getSessionUser();
  const profile = sessionUser?.studentProfile;

  if (!profile) {
    redirect("/login");
  }

  if (!profile.has_completed_diagnostic) {
    redirect("/diagnostic");
  }

  return (
    <div className="space-y-6">
      <div className="space-y-2">
        <h1 className="text-2xl font-semibold tracking-tight text-foreground sm:text-3xl">
          Exam Prep
        </h1>
        <p className="text-sm text-muted-foreground sm:text-base">
          Sit a full KCSE-format Mathematics paper, generated freshly every time from your
          current syllabus scope. Pen and paper beside you, type your final answers here.
        </p>
      </div>

      {profile.curriculum === "KCSE" ? (
        <ExamPaperPicker gradeLevel={profile.grade_level} />
      ) : (
        <div className="rounded-2xl border border-nexus-border bg-nexus-surface p-6">
          <p className="text-lg font-semibold text-foreground">CBC exam prep is coming soon</p>
          <p className="mt-1 text-sm text-muted-foreground">
            We&apos;re building CBC-format papers next. In the meantime, use Practice and
            Revision to rehearse by strand.
          </p>
        </div>
      )}
    </div>
  );
}
