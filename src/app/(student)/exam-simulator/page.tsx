import { redirect } from "next/navigation";

import { Breadcrumbs } from "@/components/layout/breadcrumbs";
import { ExamSimulatorShell } from "@/features/mockExams/components/ExamSimulatorShell";
import { createAdminClient } from "@/lib/supabase/admin";
import { getSessionUser } from "@/server/services/authService";

interface ExamSimulatorPageProps {
  searchParams: Promise<{ sessionId?: string }>;
}

export default async function ExamSimulatorPage({
  searchParams,
}: ExamSimulatorPageProps) {
  const sessionUser = await getSessionUser();

  if (!sessionUser?.studentProfile) {
    redirect("/login");
  }

  const { sessionId } = await searchParams;

  if (!sessionId) {
    redirect("/exam-prep");
  }

  const admin = createAdminClient();

  const { data: simulator } = await admin
    .from("exam_simulator_sessions")
    .select("id, student_id, mock_exam_session_id, ends_at, session_status")
    .eq("id", sessionId)
    .eq("student_id", sessionUser.studentProfile.id)
    .maybeSingle();

  if (!simulator) {
    redirect("/exam-prep");
  }

  const [{ data: questions }, { data: examSession }] = await Promise.all([
    admin
      .from("mock_exam_questions")
      .select("id, question_text, question_type, options, difficulty, sort_order")
      .eq("mock_exam_session_id", simulator.mock_exam_session_id)
      .order("sort_order", { ascending: true }),
    admin
      .from("mock_exam_sessions")
      .select("exam_style, curriculum, question_count")
      .eq("id", simulator.mock_exam_session_id)
      .maybeSingle(),
  ]);

  if (!questions?.length) {
    redirect("/exam-prep");
  }

  return (
    <div className="space-y-6">
      <Breadcrumbs
        items={[
          { label: "Exam Prep", href: "/exam-prep" },
          { label: "Exam Simulator" },
        ]}
      />
      <ExamSimulatorShell
        simulatorSessionId={simulator.id}
        endsAt={simulator.ends_at}
        questions={questions}
        examMeta={{
          curriculum: examSession?.curriculum ?? sessionUser.studentProfile.curriculum,
          gradeLevel: sessionUser.studentProfile.grade_level,
          examStyle: examSession?.exam_style ?? "kcse_style",
          questionCount: examSession?.question_count ?? questions.length,
        }}
      />
    </div>
  );
}
