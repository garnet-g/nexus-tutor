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
