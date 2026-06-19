# Mathematics Content Manifest — V1



**Version:** 1.1  

**Scope:** Minimum V1 mathematics topics for CBC and KCSE  

**Subject code:** `mathematics`



---



## Summary



| Curriculum | Topics | Lessons | Practice Questions | Diagnostic |

|------------|--------|---------|-------------------|------------|

| CBC | 3 | 9 (3 per topic) | 63 (21 per topic) | 20 questions |

| KCSE | 5 | 15 (3 per topic) | 105 (21 per topic) | 20 questions |



CBC covers **Fractions**, **Algebra**, and **Geometry Basics** (KICD foundations).  

KCSE adds **Trigonometry** and **Statistics** to the same core trio (KNEC foundations).



---



## CBC Mathematics



**Curriculum code:** `CBC`  

**Applicable grades:** Grade 4–9 (filtered by `student_profiles.curriculum` and `grade_level` via `grade_levels.sort_order`)



| Topic | Code | Subtopics | Lessons | Practice Questions | Difficulty Split |

|-------|------|-----------|---------|-------------------|------------------|

| Fractions | `fractions` | Introduction, Equivalent Fractions, Operations | 3 | 21 | 7 easy, 7 medium, 7 hard |

| Algebra | `algebra` | Expressions, Simple Equations, Linear Equations | 3 | 21 | 7 easy, 7 medium, 7 hard |

| Geometry Basics | `geometry` | Shapes, Angles, Area & Perimeter | 3 | 21 | 7 easy, 7 medium, 7 hard |



**Diagnostic assessment:** `CBC Mathematics Diagnostic` — 20 questions (8 easy, 8 medium, 4 hard) spanning all three topics.



---



## KCSE Mathematics



**Curriculum code:** `KCSE`  

**Applicable forms:** Form 1–4 (filtered by `student_profiles.curriculum` and `grade_level` via `grade_levels.sort_order`)



| Topic | Code | Subtopics | Lessons | Practice Questions | Min Form | Difficulty Split |

|-------|------|-----------|---------|-------------------|----------|------------------|

| Algebra | `algebra` | Linear Equations, Quadratic Expressions, Indices | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |

| Fractions | `fractions` | Simplifying Fractions, Operations, Word Problems | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |

| Geometry Basics | `geometry` | Coordinate Geometry, Circles, Transformations | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |

| Trigonometry | `trigonometry` | Sin/Cos/Tan, Identities, Applications | 3 | 21 | Form 2 | 7 easy, 7 medium, 7 hard |

| Statistics | `statistics` | Mean/Median/Mode, Probability, Data Representation | 3 | 21 | Form 3 | 7 easy, 7 medium, 7 hard |



**Diagnostic assessment:** `KCSE Mathematics Diagnostic` — 20 questions (8 easy, 8 medium, 4 hard) spanning all five topics (4 questions per topic).



---



## Grade Level Filtering



Topics carry `min_grade_sort_order` aligned to `grade_levels.sort_order` within the same curriculum.  

Students see topics where `min_grade_sort_order ≤ student sort_order + 1` (one-form preview/revision tolerance).



| Student stores | Matched via |

|----------------|-------------|

| `Grade 4` … `Grade 9` | `grade_levels.display_name` or `code` for CBC |

| `Form 1` … `Form 4` | `grade_levels.display_name` or `code` for KCSE |



---



## Lesson Content Shape



Each lesson uses JSONB with `blocks` and optional `shortQuiz`:



```json

{

  "blocks": [

    { "type": "heading", "content": "..." },

    { "type": "paragraph", "content": "..." },

    { "type": "example", "title": "...", "steps": ["..."], "answer": "..." },

    { "type": "tip", "content": "..." }

  ],

  "shortQuiz": {

    "questions": [

      { "questionText": "...", "options": ["A", "B", "C"], "correctAnswer": "B" }

    ]

  }

}

```



---



## Seed Location



| File | Purpose |

|------|---------|

| `scripts/generate-curriculum-seed.mjs` | Source generator for math curriculum seed |

| `supabase/seed/curriculum_math.sql` | Topics, subtopics, lessons, practice questions, diagnostics |

| `supabase/seed.sql` | Base curricula, subjects, grade levels (includes math seed via config) |



---



## Acceptance Criteria



- [x] Three topics for CBC (fractions, algebra, geometry basics)

- [x] Five topics for KCSE (algebra, fractions, geometry, trigonometry, statistics)

- [x] At least 3 lessons per topic

- [x] At least 20 practice questions per topic across difficulties

- [x] One diagnostic assessment per curriculum with 20 questions

- [x] Student UI filters content by `student_profiles.curriculum` and `grade_level`

