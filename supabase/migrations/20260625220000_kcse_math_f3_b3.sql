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

-- ========== BINOMIAL EXPANSION ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Building Pascal''s Triangle', '{"blocks":[{"type":"heading","content":"Pascal''s Triangle"},{"type":"paragraph","content":"**Pascal''s triangle** lists binomial coefficients. Row $0$ is $1$; each edge is $1$; each interior entry is the **sum of the two above**."},{"type":"callout","variant":"key_point","content":"Row $n$ gives coefficients of $(a+b)^n$ from $a^n$ to $b^n$."},{"type":"example","title":"Row $4$ of Pascal''s triangle?","steps":["$1, 4, 6, 4, 1$."],"answer":"$1, 4, 6, 4, 1$"},{"type":"question","questionText":"Row $3$ begins with?","questionType":"multiple_choice","options":["$1, 3, 3, 1$","$1, 2, 1$","$1, 4, 6, 4, 1$","$1, 1$"],"correctAnswer":"$1, 3, 3, 1$","explanation":"Third row (starting row 0)."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'pascals_triangle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Building Pascal''s Triangle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Coefficients from the Triangle', '{"blocks":[{"type":"heading","content":"Coefficients and Rows"},{"type":"math_block","latex":"(a+b)^n = \\sum_{r=0}^{n} \\binom{n}{r} a^{n-r} b^r","caption":"Binomial theorem"},{"type":"example","title":"Use row $5$ to write first three terms of $(a+b)^5$.","steps":["Coeffs: $1, 5, 10, 10, 5, 1$.","Terms: $a^5 + 5a^4b + 10a^3b^2 + \\ldots$"],"answer":"$a^5 + 5a^4b + 10a^3b^2$"},{"type":"callout","variant":"warning","content":"Count rows from $0$ at the top — row $n$ has $n+1$ entries."},{"type":"question","questionText":"Middle coefficient of row $6$?","questionType":"multiple_choice","options":["$20$","$15$","$6$","$1$"],"correctAnswer":"$20$","explanation":"Row $6$: $1,6,15,20,15,6,1$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'pascals_triangle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Coefficients from the Triangle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pascal''s Triangle — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Pascal''s Triangle"},{"type":"example","title":"Coefficient of $a^2b^3$ in $(a+b)^5$?","steps":["$\\binom{5}{3}=10$ (or read row $5$)."],"answer":"$10$"},{"type":"callout","variant":"warning","content":"Powers must sum to $n$: $2+3=5$."},{"type":"question","questionText":"Sum of row $4$ coefficients?","questionType":"multiple_choice","options":["$16$","$8$","$10$","$32$"],"correctAnswer":"$16$","explanation":"$2^4=16$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'pascals_triangle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pascal''s Triangle — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Each Pascal entry (not on edge) equals?', 'multiple_choice', '["Sum of two above","Product of above","Double above","Half above"]'::jsonb, '"Sum of two above"'::jsonb, 'easy', 'Construction rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Each Pascal entry (not on edge) equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Row $2$ is?', 'multiple_choice', '["$1,2,1$","$1,1$","$1,3,3,1$","$1,4,6,4,1$"]'::jsonb, '"$1,2,1$"'::jsonb, 'easy', 'Third row.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Row $2$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coefficient of $b^3$ in $(a+b)^4$?', 'multiple_choice', '["$4$","$6$","$1$","$3$"]'::jsonb, '"$4$"'::jsonb, 'medium', 'Row $4$: $\binom{4}{3}=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coefficient of $b^3$ in $(a+b)^4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Row $5$ fourth entry (from left)?', 'multiple_choice', '["$10$","$5$","$15$","$20$"]'::jsonb, '"$10$"'::jsonb, 'easy', '$1,5,10,10,5,1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Row $5$ fourth entry (from left)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sum of coefficients in $(a+b)^6$?', 'multiple_choice', '["$64$","$36$","$32$","$128$"]'::jsonb, '"$64$"'::jsonb, 'medium', 'Set $a=b=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sum of coefficients in $(a+b)^6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coefficient of $a^4b^2$ in $(a+b)^6$?', 'multiple_choice', '["$15$","$20$","$6$","$12$"]'::jsonb, '"$15$"'::jsonb, 'hard', '$\binom{6}{2}=15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coefficient of $a^4b^2$ in $(a+b)^6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Row $7$ has how many entries?', 'multiple_choice', '["$8$","$7$","$6$","$9$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$n+1$ entries in row $n$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pascals_triangle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Row $7$ has how many entries?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding $(a+b)^n$', '{"blocks":[{"type":"heading","content":"Binomial Expansion"},{"type":"paragraph","content":"Expand $(a+b)^n$ using coefficients from row $n$ of Pascal''s triangle. Powers of $a$ decrease while powers of $b$ increase."},{"type":"example","title":"Expand $(x+2)^3$.","steps":["Coeffs $1,3,3,1$: $(x+2)^3 = x^3 + 3x^2(2) + 3x(4) + 8$.","$= x^3 + 6x^2 + 12x + 8$."],"answer":"$x^3 + 6x^2 + 12x + 8$"},{"type":"question","questionText":"$(a+b)^2$ expands to?","questionType":"multiple_choice","options":["$a^2+2ab+b^2$","$a^2+b^2$","$a^2+ab+b^2$","$2a^2+2b^2$"],"correctAnswer":"$a^2+2ab+b^2$","explanation":"Row $2$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'expansion_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding $(a+b)^n$');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expansions with Negative Terms', '{"blocks":[{"type":"heading","content":"$(a-b)^n$ and Signs"},{"type":"example","title":"Expand $(x-1)^4$.","steps":["$x^4 - 4x^3 + 6x^2 - 4x + 1$.","Signs alternate when second term is negative."],"answer":"$x^4 - 4x^3 + 6x^2 - 4x + 1$"},{"type":"callout","variant":"warning","content":"Track signs carefully: $(-b)^r$ alternates $+,-,+,-,\\ldots$"},{"type":"example","title":"Expand $(2x+3)^2$.","steps":["$4x^2 + 12x + 9$."],"answer":"$4x^2 + 12x + 9$"},{"type":"question","questionText":"Constant term of $(x-2)^3$?","questionType":"multiple_choice","options":["$-8$","$8$","$-6$","$6$"],"correctAnswer":"$-8$","explanation":"$(-2)^3$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'expansion_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expansions with Negative Terms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Binomial Expansion — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Expansion"},{"type":"example","title":"First three terms of $(1+2x)^5$.","steps":["$1 + 5(2x) + 10(2x)^2 = 1 + 10x + 40x^2$."],"answer":"$1 + 10x + 40x^2$"},{"type":"callout","variant":"warning","content":"When $a$ is not $1$, powers of $a$ still appear in each term."},{"type":"question","questionText":"Coefficient of $x^2$ in $(x+3)^3$?","questionType":"multiple_choice","options":["$27$","$9$","$3$","$18$"],"correctAnswer":"$27$","explanation":"$3 \\cdot x^2 \\cdot 9$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'expansion_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Binomial Expansion — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x+1)^3$ constant term?', 'multiple_choice', '["$1$","$3$","$0$","$6$"]'::jsonb, '"$1$"'::jsonb, 'easy', '$1^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x+1)^3$ constant term?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(a+b)^1$?', 'multiple_choice', '["$a+b$","$a^2+b^2$","$1$","$ab$"]'::jsonb, '"$a+b$"'::jsonb, 'easy', 'Row $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(a+b)^1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x-3)^2$?', 'multiple_choice', '["$x^2-6x+9$","$x^2+6x+9$","$x^2-9$","$x^2+9$"]'::jsonb, '"$x^2-6x+9$"'::jsonb, 'medium', 'Perfect square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x-3)^2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coefficient of $x^3$ in $(2+x)^4$?', 'multiple_choice', '["$32$","$8$","$16$","$6$"]'::jsonb, '"$32$"'::jsonb, 'medium', '$\binom{4}{1}2^3=32$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coefficient of $x^3$ in $(2+x)^4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1-x)^5$ coefficient of $x^2$?', 'multiple_choice', '["$10$","$-10$","$5$","$-5$"]'::jsonb, '"$10$"'::jsonb, 'medium', '$\binom{5}{2}=10$; sign positive for $r=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1-x)^5$ coefficient of $x^2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Term independent of $x$ in $(x+\frac{1}{x})^4$?', 'multiple_choice', '["$6$","$4$","$1$","$0$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Middle terms $x^0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Term independent of $x$ in $(x+\frac{1}{x})^4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(3-2x)^3$ coefficient of $x^2$?', 'multiple_choice', '["$36$","$-36$","$54$","$-54$"]'::jsonb, '"$-36$"'::jsonb, 'hard', '$3 \cdot 3 \cdot (-2)^2 \cdot 3 = -36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(3-2x)^3$ coefficient of $x^2$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Approximating with $(1+x)^n$', '{"blocks":[{"type":"heading","content":"Binomial Approximations"},{"type":"paragraph","content":"For **small** $x$, $(1+x)^n \\approx 1 + nx$ using the first two terms. More terms give better accuracy."},{"type":"math_block","latex":"(1+x)^n \\approx 1 + nx \\quad (|x| \\ll 1)","caption":"Linear approximation"},{"type":"example","title":"Approximate $(1.02)^5$.","steps":["$(1+0.02)^5 \\approx 1 + 5(0.02) = 1.10$."],"answer":"$1.10$"},{"type":"question","questionText":"Approximation valid when $x$ is?","questionType":"multiple_choice","options":["Small","Large","Negative only","Any value"],"correctAnswer":"Small","explanation":"First-term expansion."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'approximations_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Approximating with $(1+x)^n$');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using More Terms for Accuracy', '{"blocks":[{"type":"heading","content":"Second-Order Approximation"},{"type":"math_block","latex":"(1+x)^n \\approx 1 + nx + \\frac{n(n-1)}{2}x^2","caption":"Up to $x^2$"},{"type":"example","title":"Approximate $\\sqrt{1.04}$ using $(1+x)^{1/2}$, $x=0.04$.","steps":["$\\approx 1 + \\frac{1}{2}(0.04) = 1.02$."],"answer":"$1.02$"},{"type":"callout","variant":"warning","content":"Fractional $n$ still works — coefficients use $\\binom{n}{r}$ with formula."},{"type":"question","questionText":"$(0.99)^4 \\approx$ using $1-4(0.01)$?","questionType":"multiple_choice","options":["$0.96$","$0.99$","$1.04$","$0.94$"],"correctAnswer":"$0.96$","explanation":"$(1-0.01)^4 \\approx 1-0.04$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'approximations_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using More Terms for Accuracy');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Approximations — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Approximations"},{"type":"example","title":"Estimate $(1.01)^{10}$.","steps":["$\\approx 1 + 10(0.01) = 1.10$."],"answer":"$1.10$"},{"type":"callout","variant":"warning","content":"State that the answer is an **approximation** in exam working."},{"type":"question","questionText":"$(1.005)^3 \\approx$?","questionType":"multiple_choice","options":["$1.015$","$1.005$","$1.05$","$1.5$"],"correctAnswer":"$1.015$","explanation":"$1+3(0.005)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion' AND st.code = 'approximations_binomial'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Approximations — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1+x)^n \approx 1+nx$ when $x$ is?', 'multiple_choice', '["Small","Equal to 1","Large negative only","Zero only"]'::jsonb, '"Small"'::jsonb, 'easy', 'Linear approx.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1+x)^n \approx 1+nx$ when $x$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1.03)^2 \approx$?', 'multiple_choice', '["$1.06$","$1.03$","$1.09$","$1.30$"]'::jsonb, '"$1.06$"'::jsonb, 'easy', '$1+2(0.03)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1.03)^2 \approx$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(0.98)^3 \approx$?', 'multiple_choice', '["$0.94$","$0.98$","$1.02$","$0.96$"]'::jsonb, '"$0.94$"'::jsonb, 'medium', '$1-3(0.02)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(0.98)^3 \approx$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1.02)^4 \approx$ to 2 d.p.?', 'multiple_choice', '["$1.08$","$1.04$","$1.02$","$1.16$"]'::jsonb, '"$1.08$"'::jsonb, 'medium', '$1+4(0.02)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1.02)^4 \approx$ to 2 d.p.?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sqrt{0.96}$ using $(1-0.04)^{1/2}$?', 'multiple_choice', '["$0.98$","$0.96$","$1.02$","$0.94$"]'::jsonb, '"$0.98$"'::jsonb, 'hard', '$1-\frac{1}{2}(0.04)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sqrt{0.96}$ using $(1-0.04)^{1/2}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1.01)^{20} \approx$?', 'multiple_choice', '["$1.20$","$1.10$","$1.21$","$2.00$"]'::jsonb, '"$1.20$"'::jsonb, 'hard', '$1+20(0.01)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1.01)^{20} \approx$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Why add $x^2$ term?', 'multiple_choice', '["Better accuracy","Exact value always","Only for negatives","Not needed"]'::jsonb, '"Better accuracy"'::jsonb, 'hard', 'Second-order correction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='approximations_binomial'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='binomial_expansion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Why add $x^2$ term?');

-- ========== PROBABILITY ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sample Space and Simple Events', '{"blocks":[{"type":"heading","content":"Probability Basics (Probability I)"},{"type":"paragraph","content":"The **sample space** $S$ is the set of all possible outcomes. An **event** is a subset of $S$. A **simple event** has one outcome only."},{"type":"math_block","latex":"P(A) = \\frac{\\text{favourable outcomes}}{\\text{total equally likely outcomes}}","caption":"Theoretical probability"},{"type":"example","title":"Fair die rolled once. $P(\\text{even})$?","steps":["Even: $\\{2,4,6\\}$ — $3$ outcomes.","$P = \\frac{3}{6} = \\frac{1}{2}$."],"answer":"$\\frac{1}{2}$"},{"type":"question","questionText":"Sample space of one coin toss?","questionType":"multiple_choice","options":["$\\{H, T\\}$","$\\{H\\}$","$\\{T\\}$","$\\{HH, TT\\}$"],"correctAnswer":"$\\{H, T\\}$","explanation":"Two outcomes."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'experimental_theoretical'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sample Space and Simple Events');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Experimental vs Theoretical Probability', '{"blocks":[{"type":"heading","content":"Experimental Probability"},{"type":"paragraph","content":"**Experimental (relative frequency)** probability $= \\frac{\\text{times event occurred}}{\\text{total trials}}$. It approaches **theoretical** probability as trials increase (Probability I review + extension)."},{"type":"example","title":"Coin tossed $200$ times; heads $112$ times. Experimental $P(H)$?","steps":["$P(H) = \\frac{112}{200} = 0.56$."],"answer":"$0.56$"},{"type":"callout","variant":"warning","content":"Experimental results vary — theoretical $P(H)=0.5$ for a fair coin."},{"type":"example","title":"Bag: $40$ trials drawing a red ball $15$ times. Estimate $P(\\text{red})$.","steps":["$\\frac{15}{40} = 0.375$."],"answer":"$0.375$"},{"type":"question","questionText":"More trials generally make experimental probability?","questionType":"multiple_choice","options":["Closer to theoretical","Always exactly $0.5$","Always $1$","Unrelated"],"correctAnswer":"Closer to theoretical","explanation":"Law of large numbers idea."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'experimental_theoretical'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Experimental vs Theoretical Probability');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Probability I — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Sample Space & Probability"},{"type":"example","title":"Two coins tossed. List $S$ and find $P(\\text{at least one head})$.","steps":["$S=\\{HH,HT,TH,TT\\}$.","Favourable $3$.","$P=\\frac{3}{4}$."],"answer":"$\\frac{3}{4}$"},{"type":"callout","variant":"warning","content":"List the full sample space before counting — avoids missing outcomes."},{"type":"question","questionText":"Fair die: $P(\\text{prime})$?","questionType":"multiple_choice","options":["$\\frac{1}{2}$","$\\frac{1}{3}$","$\\frac{2}{3}$","$\\frac{1}{6}$"],"correctAnswer":"$\\frac{1}{2}$","explanation":"Primes $2,3,5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'experimental_theoretical'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Probability I — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sample space contains?', 'multiple_choice', '["All possible outcomes","Only winning outcomes","One outcome","Impossible events"]'::jsonb, '"All possible outcomes"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sample space contains?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Fair die: $P(4)$?', 'multiple_choice', '["$\\frac{1}{6}$","$\\frac{1}{4}$","$\\frac{1}{3}$","$\\frac{1}{2}$"]'::jsonb, '"$\\frac{1}{6}$"'::jsonb, 'easy', 'One of six.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Fair die: $P(4)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Spinner lands red $18$ of $60$ spins. Experimental $P(\text{red})$?', 'multiple_choice', '["$0.3$","$0.18$","$0.6$","$0.5$"]'::jsonb, '"$0.3$"'::jsonb, 'medium', '$18/60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Spinner lands red $18$ of $60$ spins. Experimental $P(\text{red})$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bag has $3$ red, $5$ blue balls. $P(\text{red})$ if one drawn?', 'multiple_choice', '["$\\frac{3}{8}$","$\\frac{5}{8}$","$\\frac{1}{3}$","$\\frac{3}{5}$"]'::jsonb, '"$\\frac{3}{8}$"'::jsonb, 'medium', 'Favourable over total.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bag has $3$ red, $5$ blue balls. $P(\text{red})$ if one drawn?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Letter from MATHEMATICS at random. $P(M)$?', 'multiple_choice', '["$\\frac{2}{11}$","$\\frac{1}{11}$","$\\frac{2}{9}$","$\\frac{1}{2}$"]'::jsonb, '"$\\frac{2}{11}$"'::jsonb, 'easy', 'Two M''s in 11 letters.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Letter from MATHEMATICS at random. $P(M)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Die rolled twice. $P(\text{sum } 7)$?', 'multiple_choice', '["$\\frac{1}{6}$","$\\frac{1}{12}$","$\\frac{7}{36}$","$\\frac{1}{36}$"]'::jsonb, '"$\\frac{1}{6}$"'::jsonb, 'hard', 'Six favourable of 36.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Die rolled twice. $P(\text{sum } 7)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Experimental $P$ after $10$ trials vs $1000$ trials — which is more reliable?', 'multiple_choice', '["$1000$ trials","$10$ trials","Same always","Neither"]'::jsonb, '"$1000$ trials"'::jsonb, 'hard', 'More data stabilises estimate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='experimental_theoretical'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Experimental $P$ after $10$ trials vs $1000$ trials — which is more reliable?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mutually Exclusive and Independent Events', '{"blocks":[{"type":"heading","content":"Combined Events (Probability II)"},{"type":"paragraph","content":"**Mutually exclusive** events cannot happen together: $P(A \\cup B) = P(A) + P(B)$. **Independent** events: outcome of one does not affect the other: $P(A \\cap B) = P(A) \\times P(B)$."},{"type":"callout","variant":"key_point","content":"OR rule for exclusive events; AND rule for independent events."},{"type":"question","questionText":"Toss coin and roll die — independent?","questionType":"multiple_choice","options":["Yes","No","Only if both heads","Only if die is 6"],"correctAnswer":"Yes","explanation":"No effect on each other."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'combined_events'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mutually Exclusive and Independent Events');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'AND / OR Rules', '{"blocks":[{"type":"heading","content":"Combining Probabilities"},{"type":"example","title":"Die: $P(2 \\text{ or } 5)$?","steps":["Exclusive: $\\frac{1}{6}+\\frac{1}{6}=\\frac{1}{3}$."],"answer":"$\\frac{1}{3}$"},{"type":"example","title":"Two coins: $P(\\text{both heads})$?","steps":["Independent: $\\frac{1}{2} \\times \\frac{1}{2} = \\frac{1}{4}$."],"answer":"$\\frac{1}{4}$"},{"type":"callout","variant":"warning","content":"Do not add for AND or multiply for OR unless conditions match."},{"type":"question","questionText":"$P(A)=0.3$, $P(B)=0.4$, independent. $P(A \\cap B)$?","questionType":"multiple_choice","options":["$0.12$","$0.7$","$0.1$","$1.2$"],"correctAnswer":"$0.12$","explanation":"Multiply."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'combined_events'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'AND / OR Rules');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Events — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Combined Events"},{"type":"example","title":"Bag: $4$ red, $6$ blue. Two draws **with replacement**. $P(\\text{both red})$?","steps":["$P = \\frac{4}{10} \\times \\frac{4}{10} = 0.16$."],"answer":"$0.16$"},{"type":"callout","variant":"warning","content":"With replacement keeps probabilities the same on second draw."},{"type":"question","questionText":"$P(\\text{not } A)$ if $P(A)=0.35$?","questionType":"multiple_choice","options":["$0.65$","$0.35$","$1.35$","$0$"],"correctAnswer":"$0.65$","explanation":"$1-P(A)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'combined_events'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Events — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mutually exclusive events can occur?', 'multiple_choice', '["Together never","Always together","Independently only","With probability 1"]'::jsonb, '"Together never"'::jsonb, 'easy', 'No overlap.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mutually exclusive events can occur?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Independent: $P(A\cap B)$ equals?', 'multiple_choice', '["$P(A)P(B)$","$P(A)+P(B)$","$P(A)-P(B)$","$1$"]'::jsonb, '"$P(A)P(B)$"'::jsonb, 'easy', 'AND rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Independent: $P(A\cap B)$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Die: $P(1 \text{ or } 6)$?', 'multiple_choice', '["$\\frac{1}{3}$","$\\frac{1}{6}$","$\\frac{1}{36}$","$\\frac{1}{2}$"]'::jsonb, '"$\\frac{1}{3}$"'::jsonb, 'medium', 'Add $\frac{1}{6}+\frac{1}{6}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Die: $P(1 \text{ or } 6)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two dice: $P(\text{both show } 3)$?', 'multiple_choice', '["$\\frac{1}{36}$","$\\frac{1}{6}$","$\\frac{1}{18}$","$\\frac{1}{12}$"]'::jsonb, '"$\\frac{1}{36}$"'::jsonb, 'medium', '$\frac{1}{6}\times\frac{1}{6}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two dice: $P(\text{both show } 3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P(A)=0.5$, $P(B)=0.2$ exclusive. $P(A \cup B)$?', 'multiple_choice', '["$0.7$","$0.1$","$0.3$","$1$"]'::jsonb, '"$0.7$"'::jsonb, 'hard', 'Add when exclusive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P(A)=0.5$, $P(B)=0.2$ exclusive. $P(A \cup B)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Card from pack: $P(\text{heart or king})$? (not exclusive)', 'multiple_choice', '["$\\frac{4}{13}$","$\\frac{1}{4}$","$\\frac{1}{13}$","$\\frac{17}{52}$"]'::jsonb, '"$\\frac{4}{13}$"'::jsonb, 'hard', '$\frac{13}{52}+\frac{4}{52}-\frac{1}{52}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Card from pack: $P(\text{heart or king})$? (not exclusive)');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three fair coins: $P(\text{at least one tail})$?', 'multiple_choice', '["$\\frac{7}{8}$","$\\frac{1}{8}$","$\\frac{1}{2}$","$\\frac{3}{4}$"]'::jsonb, '"$\\frac{7}{8}$"'::jsonb, 'hard', '$1-P(HHH)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined_events'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three fair coins: $P(\text{at least one tail})$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing Tree Diagrams', '{"blocks":[{"type":"heading","content":"Tree Diagrams"},{"type":"paragraph","content":"A **tree diagram** shows stages of combined events. Branches carry probabilities; **multiply along a path**, **add across paths** for final probabilities."},{"type":"callout","variant":"key_point","content":"Probabilities on branches from one node must sum to $1$."},{"type":"example","title":"Coin then die on tree — how many end branches?","steps":["Coin $2$ branches, each splits $6$ ways.","$12$ end branches."],"answer":"$12$"},{"type":"question","questionText":"Along one path on a tree, probabilities are?","questionType":"multiple_choice","options":["Multiplied","Added","Subtracted","Divided"],"correctAnswer":"Multiplied","explanation":"AND along path."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'tree_diagrams'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing Tree Diagrams');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tree Diagrams for Combined Events', '{"blocks":[{"type":"heading","content":"Two-Stage Problems"},{"type":"example","title":"Bag: $3$ green, $2$ red. Draw twice **without replacement**. Tree for $P(\\text{GG})$.","steps":["First $G$: $\\frac{3}{5}$.","Second $G$: $\\frac{2}{4}$.","$P(GG)=\\frac{3}{5}\\times\\frac{2}{4}=\\frac{3}{10}$."],"answer":"$\\frac{3}{10}$"},{"type":"callout","variant":"warning","content":"Without replacement — second branch probabilities change."},{"type":"question","questionText":"Two paths ending in same event type — combine by?","questionType":"multiple_choice","options":["Adding path probabilities","Multiplying only","Subtracting","Ignoring"],"correctAnswer":"Adding path probabilities","explanation":"OR across paths."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'tree_diagrams'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tree Diagrams for Combined Events');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tree Diagrams — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Tree Diagrams"},{"type":"example","title":"Spinner: $\\frac{1}{2}$ red, $\\frac{1}{2}$ blue. Two spins. $P(\\text{red then blue})$?","steps":["$\\frac{1}{2} \\times \\frac{1}{2} = \\frac{1}{4}$."],"answer":"$\\frac{1}{4}$"},{"type":"callout","variant":"warning","content":"Label each branch clearly — examiners award method marks for correct tree structure."},{"type":"question","questionText":"Best tool for two-stage probability with changing probabilities?","questionType":"multiple_choice","options":["Tree diagram","Pythagoras","Ratio theorem","Linear law graph"],"correctAnswer":"Tree diagram","explanation":"Visual combined events."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability' AND st.code = 'tree_diagrams'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tree Diagrams — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tree diagram branches from one node sum to?', 'multiple_choice', '["$1$","$0$","$2$","$0.5$"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Complete partition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tree diagram branches from one node sum to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Along a path, probabilities are?', 'multiple_choice', '["Multiplied","Added","Squared","Inverted"]'::jsonb, '"Multiplied"'::jsonb, 'easy', 'AND rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Along a path, probabilities are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coin twice: $P(HT)$?', 'multiple_choice', '["$\\frac{1}{4}$","$\\frac{1}{2}$","$\\frac{1}{8}$","$\\frac{3}{4}$"]'::jsonb, '"$\\frac{1}{4}$"'::jsonb, 'medium', '$\frac{1}{2}\times\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coin twice: $P(HT)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bag $2$R $3$B, no replacement, $P(RB)$?', 'multiple_choice', '["$\\frac{3}{10}$","$\\frac{6}{25}$","$\\frac{1}{5}$","$\\frac{2}{5}$"]'::jsonb, '"$\\frac{3}{10}$"'::jsonb, 'medium', '$\frac{2}{5}\times\frac{3}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bag $2$R $3$B, no replacement, $P(RB)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two spinners each $P(\text{win})=0.2$. $P(\text{both win})$?', 'multiple_choice', '["$0.04$","$0.4$","$0.2$","$0.36$"]'::jsonb, '"$0.04$"'::jsonb, 'medium', 'Multiply.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two spinners each $P(\text{win})=0.2$. $P(\text{both win})$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three coins tree: $P(\text{exactly 2 heads})$?', 'multiple_choice', '["$\\frac{3}{8}$","$\\frac{1}{8}$","$\\frac{1}{2}$","$\\frac{5}{8}$"]'::jsonb, '"$\\frac{3}{8}$"'::jsonb, 'hard', 'HHT, HTH, THH.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three coins tree: $P(\text{exactly 2 heads})$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bag $4$W $6$B, two draws no replacement, $P(\text{different colours})$?', 'multiple_choice', '["$\\frac{8}{15}$","$\\frac{24}{100}$","$\\frac{4}{10}$","$\\frac{1}{2}$"]'::jsonb, '"$\\frac{8}{15}$"'::jsonb, 'hard', '$WB+BW$ paths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tree_diagrams'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='probability'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bag $4$W $6$B, two draws no replacement, $P(\text{different colours})$?');

-- ========== COMPOUND PROPORTIONS AND RATES OF WORK ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Joint and Compound Proportion', '{"blocks":[{"type":"heading","content":"Compound Proportion"},{"type":"paragraph","content":"**Compound proportion** links one quantity to **two or more** others. Example: $T \\propto \\frac{D}{S}$ (time directly to distance, inversely to speed)."},{"type":"math_block","latex":"T = k\\frac{D}{S}","caption":"Time from distance and speed"},{"type":"callout","variant":"key_point","content":"Identify direct ($\\uparrow$ together) and inverse ($\\uparrow\\downarrow$) relationships before writing the formula."},{"type":"question","questionText":"More workers, same job — days required?","questionType":"multiple_choice","options":["Decrease","Increase","Stay same","Double always"],"correctAnswer":"Decrease","explanation":"Inverse proportion."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'compound_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Joint and Compound Proportion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Compound Proportion Problems', '{"blocks":[{"type":"heading","content":"Worked Problems"},{"type":"example","title":"$5$ workers take $12$ days. How long for $8$ workers (same job)?","steps":["$D \\propto \\frac{1}{W}$: $5 \\times 12 = 8 \\times d$.","$d = 7.5$ days."],"answer":"$7.5$ days"},{"type":"example","title":"$T \\propto D$ and $T \\propto \\frac{1}{S}$. $D=100$, $S=50$ gives $T=4$ hr. Find $T$ when $D=150$, $S=60$.","steps":["$T = k\\frac{D}{S}$; $4 = k\\frac{100}{50} \\Rightarrow k=2$.","$T = 2 \\times \\frac{150}{60} = 5$ hr."],"answer":"$5$ hours"},{"type":"callout","variant":"warning","content":"Keep units consistent (km/h with km, etc.)."},{"type":"question","questionText":"$y \\propto x$ and $y \\propto z$. Then $y \\propto$?","questionType":"multiple_choice","options":["$xz$","$x/z$","$x+z$","$1/xz$"],"correctAnswer":"$xz$","explanation":"Both direct."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'compound_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Compound Proportion Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Compound Proportion — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Compound Proportion"},{"type":"example","title":"$6$ taps fill a tank in $4$ hr. How long for $8$ taps?","steps":["Inverse: $6 \\times 4 = 8 \\times t$.","$t = 3$ hr."],"answer":"$3$ hours"},{"type":"callout","variant":"warning","content":"State the proportionality equation before substituting numbers."},{"type":"question","questionText":"More speed, fixed distance — time?","questionType":"multiple_choice","options":["Less","More","Same","Zero"],"correctAnswer":"Less","explanation":"Inverse."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'compound_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Compound Proportion — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Compound proportion involves?', 'multiple_choice', '["Two or more related quantities","One quantity only","Angles only","Vectors only"]'::jsonb, '"Two or more related quantities"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Compound proportion involves?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y \propto \frac{1}{x}$ means?', 'multiple_choice', '["Inverse proportion","Direct proportion","No link","Equal values"]'::jsonb, '"Inverse proportion"'::jsonb, 'easy', 'As $x$ rises, $y$ falls.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y \propto \frac{1}{x}$ means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$4$ men, $15$ days. $6$ men, same work?', 'multiple_choice', '["$10$ days","$15$ days","$9$ days","$22.5$ days"]'::jsonb, '"$10$ days"'::jsonb, 'medium', '$4\times15=6d$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$4$ men, $15$ days. $6$ men, same work?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$T \propto D/S$: $D=80$, $S=40$, $T=2$. Find $T$ when $D=120$, $S=60$.', 'multiple_choice', '["$2$ hr","$3$ hr","$4$ hr","$1$ hr"]'::jsonb, '"$2$ hr"'::jsonb, 'easy', 'Ratio unchanged.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$T \propto D/S$: $D=80$, $S=40$, $T=2$. Find $T$ when $D=120$, $S=60$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$8$ machines produce $400$ items in $5$ hr. $10$ machines in $4$ hr produce?', 'multiple_choice', '["$400$","$500$","$320$","$250$"]'::jsonb, '"$400$"'::jsonb, 'medium', 'Joint proportion setup.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$8$ machines produce $400$ items in $5$ hr. $10$ machines in $4$ hr produce?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P \propto \frac{MN}{T}$: $M=4,N=3,T=6,P=24$. Find $P$ when $M=5,N=4,T=8$.', 'multiple_choice', '["$25$","$30$","$20$","$40$"]'::jsonb, '"$25$"'::jsonb, 'hard', 'Find $k$ then substitute.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P \propto \frac{MN}{T}$: $M=4,N=3,T=6,P=24$. Find $P$ when $M=5,N=4,T=8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$12$ workers, $10$ days, $8$ hr/day. $15$ workers, $8$ days — hours/day?', 'multiple_choice', '["$8$ hr","$10$ hr","$6$ hr","$12$ hr"]'::jsonb, '"$8$ hr"'::jsonb, 'hard', 'Worker-days constant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$12$ workers, $10$ days, $8$ hr/day. $15$ workers, $8$ days — hours/day?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mixing Quantities', '{"blocks":[{"type":"heading","content":"Mixture Problems"},{"type":"paragraph","content":"In **mixture** problems, combine quantities with different concentrations or prices. Total amount $=$ sum of parts; value $=$ quantity $\\times$ unit value."},{"type":"example","title":"Mix $2$ L of $40\\%$ acid with $3$ L of $10\\%$ acid. Overall concentration?","steps":["Acid $= 0.4(2)+0.1(3)=1.1$ L.","Total $5$ L.","Conc $= 22\\%$."],"answer":"$22\\%$"},{"type":"question","questionText":"Mixing tea grades is a?","questionType":"multiple_choice","options":["Mixture problem","Vector problem","Circle theorem","Matrix problem"],"correctAnswer":"Mixture problem","explanation":"Blending quantities."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'mixtures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mixing Quantities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Alligation and Price Mixtures', '{"blocks":[{"type":"heading","content":"Price & Concentration"},{"type":"example","title":"Tea A KES $400$/kg mixed with Tea B KES $600$/kg to get $20$ kg at KES $450$/kg. Mass of A?","steps":["$400a+600(20-a)=450(20)$.","$a=15$ kg."],"answer":"$15$ kg of A"},{"type":"callout","variant":"warning","content":"Total value before mixing $=$ total value after mixing."},{"type":"question","questionText":"Pure water concentration of salt?","questionType":"multiple_choice","options":["$0\\%$","$50\\%$","$100\\%$","$25\\%$"],"correctAnswer":"$0\\%$","explanation":"No salt."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'mixtures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Alligation and Price Mixtures');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mixtures — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Mixtures"},{"type":"example","title":"How many litres of $30\\%$ solution must be added to $5$ L of $50\\%$ to get $40\\%$?","steps":["Let $x$ L added.","$0.3x+2.5=0.4(x+5)$.","$x=5$ L."],"answer":"$5$ litres"},{"type":"callout","variant":"warning","content":"Define $x$ clearly — litres of which component?"},{"type":"question","questionText":"Total volume when mixing $3$ L and $7$ L?","questionType":"multiple_choice","options":["$10$ L","$4$ L","$21$ L","$3.5$ L"],"correctAnswer":"$10$ L","explanation":"Add volumes."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'mixtures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mixtures — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mixture total quantity equals?', 'multiple_choice', '["Sum of parts","Product of parts","Difference","Average only"]'::jsonb, '"Sum of parts"'::jsonb, 'easy', 'Conservation of mass.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mixture total quantity equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$1$ L of $100\%$ acid mixed with $1$ L water gives?', 'multiple_choice', '["$50\\%$","$100\\%$","$0\\%$","$25\\%$"]'::jsonb, '"$50\\%$"'::jsonb, 'easy', 'Equal volumes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$1$ L of $100\%$ acid mixed with $1$ L water gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mix $4$ kg at KES $50$ with $6$ kg at KES $80$. Mean price/kg?', 'multiple_choice', '["KES $68$","KES $65$","KES $70$","KES $130$"]'::jsonb, '"KES $68$"'::jsonb, 'medium', '$(200+480)/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mix $4$ kg at KES $50$ with $6$ kg at KES $80$. Mean price/kg?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3$ L of $20\%$ + $2$ L of $50\%$. Final concentration?', 'multiple_choice', '["$32\\%$","$35\\%$","$30\\%$","$25\\%$"]'::jsonb, '"$32\\%$"'::jsonb, 'hard', '$(0.6+1)/5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3$ L of $20\%$ + $2$ L of $50\%$. Final concentration?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Alloy: $5$ kg copper + $x$ kg zinc, $40\%$ copper overall. $x$?', 'multiple_choice', '["$7.5$ kg","$5$ kg","$3$ kg","$10$ kg"]'::jsonb, '"$7.5$ kg"'::jsonb, 'medium', '$5/(5+x)=0.4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Alloy: $5$ kg copper + $x$ kg zinc, $40\%$ copper overall. $x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Milk $4\%$ fat: mix $10$ L with $x$ L water for $2.5\%$. $x$?', 'multiple_choice', '["$6$ L","$4$ L","$8$ L","$2.5$ L"]'::jsonb, '"$6$ L"'::jsonb, 'hard', 'Fat mass constant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Milk $4\%$ fat: mix $10$ L with $x$ L water for $2.5\%$. $x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coffee KES $500$ and KES $700$ mixed for $30$ kg at KES $560$. Kg of cheaper?', 'multiple_choice', '["$21$ kg","$15$ kg","$9$ kg","$18$ kg"]'::jsonb, '"$21$ kg"'::jsonb, 'hard', 'Alligation: ratio $3:1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mixtures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coffee KES $500$ and KES $700$ mixed for $30$ kg at KES $560$. Kg of cheaper?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Work Rates and Combined Workers', '{"blocks":[{"type":"heading","content":"Rates of Work"},{"type":"paragraph","content":"If person A finishes a job in $a$ days, daily rate $= \\frac{1}{a}$ of the job. Combined rate $=$ **sum** of individual rates."},{"type":"math_block","latex":"\\frac{1}{T} = \\frac{1}{a} + \\frac{1}{b}","caption":"Two workers together"},{"type":"example","title":"A: $6$ days, B: $3$ days. Together?","steps":["$\\frac{1}{T}=\\frac{1}{6}+\\frac{1}{3}=\\frac{1}{2}$.","$T=2$ days."],"answer":"$2$ days"},{"type":"question","questionText":"More workers on same job — completion time?","questionType":"multiple_choice","options":["Shorter","Longer","Unchanged","Infinite"],"correctAnswer":"Shorter","explanation":"Rates add."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'rates_of_work'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Work Rates and Combined Workers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pipes, Tanks and Partial Work', '{"blocks":[{"type":"heading","content":"Pipes Filling/Emptying"},{"type":"example","title":"Pipe A fills tank in $4$ hr, B in $6$ hr. Together?","steps":["$\\frac{1}{T}=\\frac{1}{4}+\\frac{1}{6}=\\frac{5}{12}$.","$T=2.4$ hr."],"answer":"$2.4$ hours"},{"type":"callout","variant":"warning","content":"An **emptying** pipe subtracts rate: $\\frac{1}{T}=\\frac{1}{a}-\\frac{1}{b}$."},{"type":"example","title":"A works $3$ days alone (job $12$ days), then B joins (job $6$ days). Total time?","steps":["A rate $\\frac{1}{12}$; in $3$ days $\\frac{1}{4}$ done.","Remaining $\\frac{3}{4}$ at $\\frac{1}{12}+\\frac{1}{6}=\\frac{1}{4}$/day.","$3$ more days; total $6$ days."],"answer":"$6$ days"},{"type":"question","questionText":"Emptying pipe rate sign in combined work?","questionType":"multiple_choice","options":["Negative (subtracted)","Always positive","Zero","Doubled"],"correctAnswer":"Negative (subtracted)","explanation":"Opposes filling."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'rates_of_work'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pipes, Tanks and Partial Work');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rates of Work — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Rates of Work"},{"type":"example","title":"Tap fills in $5$ hr; leak empties in $20$ hr. Both open — time to fill?","steps":["$\\frac{1}{T}=\\frac{1}{5}-\\frac{1}{20}=\\frac{3}{20}$.","$T=\\frac{20}{3}$ hr."],"answer":"$6\\frac{2}{3}$ hours"},{"type":"callout","variant":"warning","content":"Draw a table: worker/pipe, time for whole job, rate per hour."},{"type":"question","questionText":"Job rate unit is?","questionType":"multiple_choice","options":["Fraction of job per day","KES per hour","Metres per second","Degrees"],"correctAnswer":"Fraction of job per day","explanation":"Work per time."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work' AND st.code = 'rates_of_work'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rates of Work — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Worker finishes in $10$ days — daily rate?', 'multiple_choice', '["$\\frac{1}{10}$","$10$","$\\frac{1}{5}$","$1$"]'::jsonb, '"$\\frac{1}{10}$"'::jsonb, 'easy', 'Reciprocal of time.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Worker finishes in $10$ days — daily rate?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two workers together — rates are?', 'multiple_choice', '["Added","Subtracted","Multiplied","Ignored"]'::jsonb, '"Added"'::jsonb, 'easy', 'Combined work.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two workers together — rates are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A: $4$ days, B: $12$ days. Together?', 'multiple_choice', '["$3$ days","$8$ days","$16$ days","$4$ days"]'::jsonb, '"$3$ days"'::jsonb, 'medium', '$\frac{1}{4}+\frac{1}{12}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A: $4$ days, B: $12$ days. Together?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pipe fills $3$ hr, drain empties $6$ hr. Net fill time?', 'multiple_choice', '["$6$ hr","$3$ hr","$2$ hr","$9$ hr"]'::jsonb, '"$6$ hr"'::jsonb, 'medium', '$\frac{1}{3}-\frac{1}{6}=\frac{1}{6}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pipe fills $3$ hr, drain empties $6$ hr. Net fill time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three workers: $6$, $12$, $4$ days each. Together?', 'multiple_choice', '["$2$ days","$3$ days","$4$ days","$6$ days"]'::jsonb, '"$2$ days"'::jsonb, 'medium', 'Sum rates $=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three workers: $6$, $12$, $4$ days each. Together?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A+B: $3$ days; A alone $4$ days. B alone?', 'multiple_choice', '["$12$ days","$7$ days","$1$ day","$5$ days"]'::jsonb, '"$12$ days"'::jsonb, 'hard', '$\frac{1}{b}=\frac{1}{3}-\frac{1}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A+B: $3$ days; A alone $4$ days. B alone?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Half job by A ($8$ days full) then B ($24$ days full) finishes. Total days?', 'multiple_choice', '["$8$ days","$6$ days","$10$ days","$4$ days"]'::jsonb, '"$8$ days"'::jsonb, 'hard', '$4$ days A + $4$ days B.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates_of_work'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='compound_proportions_rates_work'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Half job by A ($8$ days full) then B ($24$ days full) finishes. Total days?');

