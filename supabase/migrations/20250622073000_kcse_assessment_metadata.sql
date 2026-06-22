-- KCSE assessment engine metadata

ALTER TABLE public.mock_exam_sessions
  ADD COLUMN IF NOT EXISTS subject_code TEXT NOT NULL DEFAULT 'mathematics',
  ADD COLUMN IF NOT EXISTS assessment_metadata JSONB NOT NULL DEFAULT '{}';

ALTER TABLE public.mock_exam_questions
  ADD COLUMN IF NOT EXISTS pattern_tags JSONB NOT NULL DEFAULT '[]';

ALTER TABLE public.mock_exam_results
  ADD COLUMN IF NOT EXISTS topic_pattern_summaries JSONB NOT NULL DEFAULT '[]';

CREATE INDEX IF NOT EXISTS idx_mock_exam_sessions_subject
  ON public.mock_exam_sessions(student_id, subject_code, created_at DESC);
