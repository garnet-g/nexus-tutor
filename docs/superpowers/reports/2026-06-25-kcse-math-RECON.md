# KCSE Math Content Slice — Phase A RECON

**Date:** 2026-06-25  
**Branch:** `feat/kcse-math-content-slice`  
**Scope:** Blast-radius map + baseline before implementation

---

## 1. Access-point / caller / handler map

### 1.1 Learn routes

| Route | Page handler | Services | UI chain | Filters active content? |
|-------|-------------|----------|----------|-------------------------|
| `/learn` | `src/app/(student)/learn/page.tsx` | `getSubjectsForStudent`, `getTopics`, `getProgressSummary` | `LearnSubjectExplorer` → `TopicCard` | Topics: `is_active=true` + grade visibility + **`isTopicLearnReady`** (≥3 published lessons, every subtopic has ≥1 lesson) |
| `/learn/[topicId]` | `src/app/(student)/learn/[topicId]/page.tsx` | `getTopicDetail`, `getProgressSummary`, `getCompletedLessonIdsForTopic` | `TopicLearningPath` | Topic/subtopics/lessons: `is_active=true`; lessons `review_status=published` |
| `/learn/[topicId]/[lessonId]` | `src/app/(student)/learn/[topicId]/[lessonId]/page.tsx` | `getLesson`, `getTopicDetail`, `getLessonProgressState` | `LessonRenderer` → `LessonReader` → **`LessonContentBlocks`** | Cross-checks `lesson.topicId === topicId`; inactive topic → `notFound()` |

**APIs touched:** `/api/lessons/[id]/viewed`, `/api/lessons/[id]/complete`

**Break risk (markdown):** `LessonContentBlocks` currently renders `paragraph`, `example`, `tip`, `callout`, inline `question`, and `shortQuiz` as plain text. Routing through `MathText` may reinterpret markdown-significant characters (`*`, `_`, `#`, `$`). Snapshot tests in `tests/learn/lessonContentBlocks.test.tsx` will need updates.

**Break risk (soft-retire):** Retired topics disappear from `/learn` tree. Deep links to retired topic IDs return `notFound()`.

### 1.2 Practice

| Surface | Handler | Services | UI | Key behavior |
|---------|---------|----------|-----|--------------|
| `/practice` | `src/app/(student)/practice/page.tsx` | `listPracticeCurriculumTree` | `PracticeLanding` → **`PracticeRunner`** | Tree: active topics + publishable questions; session via `/api/practice-sessions` |
| `PracticeRunner` | Client | POST `/api/practice-sessions`, answer/complete routes | Renders `questionText` + options as **plain text** via `formatStudentQuestionText` | MCQ grading uses raw string equality on `options` values |

**Break risk (markdown):** Question text and option labels become math-aware; grading unchanged (raw string compare). Layout inside `<button>` needs `inline` MathText variant.

**Break risk (soft-retire):** `practiceService` filters `topics.is_active=true` — retired legacy topics vanish from practice tree.

### 1.3 Mock exams

| Surface | Handler | Services | UI | Key behavior |
|---------|---------|----------|-----|--------------|
| `/mock-exams` | `src/app/(student)/mock-exams/page.tsx` | — | Redirects → `/exam-prep` | |
| `/exam-prep` | `src/app/(student)/exam-prep/page.tsx` | `getSubjectsForStudent`, `getTopics` | `ExamPrepWizard` | Topic picker uses learn-ready filter |
| `/exam-simulator` | `src/app/(student)/exam-simulator/page.tsx` | Direct Supabase admin reads | **`ExamSimulatorShell`** | Questions snapshotted in `mock_exam_questions` at generation time |
| Generation | `/api/mock-exams/generate/route.ts` | `mockExamService` → `loadPracticePool` → `selectMockExamQuestions` | — | Pool query filters `practice_questions.is_active` only — **no `topics.is_active` or `review_status`** |

**Break risk (markdown):** `ExamSimulatorShell` question text + options currently plain; MathText routing needed.

**Break risk (soft-retire):** **HIGH GAP** — `mockExamService.loadPracticePool` does not filter `topics.is_active`. Retired topic questions may still appear in mock exams until slice content replaces pool depth. Out of slice scope per spec; noted for awareness.

### 1.4 `LessonContentBlocks`

**Callers:** `LessonReader`, `LessonStudioShell` (preview), `ContentReviewQueuePanel`

| Block type | Current render | Phase 1 target |
|------------|----------------|----------------|
| `paragraph`, `tip`, `callout` | Plain `<p>` | MathText (markdown+KaTeX) |
| `example` steps/answer | Plain text | MathText inline |
| `question` (inline) | Plain `questionText` + options | MathText inline |
| `rich_text`, `math_block`, `chemical_equation` | ReactMarkdown + remark-math + rehype-katex | Already math-capable |
| `heading`, `table`, `comprehension_passage` | Plain | Unchanged |
| `shortQuiz` | In `LessonReader` — plain text | MathText (if touched in Phase 1) |

**Tests:** `tests/learn/lessonContentBlocks.test.tsx` + snapshot — expect updates when MathText lands.

### 1.5 `src/schemas/lessonContentSchemas.ts`

- Zod discriminated union on `type`; consumed by admin studio, `contentQualityGates`, content generation schemas, tests.
- **No schema change planned** for Phase 1 — markdown lives in existing string fields.
- Validation risk: LaTeX in JSON must use `\\` backslashes; invalid JSON breaks seed loads.

### 1.6 Services

| Service | Role | `is_active` filtering | Readiness gates |
|---------|------|----------------------|-----------------|
| `curriculumService.ts` | Learn tree, topic detail, lessons | Strict on curricula/subjects/topics/subtopics/lessons | `getTopics` requires `isTopicLearnReady` |
| `practiceService.ts` | Practice tree, sessions, mastery | Tree + sessions filter active; questions need `review_status=published` | `MIN_QUESTIONS_TO_START_PRACTICE=5` per band |
| `mockExamService.ts` | Generate/submit mock exams | Questions `is_active` only on pool load | Falls back to synthetic questions if pool thin |
| `contentModel.ts` / `practiceCoverage.ts` | PROD_READY contract | — | ≥3 lessons, all subtopics covered, ≥5 questions/band |

### 1.7 Seed pipeline

```
supabase/config.toml [db.seed] sql_paths:
  ./seed.sql
  → ./seed/curriculum_math.sql      (CBC 3 + KCSE legacy 5 topics, 24 lessons, 100 questions)
  → ./seed/curriculum_math_kcse.sql (65 KCSE skeleton topics + subtopics)
  → curriculum_science, english, english_kcse, chemistry, kiswahili
```

Planned slice seed file must load **after** `curriculum_math_kcse.sql`. Soft-retire UPDATE must scope `c.code = 'KCSE'`.

---

## 2. Identified risks

### Markdown / MathText (Phase 1)

| Risk | Severity | Detail |
|------|----------|--------|
| Unintended markdown parsing | Medium | `*bold*`, `_emphasis_`, `# headings` in plain prose could change appearance |
| `$` / `$$` false positives | Medium | Currency or accidental delimiters trigger KaTeX |
| MCQ option rendering | High | Options inside `<button>` need `inline` MathText; grading still compares raw strings |
| Snapshot/test drift | Medium | `lessonContentBlocks.test.tsx.snap` expects plain text |
| Duplicate KaTeX CSS | Low | Import inside `MathText.tsx` per plan |
| `formatStudentQuestionText` | Low | Only strips label prefixes |

### LaTeX in seeds

| Risk | Severity | Detail |
|------|----------|--------|
| JSON backslash mangling | **Critical** | `\frac` → form-feed if not doubled (`\\frac`) in JSON strings |
| SQL apostrophe escaping | High | `Grace's` → `Grace''s` in SQL literals |

### Soft-retire legacy topics

| Risk | Severity | Detail |
|------|----------|--------|
| Learn/practice UI hides retired topics | Expected | All tree queries filter `topics.is_active=true` |
| Mock exam pool gap | **High** | `loadPracticePool` does not filter `topics.is_active` |
| Deep links break | Medium | `/learn/{retiredTopicId}` → `notFound()` |
| Upsert re-activates? | **No** | `ON CONFLICT DO UPDATE` does not touch `is_active` — soft-retire is sticky |
| CBC collision | **Critical if mis-scoped** | Retire UPDATE must include `c.code = 'KCSE'` |

### Content / readiness

| Risk | Detail |
|------|--------|
| Slice topics invisible until PROD_READY | No lessons/questions in seeds yet → filtered out of `/learn` and `/practice` |
| Mock exam pool shrinkage | Retiring 5 legacy topics removes ~50 KCSE questions from pool until slice content lands |
| `review_status` on new seeds | Practice requires `published`; confirm new lesson/question defaults |

---

## 3. Green baseline

| Metric | Result |
|--------|--------|
| Command | `npm test` → `vitest run` |
| Test files | **79 passed** |
| Tests | **378 passed** |
| Failures | **0** |

### Math topic counts (from seeds)

| Source | KCSE math topics | Notes |
|--------|------------------|-------|
| `supabase/seed/curriculum_math_kcse.sql` | **65** skeleton topics | Subtopics only; **0 lessons, 0 practice questions** |
| `supabase/seed/curriculum_math.sql` | **5** legacy KCSE topics | `algebra`, `fractions`, `geometry`, `trigonometry`, `statistics` |
| **Combined KCSE math** | **70** unique topic codes | No code overlap between files |
| Lessons (legacy file) | **24** | |
| Practice questions (legacy file) | **~100** INSERTs | ~50 CBC + ~50 KCSE |

**Slice scope (3 topics):** `integers`, `algebraic_expressions`, `rates_ratio_proportion` — skeleton exists, **no authored content yet**.

---

## 4. Ground-truth verification

| Check | Result | Evidence |
|-------|--------|----------|
| Topic `ON CONFLICT DO UPDATE` does not reset `is_active` | **PASS** | `curriculum_math.sql:215-219` |
| 3 slice topics + subtopics in `curriculum_math_kcse.sql` | **PASS** | See table below |
| `config.toml` seed order | **PASS** | `curriculum_math.sql` → `curriculum_math_kcse.sql`; append new file after kcse |
| Vitest test runner | **PASS** | `npm test` = `vitest run`; tests under `tests/` |
| `basic_factorisation` Form 1 | **DEFERRED** | Confirm against KNEC before adding; omit if uncertain |

**Slice topic codes verified:**

| Topic code | Subtopic codes (exact) |
|------------|------------------------|
| `integers` | `number_line_integers`, `operations_integers`, `order_of_operations` |
| `algebraic_expressions` | `forming_expressions`, `simplification`, `substitution` |
| `rates_ratio_proportion` | `rates`, `ratio_proportion`, `percentage` |

---

## 5. Implementation notes for Phase B

1. All tests green — safe to proceed.
2. Primary blast radius: `MathText` component + three consumer surfaces + new seed file.
3. Honor recon risks: double backslashes in LaTeX JSON, KCSE-scoped soft-retire, English regression check in Task 11.
4. Mock exam `topics.is_active` gap is documented; do not expand scope unless spec changes.
