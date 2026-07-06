import "server-only";

import { createAdminClient } from "@/lib/supabase/admin";

export async function getReadinessExamContext(studentId: string) {
  const admin = createAdminClient();

  const [{ data: simulator }, { data: mockSession }] = await Promise.all([
    admin
      .from("exam_simulator_sessions")
      .select("id")
      .eq("student_id", studentId)
      .eq("session_status", "in_progress")
      .order("started_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
    admin
      .from("mock_exam_sessions")
      .select("id, topic_id")
      .eq("student_id", studentId)
      .in("session_status", ["ready", "in_progress"])
      .order("created_at", { ascending: false })
      .limit(1)
      .maybeSingle(),
  ]);

  return {
    activeSimulatorSessionId: simulator?.id ? String(simulator.id) : null,
    readyMockSessionId: mockSession?.id ? String(mockSession.id) : null,
    topicId: mockSession?.topic_id ? String(mockSession.topic_id) : null,
  };
}
