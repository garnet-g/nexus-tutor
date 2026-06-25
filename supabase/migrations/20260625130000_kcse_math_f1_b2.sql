-- KCSE Form 1 Mathematics — Wave 1 Batch 2
-- Topics: squares_square_roots, length, area, volume_capacity, mass_weight_density
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md

-- ========== SQUARES AND SQUARE ROOTS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Squares', '{"blocks":[{"type":"heading","content":"Understanding Squares"},{"type":"paragraph","content":"The **square** of a number is that number multiplied by itself: $n^2 = n \\times n$. For example, $5^2 = 25$."},{"type":"math_block","latex":"n^2 = n \\times n","caption":"Squaring"},{"type":"callout","variant":"key_point","content":"Squaring any real number gives a non-negative result: $(-4)^2 = 16$."},{"type":"example","title":"Find $12^2$","steps":["$12 \\times 12 = 144$."],"answer":"$144$"},{"type":"question","questionText":"Evaluate $7^2$.","questionType":"multiple_choice","options":["$49$","$14$","$42$","$21$"],"correctAnswer":"$49$","explanation":"$7 \\times 7 = 49$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'squares'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Squares');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Squaring Numbers — Methods', '{"blocks":[{"type":"heading","content":"Methods for Squaring"},{"type":"paragraph","content":"Multiply directly for small numbers. Numbers ending in $5$: $(10a+5)^2$ ends in $25$ with leading digits $a(a+1)$."},{"type":"example","title":"Evaluate $35^2$","steps":["$3 \\times 4 = 12$.","Append $25$: $1225$."],"answer":"$1225$"},{"type":"callout","variant":"warning","content":"$-9^2 = -81$ but $(-9)^2 = 81$. Brackets matter."},{"type":"question","questionText":"Evaluate $15^2$.","questionType":"multiple_choice","options":["$225$","$150$","$125$","$215$"],"correctAnswer":"$225$","explanation":"$15 \\times 15 = 225$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'squares'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Squaring Numbers — Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Squares in KCSE Questions', '{"blocks":[{"type":"heading","content":"Exam Applications"},{"type":"example","title":"A square tile has side $8$ cm. Find its area.","steps":["Area $= 8^2 = 64$ cm$^2$."],"answer":"$64$ cm$^2$"},{"type":"callout","variant":"warning","content":"Area uses squaring, not doubling the side."},{"type":"question","questionText":"The square of which number is $144$?","questionType":"multiple_choice","options":["$12$","$72$","$14$","$24$"],"correctAnswer":"$12$","explanation":"$12^2 = 144$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'squares'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Squares in KCSE Questions');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Introduction to Square Roots', '{"blocks":[{"type":"heading","content":"Square Roots"},{"type":"paragraph","content":"$\\sqrt{n}$ is the positive number whose square is $n$. Example: $\\sqrt{25} = 5$."},{"type":"callout","variant":"key_point","content":"By convention $\\sqrt{n}$ means the positive root only."},{"type":"example","title":"Evaluate $\\sqrt{64}$","steps":["$8^2 = 64$, so $\\sqrt{64} = 8$."],"answer":"$8$"},{"type":"question","questionText":"Evaluate $\\sqrt{49}$.","questionType":"multiple_choice","options":["$7$","$49$","$14$","$6$"],"correctAnswer":"$7$","explanation":"$7^2 = 49$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Introduction to Square Roots');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Square Roots by Prime Factorisation', '{"blocks":[{"type":"heading","content":"Factorisation Method"},{"type":"paragraph","content":"Express the number as prime factors and pair equal factors."},{"type":"example","title":"Evaluate $\\sqrt{144}$","steps":["$144 = 2^4 \\times 3^2$.","One of each pair outside: $2 \\times 2 \\times 3 = 12$."],"answer":"$12$"},{"type":"callout","variant":"warning","content":"Perfect squares have even powers for every prime factor."},{"type":"question","questionText":"Evaluate $\\sqrt{36}$.","questionType":"multiple_choice","options":["$6$","$18$","$9$","$12$"],"correctAnswer":"$6$","explanation":"$6^2 = 36$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Square Roots by Prime Factorisation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Exam Problems — Factor Method', '{"blocks":[{"type":"heading","content":"KCSE Factor Problems"},{"type":"example","title":"Evaluate $\\sqrt{324}$","steps":["$324 = 18^2$.","$\\sqrt{324} = 18$."],"answer":"$18$"},{"type":"question","questionText":"Evaluate $\\sqrt{196}$.","questionType":"multiple_choice","options":["$14$","$98$","$13$","$28$"],"correctAnswer":"$14$","explanation":"$14^2 = 196$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Exam Problems — Factor Method');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Square Root Tables', '{"blocks":[{"type":"heading","content":"Using Tables"},{"type":"paragraph","content":"Tables list $\\sqrt{N}$. Use them for exact perfect squares and approximate values otherwise."},{"type":"example","title":"Read $\\sqrt{2}$ from a table","steps":["Locate $2$.","$\\sqrt{2} \\approx 1.414$."],"answer":"$1.414$"},{"type":"question","questionText":"Is $10$ a perfect square if $\\sqrt{10} \\approx 3.162$?","questionType":"multiple_choice","options":["No","Yes","Cannot tell","Yes, $5^2$"],"correctAnswer":"No","explanation":"Not an integer root."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Square Root Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Estimating Square Roots', '{"blocks":[{"type":"heading","content":"Estimation"},{"type":"example","title":"Between which integers is $\\sqrt{50}$?","steps":["$7^2=49$, $8^2=64$.","Between $7$ and $8$, closer to $7$."],"answer":"$7$ and $8$"},{"type":"question","questionText":"Between which integers does $\\sqrt{30}$ lie?","questionType":"multiple_choice","options":["$5$ and $6$","$4$ and $5$","$6$ and $7$","$3$ and $4$"],"correctAnswer":"$5$ and $6$","explanation":"$25 < 30 < 36$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Estimating Square Roots');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Table Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"A square field has area $200$ m$^2$. Estimate the side.","steps":["$14^2=196$, $15^2=225$.","Side $\\approx 14.1$ m."],"answer":"$\\approx 14.1$ m"},{"type":"question","questionText":"Is $\\sqrt{81}$ exact from a table?","questionType":"multiple_choice","options":["Yes, $9$","Approximate only","No","Cannot tell"],"correctAnswer":"Yes, $9$","explanation":"$81=9^2$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots' AND st.code = 'square_roots_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Table Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $6^2$.', 'multiple_choice', '["$36$","$12$","$18$","$66$"]'::jsonb, '"$36$"'::jsonb, 'easy', '$6 \times 6 = 36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $6^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-5)^2$.', 'multiple_choice', '["$25$","$-25$","$10$","$-10$"]'::jsonb, '"$25$"'::jsonb, 'easy', 'Negative squared is positive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-5)^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a perfect square?', 'multiple_choice', '["$64$","$50$","$18$","$32$"]'::jsonb, '"$64$"'::jsonb, 'easy', '$64 = 8^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a perfect square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $20^2$.', 'multiple_choice', '["$400$","$40$","$200$","$420$"]'::jsonb, '"$400$"'::jsonb, 'easy', '$20 \times 20 = 400$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $20^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{81}$.', 'multiple_choice', '["$9$","$81$","$8$","$27$"]'::jsonb, '"$9$"'::jsonb, 'easy', '$9^2 = 81$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{81}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{100}$.', 'multiple_choice', '["$10$","$50$","$20$","$5$"]'::jsonb, '"$10$"'::jsonb, 'easy', '$10^2 = 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{100}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Between which integers does $\sqrt{20}$ lie?', 'multiple_choice', '["$4$ and $5$","$3$ and $4$","$5$ and $6$","$2$ and $3$"]'::jsonb, '"$4$ and $5$"'::jsonb, 'easy', '$16 < 20 < 25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Between which integers does $\sqrt{20}$ lie?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $11^2$.', 'multiple_choice', '["$121$","$22$","$111$","$101$"]'::jsonb, '"$121$"'::jsonb, 'medium', '$11 \times 11 = 121$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $11^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{225}$.', 'multiple_choice', '["$15$","$25$","$45$","$12$"]'::jsonb, '"$15$"'::jsonb, 'medium', '$15^2 = 225$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{225}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{400}$.', 'multiple_choice', '["$20$","$40$","$10$","$200$"]'::jsonb, '"$20$"'::jsonb, 'medium', '$20^2 = 400$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{400}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate $\sqrt{45}$ to the nearest integer.', 'multiple_choice', '["$7$","$6$","$8$","$5$"]'::jsonb, '"$7$"'::jsonb, 'medium', 'Closer to $49$ than $36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate $\sqrt{45}$ to the nearest integer.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A square has side $13$ cm. Find its area in cm$^2$.', 'multiple_choice', '["$169$","$26$","$52$","$13$"]'::jsonb, '"$169$"'::jsonb, 'medium', '$13^2 = 169$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A square has side $13$ cm. Find its area in cm$^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{576}$.', 'multiple_choice', '["$24$","$28$","$26$","$18$"]'::jsonb, '"$24$"'::jsonb, 'medium', '$24^2 = 576$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{576}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Given $\sqrt{2} \approx 1.414$, estimate $\sqrt{8}$.', 'multiple_choice', '["$2.828$","$4.828$","$1.414$","$3.414$"]'::jsonb, '"$2.828$"'::jsonb, 'medium', '$\sqrt{8}=2\sqrt{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Given $\sqrt{2} \approx 1.414$, estimate $\sqrt{8}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-12)^2 + 5^2$.', 'multiple_choice', '["$169$","$119$","$144$","$25$"]'::jsonb, '"$169$"'::jsonb, 'hard', '$144+25=169$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-12)^2 + 5^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{1296}$.', 'multiple_choice', '["$36$","$34$","$32$","$18$"]'::jsonb, '"$36$"'::jsonb, 'hard', '$36^2=1296$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{1296}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A square field has area $484$ m$^2$. Find the side in metres.', 'multiple_choice', '["$22$","$44$","$242$","$24$"]'::jsonb, '"$22$"'::jsonb, 'hard', '$\sqrt{484}=22$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A square field has area $484$ m$^2$. Find the side in metres.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A square plot has area $75$ m$^2$. Estimate the side (1 d.p.).', 'multiple_choice', '["$8.7$","$7.5$","$9.0$","$8.0$"]'::jsonb, '"$8.7$"'::jsonb, 'hard', '$\sqrt{75}\approx 8.66$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A square plot has area $75$ m$^2$. Estimate the side (1 d.p.).');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Squares $169$, $196$, $225$ belong to which consecutive integers?', 'multiple_choice', '["$13,14,15$","$12,13,14$","$14,15,16$","$11,12,13$"]'::jsonb, '"$13,14,15$"'::jsonb, 'hard', 'Roots are $13,14,15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='squares'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Squares $169$, $196$, $225$ belong to which consecutive integers?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\sqrt{0.25}$.', 'multiple_choice', '["$0.5$","$0.25$","$5$","$0.05$"]'::jsonb, '"$0.5$"'::jsonb, 'hard', '$0.5^2=0.25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\sqrt{0.25}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is closest to $\sqrt{95}$?', 'multiple_choice', '["$9.7$","$8.5$","$10.2$","$9.0$"]'::jsonb, '"$9.7$"'::jsonb, 'hard', 'Between $9$ and $10$, near $9.75$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='square_roots_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='squares_square_roots'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is closest to $\sqrt{95}$?');

-- ========== LENGTH ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Units of Length', '{"blocks":[{"type":"heading","content":"Units of Length"},{"type":"paragraph","content":"Common units: millimetre (mm), centimetre (cm), metre (m), kilometre (km). $1$ m $= 100$ cm $= 1000$ mm."},{"type":"callout","variant":"key_point","content":"$1$ km $= 1000$ m."},{"type":"example","title":"Convert $3.5$ km to metres","steps":["$3.5 \\times 1000 = 3500$ m."],"answer":"$3500$ m"},{"type":"question","questionText":"How many cm in $2$ m?","questionType":"multiple_choice","options":["$200$","$20$","$2000$","$2$"],"correctAnswer":"$200$","explanation":"$2 \\times 100 = 200$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'units_length'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Units of Length');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Converting Length Units', '{"blocks":[{"type":"heading","content":"Unit Conversion"},{"type":"example","title":"Convert $450$ cm to m","steps":["$450 \\div 100 = 4.5$ m."],"answer":"$4.5$ m"},{"type":"example","title":"Convert $2.4$ km to cm","steps":["$2.4$ km $= 2400$ m $= 240\\,000$ cm."],"answer":"$240\\,000$ cm"},{"type":"callout","variant":"warning","content":"Converting to a smaller unit: multiply. To a larger unit: divide."},{"type":"question","questionText":"Convert $75$ mm to cm.","questionType":"multiple_choice","options":["$7.5$","$750$","$0.75$","$75$"],"correctAnswer":"$7.5$","explanation":"$75 \\div 10 = 7.5$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'units_length'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Converting Length Units');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Length Conversions in Context', '{"blocks":[{"type":"heading","content":"Real-Life Conversions"},{"type":"example","title":"A road sign shows $2.3$ km to Nakuru. How many metres?","steps":["$2.3 \\times 1000 = 2300$ m."],"answer":"$2300$ m"},{"type":"question","questionText":"A rope is $4.2$ m. How many cm?","questionType":"multiple_choice","options":["$420$","$42$","$4200$","$4.2$"],"correctAnswer":"$420$","explanation":"$4.2 \\times 100$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'units_length'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Length Conversions in Context');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Perimeter of Polygons', '{"blocks":[{"type":"heading","content":"Perimeter"},{"type":"paragraph","content":"**Perimeter** is the total distance around a shape. Add all side lengths."},{"type":"callout","variant":"key_point","content":"Rectangle perimeter: $P = 2(l + w)$."},{"type":"example","title":"Find perimeter of a rectangle $8$ cm by $5$ cm","steps":["$P = 2(8+5) = 26$ cm."],"answer":"$26$ cm"},{"type":"question","questionText":"Perimeter of a square of side $6$ cm?","questionType":"multiple_choice","options":["$24$ cm","$36$ cm","$12$ cm","$18$ cm"],"correctAnswer":"$24$ cm","explanation":"$4 \\times 6 = 24$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'perimeter'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Perimeter of Polygons');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Perimeter Calculations', '{"blocks":[{"type":"heading","content":"Perimeter Methods"},{"type":"example","title":"A triangle has sides $7$ cm, $9$ cm, $11$ cm. Find $P$.","steps":["$P = 7+9+11 = 27$ cm."],"answer":"$27$ cm"},{"type":"example","title":"Rectangle length $12$ m, width $7$ m. Find $P$.","steps":["$P = 2(12+7) = 38$ m."],"answer":"$38$ m"},{"type":"question","questionText":"An equilateral triangle has side $10$ cm. Find $P$.","questionType":"multiple_choice","options":["$30$ cm","$20$ cm","$100$ cm","$15$ cm"],"correctAnswer":"$30$ cm","explanation":"$3 \\times 10$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'perimeter'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Perimeter Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Perimeter Word Problems', '{"blocks":[{"type":"heading","content":"Perimeter Applications"},{"type":"example","title":"Grace fences a rectangular shamba $40$ m by $25$ m. How much fencing?","steps":["$P = 2(40+25) = 130$ m."],"answer":"$130$ m"},{"type":"callout","variant":"warning","content":"Fencing, borders, and frames usually mean perimeter, not area."},{"type":"question","questionText":"A square garden has side $15$ m. Fencing cost KES $200$ per m. Find total cost.","questionType":"multiple_choice","options":["KES $12\\,000$","KES $45\\,000$","KES $6\\,000$","KES $3\\,000$"],"correctAnswer":"KES $12\\,000$","explanation":"$P=60$ m; $60 \\times 200$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'perimeter'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Perimeter Word Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circumference of a Circle', '{"blocks":[{"type":"heading","content":"Circumference"},{"type":"paragraph","content":"The **circumference** is the perimeter of a circle."},{"type":"math_block","latex":"C = 2\\pi r = \\pi d","caption":"Circumference formulas"},{"type":"callout","variant":"key_point","content":"Use $\\pi \\approx 3.14$ or $\\frac{22}{7}$ unless told otherwise."},{"type":"example","title":"Find $C$ when $r = 7$ cm ($\\pi=\\frac{22}{7}$)","steps":["$C = 2 \\times \\frac{22}{7} \\times 7 = 44$ cm."],"answer":"$44$ cm"},{"type":"question","questionText":"Diameter $10$ cm. Find $C$ ($\\pi=3.14$).","questionType":"multiple_choice","options":["$31.4$ cm","$62.8$ cm","$314$ cm","$15.7$ cm"],"correctAnswer":"$31.4$ cm","explanation":"$C = \\pi d = 31.4$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circumference of a Circle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circumference Calculations', '{"blocks":[{"type":"heading","content":"Worked Circumference"},{"type":"example","title":"Wheel diameter $70$ cm. Distance in one revolution?","steps":["$C = \\pi d = 3.14 \\times 70 = 219.8$ cm."],"answer":"$219.8$ cm"},{"type":"callout","variant":"warning","content":"One revolution = one circumference. Do not use area formula."},{"type":"question","questionText":"Radius $14$ cm. Find $C$ ($\\pi=\\frac{22}{7}$).","questionType":"multiple_choice","options":["$88$ cm","$44$ cm","$616$ cm","$154$ cm"],"correctAnswer":"$88$ cm","explanation":"$2 \\times \\frac{22}{7} \\times 14$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circumference Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circumference Exam Problems', '{"blocks":[{"type":"heading","content":"Exam Problems"},{"type":"example","title":"A circular track has radius $35$ m. How far in $3$ laps?","steps":["$C = 2 \\times \\frac{22}{7} \\times 35 = 220$ m.","Three laps: $660$ m."],"answer":"$660$ m"},{"type":"question","questionText":"Semi-circle diameter $14$ cm. Find curved length ($\\pi=\\frac{22}{7}$).","questionType":"multiple_choice","options":["$22$ cm","$44$ cm","$11$ cm","$33$ cm"],"correctAnswer":"$22$ cm","explanation":"Half of $C = \\frac{1}{2}\\pi d$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length' AND st.code = 'circumference'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circumference Exam Problems');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many millimetres in $5$ cm?', 'multiple_choice', '["$50$","$500$","$5$","$0.5$"]'::jsonb, '"$50$"'::jsonb, 'easy', '$5 \times 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many millimetres in $5$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $2$ km to metres.', 'multiple_choice', '["$2000$","$200$","$20\\,000$","$20$"]'::jsonb, '"$2000$"'::jsonb, 'easy', '$2 \times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $2$ km to metres.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perimeter of square side $9$ cm?', 'multiple_choice', '["$36$ cm","$81$ cm","$18$ cm","$27$ cm"]'::jsonb, '"$36$ cm"'::jsonb, 'easy', '$4 \times 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perimeter of square side $9$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $6$ cm by $4$ cm. Find $P$.', 'multiple_choice', '["$20$ cm","$24$ cm","$10$ cm","$48$ cm"]'::jsonb, '"$20$ cm"'::jsonb, 'easy', '$2(6+4)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $6$ cm by $4$ cm. Find $P$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $7$ cm. $C$ with $\pi=\frac{22}{7}$?', 'multiple_choice', '["$44$ cm","$22$ cm","$154$ cm","$88$ cm"]'::jsonb, '"$44$ cm"'::jsonb, 'easy', '$2\pi r$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $7$ cm. $C$ with $\pi=\frac{22}{7}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $250$ cm to m.', 'multiple_choice', '["$2.5$","$25$","$0.25$","$2500$"]'::jsonb, '"$2.5$"'::jsonb, 'easy', '$\div 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $250$ cm to m.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Diameter $14$ cm. $C$ ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$44$ cm","$22$ cm","$88$ cm","$154$ cm"]'::jsonb, '"$44$ cm"'::jsonb, 'easy', '$\pi d$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Diameter $14$ cm. $C$ ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $1.8$ km to metres.', 'multiple_choice', '["$1800$","$180$","$18\\,000$","$1.8$"]'::jsonb, '"$1800$"'::jsonb, 'medium', '$\times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $1.8$ km to metres.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle sides $5$, $12$, $13$ cm. Find $P$.', 'multiple_choice', '["$30$ cm","$26$ cm","$60$ cm","$65$ cm"]'::jsonb, '"$30$ cm"'::jsonb, 'medium', 'Add sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle sides $5$, $12$, $13$ cm. Find $P$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle perimeter $48$ cm, length $14$ cm. Find width.', 'multiple_choice', '["$10$ cm","$12$ cm","$24$ cm","$34$ cm"]'::jsonb, '"$10$ cm"'::jsonb, 'medium', '$48=2(14+w)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle perimeter $48$ cm, length $14$ cm. Find width.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $10$ cm. $C$ ($\pi=3.14$)?', 'multiple_choice', '["$62.8$ cm","$31.4$ cm","$314$ cm","$125.6$ cm"]'::jsonb, '"$62.8$ cm"'::jsonb, 'medium', '$2\pi r$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $10$ cm. $C$ ($\pi=3.14$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $3.2$ m to mm.', 'multiple_choice', '["$3200$","$320$","$32\\,000$","$32$"]'::jsonb, '"$3200$"'::jsonb, 'medium', '$\times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $3.2$ m to mm.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Wheel diameter $56$ cm. One revolution distance ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$176$ cm","$88$ cm","$352$ cm","$44$ cm"]'::jsonb, '"$176$ cm"'::jsonb, 'medium', '$C=\pi d$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Wheel diameter $56$ cm. One revolution distance ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular pentagon side $8$ cm. Find $P$.', 'multiple_choice', '["$40$ cm","$32$ cm","$24$ cm","$64$ cm"]'::jsonb, '"$40$ cm"'::jsonb, 'medium', '$5 \times 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular pentagon side $8$ cm. Find $P$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A athlete runs $5$ laps of $400$ m. Total distance in km?', 'multiple_choice', '["$2$","$20$","$0.2$","$2000$"]'::jsonb, '"$2$"'::jsonb, 'hard', '$2000$ m $= 2$ km.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A athlete runs $5$ laps of $400$ m. Total distance in km?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square and rectangle both have perimeter $36$ cm. Square side $9$ cm. Rectangle is $12$ cm by $w$. Find $w$.', 'multiple_choice', '["$6$ cm","$9$ cm","$3$ cm","$12$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'hard', '$2(12+w)=36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square and rectangle both have perimeter $36$ cm. Square side $9$ cm. Rectangle is $12$ cm by $w$. Find $w$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circular pond radius $21$ m. Fence cost KES $150$/m ($\pi=\frac{22}{7}$). Total cost?', 'multiple_choice', '["KES $19\\,800$","KES $9\\,900$","KES $6\\,600$","KES $13\\,860$"]'::jsonb, '"KES $19\\,800$"'::jsonb, 'hard', '$C=132$ m.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circular pond radius $21$ m. Fence cost KES $150$/m ($\pi=\frac{22}{7}$). Total cost?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Wire $4.5$ m cut into $15$ equal pieces. Each piece in cm?', 'multiple_choice', '["$30$","$300$","$3$","$45$"]'::jsonb, '"$30$"'::jsonb, 'hard', '$450 \div 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_length'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Wire $4.5$ m cut into $15$ equal pieces. Each piece in cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Semi-circle radius $7$ cm. Perimeter of shape ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$36$ cm","$22$ cm","$44$ cm","$29$ cm"]'::jsonb, '"$36$ cm"'::jsonb, 'hard', 'Curve $22$ + diameter $14$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Semi-circle radius $7$ cm. Perimeter of shape ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'L-shaped room: $8$ m by $6$ m with $3$ m by $2$ m corner cut. Outer perimeter?', 'multiple_choice', '["$28$ m","$26$ m","$24$ m","$30$ m"]'::jsonb, '"$28$ m"'::jsonb, 'hard', 'Trace outer edges.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='perimeter'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='L-shaped room: $8$ m by $6$ m with $3$ m by $2$ m corner cut. Outer perimeter?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bicycle wheel $r=35$ cm. Distance in $50$ revolutions ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$220$ m","$110$ m","$440$ m","$154$ m"]'::jsonb, '"$220$ m"'::jsonb, 'hard', '$C=220$ cm per rev.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='circumference'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='length'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bicycle wheel $r=35$ cm. Distance in $50$ revolutions ($\pi=\frac{22}{7}$)?');

-- ========== AREA ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of Rectangles and Triangles', '{"blocks":[{"type":"heading","content":"Area of Plane Figures"},{"type":"paragraph","content":"Area measures surface inside a shape. Rectangle: $A = l \\times w$. Triangle: $A = \\frac{1}{2}bh$."},{"type":"callout","variant":"key_point","content":"Area is in square units: cm$^2$, m$^2$."},{"type":"example","title":"Rectangle $12$ cm by $5$ cm","steps":["$A = 12 \\times 5 = 60$ cm$^2$."],"answer":"$60$ cm$^2$"},{"type":"question","questionText":"Triangle base $10$ cm, height $6$ cm. Find $A$.","questionType":"multiple_choice","options":["$30$ cm$^2$","$60$ cm$^2$","$16$ cm$^2$","$36$ cm$^2$"],"correctAnswer":"$30$ cm$^2$","explanation":"$\\frac{1}{2} \\times 10 \\times 6$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of Rectangles and Triangles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of Parallelograms and Trapeziums', '{"blocks":[{"type":"heading","content":"More Plane Areas"},{"type":"math_block","latex":"A_{\\text{parallelogram}} = bh,\\quad A_{\\text{trapezium}} = \\frac{1}{2}(a+b)h","caption":"Formulas"},{"type":"example","title":"Parallelogram base $8$ m, height $5$ m","steps":["$A = 8 \\times 5 = 40$ m$^2$."],"answer":"$40$ m$^2$"},{"type":"example","title":"Trapezium parallel sides $6$ cm and $10$ cm, height $4$ cm","steps":["$A = \\frac{1}{2}(6+10) \\times 4 = 32$ cm$^2$."],"answer":"$32$ cm$^2$"},{"type":"question","questionText":"Square side $9$ cm. Find $A$.","questionType":"multiple_choice","options":["$81$ cm$^2$","$36$ cm$^2$","$18$ cm$^2$","$72$ cm$^2$"],"correctAnswer":"$81$ cm$^2$","explanation":"$9^2 = 81$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of Parallelograms and Trapeziums');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Plane Figure Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Rhombus diagonals $12$ cm and $16$ cm","steps":["$A = \\frac{1}{2} \\times 12 \\times 16 = 96$ cm$^2$."],"answer":"$96$ cm$^2$"},{"type":"callout","variant":"warning","content":"Use the perpendicular height, not the slant side, for parallelograms."},{"type":"question","questionText":"Rectangle area $84$ cm$^2$, width $7$ cm. Find length.","questionType":"multiple_choice","options":["$12$ cm","$7$ cm","$91$ cm","$77$ cm"],"correctAnswer":"$12$ cm","explanation":"$84 \\div 7$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Plane Figure Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of a Circle', '{"blocks":[{"type":"heading","content":"Area of a Circle"},{"type":"math_block","latex":"A = \\pi r^2","caption":"Circle area"},{"type":"callout","variant":"key_point","content":"Use radius, not diameter, unless you substitute $r = \\frac{d}{2}$."},{"type":"example","title":"Radius $7$ cm ($\\pi=\\frac{22}{7}$)","steps":["$A = \\frac{22}{7} \\times 49 = 154$ cm$^2$."],"answer":"$154$ cm$^2$"},{"type":"question","questionText":"Radius $5$ cm. $A$ ($\\pi=3.14$)?","questionType":"multiple_choice","options":["$78.5$ cm$^2$","$31.4$ cm$^2$","$15.7$ cm$^2$","$157$ cm$^2$"],"correctAnswer":"$78.5$ cm$^2$","explanation":"$3.14 \\times 25$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_circle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of a Circle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circle Area Calculations', '{"blocks":[{"type":"heading","content":"Worked Circle Areas"},{"type":"example","title":"Diameter $14$ cm ($\\pi=\\frac{22}{7}$)","steps":["$r = 7$ cm.","$A = \\frac{22}{7} \\times 49 = 154$ cm$^2$."],"answer":"$154$ cm$^2$"},{"type":"callout","variant":"warning","content":"Common mistake: using $\\pi d^2$ instead of $\\pi r^2$."},{"type":"question","questionText":"Radius $10$ m. $A$ ($\\pi=3.14$)?","questionType":"multiple_choice","options":["$314$ m$^2$","$62.8$ m$^2$","$31.4$ m$^2$","$157$ m$^2$"],"correctAnswer":"$314$ m$^2$","explanation":"$3.14 \\times 100$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_circle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circle Area Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circle Area Exam Problems', '{"blocks":[{"type":"heading","content":"Exam Problems"},{"type":"example","title":"Circular table top diameter $1.4$ m. Area ($\\pi=\\frac{22}{7}$)?","steps":["$r = 0.7$ m.","$A = \\frac{22}{7} \\times 0.49 = 1.54$ m$^2$."],"answer":"$1.54$ m$^2$"},{"type":"question","questionText":"Semi-circle radius $7$ cm. Area ($\\pi=\\frac{22}{7}$)?","questionType":"multiple_choice","options":["$77$ cm$^2$","$154$ cm$^2$","$44$ cm$^2$","$38.5$ cm$^2$"],"correctAnswer":"$77$ cm$^2$","explanation":"Half of $\\pi r^2$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_circle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circle Area Exam Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Shapes — Concepts', '{"blocks":[{"type":"heading","content":"Combined Shapes"},{"type":"paragraph","content":"Split complex shapes into rectangles, triangles, or circles. Add areas of parts, or subtract removed parts."},{"type":"callout","variant":"key_point","content":"Draw dotted lines to divide the shape before calculating."},{"type":"example","title":"L-shape: $10$ by $6$ with $4$ by $3$ removed","steps":["Whole: $60$.","Removed: $12$.","$A = 48$."],"answer":"$48$ square units"},{"type":"question","questionText":"Square $8$ cm with corner square $3$ cm cut off. Area left?","questionType":"multiple_choice","options":["$55$ cm$^2$","$64$ cm$^2$","$9$ cm$^2$","$61$ cm$^2$"],"correctAnswer":"$55$ cm$^2$","explanation":"$64 - 9$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Shapes — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Shape Methods', '{"blocks":[{"type":"heading","content":"Methods"},{"type":"example","title":"Rectangle $12$ by $8$ with semicircle radius $4$ on one end","steps":["Rectangle: $96$.","Semicircle: $\\frac{1}{2}\\pi(4)^2 = 25.12$.","Total $\\approx 121.12$."],"answer":"$\\approx 121$ cm$^2$"},{"type":"question","questionText":"Annulus: outer $r=5$, inner $r=3$ ($\\pi=3.14$). Area?","questionType":"multiple_choice","options":["$50.24$","$78.5$","$28.26$","$25.12$"],"correctAnswer":"$50.24$","explanation":"$\\pi(25-9)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Shape Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Shapes Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Square field $40$ m with circular pond radius $7$ m ($\\pi=\\frac{22}{7}$)","steps":["Field: $1600$ m$^2$.","Pond: $154$ m$^2$.","Grass: $1446$ m$^2$."],"answer":"$1446$ m$^2$"},{"type":"callout","variant":"warning","content":"Subtract holes; add separate regions."},{"type":"question","questionText":"Path $2$ m wide around rectangle $10$ by $6$ m (outer edge). Outer rectangle area?","questionType":"multiple_choice","options":["$112$ m$^2$","$60$ m$^2$","$96$ m$^2$","$80$ m$^2$"],"correctAnswer":"$112$ m$^2$","explanation":"Outer $14$ by $8$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area' AND st.code = 'area_combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Shapes Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $8$ cm by $5$ cm. Find area.', 'multiple_choice', '["$40$ cm$^2$","$26$ cm$^2$","$13$ cm$^2$","$80$ cm$^2$"]'::jsonb, '"$40$ cm$^2$"'::jsonb, 'easy', '$8 \times 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $8$ cm by $5$ cm. Find area.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square side $6$ cm. Find area.', 'multiple_choice', '["$36$ cm$^2$","$24$ cm$^2$","$12$ cm$^2$","$18$ cm$^2$"]'::jsonb, '"$36$ cm$^2$"'::jsonb, 'easy', '$6^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square side $6$ cm. Find area.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle base $8$ cm, height $5$ cm. Area?', 'multiple_choice', '["$20$ cm$^2$","$40$ cm$^2$","$13$ cm$^2$","$10$ cm$^2$"]'::jsonb, '"$20$ cm$^2$"'::jsonb, 'easy', '$\frac{1}{2}bh$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle base $8$ cm, height $5$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $7$ cm. Area ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$154$ cm$^2$","$44$ cm$^2$","$49$ cm$^2$","$77$ cm$^2$"]'::jsonb, '"$154$ cm$^2$"'::jsonb, 'easy', '$\pi r^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $7$ cm. Area ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $3$ cm. Area ($\pi=3.14$)?', 'multiple_choice', '["$28.26$ cm$^2$","$9.42$ cm$^2$","$18.84$ cm$^2$","$6.28$ cm$^2$"]'::jsonb, '"$28.26$ cm$^2$"'::jsonb, 'easy', '$3.14 \times 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $3$ cm. Area ($\pi=3.14$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square $10$ cm minus corner $2$ cm square. Area?', 'multiple_choice', '["$96$ cm$^2$","$100$ cm$^2$","$4$ cm$^2$","$98$ cm$^2$"]'::jsonb, '"$96$ cm$^2$"'::jsonb, 'easy', '$100-4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square $10$ cm minus corner $2$ cm square. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram base $9$ m, height $4$ m. Area?', 'multiple_choice', '["$36$ m$^2$","$13$ m$^2$","$18$ m$^2$","$72$ m$^2$"]'::jsonb, '"$36$ m$^2$"'::jsonb, 'easy', '$bh$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram base $9$ m, height $4$ m. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trapezium parallel sides $5$ cm and $9$ cm, height $6$ cm. Area?', 'multiple_choice', '["$42$ cm$^2$","$54$ cm$^2$","$30$ cm$^2$","$84$ cm$^2$"]'::jsonb, '"$42$ cm$^2$"'::jsonb, 'medium', '$\frac{1}{2}(5+9) \times 6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trapezium parallel sides $5$ cm and $9$ cm, height $6$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Diameter $14$ cm. Area ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$154$ cm$^2$","$44$ cm$^2$","$77$ cm$^2$","$616$ cm$^2$"]'::jsonb, '"$154$ cm$^2$"'::jsonb, 'medium', '$r=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Diameter $14$ cm. Area ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rhombus diagonals $10$ cm and $24$ cm. Area?', 'multiple_choice', '["$120$ cm$^2$","$240$ cm$^2$","$60$ cm$^2$","$34$ cm$^2$"]'::jsonb, '"$120$ cm$^2$"'::jsonb, 'medium', '$\frac{1}{2}d_1 d_2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rhombus diagonals $10$ cm and $24$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $15$ by $10$ with circle radius $5$ removed ($\pi=3.14$). Area?', 'multiple_choice', '["$71.5$","$150$","$78.5$","$221.5$"]'::jsonb, '"$71.5$"'::jsonb, 'medium', '$150 - 78.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $15$ by $10$ with circle radius $5$ removed ($\pi=3.14$). Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Semi-circle diameter $10$ cm ($\pi=3.14$). Area?', 'multiple_choice', '["$39.25$ cm$^2$","$78.5$ cm$^2$","$31.4$ cm$^2$","$15.7$ cm$^2$"]'::jsonb, '"$39.25$ cm$^2$"'::jsonb, 'medium', 'Half $\pi r^2$, $r=5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Semi-circle diameter $10$ cm ($\pi=3.14$). Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle area $72$ cm$^2$, length $9$ cm. Width?', 'multiple_choice', '["$8$ cm","$9$ cm","$63$ cm","$81$ cm"]'::jsonb, '"$8$ cm"'::jsonb, 'medium', '$72 \div 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle area $72$ cm$^2$, length $9$ cm. Width?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'L-shape: $12$ by $8$ with $5$ by $3$ cut. Area?', 'multiple_choice', '["$81$","$96$","$15$","$111$"]'::jsonb, '"$81$"'::jsonb, 'medium', '$96-15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='L-shape: $12$ by $8$ with $5$ by $3$ cut. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square field $50$ m, circular flower bed $r=7$ m ($\pi=\frac{22}{7}$). Grass area?', 'multiple_choice', '["$2346$ m$^2$","$2500$ m$^2$","$154$ m$^2$","$2446$ m$^2$"]'::jsonb, '"$2346$ m$^2$"'::jsonb, 'hard', '$2500-154$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square field $50$ m, circular flower bed $r=7$ m ($\pi=\frac{22}{7}$). Grass area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle area $48$ cm$^2$, base $12$ cm. Height?', 'multiple_choice', '["$8$ cm","$4$ cm","$6$ cm","$24$ cm"]'::jsonb, '"$8$ cm"'::jsonb, 'hard', '$A=\frac{1}{2}bh$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle area $48$ cm$^2$, base $12$ cm. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ring: outer $r=10$, inner $r=6$ ($\pi=3.14$). Area?', 'multiple_choice', '["$200.96$","$314$","$113.04$","$87.92$"]'::jsonb, '"$200.96$"'::jsonb, 'hard', '$\pi(100-36)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ring: outer $r=10$, inner $r=6$ ($\pi=3.14$). Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $20$ by $12$ with two quarter-circles $r=6$ at ends ($\pi=3.14$). Area?', 'multiple_choice', '["$103.44$","$240$","$56.52$","$183.48$"]'::jsonb, '"$103.44$"'::jsonb, 'hard', 'Subtract semicircle area.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $20$ by $12$ with two quarter-circles $r=6$ at ends ($\pi=3.14$). Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trapezium area $60$ cm$^2$, height $8$ cm, one parallel side $5$ cm. Other side?', 'multiple_choice', '["$10$ cm","$15$ cm","$7.5$ cm","$12$ cm"]'::jsonb, '"$10$ cm"'::jsonb, 'hard', '$60=\frac{1}{2}(5+b)8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_plane_figures'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trapezium area $60$ cm$^2$, height $8$ cm, one parallel side $5$ cm. Other side?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A circular mat radius $0.35$ m. Area ($\pi=\frac{22}{7}$)?', 'multiple_choice', '["$0.385$ m$^2$","$0.77$ m$^2$","$0.154$ m$^2$","$1.54$ m$^2$"]'::jsonb, '"$0.385$ m$^2$"'::jsonb, 'hard', 'Small radius squared.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_circle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A circular mat radius $0.35$ m. Area ($\pi=\frac{22}{7}$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Path $1.5$ m wide around square garden side $20$ m. Path area?', 'multiple_choice', '["$129$ m$^2$","$400$ m$^2$","$126$ m$^2$","$23$ m$^2$"]'::jsonb, '"$129$ m$^2$"'::jsonb, 'hard', 'Outer $23$ square minus $400$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='area_combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Path $1.5$ m wide around square garden side $20$ m. Path area?');

-- ========== VOLUME AND CAPACITY ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Prisms', '{"blocks":[{"type":"heading","content":"Volume of Prisms"},{"type":"math_block","latex":"V = \\text{base area} \\times \\text{height}","caption":"Prism volume"},{"type":"paragraph","content":"A **prism** has the same cross-section along its length."},{"type":"example","title":"Cuboid $6$ cm by $4$ cm by $3$ cm","steps":["$V = 6 \\times 4 \\times 3 = 72$ cm$^3$."],"answer":"$72$ cm$^3$"},{"type":"question","questionText":"Cube side $5$ cm. Volume?","questionType":"multiple_choice","options":["$125$ cm$^3$","$25$ cm$^3$","$15$ cm$^3$","$75$ cm$^3$"],"correctAnswer":"$125$ cm$^3$","explanation":"$5^3$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'volume_prisms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Prisms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prism Volume Calculations', '{"blocks":[{"type":"heading","content":"Calculations"},{"type":"example","title":"Cylinder radius $7$ cm, height $10$ cm ($\\pi=\\frac{22}{7}$)","steps":["Base $= \\pi r^2 = 154$.","$V = 154 \\times 10 = 1540$ cm$^3$."],"answer":"$1540$ cm$^3$"},{"type":"callout","variant":"warning","content":"Volume uses square units times length $\\Rightarrow$ cubic units."},{"type":"question","questionText":"Cuboid $10$ by $5$ by $2$ cm. Volume?","questionType":"multiple_choice","options":["$100$ cm$^3$","$17$ cm$^3$","$50$ cm$^3$","$200$ cm$^3$"],"correctAnswer":"$100$ cm$^3$","explanation":"$10 \\times 5 \\times 2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'volume_prisms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prism Volume Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prism Volume Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Practice"},{"type":"example","title":"Triangular prism: triangle base $12$ cm$^2$, length $15$ cm","steps":["$V = 12 \\times 15 = 180$ cm$^3$."],"answer":"$180$ cm$^3$"},{"type":"question","questionText":"Cube volume $216$ cm$^3$. Side length?","questionType":"multiple_choice","options":["$6$ cm","$36$ cm","$8$ cm","$72$ cm"],"correctAnswer":"$6$ cm","explanation":"$6^3=216$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'volume_prisms'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prism Volume Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Capacity and Units', '{"blocks":[{"type":"heading","content":"Capacity Units"},{"type":"paragraph","content":"**Capacity** is the volume of liquid a container holds. $1$ litre (L) $= 1000$ cm$^3$ $= 1000$ mL."},{"type":"callout","variant":"key_point","content":"$1$ m$^3 = 1000$ L."},{"type":"example","title":"Convert $2.5$ L to mL","steps":["$2.5 \\times 1000 = 2500$ mL."],"answer":"$2500$ mL"},{"type":"question","questionText":"How many mL in $0.75$ L?","questionType":"multiple_choice","options":["$750$","$75$","$7500$","$7.5$"],"correctAnswer":"$750$","explanation":"$\\times 1000$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'capacity_units'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Capacity and Units');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Converting Capacity', '{"blocks":[{"type":"heading","content":"Capacity Conversions"},{"type":"example","title":"Tank holds $5000$ cm$^3$. Litres?","steps":["$5000 \\div 1000 = 5$ L."],"answer":"$5$ L"},{"type":"example","title":"Convert $3$ m$^3$ to litres","steps":["$3 \\times 1000 = 3000$ L."],"answer":"$3000$ L"},{"type":"question","questionText":"Convert $4.2$ L to cm$^3$.","questionType":"multiple_choice","options":["$4200$","$42$","$420$","$42000$"],"correctAnswer":"$4200$","explanation":"$1$ L $= 1000$ cm$^3$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'capacity_units'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Converting Capacity');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Capacity in Context', '{"blocks":[{"type":"heading","content":"Real Context"},{"type":"example","title":"A jerrycan holds $20$ L. How many mL?","steps":["$20 \\times 1000 = 20\\,000$ mL."],"answer":"$20\\,000$ mL"},{"type":"question","questionText":"Medicine bottle $250$ mL. How many full $50$ mL doses?","questionType":"multiple_choice","options":["$5$","$4$","$6$","$10$"],"correctAnswer":"$5$","explanation":"$250 \\div 50$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'capacity_units'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Capacity in Context');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume Applications — Concepts', '{"blocks":[{"type":"heading","content":"Applications"},{"type":"paragraph","content":"Volume problems include tanks, swimming pools, shipping containers, and soil excavation."},{"type":"example","title":"Water tank cuboid $2$ m by $1.5$ m by $1$ m. Capacity in litres?","steps":["$V = 3$ m$^3$.","$3 \\times 1000 = 3000$ L."],"answer":"$3000$ L"},{"type":"question","questionText":"Which unit suits water in a drum?","questionType":"multiple_choice","options":["Litres","cm$^2$","Metres","Grams"],"correctAnswer":"Litres","explanation":"Capacity measures liquid volume."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'applications_volume'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume Applications — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume Application Methods', '{"blocks":[{"type":"heading","content":"Methods"},{"type":"example","title":"Pool $25$ m by $10$ m by $2$ m. Volume in m$^3$?","steps":["$V = 500$ m$^3$."],"answer":"$500$ m$^3$"},{"type":"callout","variant":"warning","content":"Check whether the question wants cm$^3$, m$^3$, or litres."},{"type":"question","questionText":"Box $40$ cm by $30$ cm by $25$ cm. Volume in litres?","questionType":"multiple_choice","options":["$30$","$30000$","$3$","$300$"],"correctAnswer":"$30$","explanation":"$30000$ cm$^3 = 30$ L."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'applications_volume'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume Application Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume Exam Word Problems', '{"blocks":[{"type":"heading","content":"Exam Word Problems"},{"type":"example","title":"Cylindrical tank $r=0.7$ m, $h=2$ m ($\\pi=\\frac{22}{7}$). Litres?","steps":["$V=\\pi r^2 h=3.08$ m$^3$.","$\\approx 3080$ L."],"answer":"$3080$ L"},{"type":"question","questionText":"Excavation trench $12$ m by $0.5$ m by $1.5$ m. Volume?","questionType":"multiple_choice","options":["$9$ m$^3$","$18$ m$^3$","$6$ m$^3$","$12$ m$^3$"],"correctAnswer":"$9$ m$^3$","explanation":"$12 \\times 0.5 \\times 1.5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity' AND st.code = 'applications_volume'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume Exam Word Problems');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid $4$ by $3$ by $2$ cm. Volume?', 'multiple_choice', '["$24$ cm$^3$","$9$ cm$^3$","$12$ cm$^3$","$48$ cm$^3$"]'::jsonb, '"$24$ cm$^3$"'::jsonb, 'easy', '$4 \times 3 \times 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid $4$ by $3$ by $2$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube side $3$ cm. Volume?', 'multiple_choice', '["$27$ cm$^3$","$9$ cm$^3$","$6$ cm$^3$","$18$ cm$^3$"]'::jsonb, '"$27$ cm$^3$"'::jsonb, 'easy', '$3^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube side $3$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $2$ L to mL.', 'multiple_choice', '["$2000$","$200$","$20$","$20000$"]'::jsonb, '"$2000$"'::jsonb, 'easy', '$\times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $2$ L to mL.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many litres in $3000$ cm$^3$?', 'multiple_choice', '["$3$","$30$","$300$","$0.3$"]'::jsonb, '"$3$"'::jsonb, 'easy', '$\div 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many litres in $3000$ cm$^3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $1.5$ L to cm$^3$.', 'multiple_choice', '["$1500$","$150$","$15$","$15000$"]'::jsonb, '"$1500$"'::jsonb, 'easy', '$\times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $1.5$ L to cm$^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder $r=3$ cm, $h=10$ cm ($\pi=3.14$). Volume?', 'multiple_choice', '["$282.6$ cm$^3$","$94.2$ cm$^3$","$28.26$ cm$^3$","$314$ cm$^3$"]'::jsonb, '"$282.6$ cm$^3$"'::jsonb, 'easy', '$\pi r^2 h$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder $r=3$ cm, $h=10$ cm ($\pi=3.14$). Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tank $1$ m$^3$. Capacity in litres?', 'multiple_choice', '["$1000$","$100$","$10$","$10000$"]'::jsonb, '"$1000$"'::jsonb, 'easy', '$1$ m$^3=1000$ L.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tank $1$ m$^3$. Capacity in litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid volume $120$ cm$^3$, base $10$ cm$^2$. Height?', 'multiple_choice', '["$12$ cm","$10$ cm","$120$ cm","$110$ cm"]'::jsonb, '"$12$ cm"'::jsonb, 'medium', '$V \div \text{base}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid volume $120$ cm$^3$, base $10$ cm$^2$. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $5.5$ L to mL.', 'multiple_choice', '["$5500$","$550$","$55$","$55000$"]'::jsonb, '"$5500$"'::jsonb, 'medium', '$\times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $5.5$ L to mL.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube volume $343$ cm$^3$. Side?', 'multiple_choice', '["$7$ cm","$49$ cm","$6$ cm","$9$ cm"]'::jsonb, '"$7$ cm"'::jsonb, 'medium', '$7^3=343$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube volume $343$ cm$^3$. Side?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Box $50$ cm by $40$ cm by $30$ cm. Volume in litres?', 'multiple_choice', '["$60$","$60000$","$6$","$600$"]'::jsonb, '"$60$"'::jsonb, 'medium', '$60000$ cm$^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Box $50$ cm by $40$ cm by $30$ cm. Volume in litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder $r=7$ cm, $h=5$ cm ($\pi=\frac{22}{7}$). Volume?', 'multiple_choice', '["$770$ cm$^3$","$154$ cm$^3$","$385$ cm$^3$","$110$ cm$^3$"]'::jsonb, '"$770$ cm$^3$"'::jsonb, 'medium', '$154 \times 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder $r=7$ cm, $h=5$ cm ($\pi=\frac{22}{7}$). Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many $250$ mL cups from $3$ L?', 'multiple_choice', '["$12$","$10$","$15$","$8$"]'::jsonb, '"$12$"'::jsonb, 'medium', '$3000 \div 250$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many $250$ mL cups from $3$ L?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Aquarium $80$ cm by $40$ cm by $50$ cm. Litres of water?', 'multiple_choice', '["$160$","$160000$","$16$","$1600$"]'::jsonb, '"$160$"'::jsonb, 'medium', '$160000$ cm$^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Aquarium $80$ cm by $40$ cm by $50$ cm. Litres of water?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pool $20$ m by $8$ m by $1.5$ m. Volume in litres?', 'multiple_choice', '["$240\\,000$","$240$","$2400$","$24\\,000$"]'::jsonb, '"$240\\,000$"'::jsonb, 'hard', '$240$ m$^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pool $20$ m by $8$ m by $1.5$ m. Volume in litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Prism base area $45$ cm$^2$, length $12$ cm. Volume?', 'multiple_choice', '["$540$ cm$^3$","$57$ cm$^3$","$90$ cm$^3$","$450$ cm$^3$"]'::jsonb, '"$540$ cm$^3$"'::jsonb, 'hard', '$45 \times 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Prism base area $45$ cm$^2$, length $12$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tank cylindrical $r=1.4$ m, $h=2$ m ($\pi=\frac{22}{7}$). Litres?', 'multiple_choice', '["$1232$","$12.32$","$616$","$2464$"]'::jsonb, '"$1232$"'::jsonb, 'hard', 'Convert m$^3$ to L.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tank cylindrical $r=1.4$ m, $h=2$ m ($\pi=\frac{22}{7}$). Litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A pipe flows $0.5$ L per second. Volume in $2$ hours?', 'multiple_choice', '["$3600$ L","$360$ L","$7200$ L","$1800$ L"]'::jsonb, '"$3600$ L"'::jsonb, 'hard', '$0.5 \times 7200$ s.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A pipe flows $0.5$ L per second. Volume in $2$ hours?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hollow cuboid outer $10$ by $8$ by $6$, inner $8$ by $6$ by $4$. Volume of material?', 'multiple_choice', '["$288$ cm$^3$","$480$ cm$^3$","$192$ cm$^3$","$672$ cm$^3$"]'::jsonb, '"$288$ cm$^3$"'::jsonb, 'hard', 'Outer minus inner.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='volume_prisms'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hollow cuboid outer $10$ by $8$ by $6$, inner $8$ by $6$ by $4$. Volume of material?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Soil heap prism: triangle base $30$ m$^2$, length $12$ m. Volume?', 'multiple_choice', '["$360$ m$^3$","$180$ m$^3$","$42$ m$^3$","$720$ m$^3$"]'::jsonb, '"$360$ m$^3$"'::jsonb, 'hard', '$30 \times 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_volume'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Soil heap prism: triangle base $30$ m$^2$, length $12$ m. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Medicine $0.8$ L prescribed as $40$ mL doses. How many doses?', 'multiple_choice', '["$20$","$32$","$25$","$16$"]'::jsonb, '"$20$"'::jsonb, 'hard', '$800 \div 40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='capacity_units'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_capacity'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Medicine $0.8$ L prescribed as $40$ mL doses. How many doses?');
