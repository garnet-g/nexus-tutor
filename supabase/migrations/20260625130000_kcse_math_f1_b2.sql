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
