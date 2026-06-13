# Study Plan Engine

**Version:** 1.0  
**Naming:** `studyPlan`, `studyTask`, `dailyGoal` — use `examStudyPlan` for exam-focused plans

---

## 1. Purpose

Generate personalized daily learning actions based on weak topics, exam countdown, and available study time.

---

## 2. Plan Types

| plan_type | Trigger | Output |
|-----------|---------|--------|
| `daily` | Post-diagnostic, dashboard | Today's recommended tasks |
| `exam` | Nex revision mode / manual | Multi-day countdown plan |

---

## 3. Inputs

```ts
{
  studentId,
  curriculum,
  gradeLevel,
  healthScore,
  weakTopics: Topic[],
  topicMastery: Record<topicId, number>,
  examCountdownDays?: number,
  dailyGoalMinutes: number,  // default 20
  targetCompletionDate?: Date
}
```

---

## 4. Generation Logic

### 4.1 Daily Plan (Default)

1. Select top 1–2 weak topics by lowest mastery
2. Create tasks:
   - **Lesson task** — incomplete lesson in weak subtopic
   - **Practice task** — 10 questions, medium difficulty
   - **Nex task** (optional) — "Review {topic} with Nex"
3. Allocate minutes to fit `dailyGoalMinutes`
4. Persist `study_plan` (single active daily) + `study_tasks` for today

### 4.2 Exam Plan (Revision Mode)

1. Confirm `examCountdownDays` (e.g., 14)
2. Rank topics by: `(1 - mastery) × examWeight`
3. Distribute topics across remaining days
4. Front-load weakest topics in first 60% of days
5. Last 20% of days → mixed revision practice
6. Create `study_tasks` with `scheduled_date` per day

**Exam weight defaults (KCSE Math V1):**

| Topic | Weight |
|-------|--------|
| Algebra | 0.35 |
| Trigonometry | 0.25 |
| Statistics | 0.20 |
| Geometry | 0.20 |

Adjust per curriculum seed data.

---

## 5. Task Types

| task_type | Activity |
|-----------|----------|
| `lesson` | Complete specific lesson |
| `practice` | 10-question session |
| `revision` | Mixed review / Nex session |

---

## 6. Daily Goals

Separate from study plan — tracks time commitment:

```
daily_goals:
  goal_date: today (Africa/Nairobi)
  daily_goal_minutes: 20
  minutes_completed: aggregated from study_time_logs
  is_completed: minutes_completed >= daily_goal_minutes
```

Update `minutes_completed` on lesson/practice/nex activity completion.

---

## 7. Completion & Progress

- Student marks task complete OR auto-complete when linked activity finishes
- `is_completed = true`, `completed_at` set
- Incomplete tasks roll to next day (exam plans) or regenerate (daily plans)

---

## 8. Nex Integration

Revision mode in Nex calls:
```
generateStudyPlan({ examCountdownDays, dailyGoalMinutes })
```
Returns human-readable plan + persists to DB.

---

## 9. Subscription Gate

| Feature | Free | Premium/Trial |
|---------|------|---------------|
| Basic daily recommendation (1 topic) | ✓ | ✓ |
| Full exam countdown plan | — | ✓ |
| Plan regeneration | Limited | Unlimited |

---

## 10. API Touchpoints

- `GET /api/study-plans/active`
- `POST /api/study-plans/generate`
- `PATCH /api/study-plans/tasks/:taskId/complete`

---

## 11. Acceptance Criteria

- [ ] Dashboard shows today's goal and recommended topic
- [ ] Exam plan spans correct number of days
- [ ] Weak topics prioritized over strong topics
- [ ] Daily goal tracks actual study time
- [ ] Plan respects `dailyGoalMinutes` constraint
