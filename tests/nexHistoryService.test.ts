import { describe, expect, it } from "vitest";

import {
  mapNexMessagesForChat,
  pickLatestActiveNexSession,
} from "@/server/services/nexHistoryMapping";

describe("nexHistoryService", () => {
  it("maps database messages into NexChatPanel initial messages", () => {
    const messages = mapNexMessagesForChat([
      {
        id: "student-1",
        role: "student",
        message_content: "Explain fractions",
      },
      {
        id: "nex-1",
        role: "nex",
        message_content: "A fraction is part of a whole.",
      },
    ]);

    expect(messages).toEqual([
      { id: "student-1", role: "student", content: "Explain fractions" },
      {
        id: "nex-1",
        role: "nex",
        content: "A fraction is part of a whole.",
      },
    ]);
  });

  it("prefers the latest active matching-topic session before generic sessions", () => {
    const session = pickLatestActiveNexSession(
      [
        {
          id: "older",
          topic_id: null,
          session_mode: "homework",
          metadata: {},
          started_at: "2026-06-21T10:00:00.000Z",
          is_active: true,
        },
        {
          id: "matching",
          topic_id: "topic-1",
          session_mode: "explain",
          metadata: {},
          started_at: "2026-06-21T09:00:00.000Z",
          is_active: true,
        },
        {
          id: "other",
          topic_id: "topic-2",
          session_mode: "practice",
          metadata: {},
          started_at: "2026-06-21T11:00:00.000Z",
          is_active: true,
        },
      ],
      "topic-1",
    );

    expect(session?.id).toBe("matching");
  });
});
