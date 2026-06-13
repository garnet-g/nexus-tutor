# Mastery Tracking Engine

**Version:** 1.0  
**Naming:** `mastery`, `masteryPercentage` — never `proficiency`

---

## 1. Purpose

Track per-topic mastery percentage that feeds health score, study plans, and progress dashboard.

---

## 2. Data Model

Primary table: `topic_mastery`

```
student_id + topic_id → mastery_percentage (0–100)
last_practiced_at
updated_at
```

---

## 3. Initial State

### From Diagnostic

On diagnostic completion, seed:
```
topic_mastery.mastery_percentage = diagnostic topicScore for each assessed topic
```

Topics not in diagnostic start at 0 or null (display as "Not assessed").

---

## 4. Update Rules

### 4.1 Practice Session Completed

For each topic touched in session:

```
newMastery = (oldMastery × 0.7) + (sessionTopicScore × 0.3)

sessionTopicScore = (correct in topic / total in topic) × 100
```

Cap: `mastery_percentage` ∈ [0, 100]

### 4.2 Lesson Completed

Minor bump for lesson's topic:
```
newMastery = min(100, oldMastery + 2)
```

Only if lesson not previously completed.

### 4.3 Nex Practice Mode Session

Same as practice session — extract topic from session context.

---

## 5. Mastery Bands (UI)

| mastery_percentage | Label | Color Token |
|--------------------|-------|-------------|
| 0–39 | Needs Work | `nexusDanger` |
| 40–69 | Developing | `nexusWarning` |
| 70–89 | Strong | `nexusSuccess` |
| 90–100 | Mastered | `nexusPrimary` |

---

## 6. Badge Triggers

| Badge Code | Condition |
|------------|-----------|
| `algebra_master` | Algebra topic mastery ≥ 90 |
| `first_practice_complete` | First practice session done |

---

## 7. Weak Topic Identification

```
weakTopics = topics where mastery_percentage < 50
             OR in diagnostic weak_topics
             ORDER BY mastery_percentage ASC
             LIMIT 5
```

Used by: Study Plan Engine, Nex context, Parent reports.

---

## 8. Subject-Level Aggregation

V1 (math only):
```
subjectMastery = mean(topic_mastery.mastery_percentage for all topics in subject)
```

V2: aggregate across subjects for overall progress view.

---

## 9. Streak Interaction

Mastery updates do **not** directly affect streaks.  
Streaks updated separately via `student_streaks` on any qualifying daily activity.

---

## 10. API Touchpoints

- `POST /api/practice-sessions/submit` → returns `masteryUpdates[]`
- `GET /api/progress/summary` → full topic mastery list

---

## 11. Acceptance Criteria

- [ ] Mastery updates after every practice session
- [ ] Diagnostic seeds initial mastery values
- [ ] Progress page shows per-topic percentages
- [ ] Weak topics feed dashboard "Continue" recommendation
- [ ] Values never exceed 0–100 range
