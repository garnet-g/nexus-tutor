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

