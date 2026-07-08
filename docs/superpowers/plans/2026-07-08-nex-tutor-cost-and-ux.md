# Nex Tutor Cost & UX Improvements Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Reduce Nex tutor LLM/TTS/vision spend (model tiering, prompt restructuring for caching, an explain-mode response cache, and client-side image downscaling) while adding four UX/interactivity improvements (dynamic follow-up chips, gamification wiring, voice response caching, and a misconception spaced-review loop) — without changing Nex's Socratic teaching behavior or safety validation.

**Architecture:** Eight independent, sequentially-committable task groups touching `src/lib/nex/*` (model call layer), `src/server/services/*` (new cache/review services), three existing Supabase migrations, and `src/features/nex/*` (chat UI). Each group ships and tests on its own; none blocks the others except Group 2 (native `contents` array), which Group 1 (model tiering) and Group 3 (cache) build on top of, so implement in the numbered order below.

**Tech Stack:** Next.js API routes, Supabase Postgres (raw `fetch` to Gemini/OpenAI REST APIs — no SDK), Vitest.

**Correction to the original cost analysis:** The prior discussion said "every response is validated by a judge call... up to 4 LLM calls per turn." Rereading `src/lib/nex/validateNexResponse.ts`, that's not accurate — `validateNexResponseWithJudge` runs a pure-regex check (`validateNexResponse`) on every turn for free, and only escalates to the real `callNexJudge` LLM call when the regex result is `"ambiguous"` **and** mode is `homework` **and** `attemptCount === 0`. That's a narrow tail case, not the common path. Cost item "2. skip the judge for low-risk modes" is folded into Group 1 below as "route the judge call to a cheaper model tier" instead, since it already only fires for homework — the real remaining waste was that it runs on the same full-price model as everything else.

---

## Group 1 — Model tiering: cheap model for the judge and for short low-stakes turns

*(Cost items 2 + 5 combined — the judge is a lite-model consumer, not a separate on/off switch.)*

**Files:**
- Modify: `src/lib/nex/modelConfig.ts`
- Create: `src/lib/nex/modelTiering.ts`
- Modify: `src/lib/nex/types.ts`
- Modify: `src/lib/nex/geminiClient.ts`
- Modify: `src/lib/nex/callNexModel.ts`
- Modify: `src/lib/nex/generateNexResponse.ts`
- Test: `tests/nex/modelConfig.test.ts` (extend), `tests/nex/modelTiering.test.ts` (new), `tests/nex/callNexModel.test.ts` (extend)

### Task 1.1: Add a lite-model config knob

- [ ] **Step 1: Write the failing test**

Append to `tests/nex/modelConfig.test.ts` (inside the existing `describe` block, after the second `it`):

```ts
  it("exposes a lite model tier separate from the standard text model", () => {
    expect(getGeminiTextModelForTier("standard")).toBe(getGeminiTextModel());
    expect(getGeminiTextModelForTier("lite")).toBe("gemini-3.5-flash-lite");
  });

  it("allows the lite model to be overridden by environment variable", () => {
    const previous = process.env.NEX_GEMINI_TEXT_MODEL_LITE;
    process.env.NEX_GEMINI_TEXT_MODEL_LITE = "gemini-flash-lite-latest";

    expect(getGeminiTextModelForTier("lite")).toBe("gemini-flash-lite-latest");

    restoreEnv("NEX_GEMINI_TEXT_MODEL_LITE", previous);
  });
```

Add `getGeminiTextModelForTier` to the import at the top of the file:

```ts
import {
  getGeminiTextModelForTier,
  getGeminiThinkingLevel,
  getGeminiTextModel,
  getGeminiTtsModel,
  getGeminiVisionModel,
  getNexModelMaxOutputTokens,
} from "@/lib/nex/modelConfig";
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/modelConfig.test.ts`
Expected: FAIL — `getGeminiTextModelForTier is not a function`

- [ ] **Step 3: Implement `getGeminiTextModelForTier`**

In `src/lib/nex/modelConfig.ts`, add a new constant after `DEFAULT_GEMINI_TEXT_MODEL` (line 1) and a new exported function after `getGeminiTextModel` (currently lines 12-14):

```ts
const DEFAULT_GEMINI_TEXT_MODEL_LITE = "gemini-3.5-flash-lite";
```

```ts
export type NexModelTier = "standard" | "lite";

export function getGeminiTextModelForTier(tier: NexModelTier): string {
  if (tier === "lite") {
    return getConfiguredModel(
      "NEX_GEMINI_TEXT_MODEL_LITE",
      DEFAULT_GEMINI_TEXT_MODEL_LITE,
    );
  }

  return getGeminiTextModel();
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/modelConfig.test.ts`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add src/lib/nex/modelConfig.ts tests/nex/modelConfig.test.ts
git commit -m "feat(nex): add lite Gemini model tier config"
```

### Task 1.2: Tier-selection heuristic

- [ ] **Step 1: Write the failing test**

Create `tests/nex/modelTiering.test.ts`:

```ts
import { describe, expect, it } from "vitest";

import { selectModelTier } from "@/lib/nex/modelTiering";

describe("selectModelTier", () => {
  it("uses the lite tier for short explain-mode turns", () => {
    expect(selectModelTier("explain", "What is a fraction?")).toBe("lite");
  });

  it("uses the lite tier for short revision-mode turns", () => {
    expect(selectModelTier("revision", "Summarise algebra basics")).toBe("lite");
  });

  it("uses the standard tier for homework mode regardless of length", () => {
    expect(selectModelTier("homework", "help")).toBe("standard");
  });

  it("uses the standard tier for practice mode regardless of length", () => {
    expect(selectModelTier("practice", "quiz me")).toBe("standard");
  });

  it("uses the standard tier for assessment mode regardless of length", () => {
    expect(selectModelTier("assessment", "start")).toBe("standard");
  });

  it("escalates explain mode to standard tier for long messages", () => {
    const longMessage = "Explain ".repeat(40);
    expect(selectModelTier("explain", longMessage)).toBe("standard");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/modelTiering.test.ts`
Expected: FAIL — Cannot find module `@/lib/nex/modelTiering`

- [ ] **Step 3: Implement `selectModelTier`**

Create `src/lib/nex/modelTiering.ts`:

```ts
import type { NexModelTier } from "./modelConfig";
import type { NexMode } from "./types";

const LITE_ELIGIBLE_MODES: ReadonlySet<NexMode> = new Set(["explain", "revision"]);
const LITE_MAX_MESSAGE_LENGTH = 220;

/**
 * Homework/practice/assessment always get the standard model — Socratic
 * guidance and misconception detection need the stronger model's reasoning.
 * Short explain/revision turns (definitions, "what is X") are routed to the
 * lite tier; anything long enough to need multi-step reasoning escalates.
 */
export function selectModelTier(mode: NexMode, studentMessage: string): NexModelTier {
  if (!LITE_ELIGIBLE_MODES.has(mode)) {
    return "standard";
  }

  return studentMessage.trim().length <= LITE_MAX_MESSAGE_LENGTH ? "lite" : "standard";
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/modelTiering.test.ts`
Expected: PASS (6 tests)

- [ ] **Step 5: Commit**

```bash
git add src/lib/nex/modelTiering.ts tests/nex/modelTiering.test.ts
git commit -m "feat(nex): add mode/length-based model tier heuristic"
```

### Task 1.3: Thread `modelOverride` through the call layer

- [ ] **Step 1: Write the failing test**

Append to `tests/nex/callNexModel.test.ts` (new `it` inside the existing `describe`):

```ts
  it("calls Gemini with an explicit model override when provided", async () => {
    process.env.GEMINI_API_KEY = "test-gemini-key";

    const fetchMock = vi.fn(async () =>
      Response.json({
        candidates: [{ content: { parts: [{ text: "Lite tier reply." }] } }],
      }),
    );
    vi.stubGlobal("fetch", fetchMock);

    await callNexModel({
      systemPrompt: "You are Nex.",
      messages: [{ role: "student", content: "What is a fraction?" }],
      modelOverride: "gemini-3.5-flash-lite",
    });

    const [url] = fetchMock.mock.calls[0] as unknown as [string];
    expect(url).toContain("/models/gemini-3.5-flash-lite:generateContent");
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: FAIL — URL contains the default model, not `gemini-3.5-flash-lite`

- [ ] **Step 3: Add `modelOverride` to the input type**

In `src/lib/nex/types.ts`, extend `NexModelCallInput` (lines 79-84):

```ts
export interface NexModelCallInput {
  systemPrompt: string;
  messages: NexMessageTurn[];
  maxTokens?: number;
  allowOpenAIFallback?: boolean;
  modelOverride?: string;
}
```

- [ ] **Step 4: Honor it in `callGemini`/`streamGemini`**

In `src/lib/nex/geminiClient.ts`, change the model resolution line in both `callGemini` (line 69) and `streamGemini` (line 131) from:

```ts
    const model = getGeminiTextModel();
```

to:

```ts
    const model = input.modelOverride ?? getGeminiTextModel();
```

(Do this in both functions — they currently duplicate this line.)

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: PASS (all prior tests + the new one)

- [ ] **Step 6: Commit**

```bash
git add src/lib/nex/types.ts src/lib/nex/geminiClient.ts tests/nex/callNexModel.test.ts
git commit -m "feat(nex): support explicit Gemini model override on model calls"
```

### Task 1.4: Route the judge to the lite tier

- [ ] **Step 1: Write the failing test**

Append to `tests/nex/callNexModel.test.ts`:

```ts
  it("routes the Gemini judge call to the lite model tier", async () => {
    process.env.GEMINI_API_KEY = "test-gemini-key";

    const fetchMock = vi.fn(async () =>
      Response.json({
        candidates: [
          {
            content: {
              parts: [{ text: '{"revealsFinalAnswer": false, "reason": "ok"}' }],
            },
          },
        ],
      }),
    );
    vi.stubGlobal("fetch", fetchMock);

    const { callNexJudge } = await import("@/lib/nex/callNexModel");
    await callNexJudge("Solve 3x + 5 = 20", "What operation is attached to x?");

    const [url] = fetchMock.mock.calls[0] as unknown as [string];
    expect(url).toContain("/models/gemini-3.5-flash-lite:generateContent");
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: FAIL — URL contains `gemini-3.5-flash`, not `gemini-3.5-flash-lite`

- [ ] **Step 3: Update `callNexJudge`**

In `src/lib/nex/callNexModel.ts`, change the import (line 21) from:

```ts
import { getGeminiTextModel, getGeminiThinkingLevel } from "./modelConfig";
```

to:

```ts
import { getGeminiTextModelForTier, getGeminiThinkingLevel } from "./modelConfig";
```

Then change line 176 inside `callNexJudge` from:

```ts
    const model = getGeminiTextModel();
```

to:

```ts
    const model = getGeminiTextModelForTier("lite");
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: PASS

- [ ] **Step 5: Commit**

```bash
git add src/lib/nex/callNexModel.ts tests/nex/callNexModel.test.ts
git commit -m "perf(nex): route judge validation calls to the lite Gemini tier"
```

### Task 1.5: Wire tier selection into `generateNexResponse`

- [ ] **Step 1: Write the failing test**

Create `tests/nex/generateNexResponseTiering.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const callNexModelMock = vi.fn(async () => ({ content: "CONCEPT\nA fraction is a part of a whole.", provider: "gemini" as const }));

vi.mock("@/lib/nex/callNexModel", () => ({
  callNexModel: callNexModelMock,
  streamNexModel: vi.fn(),
}));

vi.mock("@/lib/nex/loadStudentMemory", () => ({
  loadStudentMemory: vi.fn(async () => null),
}));

vi.mock("@/lib/nex/loadCurriculumContext", () => ({
  loadCurriculumContext: vi.fn(async () => null),
}));

describe("generateNexResponse model tiering", () => {
  beforeEach(() => {
    callNexModelMock.mockClear();
  });

  it("passes a lite modelOverride for a short explain-mode question", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      studentId: "student-1",
      studentMessage: "What is a fraction?",
      sessionMode: "explain",
      sessionMetadata: {
        hintLevel: 1,
        hintCount: 0,
        attemptCount: 0,
        misconceptionDetected: false,
      },
      recentMessages: [],
    });

    expect(callNexModelMock).toHaveBeenCalledWith(
      expect.objectContaining({ modelOverride: "gemini-3.5-flash-lite" }),
    );
  });

  it("does not set a lite override for homework mode", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      studentId: "student-1",
      studentMessage: "help me with this",
      sessionMode: "homework",
      sessionMetadata: {
        hintLevel: 1,
        hintCount: 0,
        attemptCount: 0,
        misconceptionDetected: false,
      },
      recentMessages: [],
    });

    expect(callNexModelMock).toHaveBeenCalledWith(
      expect.objectContaining({ modelOverride: undefined }),
    );
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/generateNexResponseTiering.test.ts`
Expected: FAIL — `modelOverride` is not present in the call args (both assertions fail on the first test; second currently passes trivially)

- [ ] **Step 3: Implement tier selection in the orchestrator**

In `src/lib/nex/generateNexResponse.ts`, add the import (after line 8):

```ts
import { selectModelTier } from "./modelTiering";
import { getGeminiTextModelForTier } from "./modelConfig";
```

Replace the `invokeModel` closure (lines 86-102) with a version that resolves and passes the tier:

```ts
  const tier = selectModelTier(sessionMode, input.studentMessage);
  const modelOverride =
    tier === "lite" ? getGeminiTextModelForTier("lite") : undefined;

  const invokeModel = async (
    systemPrompt: string,
    streamChunks: boolean,
  ) => {
    const modelInput = {
      systemPrompt,
      messages: recentMessages,
      modelOverride,
    };

    if (streamChunks && input.onChunk) {
      return streamNexModel(modelInput, (chunk) => {
        void input.onChunk?.(chunk);
      });
    }

    return callNexModel(modelInput);
  };
```

Note: the regenerate-retry call at line 133 (`const retryModel = await callNexModel({...})`) intentionally does **not** get `modelOverride` — leave it unset. `shouldRegenerate` can theoretically fire for any mode (the system-prompt-leak and response-length checks in `validateNexResponse.ts` apply regardless of mode, not just the homework/assessment ambiguous-turn path), so a retry always escalating to the standard model — even if the original call used the lite tier — is the correct, safer default. No code change needed here; this is already the behavior once `modelOverride` is simply omitted from the retry call.

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/generateNexResponseTiering.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 5: Run the full Nex test suite to check for regressions**

Run: `npx vitest run tests/nex`
Expected: PASS — no existing test asserts on the exact shape of the object passed to `callNexModel`/`streamNexModel` other than `systemPrompt`/`messages`, so adding `modelOverride: undefined` alongside them should not break anything. If any golden-conversation test does a strict deep-equal on the call args, update it to include `modelOverride: undefined`.

- [ ] **Step 6: Commit**

```bash
git add src/lib/nex/generateNexResponse.ts tests/nex/generateNexResponseTiering.test.ts
git commit -m "perf(nex): route short explain/revision turns to the lite Gemini tier"
```

---

## Group 2 — Native multi-turn `contents` + separate `systemInstruction`

*(Cost item 1. Gemini's automatic "implicit caching" discount only has a chance to apply when the same prefix is sent as a stable, separated block on repeat calls — today the whole prompt is one hand-built string, so there's no stable prefix for the API to recognize. This task is a correctness fix with a caching upside, not a guaranteed-savings feature; do not write a test asserting a price reduction, since that's not observable from this codebase.)*

**Files:**
- Modify: `src/lib/nex/geminiClient.ts`
- Test: `tests/nex/callNexModel.test.ts` (extend)

### Task 2.1: Build a proper `contents` array instead of one flattened string

- [ ] **Step 1: Write the failing test**

Append to `tests/nex/callNexModel.test.ts`:

```ts
  it("sends conversation turns as a native contents array with a separate systemInstruction", async () => {
    process.env.GEMINI_API_KEY = "test-gemini-key";

    const fetchMock = vi.fn(async () =>
      Response.json({
        candidates: [{ content: { parts: [{ text: "Reply." }] } }],
      }),
    );
    vi.stubGlobal("fetch", fetchMock);

    await callNexModel({
      systemPrompt: "You are Nex.",
      messages: [
        { role: "student", content: "Explain fractions." },
        { role: "nex", content: "A fraction is a part of a whole." },
        { role: "student", content: "Give me an example." },
      ],
    });

    const [, init] = fetchMock.mock.calls[0] as unknown as [string, RequestInit];
    const body = JSON.parse(String(init.body)) as {
      systemInstruction?: { parts?: Array<{ text?: string }> };
      contents?: Array<{ role?: string; parts?: Array<{ text?: string }> }>;
    };

    expect(body.systemInstruction?.parts?.[0]?.text).toBe("You are Nex.");
    expect(body.contents).toEqual([
      { role: "user", parts: [{ text: "Explain fractions." }] },
      { role: "model", parts: [{ text: "A fraction is a part of a whole." }] },
      { role: "user", parts: [{ text: "Give me an example." }] },
    ]);
  });
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: FAIL — `body.systemInstruction` is `undefined`, `body.contents` is a single flattened-text entry

- [ ] **Step 3: Implement `buildGeminiContents` and use it in both call paths**

In `src/lib/nex/geminiClient.ts`, add a new exported function right after `buildConversationText` (after line 22):

```ts
export interface GeminiContentPart {
  role: "user" | "model";
  parts: [{ text: string }];
}

export function buildGeminiContents(
  messages: NexModelCallInput["messages"],
): GeminiContentPart[] {
  return messages.map((message) => ({
    role: message.role === "student" ? "user" : "model",
    parts: [{ text: message.content }],
  }));
}
```

Then in `callGemini` (lines 57-107), replace the body-construction block. Change:

```ts
    const conversation = buildConversationText(input.messages);
    const prompt = `${input.systemPrompt}\n\nConversation so far:\n${conversation}\n\nNex:`;
    const model = input.modelOverride ?? getGeminiTextModel();

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          contents: [{ parts: [{ text: prompt }] }],
          generationConfig: {
```

to:

```ts
    const model = input.modelOverride ?? getGeminiTextModel();

    const response = await fetch(
      `https://generativelanguage.googleapis.com/v1beta/models/${model}:generateContent?key=${apiKey}`,
      {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          systemInstruction: { parts: [{ text: input.systemPrompt }] },
          contents: buildGeminiContents(input.messages),
          generationConfig: {
```

Apply the identical change to `streamGemini` (lines 116-150) — same replacement, same two lines removed (`conversation`/`prompt`), same `systemInstruction`+`contents` fields added to the request body. `buildConversationText` stays in the file (still used by `getMockNexResponse` for the mock-mode heuristic) — do not delete it.

Note: if `input.messages` is empty (shouldn't happen in practice since `generateNexResponse` always appends the current student turn, but guard anyway), `contents` will be `[]`, which Gemini rejects. Add a guard right after computing `model` in both functions:

```ts
    if (input.messages.length === 0) {
      throw new Error("Gemini request requires at least one conversation message");
    }
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/callNexModel.test.ts`
Expected: PASS (all tests, including the new one)

- [ ] **Step 5: Run the full Nex suite and the golden-conversation suite**

Run: `npx vitest run tests/nex`
Expected: PASS. If `tests/nex/goldenConversations.test.ts` or `tests/nex/nexChatStream.test.ts` mock `fetch` and assert on request body shape, update those fixtures to the new `systemInstruction`/`contents` shape the same way.

- [ ] **Step 6: Commit**

```bash
git add src/lib/nex/geminiClient.ts tests/nex/callNexModel.test.ts
git commit -m "refactor(nex): send Gemini requests as native multi-turn contents + systemInstruction"
```

---

## Group 3 — Explain-mode response cache

*(Cost item 3. Scoped to `explain` mode only — homework/practice/assessment responses are shaped by the specific problem and the student's live attempt state, and personalizing on `studentMemory` matters more there, so caching would either miss constantly or serve a stale, wrong-context answer. Explain-mode answers to "what is X" style questions are largely topic-driven and safe to reuse across students for a bounded TTL. This does reduce personalization slightly for cached explain answers — the cached response won't reflect the current student's specific weak topics — which is the deliberate tradeoff for the cost savings.)*

**Files:**
- Create: `supabase/migrations/20260709090000_nex_response_cache.sql`
- Create: `src/server/services/nexResponseCacheService.ts`
- Modify: `src/lib/nex/types.ts`
- Modify: `src/lib/nex/generateNexResponse.ts`
- Test: `tests/nex/nexResponseCacheService.test.ts`, `tests/nex/generateNexResponseCache.test.ts`

### Task 3.1: Migration

- [ ] **Step 1: Create the migration**

Create `supabase/migrations/20260709090000_nex_response_cache.sql`:

```sql
-- Explain-mode response cache: avoids re-generating answers to the same
-- topic + normalized question across students, bounded by a TTL checked in
-- application code (nexResponseCacheService.ts).

CREATE TABLE public.nex_response_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  cache_key TEXT NOT NULL UNIQUE,
  topic_id UUID REFERENCES public.topics(id) ON DELETE CASCADE,
  normalized_question TEXT NOT NULL,
  response_text TEXT NOT NULL,
  hit_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_hit_at TIMESTAMPTZ
);

CREATE INDEX idx_nex_response_cache_topic
  ON public.nex_response_cache(topic_id, created_at DESC);

ALTER TABLE public.nex_response_cache ENABLE ROW LEVEL SECURITY;

-- Service-role only: this is an internal cost-optimization cache, not
-- student-owned data, so no student RLS policy is needed.
CREATE POLICY nex_response_cache_service_role ON public.nex_response_cache
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
```

- [ ] **Step 2: Commit**

```bash
git add supabase/migrations/20260709090000_nex_response_cache.sql
git commit -m "feat(nex): add nex_response_cache table for explain-mode caching"
```

### Task 3.2: Cache service

- [ ] **Step 1: Write the failing test**

Create `tests/nex/nexResponseCacheService.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type Row = { cache_key: string; response_text: string; created_at: string };
const rows = new Map<string, Row>();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "nex_response_cache") {
        throw new Error(`unexpected table ${table}`);
      }

      return {
        select: () => ({
          eq: (_column: string, value: string) => ({
            maybeSingle: async () => ({ data: rows.get(value) ?? null, error: null }),
          }),
        }),
        upsert: (row: Row & Record<string, unknown>) => {
          rows.set(row.cache_key, {
            cache_key: row.cache_key,
            response_text: row.response_text,
            created_at: (row.created_at as string) ?? new Date().toISOString(),
          });
          return Promise.resolve({ data: null, error: null });
        },
        update: () => ({ eq: async () => ({ data: null, error: null }) }),
      };
    },
  })),
}));

describe("nexResponseCacheService", () => {
  beforeEach(() => {
    rows.clear();
    vi.resetModules();
  });

  it("builds a stable cache key from topic + normalized question text", async () => {
    const { buildCacheKey } = await import(
      "@/server/services/nexResponseCacheService"
    );

    const keyA = buildCacheKey("topic-1", "What is a Fraction?");
    const keyB = buildCacheKey("topic-1", "  what is a fraction?  ");
    const keyC = buildCacheKey("topic-1", "What is a percentage?");

    expect(keyA).toBe(keyB);
    expect(keyA).not.toBe(keyC);
  });

  it("returns null on a cache miss", async () => {
    const { getCachedExplainResponse } = await import(
      "@/server/services/nexResponseCacheService"
    );

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBeNull();
  });

  it("returns the cached response on a hit within the TTL", async () => {
    const { buildCacheKey, storeExplainResponse, getCachedExplainResponse } =
      await import("@/server/services/nexResponseCacheService");

    await storeExplainResponse("topic-1", "What is a fraction?", "A fraction is a part of a whole.");

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBe("A fraction is a part of a whole.");
    expect(buildCacheKey("topic-1", "What is a fraction?")).toBeTruthy();
  });

  it("treats entries older than the TTL as a miss", async () => {
    const { storeExplainResponse, getCachedExplainResponse, buildCacheKey } =
      await import("@/server/services/nexResponseCacheService");

    await storeExplainResponse("topic-1", "What is a fraction?", "Stale answer.");
    const key = buildCacheKey("topic-1", "What is a fraction?");
    rows.set(key, {
      cache_key: key,
      response_text: "Stale answer.",
      created_at: new Date(Date.now() - 31 * 24 * 60 * 60 * 1000).toISOString(),
    });

    const result = await getCachedExplainResponse("topic-1", "What is a fraction?");
    expect(result).toBeNull();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/nexResponseCacheService.test.ts`
Expected: FAIL — Cannot find module `@/server/services/nexResponseCacheService`

- [ ] **Step 3: Implement the service**

Create `src/server/services/nexResponseCacheService.ts`:

```ts
import "server-only";

import { createHash } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";

const CACHE_TTL_MS = 30 * 24 * 60 * 60 * 1000;

function normalizeQuestion(text: string): string {
  return text.trim().toLowerCase().replace(/\s+/g, " ");
}

export function buildCacheKey(topicId: string, studentMessage: string): string {
  const normalized = normalizeQuestion(studentMessage);
  return createHash("sha256").update(`${topicId}:${normalized}`).digest("hex");
}

export async function getCachedExplainResponse(
  topicId: string,
  studentMessage: string,
): Promise<string | null> {
  const cacheKey = buildCacheKey(topicId, studentMessage);
  const admin = createAdminClient();

  const { data } = await admin
    .from("nex_response_cache")
    .select("response_text, created_at")
    .eq("cache_key", cacheKey)
    .maybeSingle();

  if (!data) {
    return null;
  }

  const ageMs = Date.now() - new Date(data.created_at).getTime();
  if (ageMs > CACHE_TTL_MS) {
    return null;
  }

  await admin
    .from("nex_response_cache")
    .update({
      hit_count: 1,
      last_hit_at: new Date().toISOString(),
    })
    .eq("cache_key", cacheKey);

  return data.response_text;
}

export async function storeExplainResponse(
  topicId: string,
  studentMessage: string,
  responseText: string,
): Promise<void> {
  const cacheKey = buildCacheKey(topicId, studentMessage);
  const admin = createAdminClient();

  await admin.from("nex_response_cache").upsert(
    {
      cache_key: cacheKey,
      topic_id: topicId,
      normalized_question: normalizeQuestion(studentMessage),
      response_text: responseText,
      created_at: new Date().toISOString(),
      hit_count: 0,
    },
    { onConflict: "cache_key" },
  );
}
```

Note: the `update` call for `hit_count` is a fixed `1` rather than an increment because a plain Supabase `.update()` cannot express `hit_count = hit_count + 1` without an RPC — this is a cost-tracking metric only (not used for eviction logic), so an approximate "was hit at least once" signal is an acceptable simplification. If accurate hit counts matter later, add a small `increment_nex_cache_hit(cache_key)` SQL function.

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/nexResponseCacheService.test.ts`
Expected: PASS (4 tests)

- [ ] **Step 5: Commit**

```bash
git add src/server/services/nexResponseCacheService.ts tests/nex/nexResponseCacheService.test.ts
git commit -m "feat(nex): add explain-mode response cache service"
```

### Task 3.3: Wire the cache into `generateNexResponse`

- [ ] **Step 1: Write the failing test**

Create `tests/nex/generateNexResponseCache.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

const callNexModelMock = vi.fn(async () => ({ content: "CONCEPT\nFresh answer.", provider: "gemini" as const }));
const getCachedExplainResponseMock = vi.fn(async () => null as string | null);
const storeExplainResponseMock = vi.fn(async () => undefined);

vi.mock("@/lib/nex/callNexModel", () => ({
  callNexModel: callNexModelMock,
  streamNexModel: vi.fn(),
}));

vi.mock("@/lib/nex/loadStudentMemory", () => ({
  loadStudentMemory: vi.fn(async () => null),
}));

vi.mock("@/lib/nex/loadCurriculumContext", () => ({
  loadCurriculumContext: vi.fn(async () => null),
}));

vi.mock("@/server/services/nexResponseCacheService", () => ({
  getCachedExplainResponse: getCachedExplainResponseMock,
  storeExplainResponse: storeExplainResponseMock,
}));

const baseInput = {
  studentId: "student-1",
  sessionMode: "explain" as const,
  sessionMetadata: {
    hintLevel: 1 as const,
    hintCount: 0,
    attemptCount: 0,
    misconceptionDetected: false,
  },
  recentMessages: [],
  topicId: "topic-1",
};

describe("generateNexResponse explain-mode cache", () => {
  beforeEach(() => {
    callNexModelMock.mockClear();
    getCachedExplainResponseMock.mockClear();
    storeExplainResponseMock.mockClear();
  });

  it("returns the cached response without calling the model on a hit", async () => {
    getCachedExplainResponseMock.mockResolvedValueOnce("Cached: a fraction is a part of a whole.");

    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    const result = await generateNexResponse({
      ...baseInput,
      studentMessage: "What is a fraction?",
    });

    expect(result.response).toBe("Cached: a fraction is a part of a whole.");
    expect(result.provider).toBe("cache");
    expect(callNexModelMock).not.toHaveBeenCalled();
  });

  it("calls the model and stores the result on a cache miss", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      studentMessage: "What is a percentage?",
    });

    expect(callNexModelMock).toHaveBeenCalledTimes(1);
    expect(storeExplainResponseMock).toHaveBeenCalledWith(
      "topic-1",
      "What is a percentage?",
      "CONCEPT\nFresh answer.",
    );
  });

  it("does not check the cache for homework mode", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      sessionMode: "homework",
      studentMessage: "help me solve this",
    });

    expect(getCachedExplainResponseMock).not.toHaveBeenCalled();
  });

  it("does not check the cache when there is no topicId", async () => {
    const { generateNexResponse } = await import("@/lib/nex/generateNexResponse");

    await generateNexResponse({
      ...baseInput,
      topicId: undefined,
      studentMessage: "What is a fraction?",
    });

    expect(getCachedExplainResponseMock).not.toHaveBeenCalled();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/generateNexResponseCache.test.ts`
Expected: FAIL — `result.provider` is `"gemini"` not `"cache"`; `getCachedExplainResponseMock`/`storeExplainResponseMock` never called

- [ ] **Step 3: Add `"cache"` to the provider union**

In `src/lib/nex/types.ts`, update both `NexModelCallResult.provider` (line 88) and `GenerateNexResponseResult.provider` (line 120) from:

```ts
  provider: "gemini" | "openai" | "mock";
```

to:

```ts
  provider: "gemini" | "openai" | "mock" | "cache";
```

- [ ] **Step 4: Wire the cache check/store into the orchestrator**

In `src/lib/nex/generateNexResponse.ts`, add the import (after the `modelTiering`/`modelConfig` imports added in Task 1.5):

```ts
import {
  getCachedExplainResponse,
  storeExplainResponse,
} from "@/server/services/nexResponseCacheService";
```

Insert a cache check right after the `sessionMode`/`metadata` setup and before the `Promise.all` that loads memory/curriculum (i.e., right after line 42, before the `const [studentMemory, curriculumContext] = ...` block):

```ts
  if (sessionMode === "explain" && input.topicId) {
    const cached = await getCachedExplainResponse(input.topicId, input.studentMessage);
    if (cached) {
      return {
        response: cached,
        sessionMode,
        metadata,
        provider: "cache",
        validationPassed: true,
      };
    }
  }
```

Then, after the final `validationPassed` computation and before the `return` statement at the end of the function (after line 156, before line 158's `return`), store a successful explain-mode response for next time:

```ts
  if (sessionMode === "explain" && input.topicId && validationPassed) {
    void storeExplainResponse(input.topicId, input.studentMessage, response).catch(
      () => undefined,
    );
  }
```

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/nex/generateNexResponseCache.test.ts`
Expected: PASS (4 tests)

- [ ] **Step 6: Run the full Nex suite**

Run: `npx vitest run tests/nex`
Expected: PASS

- [ ] **Step 7: Commit**

```bash
git add src/lib/nex/types.ts src/lib/nex/generateNexResponse.ts tests/nex/generateNexResponseCache.test.ts
git commit -m "feat(nex): serve explain-mode answers from response cache when available"
```

### Task 3.4: Surface cache hits in the chat routes' response metadata

- [ ] **Step 1: Update chat route response shape**

In `src/app/api/nex/chat/route.ts`, both JSON success payloads already spread `provider: nexResult.provider` (line 481 for non-streaming, and the SSE `done` event at line 377). No route code change is required — `"cache"` now flows through automatically since the type union was widened. Confirm this by grepping:

```bash
grep -n "provider: nexResult.provider" src/app/api/nex/chat/route.ts src/app/api/nex/voice/route.ts
```

Expected: both routes already reference `nexResult.provider` directly (no hardcoded `"gemini" | "openai" | "mock"` narrowing), so nothing to change.

- [ ] **Step 2: Update the `nex_messages.metadata` insert to record cache hits distinctly (optional but useful for analytics)**

No code change needed — `metadata: { provider: nexResult.provider, ... }` (chat route line 344, voice route line 381) already persists `"cache"` as-is once the type change lands.

- [ ] **Step 3: Commit (docs only, if anything changed)**

If the grep in Step 1 shows no changes needed, skip the commit for this task — it was a verification step, not an implementation step.

---

## Group 4 — Client-side image downscaling before vision calls

*(Cost item 4.)*

**Files:**
- Modify: `src/features/nex/components/CameraCaptureButton.tsx`
- Create: `src/features/nex/lib/downscaleImage.ts`
- Test: `tests/nex/downscaleImage.test.ts`

### Task 4.1: Downscale helper

- [ ] **Step 1: Write the failing test**

Create `tests/nex/downscaleImage.test.ts`:

```ts
/**
 * @vitest-environment jsdom
 */
import { describe, expect, it, vi } from "vitest";

import { MAX_IMAGE_DIMENSION, downscaleImageFile } from "@/features/nex/lib/downscaleImage";

function mockCanvas(width: number, height: number) {
  const toBlob = vi.fn((callback: BlobCallback) => {
    callback(new Blob(["fake-jpeg-bytes"], { type: "image/jpeg" }));
  });

  const context = {
    drawImage: vi.fn(),
  } as unknown as CanvasRenderingContext2D;

  const canvas = {
    width,
    height,
    getContext: () => context,
    toBlob,
  } as unknown as HTMLCanvasElement;

  vi.spyOn(document, "createElement").mockImplementation((tag: string) => {
    if (tag === "canvas") {
      return canvas as unknown as HTMLElement;
    }
    return document.createElement(tag);
  });
}

describe("downscaleImageFile", () => {
  it("returns the original file unchanged when already within the max dimension", async () => {
    const smallFile = new File(["bytes"], "photo.jpg", { type: "image/jpeg" });

    vi.spyOn(globalThis, "createImageBitmap").mockResolvedValue({
      width: 800,
      height: 600,
      close: vi.fn(),
    } as unknown as ImageBitmap);

    const result = await downscaleImageFile(smallFile);
    expect(result).toBe(smallFile);

    vi.restoreAllMocks();
  });

  it("downscales an oversized image to the max dimension and returns a JPEG file", async () => {
    const largeFile = new File(["bytes"], "photo.png", { type: "image/png" });

    vi.spyOn(globalThis, "createImageBitmap").mockResolvedValue({
      width: 4000,
      height: 3000,
      close: vi.fn(),
    } as unknown as ImageBitmap);

    mockCanvas(MAX_IMAGE_DIMENSION, Math.round((3000 / 4000) * MAX_IMAGE_DIMENSION));

    const result = await downscaleImageFile(largeFile);

    expect(result).not.toBe(largeFile);
    expect(result.type).toBe("image/jpeg");
    expect(result.name).toBe("photo.jpg");

    vi.restoreAllMocks();
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/downscaleImage.test.ts`
Expected: FAIL — Cannot find module `@/features/nex/lib/downscaleImage`

- [ ] **Step 3: Implement the helper**

Create `src/features/nex/lib/downscaleImage.ts`:

```ts
export const MAX_IMAGE_DIMENSION = 1280;
const JPEG_QUALITY = 0.82;

/**
 * Downscales a captured photo client-side before it's sent to Gemini Vision.
 * Camera captures are often 3000px+ on the long edge; the vision model gets
 * no accuracy benefit above ~1280px for a worksheet photo, so this cuts the
 * upload size and vision-input tokens for free. Returns the original file
 * unchanged if it's already within bounds.
 */
export async function downscaleImageFile(file: File): Promise<File> {
  const bitmap = await createImageBitmap(file);
  const { width, height } = bitmap;

  if (width <= MAX_IMAGE_DIMENSION && height <= MAX_IMAGE_DIMENSION) {
    bitmap.close();
    return file;
  }

  const scale = MAX_IMAGE_DIMENSION / Math.max(width, height);
  const targetWidth = Math.round(width * scale);
  const targetHeight = Math.round(height * scale);

  const canvas = document.createElement("canvas");
  canvas.width = targetWidth;
  canvas.height = targetHeight;

  const context = canvas.getContext("2d");
  if (!context) {
    bitmap.close();
    return file;
  }

  context.drawImage(bitmap, 0, 0, targetWidth, targetHeight);
  bitmap.close();

  const blob = await new Promise<Blob | null>((resolve) => {
    canvas.toBlob(resolve, "image/jpeg", JPEG_QUALITY);
  });

  if (!blob) {
    return file;
  }

  const baseName = file.name.replace(/\.[^.]+$/, "");
  return new File([blob], `${baseName}.jpg`, { type: "image/jpeg" });
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/downscaleImage.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 5: Commit**

```bash
git add src/features/nex/lib/downscaleImage.ts tests/nex/downscaleImage.test.ts
git commit -m "feat(nex): add client-side image downscale helper"
```

### Task 4.2: Wire it into the camera capture flow

- [ ] **Step 1: Update `CameraCaptureButton.tsx`**

In `src/features/nex/components/CameraCaptureButton.tsx`, add the import (after line 10):

```ts
import { downscaleImageFile } from "@/features/nex/lib/downscaleImage";
```

In `handleFileChange` (lines 83-141), change:

```ts
    setIsUploading(true);

    try {
      const body = new FormData();
      body.append("image", file);
```

to:

```ts
    setIsUploading(true);

    try {
      const uploadFile = await downscaleImageFile(file).catch(() => file);

      const body = new FormData();
      body.append("image", uploadFile);
```

- [ ] **Step 2: Manual verification**

This is a client-side change with no server contract change (still posts a `File` under the `image` field to `/api/nex/camera`, which already accepts `image/jpeg,image/png,image/webp`). Verify manually per the project's `/verify` skill or by running the dev server and capturing a large photo, confirming the network request body is smaller than the original file and `extractedText` still comes back correctly.

- [ ] **Step 3: Commit**

```bash
git add src/features/nex/components/CameraCaptureButton.tsx
git commit -m "perf(nex): downscale captured photos before uploading for vision OCR"
```

---

## Group 5 — Dynamic, topic-aware follow-up chips

*(UX A. No extra LLM call — the third chip becomes topic-specific instead of generic, reusing data already available in the chat panel.)*

**Files:**
- Modify: `src/features/nex/lib/nexTutorPresentation.ts`
- Modify: `src/features/nex/components/NexFollowUpChips.tsx`
- Modify: `src/features/nex/components/NexChatPanel.tsx`
- Test: `tests/nex/nexTutorPresentation.test.ts` (extend if it exists, else create)

### Task 5.1: Topic-aware follow-up prompts

- [ ] **Step 1: Write the failing test**

Check whether `tests/nex/nexTutorPresentation.test.ts` already exists:

```bash
ls tests/nex/nexTutorPresentation.test.ts 2>/dev/null || echo "does not exist"
```

If it exists, append the `it` blocks below into its `describe("getFollowUpPromptsForMode")` block (create that `describe` if missing). If it does not exist, create the file with:

```ts
import { describe, expect, it } from "vitest";

import { getFollowUpPromptsForMode } from "@/features/nex/lib/nexTutorPresentation";

describe("getFollowUpPromptsForMode", () => {
  it("returns the static prompts when no topic title is given", () => {
    expect(getFollowUpPromptsForMode("explain")).toEqual([
      "Show another example",
      "Explain simpler",
      "Quiz me",
    ]);
  });

  it("replaces the last prompt with a topic-specific one when a topic title is given", () => {
    const prompts = getFollowUpPromptsForMode("explain", "Fractions");

    expect(prompts).toHaveLength(3);
    expect(prompts[0]).toBe("Show another example");
    expect(prompts[1]).toBe("Explain simpler");
    expect(prompts[2]).toBe("Quiz me on Fractions");
  });

  it("ignores a blank topic title", () => {
    expect(getFollowUpPromptsForMode("homework", "   ")).toEqual([
      "Give me a hint",
      "Check my step",
      "What should I try next?",
    ]);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/nexTutorPresentation.test.ts`
Expected: FAIL — `getFollowUpPromptsForMode` only accepts one argument today, second test's `prompts[2]` is `"Quiz me"` not `"Quiz me on Fractions"`

- [ ] **Step 3: Implement the topic-aware variant**

In `src/features/nex/lib/nexTutorPresentation.ts`, add a per-mode topic-templated suffix map right after `FOLLOW_UP_PROMPTS` (after line 30):

```ts
const TOPIC_FOLLOW_UP_TEMPLATES: Record<NexVisibleMode, string> = {
  explain: "Quiz me on {topic}",
  practice: "Another {topic} question",
  homework: "Show me a similar {topic} problem",
  revision: "Test my weak spots in {topic}",
};
```

Then change `getFollowUpPromptsForMode` (lines 100-102) from:

```ts
export function getFollowUpPromptsForMode(mode: NexVisibleMode): string[] {
  return FOLLOW_UP_PROMPTS[mode];
}
```

to:

```ts
export function getFollowUpPromptsForMode(
  mode: NexVisibleMode,
  topicTitle?: string | null,
): string[] {
  const base = FOLLOW_UP_PROMPTS[mode];
  const safeTopic = topicTitle?.trim();

  if (!safeTopic) {
    return base;
  }

  const topicPrompt = TOPIC_FOLLOW_UP_TEMPLATES[mode].replace("{topic}", safeTopic);
  return [base[0], base[1], topicPrompt];
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/nexTutorPresentation.test.ts`
Expected: PASS (3 tests, plus any pre-existing tests in the file)

- [ ] **Step 5: Commit**

```bash
git add src/features/nex/lib/nexTutorPresentation.ts tests/nex/nexTutorPresentation.test.ts
git commit -m "feat(nex): make the third follow-up chip topic-specific"
```

### Task 5.2: Thread `topicTitle` through the chip component and chat panel

- [ ] **Step 1: Update `NexFollowUpChips.tsx`**

In `src/features/nex/components/NexFollowUpChips.tsx`, add `topicTitle` to the props interface (lines 9-14):

```ts
interface NexFollowUpChipsProps {
  mode: NexVisibleMode;
  topicTitle?: string | null;
  onSelect: (prompt: string) => void;
  disabled?: boolean;
  className?: string;
}
```

Update the destructuring and the call site (lines 16-22):

```ts
export function NexFollowUpChips({
  mode,
  topicTitle,
  onSelect,
  disabled = false,
  className,
}: NexFollowUpChipsProps) {
  const prompts = getFollowUpPromptsForMode(mode, topicTitle);
```

- [ ] **Step 2: Pass `topicTitle` from `NexChatPanel.tsx`**

In `src/features/nex/components/NexChatPanel.tsx`, change line 380 from:

```tsx
                  <NexFollowUpChips mode={sessionMode} onSelect={handleFollowUp} />
```

to:

```tsx
                  <NexFollowUpChips
                    mode={sessionMode}
                    topicTitle={topicTitle}
                    onSelect={handleFollowUp}
                  />
```

(`topicTitle` is already a prop on `NexChatPanel` at line 47/64, already in scope at this call site — same variable used at line 340 for `NexChatEmptyState`.)

- [ ] **Step 3: Typecheck**

Run: `npx tsc --noEmit -p tsconfig.json`
Expected: no new errors

- [ ] **Step 4: Manual verification**

Start the dev server, open a Nex explain-mode chat on a topic page, send a message, and confirm the third follow-up chip reads "Quiz me on {topic name}" instead of the generic "Quiz me".

- [ ] **Step 5: Commit**

```bash
git add src/features/nex/components/NexFollowUpChips.tsx src/features/nex/components/NexChatPanel.tsx
git commit -m "feat(nex): pass topic title into follow-up chips"
```

---

## Group 6 — Gamification wiring for Nex exchanges

*(UX B. `awardStudyActivity` already exists and already accepts `activityType: "nex"` — it has just never been called from the three Nex routes. Awarded once per session, not per message: `awardStudyActivity` credits at least 1 minute toward the daily goal on every call regardless of `durationSeconds` — calling it on every chat turn would inflate a student's daily-goal progress by N minutes for an N-message conversation. Firing it once when a new `nex_sessions` row is created keeps the signal honest.)*

**Files:**
- Modify: `src/app/api/nex/chat/route.ts`
- Modify: `src/app/api/nex/voice/route.ts`
- Modify: `src/app/api/nex/camera/route.ts`
- Test: `tests/nex/nexGamificationWiring.test.ts`

### Task 6.1: Award XP/streak credit on new Nex session creation

- [ ] **Step 1: Write the failing test**

Create `tests/nex/nexGamificationWiring.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";

const root = process.cwd();

describe("Nex routes award gamification credit on new session creation", () => {
  it("chat route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "chat", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toMatch(/sessionId = createdSession\.id;[\s\S]{0,400}awardStudyActivity/);
  });

  it("voice route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "voice", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toMatch(/sessionId = createdSession\.id;[\s\S]{0,400}awardStudyActivity/);
  });

  it("camera route calls awardStudyActivity only in the new-session branch", () => {
    const source = readFileSync(
      join(root, "src", "app", "api", "nex", "camera", "route.ts"),
      "utf8",
    );

    expect(source).toContain('import { awardStudyActivity } from "@/server/services/studyActivityService"');
    expect(source).toContain("awardStudyActivity");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/nexGamificationWiring.test.ts`
Expected: FAIL — none of the three routes import or call `awardStudyActivity`

- [ ] **Step 3: Wire it into the chat route**

In `src/app/api/nex/chat/route.ts`, add the import (after line 26):

```ts
import { awardStudyActivity } from "@/server/services/studyActivityService";
```

Add a small constant near the top of the file (after `NEX_CHAT_BURST_PER_MINUTE`, line 35):

```ts
const NEX_SESSION_XP = 5;
```

In the "create new session" branch (lines 202-229), immediately after `sessionId = createdSession.id;` (line 228), add:

```ts
      void awardStudyActivity({
        studentId: studentProfile.id,
        activityType: "nex",
        activityId: sessionId,
        durationSeconds: 0,
        xpEarned: NEX_SESSION_XP,
      }).catch(() => undefined);
```

- [ ] **Step 4: Wire it into the voice route**

In `src/app/api/nex/voice/route.ts`, add the same import (after line 33) and the same constant (after the imports, before `export async function POST`):

```ts
import { awardStudyActivity } from "@/server/services/studyActivityService";

const NEX_SESSION_XP = 5;
```

In the "create new session" branch (lines 291-314), after `sessionId = createdSession.id;` (line 313), add:

```ts
      void awardStudyActivity({
        studentId: studentProfile.id,
        activityType: "nex",
        activityId: sessionId,
        durationSeconds: 0,
        xpEarned: NEX_SESSION_XP,
      }).catch(() => undefined);
```

- [ ] **Step 5: Wire it into the camera route**

In `src/app/api/nex/camera/route.ts`, add the same import (after line 44) and the same constant (after the imports, before `const SIGNED_URL_TTL_SECONDS = 3600;` on line 46):

```ts
import { awardStudyActivity } from "@/server/services/studyActivityService";

const NEX_SESSION_XP = 5;
```

In the "create new session" branch (lines 301-325), after `sessionId = createdSession.id;` (line 324), add:

```ts
      void awardStudyActivity({
        studentId: studentProfile.id,
        activityType: "nex",
        activityId: sessionId,
        durationSeconds: 0,
        xpEarned: NEX_SESSION_XP,
      }).catch(() => undefined);
```

- [ ] **Step 6: Run test to verify it passes**

Run: `npx vitest run tests/nex/nexGamificationWiring.test.ts`
Expected: PASS (3 tests)

- [ ] **Step 7: Run the full Nex API route test suite**

Run: `npx vitest run tests/nex tests/api`
Expected: PASS — `awardStudyActivity` is fire-and-forget (`void ... .catch(() => undefined)`), so it cannot fail a request even if the underlying tables are unmocked in existing route tests.

- [ ] **Step 8: Commit**

```bash
git add src/app/api/nex/chat/route.ts src/app/api/nex/voice/route.ts src/app/api/nex/camera/route.ts tests/nex/nexGamificationWiring.test.ts
git commit -m "feat(nex): award XP and streak credit when a student starts a Nex session"
```

---

## Group 7 — Voice response caching by content hash

*(UX C. Caches synthesized audio for identical Nex response text, so repeating the same explanation twice — a common tutoring pattern ("say that again") — doesn't re-cost a TTS call. Uses Supabase Storage, following the same pattern as the existing `nex-uploads` and `past-paper-answer-photos` private buckets.)*

**Files:**
- Create: `supabase/migrations/20260709091000_nex_voice_cache.sql`
- Create: `src/server/services/nexVoiceCacheService.ts`
- Modify: `src/app/api/nex/voice/route.ts`
- Test: `tests/nex/nexVoiceCacheService.test.ts`

### Task 7.1: Migration

- [ ] **Step 1: Create the migration**

Create `supabase/migrations/20260709091000_nex_voice_cache.sql`:

```sql
-- Voice response cache: reuses previously synthesized TTS audio for
-- identical Nex response text instead of re-calling the TTS provider.

INSERT INTO storage.buckets (id, name, public)
VALUES ('nex-voice-cache', 'nex-voice-cache', false)
ON CONFLICT (id) DO NOTHING;

CREATE POLICY nex_voice_cache_service_only ON storage.objects FOR ALL
  USING (bucket_id = 'nex-voice-cache' AND auth.role() = 'service_role')
  WITH CHECK (bucket_id = 'nex-voice-cache' AND auth.role() = 'service_role');

CREATE TABLE public.nex_voice_cache (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  content_hash TEXT NOT NULL UNIQUE,
  storage_path TEXT NOT NULL,
  mime_type TEXT NOT NULL,
  provider TEXT NOT NULL,
  hit_count INTEGER NOT NULL DEFAULT 0,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  last_hit_at TIMESTAMPTZ
);

ALTER TABLE public.nex_voice_cache ENABLE ROW LEVEL SECURITY;

CREATE POLICY nex_voice_cache_service_role ON public.nex_voice_cache
  FOR ALL
  USING (auth.role() = 'service_role')
  WITH CHECK (auth.role() = 'service_role');
```

- [ ] **Step 2: Commit**

```bash
git add supabase/migrations/20260709091000_nex_voice_cache.sql
git commit -m "feat(nex): add nex_voice_cache table and storage bucket"
```

### Task 7.2: Voice cache service

- [ ] **Step 1: Write the failing test**

Create `tests/nex/nexVoiceCacheService.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { beforeEach, describe, expect, it, vi } from "vitest";

type CacheRow = { content_hash: string; storage_path: string; mime_type: string };
const rows = new Map<string, CacheRow>();
const storedObjects = new Map<string, Uint8Array>();

vi.mock("@/lib/supabase/admin", () => ({
  createAdminClient: vi.fn(() => ({
    from: (table: string) => {
      if (table !== "nex_voice_cache") {
        throw new Error(`unexpected table ${table}`);
      }
      return {
        select: () => ({
          eq: (_column: string, value: string) => ({
            maybeSingle: async () => ({ data: rows.get(value) ?? null, error: null }),
          }),
        }),
        upsert: (row: CacheRow & Record<string, unknown>) => {
          rows.set(row.content_hash, {
            content_hash: row.content_hash,
            storage_path: row.storage_path as string,
            mime_type: row.mime_type as string,
          });
          return Promise.resolve({ data: null, error: null });
        },
        update: () => ({ eq: async () => ({ data: null, error: null }) }),
      };
    },
    storage: {
      from: () => ({
        upload: async (path: string, bytes: Uint8Array) => {
          storedObjects.set(path, bytes);
          return { data: { path }, error: null };
        },
        download: async (path: string) => {
          const bytes = storedObjects.get(path);
          if (!bytes) {
            return { data: null, error: { message: "not found" } };
          }
          return { data: new Blob([bytes]), error: null };
        },
      }),
    },
  })),
}));

describe("nexVoiceCacheService", () => {
  beforeEach(() => {
    rows.clear();
    storedObjects.clear();
    vi.resetModules();
  });

  it("produces the same hash for identical text + provider and a different hash otherwise", async () => {
    const { hashVoiceContent } = await import("@/server/services/nexVoiceCacheService");

    const hashA = hashVoiceContent("A fraction is a part of a whole.", "gemini");
    const hashB = hashVoiceContent("A fraction is a part of a whole.", "gemini");
    const hashC = hashVoiceContent("A fraction is a part of a whole.", "openai");

    expect(hashA).toBe(hashB);
    expect(hashA).not.toBe(hashC);
  });

  it("returns null on a cache miss", async () => {
    const { getCachedVoice } = await import("@/server/services/nexVoiceCacheService");
    const result = await getCachedVoice("nonexistent-hash");
    expect(result).toBeNull();
  });

  it("stores and retrieves cached audio bytes", async () => {
    const { hashVoiceContent, storeCachedVoice, getCachedVoice } = await import(
      "@/server/services/nexVoiceCacheService"
    );

    const hash = hashVoiceContent("Hello student.", "gemini");
    const audioBytes = new Uint8Array([1, 2, 3, 4]);

    await storeCachedVoice(hash, audioBytes, "audio/wav", "gemini");
    const cached = await getCachedVoice(hash);

    expect(cached).not.toBeNull();
    expect(cached?.mimeType).toBe("audio/wav");
    expect(Array.from(cached?.audioBytes ?? [])).toEqual([1, 2, 3, 4]);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/nexVoiceCacheService.test.ts`
Expected: FAIL — Cannot find module `@/server/services/nexVoiceCacheService`

- [ ] **Step 3: Implement the service**

Create `src/server/services/nexVoiceCacheService.ts`:

```ts
import "server-only";

import { createHash } from "node:crypto";

import { createAdminClient } from "@/lib/supabase/admin";

export const NEX_VOICE_CACHE_BUCKET = "nex-voice-cache";

export function hashVoiceContent(text: string, provider: string): string {
  return createHash("sha256").update(`${provider}:${text.trim()}`).digest("hex");
}

export interface CachedVoice {
  audioBytes: Uint8Array;
  mimeType: string;
}

export async function getCachedVoice(contentHash: string): Promise<CachedVoice | null> {
  const admin = createAdminClient();

  const { data: row } = await admin
    .from("nex_voice_cache")
    .select("storage_path, mime_type")
    .eq("content_hash", contentHash)
    .maybeSingle();

  if (!row) {
    return null;
  }

  const { data: blob, error } = await admin.storage
    .from(NEX_VOICE_CACHE_BUCKET)
    .download(row.storage_path);

  if (error || !blob) {
    return null;
  }

  const audioBytes = new Uint8Array(await blob.arrayBuffer());

  await admin
    .from("nex_voice_cache")
    .update({ hit_count: 1, last_hit_at: new Date().toISOString() })
    .eq("content_hash", contentHash);

  return { audioBytes, mimeType: row.mime_type };
}

export async function storeCachedVoice(
  contentHash: string,
  audioBytes: Uint8Array,
  mimeType: string,
  provider: string,
): Promise<void> {
  const admin = createAdminClient();
  const storagePath = `${contentHash}.bin`;

  const { error: uploadError } = await admin.storage
    .from(NEX_VOICE_CACHE_BUCKET)
    .upload(storagePath, audioBytes, { contentType: mimeType, upsert: true });

  if (uploadError) {
    return;
  }

  await admin.from("nex_voice_cache").upsert(
    {
      content_hash: contentHash,
      storage_path: storagePath,
      mime_type: mimeType,
      provider,
      hit_count: 0,
    },
    { onConflict: "content_hash" },
  );
}
```

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/nexVoiceCacheService.test.ts`
Expected: PASS (3 tests)

- [ ] **Step 5: Commit**

```bash
git add src/server/services/nexVoiceCacheService.ts tests/nex/nexVoiceCacheService.test.ts
git commit -m "feat(nex): add voice response cache service"
```

### Task 7.3: Wire the cache into the voice route

- [ ] **Step 1: Write the failing test**

Create `tests/nex/voiceRouteCacheWiring.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { describe, expect, it } from "vitest";
import { readFileSync } from "node:fs";
import { join } from "node:path";

describe("voice route uses the voice cache before calling synthesizeVoiceResponse", () => {
  it("checks getCachedVoice before synthesis and stores the result on a miss", () => {
    const source = readFileSync(
      join(process.cwd(), "src", "app", "api", "nex", "voice", "route.ts"),
      "utf8",
    );

    expect(source).toContain(
      'import { getCachedVoice, hashVoiceContent, storeCachedVoice } from "@/server/services/nexVoiceCacheService"',
    );
    expect(source).toContain("getCachedVoice(");
    expect(source).toContain("storeCachedVoice(");

    const cacheCheckIndex = source.indexOf("getCachedVoice(");
    const synthesizeIndex = source.indexOf("synthesizeVoiceResponse({");
    expect(cacheCheckIndex).toBeGreaterThan(0);
    expect(cacheCheckIndex).toBeLessThan(synthesizeIndex);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/voiceRouteCacheWiring.test.ts`
Expected: FAIL — voice route does not import or call the cache service

- [ ] **Step 3: Wire it in**

In `src/app/api/nex/voice/route.ts`, add the import (after line 16):

```ts
import {
  getCachedVoice,
  hashVoiceContent,
  storeCachedVoice,
} from "@/server/services/nexVoiceCacheService";
```

Replace the single line at 370:

```ts
    const speech = await synthesizeVoiceResponse({ text: nexResult.response });
```

with:

```ts
    const cacheProvider = nexResult.provider === "cache" ? "gemini" : nexResult.provider;
    const voiceHash = hashVoiceContent(nexResult.response, cacheProvider);
    const cachedVoice = await getCachedVoice(voiceHash);

    const speech = cachedVoice
      ? {
          audioBase64: Buffer.from(cachedVoice.audioBytes).toString("base64"),
          mimeType: cachedVoice.mimeType,
          provider: cacheProvider as "gemini" | "openai" | "mock",
        }
      : await synthesizeVoiceResponse({ text: nexResult.response });

    if (!cachedVoice) {
      void storeCachedVoice(
        voiceHash,
        Buffer.from(speech.audioBase64, "base64"),
        speech.mimeType,
        speech.provider,
      ).catch(() => undefined);
    }
```

Note: `nexResult.provider` can now be `"cache"` (from Group 3) — since that's a text-cache provider label, not a voice-synthesis provider, it's mapped to `"gemini"` for the voice-cache hash key so text served from the explain-mode cache still gets a stable, reusable voice hash instead of colliding on a nonsensical `"cache"` TTS provider bucket.

- [ ] **Step 4: Run test to verify it passes**

Run: `npx vitest run tests/nex/voiceRouteCacheWiring.test.ts`
Expected: PASS

- [ ] **Step 5: Run the full Nex suite**

Run: `npx vitest run tests/nex`
Expected: PASS

- [ ] **Step 6: Commit**

```bash
git add src/app/api/nex/voice/route.ts tests/nex/voiceRouteCacheWiring.test.ts
git commit -m "feat(nex): serve cached audio for repeated Nex responses"
```

---

## Group 8 — Misconception spaced-review loop

*(UX D. Misconceptions are currently detected and appended to `student_profiles.metadata.commonErrors` — a flat string list with no scheduling, no topic linkage, and no resolution tracking. This adds a proper reviewable-item table and a lightweight spaced-repetition schedule (2, 4, 7, 14 days), plus a dismissible banner that prompts the student to revisit a specific past mistake.)*

**Files:**
- Create: `supabase/migrations/20260709092000_nex_misconception_reviews.sql`
- Modify: `src/server/services/misconceptionService.ts`
- Create: `src/app/api/nex/reviews/due/route.ts`
- Create: `src/app/api/nex/reviews/[id]/resolve/route.ts`
- Create: `src/features/nex/components/NexReviewBanner.tsx`
- Test: `tests/nex/misconceptionReviewSchedule.test.ts`, `tests/nex/misconceptionReviewRoutes.test.ts`

### Task 8.1: Migration

- [ ] **Step 1: Create the migration**

Create `supabase/migrations/20260709092000_nex_misconception_reviews.sql`:

```sql
-- Spaced-repetition schedule for misconceptions detected in Nex homework
-- and assessment sessions. Complements the flat commonErrors list already
-- stored on student_profiles.metadata (kept as-is for prompt context).

CREATE TABLE public.nex_misconception_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  error_code TEXT NOT NULL,
  description TEXT NOT NULL,
  review_count INTEGER NOT NULL DEFAULT 0,
  next_review_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '2 days'),
  last_reviewed_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, error_code)
);

CREATE INDEX idx_nex_misconception_reviews_due
  ON public.nex_misconception_reviews(student_id, next_review_at)
  WHERE resolved_at IS NULL;

ALTER TABLE public.nex_misconception_reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY nex_misconception_reviews_student ON public.nex_misconception_reviews FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());
```

- [ ] **Step 2: Commit**

```bash
git add supabase/migrations/20260709092000_nex_misconception_reviews.sql
git commit -m "feat(nex): add nex_misconception_reviews table"
```

### Task 8.2: Spaced-review scheduling logic + persistence hook

- [ ] **Step 1: Write the failing test**

Create `tests/nex/misconceptionReviewSchedule.test.ts`:

```ts
import { describe, expect, it } from "vitest";

import { nextReviewIntervalDays } from "@/server/services/misconceptionService";

describe("nextReviewIntervalDays", () => {
  it("follows a 2, 4, 7, 14-day spaced schedule and holds at 14 after that", () => {
    expect(nextReviewIntervalDays(0)).toBe(2);
    expect(nextReviewIntervalDays(1)).toBe(4);
    expect(nextReviewIntervalDays(2)).toBe(7);
    expect(nextReviewIntervalDays(3)).toBe(14);
    expect(nextReviewIntervalDays(4)).toBe(14);
    expect(nextReviewIntervalDays(10)).toBe(14);
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/misconceptionReviewSchedule.test.ts`
Expected: FAIL — `nextReviewIntervalDays` is not exported from `misconceptionService.ts`

- [ ] **Step 3: Implement the schedule function and wire it into `persistStudentMisconception`**

In `src/server/services/misconceptionService.ts`, add near the top (after the imports, before `resolveMisconceptionFromMessage`):

```ts
const REVIEW_INTERVALS_DAYS = [2, 4, 7, 14];

export function nextReviewIntervalDays(reviewCount: number): number {
  const index = Math.min(reviewCount, REVIEW_INTERVALS_DAYS.length - 1);
  return REVIEW_INTERVALS_DAYS[index];
}
```

Then change the signature of `persistStudentMisconception` (lines 32-36) to accept an optional `topicId`, and add the review-row upsert after the existing `student_profiles` update. Replace the whole function:

```ts
export async function persistStudentMisconception(
  studentId: string,
  errorCode: string,
  description: string,
  topicId: string | null = null,
): Promise<void> {
  const admin = createAdminClient();

  const { data: profile } = await admin
    .from("student_profiles")
    .select("metadata")
    .eq("id", studentId)
    .maybeSingle();

  const metadata =
    profile?.metadata && typeof profile.metadata === "object"
      ? (profile.metadata as Record<string, unknown>)
      : {};

  const existingErrors = Array.isArray(metadata.commonErrors)
    ? metadata.commonErrors.filter((item): item is string => typeof item === "string")
    : [];

  const label = description.trim() || describeMisconception(errorCode);
  const nextErrors = mergeCommonErrors(existingErrors, label);

  await admin
    .from("student_profiles")
    .update({
      metadata: {
        ...metadata,
        commonErrors: nextErrors,
        lastMisconceptionCode: errorCode,
        lastMisconceptionAt: new Date().toISOString(),
      },
    })
    .eq("id", studentId);

  const { data: existingReview } = await admin
    .from("nex_misconception_reviews")
    .select("review_count")
    .eq("student_id", studentId)
    .eq("error_code", errorCode)
    .maybeSingle();

  const reviewCount = existingReview?.review_count ?? 0;
  const intervalDays = nextReviewIntervalDays(reviewCount);
  const nextReviewAt = new Date(
    Date.now() + intervalDays * 24 * 60 * 60 * 1000,
  ).toISOString();

  await admin.from("nex_misconception_reviews").upsert(
    {
      student_id: studentId,
      topic_id: topicId,
      error_code: errorCode,
      description: label,
      review_count: reviewCount + 1,
      next_review_at: nextReviewAt,
      last_reviewed_at: new Date().toISOString(),
      resolved_at: null,
    },
    { onConflict: "student_id,error_code" },
  );
}

export async function getDueMisconceptionReviews(
  studentId: string,
): Promise<Array<{ id: string; errorCode: string; description: string; topicId: string | null }>> {
  const admin = createAdminClient();

  const { data } = await admin
    .from("nex_misconception_reviews")
    .select("id, error_code, description, topic_id")
    .eq("student_id", studentId)
    .is("resolved_at", null)
    .lte("next_review_at", new Date().toISOString())
    .order("next_review_at", { ascending: true })
    .limit(5);

  return (data ?? []).map((row) => ({
    id: row.id,
    errorCode: row.error_code,
    description: row.description,
    topicId: row.topic_id,
  }));
}

export async function resolveMisconceptionReview(
  studentId: string,
  reviewId: string,
): Promise<void> {
  const admin = createAdminClient();

  await admin
    .from("nex_misconception_reviews")
    .update({ resolved_at: new Date().toISOString() })
    .eq("id", reviewId)
    .eq("student_id", studentId);
}
```

- [ ] **Step 4: Update the three call sites that already call `persistStudentMisconception` to pass the topic id**

In `src/app/api/nex/chat/route.ts`, the streaming branch (lines 313-320) currently reads:

```ts
                if (misconception) {
                  await persistStudentMisconception(
                    studentProfile.id,
                    misconception.errorCode,
                    misconception.description,
                  ).catch(() => undefined);
                }
```

Change the inner call to add the fourth argument:

```ts
                if (misconception) {
                  await persistStudentMisconception(
                    studentProfile.id,
                    misconception.errorCode,
                    misconception.description,
                    activeTopicId,
                  ).catch(() => undefined);
                }
```

The non-streaming branch (lines 411-417) currently reads:

```ts
      if (misconception) {
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
        ).catch(() => undefined);
      }
```

Change it the same way:

```ts
      if (misconception) {
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
          activeTopicId,
        ).catch(() => undefined);
      }
```

Apply the identical fourth-argument addition (`activeTopicId`) to the equivalent call in `src/app/api/nex/voice/route.ts` (line 349):

```ts
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
          activeTopicId,
        ).catch(() => undefined);
```

And to the equivalent call in `src/app/api/nex/camera/route.ts` (lines 364-368), which currently reads:

```ts
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
        ).catch(() => undefined);
```

Change it the same way, to:

```ts
        await persistStudentMisconception(
          studentProfile.id,
          misconception.errorCode,
          misconception.description,
          activeTopicId,
        ).catch(() => undefined);
```

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/nex/misconceptionReviewSchedule.test.ts`
Expected: PASS

- [ ] **Step 6: Run the full Nex suite plus the existing misconception persistence test**

Run: `npx vitest run tests/nex tests/misconceptionPersistence.test.ts`
Expected: PASS — the pre-existing test for `misconceptionPersistence.ts` (the pure-helper file, not `misconceptionService.ts`) is unaffected since it doesn't touch `misconceptionService.ts`. If there's an existing test file for `misconceptionService.ts` itself, run it explicitly too and update any call-site assertions that check the old 3-argument call signature.

- [ ] **Step 7: Commit**

```bash
git add src/server/services/misconceptionService.ts src/app/api/nex/chat/route.ts src/app/api/nex/voice/route.ts src/app/api/nex/camera/route.ts tests/nex/misconceptionReviewSchedule.test.ts
git commit -m "feat(nex): schedule spaced-repetition reviews when a misconception is persisted"
```

### Task 8.3: Due-reviews and resolve API routes

- [ ] **Step 1: Write the failing test**

Create `tests/nex/misconceptionReviewRoutes.test.ts`:

```ts
/**
 * @vitest-environment node
 */
import { describe, expect, it, vi } from "vitest";

const getUser = vi.fn(async () => ({
  data: { user: { id: "user-1" } },
  error: null,
}));

vi.mock("@/lib/supabase/server", () => ({
  createClient: vi.fn(async () => ({
    auth: { getUser },
    from: (table: string) => {
      if (table === "student_profiles") {
        return {
          select: () => ({
            eq: () => ({
              maybeSingle: async () => ({ data: { id: "student-1" }, error: null }),
            }),
          }),
        };
      }
      throw new Error(`unexpected table ${table}`);
    },
  })),
}));

vi.mock("@/server/services/misconceptionService", () => ({
  getDueMisconceptionReviews: vi.fn(async () => [
    { id: "review-1", errorCode: "sign_error", description: "Mixed up positive/negative signs", topicId: "topic-1" },
  ]),
  resolveMisconceptionReview: vi.fn(async () => undefined),
}));

describe("GET /api/nex/reviews/due", () => {
  it("returns due reviews for the authenticated student", async () => {
    const { GET } = await import("@/app/api/nex/reviews/due/route");
    const response = await GET(new Request("http://localhost/api/nex/reviews/due"));
    const payload = await response.json();

    expect(response.status).toBe(200);
    expect(payload.success).toBe(true);
    expect(payload.data).toHaveLength(1);
    expect(payload.data[0].errorCode).toBe("sign_error");
  });
});

describe("POST /api/nex/reviews/[id]/resolve", () => {
  it("resolves the review for the authenticated student", async () => {
    const { resolveMisconceptionReview } = await import(
      "@/server/services/misconceptionService"
    );
    const { POST } = await import("@/app/api/nex/reviews/[id]/resolve/route");

    const response = await POST(
      new Request("http://localhost/api/nex/reviews/review-1/resolve", { method: "POST" }),
      { params: Promise.resolve({ id: "review-1" }) },
    );
    const payload = await response.json();

    expect(response.status).toBe(200);
    expect(payload.success).toBe(true);
    expect(resolveMisconceptionReview).toHaveBeenCalledWith("student-1", "review-1");
  });
});
```

- [ ] **Step 2: Run test to verify it fails**

Run: `npx vitest run tests/nex/misconceptionReviewRoutes.test.ts`
Expected: FAIL — neither route file exists yet

- [ ] **Step 3: Implement the due-reviews route**

Create `src/app/api/nex/reviews/due/route.ts`:

```ts
import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { getDueMisconceptionReviews } from "@/server/services/misconceptionService";

export async function GET(_request: Request) {
  try {
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { success: false, error: { code: "UNAUTHORIZED", message: "Missing or invalid session." } },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("id")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        { success: false, error: { code: "FORBIDDEN", message: "Student profile required." } },
        { status: 403 },
      );
    }

    const reviews = await getDueMisconceptionReviews(studentProfile.id);

    return NextResponse.json({ success: true, data: reviews });
  } catch (error) {
    console.error("NEX_REVIEWS_DUE_FAILED", error);
    return NextResponse.json(
      { success: false, error: { code: "INTERNAL_ERROR", message: "Could not load reviews." } },
      { status: 500 },
    );
  }
}
```

- [ ] **Step 4: Implement the resolve route**

Create `src/app/api/nex/reviews/[id]/resolve/route.ts`:

```ts
import "server-only";

import { NextResponse } from "next/server";

import { createClient } from "@/lib/supabase/server";
import { resolveMisconceptionReview } from "@/server/services/misconceptionService";

interface RouteContext {
  params: Promise<{ id: string }>;
}

export async function POST(_request: Request, context: RouteContext) {
  try {
    const { id } = await context.params;
    const supabase = await createClient();
    const {
      data: { user },
      error: authError,
    } = await supabase.auth.getUser();

    if (authError || !user) {
      return NextResponse.json(
        { success: false, error: { code: "UNAUTHORIZED", message: "Missing or invalid session." } },
        { status: 401 },
      );
    }

    const { data: studentProfile, error: profileError } = await supabase
      .from("student_profiles")
      .select("id")
      .eq("user_id", user.id)
      .maybeSingle();

    if (profileError || !studentProfile) {
      return NextResponse.json(
        { success: false, error: { code: "FORBIDDEN", message: "Student profile required." } },
        { status: 403 },
      );
    }

    await resolveMisconceptionReview(studentProfile.id, id);

    return NextResponse.json({ success: true, data: { resolved: true } });
  } catch (error) {
    console.error("NEX_REVIEW_RESOLVE_FAILED", error);
    return NextResponse.json(
      { success: false, error: { code: "INTERNAL_ERROR", message: "Could not resolve review." } },
      { status: 500 },
    );
  }
}
```

- [ ] **Step 5: Run test to verify it passes**

Run: `npx vitest run tests/nex/misconceptionReviewRoutes.test.ts`
Expected: PASS (2 tests)

- [ ] **Step 6: Commit**

```bash
git add src/app/api/nex/reviews tests/nex/misconceptionReviewRoutes.test.ts
git commit -m "feat(nex): add due-reviews and resolve-review API routes"
```

### Task 8.4: Review banner UI

- [ ] **Step 1: Implement the banner component**

Create `src/features/nex/components/NexReviewBanner.tsx`:

```tsx
"use client";

import { useEffect, useState } from "react";
import { RotateCcw, X } from "lucide-react";

import { cn } from "@/lib/utils";

interface DueReview {
  id: string;
  errorCode: string;
  description: string;
  topicId: string | null;
}

interface NexReviewBannerProps {
  onSelectReview: (review: DueReview) => void;
  className?: string;
}

export function NexReviewBanner({ onSelectReview, className }: NexReviewBannerProps) {
  const [reviews, setReviews] = useState<DueReview[]>([]);
  const [dismissedIds, setDismissedIds] = useState<Set<string>>(new Set());

  useEffect(() => {
    let cancelled = false;

    void (async () => {
      try {
        const response = await fetch("/api/nex/reviews/due");
        const payload = (await response.json()) as {
          success: boolean;
          data?: DueReview[];
        };

        if (!cancelled && response.ok && payload.success && payload.data) {
          setReviews(payload.data);
        }
      } catch {
        // Silent — the review banner is a nice-to-have, not critical path.
      }
    })();

    return () => {
      cancelled = true;
    };
  }, []);

  const visibleReview = reviews.find((review) => !dismissedIds.has(review.id));

  if (!visibleReview) {
    return null;
  }

  async function dismiss(reviewId: string) {
    setDismissedIds((prev) => new Set(prev).add(reviewId));
    await fetch(`/api/nex/reviews/${reviewId}/resolve`, { method: "POST" }).catch(
      () => undefined,
    );
  }

  return (
    <div
      className={cn(
        "flex items-center justify-between gap-3 rounded-[14px] border border-nexus-primary/30 bg-nexus-primary/5 px-4 py-3",
        className,
      )}
      role="status"
    >
      <div className="flex items-center gap-2 text-sm text-foreground">
        <RotateCcw className="size-4 shrink-0 text-nexus-primary" aria-hidden />
        <span>You mixed this up before: {visibleReview.description}. Want a quick check?</span>
      </div>
      <div className="flex shrink-0 items-center gap-2">
        <button
          type="button"
          onClick={() => onSelectReview(visibleReview)}
          className="min-h-9 rounded-full bg-nexus-primary px-3 text-sm font-medium text-nexus-text-inverse hover:opacity-90"
        >
          Try it
        </button>
        <button
          type="button"
          onClick={() => void dismiss(visibleReview.id)}
          aria-label="Dismiss review"
          className="flex size-9 items-center justify-center rounded-full text-muted-foreground hover:bg-nexus-sunken"
        >
          <X className="size-4" aria-hidden />
        </button>
      </div>
    </div>
  );
}
```

- [ ] **Step 2: Wire the banner into `NexChatPanel.tsx`**

In `src/features/nex/components/NexChatPanel.tsx`, add the import and render the banner above the message list. Add the import (alongside the other `NexFollowUpChips` import):

```ts
import { NexReviewBanner } from "@/features/nex/components/NexReviewBanner";
```

Render it near the top of the panel's JSX (immediately before the message-list container that starts around line 338's `NexChatEmptyState` block), passing a handler that starts a homework-mode message referencing the misconception:

```tsx
      <NexReviewBanner
        onSelectReview={(review) =>
          handleStarterPrompt(
            `Can you give me a quick check on ${review.description}?`,
          )
        }
        className="mb-3"
      />
```

`handleStarterPrompt` already exists in `NexChatPanel.tsx` (used at line 341 for `NexChatEmptyState`'s `onSelectPrompt`), so this reuses the existing send-a-starter-message flow rather than adding a new code path.

- [ ] **Step 3: Typecheck**

Run: `npx tsc --noEmit -p tsconfig.json`
Expected: no new errors

- [ ] **Step 4: Manual verification**

Seed a `nex_misconception_reviews` row with `next_review_at` in the past for a test student (or trigger a real misconception detection in homework mode, then manually update `next_review_at` to `NOW() - INTERVAL '1 day'` in the DB), reload the Nex chat page, and confirm the banner appears with "Try it" / dismiss controls, and that "Try it" sends a homework-mode message referencing the misconception description.

- [ ] **Step 5: Commit**

```bash
git add src/features/nex/components/NexReviewBanner.tsx src/features/nex/components/NexChatPanel.tsx
git commit -m "feat(nex): surface due misconception reviews in the chat panel"
```

---

## Final verification (run once, after all 8 groups)

- [ ] **Run the full test suite**

Run: `npx vitest run`
Expected: all tests pass, including every new file created above.

- [ ] **Typecheck**

Run: `npx tsc --noEmit -p tsconfig.json`
Expected: no errors.

- [ ] **Lint**

Run: `npm run lint`
Expected: no new errors introduced by this plan's files.

- [ ] **Scope check**

Run: `npm run test:scope-check`
Expected: `Scope check passed.`

- [ ] **Build**

Run: `npm run build`
Expected: production build succeeds, including the two new API route segments under `/api/nex/reviews/`.
