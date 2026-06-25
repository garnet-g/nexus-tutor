-- KCSE Form 1 Mathematics content slice (integers, algebraic_expressions, rates_ratio_proportion)
-- Idempotent seed: lessons + practice questions; soft-retires legacy generic KCSE math topics.

-- Soft-retire legacy generic KCSE math topics (CBC topics with same codes are untouched)
UPDATE public.topics t
SET is_active = false
FROM public.subjects s, public.curricula c
WHERE t.subject_id = s.id AND s.curriculum_id = c.id
  AND c.code = 'KCSE' AND s.code = 'mathematics'
  AND t.code IN ('algebra','fractions','geometry','trigonometry','statistics');

-- Added subtopics (confirmed Form 1 KNEC scope)
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'integer_applications', 'Integers in Real Life', 'Real-life integer problems.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'percentage_applications', 'Percentage Applications', 'Profit, loss, discount and commission.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;
