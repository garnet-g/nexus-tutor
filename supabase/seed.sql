-- Platform settings defaults
INSERT INTO public.platform_settings (setting_key, setting_value) VALUES
  ('free_daily_nex_message_limit', '10'),
  ('free_daily_practice_session_limit', '3'),
  ('premium_daily_nex_message_limit', '75'),
  ('premium_daily_practice_session_limit', '20'),
  ('family_max_students', '4'),
  ('promotion_is_active', 'false'),
  ('promotion_title', '""'),
  ('promotion_ends_at', 'null'),
  ('promotion_premium_amount_kes', 'null')
ON CONFLICT (setting_key) DO NOTHING;

-- Subscription plans
INSERT INTO public.subscription_plans (plan_code, name, amount_kes, billing_cycle) VALUES
  ('free', 'Free', 0, 'monthly'),
  ('premium', 'Premium', 799, 'monthly'),
  ('family', 'Family', 2499, 'monthly')
ON CONFLICT (plan_code) DO NOTHING;

-- Curricula
INSERT INTO public.curricula (code, name) VALUES
  ('CBC', 'Competency Based Curriculum'),
  ('KCSE', 'Kenya Certificate of Secondary Education')
ON CONFLICT (code) DO NOTHING;

-- Grade levels (CBC Grade 4-9, KCSE Form 1-4)
INSERT INTO public.grade_levels (curriculum_id, code, display_name, sort_order)
SELECT c.id, g.code, g.display_name, g.sort_order
FROM public.curricula c
CROSS JOIN (VALUES
  ('grade_4', 'Grade 4', 1), ('grade_5', 'Grade 5', 2), ('grade_6', 'Grade 6', 3),
  ('grade_7', 'Grade 7', 4), ('grade_8', 'Grade 8', 5), ('grade_9', 'Grade 9', 6)
) AS g(code, display_name, sort_order)
WHERE c.code = 'CBC'
ON CONFLICT DO NOTHING;

INSERT INTO public.grade_levels (curriculum_id, code, display_name, sort_order)
SELECT c.id, g.code, g.display_name, g.sort_order
FROM public.curricula c
CROSS JOIN (VALUES
  ('form_1', 'Form 1', 1), ('form_2', 'Form 2', 2), ('form_3', 'Form 3', 3), ('form_4', 'Form 4', 4)
) AS g(code, display_name, sort_order)
WHERE c.code = 'KCSE'
ON CONFLICT DO NOTHING;

-- Mathematics subjects
INSERT INTO public.subjects (curriculum_id, code, name)
SELECT c.id, 'mathematics', 'Mathematics'
FROM public.curricula c
WHERE c.code IN ('CBC', 'KCSE')
ON CONFLICT DO NOTHING;

-- CBC topics
INSERT INTO public.topics (subject_id, code, title, sort_order)
SELECT s.id, t.code, t.title, t.sort_order
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
CROSS JOIN (VALUES
  ('fractions', 'Fractions', 1),
  ('algebra', 'Algebra', 2),
  ('geometry', 'Geometry', 3)
) AS t(code, title, sort_order)
WHERE c.code = 'CBC' AND s.code = 'mathematics'
ON CONFLICT DO NOTHING;

-- KCSE topics (5 topics — core trio plus trigonometry and statistics)
INSERT INTO public.topics (subject_id, code, title, sort_order, min_grade_sort_order)
SELECT s.id, t.code, t.title, t.sort_order, t.min_grade_sort_order
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
CROSS JOIN (VALUES
  ('algebra', 'Algebra', 1, 1),
  ('fractions', 'Fractions', 2, 1),
  ('geometry', 'Geometry Basics', 3, 1),
  ('trigonometry', 'Trigonometry', 4, 2),
  ('statistics', 'Statistics', 5, 3)
) AS t(code, title, sort_order, min_grade_sort_order)
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT DO NOTHING;

-- Diagnostic assessments
INSERT INTO public.diagnostic_assessments (curriculum_id, subject_id, title, question_count)
SELECT c.id, s.id, 'Mathematics Diagnostic', 20
FROM public.curricula c
JOIN public.subjects s ON s.curriculum_id = c.id AND s.code = 'mathematics'
WHERE c.code IN ('CBC', 'KCSE')
ON CONFLICT DO NOTHING;

-- CBC diagnostic questions (seed 20+)
INSERT INTO public.diagnostic_questions (
  diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order
)
SELECT da.id, t.id,
  'What is ' || q.label || '?',
  'multiple_choice',
  '["A","B","C","D"]'::jsonb,
  to_jsonb(q.answer),
  q.difficulty,
  q.sort_order
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id
JOIN (
  VALUES
    ('fractions', '1/2 + 1/4', 'A', 'easy', 1),
    ('fractions', '3/4 of 8', 'B', 'easy', 2),
    ('fractions', '2/3 - 1/6', 'A', 'medium', 3),
    ('fractions', '5/8 as a decimal', 'C', 'medium', 4),
    ('fractions', '1/3 + 1/3', 'B', 'easy', 5),
    ('fractions', '4/5 x 10', 'D', 'hard', 6),
    ('fractions', '7/10 - 2/5', 'A', 'medium', 7),
    ('algebra', '2x = 10, x = ?', 'B', 'easy', 8),
    ('algebra', 'x + 5 = 12', 'C', 'easy', 9),
    ('algebra', '3x - 4 = 11', 'B', 'medium', 10),
    ('algebra', '2(x + 1) = 8', 'A', 'medium', 11),
    ('algebra', 'x/2 = 6', 'D', 'easy', 12),
    ('algebra', '5x + 2 = 22', 'C', 'hard', 13),
    ('algebra', 'x - 7 = 3', 'B', 'medium', 14),
    ('algebra', '4x = 2x + 10', 'A', 'hard', 15),
    ('geometry', 'Sum of angles in a triangle', 'C', 'easy', 16),
    ('geometry', 'Area of rectangle 4 by 5', 'B', 'easy', 17),
    ('geometry', 'Perimeter of square side 6', 'D', 'medium', 18),
    ('geometry', 'Circumference formula', 'A', 'medium', 19),
    ('geometry', 'Volume of cube side 3', 'C', 'hard', 20)
) AS q(topic_code, label, answer, difficulty, sort_order)
  ON t.code = q.topic_code
WHERE c.code = 'CBC'
ON CONFLICT DO NOTHING;

-- KCSE diagnostic questions
INSERT INTO public.diagnostic_questions (
  diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order
)
SELECT da.id, t.id,
  q.label,
  CASE WHEN q.answer ~ '^[0-9.]+$' THEN 'numeric' ELSE 'multiple_choice' END,
  CASE WHEN q.answer ~ '^[0-9.]+$' THEN NULL ELSE '["A","B","C","D"]'::jsonb END,
  CASE WHEN q.answer ~ '^[0-9.]+$' THEN to_jsonb(q.answer::numeric) ELSE to_jsonb(q.answer) END,
  q.difficulty,
  q.sort_order
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id
JOIN (
  VALUES
    ('algebra', 'Solve 2x + 3 = 11', '4', 'easy', 1),
    ('algebra', 'Factor x^2 - 9', 'A', 'medium', 2),
    ('algebra', 'Solve 3x - 5 = 16', '7', 'easy', 3),
    ('algebra', 'Expand (x + 2)(x + 3)', 'B', 'medium', 4),
    ('fractions', 'Simplify 12/18', 'A', 'easy', 5),
    ('fractions', 'Calculate 3/4 ÷ 2/5', 'B', 'medium', 6),
    ('fractions', '5/8 of KES 24,000', 'C', 'hard', 7),
    ('fractions', '1/3 + 1/6', 'A', 'easy', 8),
    ('geometry', 'Distance between (0,0) and (3,4)', '5', 'easy', 9),
    ('geometry', 'Circumference when r = 7 cm', 'B', 'medium', 10),
    ('geometry', 'Translate (2,3) by (4,-1)', 'C', 'medium', 11),
    ('geometry', 'Area of circle r = 7 (π = 22/7)', 'D', 'hard', 12),
    ('trigonometry', 'sin 30 degrees', '0.5', 'easy', 13),
    ('trigonometry', 'cos 60 degrees', '0.5', 'medium', 14),
    ('trigonometry', 'tan 45 degrees', '1', 'easy', 15),
    ('trigonometry', 'Opposite/adjacent ratio', 'A', 'medium', 16),
    ('statistics', 'Mean of 2, 4, 6', '4', 'easy', 17),
    ('statistics', 'Median of 1, 3, 9', '3', 'easy', 18),
    ('statistics', 'Probability of heads', '0.5', 'medium', 19),
    ('statistics', 'Range of 5, 8, 12', '7', 'hard', 20)
) AS q(topic_code, label, answer, difficulty, sort_order)
  ON t.code = q.topic_code
WHERE c.code = 'KCSE'
ON CONFLICT DO NOTHING;

-- Practice questions (shared per topic)
INSERT INTO public.practice_questions (
  topic_id, question_text, question_type, options, correct_answer, difficulty, explanation
)
SELECT t.id,
  'Practice: ' || t.title || ' question ' || gs.i,
  'multiple_choice',
  '["A","B","C","D"]'::jsonb,
  to_jsonb(CASE WHEN gs.i % 4 = 0 THEN 'D' WHEN gs.i % 3 = 0 THEN 'C' WHEN gs.i % 2 = 0 THEN 'B' ELSE 'A' END),
  CASE WHEN gs.i <= 3 THEN 'easy' WHEN gs.i <= 7 THEN 'medium' ELSE 'hard' END,
  'Review the core concept for this topic.'
FROM public.topics t
CROSS JOIN generate_series(1, 10) AS gs(i)
ON CONFLICT DO NOTHING;

-- SMS templates
INSERT INTO public.sms_templates (template_code, sms_body_template) VALUES
  ('welcome_student', 'Karibu Nexus, {{studentName}}! Your learning journey starts now.'),
  ('parent_linked', 'You are now linked to {{studentName}} on Nexus.'),
  ('payment_success', 'Payment of KES {{amount}} received. Premium active until {{expiryDate}}.')
ON CONFLICT (template_code) DO NOTHING;

-- Email templates
INSERT INTO public.email_templates (template_code, email_subject_template, email_body_template) VALUES
  ('welcome_student', 'Welcome to Nexus', '<p>Hi {{studentName}}, welcome to Nexus!</p>'),
  ('weekly_parent_report', 'Weekly progress for {{studentName}}', '<p>Study time: {{studyMinutes}} minutes. Health score: {{healthScore}}.</p>'),
  ('payment_receipt', 'Nexus payment receipt', '<p>Thank you for your payment of KES {{amount}}.</p>')
ON CONFLICT (template_code) DO NOTHING;
