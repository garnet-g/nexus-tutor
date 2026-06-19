-- Activate Science + English subjects (V2 Tier 1 Phase 2.4)

INSERT INTO public.subjects (curriculum_id, code, name, is_active)
SELECT c.id, s.code, s.name, true
FROM public.curricula c
CROSS JOIN (VALUES
  ('science', 'Science'),
  ('english', 'English')
) AS s(code, name)
WHERE c.code IN ('CBC', 'KCSE')
ON CONFLICT (curriculum_id, code) DO UPDATE
SET name = EXCLUDED.name,
    is_active = true;
