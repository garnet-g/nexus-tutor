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


