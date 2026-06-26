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


-- ========== INDICES AND LOGARITHMS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Index Notation', '{"blocks":[{"type":"heading","content":"Index Notation"},{"type":"paragraph","content":"**Indices** (powers) show repeated multiplication: $a^n = a \\times a \\times \\cdots \\times a$ ($n$ times)."},{"type":"math_block","latex":"a^m \\times a^n = a^{m+n}","caption":"Product law"},{"type":"callout","variant":"key_point","content":"Any non-zero number to power $0$ equals $1$: $5^0 = 1$."},{"type":"example","title":"Simplify $2^3 \\times 2^4$","steps":["Add indices: $2^{3+4} = 2^7 = 128$."],"answer":"$2^7$"},{"type":"question","questionText":"$3^2 \\times 3^3$?","questionType":"multiple_choice","options":["$3^5$","$3^6$","$9^5$","$3^1$"],"correctAnswer":"$3^5$","explanation":"Add powers."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'laws_of_indices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Index Notation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Laws of Indices — Methods', '{"blocks":[{"type":"heading","content":"Index Laws"},{"type":"math_block","latex":"\\frac{a^m}{a^n} = a^{m-n}, \\quad (a^m)^n = a^{mn}","caption":"Quotient and power laws"},{"type":"example","title":"Simplify $\\frac{5^7}{5^4}$","steps":["$5^{7-4} = 5^3 = 125$."],"answer":"$5^3$"},{"type":"example","title":"Evaluate $(2^3)^2$","steps":["$2^{3 \\times 2} = 2^6 = 64$."],"answer":"$2^6$"},{"type":"callout","variant":"warning","content":"$(a+b)^2 \\neq a^2 + b^2$ — indices do not distribute over addition."},{"type":"question","questionText":"$\\frac{10^5}{10^2}$?","questionType":"multiple_choice","options":["$10^3$","$10^7$","$10^{2.5}$","$5^3$"],"correctAnswer":"$10^3$","explanation":"Subtract indices."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'laws_of_indices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Laws of Indices — Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Indices — Exam Application', '{"blocks":[{"type":"heading","content":"KCSE Index Problems"},{"type":"example","title":"Simplify $\\frac{2^4 \\times 2^{-1}}{2^2}$","steps":["Numerator: $2^3$.","$\\frac{2^3}{2^2} = 2^1 = 2$."],"answer":"$2$"},{"type":"question","questionText":"Evaluate $4^{-1}$.","questionType":"multiple_choice","options":["$\\frac{1}{4}$","$-4$","$4$","$0$"],"correctAnswer":"$\\frac{1}{4}$","explanation":"Negative index = reciprocal."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'laws_of_indices'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Indices — Exam Application');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Standard Form Concept', '{"blocks":[{"type":"heading","content":"Standard Form"},{"type":"paragraph","content":"**Standard form** writes numbers as $a \\times 10^n$ where $1 \\le a < 10$ and $n$ is an integer."},{"type":"math_block","latex":"N = a \\times 10^n, \\quad 1 \\le a < 10","caption":"Standard form"},{"type":"example","title":"Write $4500$ in standard form","steps":["$4500 = 4.5 \\times 10^3$."],"answer":"$4.5 \\times 10^3$"},{"type":"question","questionText":"Write $0.006$ in standard form.","questionType":"multiple_choice","options":["$6 \\times 10^{-3}$","$6 \\times 10^3$","$0.6 \\times 10^{-2}$","$60 \\times 10^{-4}$"],"correctAnswer":"$6 \\times 10^{-3}$","explanation":"$a$ must be between $1$ and $10$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'standard_form'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Standard Form Concept');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations in Standard Form', '{"blocks":[{"type":"heading","content":"Calculations"},{"type":"example","title":"Multiply $(3 \\times 10^4) \\times (2 \\times 10^3)$","steps":["$(3 \\times 2) \\times 10^{4+3} = 6 \\times 10^7$."],"answer":"$6 \\times 10^7$"},{"type":"example","title":"Divide $(8 \\times 10^6) \\div (2 \\times 10^2)$","steps":["$4 \\times 10^{6-2} = 4 \\times 10^4$."],"answer":"$4 \\times 10^4$"},{"type":"question","questionText":"$(5 \\times 10^2) \\times (4 \\times 10^1)$?","questionType":"multiple_choice","options":["$2 \\times 10^3$","$20 \\times 10^3$","$9 \\times 10^3$","$2 \\times 10^2$"],"correctAnswer":"$2 \\times 10^3$","explanation":"Multiply coefficients and add powers."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'standard_form'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations in Standard Form');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Standard Form — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Light travels $3 \\times 10^8$ m/s. Distance in $2 \\times 10^{-3}$ s?","steps":["$(3 \\times 2) \\times 10^{8-3} = 6 \\times 10^5$ m."],"answer":"$6 \\times 10^5$ m"},{"type":"callout","variant":"warning","content":"Adjust $a$ if product coefficient $\\ge 10$."},{"type":"question","questionText":"Population $2.5 \\times 10^7$. Write ordinary form.","questionType":"multiple_choice","options":["$25000000$","$2500000$","$250000$","$250000000$"],"correctAnswer":"$25000000$","explanation":"Move decimal 7 places."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'standard_form'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Standard Form — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Introduction to Logarithms', '{"blocks":[{"type":"heading","content":"Logarithms"},{"type":"paragraph","content":"If $b^x = N$, then $\\log_b N = x$. Logs are the **inverse** of indices."},{"type":"math_block","latex":"\\log_b N = x \\Leftrightarrow b^x = N","caption":"Definition"},{"type":"callout","variant":"key_point","content":"Common logs use base $10$: $\\log_{10} 100 = 2$ because $10^2 = 100$."},{"type":"example","title":"Evaluate $\\log_{10} 1000$","steps":["$10^3 = 1000$, so $\\log_{10} 1000 = 3$."],"answer":"$3$"},{"type":"question","questionText":"$\\log_{10} 1$?","questionType":"multiple_choice","options":["$0$","$1$","$10$","Undefined"],"correctAnswer":"$0$","explanation":"$10^0 = 1$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'logarithms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Introduction to Logarithms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Logarithm Laws', '{"blocks":[{"type":"heading","content":"Laws of Logarithms"},{"type":"math_block","latex":"\\log(AB) = \\log A + \\log B, \\quad \\log\\left(\\frac{A}{B}\\right) = \\log A - \\log B","caption":"Product and quotient laws"},{"type":"example","title":"Simplify $\\log 50 + \\log 2$","steps":["$\\log(50 \\times 2) = \\log 100 = 2$."],"answer":"$2$"},{"type":"example","title":"Evaluate $\\log 1000 - \\log 10$","steps":["$\\log\\left(\\frac{1000}{10}\\right) = \\log 100 = 2$."],"answer":"$2$"},{"type":"question","questionText":"$\\log 8 + \\log 5$?","questionType":"multiple_choice","options":["$\\log 40$","$\\log 13$","$\\log 3$","$40$"],"correctAnswer":"$\\log 40$","explanation":"Product law."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'logarithms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Logarithm Laws');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Logarithms — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Log Problems"},{"type":"example","title":"Solve $10^x = 500$ using logs","steps":["$x = \\log_{10} 500 \\approx 2.70$."],"answer":"$x \\approx 2.70$"},{"type":"example","title":"Find $\\log_{10} 0.01$","steps":["$10^{-2} = 0.01$, so $\\log = -2$."],"answer":"$-2$"},{"type":"callout","variant":"warning","content":"$\\log(a+b) \\neq \\log a + \\log b$ — product law only for multiplication."},{"type":"question","questionText":"$\\log_{10} 0.001$?","questionType":"multiple_choice","options":["$-3$","$3$","$-0.001$","$0.001$"],"correctAnswer":"$-3$","explanation":"$10^{-3} = 0.001$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms' AND st.code = 'logarithms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Logarithms — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $2^5 \times 2^2$.', 'multiple_choice', '["$2^7$","$2^3$","$4^7$","$2^{10}$"]'::jsonb, '"$2^7$"'::jsonb, 'easy', 'Add indices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $2^5 \times 2^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $5^0$.', 'multiple_choice', '["$1$","$0$","$5$","Undefined"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Any non-zero to power 0 is 1.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $5^0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $3^{-2}$.', 'multiple_choice', '["$\\frac{1}{9}$","$-9$","$9$","$\\frac{1}{6}$"]'::jsonb, '"$\\frac{1}{9}$"'::jsonb, 'easy', 'Negative index = reciprocal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $3^{-2}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $7000$ in standard form.', 'multiple_choice', '["$7 \\times 10^3$","$7 \\times 10^4$","$70 \\times 10^2$","$0.7 \\times 10^4$"]'::jsonb, '"$7 \\times 10^3$"'::jsonb, 'easy', '$1 \le a < 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $7000$ in standard form.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $3.2 \times 10^2$ in ordinary form.', 'multiple_choice', '["$320$","$32$","$3200$","$0.32$"]'::jsonb, '"$320$"'::jsonb, 'easy', 'Move decimal 2 places.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $3.2 \times 10^2$ in ordinary form.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\log_{10} 100$.', 'multiple_choice', '["$2$","$10$","$100$","$1$"]'::jsonb, '"$2$"'::jsonb, 'easy', '$10^2 = 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\log_{10} 100$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $10^4 = 10000$, then $\log_{10} 10000 = ?$', 'multiple_choice', '["$4$","$10000$","$10$","$40$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Log is the index.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $10^4 = 10000$, then $\log_{10} 10000 = ?$');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(2^2)^3$.', 'multiple_choice', '["$2^6$","$2^5$","$2^8$","$64^2$"]'::jsonb, '"$2^6$"'::jsonb, 'easy', 'Multiply indices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(2^2)^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{x^8}{x^3}$.', 'multiple_choice', '["$x^5$","$x^{11}$","$x^{24}$","$x^3$"]'::jsonb, '"$x^5$"'::jsonb, 'medium', 'Subtract indices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{x^8}{x^3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3^4 \times 3^{-2}}{3}$.', 'multiple_choice', '["$3^1$","$3^6$","$3^7$","$9$"]'::jsonb, '"$3^1$"'::jsonb, 'medium', '$3^{4-2-1} = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3^4 \times 3^{-2}}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $0.00045$ in standard form.', 'multiple_choice', '["$4.5 \\times 10^{-4}$","$4.5 \\times 10^4$","$45 \\times 10^{-5}$","$0.45 \\times 10^{-3}$"]'::jsonb, '"$4.5 \\times 10^{-4}$"'::jsonb, 'medium', 'Four places left.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $0.00045$ in standard form.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(2 \times 10^3) \times (3 \times 10^4) = ?$', 'multiple_choice', '["$6 \\times 10^7$","$5 \\times 10^7$","$6 \\times 10^{12}$","$6 \\times 10^1$"]'::jsonb, '"$6 \\times 10^7$"'::jsonb, 'medium', 'Add powers of 10.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(2 \times 10^3) \times (3 \times 10^4) = ?$');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\log 20 + \log 5$.', 'multiple_choice', '["$2$","$\\log 25$","$\\log 100$","$3$"]'::jsonb, '"$2$"'::jsonb, 'medium', '$\log 100 = 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\log 20 + \log 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\log_{10} 50 - \log_{10} 5$.', 'multiple_choice', '["$1$","$2$","$\\log 45$","$10$"]'::jsonb, '"$1$"'::jsonb, 'medium', '$\log 10 = 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\log_{10} 50 - \log_{10} 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $\sqrt{16}$ as a power of $2$.', 'multiple_choice', '["$2^2$","$2^4$","$4^2$","$2^8$"]'::jsonb, '"$2^2$"'::jsonb, 'medium', '$16 = 2^4$; $\sqrt{16}=4=2^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $\sqrt{16}$ as a power of $2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Divide $(8.4 \times 10^7) \div (2.1 \times 10^3)$.', 'multiple_choice', '["$4 \\times 10^4$","$4 \\times 10^{10}$","$6.3 \\times 10^4$","$4 \\times 10^3$"]'::jsonb, '"$4 \\times 10^4$"'::jsonb, 'medium', 'Subtract powers.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Divide $(8.4 \times 10^7) \div (2.1 \times 10^3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{(2x^3)^2}{4x^2}$.', 'multiple_choice', '["$x^4$","$x^6$","$4x^4$","$x^2$"]'::jsonb, '"$x^4$"'::jsonb, 'hard', '$\frac{4x^6}{4x^2} = x^4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{(2x^3)^2}{4x^2}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $2^x = 32$, find $x$.', 'multiple_choice', '["$5$","$4$","$6$","$16$"]'::jsonb, '"$5$"'::jsonb, 'hard', '$32 = 2^5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $2^x = 32$, find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Mass of Earth $\approx 6 \times 10^{24}$ kg. Write $3 \times 10^{21}$ kg as fraction of Earth mass.', 'multiple_choice', '["$\\frac{1}{2000}$","$\\frac{1}{200}$","$\\frac{1}{20}$","$2000$"]'::jsonb, '"$\\frac{1}{2000}$"'::jsonb, 'hard', 'Divide powers: $10^{21-24}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Mass of Earth $\approx 6 \times 10^{24}$ kg. Write $3 \times 10^{21}$ kg as fraction of Earth mass.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(1.2 \times 10^{-4}) \times (5 \times 10^6) = ?$', 'multiple_choice', '["$6 \\times 10^2$","$6 \\times 10^{-2}$","$6 \\times 10^{10}$","$6 \\times 10^{-10}$"]'::jsonb, '"$6 \\times 10^2$"'::jsonb, 'hard', '$1.2 \times 5 = 6$; add indices.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='standard_form'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(1.2 \times 10^{-4}) \times (5 \times 10^6) = ?$');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\log_{10} x = 2.5$ approximately. Which is closest?', 'multiple_choice', '["$316$","$25$","$250$","$1000$"]'::jsonb, '"$316$"'::jsonb, 'hard', '$x = 10^{2.5} \approx 316$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\log_{10} x = 2.5$ approximately. Which is closest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $\log a = 2$ and $\log b = 3$, find $\log(ab)$.', 'multiple_choice', '["$5$","$6$","$1$","$8$"]'::jsonb, '"$5$"'::jsonb, 'hard', '$\log a + \log b$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='logarithms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $\log a = 2$ and $\log b = 3$, find $\log(ab)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $(3^2)^3 \div 3^4$.', 'multiple_choice', '["$3^2$","$3^6$","$3^{10}$","$9$"]'::jsonb, '"$3^2$"'::jsonb, 'hard', '$3^6 \div 3^4 = 3^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='laws_of_indices'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='indices_logarithms'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $(3^2)^3 \div 3^4$.');


-- ========== GRADIENT AND STRAIGHT LINES ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Gradient', '{"blocks":[{"type":"heading","content":"Gradient of a Line"},{"type":"paragraph","content":"The **gradient** (slope) measures steepness: change in $y$ divided by change in $x$."},{"type":"math_block","latex":"m = \\frac{\\Delta y}{\\Delta x} = \\frac{y_2 - y_1}{x_2 - x_1}","caption":"Gradient formula"},{"type":"callout","variant":"key_point","content":"Positive gradient rises left to right; negative gradient falls."},{"type":"example","title":"Find gradient through $(2, 3)$ and $(6, 11)$","steps":["$m = \\frac{11-3}{6-2} = \\frac{8}{4} = 2$."],"answer":"$2$"},{"type":"question","questionText":"Gradient through $(0, 1)$ and $(4, 9)$?","questionType":"multiple_choice","options":["$2$","$8$","$\\frac{1}{2}$","$-2$"],"correctAnswer":"$2$","explanation":"$\\frac{8}{4} = 2$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'gradient'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Gradient');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Gradient — Methods', '{"blocks":[{"type":"heading","content":"Gradient Methods"},{"type":"example","title":"Find gradient of line through $(-1, 5)$ and $(3, -3)$","steps":["$m = \\frac{-3-5}{3-(-1)} = \\frac{-8}{4} = -2$."],"answer":"$-2$"},{"type":"callout","variant":"warning","content":"Subtract coordinates consistently: $\\frac{y_2-y_1}{x_2-x_1}$."},{"type":"question","questionText":"Horizontal line gradient?","questionType":"multiple_choice","options":["$0$","$1$","Undefined","$-1$"],"correctAnswer":"$0$","explanation":"No change in $y$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'gradient'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Gradient — Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Gradient — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Gradient Problems"},{"type":"example","title":"A road rises $50$ m over $200$ m horizontal. Gradient?","steps":["$m = \\frac{50}{200} = 0.25$."],"answer":"$0.25$"},{"type":"question","questionText":"Vertical line gradient?","questionType":"multiple_choice","options":["Undefined","$0$","$1$","Infinite value $0$"],"correctAnswer":"Undefined","explanation":"$\\Delta x = 0$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'gradient'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Gradient — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Equation $y = mx + c$', '{"blocks":[{"type":"heading","content":"Equation of a Straight Line"},{"type":"paragraph","content":"A straight line can be written $y = mx + c$ where $m$ is gradient and $c$ is the $y$-intercept."},{"type":"math_block","latex":"y = mx + c","caption":"Slope-intercept form"},{"type":"example","title":"Write equation of line with $m = 3$, $c = -2$","steps":["$y = 3x - 2$."],"answer":"$y = 3x - 2$"},{"type":"question","questionText":"$y$-intercept of $y = -4x + 7$?","questionType":"multiple_choice","options":["$7$","$-4$","$4$","$-7$"],"correctAnswer":"$7$","explanation":"Constant term is $c$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'equation_of_line'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Equation $y = mx + c$');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding the Equation', '{"blocks":[{"type":"heading","content":"Finding Equations"},{"type":"example","title":"Find equation through $(2, 5)$ with gradient $3$","steps":["$y - 5 = 3(x - 2)$.","$y = 3x - 1$."],"answer":"$y = 3x - 1$"},{"type":"example","title":"Find equation through $(1, 2)$ and $(4, 8)$","steps":["$m = \\frac{8-2}{4-1} = 2$.","Using $(1,2)$: $y = 2x$."],"answer":"$y = 2x$"},{"type":"question","questionText":"Line through $(0, -3)$ with $m = 2$?","questionType":"multiple_choice","options":["$y = 2x - 3$","$y = 2x + 3$","$y = -3x + 2$","$y = x - 3$"],"correctAnswer":"$y = 2x - 3$","explanation":"$c = -3$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'equation_of_line'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding the Equation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Line Equations — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"A taxi charges KES $100$ flag fall plus KES $50$ per km. Write $C$ in terms of $d$.","steps":["$C = 50d + 100$."],"answer":"$C = 50d + 100$"},{"type":"callout","variant":"warning","content":"$c$ is the value when $x = 0$ — fixed charge here."},{"type":"question","questionText":"$x$-intercept of $y = 2x - 6$?","questionType":"multiple_choice","options":["$3$","$-6$","$6$","$-3$"],"correctAnswer":"$3$","explanation":"Set $y=0$: $x=3$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'equation_of_line'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Line Equations — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Parallel Lines', '{"blocks":[{"type":"heading","content":"Parallel Lines"},{"type":"paragraph","content":"Parallel lines have **equal gradients**: if $m_1 = m_2$, the lines are parallel."},{"type":"math_block","latex":"m_1 = m_2 \\Rightarrow \\text{parallel}","caption":"Parallel condition"},{"type":"example","title":"Are $y = 2x + 1$ and $y = 2x - 5$ parallel?","steps":["Both have $m = 2$ — yes, parallel."],"answer":"Yes"},{"type":"question","questionText":"Parallel to $y = -3x + 4$ has gradient?","questionType":"multiple_choice","options":["$-3$","$3$","$\\frac{1}{3}$","$-4$"],"correctAnswer":"$-3$","explanation":"Same gradient."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'parallel_perpendicular'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Parallel Lines');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Perpendicular Lines', '{"blocks":[{"type":"heading","content":"Perpendicular Lines"},{"type":"math_block","latex":"m_1 \\times m_2 = -1","caption":"Perpendicular gradients"},{"type":"example","title":"Find gradient perpendicular to $m = 2$","steps":["$m_2 = -\\frac{1}{2}$."],"answer":"$-\\frac{1}{2}$"},{"type":"callout","variant":"warning","content":"Negative reciprocal — flip and change sign."},{"type":"question","questionText":"Perpendicular to $y = \\frac{1}{3}x$?","questionType":"multiple_choice","options":["$-3$","$3$","$\\frac{1}{3}$","$-\\frac{1}{3}$"],"correctAnswer":"$-3$","explanation":"Product must be $-1$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'parallel_perpendicular'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Perpendicular Lines');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Parallel & Perpendicular — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Find equation through $(0, 1)$ perpendicular to $y = 4x + 2$","steps":["Perpendicular gradient $= -\\frac{1}{4}$.","$y = -\\frac{1}{4}x + 1$."],"answer":"$y = -\\frac{1}{4}x + 1$"},{"type":"question","questionText":"Lines $y = 5x$ and $y = 5x - 2$ are?","questionType":"multiple_choice","options":["Parallel","Perpendicular","Intersecting only","Same line"],"correctAnswer":"Parallel","explanation":"Equal gradients."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines' AND st.code = 'parallel_perpendicular'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Parallel & Perpendicular — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient through $(0, 0)$ and $(2, 6)$?', 'multiple_choice', '["$3$","$2$","$6$","$\\frac{1}{3}$"]'::jsonb, '"$3$"'::jsonb, 'easy', '$\frac{6}{2} = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient through $(0, 0)$ and $(2, 6)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of $y = 4x + 1$?', 'multiple_choice', '["$4$","$1$","$5$","$-4$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Coefficient of $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of $y = 4x + 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y$-intercept of $y = 2x - 5$?', 'multiple_choice', '["$-5$","$2$","$5$","$-2$"]'::jsonb, '"$-5$"'::jsonb, 'easy', '$c = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y$-intercept of $y = 2x - 5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equation with $m=1$, $c=0$?', 'multiple_choice', '["$y = x$","$y = 1$","$y = 0$","$x = 1$"]'::jsonb, '"$y = x$"'::jsonb, 'easy', '$y = 1x + 0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equation with $m=1$, $c=0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallel lines have gradients that are?', 'multiple_choice', '["Equal","Negative reciprocals","Opposite","Zero"]'::jsonb, '"Equal"'::jsonb, 'easy', 'Same slope.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallel lines have gradients that are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular to $m=2$ has $m=$?', 'multiple_choice', '["$-\\frac{1}{2}$","$2$","$-2$","$\\frac{1}{2}$"]'::jsonb, '"$-\\frac{1}{2}$"'::jsonb, 'easy', 'Product $= -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular to $m=2$ has $m=$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of horizontal line?', 'multiple_choice', '["$0$","$1$","Undefined","$-1$"]'::jsonb, '"$0$"'::jsonb, 'easy', 'Flat line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of horizontal line?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'In $y = mx + c$, what is $m$?', 'multiple_choice', '["Gradient","$y$-intercept","$x$-intercept","Origin"]'::jsonb, '"Gradient"'::jsonb, 'easy', 'Slope.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='In $y = mx + c$, what is $m$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient through $(-2, 7)$ and $(4, -5)$?', 'multiple_choice', '["$-2$","$2$","$-\\frac{1}{2}$","$-1$"]'::jsonb, '"$-2$"'::jsonb, 'medium', '$\frac{-12}{6} = -2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient through $(-2, 7)$ and $(4, -5)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line through $(3, 1)$ with $m=-2$?', 'multiple_choice', '["$y = -2x + 7$","$y = -2x - 5$","$y = 2x - 5$","$y = -2x + 1$"]'::jsonb, '"$y = -2x + 7$"'::jsonb, 'medium', '$1 = -6 + c$; $c=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line through $(3, 1)$ with $m=-2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find $m$ for points $(1,4)$ and $(5,12)$.', 'multiple_choice', '["$2$","$4$","$8$","$\\frac{1}{2}$"]'::jsonb, '"$2$"'::jsonb, 'medium', '$\frac{8}{4}=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find $m$ for points $(1,4)$ and $(5,12)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular to $y = -\frac{2}{3}x + 1$?', 'multiple_choice', '["$m = \\frac{3}{2}$","$m = -\\frac{2}{3}$","$m = \\frac{2}{3}$","$m = -\\frac{3}{2}$"]'::jsonb, '"$m = \\frac{3}{2}$"'::jsonb, 'medium', 'Negative reciprocal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular to $y = -\frac{2}{3}x + 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is parallel to $y = x + 5$?', 'multiple_choice', '["$y = x - 2$","$y = -x + 5$","$y = 2x + 5$","$x = y$"]'::jsonb, '"$y = x - 2$"'::jsonb, 'medium', 'Gradient $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is parallel to $y = x + 5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rise $15$ m, run $60$ m. Gradient?', 'multiple_choice', '["$0.25$","$4$","$45$","$75$"]'::jsonb, '"$0.25$"'::jsonb, 'medium', '$\frac{15}{60}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rise $15$ m, run $60$ m. Gradient?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Where does $y = 3x - 9$ cross $x$-axis?', 'multiple_choice', '["$(3, 0)$","$(0, -9)$","$(-3, 0)$","$(9, 0)$"]'::jsonb, '"$(3, 0)$"'::jsonb, 'medium', 'Set $y=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Where does $y = 3x - 9$ cross $x$-axis?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle vertices $(0,0)$, $(4,0)$, $(4,3)$. Gradient of hypotenuse?', 'multiple_choice', '["$\\frac{3}{4}$","$\\frac{4}{3}$","$3$","$4$"]'::jsonb, '"$\\frac{3}{4}$"'::jsonb, 'hard', 'From $(0,0)$ to $(4,3)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle vertices $(0,0)$, $(4,0)$, $(4,3)$. Gradient of hypotenuse?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular bisector of $(0,0)$ and $(4,0)$ is?', 'multiple_choice', '["$x = 2$","$y = 2$","$y = x$","$x = 0$"]'::jsonb, '"$x = 2$"'::jsonb, 'hard', 'Midpoint $x=2$, vertical line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular bisector of $(0,0)$ and $(4,0)$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line through $(2,3)$ and $(6,11)$. Equation?', 'multiple_choice', '["$y = 2x - 1$","$y = 2x + 1$","$y = 4x - 5$","$y = x + 1$"]'::jsonb, '"$y = 2x - 1$"'::jsonb, 'hard', '$m=2$; $c=-1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line through $(2,3)$ and $(6,11)$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Through $(0,0)$, perpendicular to $y = \frac{1}{2}x + 3$?', 'multiple_choice', '["$y = -2x$","$y = 2x$","$y = -\\frac{1}{2}x$","$y = \\frac{1}{2}x$"]'::jsonb, '"$y = -2x$"'::jsonb, 'hard', '$m=-2$ through origin.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Through $(0,0)$, perpendicular to $y = \frac{1}{2}x + 3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle has side on $y=3x$. Adjacent side gradient?', 'multiple_choice', '["$-\\frac{1}{3}$","$3$","$-3$","$\\frac{1}{3}$"]'::jsonb, '"$-\\frac{1}{3}$"'::jsonb, 'hard', 'Perpendicular sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='parallel_perpendicular'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle has side on $y=3x$. Adjacent side gradient?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Points $(a, 2a)$ and $(3a, 8a)$. Gradient?', 'multiple_choice', '["$3$","$2$","$a$","$4$"]'::jsonb, '"$3$"'::jsonb, 'hard', '$\frac{6a}{2a} = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Points $(a, 2a)$ and $(3a, 8a)$. Gradient?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find $c$ if $y = 5x + c$ passes through $(2, 13)$.', 'multiple_choice', '["$3$","$5$","$23$","$-3$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$13 = 10 + c$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='equation_of_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find $c$ if $y = 5x + c$ passes through $(2, 13)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line parallel to $y = 2x + 1$ through $(3, 1)$. Equation?', 'multiple_choice', '["$y = 2x - 5$","$y = 2x + 1$","$y = -2x + 7$","$y = 2x + 7$"]'::jsonb, '"$y = 2x - 5$"'::jsonb, 'hard', '$m = 2$; $1 = 6 + c$ so $c = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='gradient_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line parallel to $y = 2x + 1$ through $(3, 1)$. Equation?');


-- ========== REFLECTION AND CONGRUENCE ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reflection in a Mirror Line', '{"blocks":[{"type":"heading","content":"Reflection"},{"type":"paragraph","content":"A **reflection** flips a shape over a mirror line. Each point and its image are equidistant from the mirror, on a perpendicular."},{"type":"callout","variant":"key_point","content":"The mirror line is the perpendicular bisector of the segment joining a point to its image."},{"type":"example","title":"Reflect point $A(2, 3)$ in the $x$-axis","steps":["Image $A''(2, -3)$ — $y$ changes sign."],"answer":"$A''(2, -3)$"},{"type":"question","questionText":"Reflect $(4, -1)$ in $x$-axis?","questionType":"multiple_choice","options":["$(4, 1)$","$(-4, -1)$","$(-4, 1)$","$(4, -1)$"],"correctAnswer":"$(4, 1)$","explanation":"Negate $y$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'reflection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reflection in a Mirror Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reflecting Shapes', '{"blocks":[{"type":"heading","content":"Reflecting Shapes"},{"type":"example","title":"Reflect $\\triangle ABC$ with $A(1,1)$, $B(3,1)$, $C(2,3)$ in $y$-axis","steps":["$A''(-1,1)$, $B''(-3,1)$, $C''(-2,3)$ — negate $x$."],"answer":"Triangle with negated $x$-coordinates"},{"type":"callout","variant":"warning","content":"Reflect every vertex; order of vertices is reversed in the image."},{"type":"question","questionText":"Reflect $(-2, 5)$ in $y$-axis?","questionType":"multiple_choice","options":["$(2, 5)$","$(-2, -5)$","$(2, -5)$","$(-2, 5)$"],"correctAnswer":"$(2, 5)$","explanation":"Negate $x$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'reflection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reflecting Shapes');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reflection — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Reflection"},{"type":"example","title":"Reflect point $P(3, -4)$ in the line $y = x$","steps":["Swap coordinates: $P''(-4, 3)$ — actually for $y=x$: $(y,x)$ so $(-4, 3)$ wait: $(3,-4) \\to (-4, 3)$."],"answer":"$P''(-4, 3)$"},{"type":"question","questionText":"Reflect $(1, 2)$ in $y = x$?","questionType":"multiple_choice","options":["$(2, 1)$","$(-1, -2)$","$(-2, -1)$","$(1, -2)$"],"correctAnswer":"$(2, 1)$","explanation":"Swap $x$ and $y$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'reflection'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reflection — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Congruent Figures', '{"blocks":[{"type":"heading","content":"Congruence"},{"type":"paragraph","content":"Two figures are **congruent** if they are identical in shape and size — one can be mapped onto the other by rotation, reflection, or translation."},{"type":"callout","variant":"key_point","content":"Congruent triangles have equal corresponding sides and angles."},{"type":"example","title":"Are two equilateral triangles of side $5$ cm congruent?","steps":["Same shape and size — yes, congruent."],"answer":"Yes"},{"type":"question","questionText":"Congruent shapes have equal?","questionType":"multiple_choice","options":["Corresponding sides and angles","Area only","Perimeter only","Orientation only"],"correctAnswer":"Corresponding sides and angles","explanation":"Same size and shape."},{"type":"question","questionText":"Congruent shapes have equal?","questionType":"multiple_choice","options":["Corresponding sides and angles","Area only","Perimeter only","Orientation only"],"correctAnswer":"Corresponding sides and angles","explanation":"Same size and shape."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'congruence'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Congruent Figures');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tests for Triangle Congruence', '{"blocks":[{"type":"heading","content":"Congruence Tests"},{"type":"paragraph","content":"**SSS**, **SAS**, **ASA**, **RHS** are standard congruence tests."},{"type":"example","title":"Two triangles: $AB=PQ$, $BC=QR$, $CA=RP$. Congruent?","steps":["All three sides equal — SSS, congruent."],"answer":"Congruent by SSS"},{"type":"callout","variant":"warning","content":"SSA is NOT a valid congruence test in general."},{"type":"question","questionText":"Which proves congruence?","questionType":"multiple_choice","options":["SAS","SSA","AAA","SSS and SAS"],"correctAnswer":"SSS and SAS","explanation":"AAA gives similar, not congruent."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'congruence'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tests for Triangle Congruence');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Congruence — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Rectangle $ABCD$ and rectangle $PQRS$ have $AB=PQ=6$ cm, $BC=QR=4$ cm. Congruent?","steps":["All sides match — congruent rectangles."],"answer":"Yes"},{"type":"question","questionText":"Two circles radius $7$ cm. Congruent?","questionType":"multiple_choice","options":["Yes","No","Only if same centre","Cannot tell"],"correctAnswer":"Yes","explanation":"Same radius."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'congruence'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Congruence — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Line Symmetry', '{"blocks":[{"type":"heading","content":"Line Symmetry"},{"type":"paragraph","content":"A shape has **line symmetry** if it can be folded onto itself along a mirror line."},{"type":"example","title":"How many lines of symmetry does a square have?","steps":["Vertical, horizontal, and two diagonals — $4$ lines."],"answer":"$4$"},{"type":"question","questionText":"Lines of symmetry of an equilateral triangle?","questionType":"multiple_choice","options":["$3$","$1$","$6$","$0$"],"correctAnswer":"$3$","explanation":"One through each vertex."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Line Symmetry');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rotational Symmetry', '{"blocks":[{"type":"heading","content":"Rotational Symmetry"},{"type":"paragraph","content":"**Order of rotational symmetry** is how many times the shape looks the same in a full $360^\\circ$ turn."},{"type":"example","title":"Order of rotational symmetry of a square?","steps":["$90^\\circ$ rotations: order $4$."],"answer":"Order $4$"},{"type":"callout","variant":"warning","content":"Do not confuse reflection symmetry with rotational symmetry."},{"type":"question","questionText":"A circle has rotational symmetry order?","questionType":"multiple_choice","options":["Infinite","$1$","$2$","$0$"],"correctAnswer":"Infinite","explanation":"Looks same at every angle."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rotational Symmetry');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Symmetry — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Letter H — how many lines of symmetry?","steps":["Horizontal and vertical through centre — $2$."],"answer":"$2$"},{"type":"question","questionText":"Regular pentagon: lines of symmetry?","questionType":"multiple_choice","options":["$5$","$10$","$1$","$3$"],"correctAnswer":"$5$","explanation":"One per vertex."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence' AND st.code = 'symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Symmetry — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(3, 2)$ in $x$-axis.', 'multiple_choice', '["$(3, -2)$","$(-3, 2)$","$(-3, -2)$","$(2, 3)$"]'::jsonb, '"$(3, -2)$"'::jsonb, 'easy', 'Negate $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(3, 2)$ in $x$-axis.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(5, -1)$ in $y$-axis.', 'multiple_choice', '["$(-5, -1)$","$(5, 1)$","$(-5, 1)$","$(1, -5)$"]'::jsonb, '"$(-5, -1)$"'::jsonb, 'easy', 'Negate $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(5, -1)$ in $y$-axis.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Congruent triangles are?', 'multiple_choice', '["Same shape and size","Same shape only","Same area only","Similar only"]'::jsonb, '"Same shape and size"'::jsonb, 'easy', 'Definition of congruence.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Congruent triangles are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'SSS means?', 'multiple_choice', '["Three sides equal","Three angles equal","Two sides and angle","Right angle and hypotenuse"]'::jsonb, '"Three sides equal"'::jsonb, 'easy', 'Side-Side-Side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='SSS means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A square has how many lines of symmetry?', 'multiple_choice', '["$4$","$2$","$8$","$1$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Two diagonals plus two medians.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A square has how many lines of symmetry?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Isosceles triangle lines of symmetry?', 'multiple_choice', '["$1$","$3$","$2$","$0$"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Through apex to base midpoint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Isosceles triangle lines of symmetry?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(0, 4)$ in $x$-axis.', 'multiple_choice', '["$(0, -4)$","$(4, 0)$","$(-4, 0)$","$(0, 4)$"]'::jsonb, '"$(0, -4)$"'::jsonb, 'easy', 'Negate $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(0, 4)$ in $x$-axis.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle (not square) lines of symmetry?', 'multiple_choice', '["$2$","$4$","$1$","$0$"]'::jsonb, '"$2$"'::jsonb, 'easy', 'Horizontal and vertical.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle (not square) lines of symmetry?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(2, -3)$ in line $y = x$.', 'multiple_choice', '["$(-3, 2)$","$(-2, 3)$","$(3, -2)$","$(2, 3)$"]'::jsonb, '"$(-3, 2)$"'::jsonb, 'medium', 'Swap and negate? For $y=x$: swap to $(-3,2)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(2, -3)$ in line $y = x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(1, 4)$ in $x$-axis then $y$-axis. Final point?', 'multiple_choice', '["$(-1, -4)$","$(1, -4)$","$(-1, 4)$","$(1, 4)$"]'::jsonb, '"$(-1, -4)$"'::jsonb, 'medium', '$(1,-4)$ then $(-1,-4)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(1, 4)$ in $x$-axis then $y$-axis. Final point?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two triangles: two sides and included angle equal. Test?', 'multiple_choice', '["SAS","SSS","ASA","RHS"]'::jsonb, '"SAS"'::jsonb, 'medium', 'Side-Angle-Side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two triangles: two sides and included angle equal. Test?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'RHS applies to?', 'multiple_choice', '["Right-angled triangles","All triangles","Circles","Rectangles only"]'::jsonb, '"Right-angled triangles"'::jsonb, 'medium', 'Right angle-Hypotenuse-Side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='RHS applies to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular hexagon lines of symmetry?', 'multiple_choice', '["$6$","$3$","$12$","$2$"]'::jsonb, '"$6$"'::jsonb, 'medium', 'One per vertex.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular hexagon lines of symmetry?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Order of rotational symmetry of equilateral triangle?', 'multiple_choice', '["$3$","$1$","$6$","$2$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$120^\circ$ rotations.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Order of rotational symmetry of equilateral triangle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point on $x$-axis reflected in $x$-axis?', 'multiple_choice', '["Unchanged","Moves to $y$-axis","Origin","Negates $x$"]'::jsonb, '"Unchanged"'::jsonb, 'medium', 'On the mirror line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point on $x$-axis reflected in $x$-axis?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two rectangles $3 \times 5$ and $5 \times 3$. Congruent?', 'multiple_choice', '["Yes","No","Similar only","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Same dimensions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two rectangles $3 \times 5$ and $5 \times 3$. Congruent?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vertices $A(1,2)$, $B(4,2)$ reflected in $x=1$. Image of $B$?', 'multiple_choice', '["$(-2, 2)$","$(0, 2)$","$(2, 2)$","$(-4, 2)$"]'::jsonb, '"$(-2, 2)$"'::jsonb, 'hard', 'Distance 3 left of mirror.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vertices $A(1,2)$, $B(4,2)$ reflected in $x=1$. Image of $B$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(3, 5)$ in $y = -x$.', 'multiple_choice', '["$(-5, -3)$","$(5, 3)$","$(-3, -5)$","$(3, -5)$"]'::jsonb, '"$(-5, -3)$"'::jsonb, 'hard', 'Swap and negate both.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(3, 5)$ in $y = -x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\triangle ABC \cong \triangle DEF$. $AB=7$, $BC=5$, $EF=5$. Find $DE$.', 'multiple_choice', '["$7$","$5$","$12$","$2$"]'::jsonb, '"$7$"'::jsonb, 'hard', '$DE$ corresponds to $AB$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\triangle ABC \cong \triangle DEF$. $AB=7$, $BC=5$, $EF=5$. Find $DE$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is NOT a congruence test?', 'multiple_choice', '["SSA","SSS","SAS","ASA"]'::jsonb, '"SSA"'::jsonb, 'hard', 'Ambiguous case.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='congruence'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is NOT a congruence test?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Letter N — rotational symmetry order?', 'multiple_choice', '["$2$","$1$","$4$","Infinite"]'::jsonb, '"$2$"'::jsonb, 'hard', '$180^\circ$ rotation.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Letter N — rotational symmetry order?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular octagon: order of rotational symmetry?', 'multiple_choice', '["$8$","$4$","$16$","$2$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$360^\circ \div 45^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular octagon: order of rotational symmetry?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(-3, -2)$ in the origin (both axes).', 'multiple_choice', '["$(3, 2)$","$(-3, 2)$","$(3, -2)$","$(2, 3)$"]'::jsonb, '"$(3, 2)$"'::jsonb, 'hard', 'Negate both coordinates.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='reflection'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='reflection_congruence'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(-3, -2)$ in the origin (both axes).');


