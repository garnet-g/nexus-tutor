-- Server-side lesson progress (cross-device completion + resume)

CREATE TABLE public.lesson_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  lesson_id UUID NOT NULL REFERENCES public.lessons(id) ON DELETE CASCADE,
  status TEXT NOT NULL CHECK (status IN ('in_progress', 'completed')),
  completed_at TIMESTAMPTZ,
  last_viewed_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, lesson_id)
);

CREATE INDEX idx_lesson_progress_student ON public.lesson_progress(student_id);
CREATE INDEX idx_lesson_progress_lesson ON public.lesson_progress(lesson_id);
CREATE INDEX idx_lesson_progress_student_topic ON public.lesson_progress(student_id, last_viewed_at DESC);

ALTER TABLE public.lesson_progress ENABLE ROW LEVEL SECURITY;

CREATE POLICY lesson_progress_student_select ON public.lesson_progress
  FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY lesson_progress_student_insert ON public.lesson_progress
  FOR INSERT
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY lesson_progress_student_update ON public.lesson_progress
  FOR UPDATE
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());
