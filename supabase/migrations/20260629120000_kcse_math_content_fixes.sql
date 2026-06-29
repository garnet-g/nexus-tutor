-- KCSE Mathematics — content corrections (errata from full content review 2026-06-29)
-- See docs/superpowers/reports/2026-06-29-kcse-math-content-review.md
-- Fixes 13 wrong answers + 1 under-escaped distractor + 1 calibration nit.
-- Idempotent: re-running sets the same values. Match patterns are backslash-free
-- (Postgres LIKE treats backslash as an escape character).

-- Helper scoping is repeated per statement: KCSE mathematics, specific topic, question matched by LIKE.

-- ===== Category A: wrong answer, correct value already an option (fix correct_answer) =====

-- F1 area: rectangle with two quarter-circles removed -> 240 - 56.52 = 183.48
UPDATE public.practice_questions pq SET correct_answer = '"$183.48$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='area'
  AND pq.question_text LIKE '%two quarter-circles%';

-- F2 rotation: (2,3) by 270 ACW = 90 CW = (3,-2)
UPDATE public.practice_questions pq SET correct_answer = '"$(3, -2)$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
  AND pq.question_text LIKE '%by $270%anticlockwise about $O$.';

-- F2 volume_solids: sphere r=9 (972pi) != cone r=6,h=18 (216pi) -> No
UPDATE public.practice_questions pq SET correct_answer = '"No"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
  AND pq.question_text LIKE '%melted into cone%';

-- F2 angle_properties_circle: 3x = 2(x+10) -> x = 20
UPDATE public.practice_questions pq SET correct_answer = '"$20$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
  AND pq.question_text LIKE '%inscribed $x+10$ on same arc%';

-- F3 binomial_expansion: (3-2x)^3 coeff x^2 = C(3,2)*3*(-2)^2 = +36
UPDATE public.practice_questions pq SET correct_answer = '"$36$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
  AND pq.question_text LIKE '$(3-2x)^3$ coefficient of $x^2$?';

-- F3 binomial_expansion: (2+x)^4 coeff x^3 = C(4,3)*2^1 = 8
UPDATE public.practice_questions pq SET correct_answer = '"$8$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
  AND pq.question_text LIKE 'Coefficient of $x^3$ in $(2+x)^4$?';

-- F4 statistics_ii: variance scales by k^2, doubles when k = sqrt(2)
UPDATE public.practice_questions pq SET correct_answer = '"$\\sqrt{2}$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
  AND pq.question_text LIKE 'Variance doubles when all values%';

-- ===== Category B: wrong answer AND correct value not among options (fix option + answer) =====

-- F2 statistics_i: grouped mean = (2*4.5 + 3*14.5)/5 = 52.5/5 = 10.5
UPDATE public.practice_questions pq
SET options = '["$10.5$","$9.5$","$14.5$","$4.5$"]'::jsonb, correct_answer = '"$10.5$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
  AND pq.question_text LIKE '%midpoint $14.5$. Mean estimate?';

-- F3 approximations_errors: max area error = 12*0.2 + 8*0.2 = 4.0
UPDATE public.practice_questions pq
SET options = '["$4.0$","$0.4$","$1.6$","$96$"]'::jsonb, correct_answer = '"$4.0$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
  AND pq.question_text LIKE '%Max absolute area error%';

-- F3 matrices: 2x+y=5, x+3y=7 -> x=1.6, y=1.8
UPDATE public.practice_questions pq
SET options = '["$1.8$","$2$","$3$","$7$"]'::jsonb, correct_answer = '"$1.8$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='matrices'
  AND pq.question_text LIKE '%=[5 ;  7]$. $y$?';

-- F3 sequences_series: GP a=3, r=1/2, S4 = 3+1.5+0.75+0.375 = 5.625
UPDATE public.practice_questions pq
SET options = '["$5.625$","$5$","$4.5$","$6$"]'::jsonb, correct_answer = '"$5.625$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='sequences_series'
  AND pq.question_text LIKE '%$r=1/2$, $S_4$?';

-- F3 vectors_ii: B = P + (1/3)AP = (5,3)+(1,-1) = (6,2)
UPDATE public.practice_questions pq
SET options = '["$(6, 2)$","$(8, 0)$","$(4, 4)$","$(3, 2)$"]'::jsonb, correct_answer = '"$(6, 2)$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
  AND pq.question_text LIKE '%$AP:PB=3:1$. $A(2,6)$, $P(5,3)$%';

-- F4 trigonometry_iii: sin 2x = 0 on [0,180] -> x = 0, 90, 180 -> 3 solutions
UPDATE public.practice_questions pq
SET options = '["$3$","$2$","$1$","$0$"]'::jsonb, correct_answer = '"$3$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
  AND pq.question_text LIKE '%Number of solutions?';

-- ===== Category C: calibration + rendering =====

-- F3 trigonometry_ii: cosine rule c = sqrt(89 + 80*cos30) ~= 12.6 (was 12.4)
UPDATE public.practice_questions pq
SET options = '["$12.6$","$5$","$8$","$3$"]'::jsonb, correct_answer = '"$12.6$"'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_ii'
  AND pq.question_text LIKE 'Two sides $8$ and $5$ with included%';

-- F1 scale_drawing: fix under-escaped distractor "$\frac{1}{3}$" (single -> double backslash)
UPDATE public.practice_questions pq
SET options = '["$3$","$2$","$\\frac{1}{3}$","$5$"]'::jsonb
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
  AND pq.question_text LIKE 'Similar triangles have sides $3,4,5$%Scale factor from small to large?';
