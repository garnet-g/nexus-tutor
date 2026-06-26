-- KCSE Form 2 Mathematics — Wave 2 Batch 1
-- Topics: cubes_cube_roots, reciprocals, indices_logarithms, gradient_straight_lines, reflection_congruence
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== CUBES AND CUBE ROOTS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Cubes', '{"blocks":[{"type":"heading","content":"Understanding Cubes"},{"type":"paragraph","content":"The **cube** of a number is that number multiplied by itself three times: $n^3 = n \\times n \\times n$. For example, $4^3 = 64$."},{"type":"math_block","latex":"n^3 = n \\times n \\times n","caption":"Cubing a number"},{"type":"callout","variant":"key_point","content":"Cubing a negative number gives a negative result: $(-2)^3 = -8$."},{"type":"example","title":"Find $5^3$","steps":["$5 \\times 5 = 25$.","$25 \\times 5 = 125$."],"answer":"$125$"},{"type":"question","questionText":"Evaluate $3^3$.","questionType":"multiple_choice","options":["$27$","$9$","$6$","$81$"],"correctAnswer":"$27$","explanation":"$3 \\times 3 \\times 3 = 27$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cubes'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Cubes');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cubing Numbers — Methods', '{"blocks":[{"type":"heading","content":"Methods for Cubing"},{"type":"paragraph","content":"For small integers, multiply in stages. Memorise cubes of $1$ to $10$ for speed in KCSE."},{"type":"example","title":"Evaluate $12^3$","steps":["$12^2 = 144$.","$144 \\times 12 = 1728$."],"answer":"$1728$"},{"type":"callout","variant":"warning","content":"$(-3)^3 = -27$ but $-3^3 = -27$ only if brackets are clear — always use brackets with negatives."},{"type":"question","questionText":"Evaluate $(-4)^3$.","questionType":"multiple_choice","options":["$-64$","$64$","$-12$","$12$"],"correctAnswer":"$-64$","explanation":"$(-4) \\times (-4) \\times (-4) = -64$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cubes'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cubing Numbers — Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cubes in KCSE Questions', '{"blocks":[{"type":"heading","content":"Exam Applications — Cubes"},{"type":"example","title":"A cube-shaped box has side $6$ cm. Find its volume.","steps":["Volume $= 6^3 = 216$ cm$^3$."],"answer":"$216$ cm$^3$"},{"type":"callout","variant":"warning","content":"Volume of a cube uses cubing the side, not multiplying by $3$."},{"type":"question","questionText":"The cube of which number is $125$?","questionType":"multiple_choice","options":["$5$","$25$","$15$","$35$"],"correctAnswer":"$5$","explanation":"$5^3 = 125$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cubes'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cubes in KCSE Questions');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Introduction to Cube Roots', '{"blocks":[{"type":"heading","content":"Cube Roots"},{"type":"paragraph","content":"The **cube root** of $n$, written $\\sqrt[3]{n}$, is the number that cubes to $n$. Example: $\\sqrt[3]{27} = 3$."},{"type":"math_block","latex":"\\sqrt[3]{n} = x \\text{ when } x^3 = n","caption":"Cube root definition"},{"type":"callout","variant":"key_point","content":"Cube roots of negative numbers are negative: $\\sqrt[3]{-8} = -2$."},{"type":"example","title":"Evaluate $\\sqrt[3]{64}$","steps":["$4^3 = 64$, so $\\sqrt[3]{64} = 4$."],"answer":"$4$"},{"type":"question","questionText":"Evaluate $\\sqrt[3]{1}$.","questionType":"multiple_choice","options":["$1$","$0$","$3$","$-1$"],"correctAnswer":"$1$","explanation":"$1^3 = 1$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Introduction to Cube Roots');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cube Roots by Prime Factorisation', '{"blocks":[{"type":"heading","content":"Factorisation Method"},{"type":"paragraph","content":"Express the number as prime factors and group factors in triples."},{"type":"example","title":"Evaluate $\\sqrt[3]{216}$","steps":["$216 = 2^3 \\times 3^3$.","One triple of each prime: $2 \\times 3 = 6$."],"answer":"$6$"},{"type":"callout","variant":"warning","content":"Perfect cubes have powers divisible by $3$ for every prime factor."},{"type":"question","questionText":"Evaluate $\\sqrt[3]{8}$.","questionType":"multiple_choice","options":["$2$","$4$","$16$","$3$"],"correctAnswer":"$2$","explanation":"$2^3 = 8$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cube Roots by Prime Factorisation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Exam Problems — Cube Root Factor Method', '{"blocks":[{"type":"heading","content":"KCSE Factor Problems"},{"type":"example","title":"Evaluate $\\sqrt[3]{3375}$","steps":["$3375 = 15^3$.","$\\sqrt[3]{3375} = 15$."],"answer":"$15$"},{"type":"question","questionText":"Evaluate $\\sqrt[3]{-27}$.","questionType":"multiple_choice","options":["$-3$","$3$","$-9$","$9$"],"correctAnswer":"$-3$","explanation":"$(-3)^3 = -27$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Exam Problems — Cube Root Factor Method');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cube Root Tables', '{"blocks":[{"type":"heading","content":"Using Cube Root Tables"},{"type":"paragraph","content":"Tables list $\\sqrt[3]{N}$ for various $N$. Use them for exact perfect cubes and approximations otherwise."},{"type":"example","title":"Read $\\sqrt[3]{10}$ from a table","steps":["Locate $10$ in the table.","$\\sqrt[3]{10} \\approx 2.154$."],"answer":"$2.154$"},{"type":"question","questionText":"Is $27$ a perfect cube?","questionType":"multiple_choice","options":["Yes","No","Only if negative","Cannot tell"],"correctAnswer":"Yes","explanation":"$27 = 3^3$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cube Root Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Estimating Cube Roots', '{"blocks":[{"type":"heading","content":"Estimation"},{"type":"example","title":"Between which integers is $\\sqrt[3]{50}$?","steps":["$3^3 = 27$, $4^3 = 64$.","Between $3$ and $4$, closer to $4$."],"answer":"$3$ and $4$"},{"type":"question","questionText":"Between which integers does $\\sqrt[3]{100}$ lie?","questionType":"multiple_choice","options":["$4$ and $5$","$3$ and $4$","$5$ and $6$","$9$ and $10$"],"correctAnswer":"$4$ and $5$","explanation":"$64 < 100 < 125$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Estimating Cube Roots');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cube Root Table Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"A cube has volume $500$ cm$^3$. Estimate the side length.","steps":["$7^3 = 343$, $8^3 = 512$.","Side $\\approx 7.9$ cm."],"answer":"$\\approx 7.9$ cm"},{"type":"question","questionText":"Is $\\sqrt[3]{125}$ exact from a table?","questionType":"multiple_choice","options":["Yes, $5$","Approximate only","No","Cannot tell"],"correctAnswer":"Yes, $5$","explanation":"$125 = 5^3$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots' AND st.code = 'cube_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cube Root Table Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $4^3$.', 'multiple_choice', '["$64$","$12$","$16$","$48$"]'::jsonb, '"$64$"'::jsonb, 'easy', '$4 \times 4 \times 4 = 64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $4^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-2)^3$.', 'multiple_choice', '["$-8$","$8$","$-6$","$6$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Negative cubed stays negative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2)^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a perfect cube?', 'multiple_choice', '["$27$","$25$","$18$","$32$"]'::jsonb, '"$27$"'::jsonb, 'easy', '$27 = 3^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a perfect cube?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $10^3$.', 'multiple_choice', '["$1000$","$30$","$100$","$300$"]'::jsonb, '"$1000$"'::jsonb, 'easy', '$10 \times 10 \times 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{64}$.', 'multiple_choice', '["$4$","$8$","$2$","$16$"]'::jsonb, '"$4$"'::jsonb, 'easy', '$4^3 = 64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{64}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{125}$.', 'multiple_choice', '["$5$","$25$","$15$","$35$"]'::jsonb, '"$5$"'::jsonb, 'easy', '$5^3 = 125$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{125}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{1000}$.', 'multiple_choice', '["$10$","$100$","$30$","$33$"]'::jsonb, '"$10$"'::jsonb, 'easy', '$10^3 = 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{1000}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $64$ a perfect cube?', 'multiple_choice', '["Yes","No","Only negative","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'easy', '$64 = 4^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $64$ a perfect cube?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $15^3$.', 'multiple_choice', '["$3375$","$225$","$45$","$315$"]'::jsonb, '"$3375$"'::jsonb, 'medium', '$15^2 = 225$; $225 \times 15 = 3375$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A cube has side $7$ cm. Volume?', 'multiple_choice', '["$343$ cm$^3$","$21$ cm$^3$","$49$ cm$^3$","$147$ cm$^3$"]'::jsonb, '"$343$ cm$^3$"'::jsonb, 'medium', '$7^3 = 343$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A cube has side $7$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{512}$.', 'multiple_choice', '["$8$","$16$","$4$","$6$"]'::jsonb, '"$8$"'::jsonb, 'medium', '$8^3 = 512$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{512}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{-64}$.', 'multiple_choice', '["$-4$","$4$","$-8$","$8$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$(-4)^3 = -64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{-64}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Between which integers is $\sqrt[3]{200}$?', 'multiple_choice', '["$5$ and $6$","$4$ and $5$","$6$ and $7$","$14$ and $15$"]'::jsonb, '"$5$ and $6$"'::jsonb, 'medium', '$125 < 200 < 216$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Between which integers is $\sqrt[3]{200}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\sqrt[3]{30}$ to nearest integer.', 'multiple_choice', '["$3$","$4$","$5$","$6$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$27 < 30 < 64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\sqrt[3]{30}$ to nearest integer.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $x^3 = 729$, find $x$.', 'multiple_choice', '["$9$","$27$","$81$","$3$"]'::jsonb, '"$9$"'::jsonb, 'medium', '$9^3 = 729$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $x^3 = 729$, find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{1728}$.', 'multiple_choice', '["$12$","$6$","$18$","$24$"]'::jsonb, '"$12$"'::jsonb, 'medium', '$12^3 = 1728$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{1728}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'The volume of a cube is $9261$ cm$^3$. Find the side length.', 'multiple_choice', '["$21$ cm","$31$ cm","$19$ cm","$27$ cm"]'::jsonb, '"$21$ cm"'::jsonb, 'hard', '$21^3 = 9261$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='The volume of a cube is $9261$ cm$^3$. Find the side length.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-5)^3 + 2^3$.', 'multiple_choice', '["$-117$","$-123$","$117$","$-125$"]'::jsonb, '"$-117$"'::jsonb, 'hard', '$-125 + 8 = -117$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-5)^3 + 2^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt[3]{2744}$.', 'multiple_choice', '["$14$","$7$","$28$","$49$"]'::jsonb, '"$14$"'::jsonb, 'hard', '$14^3 = 2744$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt[3]{2744}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $\sqrt[3]{x} = -6$, find $x$.', 'multiple_choice', '["$-216$","$216$","$-36$","$36$"]'::jsonb, '"$-216$"'::jsonb, 'hard', '$(-6)^3 = -216$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $\sqrt[3]{x} = -6$, find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A tank holds $8000$ litres. If cubic, side length?', 'multiple_choice', '["$20$ m if litres = dm$^3$ scale","$20$ dm","$80$ dm","$200$ dm"]'::jsonb, '"$20$ dm"'::jsonb, 'hard', '$\sqrt[3]{8000} = 20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A tank holds $8000$ litres. If cubic, side length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube root of $0.027$?', 'multiple_choice', '["$0.3$","$0.03$","$3$","$0.9$"]'::jsonb, '"$0.3$"'::jsonb, 'hard', '$(0.3)^3 = 0.027$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cube_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube root of $0.027$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $2^3 \times 3^3$.', 'multiple_choice', '["$216$","$36$","$64$","$27$"]'::jsonb, '"$216$"'::jsonb, 'hard', '$8 \times 27 = 216$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cubes'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='cubes_cube_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $2^3 \times 3^3$.');


-- ========== RECIPROCALS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'What Is a Reciprocal?', '{"blocks":[{"type":"heading","content":"What Is a Reciprocal?"},{"type":"paragraph","content":"The **reciprocal** of a non-zero number $a$ is $\\frac{1}{a}$. Multiplying a number by its reciprocal gives $1$: $a \\times \\frac{1}{a} = 1$."},{"type":"math_block","latex":"\\text{reciprocal of } a = \\frac{1}{a}","caption":"Definition"},{"type":"callout","variant":"key_point","content":"Zero has no reciprocal."},{"type":"example","title":"Find the reciprocal of $5$","steps":["Reciprocal $= \\frac{1}{5}$."],"answer":"$\\frac{1}{5}$"},{"type":"question","questionText":"Reciprocal of $8$?","questionType":"multiple_choice","options":["$\\frac{1}{8}$","$8$","$-8$","$0$"],"correctAnswer":"$\\frac{1}{8}$","explanation":"$8 \\times \\frac{1}{8} = 1$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'reciprocals_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'What Is a Reciprocal?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocals Using Tables', '{"blocks":[{"type":"heading","content":"Reciprocal Tables"},{"type":"paragraph","content":"Tables list reciprocals of integers. Locate the number and read $\\frac{1}{n}$."},{"type":"example","title":"Use a table: reciprocal of $25$","steps":["$\\frac{1}{25} = 0.04$."],"answer":"$0.04$"},{"type":"callout","variant":"warning","content":"Do not confuse reciprocal with opposite (negative)."},{"type":"question","questionText":"Reciprocal of $4$?","questionType":"multiple_choice","options":["$0.25$","$4$","$-4$","$2$"],"correctAnswer":"$0.25$","explanation":"$\\frac{1}{4} = 0.25$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'reciprocals_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocals Using Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocal Tables — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"A recipe for $8$ people uses $2$ kg flour. Flour per person?","steps":["$\\frac{2}{8} = 0.25$ kg — reciprocal thinking: $\\frac{1}{8}$ of total per person scaled."],"answer":"$0.25$ kg per person"},{"type":"question","questionText":"Reciprocal of $\\frac{1}{3}$?","questionType":"multiple_choice","options":["$3$","$\\frac{1}{3}$","$-3$","$0$"],"correctAnswer":"$3$","explanation":"Reciprocal of a fraction swaps numerator and denominator."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'reciprocals_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocal Tables — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Dividing Using Reciprocals', '{"blocks":[{"type":"heading","content":"Division via Reciprocals"},{"type":"paragraph","content":"Dividing by a number equals multiplying by its reciprocal: $a \\div b = a \\times \\frac{1}{b}$."},{"type":"math_block","latex":"a \\div b = a \\times \\frac{1}{b}","caption":"Division rule"},{"type":"example","title":"Evaluate $12 \\div \\frac{3}{4}$","steps":["Reciprocal of $\\frac{3}{4}$ is $\\frac{4}{3}$.","$12 \\times \\frac{4}{3} = 16$."],"answer":"$16$"},{"type":"question","questionText":"$6 \\div 2$ using reciprocals?","questionType":"multiple_choice","options":["$6 \\times \\frac{1}{2} = 3$","$12$","$3$","$4$"],"correctAnswer":"$6 \\times \\frac{1}{2} = 3$","explanation":"Multiply by reciprocal."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'operations_reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Dividing Using Reciprocals');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations with Reciprocals', '{"blocks":[{"type":"heading","content":"Worked Operations"},{"type":"example","title":"Evaluate $\\frac{2}{5} \\div \\frac{4}{7}$","steps":["$\\frac{2}{5} \\times \\frac{7}{4} = \\frac{14}{20} = \\frac{7}{10}$."],"answer":"$\\frac{7}{10}$"},{"type":"example","title":"Simplify $3 \\div \\frac{1}{6}$","steps":["$3 \\times 6 = 18$."],"answer":"$18$"},{"type":"callout","variant":"warning","content":"Invert the second fraction only when dividing fractions."},{"type":"question","questionText":"$\\frac{1}{2} \\div \\frac{1}{4}$?","questionType":"multiple_choice","options":["$2$","$\\frac{1}{8}$","$4$","$\\frac{1}{2}$"],"correctAnswer":"$2$","explanation":"$\\frac{1}{2} \\times 4 = 2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'operations_reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations with Reciprocals');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocal Operations — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Operations"},{"type":"example","title":"Share KES $240$ among workers at rate $\\frac{2}{3}$ of a unit each. How many units?","steps":["$240 \\div \\frac{2}{3} = 240 \\times \\frac{3}{2} = 360$."],"answer":"$360$ units"},{"type":"question","questionText":"$\\frac{3}{8} \\div \\frac{9}{16}$?","questionType":"multiple_choice","options":["$\\frac{2}{3}$","$\\frac{27}{128}$","$\\frac{3}{2}$","$\\frac{4}{3}$"],"correctAnswer":"$\\frac{2}{3}$","explanation":"Multiply by reciprocal $\\frac{16}{9}$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'operations_reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocal Operations — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocals in Rates', '{"blocks":[{"type":"heading","content":"Rates and Reciprocals"},{"type":"paragraph","content":"Speed $= \\frac{\\text{distance}}{\\text{time}}$. Time $= \\frac{\\text{distance}}{\\text{speed}}$ — the reciprocal relationship."},{"type":"example","title":"A car travels $120$ km in $2$ h. Speed?","steps":["$\\frac{120}{2} = 60$ km/h."],"answer":"$60$ km/h"},{"type":"question","questionText":"Time to cover $90$ km at $30$ km/h?","questionType":"multiple_choice","options":["$3$ h","$2700$ h","$0.33$ h","$60$ h"],"correctAnswer":"$3$ h","explanation":"$90 \\div 30 = 3$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocals in Rates');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocals in Proportion', '{"blocks":[{"type":"heading","content":"Inverse Proportion"},{"type":"paragraph","content":"If $y$ is inversely proportional to $x$, then $y = \\frac{k}{x}$ — reciprocal relationship."},{"type":"example","title":"$y$ varies inversely with $x$. When $x = 4$, $y = 6$. Find $y$ when $x = 8$.","steps":["$k = 24$.","$y = \\frac{24}{8} = 3$."],"answer":"$3$"},{"type":"question","questionText":"If $6$ workers take $10$ days, how long for $12$ workers (inverse)?","questionType":"multiple_choice","options":["$5$ days","$20$ days","$60$ days","$2$ days"],"correctAnswer":"$5$ days","explanation":"Double workers, half time."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocals in Proportion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reciprocal Applications — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Applications"},{"type":"example","title":"A pump fills a tank in $4$ h. What fraction of the tank per hour?","steps":["$\\frac{1}{4}$ of the tank per hour."],"answer":"$\\frac{1}{4}$"},{"type":"callout","variant":"warning","content":"Rate per hour is the reciprocal of total hours for one whole job."},{"type":"question","questionText":"Pipe A fills tank in $6$ h, Pipe B in $3$ h. Together, hours to fill?","questionType":"multiple_choice","options":["$2$ h","$9$ h","$4.5$ h","$1$ h"],"correctAnswer":"$2$ h","explanation":"Rates $\\frac{1}{6} + \\frac{1}{3} = \\frac{1}{2}$ per hour."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals' AND st.code = 'applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reciprocal Applications — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $10$?', 'multiple_choice', '["$0.1$","$10$","$-10$","$1$"]'::jsonb, '"$0.1$"'::jsonb, 'easy', '$\frac{1}{10} = 0.1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $10$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $\frac{1}{5}$?', 'multiple_choice', '["$5$","$\\frac{1}{5}$","$0.5$","$-5$"]'::jsonb, '"$5$"'::jsonb, 'easy', 'Flip the fraction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $\frac{1}{5}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $2$?', 'multiple_choice', '["$0.5$","$2$","$-2$","$1$"]'::jsonb, '"$0.5$"'::jsonb, 'easy', '$\frac{1}{2} = 0.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$8 \div 4$ via reciprocal?', 'multiple_choice', '["$8 \\times \\frac{1}{4} = 2$","$32$","$4$","$2$"]'::jsonb, '"$8 \\times \\frac{1}{4} = 2$"'::jsonb, 'easy', 'Multiply by $\frac{1}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$8 \div 4$ via reciprocal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{1}{3} \div \frac{1}{3}$?', 'multiple_choice', '["$1$","$\\frac{1}{9}$","$9$","$0$"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Same number divided by itself.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{1}{3} \div \frac{1}{3}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $5$ machines take $1$ day, one machine takes?', 'multiple_choice', '["$5$ days","$\\frac{1}{5}$ day","$1$ day","$0$ days"]'::jsonb, '"$5$ days"'::jsonb, 'easy', 'Inverse proportion.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $5$ machines take $1$ day, one machine takes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Speed $40$ km/h for $2$ h. Distance?', 'multiple_choice', '["$80$ km","$20$ km","$42$ km","$0.05$ km"]'::jsonb, '"$80$ km"'::jsonb, 'easy', '$40 \times 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Speed $40$ km/h for $2$ h. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Product of $7$ and its reciprocal?', 'multiple_choice', '["$1$","$7$","$49$","$0$"]'::jsonb, '"$1$"'::jsonb, 'easy', '$a \times \frac{1}{a} = 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Product of $7$ and its reciprocal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $-0.25$?', 'multiple_choice', '["$-4$","$4$","$-0.25$","$0.25$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$\frac{1}{-0.25} = -4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $-0.25$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{5}{6} \div \frac{10}{9}$?', 'multiple_choice', '["$\\frac{3}{4}$","$\\frac{50}{54}$","$\\frac{4}{3}$","$\\frac{15}{19}$"]'::jsonb, '"$\\frac{3}{4}$"'::jsonb, 'medium', '$\frac{5}{6} \times \frac{9}{10}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{5}{6} \div \frac{10}{9}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2\frac{1}{2} \div \frac{1}{4}$?', 'multiple_choice', '["$10$","$\\frac{5}{8}$","$2$","$6$"]'::jsonb, '"$10$"'::jsonb, 'medium', '$\frac{5}{2} \times 4 = 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2\frac{1}{2} \div \frac{1}{4}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y \propto \frac{1}{x}$. $x=5$, $y=12$. Find $y$ when $x=10$.', 'multiple_choice', '["$6$","$24$","$60$","$2.4$"]'::jsonb, '"$6$"'::jsonb, 'medium', '$k=60$; $y=6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y \propto \frac{1}{x}$. $x=5$, $y=12$. Find $y$ when $x=10$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tank filled in $8$ h. Fraction per hour?', 'multiple_choice', '["$\\frac{1}{8}$","$8$","$\\frac{1}{4}$","$0.8$"]'::jsonb, '"$\\frac{1}{8}$"'::jsonb, 'medium', 'One whole in 8 hours.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tank filled in $8$ h. Fraction per hour?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $0.02$?', 'multiple_choice', '["$50$","$20$","$0.5$","$5$"]'::jsonb, '"$50$"'::jsonb, 'medium', '$\frac{1}{0.02} = 50$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $0.02$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{3}{4} \div 6$?', 'multiple_choice', '["$\\frac{1}{8}$","$\\frac{18}{4}$","$8$","$\\frac{3}{24}$"]'::jsonb, '"$\\frac{1}{8}$"'::jsonb, 'medium', '$\frac{3}{4} \times \frac{1}{6}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{3}{4} \div 6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$12 \div \frac{3}{5}$?', 'multiple_choice', '["$20$","$\\frac{36}{5}$","$7.2$","$4$"]'::jsonb, '"$20$"'::jsonb, 'medium', '$12 \times \frac{5}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$12 \div \frac{3}{5}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pipes: $A$ fills in $12$ h, $B$ in $4$ h. Together?', 'multiple_choice', '["$3$ h","$8$ h","$16$ h","$2$ h"]'::jsonb, '"$3$ h"'::jsonb, 'hard', '$\frac{1}{12}+\frac{1}{4}=\frac{1}{3}$ per h.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pipes: $A$ fills in $12$ h, $B$ in $4$ h. Together?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$8$ men build a wall in $15$ days. How many men for $10$ days?', 'multiple_choice', '["$12$","$6$","$20$","$80$"]'::jsonb, '"$12$"'::jsonb, 'hard', '$8 \times 15 = 120$ man-days.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$8$ men build a wall in $15$ days. How many men for $10$ days?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sum of reciprocals of $2$ and $5$?', 'multiple_choice', '["$\\frac{7}{10}$","$\\frac{1}{7}$","$7$","$\\frac{3}{10}$"]'::jsonb, '"$\\frac{7}{10}$"'::jsonb, 'hard', '$\frac{1}{2}+\frac{1}{5}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sum of reciprocals of $2$ and $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{2}{3} \div \frac{4}{9} \times \frac{1}{2}$?', 'multiple_choice', '["$\\frac{3}{4}$","$\\frac{4}{3}$","$\\frac{1}{3}$","$1$"]'::jsonb, '"$\\frac{3}{4}$"'::jsonb, 'hard', 'Left to right with reciprocals.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{2}{3} \div \frac{4}{9} \times \frac{1}{2}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Car uses $1$ litre per $12$ km. Litres for $150$ km?', 'multiple_choice', '["$12.5$","$18$","$150$","$0.08$"]'::jsonb, '"$12.5$"'::jsonb, 'hard', '$150 \div 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Car uses $1$ litre per $12$ km. Litres for $150$ km?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1 \div (\frac{1}{2} + \frac{1}{3})$.', 'multiple_choice', '["$\\frac{6}{5}$","$\\frac{5}{6}$","$5$","$6$"]'::jsonb, '"$\\frac{6}{5}$"'::jsonb, 'hard', '$1 \div \frac{5}{6}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_reciprocals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1 \div (\frac{1}{2} + \frac{1}{3})$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reciprocal of $0.125$?', 'multiple_choice', '["$8$","$0.8$","$80$","$1.25$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$\frac{1}{0.125} = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reciprocals_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reciprocals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reciprocal of $0.125$?');


