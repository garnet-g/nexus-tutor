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

-- ========== LINEAR MOTION ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance–Time Graphs', '{"blocks":[{"type":"heading","content":"Distance–Time Graphs"},{"type":"paragraph","content":"On a **distance–time graph**, gradient equals **speed**. Horizontal line means stationary."},{"type":"math_block","latex":"\\text{speed} = \\frac{\\Delta d}{\\Delta t}","caption":"Gradient of distance–time graph"},{"type":"callout","variant":"key_point","content":"Steeper line ⇒ greater speed."},{"type":"example","title":"Distance $60$ km in $2$ h. Average speed?","steps":["$\\frac{60}{2} = 30$ km/h."],"answer":"$30$ km/h"},{"type":"question","questionText":"Horizontal section on d–t graph means?","questionType":"multiple_choice","options":["Stationary","Constant speed","Accelerating","Returning"],"correctAnswer":"Stationary","explanation":"Distance unchanged."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Distance–Time Graphs', '{"blocks":[{"type":"heading","content":"Interpreting Graphs"},{"type":"example","title":"Graph rises $40$ km in $1$ h then flat $30$ min.","steps":["First hour: speed $40$ km/h.","Flat: rest $0.5$ h."],"answer":"Speed then rest"},{"type":"callout","variant":"warning","content":"Units on axes must match before calculating gradient."},{"type":"question","questionText":"Distance $100$ m in $25$ s. Speed?","questionType":"multiple_choice","options":["$4$ m/s","$25$ m/s","$0.25$ m/s","$125$ m/s"],"correctAnswer":"$4$ m/s","explanation":"$100/25$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Distance–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance–Time — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Distance–Time"},{"type":"example","title":"Bus: $0$–$2$ h travels $80$ km; $2$–$3$ h rest; $3$–$5$ h returns $80$ km.","steps":["Outward speed $40$ km/h.","Return speed $40$ km/h opposite direction."],"answer":"Piecewise journey"},{"type":"callout","variant":"warning","content":"Returning shows decreasing distance from start — negative gradient."},{"type":"question","questionText":"Gradient of d–t graph represents?","questionType":"multiple_choice","options":["Speed","Acceleration","Distance","Time"],"correctAnswer":"Speed","explanation":"$\\Delta d/\\Delta t$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'distance_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance–Time — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Velocity–Time Graphs', '{"blocks":[{"type":"heading","content":"Velocity–Time Graphs"},{"type":"paragraph","content":"On a **velocity–time graph**, gradient is **acceleration** and area under graph is **distance** (or displacement)."},{"type":"math_block","latex":"a = \\frac{\\Delta v}{\\Delta t}, \\quad d = \\text{area under } v\\text{–}t \\text{ graph}","caption":"Key v–t interpretations"},{"type":"example","title":"Speed constant $20$ m/s for $5$ s. Distance?","steps":["Rectangle area $20 \\times 5 = 100$ m."],"answer":"$100$ m"},{"type":"question","questionText":"Zero gradient on v–t graph means?","questionType":"multiple_choice","options":["Constant velocity","Zero velocity","Maximum speed","Returning"],"correctAnswer":"Constant velocity","explanation":"No acceleration."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Velocity–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area Under Velocity–Time Graphs', '{"blocks":[{"type":"heading","content":"Area Methods"},{"type":"example","title":"Triangle: $v$ from $0$ to $10$ m/s in $4$ s.","steps":["Area $\\frac{1}{2}(4)(10) = 20$ m."],"answer":"$20$ m"},{"type":"callout","variant":"warning","content":"Split complex graphs into rectangles and triangles."},{"type":"question","questionText":"Trapezium on v–t: use?","questionType":"multiple_choice","options":["Area formula for trapezium","Circumference","Pythagoras only","Gradient only"],"correctAnswer":"Area formula for trapezium","explanation":"Area = distance."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area Under Velocity–Time Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Velocity–Time — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Velocity–Time"},{"type":"example","title":"$v=6$ m/s for $3$ s, then $v=2$ m/s for $2$ s. Total distance?","steps":["$6(3)+2(2)=22$ m."],"answer":"$22$ m"},{"type":"callout","variant":"warning","content":"Show area calculation clearly — method marks for splitting the graph."},{"type":"question","questionText":"Negative velocity on graph means?","questionType":"multiple_choice","options":["Moving opposite direction","Slowing only","Stationary","Speed increasing"],"correctAnswer":"Moving opposite direction","explanation":"Direction reversed."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'velocity_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Velocity–Time — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Acceleration Concept', '{"blocks":[{"type":"heading","content":"Acceleration"},{"type":"paragraph","content":"**Acceleration** is rate of change of velocity: $a = (v-u)/t$ for constant acceleration."},{"type":"math_block","latex":"a = \\frac{v - u}{t}","caption":"$u$ initial velocity, $v$ final, $t$ time"},{"type":"example","title":"Car $20$ m/s to $35$ m/s in $5$ s. Acceleration?","steps":["$a = (35-20)/5 = 3$ m/s$^2$."],"answer":"$3$ m/s$^2$"},{"type":"question","questionText":"Deceleration means acceleration is?","questionType":"multiple_choice","options":["Negative","Positive","Zero always","Infinite"],"correctAnswer":"Negative","explanation":"Slowing down."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Acceleration Concept');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Equations of Linear Motion', '{"blocks":[{"type":"heading","content":"SUVAT for Linear Motion"},{"type":"callout","variant":"key_point","content":"For uniform acceleration: $v = u + at$, $s = ut + \\frac{1}{2}at^2$, $v^2 = u^2 + 2as$."},{"type":"example","title":"$u=0$, $a=2$ m/s$^2$, $t=6$ s. Find $v$ and $s$.","steps":["$v = 0 + 2(6) = 12$ m/s.","$s = 0 + \\frac{1}{2}(2)(36) = 36$ m."],"answer":"$v=12$ m/s, $s=36$ m"},{"type":"question","questionText":"$u=5$ m/s, $a=3$ m/s$^2$, $t=4$ s. Final $v$?","questionType":"multiple_choice","options":["$17$ m/s","$12$ m/s","$20$ m/s","$7$ m/s"],"correctAnswer":"$17$ m/s","explanation":"$5+12$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Equations of Linear Motion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Acceleration — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Acceleration"},{"type":"example","title":"Train brakes from $25$ m/s to $10$ m/s in $3$ s.","steps":["$a = (10-25)/3 = -5$ m/s$^2$."],"answer":"$-5$ m/s$^2$ (deceleration)"},{"type":"callout","variant":"warning","content":"State units: m/s$^2$ for acceleration, not m/s."},{"type":"question","questionText":"Uniform acceleration graph on v–t is?","questionType":"multiple_choice","options":["Straight line","Horizontal line","Circle","Hyperbola"],"correctAnswer":"Straight line","explanation":"Constant gradient."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion' AND st.code = 'acceleration'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Acceleration — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Distance–time gradient equals?', 'multiple_choice', '["Speed", "Acceleration", "Force", "Area"]'::jsonb, '"Speed"'::jsonb, 'easy', '$\Delta d/\Delta t$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Distance–time gradient equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$120$ km in $3$ h. Average speed?', 'multiple_choice', '["$40$ km/h", "$360$ km/h", "$117$ km/h", "$30$ km/h"]'::jsonb, '"$40$ km/h"'::jsonb, 'easy', '$120/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$120$ km in $3$ h. Average speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stationary object on d–t graph?', 'multiple_choice', '["Horizontal line", "Steep line", "Vertical line", "Curved line"]'::jsonb, '"Horizontal line"'::jsonb, 'easy', 'Distance constant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stationary object on d–t graph?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Speed $15$ m/s for $4$ s. Distance?', 'multiple_choice', '["$60$ m", "$19$ m", "$11$ m", "$240$ m"]'::jsonb, '"$60$ m"'::jsonb, 'easy', '$15 \times 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Speed $15$ m/s for $4$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Units of speed from km and h?', 'multiple_choice', '["km/h", "km h", "h/km", "km$^2$/h"]'::jsonb, '"km/h"'::jsonb, 'easy', 'Distance per time.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Units of speed from km and h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Graph steeper means?', 'multiple_choice', '["Greater speed", "Less speed", "Zero speed", "Negative distance"]'::jsonb, '"Greater speed"'::jsonb, 'easy', 'Larger gradient.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Graph steeper means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$50$ m in $10$ s. Speed?', 'multiple_choice', '["$5$ m/s", "$500$ m/s", "$40$ m/s", "$0.2$ m/s"]'::jsonb, '"$5$ m/s"'::jsonb, 'easy', '$50/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distance_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$50$ m in $10$ s. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area under v–t graph gives?', 'multiple_choice', '["Distance", "Speed only", "Mass", "Force"]'::jsonb, '"Distance"'::jsonb, 'medium', 'Integral of velocity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area under v–t graph gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of v–t graph gives?', 'multiple_choice', '["Acceleration", "Distance", "Speed only", "Time"]'::jsonb, '"Acceleration"'::jsonb, 'medium', '$\Delta v/\Delta t$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of v–t graph gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Constant velocity on v–t is?', 'multiple_choice', '["Horizontal line", "Vertical line", "Parabola", "Circle"]'::jsonb, '"Horizontal line"'::jsonb, 'medium', 'Zero acceleration.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Constant velocity on v–t is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle area $0$ to $8$ m/s in $2$ s. Distance?', 'multiple_choice', '["$8$ m", "$16$ m", "$4$ m", "$10$ m"]'::jsonb, '"$8$ m"'::jsonb, 'medium', '$\frac{1}{2}(2)(8)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle area $0$ to $8$ m/s in $2$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v=10$ m/s for $6$ s. Distance?', 'multiple_choice', '["$60$ m", "$16$ m", "$4$ m", "$600$ m"]'::jsonb, '"$60$ m"'::jsonb, 'medium', 'Rectangle area.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v=10$ m/s for $6$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Speed increases — v–t gradient is?', 'multiple_choice', '["Positive", "Negative", "Zero", "Undefined always"]'::jsonb, '"Positive"'::jsonb, 'medium', 'Accelerating.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Speed increases — v–t gradient is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Retardation is?', 'multiple_choice', '["Negative acceleration", "Positive acceleration", "Constant speed", "Zero velocity"]'::jsonb, '"Negative acceleration"'::jsonb, 'medium', 'Slowing down.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='velocity_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Retardation is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=0$, $a=4$ m/s$^2$, $t=5$ s. Final $v$?', 'multiple_choice', '["$20$ m/s", "$25$ m/s", "$9$ m/s", "$1$ m/s"]'::jsonb, '"$20$ m/s"'::jsonb, 'hard', '$v=at$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=0$, $a=4$ m/s$^2$, $t=5$ s. Final $v$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=10$ m/s, $v=30$ m/s, $t=4$ s. Acceleration?', 'multiple_choice', '["$5$ m/s$^2$", "$10$ m/s$^2$", "$7.5$ m/s$^2$", "$40$ m/s$^2$"]'::jsonb, '"$5$ m/s$^2$"'::jsonb, 'hard', '$(30-10)/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=10$ m/s, $v=30$ m/s, $t=4$ s. Acceleration?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$u=8$ m/s, $a=-2$ m/s$^2$, $t=3$ s. Final $v$?', 'multiple_choice', '["$2$ m/s", "$14$ m/s", "$6$ m/s", "$-6$ m/s"]'::jsonb, '"$2$ m/s"'::jsonb, 'hard', '$8-6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$u=8$ m/s, $a=-2$ m/s$^2$, $t=3$ s. Final $v$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$s=ut+\frac{1}{2}at^2$ with $u=2$, $a=3$, $t=4$. Find $s$.', 'multiple_choice', '["$32$ m", "$24$ m", "$14$ m", "$48$ m"]'::jsonb, '"$32$ m"'::jsonb, 'hard', '$8+24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$s=ut+\frac{1}{2}at^2$ with $u=2$, $a=3$, $t=4$. Find $s$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Car $0$ to $20$ m/s in $10$ s. Acceleration?', 'multiple_choice', '["$2$ m/s$^2$", "$200$ m/s$^2$", "$0.5$ m/s$^2$", "$10$ m/s$^2$"]'::jsonb, '"$2$ m/s$^2$"'::jsonb, 'hard', '$20/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Car $0$ to $20$ m/s in $10$ s. Acceleration?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$v^2=u^2+2as$ with $u=0$, $v=12$, $s=18$. Find $a$.', 'multiple_choice', '["$4$ m/s$^2$", "$6$ m/s$^2$", "$2$ m/s$^2$", "$8$ m/s$^2$"]'::jsonb, '"$4$ m/s$^2$"'::jsonb, 'hard', '$144=36a$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$v^2=u^2+2as$ with $u=0$, $v=12$, $s=18$. Find $a$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Uniform deceleration from $30$ m/s to $10$ m/s in $5$ s. $a$?', 'multiple_choice', '["$-4$ m/s$^2$", "$4$ m/s$^2$", "$-8$ m/s$^2$", "$8$ m/s$^2$"]'::jsonb, '"$-4$ m/s$^2$"'::jsonb, 'hard', '$(10-30)/5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='acceleration'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_motion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Uniform deceleration from $30$ m/s to $10$ m/s in $5$ s. $a$?');

-- ========== STATISTICS I ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Types of Data', '{"blocks":[{"type":"heading","content":"Collecting Data"},{"type":"paragraph","content":"**Primary data** is collected firsthand (surveys, experiments). **Secondary data** comes from existing sources (records, reports)."},{"type":"callout","variant":"key_point","content":"**Discrete** data counts items (goals scored). **Continuous** data is measured (height, mass)."},{"type":"example","title":"Class survey of shoe sizes.","steps":["Discrete if whole sizes only.","Define how ties are measured."],"answer":"Plan before collecting"},{"type":"question","questionText":"Number of siblings is?","questionType":"multiple_choice","options":["Discrete","Continuous","Secondary only","Not data"],"correctAnswer":"Discrete","explanation":"Countable whole numbers."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Types of Data');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sampling and Bias', '{"blocks":[{"type":"heading","content":"Sampling"},{"type":"paragraph","content":"A **sample** represents a **population**. Random sampling reduces bias."},{"type":"callout","variant":"warning","content":"Biased samples (only friends, only one class) cannot represent the whole population."},{"type":"example","title":"Estimate average height of Form 2 students.","steps":["Population: all Form 2.","Random sample across streams."],"answer":"Random sample"},{"type":"question","questionText":"Census means?","questionType":"multiple_choice","options":["Every member counted","Small sample only","Guess","Secondary data only"],"correctAnswer":"Every member counted","explanation":"Full population."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sampling and Bias');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Data Collection — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Data Collection"},{"type":"example","title":"Design a tally for transport to school.","steps":["Categories: walk, bus, matatu, bicycle.","Tally during registration."],"answer":"Clear categories"},{"type":"callout","variant":"warning","content":"State whether data is discrete or continuous in your introduction."},{"type":"question","questionText":"Mass of pupils is usually?","questionType":"multiple_choice","options":["Continuous","Discrete","Qualitative only","Ordinal only"],"correctAnswer":"Continuous","explanation":"Measured to decimals."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'data_collection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Data Collection — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Frequency Tables', '{"blocks":[{"type":"heading","content":"Frequency Tables"},{"type":"paragraph","content":"A **frequency table** shows how often each value (or class) occurs. **Tally marks** help counting."},{"type":"callout","variant":"key_point","content":"Total frequency = sum of all class frequencies."},{"type":"example","title":"Scores: 3,4,4,5,5,5. Build table.","steps":["3→1, 4→2, 5→3.","Total $6$."],"answer":"Freq sum $6$"},{"type":"question","questionText":"Frequency of $7$ if tally shows |||| |?","questionType":"multiple_choice","options":["$6$","$5$","$7$","$4$"],"correctAnswer":"$6$","explanation":"Five + one."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Frequency Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Grouped Frequency', '{"blocks":[{"type":"heading","content":"Class Intervals"},{"type":"paragraph","content":"For large data, use **class intervals** e.g. $10$–$19$, $20$–$29$. **Class width** = upper − lower (for equal classes)."},{"type":"example","title":"Classes $0$–$9$, $10$–$19$, $20$–$29$ with freqs $4,7,5$.","steps":["Total $16$.","Modal class has highest freq."],"answer":"$10$–$19$ modal class"},{"type":"callout","variant":"warning","content":"Check whether intervals are inclusive on both ends (KNEC style varies — read the question)."},{"type":"question","questionText":"Class width $20$–$29$?","questionType":"multiple_choice","options":["$10$","$9$","$29$","$20$"],"correctAnswer":"$10$","explanation":"$29-20+1$ or interval span."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Grouped Frequency');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Frequency Tables — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Frequency Tables"},{"type":"example","title":"From table total freq $40$, class $30$–$39$ has freq $12$. Percentage?","steps":["$\\frac{12}{40} \\times 100 = 30\\%$."],"answer":"$30\\%$"},{"type":"callout","variant":"warning","content":"Always verify frequencies sum to the stated total."},{"type":"question","questionText":"Cumulative frequency at row $k$ includes?","questionType":"multiple_choice","options":["All frequencies up to $k$","Only row $k$","Half the total","Maximum value"],"correctAnswer":"All frequencies up to $k$","explanation":"Running total."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'frequency_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Frequency Tables — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mean, Median and Mode', '{"blocks":[{"type":"heading","content":"Averages"},{"type":"math_block","latex":"\\text{Mean} = \\frac{\\sum fx}{\\sum f}","caption":"For frequency table with values $x$ and frequencies $f$"},{"type":"callout","variant":"key_point","content":"**Median** = middle value (ordered). **Mode** = most frequent value."},{"type":"example","title":"Data: 2,3,3,5,7. Mean, median, mode?","steps":["Mean $(2+3+3+5+7)/5 = 4$.","Median $3$.","Mode $3$."],"answer":"Mean $4$, median & mode $3$"},{"type":"question","questionText":"Mode is?","questionType":"multiple_choice","options":["Most frequent value","Middle value","Sum divided by $n$","Largest value"],"correctAnswer":"Most frequent value","explanation":"Highest frequency."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mean, Median and Mode');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mean from Frequency Tables', '{"blocks":[{"type":"heading","content":"Calculating Mean"},{"type":"example","title":"Value $x$: 1,2,3 with freq 2,3,1.","steps":["$\\sum fx = 2+6+3 = 11$.","$\\sum f = 6$.","Mean $= 11/6 \\approx 1.83$."],"answer":"$\\approx 1.83$"},{"type":"callout","variant":"warning","content":"For grouped data use class midpoints (Statistics II); Form 2 tables are usually ungrouped values."},{"type":"question","questionText":"Median of 4,7,9,12?","questionType":"multiple_choice","options":["$8$","$7$","$9$","$32$"],"correctAnswer":"$8$","explanation":"$(7+9)/2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mean from Frequency Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Averages — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Mean, Median, Mode"},{"type":"example","title":"Test marks: 6,8,8,10,12. Find all three averages.","steps":["Mean $44/5=8.8$.","Median $8$.","Mode $8$."],"answer":"Mean $8.8$, median & mode $8$"},{"type":"callout","variant":"warning","content":"Even count: median is mean of two middle values."},{"type":"question","questionText":"Which average uses all values?","questionType":"multiple_choice","options":["Mean","Mode only","Median only","Range"],"correctAnswer":"Mean","explanation":"Uses every data point."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i' AND st.code = 'mean_median_mode'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Averages — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Primary data is?', 'multiple_choice', '["Collected firsthand", "From textbooks only", "Always biased", "Only continuous"]'::jsonb, '"Collected firsthand"'::jsonb, 'easy', 'You gather it.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Primary data is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Goals in a match are?', 'multiple_choice', '["Discrete", "Continuous", "Secondary", "Qualitative"]'::jsonb, '"Discrete"'::jsonb, 'easy', 'Whole number count.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Goals in a match are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Height measured to 0.1 cm is?', 'multiple_choice', '["Continuous", "Discrete", "Mode", "Census"]'::jsonb, '"Continuous"'::jsonb, 'easy', 'Can take any value in range.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Height measured to 0.1 cm is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Random sample reduces?', 'multiple_choice', '["Bias", "Data size to zero", "Mean always", "Mode"]'::jsonb, '"Bias"'::jsonb, 'easy', 'Fair representation.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Random sample reduces?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Secondary data comes from?', 'multiple_choice', '["Existing sources", "New experiment only", "Tally only", "Mode calculation"]'::jsonb, '"Existing sources"'::jsonb, 'easy', 'Already published/collected.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Secondary data comes from?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Population in statistics means?', 'multiple_choice', '["Whole group studied", "Country only", "Sample size", "Frequency"]'::jsonb, '"Whole group studied"'::jsonb, 'easy', 'All members of interest.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Population in statistics means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Qualitative data describes?', 'multiple_choice', '["Categories/qualities", "Always numbers only", "Only mean", "Only range"]'::jsonb, '"Categories/qualities"'::jsonb, 'easy', 'Non-numeric attributes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='data_collection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Qualitative data describes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Total frequency equals?', 'multiple_choice', '["Sum of all class frequencies", "Largest frequency", "Class width", "Mean"]'::jsonb, '"Sum of all class frequencies"'::jsonb, 'medium', 'Add all $f$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Total frequency equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tally |||| means frequency?', 'multiple_choice', '["$5$", "$4$", "$6$", "$10$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Standard tally group.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tally |||| means frequency?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Modal class has?', 'multiple_choice', '["Highest frequency", "Lowest frequency", "Zero frequency", "Widest interval only"]'::jsonb, '"Highest frequency"'::jsonb, 'medium', 'Most common group.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Modal class has?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Data 1,1,2,3,3,3. Mode?', 'multiple_choice', '["$3$", "$1$", "$2$", "$3.5$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Appears three times.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Data 1,1,2,3,3,3. Mode?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class $15$–$24$ midpoint?', 'multiple_choice', '["$19.5$", "$15$", "$24$", "$9$"]'::jsonb, '"$19.5$"'::jsonb, 'medium', '$(15+24)/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class $15$–$24$ midpoint?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Freq 3 for score 8 means?', 'multiple_choice', '["Score 8 occurred 3 times", "Score is 3", "Total is 8", "Mean is 3"]'::jsonb, '"Score 8 occurred 3 times"'::jsonb, 'medium', 'Frequency counts repeats.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Freq 3 for score 8 means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cumulative frequency last value equals?', 'multiple_choice', '["Total frequency", "Mode", "Class width", "Median always"]'::jsonb, '"Total frequency"'::jsonb, 'medium', 'Sum of all data.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='frequency_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cumulative frequency last value equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean of 5,5,10?', 'multiple_choice', '["$\frac{20}{3}$", "$5$", "$10$", "$20$"]'::jsonb, '"$\frac{20}{3}$"'::jsonb, 'medium', '$20/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean of 5,5,10?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Median of 3,5,7,9,11?', 'multiple_choice', '["$7$", "$5$", "$9$", "$35$"]'::jsonb, '"$7$"'::jsonb, 'hard', 'Middle of ordered list.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Median of 3,5,7,9,11?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x$:2,3 freq:4,6. Mean?', 'multiple_choice', '["$2.6$", "$2.5$", "$3$", "$5$"]'::jsonb, '"$2.6$"'::jsonb, 'hard', '$(8+18)/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x$:2,3 freq:4,6. Mean?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Marks 12,15,15,18,20. Mode?', 'multiple_choice', '["$15$", "$12$", "$16$", "$18$"]'::jsonb, '"$15$"'::jsonb, 'hard', 'Most frequent.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Marks 12,15,15,18,20. Mode?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mean of 4,6,8,10?', 'multiple_choice', '["$7$", "$6$", "$8$", "$28$"]'::jsonb, '"$7$"'::jsonb, 'hard', '$28/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mean of 4,6,8,10?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Range of 5,9,12,20?', 'multiple_choice', '["$15$", "$12$", "$20$", "$5$"]'::jsonb, '"$15$"'::jsonb, 'hard', '$20-5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Range of 5,9,12,20?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is affected most by outlier?', 'multiple_choice', '["Mean", "Mode", "Median", "Frequency"]'::jsonb, '"Mean"'::jsonb, 'hard', 'Pulls mean toward extreme.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_median_mode'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is affected most by outlier?');
