-- PR-033: FTS for student study search (published content only at query time).
ALTER TABLE public.lessons
  ADD COLUMN IF NOT EXISTS search_vector tsvector;

ALTER TABLE public.practice_questions
  ADD COLUMN IF NOT EXISTS search_vector tsvector;

UPDATE public.lessons
SET search_vector = to_tsvector('english', coalesce(title, ''))
WHERE search_vector IS NULL;

UPDATE public.practice_questions
SET search_vector = to_tsvector('english', coalesce(question_text, ''))
WHERE search_vector IS NULL;

CREATE INDEX IF NOT EXISTS idx_lessons_search_vector
  ON public.lessons USING GIN (search_vector);

CREATE INDEX IF NOT EXISTS idx_practice_questions_search_vector
  ON public.practice_questions USING GIN (search_vector);

CREATE OR REPLACE FUNCTION public.lessons_search_vector_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.title, ''));
  RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION public.practice_questions_search_vector_update()
RETURNS trigger
LANGUAGE plpgsql
AS $$
BEGIN
  NEW.search_vector := to_tsvector('english', coalesce(NEW.question_text, ''));
  RETURN NEW;
END;
$$;

DROP TRIGGER IF EXISTS trg_lessons_search_vector ON public.lessons;
CREATE TRIGGER trg_lessons_search_vector
  BEFORE INSERT OR UPDATE OF title ON public.lessons
  FOR EACH ROW EXECUTE FUNCTION public.lessons_search_vector_update();

DROP TRIGGER IF EXISTS trg_practice_questions_search_vector ON public.practice_questions;
CREATE TRIGGER trg_practice_questions_search_vector
  BEFORE INSERT OR UPDATE OF question_text ON public.practice_questions
  FOR EACH ROW EXECUTE FUNCTION public.practice_questions_search_vector_update();
