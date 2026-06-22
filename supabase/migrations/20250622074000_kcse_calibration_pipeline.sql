-- Private KCSE calibration intake.
-- Stores metadata-only paper signals for original practice generation.

CREATE TABLE IF NOT EXISTS public.kcse_paper_calibrations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  admin_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
  subject_code TEXT NOT NULL CHECK (
    subject_code IN (
      'mathematics',
      'science',
      'english',
      'kiswahili',
      'biology',
      'chemistry',
      'physics',
      'history_government',
      'geography',
      'cre',
      'ire',
      'business_studies',
      'agriculture',
      'computer_studies'
    )
  ),
  paper_number INTEGER NOT NULL CHECK (paper_number BETWEEN 1 AND 3),
  source_label TEXT NOT NULL,
  extraction_status TEXT NOT NULL CHECK (extraction_status IN ('machine_readable', 'needs_ocr')),
  command_verbs JSONB NOT NULL DEFAULT '[]' CHECK (jsonb_typeof(command_verbs) = 'array'),
  mark_allocation JSONB NOT NULL DEFAULT '[]' CHECK (jsonb_typeof(mark_allocation) = 'array'),
  topic_signals JSONB NOT NULL DEFAULT '[]' CHECK (jsonb_typeof(topic_signals) = 'array'),
  notes JSONB NOT NULL DEFAULT '[]' CHECK (jsonb_typeof(notes) = 'array'),
  source_policy TEXT NOT NULL DEFAULT 'do_not_copy_or_redistribute_source_questions'
    CHECK (source_policy = 'do_not_copy_or_redistribute_source_questions'),
  approval_status TEXT NOT NULL DEFAULT 'approved'
    CHECK (approval_status IN ('approved', 'archived')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.kcse_paper_calibrations ENABLE ROW LEVEL SECURITY;

CREATE INDEX IF NOT EXISTS idx_kcse_paper_calibrations_subject_paper
  ON public.kcse_paper_calibrations(subject_code, paper_number, created_at DESC);

CREATE TRIGGER set_kcse_paper_calibrations_updated_at
  BEFORE UPDATE ON public.kcse_paper_calibrations
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

COMMENT ON TABLE public.kcse_paper_calibrations
  IS 'Private metadata-only KCSE paper calibration records. Source questions, answers, passages, and marking scheme text must not be stored.';
