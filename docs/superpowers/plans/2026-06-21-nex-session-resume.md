# Nex Session Resume Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Resume the latest active Nex chat after refresh so students can continue context after their daily allowance resets.

**Architecture:** Keep `nex_sessions` and `nex_messages` as the source of truth. Server pages load the latest active session plus display messages and pass them to the existing client `NexChatPanel`; model context remains limited by existing route logic to recent turns.

**Tech Stack:** Next.js 16 App Router Server Components, React 19 Client Components, Supabase SSR client, Vitest.

---

### Task 1: Server-Side Nex History Loader

**Files:**
- Create: `src/server/services/nexHistoryService.ts`
- Test: `tests/nexHistoryService.test.ts`

- [ ] **Step 1: Write failing tests**

```ts
import { describe, expect, it } from "vitest";
import { mapNexMessagesForChat, pickLatestActiveNexSession } from "@/server/services/nexHistoryService";

describe("nexHistoryService", () => {
  it("maps database messages into NexChatPanel initial messages", () => {
    const messages = mapNexMessagesForChat([
      { id: "student-1", role: "student", message_content: "Explain fractions" },
      { id: "nex-1", role: "nex", message_content: "A fraction is part of a whole." },
    ]);
    expect(messages).toEqual([
      { id: "student-1", role: "student", content: "Explain fractions" },
      { id: "nex-1", role: "nex", content: "A fraction is part of a whole." },
    ]);
  });

  it("prefers the latest active matching-topic session before generic sessions", () => {
    const session = pickLatestActiveNexSession(
      [
        { id: "older", topic_id: null, started_at: "2026-06-21T10:00:00.000Z", is_active: true },
        { id: "matching", topic_id: "topic-1", started_at: "2026-06-21T09:00:00.000Z", is_active: true },
        { id: "other", topic_id: "topic-2", started_at: "2026-06-21T11:00:00.000Z", is_active: true },
      ],
      "topic-1",
    );
    expect(session?.id).toBe("matching");
  });
});
```

- [ ] **Step 2: Run red test**

Run: `npx vitest run tests/nexHistoryService.test.ts`
Expected: fail because `nexHistoryService` does not exist.

- [ ] **Step 3: Implement loader**

Create focused helpers:

```ts
export interface InitialNexChatMessage {
  id: string;
  role: "student" | "nex";
  content: string;
}

export function mapNexMessagesForChat(rows: NexMessageRow[]): InitialNexChatMessage[] { ... }
export function pickLatestActiveNexSession(rows: NexSessionRow[], topicId?: string | null): NexSessionRow | null { ... }
export async function loadLatestActiveNexChat(studentId: string, topicId?: string | null): Promise<InitialNexChatState> { ... }
```

The loader must query only the authenticated student's sessions, prefer matching `topicId`, then fallback to the latest active session, and load up to 50 display messages ordered ascending.

- [ ] **Step 4: Run green test**

Run: `npx vitest run tests/nexHistoryService.test.ts`
Expected: pass.

### Task 2: Hydrate Pages and Client Panel

**Files:**
- Modify: `src/app/(student)/nex/page.tsx`
- Modify: `src/app/(student)/assignment-help/page.tsx`
- Modify: `src/features/nex/components/NexChatPanel.tsx`
- Test: `tests/nex/NexChatPanel.test.tsx`

- [ ] **Step 1: Write failing client test**

```tsx
render(
  <NexChatPanel
    initialSessionId="00000000-0000-4000-8000-000000000001"
    initialMessages={[{ id: "m1", role: "student", content: "Explain fractions" }]}
    initialMode="explain"
    topicId={null}
    dailyUsage={0}
    dailyLimit={10}
    retryAfterSeconds={3600}
    planCode="free"
  />,
);
expect(screen.getByText("Explain fractions")).toBeInTheDocument();
expect(screen.getByRole("button", { name: /new chat/i })).toBeInTheDocument();
```

- [ ] **Step 2: Run red test**

Run: `npx vitest run tests/nex/NexChatPanel.test.tsx`
Expected: fail because `initialMessages` and New chat button are not implemented.

- [ ] **Step 3: Implement hydration**

Add `initialMessages?: ChatMessage[]` to `NexChatPanelProps`, initialize `messages` from it, pass latest chat state from `/nex` and `/assignment-help`, and keep `initialSessionId` as the session used for the next POST.

- [ ] **Step 4: Add New chat behavior**

Add a `New chat` button that clears `messages`, sets `sessionId` to `null`, clears errors/input, and preserves selected mode. Do not call an API; the next message creates a new `nex_sessions` row through the existing route.

- [ ] **Step 5: Run verification**

Run:

```bash
npx vitest run tests/nexHistoryService.test.ts tests/nex/NexChatPanel.test.tsx tests/nexSchemas.test.ts tests/nex/nexChatStream.test.ts
npx tsc --noEmit --pretty false
```

Expected: all commands pass.
