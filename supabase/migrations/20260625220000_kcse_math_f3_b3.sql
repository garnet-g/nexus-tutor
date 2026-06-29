-- KCSE Form 3 Mathematics — Wave 3 Batch 3 (FINAL)
-- Topics: vectors_ii, binomial_expansion, probability, compound_proportions_rates_work, graphical_methods
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== VECTORS II ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Position Vectors from the Origin', '{"blocks":[{"type":"heading","content":"Position Vectors"},{"type":"paragraph","content":"A **position vector** gives the location of a point relative to the **origin** $O$. If $A$ has coordinates $(x, y)$, its position vector is $\\mathbf{a} = \\begin{pmatrix} x \\\\ y \\end{pmatrix}$ or $\\mathbf{a} = xi + yj$."},{"type":"math_block","latex":"|\\mathbf{a}| = \\sqrt{x^2 + y^2}","caption":"Magnitude of a position vector"},{"type":"callout","variant":"key_point","content":"Position vectors always start at $O$. The vector $\\overrightarrow{AB}$ is **not** a position vector unless $A$ is the origin."},{"type":"example","title":"Point $P(3, 4)$. Find $|\\mathbf{p}|$.","steps":["$|\\mathbf{p}| = \\sqrt{3^2 + 4^2} = \\sqrt{25} = 5$."],"answer":"$5$ units"},{"type":"question","questionText":"Position vector of $(-2, 5)$ has $x$-component?","questionType":"multiple_choice","options":["$-2$","$5$","$\\sqrt{29}$","$3$"],"correctAnswer":"$-2$","explanation":"First component is $x$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'position_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Position Vectors from the Origin');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Vector Between Two Points', '{"blocks":[{"type":"heading","content":"Displacement Vectors"},{"type":"math_block","latex":"\\overrightarrow{AB} = \\mathbf{b} - \\mathbf{a}","caption":"Vector from $A$ to $B$ using position vectors"},{"type":"example","title":"$A(1, 2)$, $B(5, 8)$. Find $\\overrightarrow{AB}$.","steps":["$\\mathbf{a} = \\begin{pmatrix} 1 \\\\ 2 \\end{pmatrix}$, $\\mathbf{b} = \\begin{pmatrix} 5 \\\\ 8 \\end{pmatrix}$.","$\\overrightarrow{AB} = \\mathbf{b} - \\mathbf{a} = \\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$"},{"type":"callout","variant":"warning","content":"Order matters: $\\overrightarrow{AB} = \\mathbf{b} - \\mathbf{a}$, not $\\mathbf{a} - \\mathbf{b}$."},{"type":"example","title":"$M$ is midpoint of $AB$ where $A(2, -4)$, $B(8, 6)$. Position vector of $M$?","steps":["$\\mathbf{m} = \\frac{1}{2}(\\mathbf{a} + \\mathbf{b}) = \\frac{1}{2}\\begin{pmatrix} 10 \\\\ 2 \\end{pmatrix} = \\begin{pmatrix} 5 \\\\ 1 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 5 \\\\ 1 \\end{pmatrix}$"},{"type":"question","questionText":"$\\overrightarrow{BA}$ equals?","questionType":"multiple_choice","options":["$\\mathbf{a} - \\mathbf{b}$","$\\mathbf{b} - \\mathbf{a}$","$\\mathbf{a} + \\mathbf{b}$","$-\\mathbf{a}$"],"correctAnswer":"$\\mathbf{a} - \\mathbf{b}$","explanation":"Reverse direction swaps subtraction order."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'position_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Vector Between Two Points');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Position Vectors — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Position Vectors"},{"type":"example","title":"$OABC$ is parallelogram with $\\mathbf{a} = \\begin{pmatrix} 2 \\\\ 1 \\end{pmatrix}$, $\\mathbf{c} = \\begin{pmatrix} 3 \\\\ 5 \\end{pmatrix}$. Find $\\mathbf{b}$.","steps":["In parallelogram $OABC$, $\\mathbf{b} = \\mathbf{a} + \\mathbf{c}$.","$\\mathbf{b} = \\begin{pmatrix} 5 \\\\ 6 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 5 \\\\ 6 \\end{pmatrix}$"},{"type":"callout","variant":"warning","content":"Draw a quick sketch — opposite sides of a parallelogram are equal and parallel."},{"type":"question","questionText":"$P(6, 8)$. $|\\mathbf{p}|$?","questionType":"multiple_choice","options":["$10$","$14$","$2$","$\\sqrt{14}$"],"correctAnswer":"$10$","explanation":"$6^2 + 8^2 = 100$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'position_vectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Position Vectors — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Position vector gives position relative to?', 'multiple_choice', '["Origin","Any point","Midpoint only","Unit vector"]'::jsonb, '"Origin"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Position vector gives position relative to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$Q(-3, 4)$. Magnitude of $\mathbf{q}$?', 'multiple_choice', '["$5$","$7$","$1$","$\\sqrt{7}$"]'::jsonb, '"$5$"'::jsonb, 'easy', '$\sqrt{9+16}=5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$Q(-3, 4)$. Magnitude of $\mathbf{q}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(1, 3)$, $B(4, 7)$. $\overrightarrow{AB}$?', 'multiple_choice', '["$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 10 \\end{pmatrix}$","$\\begin{pmatrix} -3 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 7 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'medium', '$\mathbf{b}-\mathbf{a}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(1, 3)$, $B(4, 7)$. $\overrightarrow{AB}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Midpoint of $A(0, 6)$ and $B(8, 2)$ has position vector?', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 8 \\\\ 8 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} 0 \\\\ 4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'medium', 'Average of coordinates.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Midpoint of $A(0, 6)$ and $B(8, 2)$ has position vector?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$R$ divides $PQ$ internally in ratio $1:2$ where $P(2,1)$, $Q(8, 10)$. $\mathbf{r}$?', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} 5 \\\\ 7 \\end{pmatrix}$","$\\begin{pmatrix} 6 \\\\ 8 \\end{pmatrix}$","$\\begin{pmatrix} 3 \\\\ 3 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ 4 \\end{pmatrix}$"'::jsonb, 'medium', '$\mathbf{r}=\frac{2\mathbf{p}+\mathbf{q}}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$R$ divides $PQ$ internally in ratio $1:2$ where $P(2,1)$, $Q(8, 10)$. $\mathbf{r}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$|\mathbf{v}|=13$, $v_x=5$. Possible $v_y$?', 'multiple_choice', '["$\\pm 12$","$\\pm 8$","$8$ only","$18$"]'::jsonb, '"$\\pm 12$"'::jsonb, 'hard', '$5^2+y^2=169$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$|\mathbf{v}|=13$, $v_x=5$. Possible $v_y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram $OABC$: $\mathbf{a}=(3,-2)$, $\mathbf{b}=(7,4)$. Find $\overrightarrow{AC}$.', 'multiple_choice', '["$\\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$","$\\begin{pmatrix} 10 \\\\ 2 \\end{pmatrix}$","$\\begin{pmatrix} -4 \\\\ -6 \\end{pmatrix}$","$\\begin{pmatrix} 7 \\\\ 4 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 4 \\\\ 6 \\end{pmatrix}$"'::jsonb, 'hard', '$\overrightarrow{AC}=\mathbf{c}=\mathbf{b}-\mathbf{a}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_vectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram $OABC$: $\mathbf{a}=(3,-2)$, $\mathbf{b}=(7,4)$. Find $\overrightarrow{AC}$.');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Dividing a Line in a Given Ratio', '{"blocks":[{"type":"heading","content":"Ratio Theorem"},{"type":"paragraph","content":"If point $P$ divides line $AB$ **internally** in ratio $m:n$, then $\\overrightarrow{OP} = \\frac{n\\mathbf{a} + m\\mathbf{b}}{m+n}$."},{"type":"math_block","latex":"\\mathbf{p} = \\frac{n\\mathbf{a} + m\\mathbf{b}}{m+n}","caption":"Internal division in ratio $m:n$ from $A$ to $B$"},{"type":"callout","variant":"key_point","content":"Ratio $m:n$ means $AP:PB = m:n$. The weight on $\\mathbf{b}$ is $m$."},{"type":"question","questionText":"Ratio $2:3$ from $A$ to $B$ means $AP:PB$ is?","questionType":"multiple_choice","options":["$2:3$","$3:2$","$1:5$","$5:1$"],"correctAnswer":"$2:3$","explanation":"Order matches segment from $A$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'ratio_theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Dividing a Line in a Given Ratio');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applying the Ratio Theorem', '{"blocks":[{"type":"heading","content":"Worked Ratio Problems"},{"type":"example","title":"$A(2, 1)$, $B(14, 7)$. $P$ divides $AB$ in ratio $1:2$. Find $P$.","steps":["$\\mathbf{p} = \\frac{2\\mathbf{a} + \\mathbf{b}}{3}$.","$\\mathbf{p} = \\frac{1}{3}\\begin{pmatrix} 4+14 \\\\ 2+7 \\end{pmatrix} = \\begin{pmatrix} 6 \\\\ 3 \\end{pmatrix}$."],"answer":"$P(6, 3)$"},{"type":"callout","variant":"warning","content":"External division uses a different formula — KCSE Form 3 focuses on **internal** division."},{"type":"example","title":"Find ratio if $A(0,0)$, $B(9,6)$ and $P(3,2)$ lies on $AB$.","steps":["$AP:PB = 3:6 = 1:2$."],"answer":"Ratio $1:2$"},{"type":"question","questionText":"Midpoint corresponds to ratio?","questionType":"multiple_choice","options":["$1:1$","$2:1$","$1:2$","$0:1$"],"correctAnswer":"$1:1$","explanation":"Equal division."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'ratio_theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applying the Ratio Theorem');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Ratio Theorem — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Ratio Theorem"},{"type":"example","title":"$A(-2, 4)$, $B(10, -2)$. $P$ divides $AB$ in ratio $2:1$. Coordinates of $P$?","steps":["$\\mathbf{p} = \\frac{1\\mathbf{a} + 2\\mathbf{b}}{3}$.","$\\mathbf{p} = \\begin{pmatrix} 6 \\\\ 0 \\end{pmatrix}$."],"answer":"$P(6, 0)$"},{"type":"callout","variant":"warning","content":"Label the ratio from the **first** named point ($A$) to the second ($B$)."},{"type":"question","questionText":"In ratio $3:1$, weight on $\\mathbf{b}$ is?","questionType":"multiple_choice","options":["$3$","$1$","$4$","$2$"],"correctAnswer":"$3$","explanation":"First part of ratio attaches to $A$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'ratio_theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Ratio Theorem — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ratio theorem finds?', 'multiple_choice', '["Point dividing a segment","Area of triangle","Angle between vectors","Determinant"]'::jsonb, '"Point dividing a segment"'::jsonb, 'easy', 'Division point.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ratio theorem finds?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Internal ratio $1:3$ means total parts?', 'multiple_choice', '["$4$","$3$","$2$","$1$"]'::jsonb, '"$4$"'::jsonb, 'easy', '$m+n$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Internal ratio $1:3$ means total parts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(0,0)$, $B(12, 8)$, ratio $2:2$. Point $P$?', 'multiple_choice', '["$(6, 4)$","$(4, 8)$","$(8, 4)$","$(12, 8)$"]'::jsonb, '"$(6, 4)$"'::jsonb, 'medium', 'Midpoint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(0,0)$, $B(12, 8)$, ratio $2:2$. Point $P$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(1,5)$, $B(7, -1)$, ratio $1:2$. $P$?', 'multiple_choice', '["$(3, 3)$","$(5, 1)$","$(4, 2)$","$(2, 4)$"]'::jsonb, '"$(3, 3)$"'::jsonb, 'easy', 'Weighted average.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(1,5)$, $B(7, -1)$, ratio $1:2$. $P$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P$ on $AB$ with $AP:PB=3:1$. $A(2,6)$, $P(5,3)$. Find $B$.', 'multiple_choice', '["$(6, 1)$","$(8, 0)$","$(4, 4)$","$(3, 2)$"]'::jsonb, '"$(6, 1)$"'::jsonb, 'hard', 'Use $\mathbf{b}=4\mathbf{p}-3\mathbf{a}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P$ on $AB$ with $AP:PB=3:1$. $A(2,6)$, $P(5,3)$. Find $B$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(-4, 2)$, $B(8, 14)$, ratio $3:1$. $P$?', 'multiple_choice', '["$(5, 11)$","$(2, 5)$","$(8, 14)$","$(0, 0)$"]'::jsonb, '"$(5, 11)$"'::jsonb, 'hard', '$\mathbf{p}=\frac{\mathbf{a}+3\mathbf{b}}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(-4, 2)$, $B(8, 14)$, ratio $3:1$. $P$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P$ divides $AB$ in ratio $2:3$. If $\mathbf{p}=\frac{3\mathbf{a}+2\mathbf{b}}{5}$, ratio $AP:PB$ is?', 'multiple_choice', '["$2:3$","$3:2$","$1:1$","$5:2$"]'::jsonb, '"$2:3$"'::jsonb, 'hard', 'Match coefficients to formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P$ divides $AB$ in ratio $2:3$. If $\mathbf{p}=\frac{3\mathbf{a}+2\mathbf{b}}{5}$, ratio $AP:PB$ is?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Parallel and Collinear Vectors', '{"blocks":[{"type":"heading","content":"Vector Geometry"},{"type":"paragraph","content":"Vectors $\\mathbf{a}$ and $\\mathbf{b}$ are **parallel** if $\\mathbf{b} = k\\mathbf{a}$ for some scalar $k$. Three points $A$, $B$, $C$ are **collinear** if $\\overrightarrow{AB}$ and $\\overrightarrow{AC}$ are parallel."},{"type":"callout","variant":"key_point","content":"To prove collinearity, show one vector is a scalar multiple of another."},{"type":"example","title":"Are $A(1,2)$, $B(3,6)$, $C(5,10)$ collinear?","steps":["$\\overrightarrow{AB} = \\begin{pmatrix} 2 \\\\ 4 \\end{pmatrix}$, $\\overrightarrow{AC} = \\begin{pmatrix} 4 \\\\ 8 \\end{pmatrix}$.","$\\overrightarrow{AC} = 2\\overrightarrow{AB}$ — collinear."],"answer":"Yes, collinear"},{"type":"question","questionText":"Parallel vectors have same?","questionType":"multiple_choice","options":["Direction (or opposite)","Magnitude always","Starting point","Unit length"],"correctAnswer":"Direction (or opposite)","explanation":"Scalar multiple."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'vector_geometry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Parallel and Collinear Vectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Geometric Proofs with Vectors', '{"blocks":[{"type":"heading","content":"Proving Properties"},{"type":"example","title":"Show diagonals of parallelogram $OABC$ bisect each other.","steps":["Let $M$ be midpoint of $OB$: $\\mathbf{m} = \\frac{\\mathbf{o}+\\mathbf{b}}{2} = \\frac{\\mathbf{b}}{2}$.","Midpoint of $AC$: $\\frac{\\mathbf{a}+\\mathbf{c}}{2} = \\frac{\\mathbf{a}+(\\mathbf{a}+\\mathbf{b})}{2} = \\mathbf{a}+\\frac{\\mathbf{b}}{2}$ — not same unless...","Use $\\mathbf{c}=\\mathbf{a}+\\mathbf{b}$: midpoint $AC$ is $\\frac{\\mathbf{a}+\\mathbf{a}+\\mathbf{b}}{2}=\\mathbf{a}+\\frac{\\mathbf{b}}{2}$."],"answer":"Midpoints coincide — diagonals bisect"},{"type":"callout","variant":"warning","content":"Express all points in terms of two independent vectors (e.g. $\\mathbf{a}$ and $\\mathbf{b}$)."},{"type":"question","questionText":"$\\mathbf{b} = 3\\mathbf{a}$ means vectors are?","questionType":"multiple_choice","options":["Parallel","Perpendicular","Equal","Unit"],"correctAnswer":"Parallel","explanation":"Scalar multiple."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'vector_geometry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Geometric Proofs with Vectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Vector Geometry — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Vector Geometry"},{"type":"example","title":"$M$ is midpoint of $BC$ in triangle $ABC$. Show $\\overrightarrow{AM} = \\frac{1}{2}(\\overrightarrow{AB}+\\overrightarrow{AC})$.","steps":["$\\mathbf{m} = \\frac{\\mathbf{b}+\\mathbf{c}}{2}$.","$\\overrightarrow{AM} = \\mathbf{m}-\\mathbf{a} = \\frac{\\mathbf{b}+\\mathbf{c}-2\\mathbf{a}}{2}$ — rearrange from position vectors from $A$."],"answer":"Medians formula derived"},{"type":"callout","variant":"warning","content":"KCSE vector proofs reward clear vector expressions and scalar-multiple arguments."},{"type":"question","questionText":"Collinear points lie on?","questionType":"multiple_choice","options":["Same straight line","Parallel lines","Circle","Perpendicular lines"],"correctAnswer":"Same straight line","explanation":"Definition."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii' AND st.code = 'vector_geometry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Vector Geometry — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{v}=(2,-4)$. Parallel vector?', 'multiple_choice', '["$\\begin{pmatrix} 1 \\\\ -2 \\end{pmatrix}$","$\\begin{pmatrix} 2 \\\\ 4 \\end{pmatrix}$","$\\begin{pmatrix} -2 \\\\ -4 \\end{pmatrix}$","$\\begin{pmatrix} 4 \\\\ 2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 1 \\\\ -2 \\end{pmatrix}$"'::jsonb, 'easy', 'Scalar multiple $1/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{v}=(2,-4)$. Parallel vector?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Collinear points $A$, $B$, $C$ satisfy?', 'multiple_choice', '["$\\overrightarrow{AB}=k\\overrightarrow{AC}$","$\\mathbf{a}=\\mathbf{b}+\\mathbf{c}$","$|\\mathbf{a}|=|\\mathbf{b}|$","$\\mathbf{a}\\cdot\\mathbf{b}=0$"]'::jsonb, '"$\\overrightarrow{AB}=k\\overrightarrow{AC}$"'::jsonb, 'easy', 'Parallel displacement vectors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Collinear points $A$, $B$, $C$ satisfy?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(0,0)$, $B(2,3)$, $C(6,9)$. Collinear?', 'multiple_choice', '["Yes","No","Only if $k=2$","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'medium', '$(6,9)=3(2,3)$ from origin.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(0,0)$, $B(2,3)$, $C(6,9)$. Collinear?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram test: $OABC$ with $\mathbf{c}=\mathbf{a}+\mathbf{b}$. $\overrightarrow{AB}$ equals?', 'multiple_choice', '["$\\mathbf{c}$","$\\mathbf{b}$","$\\mathbf{a}$","$\\mathbf{a}+\\mathbf{b}$"]'::jsonb, '"$\\mathbf{c}$"'::jsonb, 'medium', 'Opposite sides equal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram test: $OABC$ with $\mathbf{c}=\mathbf{a}+\mathbf{b}$. $\overrightarrow{AB}$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\mathbf{p}=2\mathbf{q}$. $|\mathbf{p}|=10$. $|\mathbf{q}|$?', 'multiple_choice', '["$5$","$20$","$8$","$2$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Magnitude scales by $|k|$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\mathbf{p}=2\mathbf{q}$. $|\mathbf{p}|=10$. $|\mathbf{q}|$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A(1,1)$, $B(4,4)$, $C(7,k)$ collinear. $k$?', 'multiple_choice', '["$7$","$4$","$10$","$1$"]'::jsonb, '"$7$"'::jsonb, 'hard', 'Slope $1$ throughout.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A(1,1)$, $B(4,4)$, $C(7,k)$ collinear. $k$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rhombus $OABC$: show $\overrightarrow{OB}$ bisects angle $AOC$. Uses?', 'multiple_choice', '["Equal sides give equal vector magnitudes","Pythagoras only","Ratio theorem only","Binomial expansion"]'::jsonb, '"Equal sides give equal vector magnitudes"'::jsonb, 'hard', 'Symmetry of equal sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='vector_geometry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='vectors_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rhombus $OABC$: show $\overrightarrow{OB}$ bisects angle $AOC$. Uses?');

