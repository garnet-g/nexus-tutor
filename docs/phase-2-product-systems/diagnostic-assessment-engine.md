# Diagnostic Assessment Engine

**Version:** 1.0

---

## 1. Purpose

First-time onboarding assessment that establishes baseline `healthScore`, topic strengths/weaknesses, and learning path.

**Gate:** Students cannot access main dashboard until diagnostic is completed.

---

## 2. Assessment Spec (V1)

| Property | Value |
|----------|-------|
| Subject | Mathematics only |
| Question count | 20 |
| Time limit | None (V1) |
| Retakes | One completed attempt per student per curriculum variant |
| Difficulty mix | ~40% easy, ~40% medium, ~20% hard |

---

## 3. Topic Coverage

### CBC (Grade 4–9)

| Topic | Approx Questions |
|-------|------------------|
| Fractions | 5–7 |
| Algebra | 6–8 |
| Geometry | 5–7 |

### KCSE (Form 1–4)

| Topic | Approx Questions |
|-------|------------------|
| Algebra | 7–9 |
| Trigonometry | 4–6 |
| Statistics | 4–6 |

Questions selected from `diagnostic_questions` seeded per curriculum assessment.

---

## 4. Flow

```
Student completes onboarding (curriculum + grade)
    ↓
Redirect to /onboarding/diagnostic
    ↓
POST /api/diagnostic-assessments/start
    ↓
Student answers 20 questions (client UI, one-at-a-time or paginated)
    ↓
POST /api/diagnostic-assessments/submit
    ↓
Engine calculates scores
    ↓
Persist diagnostic_results + academic_health_scores
    ↓
Set has_completed_diagnostic = true
    ↓
Generate initial study_plan (optional, premium/trial)
    ↓
Redirect to dashboard
```

---

## 5. Scoring Engine

See [Academic Health Score Engine](./academic-health-score-engine.md) for formulas.

Additional outputs:
- `strong_topics[]` — topicScore ≥ 70
- `weak_topics[]` — topicScore < 50
- `recommended_topics[]` — bottom 3 weak topics prioritized

---

## 6. State Machine

```
diagnostic_attempt.assessment_status:

  [start] → in_progress
  in_progress → completed (submit)
  in_progress → abandoned (24h timeout, optional V1)
```

**Conflict:** Attempting start when completed → `409 CONFLICT`

---

## 7. Question Selection Algorithm

1. Load `diagnostic_assessment` for student's curriculum
2. Group questions by topic
3. Select proportional count per topic table above
4. Shuffle within topic, then interleave for variety
5. Return 20 questions without `correct_answer` exposed

---

## 8. Answer Grading

| question_type | Grading |
|---------------|---------|
| `multiple_choice` | Exact match |
| `numeric` | Numeric equivalence (tolerance 0.01) |
| `short_answer` | Normalized string match (V1); AI grading V2 |

---

## 9. Post-Diagnostic Actions

| Action | Trigger |
|--------|---------|
| Update `topic_mastery` | Seed initial values from topic scores |
| Award badge | `first_diagnostic_complete` |
| Award XP | +100 XP |
| Create `daily_goals` | Default 20 minutes |
| Nex recommendation | Suggest top weak topic |

---

## 10. Data Integrity

- Unique completed attempt per `(student_id, diagnostic_assessment_id)`
- Answers immutable after submit
- Results linked 1:1 to attempt

---

## 11. Acceptance Criteria

- [ ] New student forced through diagnostic before dashboard
- [ ] Exactly 20 questions presented
- [ ] healthScore displayed within 3 seconds of submit
- [ ] Weak/strong topics match score thresholds
- [ ] Retake blocked with clear message
- [ ] CBC and KCSE students get curriculum-appropriate questions
