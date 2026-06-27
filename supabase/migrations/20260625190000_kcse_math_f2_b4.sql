-- KCSE Form 2 Mathematics — Wave 2 Batch 4 (FINAL Form 2)
-- Topics: linear_inequalities, linear_motion, statistics_i, angle_properties_circle, vectors_i
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md

-- ========== LINEAR INEQUALITIES ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Linear Inequalities', '{"blocks":[{"type":"heading","content":"What Is a Linear Inequality?"},{"type":"paragraph","content":"An **inequality** compares two expressions using $<$, $>$, $\\leq$, or $\\geq$ instead of $=$."},{"type":"math_block","latex":"ax + b < c","caption":"Example linear inequality in one variable"},{"type":"callout","variant":"key_point","content":"Treat inequalities like equations, but **reverse the inequality sign** when you multiply or divide by a **negative** number."},{"type":"example","title":"Solve $2x - 3 < 7$.","steps":["Add $3$: $2x < 10$.","Divide by $2$: $x < 5$."],"answer":"$x < 5$"},{"type":"question","questionText":"Symbol for ''less than or equal to''?","questionType":"multiple_choice","options":["$\\leq$","$<$","$\\geq$","$=$"],"correctAnswer":"$\\leq$","explanation":"Less than or equal."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Linear Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving One-Variable Inequalities', '{"blocks":[{"type":"heading","content":"Step-by-Step Solving"},{"type":"example","title":"Solve $3 - 2x \\geq 11$.","steps":["Subtract $3$: $-2x \\geq 8$.","Divide by $-2$ and flip sign: $x \\leq -4$."],"answer":"$x \\leq -4$"},{"type":"callout","variant":"warning","content":"Forgetting to flip the sign when dividing by a negative is the most common KCSE error."},{"type":"example","title":"Solve $4x + 1 > 2x + 9$.","steps":["Subtract $2x$: $2x + 1 > 9$.","Subtract $1$: $2x > 8$.","$x > 4$."],"answer":"$x > 4$"},{"type":"question","questionText":"Solve $x + 5 > 12$. Solution?","questionType":"multiple_choice","options":["$x > 7$","$x < 7$","$x > 17$","$x < 17$"],"correctAnswer":"$x > 7$","explanation":"Subtract $5$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving One-Variable Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Inequalities — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Solving Inequalities"},{"type":"example","title":"A bus carries at most $52$ passengers. Already $18$ are on board. If $p$ more board, write and solve.","steps":["$18 + p \\leq 52$.","$p \\leq 34$."],"answer":"At most $34$ more passengers"},{"type":"callout","variant":"warning","content":"Word ''at most'' means $\\leq$; ''at least'' means $\\geq$."},{"type":"question","questionText":"Solve $5x - 2 \\leq 3x + 10$.","questionType":"multiple_choice","options":["$x \\leq 6$","$x \\geq 6$","$x \\leq 4$","$x \\geq 4$"],"correctAnswer":"$x \\leq 6$","explanation":"$2x \\leq 12$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Inequalities — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x + 3 > 8$. Solution?', 'multiple_choice', '["$x > 5$","$x < 5$","$x > 11$","$x < 11$"]'::jsonb, '"$x > 5$"'::jsonb, 'easy', 'Subtract $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x + 3 > 8$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2x < 10$. Solution?', 'multiple_choice', '["$x < 5$","$x > 5$","$x < 20$","$x > 20$"]'::jsonb, '"$x < 5$"'::jsonb, 'easy', 'Divide by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2x < 10$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x - 4 \geq 0$ means?', 'multiple_choice', '["$x \\geq 4$","$x \\leq 4$","$x > 4$ only","$x < 4$"]'::jsonb, '"$x \\geq 4$"'::jsonb, 'easy', 'Add $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x - 4 \geq 0$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Inequality symbol for ''greater than''?', 'multiple_choice', '["$>$","$<$","$\\leq$","$=$"]'::jsonb, '"$>$"'::jsonb, 'easy', 'Greater than.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Inequality symbol for ''greater than''?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $3x + 6 \leq 15$.', 'multiple_choice', '["$x \\leq 3$","$x \\geq 3$","$x \\leq 7$","$x \\geq 7$"]'::jsonb, '"$x \\leq 3$"'::jsonb, 'easy', '$3x \leq 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $3x + 6 \leq 15$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'When dividing by $-2$, you must?', 'multiple_choice', '["Flip the inequality sign","Keep the sign","Add $2$","Square both sides"]'::jsonb, '"Flip the inequality sign"'::jsonb, 'easy', 'Negative division rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='When dividing by $-2$, you must?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x + 1 < 4$.', 'multiple_choice', '["$x < 3$","$x > 3$","$x < 5$","$x > 5$"]'::jsonb, '"$x < 3$"'::jsonb, 'easy', 'Subtract $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x + 1 < 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $-3x > 12$.', 'multiple_choice', '["$x < -4$","$x > -4$","$x < 4$","$x > 4$"]'::jsonb, '"$x < -4$"'::jsonb, 'medium', 'Divide by $-3$; flip sign.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $-3x > 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2(x - 1) \geq 8$.', 'multiple_choice', '["$x \\geq 5$","$x \\leq 5$","$x \\geq 4$","$x \\leq 4$"]'::jsonb, '"$x \\geq 5$"'::jsonb, 'medium', '$2x - 2 \geq 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2(x - 1) \geq 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $4x + 3 < 2x + 11$.', 'multiple_choice', '["$x < 4$","$x > 4$","$x < 7$","$x > 7$"]'::jsonb, '"$x < 4$"'::jsonb, 'medium', '$2x < 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $4x + 3 < 2x + 11$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5 - x \leq 2$.', 'multiple_choice', '["$x \\geq 3$","$x \\leq 3$","$x \\geq -3$","$x \\leq -3$"]'::jsonb, '"$x \\geq 3$"'::jsonb, 'medium', '$-x \leq -3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5 - x \leq 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{x}{2} + 1 > 4$.', 'multiple_choice', '["$x > 6$","$x < 6$","$x > 3$","$x < 3$"]'::jsonb, '"$x > 6$"'::jsonb, 'medium', '$\frac{x}{2} > 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{x}{2} + 1 > 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $3x - 7 \geq 2x + 1$.', 'multiple_choice', '["$x \\geq 8$","$x \\leq 8$","$x \\geq -8$","$x \\leq -8$"]'::jsonb, '"$x \\geq 8$"'::jsonb, 'medium', '$x \geq 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $3x - 7 \geq 2x + 1$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2x + 5 \leq 3x - 1$. Solution?', 'multiple_choice', '["$x \\geq 6$","$x \\leq 6$","$x \\geq 4$","$x \\leq 4$"]'::jsonb, '"$x \\geq 6$"'::jsonb, 'medium', '$6 \leq x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2x + 5 \leq 3x - 1$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2(3x - 1) - 4(x + 2) < 5$.', 'multiple_choice', '["$x < 6.5$","$x > 6.5$","$x < 5.5$","$x > 5.5$"]'::jsonb, '"$x < 6.5$"'::jsonb, 'hard', '$2x - 10 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2(3x - 1) - 4(x + 2) < 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ages: father is $40$, son is $x$. Father is at most $4$ times son''s age. Inequality?', 'multiple_choice', '["$40 \\leq 4x$","$40 \\geq 4x$","$x \\leq 10$ only","$x \\geq 40$"]'::jsonb, '"$40 \\leq 4x$"'::jsonb, 'hard', 'At most four times.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ages: father is $40$, son is $x$. Father is at most $4$ times son''s age. Inequality?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{2x - 1}{3} \geq 5$.', 'multiple_choice', '["$x \\geq 8$","$x \\leq 8$","$x \\geq 7$","$x \\leq 7$"]'::jsonb, '"$x \\geq 8$"'::jsonb, 'hard', '$2x - 1 \geq 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{2x - 1}{3} \geq 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $-2(x + 3) \leq 4 - x$.', 'multiple_choice', '["$x \\geq -10$","$x \\leq -10$","$x \\geq 10$","$x \\leq 10$"]'::jsonb, '"$x \\geq -10$"'::jsonb, 'hard', 'Expand and collect.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $-2(x + 3) \leq 4 - x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Integer solutions of $3 < 2x - 1 \leq 9$?', 'multiple_choice', '["$3, 4, 5$","$2, 3, 4$","$4, 5, 6$","$1, 2, 3$"]'::jsonb, '"$3, 4, 5$"'::jsonb, 'hard', '$2 < x \leq 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Integer solutions of $3 < 2x - 1 \leq 9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $0.5x + 2.5 > 1.5x - 1$.', 'multiple_choice', '["$x < 3.5$","$x > 3.5$","$x < 2.5$","$x > 2.5$"]'::jsonb, '"$x < 3.5$"'::jsonb, 'hard', '$-x > -3.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $0.5x + 2.5 > 1.5x - 1$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'KES $500$ saved weekly; need $3500$. Weeks $w$ needed: $500w \geq 3500$. Minimum $w$?', 'multiple_choice', '["$7$","$6$","$8$","$35$"]'::jsonb, '"$7$"'::jsonb, 'hard', '$w \geq 7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='KES $500$ saved weekly; need $3500$. Weeks $w$ needed: $500w \geq 3500$. Minimum $w$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Inequalities on the Number Line', '{"blocks":[{"type":"heading","content":"Representing Solutions"},{"type":"paragraph","content":"The solution to $x > 3$ is **all numbers greater than $3$**. On a number line, use an **open circle** at $3$ and shade to the right."},{"type":"callout","variant":"key_point","content":"Open circle: value **not** included ($<$ or $>$). Closed circle: value **included** ($\\leq$ or $\\geq$)."},{"type":"example","title":"Show $-2 \\leq x < 4$ on a number line.","steps":["Closed circle at $-2$, shade right.","Open circle at $4$, shade stops before $4$."],"answer":"Interval $[-2, 4)$"},{"type":"question","questionText":"$x \\geq 1$ uses which circle at $1$?","questionType":"multiple_choice","options":["Closed","Open","No circle","Arrow only"],"correctAnswer":"Closed","explanation":"Includes $1$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Inequalities on the Number Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Interval Notation and Combined Inequalities', '{"blocks":[{"type":"heading","content":"Double Inequalities"},{"type":"example","title":"Solve and show: $1 \\leq 2x + 3 < 9$.","steps":["Subtract $3$: $-2 \\leq 2x < 6$.","Divide by $2$: $-1 \\leq x < 3$."],"answer":"$-1 \\leq x < 3$"},{"type":"callout","variant":"warning","content":"When solving double inequalities, perform the same operation on **all three parts**."},{"type":"example","title":"Write in words: $x > -5$.","steps":["All numbers greater than $-5$.","Open circle at $-5$, arrow right."],"answer":"$x$ is to the right of $-5$"},{"type":"question","questionText":"Solution $x < 0$: shade which direction?","questionType":"multiple_choice","options":["Left of $0$","Right of $0$","Both sides","Nowhere"],"correctAnswer":"Left of $0$","explanation":"Less than zero."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Interval Notation and Combined Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Number Line — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Number Line"},{"type":"example","title":"Solve $-3 < x + 2 \\leq 5$ and describe the number-line picture.","steps":["Subtract $2$: $-5 < x \\leq 3$.","Open at $-5$, closed at $3$."],"answer":"$-5 < x \\leq 3$"},{"type":"callout","variant":"warning","content":"KCSE may ask which diagram matches a solution — test the endpoint circles carefully."},{"type":"question","questionText":"Which matches $x \\leq -2$?","questionType":"multiple_choice","options":["Closed circle at $-2$, shade left","Open at $-2$, shade right","Closed at $2$","Open at $0$"],"correctAnswer":"Closed circle at $-2$, shade left","explanation":"Less than or equal."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Number Line — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x > 2$ on number line: circle at $2$ is?', 'multiple_choice', '["Open","Closed","Filled square","None"]'::jsonb, '"Open"'::jsonb, 'easy', 'Not including $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x > 2$ on number line: circle at $2$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x \leq 5$: shade which way from $5$?', 'multiple_choice', '["Left (and include $5$)","Right only","Neither","Both"]'::jsonb, '"Left (and include $5$)"'::jsonb, 'easy', 'Less than or equal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x \leq 5$: shade which way from $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x \geq 0$ includes?', 'multiple_choice', '["$0$ and positives","Only positives","Only negatives","Nothing"]'::jsonb, '"$0$ and positives"'::jsonb, 'easy', 'Greater or equal zero.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x \geq 0$ includes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Open circle means?', 'multiple_choice', '["Value not included","Value included","Equal only","Undefined"]'::jsonb, '"Value not included"'::jsonb, 'easy', 'Strict inequality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Open circle means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x < -1$: test value $-2$?', 'multiple_choice', '["In solution","Not in solution","Equal to boundary","Cannot tell"]'::jsonb, '"In solution"'::jsonb, 'easy', '$-2 < -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x < -1$: test value $-2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Closed circle at $4$ with shade right means?', 'multiple_choice', '["$x \\geq 4$","$x > 4$","$x \\leq 4$","$x < 4$"]'::jsonb, '"$x \\geq 4$"'::jsonb, 'easy', 'Includes $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Closed circle at $4$ with shade right means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$-3 \leq x < 2$: is $x = 2$ included?', 'multiple_choice', '["No","Yes","Sometimes","Always"]'::jsonb, '"No"'::jsonb, 'easy', 'Strict less than at $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$-3 \leq x < 2$: is $x = 2$ included?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $-4 < x - 1 \leq 2$. Solution?', 'multiple_choice', '["$-3 < x \\leq 3$","$-5 < x \\leq 1$","$-3 < x < 3$","$-5 < x < 1$"]'::jsonb, '"$-3 < x \\leq 3$"'::jsonb, 'medium', 'Add $1$ throughout.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $-4 < x - 1 \leq 2$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2 \leq 3x < 12$. Solution?', 'multiple_choice', '["$\\frac{2}{3} \\leq x < 4$","$1 \\leq x < 4$","$2 \\leq x < 36$","$6 \\leq x < 15$"]'::jsonb, '"$\\frac{2}{3} \\leq x < 4$"'::jsonb, 'medium', 'Divide by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2 \leq 3x < 12$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which integer satisfies $-2 < x \leq 3$?', 'multiple_choice', '["$3$","$4$","$-2$","$-3$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Included endpoint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which integer satisfies $-2 < x \leq 3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5x - 1 < 4x + 3$ and show $x < 4$.', 'multiple_choice', '["$x < 4$","$x > 4$","$x \\leq 4$","$x \\geq 4$"]'::jsonb, '"$x < 4$"'::jsonb, 'medium', '$x < 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5x - 1 < 4x + 3$ and show $x < 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$-1 \leq 2x + 1 < 7$. Solution?', 'multiple_choice', '["$-1 \\leq x < 3$","$0 \\leq x < 4$","$-2 \\leq x < 6$","$1 \\leq x < 8$"]'::jsonb, '"$-1 \\leq x < 3$"'::jsonb, 'medium', 'Subtract $1$, divide $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$-1 \leq 2x + 1 < 7$. Solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Number line: open at $-1$, closed at $5$, between them shaded. Inequality?', 'multiple_choice', '["$-1 < x \\leq 5$","$-1 \\leq x < 5$","$-1 < x < 5$","$-1 \\leq x \\leq 5$"]'::jsonb, '"$-1 < x \\leq 5$"'::jsonb, 'medium', 'Match circle types.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Number line: open at $-1$, closed at $5$, between them shaded. Inequality?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $|x| < 3$ style: $-3 < x < 3$. Is $x = -3$ in set?', 'multiple_choice', '["No","Yes","Only if positive","Always"]'::jsonb, '"No"'::jsonb, 'medium', 'Strict inequality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $|x| < 3$ style: $-3 < x < 3$. Is $x = -3$ in set?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $-2 \leq \frac{x + 1}{2} < 4$.', 'multiple_choice', '["$-5 \\leq x < 7$","$-3 \\leq x < 5$","$-1 \\leq x < 3$","$-4 \\leq x < 8$"]'::jsonb, '"$-5 \\leq x < 7$"'::jsonb, 'hard', 'Multiply all parts by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $-2 \leq \frac{x + 1}{2} < 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Integers $n$ with $-3.5 < n \leq 2.5$?', 'multiple_choice', '["$-3, -2, -1, 0, 1, 2$","$-3$ to $3$","$-2$ to $2$","$-4$ to $2$"]'::jsonb, '"$-3, -2, -1, 0, 1, 2$"'::jsonb, 'hard', 'Integer list.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Integers $n$ with $-3.5 < n \leq 2.5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $3(x - 2) < 2(x + 1)$ and $x > -5$ combined.', 'multiple_choice', '["$-5 < x < 8$","$x < 8$ only","$x > 8$","$-5 < x < -8$"]'::jsonb, '"$-5 < x < 8$"'::jsonb, 'hard', '$x < 8$ from first.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $3(x - 2) < 2(x + 1)$ and $x > -5$ combined.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Temperature $t^{\circ}\text{C}$ satisfies $-4 \leq t < 10$. Valid reading?', 'multiple_choice', '["$9^{\\circ}\\text{C}$","$10^{\\circ}\\text{C}$","$-5^{\\circ}\\text{C}$","$11^{\\circ}\\text{C}$"]'::jsonb, '"$9^{\\circ}\\text{C}$"'::jsonb, 'hard', 'Inside interval.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Temperature $t^{\circ}\text{C}$ satisfies $-4 \leq t < 10$. Valid reading?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $1 < 2x - 3 \leq 9$.', 'multiple_choice', '["$2 < x \\leq 6$","$1 < x \\leq 5$","$-2 < x \\leq 6$","$2 < x < 6$"]'::jsonb, '"$2 < x \\leq 6$"'::jsonb, 'hard', 'Add $3$, divide $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $1 < 2x - 3 \leq 9$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many integers satisfy $-1.5 \leq x < 3.5$?', 'multiple_choice', '["$5$","$4$","$6$","$3$"]'::jsonb, '"$5$"'::jsonb, 'hard', '$-1, 0, 1, 2, 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers satisfy $-1.5 \leq x < 3.5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $4 - x > 1$ and $2x + 1 \geq 5$ simultaneously.', 'multiple_choice', '["$x \\geq 2$ and $x < 3$","$x > 3$","$x < 2$","$x \\geq 3$"]'::jsonb, '"$x \\geq 2$ and $x < 3$"'::jsonb, 'hard', '$2 \leq x < 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $4 - x > 1$ and $2x + 1 \geq 5$ simultaneously.');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Graphing Linear Inequalities', '{"blocks":[{"type":"heading","content":"Lines and Half-Planes"},{"type":"paragraph","content":"To graph $y > 2x + 1$: first draw the boundary line $y = 2x + 1$ as a **dashed** line (not included). Shade the region **above** the line for $>$."},{"type":"callout","variant":"key_point","content":"Replace $<$ with $=$ to find the boundary line. Dashed = strict ($<$ or $>$); solid = inclusive ($\\leq$ or $\\geq$)."},{"type":"example","title":"Describe shading for $y \\leq x + 2$.","steps":["Solid line $y = x + 2$.","Shade **below** the line (smaller $y$)."],"answer":"Region on or below the line"},{"type":"question","questionText":"$y > 3$: shade above or below horizontal line $y = 3$?","questionType":"multiple_choice","options":["Above","Below","Left","Right"],"correctAnswer":"Above","explanation":"Greater $y$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Graphing Linear Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Systems of Inequalities', '{"blocks":[{"type":"heading","content":"Feasible Region"},{"type":"paragraph","content":"When several inequalities apply, the **feasible region** is where all shadings overlap."},{"type":"example","title":"Region: $x \\geq 0$, $y \\geq 0$, $x + y \\leq 6$. Describe.","steps":["First quadrant bounded by $x + y = 6$.","Triangle with vertices $(0,0)$, $(6,0)$, $(0,6)$."],"answer":"Triangle in first quadrant under $x+y=6$"},{"type":"callout","variant":"warning","content":"Use a test point (often $(0,0)$) if unsure which side to shade — substitute into the inequality."},{"type":"question","questionText":"Test point $(0,0)$ in $x + y < 4$?","questionType":"multiple_choice","options":["Satisfies","Does not satisfy","On boundary","Undefined"],"correctAnswer":"Satisfies","explanation":"$0 + 0 < 4$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Systems of Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Graphical Regions — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Graphical Regions"},{"type":"example","title":"A factory needs $x \\geq 2$ machines and $y \\geq 1$ supervisor with $2x + y \\leq 10$. Corner points?","steps":["$(2,1)$, $(2,6)$, $(4.5,1)$ approximately from constraints.","Evaluate objective at corners in full problems."],"answer":"Bounded polygon from overlapping inequalities"},{"type":"callout","variant":"warning","content":"List corner points of the feasible region before optimising — KCSE linear programming style."},{"type":"question","questionText":"Boundary of $y < 2x$ is drawn?","questionType":"multiple_choice","options":["Dashed line through origin slope $2$","Solid horizontal","Circle","Vertical line"],"correctAnswer":"Dashed line through origin slope $2$","explanation":"Strict inequality boundary."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Graphical Regions — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y > 0$: region is?', 'multiple_choice', '["Above $x$-axis","Below $x$-axis","Right of $y$-axis","Left of origin"]'::jsonb, '"Above $x$-axis"'::jsonb, 'easy', 'Positive $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y > 0$: region is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x \leq 4$: vertical line at $x = 4$ is?', 'multiple_choice', '["Solid","Dashed","Curved","Horizontal"]'::jsonb, '"Solid"'::jsonb, 'easy', 'Inclusive inequality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x \leq 4$: vertical line at $x = 4$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y < 5$: shade?', 'multiple_choice', '["Below horizontal line $y = 5$","Above","Left of $y=5$","Right"]'::jsonb, '"Below horizontal line $y = 5$"'::jsonb, 'easy', 'Smaller $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y < 5$: shade?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x > 0$: which half-plane?', 'multiple_choice', '["Right of $y$-axis","Left of $y$-axis","Above $x$-axis","Below"]'::jsonb, '"Right of $y$-axis"'::jsonb, 'easy', 'Positive $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x > 0$: which half-plane?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Dashed boundary line means?', 'multiple_choice', '["Strict inequality","Inclusive","Equality only","No solution"]'::jsonb, '"Strict inequality"'::jsonb, 'easy', '$<$ or $>$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Dashed boundary line means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y \geq -2$: shade relative to $y = -2$?', 'multiple_choice', '["On and above","Below only","Left only","Right only"]'::jsonb, '"On and above"'::jsonb, 'easy', 'Greater or equal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y \geq -2$: shade relative to $y = -2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Test $(1,1)$ in $x + y \leq 3$?', 'multiple_choice', '["Satisfies","Fails","On line only","Undefined"]'::jsonb, '"Satisfies"'::jsonb, 'easy', '$1 + 1 \leq 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Test $(1,1)$ in $x + y \leq 3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Graph $y \geq 2x - 1$: shade?', 'multiple_choice', '["On/above the line","Below the line","Left of line","Right only"]'::jsonb, '"On/above the line"'::jsonb, 'medium', '$y$ greater than line value.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Graph $y \geq 2x - 1$: shade?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Region $x \geq 1$ and $y \leq 3$ is a?', 'multiple_choice', '["Rectangle strip in plane","Circle","Single point","Empty set"]'::jsonb, '"Rectangle strip in plane"'::jsonb, 'medium', 'Bounded strip.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Region $x \geq 1$ and $y \leq 3$ is a?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2x + y \leq 8$ with $x, y \geq 0$: intercepts?', 'multiple_choice', '["$(4,0)$ and $(0,8)$","$(8,0)$ only","$(0,4)$ only","No intercepts"]'::jsonb, '"$(4,0)$ and $(0,8)$"'::jsonb, 'medium', 'Set $y=0$ and $x=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2x + y \leq 8$ with $x, y \geq 0$: intercepts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which point is in $y < x + 1$?', 'multiple_choice', '["$(0,0)$","$(0,2)$","$(1,3)$","$(2,4)$"]'::jsonb, '"$(0,0)$"'::jsonb, 'medium', '$0 < 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which point is in $y < x + 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x + 2y \leq 6$: is $(2,2)$ inside?', 'multiple_choice', '["Yes","No","On boundary only","Outside always"]'::jsonb, '"Yes"'::jsonb, 'medium', '$2 + 4 = 6$ on boundary.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x + 2y \leq 6$: is $(2,2)$ inside?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'System $x > 0$, $y > 0$: quadrant?', 'multiple_choice', '["First","Second","Third","Fourth"]'::jsonb, '"First"'::jsonb, 'medium', 'Both positive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='System $x > 0$, $y > 0$: quadrant?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y \leq -x + 4$ shade?', 'multiple_choice', '["On/below line slope $-1$","Above line","Right of $y$-axis","Outside circle"]'::jsonb, '"On/below line slope $-1$"'::jsonb, 'medium', 'Smaller $y$ values.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y \leq -x + 4$ shade?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Feasible region: $x \geq 0$, $y \geq 0$, $x + y \leq 10$, $2x + y \leq 14$. Corner $(0,0)$ valid?', 'multiple_choice', '["Yes","No","Only if $x>0$","Never"]'::jsonb, '"Yes"'::jsonb, 'hard', 'Satisfies all.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Feasible region: $x \geq 0$, $y \geq 0$, $x + y \leq 10$, $2x + y \leq 14$. Corner $(0,0)$ valid?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vertices of $x \geq 0$, $y \geq 0$, $x + y \leq 6$?', 'multiple_choice', '["$(0,0)$, $(6,0)$, $(0,6)$","$(3,3)$ only","$(6,6)$","Infinite"]'::jsonb, '"$(0,0)$, $(6,0)$, $(0,6)$"'::jsonb, 'hard', 'Triangle corners.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vertices of $x \geq 0$, $y \geq 0$, $x + y \leq 6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point in region $x \geq 1$, $y \geq 2$, $x + y \leq 8$?', 'multiple_choice', '["$(2,3)$","$(0,0)$","$(5,5)$","$(1,8)$"]'::jsonb, '"$(2,3)$"'::jsonb, 'hard', 'All constraints met.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point in region $x \geq 1$, $y \geq 2$, $x + y \leq 8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Describe region: $y > 2x$ and $y < 6$.', 'multiple_choice', '["Band between line and $y=6$","Below $x$-axis","Circle","Empty"]'::jsonb, '"Band between line and $y=6$"'::jsonb, 'hard', 'Sandwiched region.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Describe region: $y > 2x$ and $y < 6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3x + 2y \leq 12$, $x,y \geq 0$. Maximum $x$ when $y=0$?', 'multiple_choice', '["$4$","$6$","$12$","$3$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$3x \leq 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3x + 2y \leq 12$, $x,y \geq 0$. Maximum $x$ when $y=0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which fails both $x + y \leq 5$ and $x \geq 0$?', 'multiple_choice', '["$(-1, 3)$","$(2,2)$","$(0,5)$","$(5,0)$"]'::jsonb, '"$(-1, 3)$"'::jsonb, 'hard', 'Negative $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which fails both $x + y \leq 5$ and $x \geq 0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factory: $x \geq 2$, $y \geq 1$, $x + 2y \leq 12$. Is $(4,3)$ feasible?', 'multiple_choice', '["Yes","No","On one line only","Outside all"]'::jsonb, '"Yes"'::jsonb, 'hard', '$4 + 6 = 10 \leq 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factory: $x \geq 2$, $y \geq 1$, $x + 2y \leq 12$. Is $(4,3)$ feasible?');
-- ========== LINEAR MOTION ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance–Time Graphs', '{"blocks":[{"type":"heading","content":"Reading Distance–Time Graphs"},{"type":"paragraph","content":"A **distance–time graph** shows how far an object is from a starting point at each time."},{"type":"callout","variant":"key_point","content":"A **straight line** means **constant speed**. A **horizontal** segment means **stationary**."},{"type":"example","title":"Line from $(0,0)$ to $(4, 20)$. Speed?","steps":["$\\Delta s = 20$ m, $\\Delta t = 4$ s.","$v = 5$ m/s."],"answer":"$5$ m/s"},{"type":"question","questionText":"Horizontal line on distance–time graph means?","questionType":"multiple_choice","options":["Stationary","Constant speed","Accelerating","Returning"],"correctAnswer":"Stationary","explanation":"Distance not changing."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Speed from Graphs', '{"blocks":[{"type":"heading","content":"Gradient = Speed"},{"type":"math_block","latex":"v = \\frac{\\Delta s}{\\Delta t}","caption":"Speed from distance–time graph"},{"type":"example","title":"Distance $10$ m to $30$ m in $4$ s.","steps":["$\\Delta s = 20$ m.","$v = 5$ m/s."],"answer":"$5$ m/s"},{"type":"callout","variant":"warning","content":"Speed is the **gradient**, not the area under a distance–time graph."},{"type":"question","questionText":"Steeper line means?","questionType":"multiple_choice","options":["Greater speed","Less speed","Zero speed","No motion"],"correctAnswer":"Greater speed","explanation":"Larger gradient."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Speed from Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance–Time — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Distance–Time"},{"type":"example","title":"$3$ km in $12$ min, rest $6$ min, $2$ km in $8$ min.","steps":["Two sloped segments with horizontal rest."],"answer":"Piecewise graph with flat middle"},{"type":"callout","variant":"warning","content":"Convert minutes to hours when speed must be in km/h."},{"type":"question","questionText":"$150$ km in $2.5$ h. Speed?","questionType":"multiple_choice","options":["$60$ km/h","$75$ km/h","$50$ km/h","$37.5$ km/h"],"correctAnswer":"$60$ km/h","explanation":"$150/2.5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance–Time — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Distance–time: vertical axis shows?', 'multiple_choice', '["Distance","Time","Acceleration","Force"]'::jsonb, '"Distance"'::jsonb, 'easy', 'Standard axes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Distance–time: vertical axis shows?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At rest on $s$–$t$ graph?', 'multiple_choice', '["Horizontal line","Steep line","Curve","Vertical"]'::jsonb, '"Horizontal line"'::jsonb, 'easy', 'No distance change.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At rest on $s$–$t$ graph?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$10$ m/s for $5$ s. Distance?', 'multiple_choice', '["$50$ m","$2$ m","$15$ m","$0.5$ m"]'::jsonb, '"$50$ m"'::jsonb, 'easy', '$s=vt$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$10$ m/s for $5$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of $s$–$t$ equals?', 'multiple_choice', '["Speed","Acceleration","Force","Mass"]'::jsonb, '"Speed"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of $s$–$t$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$400$ m in $200$ s. Speed?', 'multiple_choice', '["$2$ m/s","$4$ m/s","$0.5$ m/s","$800$ m/s"]'::jsonb, '"$2$ m/s"'::jsonb, 'easy', '$400/200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$400$ m in $200$ s. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Straight sloped $s$–$t$ line means?', 'multiple_choice', '["Constant speed","Acceleration","Rest only","Turning"]'::jsonb, '"Constant speed"'::jsonb, 'easy', 'Uniform motion.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Straight sloped $s$–$t$ line means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Time axis is usually?', 'multiple_choice', '["Horizontal","Vertical","Diagonal","Circular"]'::jsonb, '"Horizontal"'::jsonb, 'easy', 'Convention.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Time axis is usually?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(0,0)$ to $(5,40)$. Speed?', 'multiple_choice', '["$8$ m/s","$5$ m/s","$40$ m/s","$200$ m/s"]'::jsonb, '"$8$ m/s"'::jsonb, 'medium', '$40/5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(0,0)$ to $(5,40)$. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$120$ km in $1.5$ h. Speed?', 'multiple_choice', '["$80$ km/h","$60$ km/h","$90$ km/h","$180$ km/h"]'::jsonb, '"$80$ km/h"'::jsonb, 'medium', '$120/1.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$120$ km in $1.5$ h. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Horizontal $t=3$ to $t=7$. $\Delta s$?', 'multiple_choice', '["$0$","$4$ m","$7$ m","$3$ m"]'::jsonb, '"$0$"'::jsonb, 'medium', 'Stationary.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Horizontal $t=3$ to $t=7$. $\Delta s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$15$ m/s for $20$ s. Distance?', 'multiple_choice', '["$300$ m","$35$ m","$150$ m","$0.75$ m"]'::jsonb, '"$300$ m"'::jsonb, 'medium', 'Product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$15$ m/s for $20$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$0$–$4$ s: $0$ to $16$ m; then flat. First speed?', 'multiple_choice', '["$4$ m/s","$2$ m/s","$16$ m/s","$6$ m/s"]'::jsonb, '"$4$ m/s"'::jsonb, 'medium', '$16/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$0$–$4$ s: $0$ to $16$ m; then flat. First speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$5$ km in $25$ min. km/h?', 'multiple_choice', '["$12$ km/h","$5$ km/h","$25$ km/h","$125$ km/h"]'::jsonb, '"$12$ km/h"'::jsonb, 'medium', 'Convert time.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$5$ km in $25$ min. km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(2,10)$ to $(6,30)$. Speed?', 'multiple_choice', '["$5$ m/s","$10$ m/s","$20$ m/s","$4$ m/s"]'::jsonb, '"$5$ m/s"'::jsonb, 'medium', '$20/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(2,10)$ to $(6,30)$. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Journey ends at $210$ km after rest. Total distance?', 'multiple_choice', '["$210$ km","$300$ km","$90$ km","$120$ km"]'::jsonb, '"$210$ km"'::jsonb, 'hard', 'Final reading.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Journey ends at $210$ km after rest. Total distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$30$ min at $40$ km/h plus $20$ min at $60$ km/h. Distance?', 'multiple_choice', '["$40$ km","$50$ km","$100$ km","$20$ km"]'::jsonb, '"$40$ km"'::jsonb, 'hard', '$20+20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$30$ min at $40$ km/h plus $20$ min at $60$ km/h. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Graph returns to $s=0$. Meaning?', 'multiple_choice', '["Returned to start","Never moved","Constant speed","Accelerating"]'::jsonb, '"Returned to start"'::jsonb, 'hard', 'Back at origin.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Graph returns to $s=0$. Meaning?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$100$ m in $4$ s then $150$ m more in $6$ s. Average speed?', 'multiple_choice', '["$25$ m/s","$20$ m/s","$41.7$ m/s","$15$ m/s"]'::jsonb, '"$25$ m/s"'::jsonb, 'hard', '$250/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$100$ m in $4$ s then $150$ m more in $6$ s. Average speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$18$ km + rest + $12$ km takes $90$ min total. Correct?', 'multiple_choice', '["Yes if times sum $90$","No always","Only if constant","Cannot tell"]'::jsonb, '"Yes if times sum $90$"'::jsonb, 'hard', 'Add time segments.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$18$ km + rest + $12$ km takes $90$ min total. Correct?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Second segment twice as steep. Speed ratio?', 'multiple_choice', '["$2:1$","$1:2$","$1:1$","$4:1$"]'::jsonb, '"$2:1$"'::jsonb, 'hard', 'Gradient ratio.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Second segment twice as steep. Speed ratio?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2$ m each second for $5$ s. Graph?', 'multiple_choice', '["Straight slope $2$","Curve up","Horizontal","Vertical"]'::jsonb, '"Straight slope $2$"'::jsonb, 'hard', 'Constant $2$ m/s.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2$ m each second for $5$ s. Graph?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Velocity–Time Graphs', '{"blocks":[{"type":"heading","content":"Velocity vs Time"},{"type":"paragraph","content":"**Area under** a velocity–time graph equals **distance travelled**."},{"type":"callout","variant":"key_point","content":"Horizontal line = constant velocity. Sloping line = uniform acceleration."},{"type":"example","title":"$8$ m/s for $5$ s. Distance?","steps":["Area $= 8 \\times 5 = 40$ m."],"answer":"$40$ m"},{"type":"question","questionText":"Area under $v$–$t$ gives?","questionType":"multiple_choice","options":["Distance","Speed only","Mass","Force"],"correctAnswer":"Distance","explanation":"Standard result."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Velocity–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Acceleration from Velocity–Time', '{"blocks":[{"type":"heading","content":"Gradient = Acceleration"},{"type":"math_block","latex":"a = \\frac{\\Delta v}{\\Delta t}"},{"type":"example","title":"$v$: $4$ to $16$ m/s in $3$ s.","steps":["$a = 12/3 = 4$ m/s$^2$."],"answer":"$4$ m/s$^2$"},{"type":"callout","variant":"warning","content":"Negative gradient = deceleration."},{"type":"question","questionText":"Horizontal $v$–$t$ means $a$?","questionType":"multiple_choice","options":["Zero","Maximum","Increasing","Negative only"],"correctAnswer":"Zero","explanation":"Constant $v$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Acceleration from Velocity–Time');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Velocity–Time — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Velocity–Time"},{"type":"example","title":"$10$ m/s for $4$ s, then linear to $0$ in $4$ s.","steps":["$40$ m + triangle $20$ m = $60$ m."],"answer":"$60$ m"},{"type":"callout","variant":"warning","content":"Split into rectangles and triangles."},{"type":"question","questionText":"$v=-3$ m/s means?","questionType":"multiple_choice","options":["Opposite direction","At rest","Forward only","Acceleration $-3$"],"correctAnswer":"Opposite direction","explanation":"Signed velocity."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Velocity–Time — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area under $v$–$t$ is?', 'multiple_choice', '["Distance","Speed","Mass","Force"]'::jsonb, '"Distance"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area under $v$–$t$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of $v$–$t$ is?', 'multiple_choice', '["Acceleration","Distance","Speed","Time"]'::jsonb, '"Acceleration"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of $v$–$t$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Constant $v$ appears as?', 'multiple_choice', '["Horizontal line","Sloped line","Parabola","Vertical"]'::jsonb, '"Horizontal line"'::jsonb, 'easy', 'Unchanging.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Constant $v$ appears as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$6$ m/s for $10$ s. Distance?', 'multiple_choice', '["$60$ m","$16$ m","$0.6$ m","$600$ m"]'::jsonb, '"$60$ m"'::jsonb, 'easy', 'Product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$6$ m/s for $10$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Uniform accel $v$–$t$ shape?', 'multiple_choice', '["Straight sloped","Horizontal","Circle","Random"]'::jsonb, '"Straight sloped"'::jsonb, 'easy', 'Linear $v$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Uniform accel $v$–$t$ shape?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Negative $v$ means?', 'multiple_choice', '["Opposite direction","Slow only","At rest","No distance"]'::jsonb, '"Opposite direction"'::jsonb, 'easy', 'Sign.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Negative $v$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Acceleration units?', 'multiple_choice', '["m/s$^2$","m/s","m","s"]'::jsonb, '"m/s$^2$"'::jsonb, 'easy', 'SI units.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Acceleration units?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v$: $2$ to $14$ in $4$ s. $a$?', 'multiple_choice', '["$3$ m/s$^2$","$12$ m/s$^2$","$3.5$ m/s$^2$","$16$ m/s$^2$"]'::jsonb, '"$3$ m/s$^2$"'::jsonb, 'medium', '$12/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v$: $2$ to $14$ in $4$ s. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v=5$ for $6$ s. Distance?', 'multiple_choice', '["$30$ m","$11$ m","$1.2$ m","$25$ m"]'::jsonb, '"$30$ m"'::jsonb, 'medium', 'Area.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v=5$ for $6$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle base $8$ s height $10$. Distance?', 'multiple_choice', '["$40$ m","$80$ m","$18$ m","$20$ m"]'::jsonb, '"$40$ m"'::jsonb, 'medium', '$\frac{1}{2}(80)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle base $8$ s height $10$. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Deceleration shown as?', 'multiple_choice', '["Negative gradient","Positive gradient","Horizontal","Area"]'::jsonb, '"Negative gradient"'::jsonb, 'medium', '$v$ decreasing.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Deceleration shown as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$0$ to $20$ m/s in $5$ s from rest. Distance?', 'multiple_choice', '["$50$ m","$100$ m","$25$ m","$20$ m"]'::jsonb, '"$50$ m"'::jsonb, 'medium', 'Triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$0$ to $20$ m/s in $5$ s from rest. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v=-4$ for $3$ s. Distance magnitude?', 'multiple_choice', '["$12$ m","$7$ m","$1.3$ m","$-12$ m"]'::jsonb, '"$12$ m"'::jsonb, 'medium', '$4 \times 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v=-4$ for $3$ s. Distance magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$6$ and $10$ m/s each $2$ s. Total $s$?', 'multiple_choice', '["$32$ m","$16$ m","$12$ m","$20$ m"]'::jsonb, '"$32$ m"'::jsonb, 'medium', '$12+20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$6$ and $10$ m/s each $2$ s. Total $s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$12$ m/s for $3$ s then decel to $0$ in $4$ s. Total distance?', 'multiple_choice', '["$60$ m","$36$ m","$48$ m","$84$ m"]'::jsonb, '"$60$ m"'::jsonb, 'hard', '$36+24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$12$ m/s for $3$ s then decel to $0$ in $4$ s. Total distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$a=2$ from rest $8$ s. $v$ and $s$?', 'multiple_choice', '["$v=16$, $s=64$","$v=8$ only","$s=32$","$v=4$"]'::jsonb, '"$v=16$, $s=64$"'::jsonb, 'hard', 'SUVAT.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$a=2$ from rest $8$ s. $v$ and $s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Accel $4$ m/s$^2$ for $5$ s then constant $5$ s. $s$?', 'multiple_choice', '["$150$ m","$100$ m","$50$ m","$200$ m"]'::jsonb, '"$150$ m"'::jsonb, 'hard', 'Two parts.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Accel $4$ m/s$^2$ for $5$ s then constant $5$ s. $s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v$: $20$ to $-10$ in $6$ s. $a$?', 'multiple_choice', '["$-5$ m/s$^2$","$5$ m/s$^2$","$-30$ m/s$^2$","$30$ m/s$^2$"]'::jsonb, '"$-5$ m/s$^2$"'::jsonb, 'hard', '$-30/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v$: $20$ to $-10$ in $6$ s. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Brake $25$ to $5$ m/s in $4$ s. Distance?', 'multiple_choice', '["$60$ m","$80$ m","$100$ m","$20$ m"]'::jsonb, '"$60$ m"'::jsonb, 'hard', 'Trapezium.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Brake $25$ to $5$ m/s in $4$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Same base: triangle vs rectangle area?', 'multiple_choice', '["Triangle half rectangle for same height","Equal","Double","Zero"]'::jsonb, '"Triangle half rectangle for same height"'::jsonb, 'hard', 'Area rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Same base: triangle vs rectangle area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Accel then constant then decel: sloped sections?', 'multiple_choice', '["$2$","$1$","$3$","$0$"]'::jsonb, '"$2$"'::jsonb, 'hard', 'Accel and decel.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Accel then constant then decel: sloped sections?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Acceleration', '{"blocks":[{"type":"heading","content":"What Is Acceleration?"},{"type":"math_block","latex":"a = \\frac{v - u}{t}"},{"type":"callout","variant":"key_point","content":"Positive $a$: velocity increases in positive direction. Negative $a$: retardation."},{"type":"example","title":"$10$ to $30$ m/s in $5$ s.","steps":["$a = 20/5 = 4$ m/s$^2$."],"answer":"$4$ m/s$^2$"},{"type":"question","questionText":"Retardation means?","questionType":"multiple_choice","options":["Negative acceleration","Zero speed","Constant $v$","Max distance"],"correctAnswer":"Negative acceleration","explanation":"Slowing down."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Acceleration');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Equations of Motion', '{"blocks":[{"type":"heading","content":"SUVAT"},{"type":"paragraph","content":"$v = u + at$, $s = ut + \\frac{1}{2}at^2$, $v^2 = u^2 + 2as$."},{"type":"example","title":"From rest, $a=3$, $t=4$.","steps":["$v=12$ m/s.","$s=24$ m."],"answer":"$v=12$ m/s, $s=24$ m"},{"type":"callout","variant":"warning","content":"Use consistent SI units."},{"type":"question","questionText":"$u=5$, $a=2$, $t=3$. $v$?","questionType":"multiple_choice","options":["$11$ m/s","$8$ m/s","$6$ m/s","$15$ m/s"],"correctAnswer":"$11$ m/s","explanation":"$5+6$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Equations of Motion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Acceleration — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Acceleration"},{"type":"example","title":"Dropped stone: $u=0$, $a=10$, $t=2$.","steps":["$v=20$ m/s.","$s=20$ m."],"answer":"$v=20$ m/s, $s=20$ m"},{"type":"callout","variant":"warning","content":"State $g \\approx 10$ m/s$^2$ when used."},{"type":"question","questionText":"$20$ to $0$ in $5$ s. $a$?","questionType":"multiple_choice","options":["$-4$ m/s$^2$","$4$ m/s$^2$","$-100$ m/s$^2$","$100$ m/s$^2$"],"correctAnswer":"$-4$ m/s$^2$","explanation":"$-20/5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Acceleration — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$a=(v-u)/t$ measures?', 'multiple_choice', '["Change in velocity over time","Distance over time","Force/mass","Speed$^2$"]'::jsonb, '"Change in velocity over time"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$a=(v-u)/t$ measures?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Acceleration SI unit?', 'multiple_choice', '["m/s$^2$","m/s","N","kg"]'::jsonb, '"m/s$^2$"'::jsonb, 'easy', 'Standard.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Acceleration SI unit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'From rest $a=5$, $t=2$. $v$?', 'multiple_choice', '["$10$ m/s","$5$ m/s","$2.5$ m/s","$7$ m/s"]'::jsonb, '"$10$ m/s"'::jsonb, 'easy', '$v=at$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='From rest $a=5$, $t=2$. $v$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Negative $a$ often means?', 'multiple_choice', '["Slowing (forward motion)","Speeding up always","At rest","Turning always"]'::jsonb, '"Slowing (forward motion)"'::jsonb, 'easy', 'Context.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Negative $a$ often means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=0$, $t=4$, $a=2$. $v$?', 'multiple_choice', '["$8$ m/s","$4$ m/s","$6$ m/s","$16$ m/s"]'::jsonb, '"$8$ m/s"'::jsonb, 'easy', '$v=at$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=0$, $t=4$, $a=2$. $v$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Uniform accel on $v$–$t$?', 'multiple_choice', '["Straight line","Horizontal","Hyperbola","Circle"]'::jsonb, '"Straight line"'::jsonb, 'easy', 'Linear.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Uniform accel on $v$–$t$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$s=ut+\frac{1}{2}at^2$ gives?', 'multiple_choice', '["Distance","Velocity","Acceleration","Time"]'::jsonb, '"Distance"'::jsonb, 'easy', 'SUVAT.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$s=ut+\frac{1}{2}at^2$ gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=8$, $v=20$, $t=3$. $a$?', 'multiple_choice', '["$4$ m/s$^2$","$6$ m/s$^2$","$12$ m/s$^2$","$2.67$ m/s$^2$"]'::jsonb, '"$4$ m/s$^2$"'::jsonb, 'medium', '$12/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=8$, $v=20$, $t=3$. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=0$, $a=4$, $t=5$. $s$?', 'multiple_choice', '["$50$ m","$20$ m","$100$ m","$25$ m"]'::jsonb, '"$50$ m"'::jsonb, 'medium', 'Formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=0$, $a=4$, $t=5$. $s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v^2=u^2+2as$: $u=0$, $v=10$, $s=25$. $a$?', 'multiple_choice', '["$2$ m/s$^2$","$4$ m/s$^2$","$5$ m/s$^2$","$0.5$ m/s$^2$"]'::jsonb, '"$2$ m/s$^2$"'::jsonb, 'medium', '$100=50a$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v^2=u^2+2as$: $u=0$, $v=10$, $s=25$. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$15$ to $3$ m/s in $4$ s. $a$?', 'multiple_choice', '["$-3$ m/s$^2$","$3$ m/s$^2$","$-4.5$ m/s$^2$","$4.5$ m/s$^2$"]'::jsonb, '"$-3$ m/s$^2$"'::jsonb, 'medium', '$-12/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$15$ to $3$ m/s in $4$ s. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=6$, $a=2$, $t=4$. $v$?', 'multiple_choice', '["$14$ m/s","$8$ m/s","$12$ m/s","$10$ m/s"]'::jsonb, '"$14$ m/s"'::jsonb, 'medium', '$6+8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=6$, $a=2$, $t=4$. $v$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Free fall $g=10$: $v$ after $3$ s?', 'multiple_choice', '["$30$ m/s","$15$ m/s","$45$ m/s","$3$ m/s"]'::jsonb, '"$30$ m/s"'::jsonb, 'medium', '$gt$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Free fall $g=10$: $v$ after $3$ s?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=10$, $v=0$, $s=50$. $a$?', 'multiple_choice', '["$-1$ m/s$^2$","$1$ m/s$^2$","$-2$ m/s$^2$","$2$ m/s$^2$"]'::jsonb, '"$-1$ m/s$^2$"'::jsonb, 'medium', 'Formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=10$, $v=0$, $s=50$. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=5$, $a=2$, $t=6$. $s$?', 'multiple_choice', '["$66$ m","$60$ m","$72$ m","$36$ m"]'::jsonb, '"$66$ m"'::jsonb, 'hard', 'SUVAT.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=5$, $a=2$, $t=6$. $s$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$25$ m/s to stop in $50$ m. $a$?', 'multiple_choice', '["$-6.25$ m/s$^2$","$-12.5$ m/s$^2$","$6.25$ m/s$^2$","$-0.5$ m/s$^2$"]'::jsonb, '"$-6.25$ m/s$^2$"'::jsonb, 'hard', '$v^2$ eqn.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$25$ m/s to stop in $50$ m. $a$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ball up $u=20$, $a=-10$. Time to $v=0$?', 'multiple_choice', '["$2$ s","$4$ s","$20$ s","$10$ s"]'::jsonb, '"$2$ s"'::jsonb, 'hard', '$t=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ball up $u=20$, $a=-10$. Time to $v=0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$a=3$ for $4$ s then $a=-2$ for $6$ s. $v$ at $10$ s from rest?', 'multiple_choice', '["$0$ m/s","$12$ m/s","$6$ m/s","$-12$ m/s"]'::jsonb, '"$0$ m/s"'::jsonb, 'hard', 'Net zero.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$a=3$ for $4$ s then $a=-2$ for $6$ s. $v$ at $10$ s from rest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$18$ m/s brake $a=-6$. Stopping time?', 'multiple_choice', '["$3$ s","$6$ s","$108$ s","$1.5$ s"]'::jsonb, '"$3$ s"'::jsonb, 'hard', '$18/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$18$ m/s brake $a=-6$. Stopping time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$s=20$, $u=2$, $v=10$. $t$ from average speed?', 'multiple_choice', '["$3.33$ s approx","$2$ s","$5$ s","$10$ s"]'::jsonb, '"$3.33$ s approx"'::jsonb, 'hard', '$t=20/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$s=20$, $u=2$, $v=10$. $t$ from average speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Lift $a=2$ m/s$^2$ for $3$ s from rest. Height?', 'multiple_choice', '["$9$ m","$6$ m","$18$ m","$3$ m"]'::jsonb, '"$9$ m"'::jsonb, 'hard', '$\frac{1}{2}at^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Lift $a=2$ m/s$^2$ for $3$ s from rest. Height?');
-- ========== STATISTICS I ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Collecting Statistical Data', '{"blocks":[{"type":"heading","content":"Data Collection"},{"type":"paragraph","content":"**Statistics** studies how to collect, organise, and interpret data. **Primary data** is collected first-hand; **secondary data** comes from existing sources."},{"type":"callout","variant":"key_point","content":"**Population** = entire group of interest. **Sample** = subset used when the population is too large."},{"type":"example","title":"Survey all Form 2 students in a school vs one class.","steps":["Whole school = population (if target is school).","One class = sample of the school."],"answer":"Sample saves time but must be representative"},{"type":"question","questionText":"Census data is usually?","questionType":"multiple_choice","options":["Secondary data","Primary data you collect","Always a sample","Not statistical"],"correctAnswer":"Secondary data","explanation":"Published existing data."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Collecting Statistical Data');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Methods of Data Collection', '{"blocks":[{"type":"heading","content":"Surveys and Experiments"},{"type":"paragraph","content":"Common methods: questionnaires, interviews, observation, experiments. Choose a method that matches your question."},{"type":"example","title":"Find favourite sport in a school.","steps":["Define population: all students.","Use random sample across forms.","Avoid biased questions."],"answer":"Random sample questionnaire"},{"type":"callout","variant":"warning","content":"Biased samples (only friends, only one class) give misleading results."},{"type":"question","questionText":"Random sample means?","questionType":"multiple_choice","options":["Every member has equal chance","Pick friends only","Largest values only","No planning"],"correctAnswer":"Every member has equal chance","explanation":"Fair selection."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Methods of Data Collection');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Data Collection — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Data Collection"},{"type":"example","title":"A shop wants average daily sales for a year.","steps":["Use sales records = secondary data.","Or record each day = primary."],"answer":"Secondary from records is practical"},{"type":"callout","variant":"warning","content":"State whether data is discrete (counts) or continuous (measurements)."},{"type":"question","questionText":"Heights of students are?","questionType":"multiple_choice","options":["Continuous data","Discrete counts only","Not data","Always whole numbers only"],"correctAnswer":"Continuous data","explanation":"Can take any value in a range."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Data Collection — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Statistics studies?', 'multiple_choice', '["Data collection and interpretation","Only algebra","Geometry only","Probability only"]'::jsonb, '"Data collection and interpretation"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Statistics studies?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Primary data is?', 'multiple_choice', '["Collected first-hand","From books only","Always wrong","A graph"]'::jsonb, '"Collected first-hand"'::jsonb, 'easy', 'You gather it.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Primary data is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A sample is?', 'multiple_choice', '["Subset of population","Whole population","A graph","A formula"]'::jsonb, '"Subset of population"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A sample is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Questionnaire collects?', 'multiple_choice', '["Primary data","Only secondary","No data","Angles"]'::jsonb, '"Primary data"'::jsonb, 'easy', 'Direct responses.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Questionnaire collects?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Biased sample gives?', 'multiple_choice', '["Misleading results","Perfect accuracy","No data","More marks"]'::jsonb, '"Misleading results"'::jsonb, 'easy', 'Not representative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Biased sample gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Discrete data example?', 'multiple_choice', '["Number of siblings","Height exact","Weight exact","Time continuous"]'::jsonb, '"Number of siblings"'::jsonb, 'easy', 'Count values.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Discrete data example?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Population in statistics means?', 'multiple_choice', '["Whole group studied","Country only","Sample size","Mean value"]'::jsonb, '"Whole group studied"'::jsonb, 'easy', 'Full target group.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Population in statistics means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Why use a sample?', 'multiple_choice', '["Population too large/costly","Always more accurate","Required by law only","Never useful"]'::jsonb, '"Population too large/costly"'::jsonb, 'medium', 'Practicality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Why use a sample?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Random sampling reduces?', 'multiple_choice', '["Selection bias","All errors","Need for data","Sample size"]'::jsonb, '"Selection bias"'::jsonb, 'medium', 'Fairness.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Random sampling reduces?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Marks out of $100$ are?', 'multiple_choice', '["Discrete if whole marks","Always continuous","Not data","Secondary only"]'::jsonb, '"Discrete if whole marks"'::jsonb, 'medium', 'Integer scores.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Marks out of $100$ are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Secondary data source?', 'multiple_choice', '["Published reports","Your new survey","Coin flip","Compass"]'::jsonb, '"Published reports"'::jsonb, 'medium', 'Existing records.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Secondary data source?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Leading question causes?', 'multiple_choice', '["Bias","Randomness","Larger sample","Better mean"]'::jsonb, '"Bias"'::jsonb, 'medium', 'Skews answers.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Leading question causes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Continuous data measured with?', 'multiple_choice', '["Ruler/scale","Counting people only","Tally without units","Dice only"]'::jsonb, '"Ruler/scale"'::jsonb, 'medium', 'Measurements.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Continuous data measured with?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Census vs sample: census is?', 'multiple_choice', '["Whole population","Small part only","A graph","Mean only"]'::jsonb, '"Whole population"'::jsonb, 'medium', 'Complete count.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Census vs sample: census is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'School $800$ students; survey $80$ random. Sample %?', 'multiple_choice', '["$10\\%$","$80\\%$","$1\\%$","$8\\%$"]'::jsonb, '"$10\\%$"'::jsonb, 'hard', '$80/800$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='School $800$ students; survey $80$ random. Sample %?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Only volleyball team surveyed for favourite sport. Problem?', 'multiple_choice', '["Biased sample","Random sample","Too large","No problem"]'::jsonb, '"Biased sample"'::jsonb, 'hard', 'Not representative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Only volleyball team surveyed for favourite sport. Problem?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Compare primary vs secondary for traffic counts.', 'multiple_choice', '["Primary: observe; secondary: police records","Both primary only","Neither valid","Same always"]'::jsonb, '"Primary: observe; secondary: police records"'::jsonb, 'hard', 'Method choice.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Compare primary vs secondary for traffic counts.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Discrete: buses per day. Continuous: journey time.', 'multiple_choice', '["Both statements true","Both false","First false","Second false"]'::jsonb, '"Both statements true"'::jsonb, 'hard', 'Type classification.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Discrete: buses per day. Continuous: journey time.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sample size increases generally?', 'multiple_choice', '["Reduces sampling error","Removes all bias always","Makes data discrete","Eliminates mean"]'::jsonb, '"Reduces sampling error"'::jsonb, 'hard', 'Better estimate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sample size increases generally?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stratified sample by form ensures?', 'multiple_choice', '["Representation from each form","Only top students","No randomness","Smaller data"]'::jsonb, '"Representation from each form"'::jsonb, 'hard', 'Proportional groups.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stratified sample by form ensures?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Farmer tests fertiliser on one corner only. Issue?', 'multiple_choice', '["Not representative of whole field","Perfect experiment","Secondary data","No issue"]'::jsonb, '"Not representative of whole field"'::jsonb, 'hard', 'Location bias.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Farmer tests fertiliser on one corner only. Issue?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Organising Data in Tables', '{"blocks":[{"type":"heading","content":"Frequency Tables"},{"type":"paragraph","content":"A **frequency table** shows how often each value (or class) occurs."},{"type":"table","rows":[["Score","Tally","Frequency"],["$10$","||||","$4$"],["$15$","|||","$3$"]],"caption":"Simple frequency table"},{"type":"callout","variant":"key_point","content":"Total frequency = sum of all class frequencies."},{"type":"question","questionText":"Frequency means?","questionType":"multiple_choice","options":["How often a value occurs","The mean","The largest value","Sample size only"],"correctAnswer":"How often a value occurs","explanation":"Count per category."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Organising Data in Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Grouped Frequency Tables', '{"blocks":[{"type":"heading","content":"Class Intervals"},{"type":"paragraph","content":"For large data, group into **class intervals** e.g. $10$–$19$, $20$–$29$. **Class width** = upper boundary minus lower (with consistency)."},{"type":"example","title":"Data: $12,15,18,22,25,27$. Classes $10$–$19$ and $20$–$29$.","steps":["First class frequency $3$.","Second class frequency $3$."],"answer":"Equal spread across two classes"},{"type":"callout","variant":"warning","content":"Agree class boundaries: $20$ may belong to $20$–$29$ only, not $10$–$19$."},{"type":"question","questionText":"Class $30$–$39$ width?","questionType":"multiple_choice","options":["$10$","$9$","$30$","$39$"],"correctAnswer":"$10$","explanation":"$39-29$ if boundaries $30$–$39$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Grouped Frequency Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Frequency Tables — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Frequency Tables"},{"type":"example","title":"Thirty test marks grouped. Find missing frequency if total is $30$ and others sum to $26$.","steps":["Missing $= 30 - 26 = 4$."],"answer":"$4$"},{"type":"callout","variant":"warning","content":"Check frequencies sum to sample size."},{"type":"question","questionText":"Cumulative frequency at a row includes?","questionType":"multiple_choice","options":["All frequencies up to that row","Only that row","The mean","Class width"],"correctAnswer":"All frequencies up to that row","explanation":"Running total."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Frequency Tables — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frequency table shows?', 'multiple_choice', '["Counts of values","Angles only","Equations","Graph gradient"]'::jsonb, '"Counts of values"'::jsonb, 'easy', 'Purpose.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frequency table shows?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Total frequency equals?', 'multiple_choice', '["Sum of all frequencies","Largest frequency","Class width","Mean"]'::jsonb, '"Sum of all frequencies"'::jsonb, 'easy', 'Add all.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Total frequency equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tally marks help?', 'multiple_choice', '["Count data quickly","Find mean directly","Draw circles","Solve inequalities"]'::jsonb, '"Count data quickly"'::jsonb, 'easy', 'Recording tool.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tally marks help?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class interval groups?', 'multiple_choice', '["Similar values together","Random order","Only outliers","Angles"]'::jsonb, '"Similar values together"'::jsonb, 'easy', 'Grouping.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class interval groups?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$5$ students scored $8$. Frequency of $8$?', 'multiple_choice', '["$5$","$8$","$40$","$3$"]'::jsonb, '"$5$"'::jsonb, 'easy', 'Count.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$5$ students scored $8$. Frequency of $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Grouped data uses?', 'multiple_choice', '["Class intervals","Only single values","No table","Vectors"]'::jsonb, '"Class intervals"'::jsonb, 'easy', 'Ranges.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Grouped data uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Modal class has?', 'multiple_choice', '["Highest frequency","Lowest frequency","Zero frequency","Widest class only"]'::jsonb, '"Highest frequency"'::jsonb, 'easy', 'Most common group.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Modal class has?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Classes $0$–$9$, $10$–$19$, $20$–$29$. Value $15$ goes in?', 'multiple_choice', '["$10$–$19$","$0$–$9$","$20$–$29$","None"]'::jsonb, '"$10$–$19$"'::jsonb, 'medium', 'Match interval.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Classes $0$–$9$, $10$–$19$, $20$–$29$. Value $15$ goes in?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frequencies $5,8,7$. Total data items?', 'multiple_choice', '["$20$","$15$","$8$","$35$"]'::jsonb, '"$20$"'::jsonb, 'medium', 'Sum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frequencies $5,8,7$. Total data items?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class width $5$–$14$ (width $10$). Next class starts?', 'multiple_choice', '["$15$","$14$","$10$","$5$"]'::jsonb, '"$15$"'::jsonb, 'medium', 'Consecutive classes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class width $5$–$14$ (width $10$). Next class starts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mid-value of $20$–$29$ for estimates?', 'multiple_choice', '["$24.5$","$20$","$29$","$9$"]'::jsonb, '"$24.5$"'::jsonb, 'medium', 'Class midpoint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mid-value of $20$–$29$ for estimates?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cumulative freq $12$ at row $3$ means?', 'multiple_choice', '["$12$ values up to row $3$","$12$ in row $3$ only","Mean is $12$","Width $12$"]'::jsonb, '"$12$ values up to row $3$"'::jsonb, 'medium', 'Running sum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cumulative freq $12$ at row $3$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stem-and-leaf is similar to?', 'multiple_choice', '["Frequency table","Circle theorem","Vector sum","Inequality"]'::jsonb, '"Frequency table"'::jsonb, 'medium', 'Organised list.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stem-and-leaf is similar to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Outlier may appear as?', 'multiple_choice', '["Class with very low frequency alone","Always modal class","Mean class","Widest class"]'::jsonb, '"Class with very low frequency alone"'::jsonb, 'medium', 'Unusual value.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Outlier may appear as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Grouped: $10$–$19$ freq $4$, $20$–$29$ freq $6$, $30$–$39$ freq $5$. Total?', 'multiple_choice', '["$15$","$14$","$39$","$10$"]'::jsonb, '"$15$"'::jsonb, 'hard', 'Sum freqs.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Grouped: $10$–$19$ freq $4$, $20$–$29$ freq $6$, $30$–$39$ freq $5$. Total?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Missing frequency: totals $50$, known sum $47$.', 'multiple_choice', '["$3$","$7$","$47$","$50$"]'::jsonb, '"$3$"'::jsonb, 'hard', 'Difference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Missing frequency: totals $50$, known sum $47$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equal class widths $5$. Classes $0$–$4$, $5$–$9$, $10$–$14$. Value $9$ in?', 'multiple_choice', '["$5$–$9$","$0$–$4$","$10$–$14$","Two classes"]'::jsonb, '"$5$–$9$"'::jsonb, 'hard', 'Upper bound $9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equal class widths $5$. Classes $0$–$4$, $5$–$9$, $10$–$14$. Value $9$ in?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Histogram height uses?', 'multiple_choice', '["Frequency density if widths differ","Always frequency only","Class width only","Mean"]'::jsonb, '"Frequency density if widths differ"'::jsonb, 'hard', 'Area rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Histogram height uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$40$ students: $20$–$29$ has freq $12$. Proportion?', 'multiple_choice', '["$30\\%$","$12\\%$","$29\\%$","$40\\%$"]'::jsonb, '"$30\\%$"'::jsonb, 'hard', '$12/40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$40$ students: $20$–$29$ has freq $12$. Proportion?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cumulative freq $25$ of $50$ at median class means?', 'multiple_choice', '["Median in that class","Median is $25$","All below $25$","No median"]'::jsonb, '"Median in that class"'::jsonb, 'hard', 'Middle position.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cumulative freq $25$ of $50$ at median class means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two-way table: boys/girls vs sport. Shows?', 'multiple_choice', '["Joint frequencies","Only means","Angles","Vectors"]'::jsonb, '"Joint frequencies"'::jsonb, 'hard', 'Cross-classification.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two-way table: boys/girls vs sport. Shows?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mean, Median and Mode', '{"blocks":[{"type":"heading","content":"Averages"},{"type":"math_block","latex":"\\text{Mean} = \\frac{\\sum x}{n}"},{"type":"paragraph","content":"**Median** = middle value when ordered. **Mode** = most frequent value."},{"type":"callout","variant":"key_point","content":"Mean uses all values; median resists outliers; mode suits categorical data."},{"type":"example","title":"Data: $3,5,5,7,9$.","steps":["Mean $= 29/5 = 5.8$.","Median $= 5$.","Mode $= 5$."],"answer":"Mean $5.8$, median $5$, mode $5$"},{"type":"question","questionText":"Median of $4,7,9$?","questionType":"multiple_choice","options":["$7$","$4$","$9$","$6.67$"],"correctAnswer":"$7$","explanation":"Middle value."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mean, Median and Mode');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Averages from Frequency Tables', '{"blocks":[{"type":"heading","content":"Mean from a Table"},{"type":"paragraph","content":"Mean from grouped data: use midpoints $\\times$ frequency, sum, divide by total $n$."},{"type":"example","title":"Class $10$–$19$ freq $3$, midpoint $14.5$.","steps":["Contribution $= 3 \\times 14.5 = 43.5$.","Add all classes, divide by $n$."],"answer":"Estimated mean from midpoints"},{"type":"callout","variant":"warning","content":"Grouped mean is an estimate — actual values unknown within classes."},{"type":"question","questionText":"Mode from $2,3,3,5$?","questionType":"multiple_choice","options":["$3$","$2$","$5$","$3.25$"],"correctAnswer":"$3$","explanation":"Most frequent."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Averages from Frequency Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Averages — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Mean, Median, Mode"},{"type":"example","title":"Test marks: $45,50,50,55,60,95$. Compare mean and median.","steps":["Mean pulled up by $95$.","Median $= 52.5$ between $50$ and $55$."],"answer":"Median better represents typical student"},{"type":"callout","variant":"warning","content":"State which average you use and why when answering word problems."},{"type":"question","questionText":"$6$ values: median position?","questionType":"multiple_choice","options":["Average of $3$rd and $4$th","$3$rd only","$4$th only","$6$th"],"correctAnswer":"Average of $3$rd and $4$th","explanation":"Even count rule."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Averages — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean formula?', 'multiple_choice', '["$\\sum x / n$","$n/\\sum x$","Largest minus smallest","Middle value only"]'::jsonb, '"$\\sum x / n$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Median is?', 'multiple_choice', '["Middle value when ordered","Most frequent","Largest","Sum"]'::jsonb, '"Middle value when ordered"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Median is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mode is?', 'multiple_choice', '["Most frequent value","Middle value","Sum divided by $n$","Range"]'::jsonb, '"Most frequent value"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mode is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean of $2,4,6$?', 'multiple_choice', '["$4$","$6$","$12$","$2$"]'::jsonb, '"$4$"'::jsonb, 'easy', '$12/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean of $2,4,6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mode of $1,2,2,3$?', 'multiple_choice', '["$2$","$1$","$3$","$2.5$"]'::jsonb, '"$2$"'::jsonb, 'easy', 'Repeats.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mode of $1,2,2,3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Median of $1,3,9$?', 'multiple_choice', '["$3$","$1$","$9$","$4.33$"]'::jsonb, '"$3$"'::jsonb, 'easy', 'Middle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Median of $1,3,9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Range equals?', 'multiple_choice', '["Max minus min","Mean minus mode","Median","Frequency"]'::jsonb, '"Max minus min"'::jsonb, 'easy', 'Spread measure.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Range equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean of $10,12,14,16$?', 'multiple_choice', '["$13$","$14$","$52$","$12$"]'::jsonb, '"$13$"'::jsonb, 'medium', '$52/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean of $10,12,14,16$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Median of $5,1,9,3$ (ordered first)?', 'multiple_choice', '["$4$","$5$","$9$","$3$"]'::jsonb, '"$4$"'::jsonb, 'medium', 'Order: $1,3,5,9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Median of $5,1,9,3$ (ordered first)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Data $2,2,8$. Mean?', 'multiple_choice', '["$4$","$2$","$8$","$6$"]'::jsonb, '"$4$"'::jsonb, 'medium', '$12/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Data $2,2,8$. Mean?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Freq: $5$ appears twice, $7$ three times. Mode?', 'multiple_choice', '["$7$","$5$","$6$","$12$"]'::jsonb, '"$7$"'::jsonb, 'medium', 'Highest freq.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Freq: $5$ appears twice, $7$ three times. Mode?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$n=7$ data. Median position?', 'multiple_choice', '["$4$th value","$3$rd","$3.5$th exact","$7$th"]'::jsonb, '"$4$th value"'::jsonb, 'medium', 'Odd count.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$n=7$ data. Median position?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Grouped mean uses?', 'multiple_choice', '["Midpoints times frequencies","Upper bounds only","Class width only","Mode only"]'::jsonb, '"Midpoints times frequencies"'::jsonb, 'medium', 'Estimate method.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Grouped mean uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Outlier affects most?', 'multiple_choice', '["Mean","Median","Mode always same","Range never"]'::jsonb, '"Mean"'::jsonb, 'medium', 'Sensitive average.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Outlier affects most?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Marks $40,45,50,50,55,100$. Mean?', 'multiple_choice', '["$56.67$ approx","$50$","$55$","$45$"]'::jsonb, '"$56.67$ approx"'::jsonb, 'hard', '$340/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Marks $40,45,50,50,55,100$. Mean?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Same data median?', 'multiple_choice', '["$50$","$55$","$45$","$56.67$"]'::jsonb, '"$50$"'::jsonb, 'hard', 'Middle between $50$ and $50$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Same data median?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class $0$–$9$ freq $2$, midpoint $4.5$; $10$–$19$ freq $3$, midpoint $14.5$. Mean estimate?', 'multiple_choice', '["$10.2$","$9.5$","$14.5$","$4.5$"]'::jsonb, '"$10.2$"'::jsonb, 'hard', '$(9+43.5)/5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class $0$–$9$ freq $2$, midpoint $4.5$; $10$–$19$ freq $3$, midpoint $14.5$. Mean estimate?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which average for shoe size sold most?', 'multiple_choice', '["Mode","Mean","Median","Range"]'::jsonb, '"Mode"'::jsonb, 'hard', 'Most popular size.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which average for shoe size sold most?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Salaries with one very high CEO: best average?', 'multiple_choice', '["Median","Mean","Mode","Range"]'::jsonb, '"Median"'::jsonb, 'hard', 'Resists outlier.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Salaries with one very high CEO: best average?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Freq table: total $n=40$, cumulative $20$ at class $4$. Median class?', 'multiple_choice', '["Class $4$","Class $1$","Last class","No median"]'::jsonb, '"Class $4$"'::jsonb, 'hard', 'Halfway position.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Freq table: total $n=40$, cumulative $20$ at class $4$. Median class?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean of grouped data is exact when?', 'multiple_choice', '["All values in class at midpoint (rare)","Always exact","Never estimate","Classes unequal"]'::jsonb, '"All values in class at midpoint (rare)"'::jsonb, 'hard', 'Otherwise estimate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean of grouped data is exact when?');
-- ========== ANGLE PROPERTIES OF A CIRCLE ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angle at the Centre and Circumference', '{"blocks":[{"type":"heading","content":"Centre vs Circumference"},{"type":"paragraph","content":"An **angle at the centre** subtended by arc $AB$ is twice the **angle at the circumference** standing on the same arc."},{"type":"math_block","latex":"\\angle AOB = 2\\angle ACB","caption":"O is centre; C on circumference"},{"type":"callout","variant":"key_point","content":"Both angles must stand on the **same arc** $AB$."},{"type":"question","questionText":"Angle at centre $80^\\circ$. Angle at circumference on same arc?","questionType":"multiple_choice","options":["$40^\\circ$","$80^\\circ$","$160^\\circ$","$20^\\circ$"],"correctAnswer":"$40^\\circ$","explanation":"Half the centre angle."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'angles_centre_circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angle at the Centre and Circumference');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using the Angle Theorem', '{"blocks":[{"type":"heading","content":"Worked Problems"},{"type":"example","title":"Centre angle $120^\\circ$. Find circumference angle.","steps":["Circumference $= 120/2 = 60^\\circ$."],"answer":"$60^\\circ$"},{"type":"callout","variant":"warning","content":"Identify which arc the angles subtend — the **minor arc** unless stated otherwise."},{"type":"example","title":"Circumference angle $35^\\circ$. Centre angle?","steps":["$2 \\times 35 = 70^\\circ$."],"answer":"$70^\\circ$"},{"type":"question","questionText":"Same arc condition is needed because?","questionType":"multiple_choice","options":["Theorem links angles on identical arc","All angles equal always","Centre angle is half","Arc length is zero"],"correctAnswer":"Theorem links angles on identical arc","explanation":"Same arc required."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'angles_centre_circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using the Angle Theorem');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Centre & Circumference — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Centre/Circumference"},{"type":"example","title":"Triangle $OAB$ isosceles with centre $O$, $\\angle AOB = 100^\\circ$. Find $\\angle OAB$.","steps":["Base angles equal in $\\triangle OAB$.","$(180-100)/2 = 40^\\circ$."],"answer":"$40^\\circ$"},{"type":"callout","variant":"warning","content":"Combine circle theorems with triangle angle sum."},{"type":"question","questionText":"Centre $140^\\circ$. Inscribed angle?","questionType":"multiple_choice","options":["$70^\\circ$","$140^\\circ$","$280^\\circ$","$35^\\circ$"],"correctAnswer":"$70^\\circ$","explanation":"Half."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'angles_centre_circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Centre & Circumference — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle at centre is ___ circumference angle on same arc.', 'multiple_choice', '["Twice","Half","Equal","Three times"]'::jsonb, '"Twice"'::jsonb, 'easy', 'Standard theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle at centre is ___ circumference angle on same arc.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre angle $60^\circ$. Circumference?', 'multiple_choice', '["$30^\\circ$","$60^\\circ$","$120^\\circ$","$15^\\circ$"]'::jsonb, '"$30^\\circ$"'::jsonb, 'easy', 'Halve.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre angle $60^\circ$. Circumference?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circumference angle $25^\circ$. Centre?', 'multiple_choice', '["$50^\\circ$","$25^\\circ$","$12.5^\\circ$","$75^\\circ$"]'::jsonb, '"$50^\\circ$"'::jsonb, 'easy', 'Double.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circumference angle $25^\circ$. Centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angles must stand on?', 'multiple_choice', '["Same arc","Different circles","Tangent only","Diameter only"]'::jsonb, '"Same arc"'::jsonb, 'easy', 'Theorem condition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angles must stand on?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre of circle is?', 'multiple_choice', '["Equidistant from all points on circle","On circumference always","Outside always","A tangent point"]'::jsonb, '"Equidistant from all points on circle"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre of circle is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Minor arc is?', 'multiple_choice', '["Shorter arc between two points","Always semicircle","Full circle","Tangent"]'::jsonb, '"Shorter arc between two points"'::jsonb, 'easy', 'Unless major specified.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Minor arc is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Inscribed angle touches?', 'multiple_choice', '["Circumference","Centre only","Outside circle","Never arc"]'::jsonb, '"Circumference"'::jsonb, 'easy', 'Vertex on circle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Inscribed angle touches?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre $110^\circ$. Inscribed?', 'multiple_choice', '["$55^\\circ$","$110^\\circ$","$220^\\circ$","$27.5^\\circ$"]'::jsonb, '"$55^\\circ$"'::jsonb, 'medium', 'Half.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre $110^\circ$. Inscribed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Inscribed $42^\circ$. Centre?', 'multiple_choice', '["$84^\\circ$","$42^\\circ$","$21^\\circ$","$126^\\circ$"]'::jsonb, '"$84^\\circ$"'::jsonb, 'medium', 'Double.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Inscribed $42^\circ$. Centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle AOB = 2x$, $\angle ACB = x$. Relationship?', 'multiple_choice', '["Centre double circumference","Equal","Sum $180$ always","Unclear"]'::jsonb, '"Centre double circumference"'::jsonb, 'medium', 'Theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle AOB = 2x$, $\angle ACB = x$. Relationship?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Isosceles $\triangle OAB$: $OA=OB$. If centre $\angle AOB=80^\circ$, $\angle OAB$?', 'multiple_choice', '["$50^\\circ$","$80^\\circ$","$40^\\circ$","$100^\\circ$"]'::jsonb, '"$50^\\circ$"'::jsonb, 'medium', '$(180-80)/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Isosceles $\triangle OAB$: $OA=OB$. If centre $\angle AOB=80^\circ$, $\angle OAB$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Semicircle angle at circumference on diameter?', 'multiple_choice', '["$90^\\circ$","$45^\\circ$","$180^\\circ$","$60^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'medium', 'Angle in semicircle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Semicircle angle at circumference on diameter?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre $200^\circ$ on major arc thinking. Minor arc centre?', 'multiple_choice', '["$160^\\circ$","$200^\\circ$","$80^\\circ$","$100^\\circ$"]'::jsonb, '"$160^\\circ$"'::jsonb, 'medium', '$360-200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre $200^\circ$ on major arc thinking. Minor arc centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two inscribed angles on same arc?', 'multiple_choice', '["Equal","Always supplementary","Always $90$","Unrelated"]'::jsonb, '"Equal"'::jsonb, 'medium', 'Same arc theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two inscribed angles on same arc?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre $3x$, inscribed $x+10$ on same arc. Find $x$.', 'multiple_choice', '["$10$","$5$","$20$","$30$"]'::jsonb, '"$10$"'::jsonb, 'hard', '$3x=2(x+10)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre $3x$, inscribed $x+10$ on same arc. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\triangle OAB$ with $\angle OAB=35^\circ$, $OA=OB$. $\angle AOB$?', 'multiple_choice', '["$110^\\circ$","$70^\\circ$","$35^\\circ$","$145^\\circ$"]'::jsonb, '"$110^\\circ$"'::jsonb, 'hard', 'Isosceles base angles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\triangle OAB$ with $\angle OAB=35^\circ$, $OA=OB$. $\angle AOB$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Inscribed angles $A$ and $B$ on same arc $48^\circ$ and $48^\circ$. Arc measure at centre?', 'multiple_choice', '["$96^\\circ$","$48^\\circ$","$24^\\circ$","$192^\\circ$"]'::jsonb, '"$96^\\circ$"'::jsonb, 'hard', 'Double inscribed.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Inscribed angles $A$ and $B$ on same arc $48^\circ$ and $48^\circ$. Arc measure at centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chord $AB$: centre $\angle AOB=130^\circ$. Point $C$ on major arc. $\angle ACB$?', 'multiple_choice', '["$65^\\circ$","$130^\\circ$","$50^\\circ$","$115^\\circ$"]'::jsonb, '"$65^\\circ$"'::jsonb, 'hard', 'Half centre on minor arc.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chord $AB$: centre $\angle AOB=130^\circ$. Point $C$ on major arc. $\angle ACB$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre $72^\circ$, inscribed on same minor arc?', 'multiple_choice', '["$36^\\circ$","$72^\\circ$","$144^\\circ$","$18^\\circ$"]'::jsonb, '"$36^\\circ$"'::jsonb, 'hard', 'Halve.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre $72^\circ$, inscribed on same minor arc?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle ACB=38^\circ$. Centre angle on same arc?', 'multiple_choice', '["$76^\\circ$","$38^\\circ$","$152^\\circ$","$19^\\circ$"]'::jsonb, '"$76^\\circ$"'::jsonb, 'hard', 'Double inscribed.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle ACB=38^\circ$. Centre angle on same arc?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular hexagon in circle: centre angle per side?', 'multiple_choice', '["$60^\\circ$","$120^\\circ$","$30^\\circ$","$90^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'hard', '$360/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_centre_circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular hexagon in circle: centre angle per side?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cyclic Quadrilaterals', '{"blocks":[{"type":"heading","content":"Opposite Angles"},{"type":"paragraph","content":"A **cyclic quadrilateral** has all vertices on a circle. **Opposite angles sum to $180^\\circ$**."},{"type":"math_block","latex":"\\angle A + \\angle C = 180^\\circ,\\quad \\angle B + \\angle D = 180^\\circ"},{"type":"callout","variant":"key_point","content":"If opposite angles sum to $180^\\circ$, the quadrilateral is cyclic."},{"type":"question","questionText":"Cyclic quad: one angle $70^\\circ$. Opposite?","questionType":"multiple_choice","options":["$110^\\circ$","$70^\\circ$","$180^\\circ$","$90^\\circ$"],"correctAnswer":"$110^\\circ$","explanation":"$180-70$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'cyclic_quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cyclic Quadrilaterals');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Proving and Using Cyclic Properties', '{"blocks":[{"type":"heading","content":"Exterior Angles"},{"type":"paragraph","content":"An exterior angle of a cyclic quadrilateral equals the **interior opposite angle**."},{"type":"example","title":"Cyclic $ABCD$: $\\angle A = 85^\\circ$. Find $\\angle C$.","steps":["$\\angle C = 180 - 85 = 95^\\circ$."],"answer":"$95^\\circ$"},{"type":"callout","variant":"warning","content":"Do not confuse adjacent angles with opposite angles."},{"type":"question","questionText":"$\\angle B = 100^\\circ$ in cyclic quad. $\\angle D$?","questionType":"multiple_choice","options":["$80^\\circ$","$100^\\circ$","$280^\\circ$","$50^\\circ$"],"correctAnswer":"$80^\\circ$","explanation":"Supplementary opposite."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'cyclic_quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Proving and Using Cyclic Properties');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cyclic Quadrilaterals — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Cyclic Quadrilaterals"},{"type":"example","title":"$ABCD$ cyclic, $\\angle ABC = 65^\\circ$, $\\angle BCD = 110^\\circ$. Find $\\angle BAD$.","steps":["$\\angle ADC = 180 - 65 = 115^\\circ$ (opposite).","$\\angle BAD = 180 - 110 = 70^\\circ$ (opposite)."],"answer":"$\\angle BAD = 70^\\circ$"},{"type":"callout","variant":"warning","content":"Draw the circle sketch and label arcs — method marks in KCSE."},{"type":"question","questionText":"Exterior angle at $B$ equals?","questionType":"multiple_choice","options":["Interior opposite $\\angle D$","$\\angle B$","$\\angle A$","$90^\\circ$ always"],"correctAnswer":"Interior opposite $\\angle D$","explanation":"Exterior angle theorem."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'cyclic_quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cyclic Quadrilaterals — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclic quadrilateral vertices lie?', 'multiple_choice', '["On a circle","On a line only","At centre","Outside circle"]'::jsonb, '"On a circle"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclic quadrilateral vertices lie?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Opposite angles in cyclic quad sum to?', 'multiple_choice', '["$180^\\circ$","$90^\\circ$","$360^\\circ$","$0^\\circ$"]'::jsonb, '"$180^\\circ$"'::jsonb, 'easy', 'Theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Opposite angles in cyclic quad sum to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'One angle $95^\circ$. Opposite?', 'multiple_choice', '["$85^\\circ$","$95^\\circ$","$180^\\circ$","$45^\\circ$"]'::jsonb, '"$85^\\circ$"'::jsonb, 'easy', 'Supplement.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='One angle $95^\circ$. Opposite?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclic quad has how many vertices on circle?', 'multiple_choice', '["$4$","$3$","$2$","$6$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Quadrilateral.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclic quad has how many vertices on circle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If opposite angles sum $180$, shape is?', 'multiple_choice', '["Cyclic","Never cyclic","Square only","Rectangle only"]'::jsonb, '"Cyclic"'::jsonb, 'easy', 'Converse.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If opposite angles sum $180$, shape is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle A=60$ cyclic. $\angle C$?', 'multiple_choice', '["$120^\\circ$","$60^\\circ$","$30^\\circ$","$180^\\circ$"]'::jsonb, '"$120^\\circ$"'::jsonb, 'easy', 'Opposite.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle A=60$ cyclic. $\angle C$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Exterior angle property useful for?', 'multiple_choice', '["Finding interior opposite","Finding centre","Area","Speed"]'::jsonb, '"Finding interior opposite"'::jsonb, 'easy', 'Circle geometry.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Exterior angle property useful for?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle B=72^\circ$, cyclic. $\angle D$?', 'multiple_choice', '["$108^\\circ$","$72^\\circ$","$36^\\circ$","$180^\\circ$"]'::jsonb, '"$108^\\circ$"'::jsonb, 'medium', 'Supplement.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle B=72^\circ$, cyclic. $\angle D$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle A=3x$, $\angle C=120^\circ$, cyclic. $x$?', 'multiple_choice', '["$20$","$40$","$60$","$30$"]'::jsonb, '"$20$"'::jsonb, 'medium', '$3x+120=180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle A=3x$, $\angle C=120^\circ$, cyclic. $x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Exterior at $A$ is $115^\circ$. Interior $\angle A$?', 'multiple_choice', '["$65^\\circ$","$115^\\circ$","$180^\\circ$","$295^\\circ$"]'::jsonb, '"$65^\\circ$"'::jsonb, 'medium', 'Linear pair.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Exterior at $A$ is $115^\circ$. Interior $\angle A$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle B=\angle D$ in cyclic quad. Each equals?', 'multiple_choice', '["$90^\\circ$ if supplementary equal","$45^\\circ$ always","$180^\\circ$","Cannot tell"]'::jsonb, '"$90^\\circ$ if supplementary equal"'::jsonb, 'medium', '$B+D=180$ and equal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle B=\angle D$ in cyclic quad. Each equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three angles of cyclic quad known. Fourth from?', 'multiple_choice', '["$360$ minus sum of three","Always $90$","Double one angle","Half sum"]'::jsonb, '"$360$ minus sum of three"'::jsonb, 'medium', 'Quad angle sum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three angles of cyclic quad known. Fourth from?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is cyclic: opposite $70$ and $110$?', 'multiple_choice', '["Yes","No","Only if square","Never"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Sum $180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is cyclic: opposite $70$ and $110$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle ABC=80$, exterior at $C$ related to $\angle A$?', 'multiple_choice', '["$\\angle A$ equals exterior at $C$ if positioned","Always equal $80$","No relation","$180$"]'::jsonb, '"$\\angle A$ equals exterior at $C$ if positioned"'::jsonb, 'medium', 'Exterior theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle ABC=80$, exterior at $C$ related to $\angle A$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclic $ABCD$: $\angle A=2x$, $\angle C=x+40$. Find $x$.', 'multiple_choice', '["$46.67$ approx","$40$","$20$","$60$"]'::jsonb, '"$46.67$ approx"'::jsonb, 'hard', '$2x+x+40=180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclic $ABCD$: $\angle A=2x$, $\angle C=x+40$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle B=95^\circ$, $\angle C=70^\circ$, cyclic. $\angle A$?', 'multiple_choice', '["$110^\\circ$","$115^\\circ$","$85^\\circ$","$70^\\circ$"]'::jsonb, '"$110^\\circ$"'::jsonb, 'hard', '$A$ opposite $C$: $180-70$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle B=95^\circ$, $\angle C=70^\circ$, cyclic. $\angle A$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Exterior $\angle B=125^\circ$. Interior opposite $\angle D$?', 'multiple_choice', '["$125^\\circ$","$55^\\circ$","$180^\\circ$","$65^\\circ$"]'::jsonb, '"$125^\\circ$"'::jsonb, 'hard', 'Exterior equals interior opposite.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Exterior $\angle B=125^\circ$. Interior opposite $\angle D$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclic trapezium (isosceles) base angles?', 'multiple_choice', '["Equal","Supplementary only","All $90^\\circ$","All $60^\\circ$"]'::jsonb, '"Equal"'::jsonb, 'hard', 'Symmetry.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclic trapezium (isosceles) base angles?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle A=85^\circ$, $\angle B=95^\circ$, cyclic. Find $\angle C$.', 'multiple_choice', '["$95^\\circ$","$85^\\circ$","$105^\\circ$","$75^\\circ$"]'::jsonb, '"$95^\\circ$"'::jsonb, 'hard', '$C$ opposite $A$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle A=85^\circ$, $\angle B=95^\circ$, cyclic. Find $\angle C$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equal angles in same segment subtend?', 'multiple_choice', '["Same arc on circle","Parallel chords","Tangent","Diameter only"]'::jsonb, '"Same arc on circle"'::jsonb, 'hard', 'Segment theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equal angles in same segment subtend?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$ABCD$ cyclic, $AB$ diameter. $\angle ACB$?', 'multiple_choice', '["$90^\\circ$","$45^\\circ$","$180^\\circ$","$60^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'hard', 'Angle in semicircle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cyclic_quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$ABCD$ cyclic, $AB$ diameter. $\angle ACB$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangent to a Circle', '{"blocks":[{"type":"heading","content":"Tangent Properties"},{"type":"paragraph","content":"A **tangent** touches the circle at exactly one point. The tangent is **perpendicular to the radius** at the point of contact."},{"type":"math_block","latex":"OT \\perp \\text{tangent at } T"},{"type":"callout","variant":"key_point","content":"Angle between tangent and radius at contact $= 90^\\circ$."},{"type":"question","questionText":"Tangent meets radius at contact at?","questionType":"multiple_choice","options":["$90^\\circ$","$45^\\circ$","$180^\\circ$","$0^\\circ$"],"correctAnswer":"$90^\\circ$","explanation":"Perpendicular."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'tangent_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangent to a Circle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangents from an External Point', '{"blocks":[{"type":"heading","content":"Equal Tangents"},{"type":"paragraph","content":"Tangents drawn from an external point to a circle are **equal in length**."},{"type":"example","title":"External point $P$, tangents $PA$ and $PB$.","steps":["$PA = PB$.","Triangles $OAP$ and $OBP$ congruent (RHS)."],"answer":"Equal tangent lengths"},{"type":"callout","variant":"warning","content":"Use right angles at $A$ and $B$ where tangents touch."},{"type":"question","questionText":"$PA=8$ cm from external point. $PB$?","questionType":"multiple_choice","options":["$8$ cm","$4$ cm","$16$ cm","Unknown"],"correctAnswer":"$8$ cm","explanation":"Equal tangents."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'tangent_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangents from an External Point');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangent Angles — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Tangents"},{"type":"example","title":"Tangent at $T$, radius $OT$, point $Q$ on tangent. $\\angle OTP=90^\\circ$. If $\\angle TOP=35^\\circ$, find other angles in $\\triangle OTP$.","steps":["Right angle at $T$.","Third angle $= 55^\\circ$."],"answer":"$55^\\circ$ at $P$ if configured"},{"type":"callout","variant":"warning","content":"Alternate segment theorem links tangent-chord angles (extension in later forms)."},{"type":"question","questionText":"Radius $6$ cm, tangent from $10$ cm away (perpendicular). Tangent length?","questionType":"multiple_choice","options":["$8$ cm","$6$ cm","$10$ cm","$16$ cm"],"correctAnswer":"$8$ cm","explanation":"$\\sqrt{100-36}$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle' AND st.code = 'tangent_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangent Angles — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent touches circle at?', 'multiple_choice', '["One point","Two points","All points","No points"]'::jsonb, '"One point"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent touches circle at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent perpendicular to?', 'multiple_choice', '["Radius at contact","Chord always","Diameter only","Another tangent"]'::jsonb, '"Radius at contact"'::jsonb, 'easy', 'Key property.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent perpendicular to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle radius-tangent at contact?', 'multiple_choice', '["$90^\\circ$","$45^\\circ$","$60^\\circ$","$180^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'easy', 'Perpendicular.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle radius-tangent at contact?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangents from external point are?', 'multiple_choice', '["Equal length","Unequal always","Parallel","Perpendicular"]'::jsonb, '"Equal length"'::jsonb, 'easy', 'Theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangents from external point are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$PA=5$ cm tangent. $PB$ from same point?', 'multiple_choice', '["$5$ cm","$10$ cm","$2.5$ cm","$0$ cm"]'::jsonb, '"$5$ cm"'::jsonb, 'easy', 'Equal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$PA=5$ cm tangent. $PB$ from same point?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent line lies?', 'multiple_choice', '["Outside except contact point","Inside circle","Through centre","Is a chord"]'::jsonb, '"Outside except contact point"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent line lies?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point of contact is?', 'multiple_choice', '["Where tangent touches","Centre","External point","Chord midpoint"]'::jsonb, '"Where tangent touches"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point of contact is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $5$, distance from centre to external point $13$. Tangent length?', 'multiple_choice', '["$12$","$8$","$18$","$5$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Pythagoras.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $5$, distance from centre to external point $13$. Tangent length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle OTA=90^\circ$ at contact $T$. True?', 'multiple_choice', '["Yes","No","Only if diameter","Only if chord"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Tangent-radius.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle OTA=90^\circ$ at contact $T$. True?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two tangents from $P$ make equal angles with line $OP$?', 'multiple_choice', '["Yes (symmetry)","No","Always $45$","Never"]'::jsonb, '"Yes (symmetry)"'::jsonb, 'medium', 'Congruent triangles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two tangents from $P$ make equal angles with line $OP$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $OA=7$ and $OP=25$, tangent $PA$?', 'multiple_choice', '["$24$","$18$","$32$","$7$"]'::jsonb, '"$24$"'::jsonb, 'medium', '$\sqrt{625-49}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $OA=7$ and $OP=25$, tangent $PA$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent and radius meet; triangle at centre often?', 'multiple_choice', '["Right-angled","Equilateral","Obtuse only","Degenerate"]'::jsonb, '"Right-angled"'::jsonb, 'medium', '90 at contact.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent and radius meet; triangle at centre often?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'External point has how many equal tangents?', 'multiple_choice', '["$2$","$1$","$3$","Infinite"]'::jsonb, '"$2$"'::jsonb, 'medium', 'Typical diagram.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='External point has how many equal tangents?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chord vs tangent at endpoint?', 'multiple_choice', '["Tangent one intersection","Chord two","Same","Neither touches"]'::jsonb, '"Tangent one intersection"'::jsonb, 'medium', 'Definitions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chord vs tangent at endpoint?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circle radius $6$, external point $10$ cm from centre. Tangent length?', 'multiple_choice', '["$8$ cm","$6$ cm","$10$ cm","$4$ cm"]'::jsonb, '"$8$ cm"'::jsonb, 'hard', '$\sqrt{64}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circle radius $6$, external point $10$ cm from centre. Tangent length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$PA=PB=15$, $OP=17$, radius?', 'multiple_choice', '["$8$","$15$","$17$","$2$"]'::jsonb, '"$8$"'::jsonb, 'hard', 'Right triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$PA=PB=15$, $OP=17$, radius?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Quadrilateral $OAPB$ with tangents: $\angle OAP$?', 'multiple_choice', '["$90^\\circ$","$45^\\circ$","$180^\\circ$","$60^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'hard', 'Radius perp tangent.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Quadrilateral $OAPB$ with tangents: $\angle OAP$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent length $9$, radius $12$. Distance external to centre?', 'multiple_choice', '["$15$","$21$","$3$","$108$"]'::jsonb, '"$15$"'::jsonb, 'hard', '$\sqrt{81+144}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent length $9$, radius $12$. Distance external to centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\angle between tangents from $P$ is $80^\circ$. Angle $OP$ bisects?', 'multiple_choice', '["Yes symmetry","No","$40$ at centre always","Parallel"]'::jsonb, '"Yes symmetry"'::jsonb, 'hard', 'Equal tangents.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\angle between tangents from $P$ is $80^\circ$. Angle $OP$ bisects?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two circles external tangents — Form 2 focus: single circle tangent from $P$ length $7$, find $OP$ if $r=3$.', 'multiple_choice', '["$\\sqrt{58}$","$10$","$4$","$7$"]'::jsonb, '"$\\sqrt{58}$"'::jsonb, 'hard', '$49+9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two circles external tangents — Form 2 focus: single circle tangent from $P$ length $7$, find $OP$ if $r=3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius perpendicular to tangent helps prove?', 'multiple_choice', '["Equal tangent lengths","Area of circle","Mean median","Speed"]'::jsonb, '"Equal tangent lengths"'::jsonb, 'hard', 'Congruence RHS.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angle_properties_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius perpendicular to tangent helps prove?');
-- ========== VECTORS I ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Introduction to Vectors', '{"blocks":[{"type":"heading","content":"Scalars and Vectors"},{"type":"paragraph","content":"A **vector** has magnitude and direction. A **scalar** has magnitude only."},{"type":"math_block","latex":"\\mathbf{a} \\text{ or } \\vec{a}","caption":"Vector notation"},{"type":"callout","variant":"key_point","content":"Equal vectors have same magnitude and direction (not necessarily same position)."},{"type":"question","questionText":"Which is a vector?","questionType":"multiple_choice","options":["Displacement $5$ km east","Mass $5$ kg","Time $5$ s","Temperature $5^\\circ$C"],"correctAnswer":"Displacement $5$ km east","explanation":"Has direction."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'vector_notation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Introduction to Vectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Magnitude and Direction', '{"blocks":[{"type":"heading","content":"Modulus of a Vector"},{"type":"math_block","latex":"|\\mathbf{a}| = \\sqrt{x^2 + y^2}","caption":"For column vector $\\begin{pmatrix} x \\\\ y \\end{pmatrix}$"},{"type":"example","title":"$\\mathbf{a} = \\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$. Find $|\\mathbf{a}|$.","steps":["$|\\mathbf{a}| = \\sqrt{9+16} = 5$."],"answer":"$5$"},{"type":"callout","variant":"warning","content":"Direction is often given as bearing or angle from positive $x$-axis."},{"type":"question","questionText":"$|\\mathbf{0}|$?","questionType":"multiple_choice","options":["$0$","$1$","Undefined","$-1$"],"correctAnswer":"$0$","explanation":"Zero vector."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'vector_notation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Magnitude and Direction');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Vector Notation — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Notation"},{"type":"example","title":"Translate point $A(1,2)$ by $\\mathbf{v}=\\begin{pmatrix} 3 \\\\ -1 \\end{pmatrix}$.","steps":["$A'' = (1+3, 2+(-1)) = (4,1)$."],"answer":"$(4,1)$"},{"type":"callout","variant":"warning","content":"Use bold or arrow notation consistently in working."},{"type":"question","questionText":"Parallel vectors have?","questionType":"multiple_choice","options":["Same direction (or opposite)","Always equal length","Always zero","No direction"],"correctAnswer":"Same direction (or opposite)","explanation":"Scalar multiples."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'vector_notation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Vector Notation — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vector has?', 'multiple_choice', '["Magnitude and direction","Magnitude only","Direction only","Neither"]'::jsonb, '"Magnitude and direction"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vector has?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Scalar example?', 'multiple_choice', '["Mass","Force vector","Velocity","Displacement"]'::jsonb, '"Mass"'::jsonb, 'easy', 'No direction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Scalar example?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{a}|$ means?', 'multiple_choice', '["Magnitude of $\\mathbf{a}$","Direction","Negative vector","Unit vector always"]'::jsonb, '"Magnitude of $\\mathbf{a}$"'::jsonb, 'easy', 'Modulus.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{a}|$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(3, 4)$ magnitude?', 'multiple_choice', '["$5$","$7$","$1$","$12$"]'::jsonb, '"$5$"'::jsonb, 'easy', '3-4-5 triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(3, 4)$ magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equal vectors must have?', 'multiple_choice', '["Same magnitude and direction","Same start point","Same end only","Different directions"]'::jsonb, '"Same magnitude and direction"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equal vectors must have?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Zero vector magnitude?', 'multiple_choice', '["$0$","$1$","Undefined","$-1$"]'::jsonb, '"$0$"'::jsonb, 'easy', 'No length.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Zero vector magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Displacement is a?', 'multiple_choice', '["Vector","Scalar","Angle","Area"]'::jsonb, '"Vector"'::jsonb, 'easy', 'Directed distance.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Displacement is a?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(-6, 8)$ magnitude?', 'multiple_choice', '["$10$","$14$","$2$","$48$"]'::jsonb, '"$10$"'::jsonb, 'medium', '$\sqrt{100}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(-6, 8)$ magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Unit vector has magnitude?', 'multiple_choice', '["$1$","$0$","$-1$","Any"]'::jsonb, '"$1$"'::jsonb, 'medium', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Unit vector has magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{a}$ parallel to $\mathbf{b}$ if?', 'multiple_choice', '["$\\mathbf{a}=k\\mathbf{b}$","Always equal","Always perpendicular","Magnitudes equal only"]'::jsonb, '"$\\mathbf{a}=k\\mathbf{b}$"'::jsonb, 'medium', 'Scalar multiple.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{a}$ parallel to $\mathbf{b}$ if?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point $(2,5)$ plus $(-1, 3)$?', 'multiple_choice', '["$(1,8)$","$(3,2)$","$(1,2)$","$(3,8)$"]'::jsonb, '"$(1,8)$"'::jsonb, 'medium', 'Add components.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point $(2,5)$ plus $(-1, 3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|(1, 2)|$?', 'multiple_choice', '["$\\sqrt{5}$","$3$","$5$","$1$"]'::jsonb, '"$\\sqrt{5}$"'::jsonb, 'medium', '$\sqrt{1+4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|(1, 2)|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Velocity $30$ km/h north is?', 'multiple_choice', '["Vector","Scalar","Mass","Time"]'::jsonb, '"Vector"'::jsonb, 'medium', 'Direction included.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Velocity $30$ km/h north is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Opposite vector of $(2, -3)$?', 'multiple_choice', '["$\\begin{pmatrix} -2 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} -2 \\\\ -3 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ 2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -2 \\\\ 3 \\end{pmatrix}$"'::jsonb, 'medium', 'Negate components.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Opposite vector of $(2, -3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{a}|=5$, $\mathbf{a}=(3, y)$, $y>0$. Find $y$.', 'multiple_choice', '["$4$","$-4$","$8$","$2$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$9+y^2=25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{a}|=5$, $\mathbf{a}=(3, y)$, $y>0$. Find $y$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(1,1)$ to $B(4,5)$. Vector $\vec{AB}$?', 'multiple_choice', '["$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 5 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ -4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'hard', 'Subtract coordinates.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(1,1)$ to $B(4,5)$. Vector $\vec{AB}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{a}+\mathbf{b}|$ always equals $|\mathbf{a}|+|\mathbf{b}|$?', 'multiple_choice', '["No","Yes always","Only if zero","Only scalars"]'::jsonb, '"No"'::jsonb, 'hard', 'Triangle inequality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{a}+\mathbf{b}|$ always equals $|\mathbf{a}|+|\mathbf{b}|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vector $(12, 5)$ magnitude?', 'multiple_choice', '["$13$","$17$","$7$","$60$"]'::jsonb, '"$13$"'::jsonb, 'hard', '5-12-13.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vector $(12, 5)$ magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Translate $(-2,3)$ by $\mathbf{v}$ to $(1,7)$. $\mathbf{v}$?', 'multiple_choice', '["$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 1 \\\\ 7 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'hard', 'Difference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Translate $(-2,3)$ by $\mathbf{v}$ to $(1,7)$. $\mathbf{v}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $|\mathbf{a}|=|\mathbf{b}|$ and $\mathbf{a}\perp\mathbf{b}$, $|\mathbf{a}+\mathbf{b}|$ with $|a|=|b|=1$?', 'multiple_choice', '["$\\sqrt{2}$","$2$","$0$","$1$"]'::jsonb, '"$\\sqrt{2}$"'::jsonb, 'hard', 'Right angle add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $|\mathbf{a}|=|\mathbf{b}|$ and $\mathbf{a}\perp\mathbf{b}$, $|\mathbf{a}+\mathbf{b}|$ with $|a|=|b|=1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bearing vs column vector: east is?', 'multiple_choice', '["Positive $x$ direction","Positive $y$","Negative $x$","Up only"]'::jsonb, '"Positive $x$ direction"'::jsonb, 'hard', 'Standard axes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_notation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bearing vs column vector: east is?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Vectors', '{"blocks":[{"type":"heading","content":"Vector Addition"},{"type":"paragraph","content":"Add vectors **component-wise**. Geometrically: place tail of second at head of first (triangle/parallelogram rule)."},{"type":"math_block","latex":"\\begin{pmatrix} a_1 \\\\ a_2 \\end{pmatrix} + \\begin{pmatrix} b_1 \\\\ b_2 \\end{pmatrix} = \\begin{pmatrix} a_1+b_1 \\\\ a_2+b_2 \\end{pmatrix}"},{"type":"example","title":"$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix} + \\begin{pmatrix} -1 \\\\ 5 \\end{pmatrix}$.","steps":["$\\begin{pmatrix} 1 \\\\ 8 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 1 \\\\ 8 \\end{pmatrix}$"},{"type":"question","questionText":"$\\mathbf{a} - \\mathbf{b}$ equals?","questionType":"multiple_choice","options":["$\\mathbf{a} + (-\\mathbf{b})$","$\\mathbf{b} - \\mathbf{a}$ always","$|\\mathbf{a}|-|\\mathbf{b}|$","Scalar only"],"correctAnswer":"$\\mathbf{a} + (-\\mathbf{b})$","explanation":"Subtract via opposite."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'addition_subtraction'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Vectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Resultant Vectors', '{"blocks":[{"type":"heading","content":"Resultant"},{"type":"example","title":"Forces $\\begin{pmatrix} 4 \\\\ 0 \\end{pmatrix}$ N and $\\begin{pmatrix} 0 \\\\ 3 \\end{pmatrix}$ N. Resultant?","steps":["$\\begin{pmatrix} 4 \\\\ 3 \\end{pmatrix}$ N.","Magnitude $5$ N."],"answer":"$\\begin{pmatrix} 4 \\\\ 3 \\end{pmatrix}$ N, magnitude $5$ N"},{"type":"callout","variant":"warning","content":"Subtracting vectors: subtract each component."},{"type":"question","questionText":"$\\begin{pmatrix} 5 \\\\ 2 \\end{pmatrix} - \\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$?","questionType":"multiple_choice","options":["$\\begin{pmatrix} 2 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 8 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} -2 \\\\ 2 \\end{pmatrix}$"],"correctAnswer":"$\\begin{pmatrix} 2 \\\\ -2 \\end{pmatrix}$","explanation":"Component subtract."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'addition_subtraction'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Resultant Vectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Addition & Subtraction — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Resultants"},{"type":"example","title":"$\\vec{AB}+\\vec{BC}+\\vec{CD}$.","steps":["Chaining gives $\\vec{AD}$ (vector polygon)."],"answer":"$\\vec{AD}$"},{"type":"callout","variant":"warning","content":"Draw diagrams for word problems — displacements add head-to-tail."},{"type":"question","questionText":"$\\mathbf{a}+\\mathbf{b}=\\mathbf{b}+\\mathbf{a}$ shows?","questionType":"multiple_choice","options":["Commutative addition","No addition","Division","Dot product"],"correctAnswer":"Commutative addition","explanation":"Order does not matter."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'addition_subtraction'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Addition & Subtraction — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Add $(1, 2)$ and $(3, 4)$.', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ 6 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$"'::jsonb, 'easy', 'Add components.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Add $(1, 2)$ and $(3, 4)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Subtract $(5, 7) - (2 ,  3)$.', 'multiple_choice', '["$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 7 \\\\ 10 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ -4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'easy', 'Component subtract.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Subtract $(5, 7) - (2 ,  3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{a}+\mathbf{0}$ equals?', 'multiple_choice', '["$\\mathbf{a}$","$\\mathbf{0}$","$2\\mathbf{a}$","Undefined"]'::jsonb, '"$\\mathbf{a}$"'::jsonb, 'easy', 'Identity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{a}+\mathbf{0}$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Negative of $(4, -1)$?', 'multiple_choice', '["$\\begin{pmatrix} -4 \\\\ 1 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 1 \\end{pmatrix}$","$\\begin{pmatrix} -4 \\\\ -1 \\end{pmatrix}$","$\\begin{pmatrix} 1 \\\\ 4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -4 \\\\ 1 \\end{pmatrix}$"'::jsonb, 'easy', 'Flip signs.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Negative of $(4, -1)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Resultant means?', 'multiple_choice', '["Combined vector","Unit vector","Scalar product","Angle only"]'::jsonb, '"Combined vector"'::jsonb, 'easy', 'Sum effect.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Resultant means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(0, 0)$ plus any vector?', 'multiple_choice', '["Same vector","Zero only","Double","Undefined"]'::jsonb, '"Same vector"'::jsonb, 'easy', 'Add zero.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(0, 0)$ plus any vector?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram rule finds?', 'multiple_choice', '["Vector sum","Dot product","Magnitude only","Angle bisector"]'::jsonb, '"Vector sum"'::jsonb, 'easy', 'Geometry of add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram rule finds?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(-2, 5)+(4 ,  -3)$?', 'multiple_choice', '["$\\begin{pmatrix} 2 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 6 \\\\ 8 \\end{pmatrix}$","$\\begin{pmatrix} -6 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ -2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 2 \\\\ 2 \\end{pmatrix}$"'::jsonb, 'medium', 'Add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(-2, 5)+(4 ,  -3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|(3, 4)|$ after adding $(0, 0)$?', 'multiple_choice', '["$5$","$7$","$1$","$12$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Unchanged.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|(3, 4)|$ after adding $(0, 0)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\vec{AB}+\vec{BC}$ equals?', 'multiple_choice', '["$\\vec{AC}$","$\\vec{BA}$","$\\vec{0}$","$\\vec{CB}$"]'::jsonb, '"$\\vec{AC}$"'::jsonb, 'medium', 'Chaining.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\vec{AB}+\vec{BC}$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{a}-\mathbf{a}$ equals?', 'multiple_choice', '["$\\mathbf{0}$","$2\\mathbf{a}$","$\\mathbf{a}$","Undefined"]'::jsonb, '"$\\mathbf{0}$"'::jsonb, 'medium', 'Self cancel.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{a}-\mathbf{a}$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Resultant $(6, 8)$ magnitude?', 'multiple_choice', '["$10$","$14$","$2$","$48$"]'::jsonb, '"$10$"'::jsonb, 'medium', '6-8-10.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Resultant $(6, 8)$ magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1, -2)-(-3 ,  1)$?', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ -3 \\end{pmatrix}$","$\\begin{pmatrix} -2 \\\\ -3 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ -1 \\end{pmatrix}$","$\\begin{pmatrix} -4 \\\\ 3 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ -3 \\end{pmatrix}$"'::jsonb, 'medium', 'Subtract.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1, -2)-(-3 ,  1)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three vectors head-to-tail return to start. Sum?', 'multiple_choice', '["$\\mathbf{0}$","Largest only","Cannot sum","Scalar $3$"]'::jsonb, '"$\\mathbf{0}$"'::jsonb, 'medium', 'Closed polygon.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three vectors head-to-tail return to start. Sum?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{u}=(2, 1)$, $\mathbf{v}=(-1, 3)$. $|\mathbf{u}+\mathbf{v}|$?', 'multiple_choice', '["$\\sqrt{13}$","$5$","$\\sqrt{5}$","$3$"]'::jsonb, '"$\\sqrt{13}$"'::jsonb, 'hard', '$(1, 4)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{u}=(2, 1)$, $\mathbf{v}=(-1, 3)$. $|\mathbf{u}+\mathbf{v}|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\vec{PQ}+\vec{QR}+\vec{RS}+\vec{SP}$?', 'multiple_choice', '["$\\mathbf{0}$","$\\vec{PR}$","$\\vec{PS}$","$2\\vec{PQ}$"]'::jsonb, '"$\\mathbf{0}$"'::jsonb, 'hard', 'Closed quad.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\vec{PQ}+\vec{QR}+\vec{RS}+\vec{SP}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2\mathbf{a}+3\mathbf{b}$ with $\mathbf{a}=(1, 0)$, $\mathbf{b}=(0, 2)$.', 'multiple_choice', '["$\\begin{pmatrix} 2 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} 6 \\\\ 2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 2 \\\\ 6 \\end{pmatrix}$"'::jsonb, 'hard', 'Scale and add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2\mathbf{a}+3\mathbf{b}$ with $\mathbf{a}=(1, 0)$, $\mathbf{b}=(0, 2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Boat velocity $(4, 3)$ plus current $(0, -2)$. Resultant magnitude?', 'multiple_choice', '["$\\sqrt{17}$","$5$","$7$","$1$"]'::jsonb, '"$\\sqrt{17}$"'::jsonb, 'hard', '$(4, 1)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Boat velocity $(4, 3)$ plus current $(0, -2)$. Resultant magnitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{a}+\mathbf{b}=(7, 1)$, $\mathbf{a}=(3, -2)$. $\mathbf{b}$?', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} 10 \\\\ -1 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ -3 \\end{pmatrix}$","$\\begin{pmatrix} -4 \\\\ 3 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ 3 \\end{pmatrix}$"'::jsonb, 'hard', 'Subtract $\mathbf{a}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{a}+\mathbf{b}=(7, 1)$, $\mathbf{a}=(3, -2)$. $\mathbf{b}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Midpoint of $A$ to $B$ vector half of $\vec{AB}$?', 'multiple_choice', '["Yes $\\frac{1}{2}\\vec{AB}$","No","Full $\\vec{AB}$","Zero"]'::jsonb, '"Yes $\\frac{1}{2}\\vec{AB}$"'::jsonb, 'hard', 'Half displacement.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Midpoint of $A$ to $B$ vector half of $\vec{AB}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{a}-\mathbf{b}|$ when $\mathbf{a}=\mathbf{b}$?', 'multiple_choice', '["$0$","$1$","$2|\\mathbf{a}|$","Undefined"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Equal vectors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='addition_subtraction'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{a}-\mathbf{b}|$ when $\mathbf{a}=\mathbf{b}$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Column Vector Form', '{"blocks":[{"type":"heading","content":"Column Vectors"},{"type":"paragraph","content":"A 2D vector is written as a **column vector** $\\begin{pmatrix} x \\\\ y \\end{pmatrix}$ where $x$ is horizontal component and $y$ is vertical."},{"type":"math_block","latex":"\\mathbf{v} = \\begin{pmatrix} x \\\\ y \\end{pmatrix}","caption":"Component form"},{"type":"callout","variant":"key_point","content":"From $A(x_1,y_1)$ to $B(x_2,y_2)$: $\\vec{AB} = \\begin{pmatrix} x_2-x_1 \\\\ y_2-y_1 \\end{pmatrix}$."},{"type":"question","questionText":"$\\begin{pmatrix} 2 \\\\ -3 \\end{pmatrix}$: vertical component?","questionType":"multiple_choice","options":["$-3$","$2$","$5$","$-1$"],"correctAnswer":"$-3$","explanation":"Bottom entry."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'column_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Column Vector Form');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scalar Multiplication', '{"blocks":[{"type":"heading","content":"Scaling Vectors"},{"type":"math_block","latex":"k\\begin{pmatrix} x \\\\ y \\end{pmatrix} = \\begin{pmatrix} kx \\\\ ky \\end{pmatrix}"},{"type":"example","title":"$3\\begin{pmatrix} 2 \\\\ -1 \\end{pmatrix}$.","steps":["$\\begin{pmatrix} 6 \\\\ -3 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 6 \\\\ -3 \\end{pmatrix}$"},{"type":"callout","variant":"warning","content":"Negative scalar reverses direction."},{"type":"question","questionText":"$-2\\begin{pmatrix} 1 \\\\ 4 \\end{pmatrix}$?","questionType":"multiple_choice","options":["$\\begin{pmatrix} -2 \\\\ -8 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 8 \\end{pmatrix}$","$\\begin{pmatrix} -1 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 0 \\\\ -8 \\end{pmatrix}$"],"correctAnswer":"$\\begin{pmatrix} -2 \\\\ -8 \\end{pmatrix}$","explanation":"Multiply each."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'column_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scalar Multiplication');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Column Vectors — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Column Vectors"},{"type":"example","title":"$P(2,1)$, $Q(8,5)$. Find $\\vec{PQ}$ and $|\\vec{PQ}|$.","steps":["$\\vec{PQ}=\\begin{pmatrix}6\\\\4\\end{pmatrix}$.","$|\\vec{PQ}|=\\sqrt{36+16}=\\sqrt{52}=2\\sqrt{13}$."],"answer":"$\\begin{pmatrix}6\\\\4\\end{pmatrix}$, magnitude $2\\sqrt{13}$"},{"type":"callout","variant":"warning","content":"Order matters: $\\vec{AB} \\neq \\vec{BA}$ in general."},{"type":"question","questionText":"$\\vec{AB}+\\vec{BA}$ equals?","questionType":"multiple_choice","options":["$\\mathbf{0}$","$2\\vec{AB}$","$\\vec{BB}$","$\\vec{AA}$ nonzero"],"correctAnswer":"$\\mathbf{0}$","explanation":"Opposite vectors."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i' AND st.code = 'column_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Column Vectors — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Column vector $(x, y)$: $x$ is?', 'multiple_choice', '["Horizontal component","Vertical","Magnitude","Angle"]'::jsonb, '"Horizontal component"'::jsonb, 'easy', 'Top entry.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Column vector $(x, y)$: $x$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(0,0)$ to $B(3,2)$: $\vec{AB}$?', 'multiple_choice', '["$\\begin{pmatrix} 3 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 1 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 \\\\ 2 \\end{pmatrix}$"'::jsonb, 'easy', 'Subtract coords.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(0,0)$ to $B(3,2)$: $\vec{AB}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2(1, 3)$?', 'multiple_choice', '["$\\begin{pmatrix} 2 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ 5 \\end{pmatrix}$","$\\begin{pmatrix} 1 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 2 \\\\ 6 \\end{pmatrix}$"'::jsonb, 'easy', 'Scalar mult.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2(1, 3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\vec{BA}$ from $\vec{AB}=(2, 5)$?', 'multiple_choice', '["$\\begin{pmatrix} -2 \\\\ -5 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 5 \\end{pmatrix}$","$\\begin{pmatrix} -5 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -2 \\\\ -5 \\end{pmatrix}$"'::jsonb, 'easy', 'Reverse.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\vec{BA}$ from $\vec{AB}=(2, 5)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Zero column vector?', 'multiple_choice', '["$\\begin{pmatrix} 0 \\\\ 0 \\end{pmatrix}$","$\\begin{pmatrix} 1 \\\\ 1 \\end{pmatrix}$","$0$ scalar","No vector"]'::jsonb, '"$\\begin{pmatrix} 0 \\\\ 0 \\end{pmatrix}$"'::jsonb, 'easy', 'Both zero.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Zero column vector?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(4, 0)$ points?', 'multiple_choice', '["Along positive $x$","Along $y$","Diagonal","Origin only"]'::jsonb, '"Along positive $x$"'::jsonb, 'easy', 'No vertical.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(4, 0)$ points?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Scalar $-1$ times vector?', 'multiple_choice', '["Reverses direction","Zero vector","Doubles magnitude","Unchanged"]'::jsonb, '"Reverses direction"'::jsonb, 'easy', 'Opposite.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Scalar $-1$ times vector?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$M(3,4)$ translated by $(-2, 5)$?', 'multiple_choice', '["$(1,9)$","$(5,-1)$","$(1,-1)$","$(-2,20)$"]'::jsonb, '"$(1,9)$"'::jsonb, 'medium', 'Add to coords.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$M(3,4)$ translated by $(-2, 5)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|(-8, 6)|$?', 'multiple_choice', '["$10$","$14$","$2$","$48$"]'::jsonb, '"$10$"'::jsonb, 'medium', 'Magnitude.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|(-8, 6)|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$k(3, -2)=(9, -6)$. $k$?', 'multiple_choice', '["$3$","$-3$","$6$","$\\frac{1}{3}$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Scale factor.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$k(3, -2)=(9, -6)$. $k$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P(1,2)$, $Q(4,6)$, $R(7,10)$. $\vec{PQ}$ and $\vec{QR}$ relation?', 'multiple_choice', '["Both $\\begin{pmatrix}3\\\\4\\end{pmatrix}$ parallel","Perpendicular","Zero","Unrelated"]'::jsonb, '"Both $\\begin{pmatrix}3\\\\4\\end{pmatrix}$ parallel"'::jsonb, 'medium', 'Same vector.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P(1,2)$, $Q(4,6)$, $R(7,10)$. $\vec{PQ}$ and $\vec{QR}$ relation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{1}{2}(8, -4)$?', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 8 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 16 \\\\ -8 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ -2 \\end{pmatrix}$"'::jsonb, 'medium', 'Halve.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{1}{2}(8, -4)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Position vector of $(5,-2)$ from origin?', 'multiple_choice', '["$\\begin{pmatrix} 5 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} -2 \\\\ 5 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 2 \\end{pmatrix}$","$7$"]'::jsonb, '"$\\begin{pmatrix} 5 \\\\ -2 \\end{pmatrix}$"'::jsonb, 'medium', 'Direct coords.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Position vector of $(5,-2)$ from origin?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\vec{AB}=\mathbf{v}$ implies $\vec{BA}$?', 'multiple_choice', '["$-\\mathbf{v}$","$\\mathbf{v}$","$2\\mathbf{v}$","$|\\mathbf{v}|$"]'::jsonb, '"$-\\mathbf{v}$"'::jsonb, 'medium', 'Opposite direction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\vec{AB}=\mathbf{v}$ implies $\vec{BA}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(2,3)$, $B(10,11)$. $|\vec{AB}|$?', 'multiple_choice', '["$8\\sqrt{2}$","$16$","$8$","$\\sqrt{8}$"]'::jsonb, '"$8\\sqrt{2}$"'::jsonb, 'hard', '$(8, 8)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(2,3)$, $B(10,11)$. $|\vec{AB}|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{a}=(1, 2)$, $\mathbf{b}=(3, -1)$. $2\mathbf{a}-\mathbf{b}$?', 'multiple_choice', '["$\\begin{pmatrix} -1 \\\\ 5 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ -1 \\end{pmatrix}$","$\\begin{pmatrix} -1 \\\\ 3 \\end{pmatrix}$","$\\begin{pmatrix} 1 \\\\ 5 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -1 \\\\ 5 \\end{pmatrix}$"'::jsonb, 'hard', 'Compute.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{a}=(1, 2)$, $\mathbf{b}=(3, -1)$. $2\mathbf{a}-\mathbf{b}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Points collinear if $\vec{AB}$ is multiple of $\vec{AC}$?', 'multiple_choice', '["Yes","No never","Only if origin","Only unit vectors"]'::jsonb, '"Yes"'::jsonb, 'hard', 'Parallel test.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Points collinear if $\vec{AB}$ is multiple of $\vec{AC}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\vec{OP}=(4, 3)$, $\vec{OQ}=(1, 7)$. $\vec{PQ}$?', 'multiple_choice', '["$\\begin{pmatrix} -3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 10 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ -4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -3 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'hard', '$Q-P$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\vec{OP}=(4, 3)$, $\vec{OQ}=(1, 7)$. $\vec{PQ}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{v}|=3$, find $| -4\mathbf{v} |$.', 'multiple_choice', '["$12$","$7$","$-12$","$3$"]'::jsonb, '"$12$"'::jsonb, 'hard', 'Scale magnitude.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{v}|=3$, find $| -4\mathbf{v} |$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram $OABC$, $\vec{OA}=\mathbf{a}$, $\vec{OC}=\mathbf{c}$. $\vec{OB}$?', 'multiple_choice', '["$\\mathbf{a}+\\mathbf{c}$","$\\mathbf{a}-\\mathbf{c}$","$\\mathbf{c}-\\mathbf{a}$","$2\\mathbf{a}$"]'::jsonb, '"$\\mathbf{a}+\\mathbf{c}$"'::jsonb, 'hard', 'Parallelogram rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram $OABC$, $\vec{OA}=\mathbf{a}$, $\vec{OC}=\mathbf{c}$. $\vec{OB}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(2, y)$ parallel to $(6, 15)$. $y$?', 'multiple_choice', '["$5$","$3$","$10$","$7.5$"]'::jsonb, '"$5$"'::jsonb, 'hard', 'Triple components.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='column_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(2, y)$ parallel to $(6, 15)$. $y$?');