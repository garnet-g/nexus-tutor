# Database Schema Standard

**Version:** 1.0  
**Authority:** [Naming Guidelines](../product-governance/naming-guidelines.md) overrides MVP draft schema in [MVP](../product-governance/mvp.md)

---

## 1. Conventions

| Rule | Standard |
|------|----------|
| Table names | `snake_case_plural` |
| Column names | `snake_case` |
| Primary keys | `id UUID DEFAULT gen_random_uuid()` |
| Foreign keys | `{entity}_id` |
| Timestamps | `created_at`, `updated_at` TIMESTAMPTZ |
| Booleans | `is_*`, `has_*`, `can_*` |
| Status values | lowercase strings |
| Soft delete | `deleted_at` (nullable) where needed |
| Currency | `amount_kes INTEGER` (whole shillings) |

---

## 2. Migration Naming

```
supabase migration new <verb>_<entity>_<detail>
```

**Examples:**
```
20250613120000_create_student_profiles.sql
20250613120100_create_curriculum_tables.sql
20250613120200_create_diagnostic_assessments.sql
20250613120300_enable_rls_student_profiles.sql
20250613120400_add_indexes_practice_attempts.sql
```

**Rules:**
1. Always create via `supabase migration new <name>` — never invent timestamps manually in production workflow.
2. One logical change per migration when possible.
3. RLS policies in dedicated migration after table creation.
4. Seed data in `supabase/seed/` — not in migrations (except reference data required for FK integrity).
5. Never destructive-drop production tables without explicit approval.

---

## 3. Core Tables

### 3.1 Auth & Profiles

#### `student_profiles`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `user_id` | UUID FK → auth.users UNIQUE | |
| `full_name` | TEXT NOT NULL | |
| `email` | TEXT | Denormalized from auth |
| `phone_number` | TEXT | +254 format |
| `curriculum` | TEXT NOT NULL | `CBC` \| `KCSE` |
| `grade_level` | TEXT NOT NULL | e.g. `Grade 8`, `Form 3` |
| `school_name` | TEXT | |
| `target_grade` | TEXT | e.g. `A`, `B+` |
| `has_completed_diagnostic` | BOOLEAN DEFAULT false | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

**Indexes:** `user_id` (unique), `(curriculum, grade_level)`

#### `parent_profiles`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `user_id` | UUID FK → auth.users UNIQUE | |
| `full_name` | TEXT NOT NULL | |
| `email` | TEXT | |
| `phone_number` | TEXT | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

#### `student_parent_links`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK → student_profiles | |
| `parent_id` | UUID FK → parent_profiles | |
| `link_status` | TEXT | `pending` \| `active` \| `revoked` |
| `invite_code` | TEXT | |
| `linked_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |

**Unique:** `(student_id, parent_id)`

---

### 3.2 Curriculum

#### `curricula`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `code` | TEXT UNIQUE | `CBC`, `KCSE` |
| `name` | TEXT NOT NULL | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |

#### `grade_levels`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `curriculum_id` | UUID FK → curricula | |
| `code` | TEXT | `grade_8`, `form_3` |
| `display_name` | TEXT | `Grade 8`, `Form 3` |
| `sort_order` | INTEGER | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `subjects`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `curriculum_id` | UUID FK → curricula | |
| `code` | TEXT | `mathematics` |
| `name` | TEXT | `Mathematics` |
| `is_active` | BOOLEAN DEFAULT true | |

**V1:** Only Mathematics subject rows seeded.

#### `topics`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `subject_id` | UUID FK → subjects | |
| `code` | TEXT | `algebra` |
| `title` | TEXT NOT NULL | |
| `description` | TEXT | |
| `sort_order` | INTEGER | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `subtopics`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `topic_id` | UUID FK → topics | |
| `code` | TEXT | `linear_equations` |
| `title` | TEXT NOT NULL | |
| `description` | TEXT | |
| `sort_order` | INTEGER | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `lessons`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `subtopic_id` | UUID FK → subtopics | |
| `title` | TEXT NOT NULL | |
| `content` | JSONB NOT NULL | Notes, examples blocks |
| `estimated_minutes` | INTEGER | |
| `sort_order` | INTEGER | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

---

### 3.3 Diagnostic & Health Score

#### `diagnostic_assessments`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `curriculum_id` | UUID FK → curricula | |
| `subject_id` | UUID FK → subjects | |
| `title` | TEXT | |
| `question_count` | INTEGER DEFAULT 20 | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `diagnostic_questions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `diagnostic_assessment_id` | UUID FK | |
| `topic_id` | UUID FK → topics | |
| `subtopic_id` | UUID FK → subtopics NULL | |
| `question_text` | TEXT NOT NULL | |
| `question_type` | TEXT | `multiple_choice` \| `numeric` \| `short_answer` |
| `options` | JSONB | For MCQ |
| `correct_answer` | JSONB NOT NULL | |
| `difficulty` | TEXT | `easy` \| `medium` \| `hard` |
| `sort_order` | INTEGER | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `diagnostic_attempts`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK → student_profiles | |
| `diagnostic_assessment_id` | UUID FK | |
| `assessment_status` | TEXT | `in_progress` \| `completed` \| `abandoned` |
| `started_at` | TIMESTAMPTZ | |
| `completed_at` | TIMESTAMPTZ | |

**Unique (partial):** one `completed` attempt per student per assessment (enforced via app + unique index on `(student_id, diagnostic_assessment_id) WHERE assessment_status = 'completed'`)

#### `diagnostic_results`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `diagnostic_attempt_id` | UUID FK UNIQUE | |
| `student_id` | UUID FK → student_profiles | |
| `diagnostic_score` | NUMERIC(5,2) | 0–100 |
| `health_score` | NUMERIC(5,2) | Same as overall for V1 math-only |
| `strong_topics` | JSONB | Array of topic IDs/names |
| `weak_topics` | JSONB | Array of topic IDs/names |
| `recommended_topics` | JSONB | |
| `created_at` | TIMESTAMPTZ | |

#### `academic_health_scores`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK → student_profiles | |
| `subject_id` | UUID FK → subjects | |
| `health_score` | NUMERIC(5,2) | 0–100 |
| `topic_scores` | JSONB | `{ topicId: score }` |
| `predicted_grade` | TEXT | e.g. `B-` |
| `calculated_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |

**Index:** `(student_id, subject_id, calculated_at DESC)`

---

### 3.4 Practice

#### `practice_questions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `topic_id` | UUID FK → topics | |
| `subtopic_id` | UUID FK → subtopics NULL | |
| `question_text` | TEXT NOT NULL | |
| `question_type` | TEXT | |
| `options` | JSONB | |
| `correct_answer` | JSONB NOT NULL | |
| `difficulty` | TEXT | `easy` \| `medium` \| `hard` |
| `explanation` | TEXT | |
| `is_active` | BOOLEAN DEFAULT true | |

#### `practice_sessions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK → student_profiles | |
| `topic_id` | UUID FK → topics | |
| `difficulty` | TEXT | |
| `question_count` | INTEGER DEFAULT 10 | |
| `session_status` | TEXT | `in_progress` \| `completed` \| `abandoned` |
| `started_at` | TIMESTAMPTZ | |
| `completed_at` | TIMESTAMPTZ | |

#### `practice_attempts`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `practice_session_id` | UUID FK | |
| `practice_question_id` | UUID FK | |
| `student_answer` | JSONB | |
| `is_correct` | BOOLEAN | |
| `time_spent_seconds` | INTEGER | |
| `created_at` | TIMESTAMPTZ | |

#### `practice_results`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `practice_session_id` | UUID FK UNIQUE | |
| `student_id` | UUID FK | |
| `practice_score` | NUMERIC(5,2) | |
| `correct_answers` | INTEGER | |
| `incorrect_answers` | INTEGER | |
| `time_spent_seconds` | INTEGER | |
| `weak_topics` | JSONB | |
| `created_at` | TIMESTAMPTZ | |

---

### 3.5 Progress & Gamification

#### `student_progress`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `subject_id` | UUID FK | |
| `total_study_time_seconds` | INTEGER DEFAULT 0 | |
| `lessons_completed` | INTEGER DEFAULT 0 | |
| `practice_sessions_completed` | INTEGER DEFAULT 0 | |
| `updated_at` | TIMESTAMPTZ | |

#### `topic_mastery`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `topic_id` | UUID FK | |
| `mastery_percentage` | NUMERIC(5,2) DEFAULT 0 | 0–100 |
| `last_practiced_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

**Unique:** `(student_id, topic_id)`

#### `study_time_logs`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `activity_type` | TEXT | `lesson` \| `practice` \| `nex` \| `diagnostic` |
| `activity_id` | UUID | Polymorphic reference |
| `duration_seconds` | INTEGER | |
| `logged_at` | TIMESTAMPTZ | |

#### `student_streaks`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK UNIQUE | |
| `current_streak` | INTEGER DEFAULT 0 | |
| `longest_streak` | INTEGER DEFAULT 0 | |
| `last_activity_date` | DATE | Kenya timezone |
| `updated_at` | TIMESTAMPTZ | |

#### `student_xp`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK UNIQUE | |
| `total_xp` | INTEGER DEFAULT 0 | |
| `current_level` | INTEGER DEFAULT 1 | |
| `updated_at` | TIMESTAMPTZ | |

#### `student_badges`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `badge_code` | TEXT | `seven_day_streak`, `algebra_master`, etc. |
| `earned_at` | TIMESTAMPTZ | |

**Unique:** `(student_id, badge_code)`

---

### 3.6 Study Plans

#### `study_plans`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `title` | TEXT | |
| `plan_type` | TEXT | `daily` \| `exam` |
| `exam_countdown_days` | INTEGER NULL | For exam plans |
| `target_completion_date` | DATE | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |

#### `study_tasks`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `study_plan_id` | UUID FK | |
| `topic_id` | UUID FK NULL | |
| `task_title` | TEXT NOT NULL | |
| `task_type` | TEXT | `lesson` \| `practice` \| `revision` |
| `scheduled_date` | DATE | |
| `daily_goal_minutes` | INTEGER | |
| `is_completed` | BOOLEAN DEFAULT false | |
| `completed_at` | TIMESTAMPTZ | |

#### `daily_goals`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `goal_date` | DATE | |
| `daily_goal_minutes` | INTEGER DEFAULT 20 | |
| `minutes_completed` | INTEGER DEFAULT 0 | |
| `is_completed` | BOOLEAN DEFAULT false | |

**Unique:** `(student_id, goal_date)`

---

### 3.7 Nex AI

#### `nex_sessions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `session_mode` | TEXT | `explain` \| `practice` \| `homework` \| `revision` \| `assessment` (assessment V2 UI) |
| `metadata` | JSONB | `hintLevel`, `attemptCount`, mode state |
| `topic_id` | UUID FK NULL | |
| `is_active` | BOOLEAN DEFAULT true | |
| `started_at` | TIMESTAMPTZ | |
| `ended_at` | TIMESTAMPTZ | |

#### `nex_messages`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `nex_session_id` | UUID FK | |
| `student_id` | UUID FK | |
| `role` | TEXT | `student` \| `nex` |
| `message_content` | TEXT NOT NULL | |
| `metadata` | JSONB | mode hints, topic refs |
| `created_at` | TIMESTAMPTZ | |

### Student Memory (V1 — no separate table)

Nex "memory" in V1 is **derived at request time** from:

- `topic_mastery`, `diagnostic_results`, `academic_health_scores`
- `study_time_logs`, `student_streaks`, recent `nex_messages` (last 10 turns)
- Optional `student_profiles.metadata` JSONB for `commonErrors[]` when detected

Do not send full chat history to the model. V2 may add dedicated memory tables.

#### `nex_recommendations`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `recommendation_type` | TEXT | `topic` \| `practice` \| `study_plan` |
| `recommendation_payload` | JSONB | |
| `is_dismissed` | BOOLEAN DEFAULT false | |
| `created_at` | TIMESTAMPTZ | |

---

### 3.8 Subscriptions & Payments

#### `subscription_plans`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `plan_code` | TEXT UNIQUE | `free`, `premium`, `family` |
| `name` | TEXT | |
| `amount_kes` | INTEGER | 0 for free; **editable by super_admin** |
| `billing_cycle` | TEXT | `monthly` |
| `is_active` | BOOLEAN DEFAULT true | |
| `promotion_label` | TEXT NULL | e.g. `Exam Season Sale` |
| `updated_at` | TIMESTAMPTZ | |
| `updated_by_user_id` | UUID FK → auth.users NULL | Last super_admin edit |

#### `student_subscriptions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `subscription_plan_id` | UUID FK | |
| `subscription_status` | TEXT | `trialing` \| `active` \| `past_due` \| `cancelled` \| `expired` |
| `trial_started_at` | TIMESTAMPTZ | |
| `trial_ends_at` | TIMESTAMPTZ | |
| `current_period_start` | TIMESTAMPTZ | |
| `current_period_end` | TIMESTAMPTZ | |
| `cancelled_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

#### `subscription_trials`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK UNIQUE | |
| `trial_started_at` | TIMESTAMPTZ | |
| `trial_ends_at` | TIMESTAMPTZ | |
| `is_trial_active` | BOOLEAN | |
| `converted_at` | TIMESTAMPTZ | |

#### `mpesa_payments`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `subscription_plan_id` | UUID FK | |
| `phone_number` | TEXT NOT NULL | |
| `amount_kes` | INTEGER NOT NULL | |
| `checkout_request_id` | TEXT UNIQUE | |
| `merchant_request_id` | TEXT | |
| `mpesa_receipt_number` | TEXT | |
| `payment_status` | TEXT | `pending` \| `processing` \| `paid` \| `failed` \| `cancelled` \| `expired` \| `refunded` |
| `paid_at` | TIMESTAMPTZ | |
| `expires_at` | TIMESTAMPTZ | STK timeout |
| `created_at` | TIMESTAMPTZ | |
| `updated_at` | TIMESTAMPTZ | |

#### `mpesa_callbacks`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `mpesa_payment_id` | UUID FK | |
| `checkout_request_id` | TEXT | |
| `callback_payload` | JSONB NOT NULL | Raw Daraja payload |
| `result_code` | INTEGER | |
| `result_description` | TEXT | |
| `is_processed` | BOOLEAN DEFAULT false | |
| `processed_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |

**Unique:** `(checkout_request_id, result_code, mpesa_receipt_number)` where receipt present — dedupe index

#### `payment_transactions`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `mpesa_payment_id` | UUID FK | |
| `student_subscription_id` | UUID FK | |
| `transaction_type` | TEXT | `subscription_payment` |
| `amount_kes` | INTEGER | |
| `created_at` | TIMESTAMPTZ | |

#### `billing_events`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_subscription_id` | UUID FK | |
| `event_type` | TEXT | `trial_started`, `payment_received`, `subscription_expired` |
| `event_payload` | JSONB | |
| `created_at` | TIMESTAMPTZ | |

#### `invoices`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK | |
| `mpesa_payment_id` | UUID FK | |
| `amount_kes` | INTEGER | |
| `invoice_status` | TEXT | `paid` \| `void` |
| `issued_at` | TIMESTAMPTZ | |

---

### 3.9 Notifications

#### `sms_templates`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `template_code` | TEXT UNIQUE | |
| `sms_body_template` | TEXT | With `{{placeholders}}` |
| `is_active` | BOOLEAN DEFAULT true | |

#### `celcom_sms_logs`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `student_id` | UUID FK NULL | |
| `parent_id` | UUID FK NULL | |
| `phone_number` | TEXT | |
| `sms_body` | TEXT | |
| `template_code` | TEXT | |
| `celcom_message_id` | TEXT | |
| `sms_status` | TEXT | `queued` \| `sent` \| `delivered` \| `failed` |
| `sent_at` | TIMESTAMPTZ | |
| `delivered_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |

#### `email_templates`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `template_code` | TEXT UNIQUE | |
| `email_subject_template` | TEXT | |
| `email_body_template` | TEXT | HTML |
| `is_active` | BOOLEAN DEFAULT true | |

#### `resend_email_logs`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `recipient_email` | TEXT | |
| `email_subject` | TEXT | |
| `template_code` | TEXT | |
| `resend_email_id` | TEXT | Provider ID |
| `email_status` | TEXT | `queued` \| `sent` \| `delivered` \| `opened` \| `failed` \| `bounced` |
| `sent_at` | TIMESTAMPTZ | |
| `created_at` | TIMESTAMPTZ | |

---

### 3.10 Platform Admin

#### `super_admin_profiles`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `user_id` | UUID FK → auth.users UNIQUE | |
| `full_name` | TEXT NOT NULL | |
| `email` | TEXT | |
| `is_active` | BOOLEAN DEFAULT true | |
| `created_at` | TIMESTAMPTZ | |

`app_metadata.userRole = 'super_admin'` required.

#### `platform_settings`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `setting_key` | TEXT UNIQUE | See platform-admin-system.md |
| `setting_value` | JSONB NOT NULL | Typed value stored as JSON |
| `updated_at` | TIMESTAMPTZ | |
| `updated_by_user_id` | UUID FK → auth.users | |

**Seed keys:** `free_daily_nex_message_limit`, `free_daily_practice_session_limit`, `premium_daily_nex_message_limit`, `premium_daily_practice_session_limit`, `family_max_students`, `promotion_is_active`, `promotion_title`, `promotion_ends_at`, `promotion_premium_amount_kes`

#### `platform_settings_audit_log`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `super_admin_user_id` | UUID FK → auth.users | |
| `change_type` | TEXT | `platform_setting` \| `subscription_plan` \| `promotion` |
| `setting_key` | TEXT | |
| `previous_value` | JSONB | |
| `new_value` | JSONB | |
| `change_reason` | TEXT NULL | Admin note |
| `created_at` | TIMESTAMPTZ | |

**Append-only** — no UPDATE/DELETE policies.

---

### 3.11 Parent Reports

#### `parent_reports`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `parent_id` | UUID FK | |
| `student_id` | UUID FK | |
| `report_type` | TEXT | `weekly` |
| `report_payload` | JSONB | |
| `generated_at` | TIMESTAMPTZ | |

#### `weekly_reports`

| Column | Type | Notes |
|--------|------|-------|
| `id` | UUID PK | |
| `parent_report_id` | UUID FK | |
| `week_start_date` | DATE | |
| `weekly_study_minutes` | INTEGER | |
| `weekly_health_score` | NUMERIC(5,2) | |
| `weekly_weak_topics` | JSONB | |
| `predicted_grade` | TEXT | |
| `created_at` | TIMESTAMPTZ | |

---

## 4. Relationships Summary

```
auth.users
  ├── student_profiles (1:1)
  │     ├── diagnostic_attempts → diagnostic_results
  │     ├── academic_health_scores
  │     ├── practice_sessions → practice_attempts → practice_results
  │     ├── topic_mastery, student_progress, student_streaks, student_xp, student_badges
  │     ├── study_plans → study_tasks, daily_goals
  │     ├── nex_sessions → nex_messages, nex_recommendations
  │     ├── student_subscriptions → subscription_trials
  │     └── mpesa_payments → mpesa_callbacks → payment_transactions
  └── parent_profiles (1:1)
        └── student_parent_links → student_profiles

curricula → grade_levels
curricula → subjects → topics → subtopics → lessons
subjects → diagnostic_assessments → diagnostic_questions
topics → practice_questions
```

---

## 5. RLS Rules

### 5.1 Global

- `ALTER TABLE ... ENABLE ROW LEVEL SECURITY` on all public tables.
- No policy = no access for `authenticated` role.

### 5.2 Student Policies

| Table | SELECT | INSERT | UPDATE | DELETE |
|-------|--------|--------|--------|--------|
| `student_profiles` | own (`user_id = auth.uid()`) | own on signup | own | — |
| Curriculum content tables | all authenticated (read-only) | — | — | — |
| `diagnostic_*`, `practice_*`, `nex_*` | own student_id | own | own in-progress | — |
| `topic_mastery`, `student_progress`, streaks, xp, badges | own | via server/service | via server/service | — |
| `student_subscriptions` | own | server | server | — |
| `mpesa_payments` | own | own initiate | server only | — |

**Helper function (recommended):**
```sql
CREATE FUNCTION auth_student_id() RETURNS UUID AS $$
  SELECT id FROM student_profiles WHERE user_id = auth.uid()
$$ LANGUAGE sql STABLE SECURITY DEFINER SET search_path = public;
```

### 5.3 Parent Policies

| Table | Access |
|-------|--------|
| Linked student progress, health scores, reports | SELECT where `student_parent_links.link_status = 'active'` |
| `parent_profiles` | own row only |
| Curriculum content | SELECT (read-only) |
| Mutations on student data | **Denied** |

### 5.4 Service Role Bypass

Webhooks and subscription activation use service role client — never exposed to browser.

### 5.5 Super Admin Policies

| Table | Access |
|-------|--------|
| `platform_settings` | No student/parent access. Read/write via server after `super_admin` session check |
| `platform_settings_audit_log` | Append-only via server; SELECT for super_admin audit UI |
| `subscription_plans` | Public SELECT for pricing page. UPDATE super_admin via server only |
| `super_admin_profiles` | Own row for super_admin |

Never expose direct `platform_settings` writes to student/parent JWTs.

---

## 6. Indexes

### Required Indexes

| Table | Index | Purpose |
|-------|-------|---------|
| `student_profiles` | `user_id` UNIQUE | Auth lookup |
| `student_parent_links` | `(student_id, parent_id)` UNIQUE | Link integrity |
| `diagnostic_attempts` | `(student_id, diagnostic_assessment_id)` | Completion check |
| `topic_mastery` | `(student_id, topic_id)` UNIQUE | Upsert mastery |
| `practice_sessions` | `(student_id, started_at DESC)` | History |
| `nex_messages` | `(nex_session_id, created_at)` | Chat history |
| `mpesa_payments` | `checkout_request_id` UNIQUE | Callback lookup |
| `mpesa_callbacks` | `(checkout_request_id)` | Dedupe |
| `academic_health_scores` | `(student_id, calculated_at DESC)` | Latest score |
| `study_time_logs` | `(student_id, logged_at DESC)` | Weekly aggregation |
| `daily_goals` | `(student_id, goal_date)` UNIQUE | Daily goal |
| `celcom_sms_logs` | `(phone_number, created_at DESC)` | Debug |
| `resend_email_logs` | `(recipient_email, created_at DESC)` | Debug |
| `platform_settings` | `setting_key` UNIQUE | Settings lookup |
| `platform_settings_audit_log` | `(created_at DESC)` | Audit UI |

### Partial Indexes

```sql
CREATE UNIQUE INDEX idx_diagnostic_one_completed
  ON diagnostic_attempts (student_id, diagnostic_assessment_id)
  WHERE assessment_status = 'completed';
```

---

## 7. Triggers (Recommended)

| Trigger | Purpose |
|---------|---------|
| `set_updated_at` | Auto-update `updated_at` on row change |
| `on_auth_user_created` | Create `student_profiles` or `parent_profiles` stub |
| `on_diagnostic_completed` | Compute `diagnostic_results`, set `has_completed_diagnostic` |
| `on_practice_completed` | Update `topic_mastery`, `student_xp`, streak |

**Implementation:** Prefer server services in V1 for clarity; migrate hot paths to triggers when performance requires.

---

## 8. Seed Data Requirements (V1)

1. `curricula`: CBC, KCSE
2. `grade_levels`: Grade 4–9, Form 1–4
3. `subjects`: Mathematics (both curricula)
4. `topics` / `subtopics` / `lessons`: MVP math content
5. `diagnostic_assessments` + 20 questions per curriculum variant
6. `practice_questions`: pool per topic × difficulty
7. `subscription_plans`: free, premium, family
8. `sms_templates`, `email_templates`: see Notification Spec
