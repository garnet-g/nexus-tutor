import type { NexMode } from "@/lib/nex/types";

export interface InitialNexChatMessage {
  id: string;
  role: "student" | "nex";
  content: string;
}

export interface NexSessionRow {
  id: string;
  topic_id: string | null;
  session_mode: string;
  metadata: unknown;
  started_at: string;
  is_active: boolean;
}

export interface NexMessageRow {
  id: string;
  role: string;
  message_content: string;
}

export interface InitialNexChatState {
  sessionId: string | null;
  sessionStartedAt: string | null;
  mode: NexMode | null;
  topicId: string | null;
  topicTitle: string | null;
  messages: InitialNexChatMessage[];
}

function isNexRole(role: string): role is "student" | "nex" {
  return role === "student" || role === "nex";
}

export function isNexMode(value: string): value is NexMode {
  return (
    value === "explain" ||
    value === "practice" ||
    value === "homework" ||
    value === "revision" ||
    value === "assessment"
  );
}

export function mapNexMessagesForChat(
  rows: NexMessageRow[],
): InitialNexChatMessage[] {
  return rows
    .filter((row) => isNexRole(row.role) && row.message_content.trim().length > 0)
    .map((row) => ({
      id: row.id,
      role: row.role as "student" | "nex",
      content: row.message_content,
    }));
}

export function pickLatestActiveNexSession(
  rows: NexSessionRow[],
  topicId?: string | null,
): NexSessionRow | null {
  const activeRows = rows
    .filter((row) => row.is_active)
    .sort(
      (left, right) =>
        new Date(right.started_at).getTime() - new Date(left.started_at).getTime(),
    );

  if (topicId) {
    const matchingTopic = activeRows.find((row) => row.topic_id === topicId);
    if (matchingTopic) {
      return matchingTopic;
    }
  }

  return activeRows[0] ?? null;
}
