# English Content Manifest — V2 Tier 1

**Version:** 1.0  
**Scope:** Minimum English topics for CBC and KCSE  
**Subject code:** `english`

---

## Summary

| Curriculum | Topics | Lessons | Practice Questions |
|------------|--------|---------|-------------------|
| CBC | 3 | 9 (3 per topic) | 63 (21 per topic) |
| KCSE | 3 | 9 (3 per topic) | 63 (21 per topic) |

Both curricula cover **Reading Comprehension**, **Grammar**, and **Writing Skills**.

Writing skills teach structure and editing — **no essay ghostwriting** (Nex declines completing full essays for students).

Diagnostic assessments remain **math-only** (V1 unchanged).

---

## CBC English

**Curriculum code:** `CBC`  
**Applicable grades:** Grade 4–9

| Topic | Code | Subtopics | Lessons | Practice Questions | Difficulty Split |
|-------|------|-----------|---------|-------------------|------------------|
| Reading Comprehension | `reading_comprehension` | Main Idea, Inference, Vocabulary | 3 | 21 | 7 easy, 7 medium, 7 hard |
| Grammar | `grammar` | Parts of Speech, Sentences, Tenses | 3 | 21 | 7 easy, 7 medium, 7 hard |
| Writing Skills | `writing_skills` | Paragraphs, Punctuation, Summaries | 3 | 21 | 7 easy, 7 medium, 7 hard |

---

## KCSE English

**Curriculum code:** `KCSE`  
**Applicable forms:** Form 1–4

| Topic | Code | Subtopics | Lessons | Practice Questions | Min Form | Difficulty Split |
|-------|------|-----------|---------|-------------------|----------|------------------|
| Reading Comprehension | `reading_comprehension` | Main Idea, Inference, Vocabulary | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |
| Grammar | `grammar` | Parts of Speech, Sentences, Tenses | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |
| Writing Skills | `writing_skills` | Paragraphs, Punctuation, Summaries | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |

---

## Seed Location

| File | Purpose |
|------|---------|
| `scripts/generate-curriculum-seed.mjs` | Generator for english curriculum seed |
| `supabase/seed/curriculum_english.sql` | Topics, subtopics, lessons, practice questions |

---

## Acceptance Criteria

- [x] Three topics per curriculum (CBC + KCSE)
- [x] At least 3 lessons per topic
- [x] At least 21 practice questions per topic across difficulties
- [x] Student UI filters by curriculum and grade level
- [x] Nex tutors english with curriculum-grounded context
- [x] Nex declines ghostwriting full essays
