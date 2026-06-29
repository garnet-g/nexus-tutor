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
-- ========== LOCI ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Locus of Points — Concepts', '{"blocks":[{"type":"heading","content":"What is a Locus?"},{"type":"paragraph","content":"A **locus** is the set of all points satisfying a given condition (e.g. fixed distance from a point)."},{"type":"callout","variant":"key_point","content":"Distance $r$ from point $A$ → locus is a **circle** centre $A$, radius $r$."},{"type":"question","questionText":"Locus of points $3$ cm from $P$?","questionType":"multiple_choice","options":["Circle radius $3$ cm","Line through $P$","Square","Parallel line only"],"correctAnswer":"Circle radius $3$ cm","explanation":"Fixed distance."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'locus_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Locus of Points — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Standard Loci', '{"blocks":[{"type":"heading","content":"Common Loci"},{"type":"paragraph","content":"Equidistant from two points $A$, $B$ → **perpendicular bisector** of $AB$. Equidistant from two lines → **angle bisector** (or parallel line if lines are parallel)."},{"type":"example","title":"Describe locus equidistant from parallel lines $3$ cm apart.","steps":["Parallel line midway between them."],"answer":"Midline parallel to both"},{"type":"question","questionText":"Equidistant from $A$ and $B$?","questionType":"multiple_choice","options":["Perpendicular bisector of $AB$","Circle at $A$","Line through $A$ only","Arc only"],"correctAnswer":"Perpendicular bisector of $AB$","explanation":"Equal distance property."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'locus_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Standard Loci');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Locus of Points — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Describing Loci"},{"type":"example","title":"Locus of points $2$ cm from line $L$.","steps":["Two parallel lines, one each side of $L$, distance $2$ cm."],"answer":"Pair of parallel lines"},{"type":"callout","variant":"warning","content":"State **shape**, **centre/line**, and **measurement** in your answer."},{"type":"question","questionText":"Locus inside triangle equidistant from all sides?","questionType":"multiple_choice","options":["Incentre/incircle region","Circumcircle only","Median only","Altitude only"],"correctAnswer":"Incentre/incircle region","explanation":"Angle bisectors meet at incentre."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'locus_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Locus of Points — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Locus is a set of points satisfying?', 'multiple_choice', '["A given condition","Random points","Only integers","Area formula"]'::jsonb, '"A given condition"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Locus is a set of points satisfying?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$4$ cm from fixed point $O$?', 'multiple_choice', '["Circle radius $4$ cm","Square side $4$","Line length $4$ only","No locus"]'::jsonb, '"Circle radius $4$ cm"'::jsonb, 'easy', 'Constant distance.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$4$ cm from fixed point $O$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equidistant from two points?', 'multiple_choice', '["Perpendicular bisector","Circle at one point","Random curve","Parallel to $x$-axis only"]'::jsonb, '"Perpendicular bisector"'::jsonb, 'easy', 'Classic locus.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equidistant from two points?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2$ cm from a straight line?', 'multiple_choice', '["Two parallel lines","One line only","Circle","Point"]'::jsonb, '"Two parallel lines"'::jsonb, 'medium', 'Both sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2$ cm from a straight line?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equidistant from two intersecting lines?', 'multiple_choice', '["Angle bisectors","Perpendicular bisector of segment","Circle","Parabola"]'::jsonb, '"Angle bisectors"'::jsonb, 'medium', 'Bisect angles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equidistant from two intersecting lines?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Points closer to $A$ than $B$?', 'multiple_choice', '["Half-plane bounded by perp. bisector","Circle at $A$","Line $AB$","Empty set"]'::jsonb, '"Half-plane bounded by perp. bisector"'::jsonb, 'hard', 'One side of bisector.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Points closer to $A$ than $B$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Locus equidistant from three non-collinear points (vertices)?', 'multiple_choice', '["Circumcentre (one point)","Infinite points always","Line only","Two circles"]'::jsonb, '"Circumcentre (one point)"'::jsonb, 'hard', 'Perp. bisectors meet once.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='locus_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Locus equidistant from three non-collinear points (vertices)?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Constructing Loci', '{"blocks":[{"type":"heading","content":"Compass and Straight Edge"},{"type":"paragraph","content":"To construct locus $2$ cm from point $P$: set compass to $2$ cm, draw full circle centre $P$."},{"type":"callout","variant":"key_point","content":"Perpendicular bisector: arcs of equal radius from $A$ and $B$, join intersection points."},{"type":"question","questionText":"First step for circle locus?","questionType":"multiple_choice","options":["Set compass to required radius","Draw diameter only","Measure angle","Plot origin"],"correctAnswer":"Set compass to required radius","explanation":"Radius defines circle."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'constructed_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Constructing Loci');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Construction Steps', '{"blocks":[{"type":"heading","content":"Perpendicular Bisector Construction"},{"type":"paragraph","content":"1. Place compass at $A$, draw arcs crossing $AB$. 2. Repeat from $B$ with same radius. 3. Join the two arc intersections — this line is the perpendicular bisector."},{"type":"example","title":"Construct locus equidistant from $A$ and $B$.","steps":["Draw perpendicular bisector of $AB$ as above."],"answer":"Perpendicular bisector"},{"type":"callout","variant":"warning","content":"Leave construction arcs visible — examiners check method."},{"type":"question","questionText":"Angle bisector at $O$ uses?","questionType":"multiple_choice","options":["Arcs from $O$ cutting both arms","Only one arc","Parallel lines","Midpoint only"],"correctAnswer":"Arcs from $O$ cutting both arms","explanation":"Standard angle bisector."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'constructed_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Construction Steps');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Constructed Loci — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Construction"},{"type":"example","title":"Construct circle centre $P$, radius $3$ cm; shade region inside.","steps":["Compass width $3$ cm at $P$, complete circle."],"answer":"Interior is locus $<3$ cm from $P$"},{"type":"callout","variant":"warning","content":"Label points and show all construction arcs clearly."},{"type":"question","questionText":"To copy distance $AB$ to line through $C$?","questionType":"multiple_choice","options":["Compass radius $AB$, arc from $C$","Protractor only","Guess and check","Erase $AB$"],"correctAnswer":"Compass radius $AB$, arc from $C$","explanation":"Transfer length."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'constructed_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Constructed Loci — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circle locus needs?', 'multiple_choice', '["Compass set to radius","Protractor only","Set square only","No tools"]'::jsonb, '"Compass set to radius"'::jsonb, 'easy', 'Draw arc/circle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circle locus needs?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perp. bisector uses arcs from?', 'multiple_choice', '["Both endpoints","Midpoint only","One endpoint","Origin only"]'::jsonb, '"Both endpoints"'::jsonb, 'easy', 'Equal radii.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perp. bisector uses arcs from?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Steps for angle bisector at $O$ include?', 'multiple_choice', '["Arc from $O$ cutting arms","Circle at random centre","Only straight line","Measure $90^\\circ$ only"]'::jsonb, '"Arc from $O$ cutting arms"'::jsonb, 'medium', 'Standard method.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Steps for angle bisector at $O$ include?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Locus $1.5$ cm from line $L$:', 'multiple_choice', '["Two parallel lines construct","One circle","Perp. bisector","Median"]'::jsonb, '"Two parallel lines construct"'::jsonb, 'medium', 'Offset each side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Locus $1.5$ cm from line $L$:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equal chords from $A$, $B$ in bisector construction imply?', 'multiple_choice', '["Equidistant from $A$, $B$","Parallel lines","Right angle at $A$","Same circle area"]'::jsonb, '"Equidistant from $A$, $B$"'::jsonb, 'medium', 'Arc property.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equal chords from $A$, $B$ in bisector construction imply?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Construct incircle of triangle: bisect?', 'multiple_choice', '["All three angles","One side only","External angles only","Medians only"]'::jsonb, '"All three angles"'::jsonb, 'hard', 'Incentre from bisectors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Construct incircle of triangle: bisect?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Region inside triangle closer to side $AB$ than $AC$ bounded by?', 'multiple_choice', '["Angle bisector at $A$","Perp. bisector of $BC$","Circle at $A$","Parallel to $BC$"]'::jsonb, '"Angle bisector at $A$"'::jsonb, 'hard', 'Equidistant from two sides meeting at $A$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='constructed_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Region inside triangle closer to side $AB$ than $AC$ bounded by?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Intersecting Loci — Concepts', '{"blocks":[{"type":"heading","content":"Regions from Two Loci"},{"type":"paragraph","content":"The **intersection** of two loci satisfies **both** conditions simultaneously — often finitely many points."},{"type":"callout","variant":"key_point","content":"Example: $2$ cm from $A$ AND $3$ cm from $B$ → intersection points of two circles."},{"type":"question","questionText":"Intersection of two loci gives points satisfying?","questionType":"multiple_choice","options":["Both conditions","Either condition only","Neither","Area only"],"correctAnswer":"Both conditions","explanation":"Logical AND."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'intersecting_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Intersecting Loci — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding Intersection Points', '{"blocks":[{"type":"heading","content":"Construction of Intersections"},{"type":"paragraph","content":"Draw both loci accurately. Mark points where they cross. Shade required region if asked (e.g. inside circle AND on one side of bisector)."},{"type":"example","title":"Circle centre $O$ radius $4$ cm and line perp. bisector of $OP$ — how many intersection points generally?","steps":["Typically $0$, $1$, or $2$ depending on geometry."],"answer":"Up to $2$ points"},{"type":"question","questionText":"Two circles radii $3$ and $5$, centres $4$ apart. How many intersections?","questionType":"multiple_choice","options":["$2$","$0$","Infinite","$4$"],"correctAnswer":"$2$","explanation":"Circles cross twice."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'intersecting_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding Intersection Points');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Intersecting Loci — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Intersecting Loci"},{"type":"example","title":"Farm problem: pump equidistant from wells $A$, $B$ and $2$ km from road (line).","steps":["Draw perp. bisector of $AB$.","Draw parallel lines $2$ km from road.","Mark intersection points."],"answer":"Candidate sites at intersections"},{"type":"callout","variant":"warning","content":"Read whether region must be **inside** or **outside** each locus."},{"type":"question","questionText":"Shaded region: inside circle AND closer to $A$ than $B$ uses?","questionType":"multiple_choice","options":["Circle and half-plane by bisector","Two circles only","Angle bisector only","Median"],"correctAnswer":"Circle and half-plane by bisector","explanation":"Combine conditions."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci' AND st.code = 'intersecting_loci'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Intersecting Loci — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Intersecting loci satisfy?', 'multiple_choice', '["Both conditions","One condition","No condition","Area formula"]'::jsonb, '"Both conditions"'::jsonb, 'easy', 'AND region.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Intersecting loci satisfy?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two circles may intersect at?', 'multiple_choice', '["$0$, $1$, or $2$ points","Always $4$","Always infinite","Never"]'::jsonb, '"$0$, $1$, or $2$ points"'::jsonb, 'easy', 'Relative positions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two circles may intersect at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pump equidistant from $A$, $B$ lies on?', 'multiple_choice', '["Perp. bisector of $AB$","Circle at $A$","Line parallel to $AB$ only","Angle at $C$"]'::jsonb, '"Perp. bisector of $AB$"'::jsonb, 'medium', 'Equal distance.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pump equidistant from $A$, $B$ lies on?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Region inside both circles centre $A$, $B$?', 'multiple_choice', '["Intersection of interiors","Union only","Outside both","Line segment $AB$"]'::jsonb, '"Intersection of interiors"'::jsonb, 'medium', 'Both radii.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Region inside both circles centre $A$, $B$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Garden: $3$ m from fence AND $5$ m from tap $T$. Number of possible beds generally?', 'multiple_choice', '["Up to $2$","Exactly $4$","Infinite on line","Zero always"]'::jsonb, '"Up to $2$"'::jsonb, 'hard', 'Circle-line/circle-circle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Garden: $3$ m from fence AND $5$ m from tap $T$. Number of possible beds generally?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Shade: closer to $A$ than $B$ AND within $4$ cm of $B$.', 'multiple_choice', '["Segment of circle near $A$ side","Whole circle","Outside circle","Perp. bisector only"]'::jsonb, '"Segment of circle near $A$ side"'::jsonb, 'hard', 'Combine half-plane and disc.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Shade: closer to $A$ than $B$ AND within $4$ cm of $B$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Locus points $5$ cm from $A$ AND $5$ cm from $B$ with $AB=10$ cm gives?', 'multiple_choice', '["Midpoint of $AB$ only","Two points always","Circle centre $A$","Infinite points"]'::jsonb, '"Midpoint of $AB$ only"'::jsonb, 'hard', 'Circles touch at midpoint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_loci'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='loci'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Locus points $5$ cm from $A$ AND $5$ cm from $B$ with $AB=10$ cm gives?');
-- ========== TRIGONOMETRY III ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Trig Ratios for General Angles', '{"blocks":[{"type":"heading","content":"ASTC Rule"},{"type":"paragraph","content":"Signs of $\\sin$, $\\cos$, $\\tan$ depend on quadrant: **A**ll positive in Q1, **S**in Q2, **T**an Q3, **C**os Q4."},{"type":"math_block","latex":"\\sin(180^\\circ-\\theta)=\\sin\\theta,\\quad \\cos(180^\\circ-\\theta)=-\\cos\\theta","caption":"Supplementary angles"},{"type":"callout","variant":"key_point","content":"Use reference acute angle in related quadrant."},{"type":"question","questionText":"$\\sin 150^\\circ$ equals?","questionType":"multiple_choice","options":["$\\frac{1}{2}$","$-\\frac{1}{2}$","$\\frac{\\sqrt{3}}{2}$","$-1$"],"correctAnswer":"$\\frac{1}{2}$","explanation":"Q2, sin positive."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_ratios_general'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Trig Ratios for General Angles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Related Angles and Identities', '{"blocks":[{"type":"heading","content":"Identities"},{"type":"math_block","latex":"\\sin^2\\theta+\\cos^2\\theta=1","caption":"Pythagorean identity"},{"type":"example","title":"$\\cos\\theta=-\\frac{3}{5}$, $\\theta$ in Q2. Find $\\sin\\theta$.","steps":["$\\sin^2=1-9/25=16/25$.","Q2: $\\sin$ positive → $\\frac{4}{5}$."],"answer":"$\\frac{4}{5}$"},{"type":"question","questionText":"$\\tan\\theta$ in terms of $\\sin$, $\\cos$?","questionType":"multiple_choice","options":["$\\frac{\\sin\\theta}{\\cos\\theta}$","$\\sin\\theta\\cos\\theta$","$1-\\cos\\theta$","$\\cos\\theta/\\sin\\theta$ always"],"correctAnswer":"$\\frac{\\sin\\theta}{\\cos\\theta}$","explanation":"Definition."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_ratios_general'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Related Angles and Identities');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'General Angles — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — General Angles"},{"type":"example","title":"Simplify $\\cos(360^\\circ-\\theta)$.","steps":["$\\cos\\theta$."],"answer":"$\\cos\\theta$"},{"type":"callout","variant":"warning","content":"State quadrant when finding sign of ratio."},{"type":"question","questionText":"$\\tan 225^\\circ$?","questionType":"multiple_choice","options":["$1$","$-1$","$0$","Undefined"],"correctAnswer":"$1$","explanation":"Q3, tan positive."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_ratios_general'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'General Angles — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'ASTC: Q2 sin is?', 'multiple_choice', '["Positive","Negative always","Zero only","Undefined"]'::jsonb, '"Positive"'::jsonb, 'easy', 'S in Q2.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='ASTC: Q2 sin is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin 30^\circ$?', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{\\sqrt{3}}{2}$","$1$","$0$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'easy', 'Special angle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin 30^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos 180^\circ$?', 'multiple_choice', '["$-1$","$1$","$0$","$\\frac{1}{2}$"]'::jsonb, '"$-1$"'::jsonb, 'easy', 'On negative $x$-axis.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos 180^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin 150^\circ$?', 'multiple_choice', '["$\\frac{1}{2}$","$-\\frac{1}{2}$","$\\frac{\\sqrt{3}}{2}$","$0$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', 'Reference $30^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin 150^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos\theta=\frac{5}{13}$, acute. $\sin\theta$?', 'multiple_choice', '["$\\frac{12}{13}$","$-\\frac{12}{13}$","$\\frac{5}{12}$","$\\frac{13}{5}$"]'::jsonb, '"$\\frac{12}{13}$"'::jsonb, 'medium', 'Pythagorean identity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos\theta=\frac{5}{13}$, acute. $\sin\theta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin^2\theta+\cos^2\theta$ for any $\theta$?', 'multiple_choice', '["$1$","$0$","$\\sin 2\\theta$","$2$"]'::jsonb, '"$1$"'::jsonb, 'hard', 'Identity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin^2\theta+\cos^2\theta$ for any $\theta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos\theta=-0.6$, Q3. $\sin\theta$?', 'multiple_choice', '["$-0.8$","$0.8$","$-0.6$","$1$"]'::jsonb, '"$-0.8$"'::jsonb, 'hard', 'Q3 sin negative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_ratios_general'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos\theta=-0.6$, Q3. $\sin\theta$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Trigonometric Equations — Concepts', '{"blocks":[{"type":"heading","content":"Solving $\\sin x = k$"},{"type":"paragraph","content":"Find reference angle, use symmetry to list solutions in given interval (often $0^\\circ\\le x\\le 360^\\circ$)."},{"type":"example","title":"$\\sin x=\\frac{1}{2}$, $0^\\circ\\le x\\le 360^\\circ$.","steps":["Reference $30^\\circ$.","$x=30^\\circ$ or $150^\\circ$."],"answer":"$30^\\circ, 150^\\circ$"},{"type":"question","questionText":"$\\cos x=0$ in $[0,360]$?","questionType":"multiple_choice","options":["$90^\\circ, 270^\\circ$","$0^\\circ, 180^\\circ$","$45^\\circ$ only","No solution"],"correctAnswer":"$90^\\circ, 270^\\circ$","explanation":"On axes."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_equations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Trigonometric Equations — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Trig Equations', '{"blocks":[{"type":"heading","content":"Methods"},{"type":"math_block","latex":"a\\sin x + b\\cos x = 0 \\Rightarrow \\tan x = -\\frac{b}{a}","caption":"When $\\cos x \\neq 0$"},{"type":"example","title":"$2\\cos x-1=0$, $0\\le x\\le 360^\\circ$.","steps":["$\\cos x=\\frac{1}{2}$.","$x=60^\\circ, 300^\\circ$."],"answer":"$60^\\circ, 300^\\circ$"},{"type":"callout","variant":"warning","content":"Check **all** solutions in interval — trig is periodic."},{"type":"question","questionText":"$\\tan x=1$ in Q1 only?","questionType":"multiple_choice","options":["$45^\\circ$","$90^\\circ$","$30^\\circ$","$180^\\circ$"],"correctAnswer":"$45^\\circ$","explanation":"Standard angle."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_equations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Trig Equations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Trig Equations — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Trig Equations"},{"type":"example","title":"$\\sin(2x)=\\frac{\\sqrt{3}}{2}$, $0\\le x\\le 180^\\circ$.","steps":["$2x=60^\\circ, 120^\\circ, ...$","$x=30^\\circ, 60^\\circ$."],"answer":"$30^\\circ, 60^\\circ$"},{"type":"callout","variant":"warning","content":"Factorise before solving when possible: $\\sin x\\cos x=0$."},{"type":"question","questionText":"$\\sin x=\\cos x$, $0\\le x\\le 90^\\circ$?","questionType":"multiple_choice","options":["$45^\\circ$","$0^\\circ$","$90^\\circ$","$30^\\circ$"],"correctAnswer":"$45^\\circ$","explanation":"$\\tan x=1$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'trig_equations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Trig Equations — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin x=1$ has solution?', 'multiple_choice', '["$90^\\circ$","$0^\\circ$","$180^\\circ$","$270^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'easy', 'Maximum sine.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin x=1$ has solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos x=\frac{1}{2}$ reference angle?', 'multiple_choice', '["$60^\\circ$","$30^\\circ$","$45^\\circ$","$90^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'easy', 'Special angle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos x=\frac{1}{2}$ reference angle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin x=\frac{1}{2}$, $0\le x\le 360^\circ$. Smallest positive?', 'multiple_choice', '["$30^\\circ$","$150^\\circ$","$210^\\circ$","$330^\\circ$"]'::jsonb, '"$30^\\circ$"'::jsonb, 'medium', 'Q1 solution.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin x=\frac{1}{2}$, $0\le x\le 360^\circ$. Smallest positive?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos x=-\frac{\sqrt{2}}{2}$ in $[0,360]$. One solution?', 'multiple_choice', '["$135^\\circ$","$45^\\circ$","$225^\\circ$ only listed","$315^\\circ$"]'::jsonb, '"$135^\\circ$"'::jsonb, 'medium', 'Q2/Q3 pair.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos x=-\frac{\sqrt{2}}{2}$ in $[0,360]$. One solution?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2\sin x-1=0$. $x$ in $[0,360]$ includes?', 'multiple_choice', '["$30^\\circ$ and $150^\\circ$","$60^\\circ$ only","$90^\\circ$ only","None"]'::jsonb, '"$30^\\circ$ and $150^\\circ$"'::jsonb, 'medium', 'Two solutions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2\sin x-1=0$. $x$ in $[0,360]$ includes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin x+\cos x=0$. $\tan x$?', 'multiple_choice', '["$-1$","$1$","$0$","Undefined always"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$\sin x=-\cos x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin x+\cos x=0$. $\tan x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin 2x=0$, $0\le x\le 180^\circ$. Number of solutions?', 'multiple_choice', '["$4$","$2$","$1$","$0$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$2x=0,180,360,540$...'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_equations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin 2x=0$, $0\le x\le 180^\circ$. Number of solutions?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Amplitude and Period — Concepts', '{"blocks":[{"type":"heading","content":"Graphs of $y=a\\sin bx$"},{"type":"paragraph","content":"**Amplitude** $=|a|$. **Period** $=\\frac{360^\\circ}{b}$ for degrees (or $\\frac{2\\pi}{b}$ radians)."},{"type":"math_block","latex":"y = a\\sin(bx+c) + d","caption":"Transformed sine curve"},{"type":"question","questionText":"$y=3\\sin x$ amplitude?","questionType":"multiple_choice","options":["$3$","$1$","$360^\\circ$","$\\frac{1}{3}$"],"correctAnswer":"$3$","explanation":"$|a|=3$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'amplitude_period'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Amplitude and Period — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Graph Transformations', '{"blocks":[{"type":"heading","content":"Period and Phase"},{"type":"example","title":"$y=\\sin 2x$. Period?","steps":["$360/2=180^\\circ$."],"answer":"$180^\\circ$"},{"type":"callout","variant":"warning","content":"Larger $b$ → shorter period (more cycles)."},{"type":"question","questionText":"$y=-2\\cos x$ amplitude?","questionType":"multiple_choice","options":["$2$","$-2$","$1$","$0$"],"correctAnswer":"$2$","explanation":"Absolute value."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'amplitude_period'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Graph Transformations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Amplitude & Period — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Graphs"},{"type":"example","title":"$y=\\sin(x-30^\\circ)$ shift?","steps":["Phase shift $+30^\\circ$ right."],"answer":"$30^\\circ$ right"},{"type":"callout","variant":"warning","content":"Sketch one full period and label max/min."},{"type":"question","questionText":"$y=\\cos 3x$ period (degrees)?","questionType":"multiple_choice","options":["$120^\\circ$","$360^\\circ$","$180^\\circ$","$60^\\circ$"],"correctAnswer":"$120^\\circ$","explanation":"$360/3$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii' AND st.code = 'amplitude_period'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Amplitude & Period — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Amplitude of $y=a\sin x$?', 'multiple_choice', '["$|a|$","$2a$","$360^\\circ$","$2\\pi$"]'::jsonb, '"$|a|$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Amplitude of $y=a\sin x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=\sin x$ period (degrees)?', 'multiple_choice', '["$360^\\circ$","$180^\\circ$","$90^\\circ$","$720^\\circ$"]'::jsonb, '"$360^\\circ$"'::jsonb, 'easy', 'Standard.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=\sin x$ period (degrees)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=\sin 2x$ period?', 'multiple_choice', '["$180^\\circ$","$360^\\circ$","$90^\\circ$","$720^\\circ$"]'::jsonb, '"$180^\\circ$"'::jsonb, 'medium', '$360/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=\sin 2x$ period?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=-3\cos x$ amplitude?', 'multiple_choice', '["$3$","$-3$","$1$","$0$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$|{-3}|$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=-3\cos x$ amplitude?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=\sin(x+90^\circ)$ is same as?', 'multiple_choice', '["$\\cos x$","$-\\cos x$","$\\sin x$","$-\\sin x$"]'::jsonb, '"$\\cos x$"'::jsonb, 'hard', 'Phase identity.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=\sin(x+90^\circ)$ is same as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=5\sin(2x-60^\circ)$ amplitude and period?', 'multiple_choice', '["$5$, $180^\\circ$","$2$, $360^\\circ$","$5$, $60^\\circ$","$3$, $180^\\circ$"]'::jsonb, '"$5$, $180^\\circ$"'::jsonb, 'hard', '$|5|$, $360/2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=5\sin(2x-60^\circ)$ amplitude and period?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y=\sin x$ and $y=\cos x$ first intersect for $x>0$?', 'multiple_choice', '["$45^\\circ$","$90^\\circ$","$0^\\circ$","$180^\\circ$"]'::jsonb, '"$45^\\circ$"'::jsonb, 'hard', '$\tan x=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='amplitude_period'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_iii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y=\sin x$ and $y=\cos x$ first intersect for $x>0$?');