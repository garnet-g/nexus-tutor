-- Phase 3: content review workflow (in_review), author seams, lesson versioning.

ALTER TABLE public.lessons
  DROP CONSTRAINT IF EXISTS lessons_review_status_check;

ALTER TABLE public.lessons
  ADD CONSTRAINT lessons_review_status_check
  CHECK (review_status IN ('draft', 'in_review', 'published', 'archived'));

ALTER TABLE public.practice_questions
  DROP CONSTRAINT IF EXISTS practice_questions_review_status_check;

ALTER TABLE public.practice_questions
  ADD CONSTRAINT practice_questions_review_status_check
  CHECK (review_status IN ('draft', 'in_review', 'published', 'archived'));

ALTER TABLE public.lessons
  ADD COLUMN IF NOT EXISTS author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS author_auto_approve_trusted BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS submitted_for_review_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS review_notes TEXT;

ALTER TABLE public.practice_questions
  ADD COLUMN IF NOT EXISTS author_id UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  ADD COLUMN IF NOT EXISTS author_auto_approve_trusted BOOLEAN NOT NULL DEFAULT false,
  ADD COLUMN IF NOT EXISTS submitted_for_review_at TIMESTAMPTZ,
  ADD COLUMN IF NOT EXISTS review_notes TEXT;

UPDATE public.lessons
SET author_id = generated_by
WHERE author_id IS NULL AND generated_by IS NOT NULL;

UPDATE public.practice_questions
SET author_id = generated_by
WHERE author_id IS NULL AND generated_by IS NOT NULL;

CREATE INDEX IF NOT EXISTS idx_lessons_review_status_in_review
  ON public.lessons (review_status)
  WHERE review_status = 'in_review';

CREATE INDEX IF NOT EXISTS idx_practice_questions_review_status_in_review
  ON public.practice_questions (review_status)
  WHERE review_status = 'in_review';

CREATE TABLE IF NOT EXISTS public.lesson_versions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  version_number INTEGER NOT NULL,
  title TEXT NOT NULL,
  content JSONB NOT NULL,
  estimated_minutes INTEGER NOT NULL,
  published_by UUID REFERENCES auth.users(id) ON DELETE SET NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (lesson_id, version_number)
);

CREATE INDEX IF NOT EXISTS idx_lesson_versions_lesson_id
  ON public.lesson_versions (lesson_id, version_number DESC);

ALTER TABLE public.lesson_versions ENABLE ROW LEVEL SECURITY;

-- Service-role only; no authenticated policies (matches content_generation_jobs pattern).
