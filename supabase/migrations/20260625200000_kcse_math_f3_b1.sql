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

