-- Activate Kiswahili (CBC+KCSE) and standalone Chemistry (KCSE) subjects. Additive only.
INSERT INTO public.subjects (curriculum_id, code, name, is_active)
SELECT c.id, 'kiswahili', 'Kiswahili', true
FROM public.curricula c
WHERE c.code IN ('CBC', 'KCSE')
ON CONFLICT (curriculum_id, code) DO UPDATE
  SET name = EXCLUDED.name, is_active = true;

INSERT INTO public.subjects (curriculum_id, code, name, is_active)
SELECT c.id, 'chemistry', 'Chemistry', true
FROM public.curricula c
WHERE c.code = 'KCSE'
ON CONFLICT (curriculum_id, code) DO UPDATE
  SET name = EXCLUDED.name, is_active = true;
