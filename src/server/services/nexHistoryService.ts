import "server-only";

import { createClient } from "@/lib/supabase/server";
import {
  isNexMode,
  mapNexMessagesForChat,
  pickLatestActiveNexSession,
  type InitialNexChatState,
  type NexMessageRow,
  type NexSessionRow,
} from "@/server/services/nexHistoryMapping";

const DISPLAY_MESSAGE_LIMIT = 50;
const SESSION_CANDIDATE_LIMIT = 10;

export async function loadLatestActiveNexChat(
  studentId: string,
  topicId?: string | null,
): Promise<InitialNexChatState> {
  const supabase = await createClient();

  const { data: sessions } = await supabase
    .from("nex_sessions")
    .select("id, topic_id, session_mode, metadata, started_at, is_active")
    .eq("student_id", studentId)
    .eq("is_active", true)
    .order("started_at", { ascending: false })
    .limit(SESSION_CANDIDATE_LIMIT);

  const session = pickLatestActiveNexSession(
    (sessions ?? []) as NexSessionRow[],
    topicId,
  );

  if (!session) {
    return {
      sessionId: null,
      mode: null,
      topicId: topicId ?? null,
      messages: [],
    };
  }

  const { data: messages } = await supabase
    .from("nex_messages")
    .select("id, role, message_content")
    .eq("student_id", studentId)
    .eq("nex_session_id", session.id)
    .order("created_at", { ascending: false })
    .limit(DISPLAY_MESSAGE_LIMIT);

  const orderedMessages = [...((messages ?? []) as NexMessageRow[])].reverse();

  return {
    sessionId: session.id,
    mode: isNexMode(session.session_mode) ? session.session_mode : null,
    topicId: session.topic_id ?? topicId ?? null,
    messages: mapNexMessagesForChat(orderedMessages),
  };
}
