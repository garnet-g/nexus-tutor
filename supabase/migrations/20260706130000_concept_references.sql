-- PR-040: Published concept/reference library with studio lifecycle.
CREATE TABLE public.concept_references (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  subtopic_id UUID REFERENCES public.subtopics(id) ON DELETE SET NULL,
  source_lesson_id UUID REFERENCES public.lessons(id) ON DELETE SET NULL,
  title TEXT NOT NULL,
  summary TEXT,
  body TEXT NOT NULL,
  category TEXT NOT NULL DEFAULT 'formula'
    CHECK (category IN ('formula', 'definition', 'theorem', 'example', 'tip')),
  review_status TEXT NOT NULL DEFAULT 'draft'
    CHECK (review_status IN ('draft', 'in_review', 'published', 'archived')),
  is_active BOOLEAN NOT NULL DEFAULT true,
  sort_order INTEGER NOT NULL DEFAULT 0,
  author_id UUID,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_concept_references_topic_published
  ON public.concept_references(topic_id, sort_order)
  WHERE review_status = 'published' AND is_active = true;

CREATE INDEX idx_concept_references_search
  ON public.concept_references USING GIN (to_tsvector('english', coalesce(title, '') || ' ' || coalesce(summary, '') || ' ' || coalesce(body, '')));

CREATE TRIGGER trg_concept_references_updated_at
  BEFORE UPDATE ON public.concept_references
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.concept_references ENABLE ROW LEVEL SECURITY;

CREATE POLICY concept_references_student_read ON public.concept_references
  FOR SELECT
  USING (review_status = 'published' AND is_active = true);
