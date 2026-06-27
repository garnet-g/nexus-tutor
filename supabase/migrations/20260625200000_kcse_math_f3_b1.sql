-- KCSE Form 3 Mathematics — Wave 3 Batch 1
-- Topics: quadratic_equations_ii, approximations_errors, trigonometry_ii, surds, further_logarithms
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md

-- ========== QUADRATIC EQUATIONS II ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Why Complete the Square?', '{"blocks":[{"type":"heading","content":"Completing the Square"},{"type":"paragraph","content":"To solve $ax^2 + bx + c = 0$ when factorisation is awkward, rewrite the quadratic as a **perfect square** plus a constant."},{"type":"math_block","latex":"x^2 + bx = \\left(x + \\frac{b}{2}\\right)^2 - \\left(\\frac{b}{2}\\right)^2","caption":"Completing the square pattern"},{"type":"callout","variant":"key_point","content":"Add and subtract $\\left(\\frac{b}{2}\\right)^2$ so the left side becomes a square."},{"type":"example","title":"Write $x^2 + 6x + 5 = 0$ in completed-square form.","steps":["$x^2 + 6x = -5$.","Half of $6$ is $3$; add $9$: $(x+3)^2 - 9 = -5$.","$(x+3)^2 = 4$."],"answer":"$(x+3)^2 = 4$"},{"type":"question","questionText":"Half of coefficient $8$ in $x^2 + 8x$ is?","questionType":"multiple_choice","options":["$4$","$8$","$16$","$2$"],"correctAnswer":"$4$","explanation":"Divide $b$ by $2$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'completing_square'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Why Complete the Square?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving by Completing the Square', '{"blocks":[{"type":"heading","content":"Step-by-Step Method"},{"type":"example","title":"Solve $x^2 - 4x - 5 = 0$ by completing the square.","steps":["$x^2 - 4x = 5$.","$(x-2)^2 - 4 = 5$.","$(x-2)^2 = 9$.","$x - 2 = \\pm 3$.","$x = 5$ or $x = -1$."],"answer":"$x = 5$ or $x = -1$"},{"type":"callout","variant":"warning","content":"When $a \\neq 1$, divide the whole equation by $a$ first before completing the square."},{"type":"example","title":"Solve $2x^2 + 8x + 6 = 0$.","steps":["Divide by $2$: $x^2 + 4x + 3 = 0$.","$(x+2)^2 - 4 = -3$… adjust: $(x+2)^2 = 1$.","$x = -1$ or $x = -3$."],"answer":"$x = -1$ or $x = -3$"},{"type":"question","questionText":"After $(x-5)^2 = 16$, what is $x$?","questionType":"multiple_choice","options":["$x = 9$ or $x = 1$","$x = 4$ only","$x = -4$ only","$x = 21$"],"correctAnswer":"$x = 9$ or $x = 1$","explanation":"Square root both sides."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'completing_square'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving by Completing the Square');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Completing the Square — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Completing the Square"},{"type":"example","title":"Find minimum value of $y = x^2 - 6x + 10$.","steps":["$(x-3)^2 - 9 + 10 = (x-3)^2 + 1$.","Minimum when square is zero: $y_{\\min} = 1$."],"answer":"Minimum value $1$ at $x = 3$"},{"type":"callout","variant":"warning","content":"Completing the square reveals the **turning point** $(h, k)$ of a parabola."},{"type":"question","questionText":"Vertex form $(x-2)^2 + 3$ has turning point?","questionType":"multiple_choice","options":["$(2, 3)$","$(-2, 3)$","$(2, -3)$","$(3, 2)$"],"correctAnswer":"$(2, 3)$","explanation":"Read $h$ and $k$ from form."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'completing_square'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Completing the Square — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'To complete $x^2 + 10x$, add?', 'multiple_choice', '["$25$","$5$","$100$","$10$"]'::jsonb, '"$25$"'::jsonb, 'easy', '$(10/2)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='To complete $x^2 + 10x$, add?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x+4)^2$ expands to?', 'multiple_choice', '["$x^2 + 8x + 16$","$x^2 + 4x + 16$","$x^2 + 16$","$x^2 + 8x$"]'::jsonb, '"$x^2 + 8x + 16$"'::jsonb, 'easy', 'Square binomial.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x+4)^2$ expands to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Half of $-6$ is?', 'multiple_choice', '["$-3$","$3$","$-6$","$36$"]'::jsonb, '"$-3$"'::jsonb, 'easy', '$b/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Half of $-6$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + 2x + 1$ is a perfect square?', 'multiple_choice', '["Yes","No","Only if $x>0$","Never"]'::jsonb, '"Yes"'::jsonb, 'easy', '$(x+1)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + 2x + 1$ is a perfect square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Completing square helps find?', 'multiple_choice', '["Vertex of parabola","Area only","Perimeter","Gradient"]'::jsonb, '"Vertex of parabola"'::jsonb, 'easy', 'Turning point.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Completing square helps find?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x-1)^2 = 0$ gives?', 'multiple_choice', '["$x = 1$","$x = -1$","$x = 0$","$x = 2$"]'::jsonb, '"$x = 1$"'::jsonb, 'easy', 'Single root.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x-1)^2 = 0$ gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Add to $x^2 + 12x$ to complete square?', 'multiple_choice', '["$36$","$6$","$144$","$12$"]'::jsonb, '"$36$"'::jsonb, 'easy', '$(6)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Add to $x^2 + 12x$ to complete square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $(x+2)^2 = 25$.', 'multiple_choice', '["$x = 3$ or $x = -7$","$x = 5$ only","$x = -5$ only","$x = 23$"]'::jsonb, '"$x = 3$ or $x = -7$"'::jsonb, 'medium', '$x+2 = \pm 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $(x+2)^2 = 25$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 - 8x + 12 = 0$. Completed form constant?', 'multiple_choice', '["$4$ on RHS after shift","$16$","$-4$","$64$"]'::jsonb, '"$4$ on RHS after shift"'::jsonb, 'medium', '$(x-4)^2 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 - 8x + 12 = 0$. Completed form constant?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Minimum of $(x-3)^2 + 5$?', 'multiple_choice', '["$5$","$3$","$0$","$-5$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Square $\geq 0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Minimum of $(x-3)^2 + 5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Divide $3x^2 + 12x = 0$ by $3$ first gives?', 'multiple_choice', '["$x^2 + 4x = 0$","$x^2 + 12x = 0$","$x^2 + 4 = 0$","$3x^2 + 4x = 0$"]'::jsonb, '"$x^2 + 4x = 0$"'::jsonb, 'medium', 'Coefficient of $x^2$ is $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Divide $3x^2 + 12x = 0$ by $3$ first gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x+5)^2 = 9$. Smaller root?', 'multiple_choice', '["$-8$","$-2$","$2$","$8$"]'::jsonb, '"$-8$"'::jsonb, 'medium', '$x+5 = -3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x+5)^2 = 9$. Smaller root?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Turning point of $x^2 + 4x + 7$?', 'multiple_choice', '["$(-2, 3)$","$(2, 3)$","$(-2, -3)$","$(2, 7)$"]'::jsonb, '"$(-2, 3)$"'::jsonb, 'medium', 'Complete square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Turning point of $x^2 + 4x + 7$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + bx + c$; square term uses?', 'multiple_choice', '["$\\left(\\frac{b}{2}\\right)^2$","$b^2$","$2b$","$\\frac{b}{4}$"]'::jsonb, '"$\\left(\\frac{b}{2}\\right)^2$"'::jsonb, 'medium', 'Standard pattern.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + bx + c$; square term uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2 + 6x - 7 = 0$ by completing square.', 'multiple_choice', '["$x = 1$ or $x = -7$","$x = 7$ or $x = -1$","$x = 3$ only","$x = -3$ only"]'::jsonb, '"$x = 1$ or $x = -7$"'::jsonb, 'hard', '$(x+3)^2 = 16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2 + 6x - 7 = 0$ by completing square.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Minimum of $2x^2 - 8x + 11$?', 'multiple_choice', '["$3$ at $x = 2$","$11$ at $x = 0$","$-5$","$7$"]'::jsonb, '"$3$ at $x = 2$"'::jsonb, 'hard', 'Factor $2$ first.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Minimum of $2x^2 - 8x + 11$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x-4)^2 = -1$ has how many real roots?', 'multiple_choice', '["$0$","$1$","$2$","Infinite"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Square cannot be negative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x-4)^2 = -1$ has how many real roots?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2 - 10x + 21 = 0$ via completing square.', 'multiple_choice', '["$x = 7$ or $x = 3$","$x = 5$ only","$x = -7$ or $3$","$x = 10$"]'::jsonb, '"$x = 7$ or $x = 3$"'::jsonb, 'hard', '$(x-5)^2 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2 - 10x + 21 = 0$ via completing square.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + 2x + k$ is perfect square when $k$?', 'multiple_choice', '["$1$","$2$","$4$","$0$"]'::jsonb, '"$1$"'::jsonb, 'hard', '$(x+1)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + 2x + k$ is perfect square when $k$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area model: square side $(x+3)$, area?', 'multiple_choice', '["$(x+3)^2$","$x^2 + 3$","$x^2 + 9$","$2x + 6$"]'::jsonb, '"$(x+3)^2$"'::jsonb, 'hard', 'Side squared.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area model: square side $(x+3)$, area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $4x^2 - 8x - 12 = 0$ (complete square after dividing).', 'multiple_choice', '["$x = 3$ or $x = -1$","$x = 2$ or $-3$","$x = 1$ only","$x = -3$ only"]'::jsonb, '"$x = 3$ or $x = -1$"'::jsonb, 'hard', 'Divide by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='completing_square'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $4x^2 - 8x - 12 = 0$ (complete square after dividing).');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'The Quadratic Formula', '{"blocks":[{"type":"heading","content":"Quadratic Formula"},{"type":"paragraph","content":"For $ax^2 + bx + c = 0$ with $a \\neq 0$, the roots are given by the quadratic formula."},{"type":"math_block","latex":"x = \\frac{-b \\pm \\sqrt{b^2 - 4ac}}{2a}","caption":"Quadratic formula"},{"type":"callout","variant":"key_point","content":"$\\Delta = b^2 - 4ac$ is the **discriminant**. $\\Delta > 0$: two roots; $\\Delta = 0$: one repeated; $\\Delta < 0$: no real roots."},{"type":"example","title":"Solve $x^2 - 5x + 6 = 0$ using the formula.","steps":["$a=1, b=-5, c=6$.","$\\Delta = 25 - 24 = 1$.","$x = \\frac{5 \\pm 1}{2}$.","$x = 3$ or $x = 2$."],"answer":"$x = 3$ or $x = 2$"},{"type":"question","questionText":"Discriminant symbol?","questionType":"multiple_choice","options":["$\\Delta$","$\\Sigma$","$\\pi$","$\\theta$"],"correctAnswer":"$\\Delta$","explanation":"Greek delta."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'quadratic_formula'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'The Quadratic Formula');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using the Formula — Worked Examples', '{"blocks":[{"type":"heading","content":"Careful Substitution"},{"type":"example","title":"Solve $2x^2 + 3x - 2 = 0$.","steps":["$a=2, b=3, c=-2$.","$\\Delta = 9 + 16 = 25$.","$x = \\frac{-3 \\pm 5}{4}$.","$x = \\frac{1}{2}$ or $x = -2$."],"answer":"$x = \\frac{1}{2}$ or $x = -2$"},{"type":"callout","variant":"warning","content":"Include the **sign** of $b$ when substituting. For $-5x$, use $b = -5$."},{"type":"example","title":"Solve $x^2 + 4x + 5 = 0$.","steps":["$\\Delta = 16 - 20 = -4 < 0$.","No real roots."],"answer":"No real roots"},{"type":"question","questionText":"$\\Delta = 0$ means?","questionType":"multiple_choice","options":["One repeated root","Two distinct roots","No roots","Three roots"],"correctAnswer":"One repeated root","explanation":"Tangent to $x$-axis."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'quadratic_formula'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using the Formula — Worked Examples');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Quadratic Formula — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Quadratic Formula"},{"type":"example","title":"A rectangle: length $2$ m more than width $w$. Area $24$ m$^2$. Form equation and solve.","steps":["$w(w+2) = 24$.","$w^2 + 2w - 24 = 0$.","Formula: $w = 4$ m (reject negative)."],"answer":"Width $4$ m"},{"type":"callout","variant":"warning","content":"In word problems, reject roots that give negative lengths."},{"type":"question","questionText":"$x^2 - 6x + 9 = 0$. Number of distinct real roots?","questionType":"multiple_choice","options":["$1$","$2$","$0$","$3$"],"correctAnswer":"$1$","explanation":"$\\Delta = 0$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'quadratic_formula'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Quadratic Formula — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Formula uses which coefficients?', 'multiple_choice', '["$a, b, c$ from $ax^2+bx+c$","Only $c$","Only $a$","$x$ only"]'::jsonb, '"$a, b, c$ from $ax^2+bx+c$"'::jsonb, 'easy', 'Standard form.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Formula uses which coefficients?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\Delta = b^2 - 4ac$ is called?', 'multiple_choice', '["Discriminant","Determinant","Derivative","Diagonal"]'::jsonb, '"Discriminant"'::jsonb, 'easy', 'Name.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\Delta = b^2 - 4ac$ is called?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\Delta > 0$ gives?', 'multiple_choice', '["Two real roots","No real roots","One root only","Complex only always"]'::jsonb, '"Two real roots"'::jsonb, 'easy', 'Two intersections.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\Delta > 0$ gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'For $x^2 - 9 = 0$, $b$ equals?', 'multiple_choice', '["$0$","$9$","$-9$","$1$"]'::jsonb, '"$0$"'::jsonb, 'easy', 'No $x$ term.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='For $x^2 - 9 = 0$, $b$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\pm$ in formula means?', 'multiple_choice', '["Two values","Multiply","Divide","Square"]'::jsonb, '"Two values"'::jsonb, 'easy', 'Plus and minus.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\pm$ in formula means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Denominator in formula is?', 'multiple_choice', '["$2a$","$a$","$2b$","$2c$"]'::jsonb, '"$2a$"'::jsonb, 'easy', 'Standard.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Denominator in formula is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + 1 = 0$ has $\Delta$?', 'multiple_choice', '["$-4$","$4$","$0$","$1$"]'::jsonb, '"$-4$"'::jsonb, 'easy', '$a=1,b=0,c=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + 1 = 0$ has $\Delta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2 - 4x + 3 = 0$ by formula.', 'multiple_choice', '["$x = 3$ or $x = 1$","$x = -3$ or $-1$","$x = 4$ only","$x = 0$"]'::jsonb, '"$x = 3$ or $x = 1$"'::jsonb, 'medium', '$\Delta = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2 - 4x + 3 = 0$ by formula.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2x^2 - 7x + 3 = 0$. Smaller root?', 'multiple_choice', '["$\\frac{1}{2}$","$3$","$-3$","$7$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', 'Use formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2x^2 - 7x + 3 = 0$. Smaller root?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + 2x + 1 = 0$. Root?', 'multiple_choice', '["$-1$ (repeated)","$1$","$0$","$2$"]'::jsonb, '"$-1$ (repeated)"'::jsonb, 'medium', 'Perfect square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + 2x + 1 = 0$. Root?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3x^2 + x - 2 = 0$. Positive root?', 'multiple_choice', '["$\\frac{2}{3}$","$-1$","$1$","$2$"]'::jsonb, '"$\\frac{2}{3}$"'::jsonb, 'medium', 'Formula steps.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3x^2 + x - 2 = 0$. Positive root?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $\Delta = 49$, roots are?', 'multiple_choice', '["Real and distinct","Not real","Equal only","Always zero"]'::jsonb, '"Real and distinct"'::jsonb, 'medium', 'Positive discriminant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $\Delta = 49$, roots are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 - 2x - 8 = 0$. Product of roots?', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'medium', '$c/a$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 - 2x - 8 = 0$. Product of roots?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sum of roots of $x^2 - 7x + 10 = 0$?', 'multiple_choice', '["$7$","$10$","$-7$","$-10$"]'::jsonb, '"$7$"'::jsonb, 'medium', '$-b/a$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sum of roots of $x^2 - 7x + 10 = 0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5x^2 - 20x + 15 = 0$.', 'multiple_choice', '["$x = 3$ or $x = 1$","$x = 5$ or $3$","$x = -3$ or $-1$","$x = 0$"]'::jsonb, '"$x = 3$ or $x = 1$"'::jsonb, 'hard', 'Divide by $5$ first.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5x^2 - 20x + 15 = 0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$kx^2 + 4x + 1 = 0$ has equal roots when $k$?', 'multiple_choice', '["$4$","$1$","$2$","$0$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$\Delta = 0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$kx^2 + 4x + 1 = 0$ has equal roots when $k$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Word: consecutive integers product $72$. Larger integer?', 'multiple_choice', '["$9$","$8$","$6$","$12$"]'::jsonb, '"$9$"'::jsonb, 'hard', '$n(n+1)=72$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Word: consecutive integers product $72$. Larger integer?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x^2 + px + 9 = 0$ has no real roots when $p$?', 'multiple_choice', '["$|p| < 6$","$|p| > 6$","$p = 6$ only","$p = 0$ only"]'::jsonb, '"$|p| < 6$"'::jsonb, 'hard', '$\Delta < 0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x^2 + px + 9 = 0$ has no real roots when $p$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{1}{x} + x = 3$ (multiply through).', 'multiple_choice', '["$x = \\frac{3 \\pm \\sqrt{5}}{2}$","$x = 3$ only","$x = 1$ only","No solution"]'::jsonb, '"$x = \\frac{3 \\pm \\sqrt{5}}{2}$"'::jsonb, 'hard', 'Quadratic in $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{1}{x} + x = 3$ (multiply through).');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2x^2 + kx + 8 = 0$; equal roots. $k$?', 'multiple_choice', '["$\\pm 8$","$\\pm 4$","$8$ only","$4$ only"]'::jsonb, '"$\\pm 8$"'::jsonb, 'hard', '$k^2 = 64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2x^2 + kx + 8 = 0$; equal roots. $k$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reject $x = -5$ in width problem because?', 'multiple_choice', '["Width cannot be negative","Formula wrong","Always reject negative","$\\Delta$ negative"]'::jsonb, '"Width cannot be negative"'::jsonb, 'hard', 'Context.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadratic_formula'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reject $x = -5$ in width problem because?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Shape of Quadratic Graphs', '{"blocks":[{"type":"heading","content":"Parabolas"},{"type":"paragraph","content":"The graph of $y = ax^2 + bx + c$ is a **parabola**. If $a > 0$ it opens upward (minimum); if $a < 0$ it opens downward (maximum)."},{"type":"callout","variant":"key_point","content":"$y$-intercept is $(0, c)$. Axis of symmetry: $x = -\\frac{b}{2a}$."},{"type":"example","title":"Sketch features of $y = x^2 - 4x + 3$.","steps":["$a=1>0$: U-shape.","$y$-intercept $(0,3)$.","Axis $x = 2$.","Turning point $(2, -1)$."],"answer":"U-parabola, vertex $(2,-1)$"},{"type":"question","questionText":"$a < 0$ parabola opens?","questionType":"multiple_choice","options":["Downward","Upward","Left","Right"],"correctAnswer":"Downward","explanation":"Negative $a$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'graphs_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Shape of Quadratic Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Roots and the $x$-Axis', '{"blocks":[{"type":"heading","content":"Intercepts"},{"type":"paragraph","content":"**$x$-intercepts** occur where $y = 0$ — solve the quadratic equation."},{"type":"example","title":"Find intercepts of $y = x^2 - x - 6$.","steps":["$y$-intercept: $(0, -6)$.","$x^2 - x - 6 = 0$.","$(x-3)(x+2)=0$.","Crosses at $(3,0)$ and $(-2,0)$."],"answer":"Intercepts $(-2,0)$ and $(3,0)$"},{"type":"callout","variant":"warning","content":"If $\\Delta < 0$, the parabola does not cross the $x$-axis."},{"type":"question","questionText":"No $x$-intercepts means?","questionType":"multiple_choice","options":["$\\Delta < 0$ (real)","$\\Delta > 0$","$a = 0$","$c = 0$ always"],"correctAnswer":"$\\Delta < 0$ (real)","explanation":"No real zeros."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'graphs_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Roots and the $x$-Axis');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Quadratic Graphs — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Graph Reading"},{"type":"example","title":"Graph touches $x$-axis once at $x = 4$. What is $\\Delta$?","steps":["$\\Delta = 0$","$\\Delta > 0$","$\\Delta < 0$","Cannot tell"],"answer":"$\\Delta = 0$"},{"type":"callout","variant":"warning","content":"Touching once = repeated root = discriminant zero."},{"type":"question","questionText":"Line of symmetry of $y = 2x^2 - 8x + 1$?","questionType":"multiple_choice","options":["$x = 2$","$x = 4$","$x = -2$","$x = 8$"],"correctAnswer":"$x = 2$","explanation":"$-b/(2a)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii' AND st.code = 'graphs_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Quadratic Graphs — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Graph of $y = x^2$ shape?', 'multiple_choice', '["Parabola","Straight line","Circle","Hyperbola"]'::jsonb, '"Parabola"'::jsonb, 'easy', 'Quadratic.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Graph of $y = x^2$ shape?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y$-intercept of $y = x^2 + 5$?', 'multiple_choice', '["$(0, 5)$","$(5, 0)$","$(0, 0)$","$(1, 5)$"]'::jsonb, '"$(0, 5)$"'::jsonb, 'easy', 'Set $x=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y$-intercept of $y = x^2 + 5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$a > 0$ means vertex is?', 'multiple_choice', '["Minimum","Maximum","Neither","Origin only"]'::jsonb, '"Minimum"'::jsonb, 'easy', 'U-shape.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$a > 0$ means vertex is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Axis of symmetry formula?', 'multiple_choice', '["$x = -b/(2a)$","$x = b/2$","$y = c$","$x = c$"]'::jsonb, '"$x = -b/(2a)$"'::jsonb, 'easy', 'Standard.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Axis of symmetry formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x$-intercepts found by?', 'multiple_choice', '["Setting $y = 0$","Setting $x = 0$","Differentiating","Adding roots"]'::jsonb, '"Setting $y = 0$"'::jsonb, 'easy', 'On $x$-axis.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x$-intercepts found by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = -x^2$ opens?', 'multiple_choice', '["Downward","Upward","Right","Left"]'::jsonb, '"Downward"'::jsonb, 'easy', '$a = -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = -x^2$ opens?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Turning point also called?', 'multiple_choice', '["Vertex","Intercept","Asymptote","Focus only"]'::jsonb, '"Vertex"'::jsonb, 'easy', 'Max or min point.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Turning point also called?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^2 - 4$. $x$-intercepts?', 'multiple_choice', '["$\\pm 2$","$\\pm 4$","$0$ only","None"]'::jsonb, '"$\\pm 2$"'::jsonb, 'medium', '$x^2 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^2 - 4$. $x$-intercepts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Symmetry axis of $y = x^2 + 2x$?', 'multiple_choice', '["$x = -1$","$x = 1$","$x = 2$","$x = 0$"]'::jsonb, '"$x = -1$"'::jsonb, 'medium', '$-2/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Symmetry axis of $y = x^2 + 2x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Minimum of $y = x^2 - 6x + 10$?', 'multiple_choice', '["$1$ at $x = 3$","$10$ at $x = 0$","$-6$","$3$"]'::jsonb, '"$1$ at $x = 3$"'::jsonb, 'medium', 'Complete square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Minimum of $y = x^2 - 6x + 10$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two $x$-intercepts implies?', 'multiple_choice', '["$\\Delta > 0$","$\\Delta = 0$","$\\Delta < 0$","$a = 0$"]'::jsonb, '"$\\Delta > 0$"'::jsonb, 'medium', 'Crosses twice.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two $x$-intercepts implies?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 2(x-1)^2 + 3$ vertex?', 'multiple_choice', '["$(1, 3)$","$(-1, 3)$","$(1, -3)$","$(3, 1)$"]'::jsonb, '"$(1, 3)$"'::jsonb, 'medium', 'Vertex form.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 2(x-1)^2 + 3$ vertex?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Range of $y = x^2 + 1$?', 'multiple_choice', '["$y \\geq 1$","$y \\leq 1$","All reals","$y > 0$ only"]'::jsonb, '"$y \\geq 1$"'::jsonb, 'medium', 'Minimum $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Range of $y = x^2 + 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Graph above $x$-axis everywhere: $\Delta$?', 'multiple_choice', '["$\\Delta < 0$ and $a > 0$","$\\Delta > 0$","$\\Delta = 0$","$a < 0$ always"]'::jsonb, '"$\\Delta < 0$ and $a > 0$"'::jsonb, 'medium', 'No real roots, U-shape.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Graph above $x$-axis everywhere: $\Delta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sketch $y = -2x^2 + 8x - 6$. Maximum $y$?', 'multiple_choice', '["$2$ at $x = 2$","$-6$","$8$","$6$"]'::jsonb, '"$2$ at $x = 2$"'::jsonb, 'hard', 'Downward parabola.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sketch $y = -2x^2 + 8x - 6$. Maximum $y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Root sum $2$, product $-3$. Equation?', 'multiple_choice', '["$x^2 - 2x - 3 = 0$","$x^2 + 2x - 3 = 0$","$x^2 - 2x + 3 = 0$","$2x^2 - 3 = 0$"]'::jsonb, '"$x^2 - 2x - 3 = 0$"'::jsonb, 'hard', 'Vieta.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Root sum $2$, product $-3$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = k + (x-h)^2$ shifts parabola?', 'multiple_choice', '["$h$ right, $k$ up","$h$ left only","Down only","No shift"]'::jsonb, '"$h$ right, $k$ up"'::jsonb, 'hard', 'Transformations.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = k + (x-h)^2$ shifts parabola?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line meets parabola once. $\Delta$ of system?', 'multiple_choice', '["$0$","Always positive","Always negative","$1$"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Tangent.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line meets parabola once. $\Delta$ of system?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^2 + bx + 1$ axis $x = 3$. Find $b$.', 'multiple_choice', '["$-6$","$6$","$-3$","$3$"]'::jsonb, '"$-6$"'::jsonb, 'hard', '$-b/2a = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^2 + bx + 1$ axis $x = 3$. Find $b$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Profit $P = -2n^2 + 40n - 150$. Max profit when $n$?', 'multiple_choice', '["$10$","$20$","$5$","$40$"]'::jsonb, '"$10$"'::jsonb, 'hard', 'Vertex at $n=10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Profit $P = -2n^2 + 40n - 150$. Max profit when $n$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which has no real $x$-intercepts?', 'multiple_choice', '["$y = x^2 + x + 1$","$y = x^2 - 1$","$y = x^2$","$y = x^2 - 4x$"]'::jsonb, '"$y = x^2 + x + 1$"'::jsonb, 'hard', '$\Delta = -3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphs_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_equations_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which has no real $x$-intercepts?');


-- ========== APPROXIMATIONS AND ERRORS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Significant Figures and Rounding', '{"blocks":[{"type":"heading","content":"Significant Figures"},{"type":"paragraph","content":"A **significant figure** is a reliable digit in a measurement. When rounding, keep the required number of significant figures and look at the next digit: $5$ or more rounds up."},{"type":"callout","variant":"key_point","content":"Zeros between non-zero digits **count** (e.g. $305$ has three s.f.). Leading zeros do **not** count."},{"type":"example","title":"Round $0.004567$ to $2$ significant figures.","steps":["First two s.f. digits: $4$ and $5$.","Next digit is $6$ (round up).","Answer: $0.0046$."],"answer":"$0.0046$"},{"type":"question","questionText":"Round $3.141$ to $2$ d.p.","questionType":"multiple_choice","options":["$3.14$","$3.15$","$3.1$","$3.2$"],"correctAnswer":"$3.14$","explanation":"Look at third decimal."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'rounding_estimation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Significant Figures and Rounding');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Estimation Strategies', '{"blocks":[{"type":"heading","content":"Quick Estimates"},{"type":"paragraph","content":"Before calculating exactly, **round** numbers to $1$ significant figure to estimate an answer and check if your final result is reasonable."},{"type":"example","title":"Estimate $\\frac{49 \\times 0.21}{1.9}$.","steps":["Round: $\\frac{50 \\times 0.2}{2} = \\frac{10}{2} = 5$."],"answer":"About $5$"},{"type":"callout","variant":"warning","content":"Estimation is not exact — it catches order-of-magnitude mistakes in KCSE."},{"type":"example","title":"Estimate $198 \\times 52$.","steps":["$200 \\times 50 = 10\\,000$."],"answer":"About $10\\,000$"},{"type":"question","questionText":"Best estimate of $47 + 52$?","questionType":"multiple_choice","options":["$100$","$90$","$110$","$50$"],"correctAnswer":"$100$","explanation":"Round to nearest ten."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'rounding_estimation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Estimation Strategies');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rounding — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Rounding & Estimation"},{"type":"example","title":"A pipe length is $12.74$ cm to the nearest $0.01$ cm. State lower and upper bounds.","steps":["$L = 12.74$, half-width $0.005$.","Lower $12.735$ cm, upper $12.745$ cm."],"answer":"$12.735 \\leq l < 12.745$"},{"type":"callout","variant":"warning","content":"Bounds come from half the unit of rounding."},{"type":"question","questionText":"$286$ rounded to nearest $10$ is?","questionType":"multiple_choice","options":["$290$","$280$","$300$","$286$"],"correctAnswer":"$290$","explanation":"Units digit $6$ rounds up."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'rounding_estimation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rounding — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $6.78$ to $1$ d.p.', 'multiple_choice', '["$6.8$","$6.7$","$7.0$","$6.78$"]'::jsonb, '"$6.8$"'::jsonb, 'easy', 'Second decimal is $8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $6.78$ to $1$ d.p.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$0.0502$ to $2$ s.f.?', 'multiple_choice', '["$0.050$","$0.05$","$0.0502$","$0.051$"]'::jsonb, '"$0.050$"'::jsonb, 'easy', 'Leading zeros not significant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$0.0502$ to $2$ s.f.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $1250$ to $2$ s.f.', 'multiple_choice', '["$1300$","$1200$","$1250$","$1000$"]'::jsonb, '"$1300$"'::jsonb, 'easy', 'Third digit rounds up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $1250$ to $2$ s.f.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $19 \times 31$.', 'multiple_choice', '["$600$","$500$","$700$","$900$"]'::jsonb, '"$600$"'::jsonb, 'easy', '$20 \times 30$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $19 \times 31$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$4.995$ to $2$ d.p.?', 'multiple_choice', '["$5.00$","$4.99$","$5.0$","$4.9$"]'::jsonb, '"$5.00$"'::jsonb, 'easy', 'Carry to units.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$4.995$ to $2$ d.p.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many s.f. in $0.04060$?', 'multiple_choice', '["$4$","$3$","$5$","$6$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Ignore leading zeros.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many s.f. in $0.04060$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $0.666$ to $1$ s.f.', 'multiple_choice', '["$0.7$","$0.6$","$1$","$0.67$"]'::jsonb, '"$0.7$"'::jsonb, 'easy', 'First s.f. is $6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $0.666$ to $1$ s.f.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\frac{98}{4.1}$.', 'multiple_choice', '["$25$","$20$","$30$","$10$"]'::jsonb, '"$25$"'::jsonb, 'medium', '$100/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\frac{98}{4.1}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$12.349$ to $2$ d.p.?', 'multiple_choice', '["$12.35$","$12.34$","$12.3$","$12.4$"]'::jsonb, '"$12.35$"'::jsonb, 'medium', 'Third decimal $9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$12.349$ to $2$ d.p.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Lower bound of $7.5$ cm to nearest $0.1$ cm?', 'multiple_choice', '["$7.45$ cm","$7.4$ cm","$7.55$ cm","$7.5$ cm"]'::jsonb, '"$7.45$ cm"'::jsonb, 'medium', 'Half of $0.1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Lower bound of $7.5$ cm to nearest $0.1$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Upper bound of $7.5$ cm to nearest $0.1$ cm?', 'multiple_choice', '["$7.55$ cm","$7.6$ cm","$7.45$ cm","$8.0$ cm"]'::jsonb, '"$7.55$ cm"'::jsonb, 'medium', 'Exclusive upper.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Upper bound of $7.5$ cm to nearest $0.1$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\sqrt{50}$.', 'multiple_choice', '["$7$","$5$","$10$","$25$"]'::jsonb, '"$7$"'::jsonb, 'medium', 'Between $7$ and $8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\sqrt{50}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$0.00499$ to $2$ s.f.?', 'multiple_choice', '["$0.0050$","$0.0049$","$0.005$","$0.00$"]'::jsonb, '"$0.0050$"'::jsonb, 'medium', 'Round third digit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$0.00499$ to $2$ s.f.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $456789$ to $3$ s.f.', 'multiple_choice', '["$457000$","$456000$","$457$","$460000$"]'::jsonb, '"$457000$"'::jsonb, 'medium', 'Standard form style.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $456789$ to $3$ s.f.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $(1.9)^3$.', 'multiple_choice', '["$8$","$6$","$10$","$27$"]'::jsonb, '"$8$"'::jsonb, 'medium', '$2^3 = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $(1.9)^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mass $2.5$ kg to nearest $0.1$ kg: max absolute error?', 'multiple_choice', '["$0.05$ kg","$0.1$ kg","$0.025$ kg","$0.5$ kg"]'::jsonb, '"$0.05$ kg"'::jsonb, 'hard', 'Half the unit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mass $2.5$ kg to nearest $0.1$ kg: max absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$1.2345$ to $3$ s.f. then $2$ d.p.?', 'multiple_choice', '["$1.23$","$1.24$","$1.2$","$1.3$"]'::jsonb, '"$1.23$"'::jsonb, 'hard', 'First to $1.23$, already $2$ d.p.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$1.2345$ to $3$ s.f. then $2$ d.p.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\frac{0.49 \times 201}{9.8}$.', 'multiple_choice', '["$10$","$1$","$100$","$20$"]'::jsonb, '"$10$"'::jsonb, 'hard', '$0.5 \times 200 / 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\frac{0.49 \times 201}{9.8}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $999$ to $2$ s.f.', 'multiple_choice', '["$1000$","$990$","$900$","$100$"]'::jsonb, '"$1000$"'::jsonb, 'hard', 'Needs $4$ digits.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $999$ to $2$ s.f.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Width $w = 3.2$ m (1 d.p.). Range of $w$?', 'multiple_choice', '["$3.15 \\leq w < 3.25$","$3.1 \\leq w < 3.3$","$3.0 \\leq w < 3.4$","$3.2$ only"]'::jsonb, '"$3.15 \\leq w < 3.25$"'::jsonb, 'hard', 'Half of $0.1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Width $w = 3.2$ m (1 d.p.). Range of $w$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\frac{48.7 + 51.2}{0.98}$.', 'multiple_choice', '["$100$","$50$","$200$","$10$"]'::jsonb, '"$100$"'::jsonb, 'hard', 'Numerator $\approx 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rounding_estimation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\frac{48.7 + 51.2}{0.98}$.');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Absolute Error', '{"blocks":[{"type":"heading","content":"Absolute Error"},{"type":"paragraph","content":"If the true value is $T$ and measured value is $M$, the **absolute error** is $|M - T|$."},{"type":"math_block","latex":"\\text{Absolute error} = |M - T|","caption":"Absolute error formula"},{"type":"callout","variant":"key_point","content":"Absolute error has the **same units** as the measurement."},{"type":"example","title":"True length $50$ cm; measured $49.2$ cm. Find absolute error.","steps":["$|49.2 - 50| = 0.8$ cm."],"answer":"$0.8$ cm"},{"type":"question","questionText":"Measured $12$ g, true $11.5$ g. Absolute error?","questionType":"multiple_choice","options":["$0.5$ g","$0.5$","$12.5$ g","$11.5$ g"],"correctAnswer":"$0.5$ g","explanation":"Difference in grams."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'absolute_relative_error'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Absolute Error');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Relative and Percentage Error', '{"blocks":[{"type":"heading","content":"Relative Error"},{"type":"math_block","latex":"\\text{Relative error} = \\frac{|M - T|}{|T|}","caption":"Relative error (decimal)"},{"type":"paragraph","content":"**Percentage error** $= $ relative error $\\times 100\\%$."},{"type":"example","title":"True $200$ mL, measured $194$ mL.","steps":["Absolute $6$ mL.","Relative $\\frac{6}{200} = 0.03$.","Percentage $3\\%$."],"answer":"$3\\%$"},{"type":"callout","variant":"warning","content":"Use the **true** value in the denominator for standard KCSE relative error."},{"type":"question","questionText":"Relative error $0.02$ equals?","questionType":"multiple_choice","options":["$2\\%$","$20\\%$","$0.2\\%$","$200\\%$"],"correctAnswer":"$2\\%$","explanation":"Multiply by $100$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'absolute_relative_error'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Relative and Percentage Error');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Errors — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Absolute & Relative Error"},{"type":"example","title":"A student times $10$ swings as $20.4$ s; true value $20.0$ s.","steps":["Absolute error $0.4$ s.","Relative $\\frac{0.4}{20} = 2\\%$."],"answer":"$2\\%$ relative error"},{"type":"callout","variant":"warning","content":"Always state units with absolute error."},{"type":"question","questionText":"Which is unitless?","questionType":"multiple_choice","options":["Relative error","Absolute error","Both","Neither"],"correctAnswer":"Relative error","explanation":"Ratio of same units."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'absolute_relative_error'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Errors — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Absolute error formula?', 'multiple_choice', '["$|M - T|$","$M - T$","$M + T$","$M \\times T$"]'::jsonb, '"$|M - T|$"'::jsonb, 'easy', 'Modulus of difference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Absolute error formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'True $100$, measured $97$. Absolute error?', 'multiple_choice', '["$3$","$97$","$3\\%$","$197$"]'::jsonb, '"$3$"'::jsonb, 'easy', '$|97-100|$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='True $100$, measured $97$. Absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Percentage error multiplies relative by?', 'multiple_choice', '["$100$","$10$","$1$","$1000$"]'::jsonb, '"$100$"'::jsonb, 'easy', 'Convert to percent.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Percentage error multiplies relative by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Relative error denominator is usually?', 'multiple_choice', '["True value","Measured value","Sum","Product"]'::jsonb, '"True value"'::jsonb, 'easy', 'Standard definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Relative error denominator is usually?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Measured $5.0$ cm, true $5.0$ cm. Error?', 'multiple_choice', '["$0$","$5$","$10$","Unknown"]'::jsonb, '"$0$"'::jsonb, 'easy', 'Perfect match.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Measured $5.0$ cm, true $5.0$ cm. Error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2\%$ as decimal relative error?', 'multiple_choice', '["$0.02$","$0.2$","$2$","$0.002$"]'::jsonb, '"$0.02$"'::jsonb, 'easy', 'Divide by $100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2\%$ as decimal relative error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Absolute error of $8.2$ vs true $8$?', 'multiple_choice', '["$0.2$","$0.8$","$16.2$","$1.6$"]'::jsonb, '"$0.2$"'::jsonb, 'easy', 'Subtract.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Absolute error of $8.2$ vs true $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'True $40$ kg, absolute error $2$ kg. Relative error?', 'multiple_choice', '["$0.05$","$0.02$","$5$","$20$"]'::jsonb, '"$0.05$"'::jsonb, 'medium', '$2/40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='True $40$ kg, absolute error $2$ kg. Relative error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Measured $150$ V, $3\%$ relative error. Absolute error?', 'multiple_choice', '["$4.5$ V","$3$ V","$45$ V","$0.03$ V"]'::jsonb, '"$4.5$ V"'::jsonb, 'medium', '$0.03 \times 150$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Measured $150$ V, $3\%$ relative error. Absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'True $0.50$ m, measured $0.53$ m. Percentage error?', 'multiple_choice', '["$6\\%$","$3\\%$","$0.6\\%$","$60\\%$"]'::jsonb, '"$6\\%$"'::jsonb, 'medium', '$0.03/0.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='True $0.50$ m, measured $0.53$ m. Percentage error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which has larger absolute error: $|12-10|$ or $|12-11.5|$?', 'multiple_choice', '["$|12-10|$","$|12-11.5|$","Equal","Cannot tell"]'::jsonb, '"$|12-10|$"'::jsonb, 'medium', '$2$ vs $0.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which has larger absolute error: $|12-10|$ or $|12-11.5|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Relative error $0.01$ on $500$ m. Absolute?', 'multiple_choice', '["$5$ m","$50$ m","$0.5$ m","$500$ m"]'::jsonb, '"$5$ m"'::jsonb, 'medium', 'Multiply.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Relative error $0.01$ on $500$ m. Absolute?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'True speed $80$ km/h, measured $76$ km/h. Percentage error?', 'multiple_choice', '["$5\\%$","$4\\%$","$5$ km/h","$4$ km/h"]'::jsonb, '"$5\\%$"'::jsonb, 'medium', '$4/80$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='True speed $80$ km/h, measured $76$ km/h. Percentage error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Absolute error $0.05$ g on true $2.5$ g. Relative?', 'multiple_choice', '["$0.02$","$0.05$","$2\\%$ only","$5\\%$"]'::jsonb, '"$0.02$"'::jsonb, 'medium', '$0.05/2.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Absolute error $0.05$ g on true $2.5$ g. Relative?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Measured twice: $9.8$ and $10.2$; true $10$. Mean absolute error?', 'multiple_choice', '["$0.2$","$0.4$","$0$","$1$"]'::jsonb, '"$0.2$"'::jsonb, 'medium', 'Average of $|0.2|$ and $|0.2|$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Measured twice: $9.8$ and $10.2$; true $10$. Mean absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stopwatch true period $2.00$ s, reads $2.06$ s. Percentage error?', 'multiple_choice', '["$3\\%$","$6\\%$","$0.06\\%$","$30\\%$"]'::jsonb, '"$3\\%$"'::jsonb, 'hard', '$0.06/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stopwatch true period $2.00$ s, reads $2.06$ s. Percentage error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Relative error $1.5\%$ on mass $80$ g. Absolute error?', 'multiple_choice', '["$1.2$ g","$1.5$ g","$12$ g","$0.12$ g"]'::jsonb, '"$1.2$ g"'::jsonb, 'hard', '$0.015 \times 80$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Relative error $1.5\%$ on mass $80$ g. Absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'True $L = 12$ cm, $|M-L| \leq 0.3$ cm. Max relative error?', 'multiple_choice', '["$2.5\\%$","$3\\%$","$0.3\\%$","$25\\%$"]'::jsonb, '"$2.5\\%$"'::jsonb, 'hard', '$0.3/12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='True $L = 12$ cm, $|M-L| \leq 0.3$ cm. Max relative error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two measurements $49$ and $51$; accepted $50$. Max absolute error?', 'multiple_choice', '["$1$","$2$","$50$","$100$"]'::jsonb, '"$1$"'::jsonb, 'hard', 'Worst case each side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two measurements $49$ and $51$; accepted $50$. Max absolute error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Percentage error increases when true value?', 'multiple_choice', '["Decreases (same absolute error)","Increases","Is zero","Is negative only"]'::jsonb, '"Decreases (same absolute error)"'::jsonb, 'hard', 'Smaller denominator.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Percentage error increases when true value?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Scale reads $2.4$ kg for $2.5$ kg bag. Relative error to $2$ s.f.?', 'multiple_choice', '["$0.040$","$0.04$","$4\\%$","$0.4$"]'::jsonb, '"$0.040$"'::jsonb, 'hard', '$0.1/2.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='absolute_relative_error'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Scale reads $2.4$ kg for $2.5$ kg bag. Relative error to $2$ s.f.?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Measurements', '{"blocks":[{"type":"heading","content":"Error in Sums and Differences"},{"type":"paragraph","content":"When adding or subtracting measurements, **absolute errors add** (worst case)."},{"type":"math_block","latex":"\\Delta_{A \\pm B} = \\Delta_A + \\Delta_B","caption":"Propagation for addition/subtraction"},{"type":"example","title":"$a = 5.0 \\pm 0.1$ cm, $b = 3.0 \\pm 0.1$ cm. Find range of $a + b$.","steps":["Max error $0.2$ cm.","$a+b = 8.0 \\pm 0.2$ cm."],"answer":"$7.8$ to $8.2$ cm"},{"type":"question","questionText":"Add errors $0.05$ and $0.03$. Combined absolute?","questionType":"multiple_choice","options":["$0.08$","$0.02$","$0.15$","$0.0015$"],"correctAnswer":"$0.08$","explanation":"Sum absolute errors."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'propagation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Measurements');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying and Dividing with Errors', '{"blocks":[{"type":"heading","content":"Relative Errors Multiply"},{"type":"math_block","latex":"\\frac{\\Delta_{A \\times B}}{AB} \\approx \\frac{\\Delta_A}{A} + \\frac{\\Delta_B}{B}","caption":"Relative errors add for product"},{"type":"paragraph","content":"For products and quotients, add **relative** errors (approximation used at KCSE level)."},{"type":"example","title":"$l = 2.0 \\pm 0.1$ m, $w = 3.0 \\pm 0.1$ m. Estimate error in area.","steps":["Relative: $\\frac{0.1}{2} + \\frac{0.1}{3} \\approx 0.083$.","Area $6$ m$^2$; $\\Delta \\approx 0.5$ m$^2$."],"answer":"About $\\pm 0.5$ m$^2$"},{"type":"callout","variant":"warning","content":"Convert back to absolute error after adding relative parts."},{"type":"question","questionText":"Multiplying two lengths: combine which errors?","questionType":"multiple_choice","options":["Relative","Absolute only","Subtract","Ignore"],"correctAnswer":"Relative","explanation":"Product rule."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'propagation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing with Errors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Propagation — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Error Propagation"},{"type":"example","title":"Density $\\rho = m/V$. Mass $200 \\pm 2$ g, volume $50.0 \\pm 0.5$ cm$^3$.","steps":["$\\rho = 4$ g/cm$^3$.","Relative errors: $\\frac{2}{200} + \\frac{0.5}{50} = 0.01 + 0.01 = 0.02$.","Absolute $\\approx 0.08$ g/cm$^3$."],"answer":"$4.0 \\pm 0.08$ g/cm$^3$"},{"type":"callout","variant":"warning","content":"Show working for relative errors before final absolute answer."},{"type":"question","questionText":"$A = lw$. If both have $1\\%$ relative error, area relative error about?","questionType":"multiple_choice","options":["$2\\%$","$1\\%$","$0.5\\%$","$100\\%$"],"correctAnswer":"$2\\%$","explanation":"Add relative parts."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors' AND st.code = 'propagation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Propagation — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Adding measurements: absolute errors?', 'multiple_choice', '["Add","Multiply","Subtract","Divide"]'::jsonb, '"Add"'::jsonb, 'easy', 'Sum rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Adding measurements: absolute errors?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3 \pm 0.2$ plus $5 \pm 0.1$. Max combined error?', 'multiple_choice', '["$0.3$","$0.2$","$0.1$","$8$"]'::jsonb, '"$0.3$"'::jsonb, 'easy', '$0.2+0.1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3 \pm 0.2$ plus $5 \pm 0.1$. Max combined error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Product rule uses mainly?', 'multiple_choice', '["Relative errors","Absolute only","Square roots","Logs"]'::jsonb, '"Relative errors"'::jsonb, 'easy', 'Standard propagation.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Product rule uses mainly?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$10 \pm 1$ has relative error?', 'multiple_choice', '["$0.1$","$1$","$10$","$0.01$"]'::jsonb, '"$0.1$"'::jsonb, 'easy', '$1/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$10 \pm 1$ has relative error?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Subtracting: absolute errors?', 'multiple_choice', '["Add","Cancel","Multiply","Zero"]'::jsonb, '"Add"'::jsonb, 'easy', 'Worst case still adds.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Subtracting: absolute errors?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2\%$ plus $3\%$ relative gives about?', 'multiple_choice', '["$5\\%$","$6\\%$","$1\\%$","$0.5\\%$"]'::jsonb, '"$5\\%$"'::jsonb, 'easy', 'Sum for product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2\%$ plus $3\%$ relative gives about?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area from $l$ and $w$: errors combine as?', 'multiple_choice', '["Relative sum","Absolute sum only","Difference","None"]'::jsonb, '"Relative sum"'::jsonb, 'easy', 'Product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area from $l$ and $w$: errors combine as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$4.0 \pm 0.2$ and $2.0 \pm 0.1$. Sum range width?', 'multiple_choice', '["$0.6$","$0.3$","$0.2$","$6.0$"]'::jsonb, '"$0.6$"'::jsonb, 'medium', 'Total $\pm 0.3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$4.0 \pm 0.2$ and $2.0 \pm 0.1$. Sum range width?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$50 \pm 2$ divided by $10 \pm 0.5$. Relative parts?', 'multiple_choice', '["$0.04 + 0.05$","$0.02 + 0.5$","$2 + 0.5$","$5$"]'::jsonb, '"$0.04 + 0.05$"'::jsonb, 'medium', '$2/50 + 0.5/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$50 \pm 2$ divided by $10 \pm 0.5$. Relative parts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Volume $V = l^3$ with $1\%$ error in $l$. Relative error in $V$?', 'multiple_choice', '["$3\\%$","$1\\%$","$9\\%$","$30\\%$"]'::jsonb, '"$3\\%$"'::jsonb, 'medium', 'Triple relative in cube.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Volume $V = l^3$ with $1\%$ error in $l$. Relative error in $V$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$m = 80 \pm 4$ g, $V = 20 \pm 1$ cm$^3$. $\rho$ nominal?', 'multiple_choice', '["$4$ g/cm$^3$","$5$ g/cm$^3$","$3$ g/cm$^3$","$80$ g/cm$^3$"]'::jsonb, '"$4$ g/cm$^3$"'::jsonb, 'medium', '$80/20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$m = 80 \pm 4$ g, $V = 20 \pm 1$ cm$^3$. $\rho$ nominal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Same data: relative error in $\rho$ about?', 'multiple_choice', '["$0.05 + 0.05 = 0.1$","$0.1$ only","$0.01$","$0.2$"]'::jsonb, '"$0.05 + 0.05 = 0.1$"'::jsonb, 'medium', 'Add relative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Same data: relative error in $\rho$ about?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perimeter $P = 2(l+w)$ with errors in $l,w$. Use?', 'multiple_choice', '["Add absolute errors in $l$ and $w$ then double","Multiply relative","Ignore","Subtract"]'::jsonb, '"Add absolute errors in $l$ and $w$ then double"'::jsonb, 'medium', 'Sum before scale.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perimeter $P = 2(l+w)$ with errors in $l,w$. Use?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x = 6 \pm 0.3$, $y = 6 \pm 0.3$. Product $36 \pm ?$ about', 'multiple_choice', '["$\\pm 3.6$","$\\pm 0.6$","$\\pm 36$","$\\pm 0.36$"]'::jsonb, '"$\\pm 3.6$"'::jsonb, 'medium', '$10\%$ each $\Rightarrow 20\%$ of $36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x = 6 \pm 0.3$, $y = 6 \pm 0.3$. Product $36 \pm ?$ about');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Power $A = s^2$: if $s$ has rel. error $r$, $A$ has about?', 'multiple_choice', '["$2r$","$r$","$r^2$","$\\sqrt{r}$"]'::jsonb, '"$2r$"'::jsonb, 'medium', 'Square doubles relative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Power $A = s^2$: if $s$ has rel. error $r$, $A$ has about?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chain: divide $a$ by $b$ with $2\%$ and $1\%$ rel. errors. Combined?', 'multiple_choice', '["$3\\%$","$1\\%$","$2\\%$","$0.5\\%$"]'::jsonb, '"$3\\%$"'::jsonb, 'hard', 'Add relative magnitudes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chain: divide $a$ by $b$ with $2\%$ and $1\%$ rel. errors. Combined?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$T = 2\pi\sqrt{L/g}$. Only $L$ has $4\%$ error. $T$ relative?', 'multiple_choice', '["$2\\%$","$4\\%$","$8\\%$","$1\\%$"]'::jsonb, '"$2\\%$"'::jsonb, 'hard', 'Square root halves exponent.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$T = 2\pi\sqrt{L/g}$. Only $L$ has $4\%$ error. $T$ relative?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $12 \pm 0.2$ by $8 \pm 0.2$. Max absolute area error approx?', 'multiple_choice', '["$3.2$","$0.4$","$1.6$","$96$"]'::jsonb, '"$3.2$"'::jsonb, 'hard', 'Relative sum $\times 96$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $12 \pm 0.2$ by $8 \pm 0.2$. Max absolute area error approx?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Why add absolute errors for $a - b$?', 'multiple_choice', '["Worst-case deviation","They cancel","Always zero","Use relative only"]'::jsonb, '"Worst-case deviation"'::jsonb, 'hard', 'Conservative bound.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Why add absolute errors for $a - b$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$k = \frac{xy}{z}$. Relative errors $1\%, 2\%, 2\%$ in $x,y,z$. Combined?', 'multiple_choice', '["$5\\%$","$3\\%$","$1\\%$","$4\\%$"]'::jsonb, '"$5\\%$"'::jsonb, 'hard', 'Add for product, add for divide.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$k = \frac{xy}{z}$. Relative errors $1\%, 2\%, 2\%$ in $x,y,z$. Combined?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Speed from $d = 100 \pm 2$ m, $t = 20.0 \pm 0.2$ s. $v$ about?', 'multiple_choice', '["$5.0 \\pm 0.12$ m/s","$5 \\pm 2$ m/s","$5 \\pm 0.2$ m/s","$100$ m/s"]'::jsonb, '"$5.0 \\pm 0.12$ m/s"'::jsonb, 'hard', 'Rel. $0.02+0.01$ on $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='propagation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='approximations_errors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Speed from $d = 100 \pm 2$ m, $t = 20.0 \pm 0.2$ s. $v$ about?');

