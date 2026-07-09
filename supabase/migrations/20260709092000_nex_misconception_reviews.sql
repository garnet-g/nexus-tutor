-- Spaced-repetition schedule for misconceptions detected in Nex homework
-- and assessment sessions. Complements the flat commonErrors list already
-- stored on student_profiles.metadata (kept as-is for prompt context).

CREATE TABLE public.nex_misconception_reviews (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  error_code TEXT NOT NULL,
  description TEXT NOT NULL,
  review_count INTEGER NOT NULL DEFAULT 0,
  next_review_at TIMESTAMPTZ NOT NULL DEFAULT (NOW() + INTERVAL '2 days'),
  last_reviewed_at TIMESTAMPTZ,
  resolved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, error_code)
);

CREATE INDEX idx_nex_misconception_reviews_due
  ON public.nex_misconception_reviews(student_id, next_review_at)
  WHERE resolved_at IS NULL;

ALTER TABLE public.nex_misconception_reviews ENABLE ROW LEVEL SECURITY;

CREATE POLICY nex_misconception_reviews_student ON public.nex_misconception_reviews FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());
