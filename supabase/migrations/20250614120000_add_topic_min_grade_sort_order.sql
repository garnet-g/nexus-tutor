-- Map topic visibility to grade_levels.sort_order within each curriculum.
ALTER TABLE public.topics
  ADD COLUMN IF NOT EXISTS min_grade_sort_order INTEGER NOT NULL DEFAULT 1;

COMMENT ON COLUMN public.topics.min_grade_sort_order IS
  'Minimum grade_levels.sort_order when topic becomes available (uses ±1 preview/revision tolerance in app layer).';
