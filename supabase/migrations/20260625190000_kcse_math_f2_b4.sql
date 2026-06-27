-- KCSE Form 2 Mathematics — Wave 2 Batch 4
-- Topics: linear_inequalities, linear_motion, statistics_i, angle_properties_circle, vectors_i
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== LINEAR INEQUALITIES ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Linear Inequalities', '{"blocks":[{"type":"heading","content":"Linear Inequalities"},{"type":"paragraph","content":"A **linear inequality** compares two expressions using $<$, $>$, $\\leq$, or $\\geq$. Solve like an equation, but **reverse the inequality sign** when multiplying or dividing by a negative number."},{"type":"math_block","latex":"ax + b < c \\Rightarrow x < \\frac{c-b}{a} \\quad (a > 0)","caption":"Same steps as equations unless you multiply/divide by a negative"},{"type":"callout","variant":"key_point","content":"Treat $=$ as part of $\\leq$ or $\\geq$; do not reverse the sign when adding or subtracting."},{"type":"example","title":"Solve $3x - 5 < 7$.","steps":["Add $5$: $3x < 12$.","Divide by $3$: $x < 4$."],"answer":"$x < 4$"},{"type":"question","questionText":"When solving $-2x > 6$, the sign becomes?","questionType":"multiple_choice","options":["$x < -3$","$x > -3$","$x < 3$","$x > 3$"],"correctAnswer":"$x < -3$","explanation":"Divide by $-2$ and reverse."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Linear Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Inequalities with Brackets', '{"blocks":[{"type":"heading","content":"Brackets and Fractions"},{"type":"example","title":"Solve $2(x + 3) \\geq 10$.","steps":["Expand: $2x + 6 \\geq 10$.","Subtract $6$: $2x \\geq 4$.","Divide: $x \\geq 2$."],"answer":"$x \\geq 2$"},{"type":"example","title":"Solve $\\frac{x}{3} + 2 < 5$.","steps":["Subtract $2$: $\\frac{x}{3} < 3$.","Multiply by $3$: $x < 9$."],"answer":"$x < 9$"},{"type":"callout","variant":"warning","content":"Clear fractions early by multiplying every term by the LCD."},{"type":"question","questionText":"Solve $4 - x > 1$.","questionType":"multiple_choice","options":["$x < 3$","$x > 3$","$x < -3$","$x > -3$"],"correctAnswer":"$x < 3$","explanation":"$-x > -3$, multiply by $-1$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Inequalities with Brackets');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Inequalities — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Solving Inequalities"},{"type":"example","title":"Solve $5 - 2x \\leq 11$.","steps":["$-2x \\leq 6$.","Divide by $-2$, reverse: $x \\geq -3$."],"answer":"$x \\geq -3$"},{"type":"callout","variant":"warning","content":"KCSE often tests sign reversal — underline when you divide by a negative."},{"type":"question","questionText":"Solution of $3x + 1 > 10$?","questionType":"multiple_choice","options":["$x > 3$","$x < 3$","$x > 9$","$x < 9$"],"correctAnswer":"$x > 3$","explanation":"$3x > 9$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'solving_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Inequalities — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Representing Solutions on a Number Line', '{"blocks":[{"type":"heading","content":"Number Line Representation"},{"type":"paragraph","content":"After solving, show the solution set on a **number line**. Open circle for $<$ or $>$; closed circle for $\\leq$ or $\\geq$."},{"type":"callout","variant":"key_point","content":"Shade the region that satisfies the inequality."},{"type":"example","title":"Show $x \\geq -2$ on a number line.","steps":["Closed circle at $-2$.","Shade all values to the right."],"answer":"Ray from $-2$ rightward, closed at $-2$"},{"type":"question","questionText":"$x < 5$ uses which circle at $5$?","questionType":"multiple_choice","options":["Open","Closed","No circle","Shaded square"],"correctAnswer":"Open","explanation":"Strict inequality."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Representing Solutions on a Number Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Inequalities on a Number Line', '{"blocks":[{"type":"heading","content":"Double Inequalities"},{"type":"example","title":"Show $-1 < x \\leq 4$.","steps":["Open circle at $-1$, closed at $4$.","Shade between them."],"answer":"Interval $(-1, 4]$"},{"type":"callout","variant":"warning","content":"Read double inequalities left to right: lower bound first."},{"type":"question","questionText":"$2 \\leq x < 7$ includes $2$?","questionType":"multiple_choice","options":["Yes","No","Only if $x$ is integer","Cannot tell"],"correctAnswer":"Yes","explanation":"$\\leq$ includes $2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Inequalities on a Number Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Number Line — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Number Lines"},{"type":"example","title":"Solve and show: $x - 3 < 2$.","steps":["$x < 5$.","Open circle at $5$, shade left."],"answer":"$x < 5$"},{"type":"callout","variant":"warning","content":"Always state the inequality AND sketch the number line in exam answers."},{"type":"question","questionText":"Integer values satisfying $0 < x \\leq 3$?","questionType":"multiple_choice","options":["$1, 2, 3$","$0, 1, 2, 3$","$1, 2$","$2, 3$"],"correctAnswer":"$1, 2, 3$","explanation":"$0$ excluded, $3$ included."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'number_line_ineq'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Number Line — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Graphing Linear Inequalities', '{"blocks":[{"type":"heading","content":"Graphical Regions"},{"type":"paragraph","content":"Replace $<$ with $=$ to draw the boundary line. **Dashed line** for strict inequality; **solid line** for $\\leq$ or $\\geq$."},{"type":"callout","variant":"key_point","content":"Test a point (often origin) to decide which side to shade."},{"type":"example","title":"Sketch $y > 2x - 1$.","steps":["Draw dashed line $y = 2x - 1$.","Test $(0,0)$: $0 > -1$ true — shade that side."],"answer":"Region above dashed line"},{"type":"question","questionText":"$y \\leq x + 2$ boundary line style?","questionType":"multiple_choice","options":["Solid","Dashed","Dotted only","No line"],"correctAnswer":"Solid","explanation":"Includes equality."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Graphing Linear Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Systems of Inequalities', '{"blocks":[{"type":"heading","content":"Feasible Region"},{"type":"example","title":"Shade $x \\geq 0$, $y \\geq 0$, $x + y \\leq 6$.","steps":["First quadrant axes.","Line $x+y=6$; shade below.","Overlap is the feasible region."],"answer":"Triangle in first quadrant"},{"type":"callout","variant":"warning","content":"Label each inequality on your sketch for method marks."},{"type":"question","questionText":"Feasible region of a system is?","questionType":"multiple_choice","options":["Overlap of half-planes","Union only","Single point always","Empty always"],"correctAnswer":"Overlap of half-planes","explanation":"Intersection of regions."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Systems of Inequalities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Graphical Region — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Graphical Inequalities"},{"type":"example","title":"Region: $y < 3$ and $x > -1$.","steps":["Horizontal dashed line $y=3$, shade below.","Vertical dashed $x=-1$, shade right."],"answer":"Infinite strip"},{"type":"callout","variant":"warning","content":"Use consistent shading (diagonal lines or colour) and mark the unbounded region clearly."},{"type":"question","questionText":"Point $(2,1)$ satisfies $y < x$?","questionType":"multiple_choice","options":["Yes","No","On boundary","Undefined"],"correctAnswer":"Yes","explanation":"$1 < 2$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities' AND st.code = 'graphical_region'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Graphical Region — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Symbol for ''greater than or equal''?', 'multiple_choice', '["$\geq$", "$>$", "$\leq$", "$=$"]'::jsonb, '"$\geq$"'::jsonb, 'easy', 'Inclusive lower bound.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Symbol for ''greater than or equal''?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x + 4 > 9$.', 'multiple_choice', '["$x > 5$", "$x < 5$", "$x > 13$", "$x < 13$"]'::jsonb, '"$x > 5$"'::jsonb, 'easy', 'Subtract $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x + 4 > 9$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2x \leq 8$.', 'multiple_choice', '["$x \leq 4$", "$x \geq 4$", "$x \leq 16$", "$x \geq 16$"]'::jsonb, '"$x \leq 4$"'::jsonb, 'easy', 'Divide by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2x \leq 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reverse sign when multiplying by?', 'multiple_choice', '["Negative number", "Positive number", "Zero", "One"]'::jsonb, '"Negative number"'::jsonb, 'easy', 'Key rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reverse sign when multiplying by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x - 7 \geq 0$.', 'multiple_choice', '["$x \geq 7$", "$x \leq 7$", "$x > 7$", "$x < 7$"]'::jsonb, '"$x \geq 7$"'::jsonb, 'easy', 'Add $7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x - 7 \geq 0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5x + 2 < 17$.', 'multiple_choice', '["$x < 3$", "$x > 3$", "$x < 15$", "$x > 15$"]'::jsonb, '"$x < 3$"'::jsonb, 'easy', '$5x < 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5x + 2 < 17$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solution set of $x > -1$ includes $0$?', 'multiple_choice', '["Yes", "No", "Only if integer", "Never"]'::jsonb, '"Yes"'::jsonb, 'easy', '$0 > -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solution set of $x > -1$ includes $0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2x - 3 > 5$.', 'multiple_choice', '["$x > 4$", "$x < 4$", "$x > 1$", "$x < 1$"]'::jsonb, '"$x > 4$"'::jsonb, 'medium', '$2x > 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2x - 3 > 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $-3x \geq 9$.', 'multiple_choice', '["$x \leq -3$", "$x \geq -3$", "$x \leq 3$", "$x \geq 3$"]'::jsonb, '"$x \leq -3$"'::jsonb, 'medium', 'Divide by $-3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $-3x \geq 9$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $3(x - 2) < 12$.', 'multiple_choice', '["$x < 6$", "$x > 6$", "$x < 4$", "$x > 4$"]'::jsonb, '"$x < 6$"'::jsonb, 'medium', '$x - 2 < 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $3(x - 2) < 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$-2 < x \leq 5$ includes $5$?', 'multiple_choice', '["Yes", "No", "Only $-2$", "Neither"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Closed at $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$-2 < x \leq 5$ includes $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{x}{2} + 1 \leq 5$.', 'multiple_choice', '["$x \leq 8$", "$x \geq 8$", "$x \leq 4$", "$x \geq 4$"]'::jsonb, '"$x \leq 8$"'::jsonb, 'medium', '$\frac{x}{2} \leq 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{x}{2} + 1 \leq 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Integers with $-3 \leq x < 1$?', 'multiple_choice', '["$-3,-2,-1,0$", "$-2,-1,0$", "$-3,-2,-1$", "$0,1$"]'::jsonb, '"$-3,-2,-1,0$"'::jsonb, 'medium', '$1$ excluded.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Integers with $-3 \leq x < 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Open circle means?', 'multiple_choice', '["Value not included", "Value included", "No solution", "Equal only"]'::jsonb, '"Value not included"'::jsonb, 'medium', 'Strict inequality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_ineq'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Open circle means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Test point for $y > x + 1$ at origin?', 'multiple_choice', '["Not satisfied", "Satisfied", "On line", "Undefined"]'::jsonb, '"Not satisfied"'::jsonb, 'medium', '$0 > 1$ false.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Test point for $y > x + 1$ at origin?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y \leq 4$ describes?', 'multiple_choice', '["Region below/on horizontal line $y=4$", "Above $y=4$", "Vertical line", "Circle"]'::jsonb, '"Region below/on horizontal line $y=4$"'::jsonb, 'medium', 'Horizontal boundary.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y \leq 4$ describes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $4 - 2x < 10$.', 'multiple_choice', '["$x > -3$", "$x < -3$", "$x > 3$", "$x < 3$"]'::jsonb, '"$x > -3$"'::jsonb, 'hard', '$-2x < 6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $4 - 2x < 10$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{2x+1}{3} > 3$.', 'multiple_choice', '["$x > 4$", "$x < 4$", "$x > 5$", "$x < 5$"]'::jsonb, '"$x > 4$"'::jsonb, 'hard', '$2x+1 > 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{2x+1}{3} > 3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Age: at least $18$ means?', 'multiple_choice', '["$a \geq 18$", "$a > 18$", "$a \leq 18$", "$a < 18$"]'::jsonb, '"$a \geq 18$"'::jsonb, 'hard', 'At least = inclusive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Age: at least $18$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5x - 2 \geq 3x + 6$.', 'multiple_choice', '["$x \geq 4$", "$x \leq 4$", "$x \geq 2$", "$x \leq 2$"]'::jsonb, '"$x \geq 4$"'::jsonb, 'hard', '$2x \geq 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5x - 2 \geq 3x + 6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Region $x \geq 0$ and $y \geq 0$ is?', 'multiple_choice', '["First quadrant", "Second quadrant", "Third quadrant", "Fourth quadrant"]'::jsonb, '"First quadrant"'::jsonb, 'hard', 'Non-negative axes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Region $x \geq 0$ and $y \geq 0$ is?');
