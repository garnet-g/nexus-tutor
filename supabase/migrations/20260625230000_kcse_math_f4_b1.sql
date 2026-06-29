-- KCSE Form 4 Mathematics — Wave 4 Batch 1
-- Topics: matrices_transformations, statistics_ii, loci, trigonometry_iii, three_dimensional_geometry
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md

-- ========== MATRICES AND TRANSFORMATIONS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Transformation Matrices — Concepts', '{"blocks":[{"type":"heading","content":"2×2 Transformation Matrices"},{"type":"paragraph","content":"A point $(x,y)$ as $\\begin{pmatrix} x \\\\ y \\end{pmatrix}$ is mapped by $T$ to $T\\begin{pmatrix} x \\\\ y \\end{pmatrix}$."},{"type":"math_block","latex":"\\begin{pmatrix} x'' \\\\ y'' \\end{pmatrix} = \\begin{pmatrix} a & b \\\\ c & d \\end{pmatrix}\\begin{pmatrix} x \\\\ y \\end{pmatrix}","caption":"Linear transformation"},{"type":"callout","variant":"key_point","content":"Reflection in the **x-axis**: $\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$. Reflection in the **y-axis**: $\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$."},{"type":"question","questionText":"KCSE transformation matrices are usually?","questionType":"multiple_choice","options":["$2 \\times 2$","$3 \\times 3$","$1 \\times 2$","$2 \\times 1$"],"correctAnswer":"$2 \\times 2$","explanation":"Form 4 standard."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'transformation_matrices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Transformation Matrices — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Common Transformation Matrices', '{"blocks":[{"type":"heading","content":"Reflection, Rotation, Enlargement"},{"type":"table","rows":[["Reflection in $x$-axis","$\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$"],["Reflection in $y$-axis","$\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$"],["Enlargement $k$ about $O$","$\\begin{pmatrix} k & 0 \\\\ 0 & k \\end{pmatrix}$"]],"caption":"Matrices with centre at origin"},{"type":"example","title":"Image of $(2,3)$ under reflection in $x$-axis.","steps":["$\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$$\\begin{pmatrix} 2 \\\\ 3 \\end{pmatrix} = \\begin{pmatrix} 2 \\\\ -3 \\end{pmatrix}$."],"answer":"$(2,-3)$"},{"type":"callout","variant":"warning","content":"Multiply **matrix × column vector** — order matters."},{"type":"question","questionText":"Enlargement scale $3$ about $O$?","questionType":"multiple_choice","options":["$\\begin{pmatrix} 3 & 0 \\\\ 0 & 3 \\end{pmatrix}$","$\\begin{pmatrix} 1 & 0 \\\\ 0 & 3 \\end{pmatrix}$","$\\begin{pmatrix} 3 & 0 \\\\ 0 & 1 \\end{pmatrix}$","$\\begin{pmatrix} 0 & 3 \\\\ 3 & 0 \\end{pmatrix}$"],"correctAnswer":"$\\begin{pmatrix} 3 & 0 \\\\ 0 & 3 \\end{pmatrix}$","explanation":"Diagonal $k$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'transformation_matrices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Common Transformation Matrices');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Transformation Matrices — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Transformation Matrices"},{"type":"example","title":"$90^\\circ$ anticlockwise rotation about $O$ maps $(1,0)$ to?","steps":["Use $\\begin{pmatrix} 0 & -1 \\\\ 1 & 0 \\end{pmatrix}$.","Image $(0,1)$."],"answer":"$(0,1)$"},{"type":"callout","variant":"warning","content":"Name the transformation and show the matrix in full working."},{"type":"question","questionText":"$(4,-2)$ reflected in $y$-axis?","questionType":"multiple_choice","options":["$(-4,-2)$","$(4,2)$","$(-4,2)$","$(2,-4)$"],"correctAnswer":"$(-4,-2)$","explanation":"Negate $x$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'transformation_matrices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Transformation Matrices — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Transformation matrix acts on a point by?', 'multiple_choice', '["Matrix multiplication","Addition","Scalar division","Integration"]'::jsonb, '"Matrix multiplication"'::jsonb, 'easy', 'Standard rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Transformation matrix acts on a point by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflection in $x$-axis matrix?', 'multiple_choice', '["$\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$","$\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$","$\\begin{pmatrix} 0 & 1 \\\\ 1 & 0 \\end{pmatrix}$","$\\begin{pmatrix} 1 & 1 \\\\ 0 & 0 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$"'::jsonb, 'easy', 'Negate $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflection in $x$-axis matrix?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflection in $y$-axis matrix?', 'multiple_choice', '["$\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$","$\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$","$\\begin{pmatrix} 0 & -1 \\\\ 1 & 0 \\end{pmatrix}$","$\\begin{pmatrix} -1 & -1 \\\\ 0 & 0 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$"'::jsonb, 'easy', 'Negate $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflection in $y$-axis matrix?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(3,2)$ under enlargement $k=2$ about $O$?', 'multiple_choice', '["$(6,4)$","$(5,4)$","$(3,4)$","$(6,2)$"]'::jsonb, '"$(6,4)$"'::jsonb, 'medium', 'Multiply coords.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(3,2)$ under enlargement $k=2$ about $O$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1,4)$ reflected in $x$-axis?', 'multiple_choice', '["$(1,-4)$","$(-1,4)$","$(-1,-4)$","$(4,1)$"]'::jsonb, '"$(1,-4)$"'::jsonb, 'medium', '$y$ sign change.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1,4)$ reflected in $x$-axis?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(2,-1)$ under $[0 & -1 ; 1 & 0]$?', 'multiple_choice', '["$(1,2)$","$(-2,1)$","$(2,1)$","$(-1,-2)$"]'::jsonb, '"$(1,2)$"'::jsonb, 'hard', 'Apply matrix.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(2,-1)$ under $[0 & -1 ; 1 & 0]$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlargement $k=-2$ about $O$: $(1,3)$ maps to?', 'multiple_choice', '["$(-2,-6)$","$(2,-6)$","$(-2,6)$","$(-1,-3)$"]'::jsonb, '"$(-2,-6)$"'::jsonb, 'hard', 'Scale and invert.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='transformation_matrices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlargement $k=-2$ about $O$: $(1,3)$ maps to?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combining Transformations', '{"blocks":[{"type":"heading","content":"Successive Transformations"},{"type":"paragraph","content":"If $T_1$ then $T_2$ are applied, the **combined** matrix is $T_2 T_1$ (rightmost acts first on the vector)."},{"type":"math_block","latex":"\\mathbf{x}'' = T_2(T_1\\mathbf{x}) = (T_2 T_1)\\mathbf{x}","caption":"Order of multiplication"},{"type":"callout","variant":"key_point","content":"Matrix multiplication is **not commutative** — order changes the result."},{"type":"question","questionText":"Apply $A$ then $B$. Combined matrix?","questionType":"multiple_choice","options":["$BA$","$AB$","$A+B$","$A-B$"],"correctAnswer":"$BA$","explanation":"$B$ acts on $A\\mathbf{x}$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'successive_transformations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combining Transformations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying Transformation Matrices', '{"blocks":[{"type":"heading","content":"Worked Combination"},{"type":"example","title":"Reflect in $x$-axis then enlarge scale $2$. Combined matrix?","steps":["$E=\\begin{pmatrix} 2 & 0 \\\\ 0 & 2 \\end{pmatrix}$, $R=\\begin{pmatrix} 1 & 0 \\\\ 0 & -1 \\end{pmatrix}$.","Combined $ER=\\begin{pmatrix} 2 & 0 \\\\ 0 & -2 \\end{pmatrix}$."],"answer":"$\\begin{pmatrix} 2 & 0 \\\\ 0 & -2 \\end{pmatrix}$"},{"type":"callout","variant":"warning","content":"Write matrices in the order they are applied when building the product."},{"type":"question","questionText":"$AB$ means apply?","questionType":"multiple_choice","options":["$B$ then $A$","$A$ then $B$","Both at once only","Neither"],"correctAnswer":"$B$ then $A$","explanation":"$A(B\\mathbf{x})$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'successive_transformations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying Transformation Matrices');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Successive Transformations — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Combined Transformations"},{"type":"example","title":"$(1,2)$: reflect in $y$-axis then translate — note pure matrix step for reflection only gives $(-1,2)$.","steps":["Reflection matrix $\\begin{pmatrix} -1 & 0 \\\\ 0 & 1 \\end{pmatrix}$.","Image $(-1,2)$."],"answer":"$(-1,2)$"},{"type":"callout","variant":"warning","content":"KCSE often asks for matrix product only — translations need vector addition."},{"type":"question","questionText":"Enlargement $2$ then reflection in $x$-axis: diagonal entries of product?","questionType":"multiple_choice","options":["$2$ and $-2$","$2$ and $2$","$-2$ and $2$","$1$ and $-1$"],"correctAnswer":"$2$ and $-2$","explanation":"$\\begin{pmatrix} 2 & 0 \\\\ 0 & -2 \\end{pmatrix}$"}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'successive_transformations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Successive Transformations — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Successive transformations combine by?', 'multiple_choice', '["Matrix multiplication","Matrix addition","Division","Determinant only"]'::jsonb, '"Matrix multiplication"'::jsonb, 'easy', 'Product of matrices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Successive transformations combine by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Apply $T_1$ then $T_2$. Single matrix?', 'multiple_choice', '["$T_2T_1$","$T_1T_2$","$T_1+T_2$","$T_1-T_2$"]'::jsonb, '"$T_2T_1$"'::jsonb, 'easy', 'Right acts first.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Apply $T_1$ then $T_2$. Single matrix?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $x$-axis then enlarge $3$. Product matrix?', 'multiple_choice', '["$\\begin{pmatrix} 3 & 0 \\\\ 0 & -3 \\end{pmatrix}$","$\\begin{pmatrix} 3 & 0 \\\\ 0 & 3 \\end{pmatrix}$","$\\begin{pmatrix} -3 & 0 \\\\ 0 & 3 \\end{pmatrix}$","$\\begin{pmatrix} 1 & 0 \\\\ 0 & -3 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 3 & 0 \\\\ 0 & -3 \\end{pmatrix}$"'::jsonb, 'medium', 'ER product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $x$-axis then enlarge $3$. Product matrix?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlarge $2$ then reflect $y$-axis. Product?', 'multiple_choice', '["$\\begin{pmatrix} -2 & 0 \\\\ 0 & 2 \\end{pmatrix}$","$\\begin{pmatrix} 2 & 0 \\\\ 0 & -2 \\end{pmatrix}$","$\\begin{pmatrix} -2 & 0 \\\\ 0 & -2 \\end{pmatrix}$","$\\begin{pmatrix} 2 & 0 \\\\ 0 & 2 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} -2 & 0 \\\\ 0 & 2 \\end{pmatrix}$"'::jsonb, 'medium', 'RE product.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlarge $2$ then reflect $y$-axis. Product?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1,1)$: reflect $x$-axis then enlarge $2$. Image?', 'multiple_choice', '["$(2,-2)$","$(-2,2)$","$(2,2)$","$(-2,-2)$"]'::jsonb, '"$(2,-2)$"'::jsonb, 'medium', '$(1,-1)$ then scale.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1,1)$: reflect $x$-axis then enlarge $2$. Image?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A=[0 & 1 ; 1 & 0]$ (reflect $y=x$). $A^2$ equals?', 'multiple_choice', '["$\\begin{pmatrix} 1 & 0 \\\\ 0 & 1 \\end{pmatrix}$","$\\begin{pmatrix} 0 & 1 \\\\ 1 & 0 \\end{pmatrix}$","$\\begin{pmatrix} -1 & 0 \\\\ 0 & -1 \\end{pmatrix}$","$\\begin{pmatrix} 0 & -1 \\\\ 1 & 0 \\end{pmatrix}$"]'::jsonb, '"$\\begin{pmatrix} 1 & 0 \\\\ 0 & 1 \\end{pmatrix}$"'::jsonb, 'hard', 'Double reflection gives identity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A=[0 & 1 ; 1 & 0]$ (reflect $y=x$). $A^2$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $90^\circ$ AC then reflect $x$-axis. Product top-left entry?', 'multiple_choice', '["$0$","$1$","$-1$","$2$"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Multiply matrices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='successive_transformations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $90^\circ$ AC then reflect $x$-axis. Product top-left entry?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area Scale Factor — Concepts', '{"blocks":[{"type":"heading","content":"Area Under a Transformation"},{"type":"paragraph","content":"For matrix $T$, **area scale factor** $= |\\det T|$. A region of area $A$ maps to area $|det(T)|\\cdot A$."},{"type":"math_block","latex":"\\text{New area} = |ad-bc| \\times \\text{original area}","caption":"For $T=\\begin{pmatrix}a&b\\\\c&d\\end{pmatrix}$"},{"type":"callout","variant":"key_point","content":"Negative determinant indicates orientation reversal — use **absolute value** for area."},{"type":"question","questionText":"Area scale factor uses?","questionType":"multiple_choice","options":["$|\\det T|$","$\\det T$ only if positive","Trace of $T$","Sum of entries"],"correctAnswer":"$|\\det T|$","explanation":"Absolute determinant."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'area_scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area Scale Factor — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Area Scale Factor', '{"blocks":[{"type":"heading","content":"Worked Examples"},{"type":"example","title":"Triangle area $6$ cm$^2$. Enlargement $k=3$. New area?","steps":["$\\det=9$.","New area $=9\\times6=54$ cm$^2$."],"answer":"$54$ cm$^2$"},{"type":"callout","variant":"warning","content":"Linear dimensions scale by $k$; areas scale by $k^2$."},{"type":"question","questionText":"Enlargement $k=2$. Area multiplied by?","questionType":"multiple_choice","options":["$4$","$2$","$8$","$1$"],"correctAnswer":"$4$","explanation":"$k^2=4$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'area_scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Area Scale Factor');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area Scale Factor — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Area Scale Factor"},{"type":"example","title":"$T=\\begin{pmatrix} 2 & 1 \\\\ 0 & 3 \\end{pmatrix}$. Rectangle area $10$ cm$^2$. Image area?","steps":["$\\det=6$.","Image area $=60$ cm$^2$."],"answer":"$60$ cm$^2$"},{"type":"callout","variant":"warning","content":"Show determinant calculation before area multiplication."},{"type":"question","questionText":"$\\det T=-5$. Area scale factor?","questionType":"multiple_choice","options":["$5$","$-5$","$0$","$25$"],"correctAnswer":"$5$","explanation":"Use modulus."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations' AND st.code = 'area_scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area Scale Factor — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area scale factor equals?', 'multiple_choice', '["$|\\det T|$","Trace of $T$","$\\det T$ always negative","Rank only"]'::jsonb, '"$|\\det T|$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area scale factor equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlargement $k=4$. Area scale factor?', 'multiple_choice', '["$16$","$4$","$8$","$2$"]'::jsonb, '"$16$"'::jsonb, 'easy', '$k^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlargement $k=4$. Area scale factor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\det[3 & 0 ; 0 & 2]$?', 'multiple_choice', '["$6$","$5$","$1$","$-6$"]'::jsonb, '"$6$"'::jsonb, 'medium', '$3\times2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\det[3 & 0 ; 0 & 2]$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area $12$ cm$^2$, $\det T=5$. Image area?', 'multiple_choice', '["$60$ cm$^2$","$17$ cm$^2$","$7$ cm$^2$","$12$ cm$^2$"]'::jsonb, '"$60$ cm$^2$"'::jsonb, 'medium', '$12\times5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area $12$ cm$^2$, $\det T=5$. Image area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$T=[1 & 2 ; 3 & 4]$. Area factor?', 'multiple_choice', '["$2$","$-2$","$10$","$0$"]'::jsonb, '"$2$"'::jsonb, 'hard', '$|4-6|=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$T=[1 & 2 ; 3 & 4]$. Area factor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square side $3$, $T$ has $\det=7$. Image square area?', 'multiple_choice', '["$63$","$21$","$9$","$49$"]'::jsonb, '"$63$"'::jsonb, 'hard', '$9\times7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square side $3$, $T$ has $\det=7$. Image square area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Shear matrix $\det=1$. Area scale factor?', 'multiple_choice', '["$1$","$0$","$-1$","$2$"]'::jsonb, '"$1$"'::jsonb, 'hard', 'Determinant gives area factor.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='matrices_transformations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Shear matrix $\det=1$. Area scale factor?');
-- ========== STATISTICS II ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Grouped Data — Concepts', '{"blocks":[{"type":"heading","content":"Class Intervals"},{"type":"paragraph","content":"**Grouped data** lists frequencies in class intervals such as $10\\le x<20$. The **class width** is upper boundary minus lower."},{"type":"table","rows":[["$0$–$10$","$3$"],["$10$–$20$","$7$"],["$20$–$30$","$5$"]],"caption":"Example frequency table"},{"type":"callout","variant":"key_point","content":"Use **class midpoints** for mean estimates: midpoint $=\\frac{\\text{lower}+\\text{upper}}{2}$."},{"type":"question","questionText":"Class $15$–$25$ has width?","questionType":"multiple_choice","options":["$10$","$20$","$15$","$5$"],"correctAnswer":"$10$","explanation":"$25-15$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'grouped_data'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Grouped Data — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Grouped Tables', '{"blocks":[{"type":"heading","content":"Frequency Tables"},{"type":"example","title":"Total frequency from table with classes $0$–$10$: $4$, $10$–$20$: $6$, $20$–$30$: $2$.","steps":["Total $=4+6+2=12$."],"answer":"$12$"},{"type":"callout","variant":"warning","content":"Check whether boundaries are inclusive — KCSE tables state this clearly."},{"type":"question","questionText":"Midpoint of $20$–$30$?","questionType":"multiple_choice","options":["$25$","$20$","$30$","$10$"],"correctAnswer":"$25$","explanation":"Average of bounds."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'grouped_data'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Grouped Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Grouped Data — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Grouped Data"},{"type":"example","title":"Which class has highest frequency if $0$–$5$: $2$, $5$–$10$: $9$, $10$–$15$: $4$?","steps":["$5$–$10$ has $9$."],"answer":"$5$–$10$"},{"type":"callout","variant":"warning","content":"Label axes clearly when drawing histograms — frequency density if widths differ."},{"type":"question","questionText":"Histogram with unequal classes uses?","questionType":"multiple_choice","options":["Frequency density","Raw frequency only on $y$","Cumulative freq only","Midpoints on $y$"],"correctAnswer":"Frequency density","explanation":"Area represents frequency."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'grouped_data'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Grouped Data — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Grouped data uses?', 'multiple_choice', '["Class intervals","Only single values","No frequencies","Pie charts only"]'::jsonb, '"Class intervals"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Grouped data uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Midpoint of $0$–$10$?', 'multiple_choice', '["$5$","$10$","$0$","$20$"]'::jsonb, '"$5$"'::jsonb, 'easy', 'Average bound.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Midpoint of $0$–$10$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class width $5$–$15$?', 'multiple_choice', '["$10$","$5$","$15$","$20$"]'::jsonb, '"$10$"'::jsonb, 'easy', '$15-5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class width $5$–$15$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frequencies $3,7,5$. Total?', 'multiple_choice', '["$15$","$14$","$16$","$12$"]'::jsonb, '"$15$"'::jsonb, 'medium', 'Sum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frequencies $3,7,5$. Total?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cumulative freq at end equals?', 'multiple_choice', '["Total frequency","Class width","Mean","Variance"]'::jsonb, '"Total frequency"'::jsonb, 'medium', 'Running total.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cumulative freq at end equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Classes $10$–$20$ ($f=4$), $20$–$40$ ($f=8$). Histogram: second bar width?', 'multiple_choice', '["$20$","$10$","$8$","$4$"]'::jsonb, '"$20$"'::jsonb, 'hard', 'Unequal width.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Classes $10$–$20$ ($f=4$), $20$–$40$ ($f=8$). Histogram: second bar width?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frequency density $=\frac{f}{w}$. Class $f=12$, $w=4$. Density?', 'multiple_choice', '["$3$","$48$","$8$","$16$"]'::jsonb, '"$3$"'::jsonb, 'hard', '$12/4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='grouped_data'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frequency density $=\frac{f}{w}$. Class $f=12$, $w=4$. Density?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Mean of Grouped Data — Concepts', '{"blocks":[{"type":"heading","content":"Estimated Mean"},{"type":"math_block","latex":"\\bar{x} = \\frac{\\sum fx}{\\sum f}","caption":"Using class midpoints for $x$"},{"type":"callout","variant":"key_point","content":"Multiply each midpoint by frequency, sum, divide by total frequency."},{"type":"question","questionText":"Grouped mean is?","questionType":"multiple_choice","options":["An estimate","Always exact","Always zero","Same as median always"],"correctAnswer":"An estimate","explanation":"Assumes uniform spread in class."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'mean_grouped'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Mean of Grouped Data — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating the Grouped Mean', '{"blocks":[{"type":"heading","content":"Worked Mean"},{"type":"table","rows":[["Class","$f$","Midpoint $x$","$fx$"],["$0$–$10$","$2$","$5$","$10$"],["$10$–$20$","$3$","$15$","$45$"]],"caption":"Mean calculation layout"},{"type":"example","title":"From table: $\\sum f=5$, $\\sum fx=55$.","steps":["$\\bar{x}=55/5=11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"Show $\\sum fx$ and $\\sum f$ columns — method marks."},{"type":"question","questionText":"$\\sum fx=200$, $\\sum f=25$. Mean?","questionType":"multiple_choice","options":["$8$","$175$","$225$","$5$"],"correctAnswer":"$8$","explanation":"$200/25$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'mean_grouped'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating the Grouped Mean');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Grouped Mean — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Grouped Mean"},{"type":"example","title":"Classes: $10$–$20$ ($f=4$, mid $15$), $20$–$30$ ($f=6$, mid $25$). Mean?","steps":["$\\sum fx=60+150=210$, $\\sum f=10$.","$\\bar{x}=21$."],"answer":"$21$"},{"type":"callout","variant":"warning","content":"Use midpoints — not upper bounds."},{"type":"question","questionText":"If all midpoints increase by $2$, mean?","questionType":"multiple_choice","options":["Increases by $2$","Unchanged","Doubles","Halves"],"correctAnswer":"Increases by $2$","explanation":"Shift in data."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'mean_grouped'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Grouped Mean — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Grouped mean formula?', 'multiple_choice', '["$\\sum fx/\\sum f$","$\\sum f/\\sum x$","$\\sum x$ only","$f \\times w$"]'::jsonb, '"$\\sum fx/\\sum f$"'::jsonb, 'easy', 'Standard formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Grouped mean formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Use ___ as $x$ in grouped mean.', 'multiple_choice', '["Class midpoint","Upper bound only","Class width","Variance"]'::jsonb, '"Class midpoint"'::jsonb, 'easy', 'Representative value.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Use ___ as $x$ in grouped mean.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Class $5$–$15$, $f=8$. $fx$?', 'multiple_choice', '["$80$","$40$","$120$","$8$"]'::jsonb, '"$80$"'::jsonb, 'medium', 'Mid $10$, $8\times10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Class $5$–$15$, $f=8$. $fx$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two classes same width, $f$ equal. Mean equals?', 'multiple_choice', '["Average of midpoints","Sum of widths","Zero","Median always"]'::jsonb, '"Average of midpoints"'::jsonb, 'medium', 'Symmetric weights.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two classes same width, $f$ equal. Mean equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sum fx=360$, $\sum f=30$. Mean?', 'multiple_choice', '["$12$","$330$","$390$","$30$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Division.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sum fx=360$, $\sum f=30$. Mean?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Add observation in highest class. Mean generally?', 'multiple_choice', '["Increases","Always decreases","Stays $0$","Undefined"]'::jsonb, '"Increases"'::jsonb, 'hard', 'Pulls mean up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Add observation in highest class. Mean generally?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Classes $0$–$20$ ($f=5$), $20$–$40$ ($f=5$). Mean?', 'multiple_choice', '["$20$","$10$","$30$","$25$"]'::jsonb, '"$20$"'::jsonb, 'hard', 'Symmetric midpoints.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='mean_grouped'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Classes $0$–$20$ ($f=5$), $20$–$40$ ($f=5$). Mean?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Quartiles and Spread — Concepts', '{"blocks":[{"type":"heading","content":"Quartiles"},{"type":"paragraph","content":"**$Q_1$** (lower quartile): $25\\%$ of data below. **$Q_2$**: median. **$Q_3$**: $75\\%$ below."},{"type":"math_block","latex":"IQR = Q_3 - Q_1","caption":"Interquartile range"},{"type":"callout","variant":"key_point","content":"From ogive, read $Q_1$, $Q_2$, $Q_3$ at $\\frac{n}{4}$, $\\frac{n}{2}$, $\\frac{3n}{4}$ positions."},{"type":"question","questionText":"IQR measures?","questionType":"multiple_choice","options":["Middle spread","Mean","Total frequency","Class width"],"correctAnswer":"Middle spread","explanation":"Spread of middle 50%."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'quartiles_deviation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Quartiles and Spread — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Variance and Standard Deviation', '{"blocks":[{"type":"heading","content":"Variance & SD"},{"type":"math_block","latex":"\\sigma^2 = \\frac{\\sum f(x-\\bar{x})^2}{\\sum f}, \\quad \\sigma = \\sqrt{\\sigma^2}","caption":"Grouped variance (estimate)"},{"type":"example","title":"If $\\sum f(x-\\bar{x})^2=100$ and $\\sum f=25$, variance?","steps":["$\\sigma^2=4$.","$\\sigma=2$."],"answer":"$\\sigma=2$"},{"type":"callout","variant":"warning","content":"Variance uses squared deviations — SD returns to original units."},{"type":"question","questionText":"Larger SD means data is?","questionType":"multiple_choice","options":["More spread out","Always larger mean","Always symmetric","Always grouped"],"correctAnswer":"More spread out","explanation":"Spread measure."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'quartiles_deviation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Variance and Standard Deviation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Quartiles & SD — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Quartiles, Ogives, SD"},{"type":"example","title":"Ogive: $Q_1=12$, $Q_3=28$. IQR?","steps":["$IQR=16$."],"answer":"$16$"},{"type":"callout","variant":"warning","content":"Plot points at upper boundaries for a cumulative frequency curve."},{"type":"question","questionText":"$\\sigma^2=9$. $\\sigma$?","questionType":"multiple_choice","options":["$3$","$81$","$4.5$","$9$"],"correctAnswer":"$3$","explanation":"Square root."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii' AND st.code = 'quartiles_deviation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Quartiles & SD — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$Q_2$ is the?', 'multiple_choice', '["Median","Lower quartile","Upper quartile","Range"]'::jsonb, '"Median"'::jsonb, 'easy', '50th percentile.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$Q_2$ is the?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'IQR equals?', 'multiple_choice', '["$Q_3-Q_1$","$Q_2-Q_1$","$Q_3+Q_1$","$n/4$"]'::jsonb, '"$Q_3-Q_1$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='IQR equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$Q_1=8$, $Q_3=20$. IQR?', 'multiple_choice', '["$12$","$28$","$10$","$16$"]'::jsonb, '"$12$"'::jsonb, 'medium', '$20-8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$Q_1=8$, $Q_3=20$. IQR?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sigma^2=25$. SD?', 'multiple_choice', '["$5$","$625$","$12.5$","$25$"]'::jsonb, '"$5$"'::jsonb, 'medium', '$\sqrt{25}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sigma^2=25$. SD?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'All values equal. SD?', 'multiple_choice', '["$0$","$1$","Undefined","Equals mean"]'::jsonb, '"$0$"'::jsonb, 'hard', 'No spread.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='All values equal. SD?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$n=80$. Position for $Q_3$ on ogive at?', 'multiple_choice', '["$60$","$40$","$20$","$80$"]'::jsonb, '"$60$"'::jsonb, 'hard', '$\frac{3n}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$n=80$. Position for $Q_3$ on ogive at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Variance doubles when all values multiplied by?', 'multiple_choice', '["$2$","$4$","$\\sqrt{2}$","$1$"]'::jsonb, '"$2$"'::jsonb, 'hard', 'Scale factor squares for variance.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quartiles_deviation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='statistics_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Variance doubles when all values multiplied by?');