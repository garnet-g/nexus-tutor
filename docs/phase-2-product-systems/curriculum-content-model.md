# Curriculum Content Model

**Version:** 1.0  
**Naming:** curriculum → gradeLevel → subject → topic → subtopic → lesson

---

## 1. Hierarchy

```
Curriculum (CBC | KCSE)
  └── Grade Level (Grade 4–9 | Form 1–4)
        └── Subject (Mathematics — V1 only)
              └── Topic (Algebra, Geometry, ...)
                    └── Subtopic (Linear Equations, ...)
                          └── Lesson (notes + examples)
```

**Banned terms:** syllabus, unit, class (use curriculum, topic, lesson)

---

## 2. Curricula

| code | name | Grade Levels |
|------|------|--------------|
| `CBC` | Competency-Based Curriculum | Grade 4, 5, 6, 7, 8, 9 |
| `KCSE` | Kenya Certificate of Secondary Education | Form 1, 2, 3, 4 |

Student selects one curriculum at onboarding. Content filtered by `student_profiles.curriculum`.

---

## 3. Subjects (V1)

| code | name | V1 Status |
|------|------|-----------|
| `mathematics` | Mathematics | **Active** |
| `science` | Science | V2 |
| `english` | English | V2 |
| `kiswahili` | Kiswahili | V2 |

---

## 4. Topics & Subtopics (V1 Mathematics)

### CBC Mathematics

| Topic | Subtopics (Examples) |
|-------|---------------------|
| Fractions | Introduction, Equivalent Fractions, Operations |
| Algebra | Expressions, Simple Equations, Linear Equations |
| Geometry | Shapes, Angles, Area & Perimeter |

### KCSE Mathematics

| Topic | Subtopics (Examples) |
|-------|---------------------|
| Algebra | Linear Equations, Quadratic Equations, Indices |
| Trigonometry | Sin/Cos/Tan, Identities, Applications |
| Statistics | Mean/Median/Mode, Probability, Data Representation |
| Geometry | Coordinate Geometry, Circles, Transformations |

---

## 5. Lessons

Each lesson belongs to one subtopic.

### Lesson Content Structure (JSONB)

```json
{
  "blocks": [
    {
      "type": "heading",
      "content": "Introduction to Linear Equations"
    },
    {
      "type": "paragraph",
      "content": "A linear equation is..."
    },
    {
      "type": "example",
      "title": "Worked Example 1",
      "steps": [
        "Step 1: ...",
        "Step 2: ..."
      ],
      "answer": "x = 4"
    },
    {
      "type": "tip",
      "content": "Remember to balance both sides."
    }
  ],
  "shortQuiz": {
    "questions": [
      {
        "questionText": "...",
        "options": ["A", "B", "C"],
        "correctAnswer": "B"
      }
    ]
  }
}
```

**V1:** No videos. Notes + examples + optional short quiz per lesson.

---

## 6. Question Difficulty Levels

| Level | Code | Description |
|-------|------|-------------|
| Easy | `easy` | Single-step, foundational |
| Medium | `medium` | Multi-step, typical exam level |
| Hard | `hard` | Complex, extension/challenge |

Used in: diagnostic questions, practice questions, Nex practice mode.

### Distribution Guidelines

| Context | Easy | Medium | Hard |
|---------|------|--------|------|
| Diagnostic | 40% | 40% | 20% |
| Practice (student-selected) | 100% of selected level | | |
| Nex adaptive | Dynamic | Dynamic | Dynamic |

---

## 7. Practice Questions

Linked to `topic_id` and optionally `subtopic_id`.

Fields:
- `question_text`, `question_type`, `options`, `correct_answer`
- `difficulty`, `explanation`
- `is_active`

Pool size target: ≥20 questions per topic per difficulty for V1 launch.

---

## 8. Knowledge Graph (Conceptual)

PRD describes prerequisite mapping:

```
Linear Equations
  ← depends on: Fractions, Integers, Basic Algebra
```

**V1 implementation:** Store as optional `prerequisite_topic_ids UUID[]` on `topics` table (seed data).

Study Plan Engine uses prerequisites to suggest foundational review when advanced topic mastery is low.

**V2:** Full graph visualization and automated gap detection.

---

## 9. Mastery Calculation

See [Mastery Tracking Engine](./mastery-tracking-engine.md).

Topic mastery rolls up to subject; subject contributes to `healthScore`.

---

## 10. Content Authoring Rules

1. All content aligned to KICD/CBC or KNEC/KCSE standards
2. Use Kenyan contexts in word problems
3. Grade-appropriate vocabulary
4. One concept focus per lesson
5. Every subtopic has ≥1 lesson before launch
6. Content changes require seed/migration update — not hardcoded in UI

---

## 11. Grade Level Filtering

Lessons tagged with applicable grade levels via join table or `grade_levels` FK on topics (implementation choice — document in migration).

Student sees content for:
- Their `curriculum`
- Their `grade_level` ± 1 grade tolerance for revision

---

## 12. API Content Delivery

| Endpoint | Returns |
|----------|---------|
| `GET /api/learn/subjects` | Subject tree |
| `GET /api/learn/topics/:id` | Subtopics + lessons |
| `GET /api/learn/lessons/:id` | Full lesson JSONB |

Content tables are **read-only** for students (RLS SELECT only).

---

## 13. V2 Content Expansion

- Science, English, Kiswahili subjects
- Cambridge curriculum branch
- Video blocks in lesson JSONB
- Interactive manipulatives

**Do not add in V1 without scope lock amendment.**
