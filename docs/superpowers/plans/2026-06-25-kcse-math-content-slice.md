# KCSE Math Content Slice — Implementation Plan

> **For the implementing agent (Cursor):** You have ZERO prior context. Read these two docs in full first:
> - `docs/superpowers/plans/2026-06-25-kcse-math-CURSOR-GROUND-TRUTH.md` (schema, SQL patterns, escaping, hard rules)
> - `docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md` (how to author content, gold-standard exemplar)
>
> Work task-by-task, in order. Each task ends with a commit. Steps use `- [ ]` checkboxes. If reality
> diverges from this plan (a file/column/code is different), **STOP and report** — do not improvise.

**Goal:** Make 3 Form 1 KCSE Mathematics topics (`integers`, `algebraic_expressions`, `rates_ratio_proportion`) genuinely production-ready (comprehensive lessons + calibrated practice), and make math notation render everywhere students read it.

**Architecture:** A contained renderer change introduces one shared `MathText` (markdown + KaTeX) component and routes currently-plain-text fields through it. Content is authored as a new idempotent seed file; legacy generic KCSE math topics are soft-retired (`is_active=false`). No navigation or schema changes.

**Tech Stack:** Next.js (app router), React, TypeScript, Tailwind, `react-markdown` + `remark-gfm` + `remark-math` + `rehype-katex`, Vitest + React Testing Library (jsdom), Supabase (Postgres) seeds.

**Branch:** `feat/kcse-math-content-slice` (already created). Commit here; do not merge to `main`.

**Commands you will use:**
- Run all tests: `npm test`
- Run one test file: `npx vitest run <path>`
- Reseed local DB: `npm run db:reset`

---

## Phase 1 — Renderer enhancement (TDD)

### Task 1: Shared `MathText` component

**Files:**
- Create: `src/components/content/MathText.tsx`
- Test: `tests/content/mathText.test.tsx`

- [ ] **Step 1: Write the failing test** (mirror RTL/jsdom setup used by `tests/learn/learnSubjectExplorer.test.tsx`)

```tsx
import { render } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { MathText } from "@/components/content/MathText";

describe("MathText", () => {
  it("renders LaTeX as KaTeX markup", () => {
    const { container } = render(<MathText inline>{"$\\frac{3}{4}$"}</MathText>);
    expect(container.querySelector(".katex")).not.toBeNull();
  });

  it("passes plain text through unchanged", () => {
    const { container } = render(<MathText inline>{"Hello world"}</MathText>);
    expect(container.textContent).toContain("Hello world");
  });
});
```

- [ ] **Step 2: Run it, verify it fails**

Run: `npx vitest run tests/content/mathText.test.tsx`
Expected: FAIL — cannot resolve `@/components/content/MathText`.

- [ ] **Step 3: Implement the component**

```tsx
"use client";

import ReactMarkdown from "react-markdown";
import rehypeKatex from "rehype-katex";
import remarkGfm from "remark-gfm";
import remarkMath from "remark-math";

import "katex/dist/katex.min.css";

const remarkPlugins = [remarkGfm, remarkMath];
const rehypePlugins = [rehypeKatex];

export function MathText({
  children,
  inline = false,
  className,
}: {
  children: string;
  inline?: boolean;
  className?: string;
}) {
  if (inline) {
    return (
      <ReactMarkdown
        remarkPlugins={remarkPlugins}
        rehypePlugins={rehypePlugins}
        components={{ p: ({ children }) => <>{children}</> }}
      >
        {children}
      </ReactMarkdown>
    );
  }

  return (
    <div className={className}>
      <ReactMarkdown remarkPlugins={remarkPlugins} rehypePlugins={rehypePlugins}>
        {children}
      </ReactMarkdown>
    </div>
  );
}
```

- [ ] **Step 4: Run it, verify it passes**

Run: `npx vitest run tests/content/mathText.test.tsx`
Expected: PASS (both tests).

- [ ] **Step 5: Commit**

```bash
git add src/components/content/MathText.tsx tests/content/mathText.test.tsx
git commit -m "feat(content): add shared MathText markdown+KaTeX renderer"
```

### Task 2: Route lesson blocks through `MathText`

**Files:**
- Modify: `src/features/learn/components/LessonContentBlocks.tsx`

Use **block** `MathText` for prose (`paragraph`, `tip`, `callout`), **inline** `MathText` for the
`example` steps + answer and inline `question` text + options. Do not change layout/markup beyond
swapping the text node for `<MathText …>`.

- [ ] **Step 1: Add the import** at the top with the other imports:

```tsx
import { MathText } from "@/components/content/MathText";
```

- [ ] **Step 2: `paragraph` block** — replace `<p className="leading-8 text-foreground/90">{block.content}</p>` with:

```tsx
<MathText className="leading-8 text-foreground/90">{block.content}</MathText>
```

- [ ] **Step 3: `example` steps** — inside `WorkedExampleBlock`, replace the step body `{step}` (the text after the `Step N.` span) with:

```tsx
<MathText inline>{step}</MathText>
```

- [ ] **Step 4: `example` answer** — replace `Answer: {block.answer}` with:

```tsx
Answer: <MathText inline>{block.answer}</MathText>
```

- [ ] **Step 5: `tip` block** — replace `<p className="mt-2">{block.content}</p>` with:

```tsx
<MathText className="mt-2">{block.content}</MathText>
```

- [ ] **Step 6: `callout` block** — inside `CalloutBlock`, replace `<p className="mt-2 whitespace-pre-wrap">{block.content}</p>` with:

```tsx
<MathText className="mt-2">{block.content}</MathText>
```

- [ ] **Step 7: inline `question` block** — inside `InlineQuestionBlock`:
  - replace `{formatStudentQuestionText(block.questionText)}` with `<MathText inline>{formatStudentQuestionText(block.questionText)}</MathText>`
  - replace the option label `{option}` (inside the option `<button>`) with `<MathText inline>{option}</MathText>`
  - replace the answer reveal `…the answer is ${block.correctAnswer}.` so the answer renders: keep the prefix text and render `<MathText inline>{block.correctAnswer}</MathText>` after it.

- [ ] **Step 8: Typecheck + tests**

Run: `npx vitest run` (and your editor/`tsc` if available)
Expected: existing learn tests still PASS; no type errors.

- [ ] **Step 9: Commit**

```bash
git add src/features/learn/components/LessonContentBlocks.tsx
git commit -m "feat(learn): render math in paragraph/example/tip/callout/inline-question"
```

### Task 3: Route practice questions through `MathText`

**Files:**
- Modify: `src/features/practice/components/PracticeRunner.tsx`

- [ ] **Step 1: Import** `import { MathText } from "@/components/content/MathText";`
- [ ] **Step 2:** Replace the rendered `currentQuestionText` node (`<span>{...}</span>` / `<p>` showing `formatStudentQuestionText(currentQuestion.questionText)`) so the text renders via `<MathText inline>{currentQuestionText}</MathText>`.
- [ ] **Step 3:** Replace the option label render `{option}` (inside the option list) with `<MathText inline>{option}</MathText>`.
- [ ] **Step 4: Tests** — Run: `npx vitest run tests/practice` — Expected: PASS.
- [ ] **Step 5: Commit**

```bash
git add src/features/practice/components/PracticeRunner.tsx
git commit -m "feat(practice): render math in question text and options"
```

### Task 4: Route mock-exam questions through `MathText`

**Files:**
- Modify: `src/features/mockExams/components/ExamSimulatorShell.tsx`

- [ ] **Step 1: Import** `MathText`.
- [ ] **Step 2:** Render the exam question text via `<MathText inline>…</MathText>`.
- [ ] **Step 3:** Render each option label via `<MathText inline>{option}</MathText>`.
- [ ] **Step 4: Tests** — Run: `npx vitest run` — Expected: PASS.
- [ ] **Step 5: Commit**

```bash
git add src/features/mockExams/components/ExamSimulatorShell.tsx
git commit -m "feat(mock-exams): render math in question text and options"
```

---

## Phase 2 — Content authoring

> Author per `…CONTENT-GUIDE.md`. Every insert must be idempotent and use the exact patterns from
> `…CURSOR-GROUND-TRUTH.md §4`. Watch the LaTeX-in-JSON-in-SQL escaping (`…GROUND-TRUTH.md §5`).

### Task 5: New seed file, wiring, soft-retire, added subtopics

**Files:**
- Create: `supabase/seed/curriculum_math_kcse_content.sql`
- Modify: `supabase/config.toml`

- [ ] **Step 1:** Create `supabase/seed/curriculum_math_kcse_content.sql` beginning with a header comment and the **soft-retire** block (GROUND-TRUTH §4) for `algebra, fractions, geometry, trigonometry, statistics` scoped to `c.code='KCSE'`.
- [ ] **Step 2:** Add any **added subtopics** you will use (GROUND-TRUTH §4 subtopic pattern) — only those confirmed against KNEC (CONTENT-GUIDE §5). If unconfirmed (e.g. `basic_factorisation`), omit it and author within existing subtopics; note the omission in your handback.
- [ ] **Step 3:** Register the file in `supabase/config.toml` `[db.seed] sql_paths`, **immediately after** `"./seed/curriculum_math_kcse.sql"`.
- [ ] **Step 4:** Reset and confirm it loads with no SQL errors.

Run: `npm run db:reset`
Expected: completes without error; new file is applied.

- [ ] **Step 5: Commit**

```bash
git add supabase/seed/curriculum_math_kcse_content.sql supabase/config.toml
git commit -m "feat(seed): scaffold KCSE math content seed; soft-retire legacy topics"
```

### Task 6: Author `integers` content

**Files:** Modify `supabase/seed/curriculum_math_kcse_content.sql`

- [ ] **Step 1:** Author lessons for every `integers` subtopic (concept → methods → application), ≥3 lessons total, using the gold-standard exemplar (CONTENT-GUIDE §6) as the quality/shape baseline.
- [ ] **Step 2:** Author practice questions: **≥7 easy, ≥7 medium, ≥7 hard**, mistake-based distractors, explanations, spread across subtopics.
- [ ] **Step 3:** `npm run db:reset` — Expected: no errors.
- [ ] **Step 4:** Verify counts + rendering (see Phase 3 queries) for `integers` specifically.
- [ ] **Step 5: Commit**

```bash
git add supabase/seed/curriculum_math_kcse_content.sql
git commit -m "feat(content): author KCSE Form 1 Integers lessons and practice"
```

### Task 7: Author `algebraic_expressions` content

**Files:** Modify `supabase/seed/curriculum_math_kcse_content.sql`

- [ ] **Step 1:** Lessons for every subtopic (`forming_expressions`, `simplification`, `substitution`, + confirmed adds), ≥3 total, concept→methods→application.
- [ ] **Step 2:** ≥7/≥7/≥7 practice questions across difficulties, mistake-based distractors, explanations.
- [ ] **Step 3:** `npm run db:reset` — Expected: no errors.
- [ ] **Step 4:** Verify counts + rendering for `algebraic_expressions`.
- [ ] **Step 5: Commit**

```bash
git add supabase/seed/curriculum_math_kcse_content.sql
git commit -m "feat(content): author KCSE Form 1 Algebraic Expressions lessons and practice"
```

### Task 8: Author `rates_ratio_proportion` content

**Files:** Modify `supabase/seed/curriculum_math_kcse_content.sql`

- [ ] **Step 1:** Lessons for every subtopic (`rates`, `ratio_proportion`, `percentage`, + confirmed adds), ≥3 total, concept→methods→application.
- [ ] **Step 2:** ≥7/≥7/≥7 practice questions across difficulties, mistake-based distractors, explanations.
- [ ] **Step 3:** `npm run db:reset` — Expected: no errors.
- [ ] **Step 4:** Verify counts + rendering for `rates_ratio_proportion`.
- [ ] **Step 5: Commit**

```bash
git add supabase/seed/curriculum_math_kcse_content.sql
git commit -m "feat(content): author KCSE Form 1 Rates, Ratio & Proportion lessons and practice"
```

---

## Phase 3 — Verification

### Task 9: Readiness contract test (pure function)

**Files:**
- Test: `tests/curriculum/kcseMathSliceReadiness.test.ts`

- [ ] **Step 1: Write the test** (encodes the bar; uses the real `getTopicReadinessLabel`)

```ts
import { describe, expect, it } from "vitest";

import { getTopicReadinessLabel } from "@/lib/curriculum/contentModel";

describe("KCSE math slice readiness bar", () => {
  it("a topic with full lessons and ≥7 per band is PROD_READY", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 9,
        subtopicCount: 3,
        subtopicsWithLesson: 3,
        questionCounts: { easy: 7, medium: 7, hard: 7 },
      }),
    ).toBe("PROD_READY");
  });

  it("missing a subtopic lesson is not PROD_READY", () => {
    expect(
      getTopicReadinessLabel({
        publishedLessonCount: 9,
        subtopicCount: 3,
        subtopicsWithLesson: 2,
        questionCounts: { easy: 7, medium: 7, hard: 7 },
      }),
    ).not.toBe("PROD_READY");
  });
});
```

- [ ] **Step 2: Run** — `npx vitest run tests/curriculum/kcseMathSliceReadiness.test.ts` — Expected: PASS.
- [ ] **Step 3: Commit**

```bash
git add tests/curriculum/kcseMathSliceReadiness.test.ts
git commit -m "test(curriculum): encode KCSE math slice readiness bar"
```

### Task 10: Seed-integrity verification (run, record results in handback)

- [ ] **Step 1:** `npm run db:reset` twice; confirm the second run does not increase counts (idempotency).
- [ ] **Step 2:** Run these queries (via `supabase db` / psql / Studio) and record outputs:

```sql
-- legacy KCSE topics must be inactive
SELECT t.code, t.is_active FROM public.topics t
JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
WHERE c.code='KCSE' AND s.code='mathematics'
  AND t.code IN ('algebra','fractions','geometry','trigonometry','statistics');

-- lessons per slice topic (expect >=3 and every subtopic covered)
SELECT t.code AS topic, st.code AS subtopic, count(l.id) AS lessons
FROM public.topics t
JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id
LEFT JOIN public.lessons l ON l.subtopic_id=st.id
WHERE c.code='KCSE' AND s.code='mathematics'
  AND t.code IN ('integers','algebraic_expressions','rates_ratio_proportion')
GROUP BY t.code, st.code ORDER BY t.code, st.code;

-- questions per band per slice topic (expect each band >=7)
SELECT t.code AS topic, pq.difficulty, count(*) AS n
FROM public.practice_questions pq
JOIN public.topics t ON t.id=pq.topic_id
JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
WHERE c.code='KCSE' AND s.code='mathematics'
  AND t.code IN ('integers','algebraic_expressions','rates_ratio_proportion')
GROUP BY t.code, pq.difficulty ORDER BY t.code, pq.difficulty;
```

Expected: legacy topics `is_active=false`; every slice subtopic has ≥1 lesson and each topic ≥3 lessons; each topic has ≥7 questions in each of easy/medium/hard.

### Task 11: Visual verification (preview) + full suite

- [ ] **Step 1:** Run the app; open a slice lesson with a worked example containing a fraction/exponent — confirm it renders as real notation (not literal `\frac`).
- [ ] **Step 2:** Start a practice session on a slice topic — confirm question + option math renders.
- [ ] **Step 3: REGRESSION** — open an existing **English** lesson and an English practice session — confirm prose is unchanged/undisturbed by the renderer change.
- [ ] **Step 4:** `npm test` — Expected: entire suite PASS.
- [ ] **Step 5:** Prepare a handback summary (see below).

---

## Handback summary (Cursor → owner → audit)

When done, report:
1. Files created/modified (with the commit list).
2. Per-topic counts from Task 10 queries (lessons per subtopic; questions per band).
3. Any subtopics you added vs omitted (and why — e.g. `basic_factorisation` KNEC uncertainty).
4. Any deviations from this plan and the reason.
5. Confirmation that legacy topics are soft-retired and `db reset` is idempotent.
6. Screenshots/notes from the preview checks, including the English regression check.

## Definition of done (audit checklist)

- [ ] `MathText` exists, tested; math renders in lessons, practice, and mock exams.
- [ ] Existing English content visually unchanged (regression check passed).
- [ ] 3 slice topics each: ≥3 lessons, every subtopic covered, ≥7 questions/band; `PROD_READY`.
- [ ] Legacy generic KCSE math topics `is_active=false`; no `DELETE`/rename; CBC untouched.
- [ ] New seed file idempotent; `config.toml` updated; `npm run db:reset` clean.
- [ ] All math content uses correctly-escaped LaTeX; renders as symbols.
- [ ] `npm test` passes. Work on `feat/kcse-math-content-slice`, not `main`.
