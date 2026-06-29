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