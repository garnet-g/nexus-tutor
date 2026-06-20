-- Content generation pipeline: draft review workflow + job audit log.
-- Existing rows default to review_status='published' (no student-facing change).

ALTER TABLE public.lessons
  ADD COLUMN IF NOT EXISTS review_status TEXT NOT NULL DEFAULT 'published'
    CHECK (review_status IN ('draft', 'published', 'archived')),
  ADD COLUMN IF NOT EXISTS generated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS generated_model TEXT;

ALTER TABLE public.practice_questions
  ADD COLUMN IF NOT EXISTS review_status TEXT NOT NULL DEFAULT 'published'
    CHECK (review_status IN ('draft', 'published', 'archived')),
  ADD COLUMN IF NOT EXISTS generated_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS generated_model TEXT;

CREATE INDEX IF NOT EXISTS idx_lessons_review_status
  ON public.lessons (review_status)
  WHERE review_status = 'draft';

CREATE INDEX IF NOT EXISTS idx_practice_questions_review_status
  ON public.practice_questions (review_status)
  WHERE review_status = 'draft';

CREATE TABLE public.content_generation_jobs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  scope_type TEXT NOT NULL CHECK (scope_type IN ('subtopic', 'topic')),
  scope_id UUID NOT NULL,
  curriculum_code TEXT NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('completed', 'failed')),
  lessons_created INTEGER NOT NULL DEFAULT 0,
  questions_created INTEGER NOT NULL DEFAULT 0,
  model TEXT,
  error TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_content_generation_jobs_created
  ON public.content_generation_jobs (created_at DESC);

ALTER TABLE public.content_generation_jobs ENABLE ROW LEVEL SECURITY;

-- Admin-only table: no authenticated policies; service role used by server services.
