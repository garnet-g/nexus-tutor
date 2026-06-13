# Academic Health Score Engine

**Version:** 1.0  
**Display Name:** Academic Health Score™  
**Code Name:** `healthScore` (never `academicScore`)

---

## 1. Purpose

Provide a single, understandable metric of a student's academic standing — updated from diagnostic results and ongoing practice.

---

## 2. Initial Score (Diagnostic)

Generated on first diagnostic completion.

### 2.1 Input

- 20 diagnostic questions (Mathematics)
- Per-question: `is_correct`, `difficulty`, `topic_id`

### 2.2 Calculation

```
questionWeight = { easy: 1.0, medium: 1.5, hard: 2.0 }

weightedScore = Σ(correct × questionWeight) / Σ(questionWeight) × 100

healthScore = round(weightedScore, 0)   // 0–100 integer display
```

### 2.3 Subject Breakdown (V1 Math-Only)

```
subjectScore (Mathematics) = healthScore   // single subject in V1
```

### 2.4 Topic Breakdown

Per topic:
```
topicScore = (correct in topic / total in topic) × 100
```

Classify:
- **Strong:** topicScore ≥ 70
- **Weak:** topicScore < 50
- **Recommended:** weakest 2–3 topics for study plan

### 2.5 Output Record

Persist to:
- `diagnostic_results` (snapshot at completion)
- `academic_health_scores` (latest rolling record)

---

## 3. Ongoing Updates

Recalculate `healthScore` when:

| Event | Weight |
|-------|--------|
| Diagnostic completed | Full reset baseline |
| Practice session completed | Incremental adjustment |
| Lesson completed | Minor bump (+0–2 points max per lesson) |

### 3.1 Rolling Formula (Post-Diagnostic)

```
healthScore = (diagnosticBaseline × 0.4)
            + (averageTopicMastery × 0.5)
            + (recentPracticePerformance × 0.1)
```

Where:
- `averageTopicMastery` = mean of all `topic_mastery.mastery_percentage` for subject
- `recentPracticePerformance` = mean score of last 5 practice sessions

### 3.2 Update Frequency

- Recalculate on practice completion (async/server)
- Dashboard reads latest `academic_health_scores` row
- Do not recalculate on every page load

---

## 4. Predicted Grade Engine

Maps `healthScore` to curriculum-specific grade labels.

### 4.1 KCSE Mapping (Mathematics)

| healthScore | Predicted Grade |
|-------------|-----------------|
| 80–100 | A |
| 75–79 | A- |
| 70–74 | B+ |
| 65–69 | B |
| 60–64 | B- |
| 55–59 | C+ |
| 50–54 | C |
| 45–49 | C- |
| 40–44 | D+ |
| 35–39 | D |
| 30–34 | D- |
| 0–29 | E |

### 4.2 CBC Mapping

Use competency bands (V1 simplified):

| healthScore | Band |
|-------------|------|
| 80–100 | Exceeding Expectations |
| 60–79 | Meeting Expectations |
| 40–59 | Approaching Expectations |
| 0–39 | Below Expectations |

Store as `predicted_grade` text field.

---

## 5. Dashboard Display

```
Academic Health Score: 67/100
Predicted KCSE Grade: B-
Math: 67%
Strong: ✓ Geometry
Weak: ✗ Algebra, ✗ Fractions
```

---

## 6. Parent Visibility

Parents see:
- Latest `healthScore`
- `predicted_grade`
- `weeklyWeakTopics` in weekly report

Parents do **not** see raw diagnostic question answers.

---

## 7. API Touchpoints

- `POST /api/diagnostic-assessments/submit` → initial score
- `POST /api/practice-sessions/submit` → triggers recalculation
- `GET /api/progress/summary` → returns latest scores

---

## 8. V2 Extensions (Not V1)

- Multi-subject health score breakdown (Science, English)
- Trend graphs (30/60/90 day)
- School benchmark comparison

**Flag:** PRD shows multi-subject diagnostic; V1 is math-only per MVP scope lock.
