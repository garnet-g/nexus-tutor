import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export async function getReadinessExamContext(
  studentId: string,
): Promise<{ activeExamPaperSessionId: string | null }> {
  const admin = createAdminClient();

  const { data: session } = await admin
    .from("exam_paper_sessions")
    .select("id")
    .eq("student_id", studentId)
    .eq("status", "in_progress")
    .order("started_at", { ascending: false })
    .limit(1)
    .maybeSingle();

  return {
    activeExamPaperSessionId: session?.id ? String(session.id) : null,
  };
}
