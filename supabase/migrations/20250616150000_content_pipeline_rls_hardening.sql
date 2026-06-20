-- Harden student RLS: drafts never visible to authenticated users.
-- Add publish audit columns used by publishDraft(adminId).

DROP POLICY IF EXISTS lessons_read ON public.lessons;
CREATE POLICY lessons_read ON public.lessons
  FOR SELECT TO authenticated
  USING (is_active = true);

DROP POLICY IF EXISTS practice_questions_read ON public.practice_questions;
CREATE POLICY practice_questions_read ON public.practice_questions
  FOR SELECT TO authenticated
  USING (is_active = true);

ALTER TABLE public.lessons
  ADD COLUMN IF NOT EXISTS published_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;

ALTER TABLE public.practice_questions
  ADD COLUMN IF NOT EXISTS published_by UUID REFERENCES auth.users(id) ON DELETE SET NULL;
