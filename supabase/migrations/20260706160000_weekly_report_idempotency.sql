-- PR-131: Idempotent weekly parent reports per parent/student/week.
ALTER TABLE public.parent_reports
  ADD COLUMN IF NOT EXISTS week_start_date DATE;

CREATE UNIQUE INDEX IF NOT EXISTS uq_parent_weekly_report_per_week
  ON public.parent_reports (parent_id, student_id, week_start_date)
  WHERE report_type = 'weekly' AND week_start_date IS NOT NULL;
