-- KCSE Form 1 Mathematics content slice (integers, algebraic_expressions, rates_ratio_proportion)
-- Idempotent seed: lessons + practice questions; soft-retires legacy generic KCSE math topics.

-- Soft-retire legacy generic KCSE math topics (CBC topics with same codes are untouched)
UPDATE public.topics t
SET is_active = false
FROM public.subjects s, public.curricula c
WHERE t.subject_id = s.id AND s.curriculum_id = c.id
  AND c.code = 'KCSE' AND s.code = 'mathematics'
  AND t.code IN ('algebra','fractions','geometry','trigonometry','statistics');

-- Added subtopics (confirmed Form 1 KNEC scope)
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'integer_applications', 'Integers in Real Life', 'Real-life integer problems.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'percentage_applications', 'Percentage Applications', 'Profit, loss, discount and commission.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;


-- ========== INTEGERS CONTENT ==========





INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Integers on the Number Line', '{"blocks":[{"type":"heading","content":"Integers on the Number Line"},{"type":"paragraph","content":"Integers are whole numbers and their opposites: $\\ldots, -3, -2, -1, 0, 1, 2, 3, \\ldots$ Numbers greater than zero are positive; numbers less than zero are negative; zero is neither."},{"type":"math_block","latex":"\\ldots\\; -3 \\; -2 \\; -1 \\; 0 \\; 1 \\; 2 \\; 3 \\; \\ldots","caption":"A number line: values increase to the right."},{"type":"callout","variant":"key_point","content":"On a number line, a number to the right is always greater. So $-1 > -3$, even though 3 looks bigger than 1."},{"type":"paragraph","content":"We use integers every day: a temperature of $-4^{\\circ}\\text{C}$, a debt of KES 200 written as $-200$, or 50 m below sea level as $-50$."},{"type":"example","title":"Order these from smallest to largest: $2, -5, 0, -1, 3$","steps":["Place each on the number line in your mind: the further left, the smaller.","The most negative is $-5$, then $-1$, then $0$, then $2$, then $3$."],"answer":"$-5, -1, 0, 2, 3$"},{"type":"callout","variant":"warning","content":"A common mistake is thinking $-5 > -1$ because 5 > 1. With negatives it is the opposite: $-5 < -1$."},{"type":"question","questionText":"Which number is greater: $-7$ or $-2$?","questionType":"multiple_choice","options":["$-7$","$-2$","They are equal","Cannot tell"],"correctAnswer":"$-2$","explanation":"On the number line $-2$ is to the right of $-7$, so $-2 > -7$."}],"shortQuiz":{"questions":[{"questionText":"Which of these is the smallest integer?","options":["$-3$","$-10$","$0$","$4$"],"correctAnswer":"$-10$"}]}}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Adding and Subtracting Integers', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Integers"},{"type":"paragraph","content":"When adding integers with the same sign, add the magnitudes and keep the sign. When signs differ, subtract the smaller magnitude from the larger and keep the sign of the larger."},{"type":"callout","variant":"key_point","content":"Subtracting a number is the same as adding its opposite: $a - b = a + (-b)$."},{"type":"example","title":"Evaluate $(-8) + (-3)$","steps":["Both numbers are negative — add magnitudes: $8 + 3 = 11$.","Keep the negative sign: $(-8) + (-3) = -11$."],"answer":"$-11$"},{"type":"example","title":"Evaluate $7 - (-4)$","steps":["Subtracting $-4$ means adding $+4$.","$7 + 4 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"Do not write $7 - -4$ without brackets — use $7 - (-4)$ to avoid sign errors."},{"type":"question","questionText":"Evaluate $5 + (-9)$.","questionType":"multiple_choice","options":["$-4$","$4$","$-14$","$14$"],"correctAnswer":"$-4$","explanation":"Signs differ: $9 - 5 = 4$; the larger magnitude is negative, so $-4$."}]}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Multiplying and Dividing Integers', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Integers"},{"type":"paragraph","content":"Same signs give a positive result. Different signs give a negative result."},{"type":"math_block","latex":"(+) \\times (+) = (+) \\quad (-) \\times (-) = (+) \\quad (+) \\times (-) = (-)","caption":"Sign rules for multiplication (division follows the same rules)."},{"type":"example","title":"Evaluate $(-6) \\times 4$","steps":["Signs are different, so the answer is negative.","$(-6) \\times 4 = -24$."],"answer":"$-24$"},{"type":"example","title":"Evaluate $(-20) \\div (-5)$","steps":["Both negative — result is positive.","$(-20) \\div (-5) = 4$."],"answer":"$4$"},{"type":"question","questionText":"Evaluate $(-3) \\times (-7)$.","questionType":"multiple_choice","options":["$21$","$-21$","$-10$","$10$"],"correctAnswer":"$21$","explanation":"Negative times negative = positive: $3 \\times 7 = 21$."}]}'::jsonb, 10, 2

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'BODMAS with Integers', '{"blocks":[{"type":"heading","content":"Order of Operations (BODMAS)"},{"type":"paragraph","content":"When an expression mixes operations, follow BODMAS: Brackets, Orders (powers), Division and Multiplication (left to right), Addition and Subtraction (left to right)."},{"type":"example","title":"Evaluate $3 + 4 \\times (-2)$","steps":["Multiplication before addition: $4 \\times (-2) = -8$.","$3 + (-8) = -5$."],"answer":"$-5$"},{"type":"example","title":"Evaluate $(6 - 10) \\div 2 + 3$","steps":["Brackets first: $6 - 10 = -4$.","Division: $(-4) \\div 2 = -2$.","Addition: $-2 + 3 = 1$."],"answer":"$1$"},{"type":"callout","variant":"warning","content":"A common mistake is working left to right and doing $3 + 4$ first in $3 + 4 \\times 2$."},{"type":"question","questionText":"Evaluate $2 \\times (5 - 8)^2$.","questionType":"multiple_choice","options":["$18$","$-18$","$36$","$-36$"],"correctAnswer":"$18$","explanation":"Brackets: $5-8=-3$; order: $(-3)^2=9$; $2 \\times 9 = 18$."}]}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'order_of_operations'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Integers in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Integers in Real Life"},{"type":"paragraph","content":"Integers model gains and losses: profit/loss in KES, temperature changes, altitude above/below sea level, and football goal differences."},{"type":"example","title":"A trader starts with KES 500. She makes a profit of KES 120, then a loss of KES 80. What is her net change?","steps":["Represent profit as $+120$ and loss as $-80$.","Net change: $120 + (-80) = 40$."],"answer":"Net gain of KES $40$"},{"type":"example","title":"The temperature at 6 a.m. was $-2^{\\circ}\\text{C}$. By noon it rose $9^{\\circ}\\text{C}$. What was the noon temperature?","steps":["Rise means add: $-2 + 9 = 7$."],"answer":"$7^{\\circ}\\text{C}$"},{"type":"callout","variant":"warning","content":"In word problems, decide whether each change is positive or negative before you calculate."},{"type":"question","questionText":"A submarine is at $-45$ m. It rises $20$ m. What is its new depth?","questionType":"multiple_choice","options":["$-25$ m","$-65$ m","$25$ m","$65$ m"],"correctAnswer":"$-25$ m","explanation":"Rising $20$ m: $-45 + 20 = -25$."}]}'::jsonb, 10, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'integer_applications'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers in Kenyan Contexts'

);



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Which integer is greatest?', 'multiple_choice', '["$-4$","$-1$","$-9$","$-6$"]'::jsonb, '"$-1$"'::jsonb, 'easy', 'On the number line $-1$ is furthest right.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which integer is greatest?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Which is the smallest: $3, -2, 0, -5$?', 'multiple_choice', '["$3$","$-2$","$0$","$-5$"]'::jsonb, '"$-5$"'::jsonb, 'easy', '$-5$ is furthest left on the number line.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the smallest: $3, -2, 0, -5$?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-3) + (-5)$.', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Adding two negatives: add magnitudes, keep negative sign.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-3) + (-5)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $8 - 12$.', 'multiple_choice', '["$-4$","$4$","$20$","$-20$"]'::jsonb, '"$-4$"'::jsonb, 'easy', '$8 - 12 = -4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $8 - 12$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-4) \times 3$.', 'multiple_choice', '["$-12$","$12$","$-7$","$7$"]'::jsonb, '"$-12$"'::jsonb, 'easy', 'Different signs: negative result.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-4) \times 3$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $15 \div (-3)$.', 'multiple_choice', '["$-5$","$5$","$-12$","$12$"]'::jsonb, '"$-5$"'::jsonb, 'easy', 'Different signs give a negative quotient.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \div (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $10 - 3 \times 2$.', 'multiple_choice', '["$4$","$14$","$-4$","$16$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Multiply first: $3 \times 2 = 6$; $10 - 6 = 4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10 - 3 \times 2$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'A bank balance of $-500$ KES means:', 'multiple_choice', '["A debt of KES 500","A credit of KES 500","Zero balance","KES 1000 credit"]'::jsonb, '"A debt of KES 500"'::jsonb, 'easy', 'Negative balance represents money owed.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bank balance of $-500$ KES means:');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-7 - (-3)$.', 'multiple_choice', '["$-4$","$-10$","$4$","$10$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$-7 - (-3) = -7 + 3 = -4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-7 - (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-6) \times 4 \div (-2)$.', 'multiple_choice', '["$12$","$-12$","$-48$","$48$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Left to right: $-24 \div -2 = 12$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-6) \times 4 \div (-2)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-2) + 5 - 8$.', 'multiple_choice', '["$-5$","$5$","$-15$","$15$"]'::jsonb, '"$-5$"'::jsonb, 'medium', 'Left to right: $3 - 8 = -5$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2) + 5 - 8$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $4 + 3 \times (-2)^2$.', 'multiple_choice', '["$16$","$-8$","$10$","$-32$"]'::jsonb, '"$16$"'::jsonb, 'medium', 'Power first: $(-2)^2=4$; $3 \times 4=12$; $4+12=16$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $4 + 3 \times (-2)^2$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(8 - 14) \div 3 + 5$.', 'multiple_choice', '["$3$","$-3$","$7$","$-7$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Brackets: $-6 \div 3 = -2$; $-2 + 5 = 3$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(8 - 14) \div 3 + 5$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-3 \times (4 - 7)$.', 'multiple_choice', '["$9$","$-9$","$-21$","$21$"]'::jsonb, '"$9$"'::jsonb, 'medium', 'Brackets: $4-7=-3$; $-3 \times -3 = 9$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-3 \times (4 - 7)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?', 'multiple_choice', '["$-5^{\\circ}\\text{C}$","$5^{\\circ}\\text{C}$","$11^{\\circ}\\text{C}$","$-11^{\\circ}\\text{C}$"]'::jsonb, '"$-5^{\\circ}\\text{C}$"'::jsonb, 'medium', '$3 + (-8) = -5$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Football: scored $4$, conceded $7$. Goal difference?', 'multiple_choice', '["$-3$","$3$","$11$","$-11$"]'::jsonb, '"$-3$"'::jsonb, 'medium', 'Difference: $4 - 7 = -3$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Football: scored $4$, conceded $7$. Goal difference?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-2)^3 + (-1)^4$.', 'multiple_choice', '["$-7$","$7$","$-9$","$9$"]'::jsonb, '"$-7$"'::jsonb, 'hard', '$(-2)^3=-8$; $(-1)^4=1$; $-8+1=-7$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2)^3 + (-1)^4$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $6 \div (-2) + 4 \times (-3)$.', 'multiple_choice', '["$-15$","$15$","$-9$","$9$"]'::jsonb, '"$-15$"'::jsonb, 'hard', '$-3 + (-12) = -15$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $6 \div (-2) + 4 \times (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?', 'multiple_choice', '["$1^{\\circ}\\text{C}$","$-1^{\\circ}\\text{C}$","$9^{\\circ}\\text{C}$","$21^{\\circ}\\text{C}$"]'::jsonb, '"$1^{\\circ}\\text{C}$"'::jsonb, 'hard', '$-4+11=7$; $7-6=1$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?', 'multiple_choice', '["$-1$","$1$","$-5$","$5$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$0+12-18+5=-1$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.', 'multiple_choice', '["$24$","$-24$","$10$","$-10$"]'::jsonb, '"$24$"'::jsonb, 'hard', 'Four negatives: pairs give positives; product is $24$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.', 'multiple_choice', '["$-27$","$27$","$-23$","$23$"]'::jsonb, '"$-27$"'::jsonb, 'hard', '$(3-8)=-5$; $(-5)^2=25$; $-25+2(-1)=-27$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'How many integers lie strictly between $-3$ and $4$?', 'multiple_choice', '["$6$","$7$","$8$","$5$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Integers: $-2,-1,0,1,2,3$ — six values.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers lie strictly between $-3$ and $4$?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?', 'multiple_choice', '["KES $30$ profit","KES $30$ loss","KES $830$ profit","KES $830$ loss"]'::jsonb, '"KES $30$ profit"'::jsonb, 'hard', '$250-400+180=30$ net profit.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'If $a = -3$ and $b = -4$, evaluate $2a - b$.', 'multiple_choice', '["$-2$","$2$","$-10$","$10$"]'::jsonb, '"$-2$"'::jsonb, 'hard', '$2(-3)-(-4)=-6+4=-2$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = -3$ and $b = -4$, evaluate $2a - b$.');



-- ========== INTEGERS CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers on the Number Line', '{"blocks":[{"type":"heading","content":"Integers on the Number Line"},{"type":"paragraph","content":"Integers are whole numbers and their opposites: $\\ldots, -3, -2, -1, 0, 1, 2, 3, \\ldots$ Numbers greater than zero are positive; numbers less than zero are negative; zero is neither."},{"type":"math_block","latex":"\\ldots\\; -3 \\; -2 \\; -1 \\; 0 \\; 1 \\; 2 \\; 3 \\; \\ldots","caption":"A number line: values increase to the right."},{"type":"callout","variant":"key_point","content":"On a number line, a number to the right is always greater. So $-1 > -3$, even though 3 looks bigger than 1."},{"type":"paragraph","content":"We use integers every day: a temperature of $-4^{\\circ}\\text{C}$, a debt of KES 200 written as $-200$, or 50 m below sea level as $-50$."},{"type":"example","title":"Order these from smallest to largest: $2, -5, 0, -1, 3$","steps":["Place each on the number line in your mind: the further left, the smaller.","The most negative is $-5$, then $-1$, then $0$, then $2$, then $3$."],"answer":"$-5, -1, 0, 2, 3$"},{"type":"callout","variant":"warning","content":"A common mistake is thinking $-5 > -1$ because 5 > 1. With negatives it is the opposite: $-5 < -1$."},{"type":"question","questionText":"Which number is greater: $-7$ or $-2$?","questionType":"multiple_choice","options":["$-7$","$-2$","They are equal","Cannot tell"],"correctAnswer":"$-2$","explanation":"On the number line $-2$ is to the right of $-7$, so $-2 > -7$."}],"shortQuiz":{"questions":[{"questionText":"Which of these is the smallest integer?","options":["$-3$","$-10$","$0$","$4$"],"correctAnswer":"$-10$"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Integers', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Integers"},{"type":"paragraph","content":"When adding integers with the same sign, add the magnitudes and keep the sign. When signs differ, subtract the smaller magnitude from the larger and keep the sign of the larger."},{"type":"callout","variant":"key_point","content":"Subtracting a number is the same as adding its opposite: $a - b = a + (-b)$."},{"type":"example","title":"Evaluate $(-8) + (-3)$","steps":["Both numbers are negative — add magnitudes: $8 + 3 = 11$.","Keep the negative sign: $(-8) + (-3) = -11$."],"answer":"$-11$"},{"type":"example","title":"Evaluate $7 - (-4)$","steps":["Subtracting $-4$ means adding $+4$.","$7 + 4 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"Do not write $7 - -4$ without brackets — use $7 - (-4)$ to avoid sign errors."},{"type":"question","questionText":"Evaluate $5 + (-9)$.","questionType":"multiple_choice","options":["$-4$","$4$","$-14$","$14$"],"correctAnswer":"$-4$","explanation":"Signs differ: $9 - 5 = 4$; the larger magnitude is negative, so $-4$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying and Dividing Integers', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Integers"},{"type":"paragraph","content":"Same signs give a positive result. Different signs give a negative result."},{"type":"math_block","latex":"(+) \\times (+) = (+) \\quad (-) \\times (-) = (+) \\quad (+) \\times (-) = (-)","caption":"Sign rules for multiplication (division follows the same rules)."},{"type":"example","title":"Evaluate $(-6) \\times 4$","steps":["Signs are different, so the answer is negative.","$(-6) \\times 4 = -24$."],"answer":"$-24$"},{"type":"example","title":"Evaluate $(-20) \\div (-5)$","steps":["Both negative — result is positive.","$(-20) \\div (-5) = 4$."],"answer":"$4$"},{"type":"question","questionText":"Evaluate $(-3) \\times (-7)$.","questionType":"multiple_choice","options":["$21$","$-21$","$-10$","$10$"],"correctAnswer":"$21$","explanation":"Negative times negative = positive: $3 \\times 7 = 21$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'BODMAS with Integers', '{"blocks":[{"type":"heading","content":"Order of Operations (BODMAS)"},{"type":"paragraph","content":"When an expression mixes operations, follow BODMAS: Brackets, Orders (powers), Division and Multiplication (left to right), Addition and Subtraction (left to right)."},{"type":"example","title":"Evaluate $3 + 4 \\times (-2)$","steps":["Multiplication before addition: $4 \\times (-2) = -8$.","$3 + (-8) = -5$."],"answer":"$-5$"},{"type":"example","title":"Evaluate $(6 - 10) \\div 2 + 3$","steps":["Brackets first: $6 - 10 = -4$.","Division: $(-4) \\div 2 = -2$.","Addition: $-2 + 3 = 1$."],"answer":"$1$"},{"type":"callout","variant":"warning","content":"A common mistake is working left to right and doing $3 + 4$ first in $3 + 4 \\times 2$."},{"type":"question","questionText":"Evaluate $2 \\times (5 - 8)^2$.","questionType":"multiple_choice","options":["$18$","$-18$","$36$","$-36$"],"correctAnswer":"$18$","explanation":"Brackets: $5-8=-3$; order: $(-3)^2=9$; $2 \\times 9 = 18$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'order_of_operations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Integers in Real Life"},{"type":"paragraph","content":"Integers model gains and losses: profit/loss in KES, temperature changes, altitude above/below sea level, and football goal differences."},{"type":"example","title":"A trader makes a profit of KES 120, then a loss of KES 80. What is her net change?","steps":["Represent profit as $+120$ and loss as $-80$.","Net change: $120 + (-80) = 40$."],"answer":"Net gain of KES $40$"},{"type":"example","title":"The temperature at 6 a.m. was $-2^{\\circ}\\text{C}$. By noon it rose $9^{\\circ}\\text{C}$. What was the noon temperature?","steps":["Rise means add: $-2 + 9 = 7$."],"answer":"$7^{\\circ}\\text{C}$"},{"type":"callout","variant":"warning","content":"In word problems, decide whether each change is positive or negative before you calculate."},{"type":"question","questionText":"A submarine is at $-45$ m. It rises $20$ m. What is its new depth?","questionType":"multiple_choice","options":["$-25$ m","$-65$ m","$25$ m","$65$ m"],"correctAnswer":"$-25$ m","explanation":"Rising $20$ m: $-45 + 20 = -25$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'integer_applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers in Kenyan Contexts');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which integer is greatest?', 'multiple_choice', '["$-4$","$-1$","$-9$","$-6$"]'::jsonb, '"$-1$"'::jsonb, 'easy', 'On the number line $-1$ is furthest right.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which integer is greatest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is the smallest: $3, -2, 0, -5$?', 'multiple_choice', '["$3$","$-2$","$0$","$-5$"]'::jsonb, '"$-5$"'::jsonb, 'easy', '$-5$ is furthest left on the number line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the smallest: $3, -2, 0, -5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-3) + (-5)$.', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Adding two negatives: add magnitudes, keep negative sign.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-3) + (-5)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $8 - 12$.', 'multiple_choice', '["$-4$","$4$","$20$","$-20$"]'::jsonb, '"$-4$"'::jsonb, 'easy', '$8 - 12 = -4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $8 - 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-4) \times 3$.', 'multiple_choice', '["$-12$","$12$","$-7$","$7$"]'::jsonb, '"$-12$"'::jsonb, 'easy', 'Different signs: negative result.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-4) \times 3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $15 \div (-3)$.', 'multiple_choice', '["$-5$","$5$","$-12$","$12$"]'::jsonb, '"$-5$"'::jsonb, 'easy', 'Different signs give a negative quotient.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \div (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $10 - 3 \times 2$.', 'multiple_choice', '["$4$","$14$","$-4$","$16$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Multiply first: $3 \times 2 = 6$; $10 - 6 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10 - 3 \times 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A bank balance of $-500$ KES means:', 'multiple_choice', '["A debt of KES 500","A credit of KES 500","Zero balance","KES 1000 credit"]'::jsonb, '"A debt of KES 500"'::jsonb, 'easy', 'Negative balance represents money owed.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bank balance of $-500$ KES means:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-7 - (-3)$.', 'multiple_choice', '["$-4$","$-10$","$4$","$10$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$-7 - (-3) = -7 + 3 = -4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-7 - (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-6) \times 4 \div (-2)$.', 'multiple_choice', '["$12$","$-12$","$-48$","$48$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Left to right: $-24 \div -2 = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-6) \times 4 \div (-2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-2) + 5 - 8$.', 'multiple_choice', '["$-5$","$5$","$-15$","$15$"]'::jsonb, '"$-5$"'::jsonb, 'medium', 'Left to right: $3 - 8 = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2) + 5 - 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $4 + 3 \times (-2)^2$.', 'multiple_choice', '["$16$","$-8$","$10$","$-32$"]'::jsonb, '"$16$"'::jsonb, 'medium', 'Power first: $(-2)^2=4$; $3 \times 4=12$; $4+12=16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $4 + 3 \times (-2)^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(8 - 14) \div 3 + 5$.', 'multiple_choice', '["$3$","$-3$","$7$","$-7$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Brackets: $-6 \div 3 = -2$; $-2 + 5 = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(8 - 14) \div 3 + 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-3 \times (4 - 7)$.', 'multiple_choice', '["$9$","$-9$","$-21$","$21$"]'::jsonb, '"$9$"'::jsonb, 'medium', 'Brackets: $4-7=-3$; $-3 \times -3 = 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-3 \times (4 - 7)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?', 'multiple_choice', '["$-5^{\\circ}\\text{C}$","$5^{\\circ}\\text{C}$","$11^{\\circ}\\text{C}$","$-11^{\\circ}\\text{C}$"]'::jsonb, '"$-5^{\\circ}\\text{C}$"'::jsonb, 'medium', '$3 + (-8) = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Football: scored $4$, conceded $7$. Goal difference?', 'multiple_choice', '["$-3$","$3$","$11$","$-11$"]'::jsonb, '"$-3$"'::jsonb, 'medium', 'Difference: $4 - 7 = -3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Football: scored $4$, conceded $7$. Goal difference?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-2)^3 + (-1)^4$.', 'multiple_choice', '["$-7$","$7$","$-9$","$9$"]'::jsonb, '"$-7$"'::jsonb, 'hard', '$(-2)^3=-8$; $(-1)^4=1$; $-8+1=-7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2)^3 + (-1)^4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $6 \div (-2) + 4 \times (-3)$.', 'multiple_choice', '["$-15$","$15$","$-9$","$9$"]'::jsonb, '"$-15$"'::jsonb, 'hard', '$-3 + (-12) = -15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $6 \div (-2) + 4 \times (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?', 'multiple_choice', '["$1^{\\circ}\\text{C}$","$-1^{\\circ}\\text{C}$","$9^{\\circ}\\text{C}$","$21^{\\circ}\\text{C}$"]'::jsonb, '"$1^{\\circ}\\text{C}$"'::jsonb, 'hard', '$-4+11=7$; $7-6=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?', 'multiple_choice', '["$-1$","$1$","$-5$","$5$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$0+12-18+5=-1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.', 'multiple_choice', '["$24$","$-24$","$10$","$-10$"]'::jsonb, '"$24$"'::jsonb, 'hard', 'Four negatives: pairs give positives; product is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.', 'multiple_choice', '["$-27$","$27$","$-23$","$23$"]'::jsonb, '"$-27$"'::jsonb, 'hard', '$(3-8)=-5$; $(-5)^2=25$; $-25+2(-1)=-27$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many integers lie strictly between $-3$ and $4$?', 'multiple_choice', '["$6$","$7$","$8$","$5$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Integers: $-2,-1,0,1,2,3$ — six values.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers lie strictly between $-3$ and $4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?', 'multiple_choice', '["KES $30$ profit","KES $30$ loss","KES $830$ profit","KES $830$ loss"]'::jsonb, '"KES $30$ profit"'::jsonb, 'hard', '$250-400+180=30$ net profit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a = -3$ and $b = -4$, evaluate $2a - b$.', 'multiple_choice', '["$-2$","$2$","$-10$","$10$"]'::jsonb, '"$-2$"'::jsonb, 'hard', '$2(-3)-(-4)=-6+4=-2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = -3$ and $b = -4$, evaluate $2a - b$.');
-- ========== ALGEBRAIC EXPRESSIONS CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'From Words to Algebra', '{"blocks":[{"type":"heading","content":"Forming Algebraic Expressions"},{"type":"paragraph","content":"An algebraic expression uses letters (variables) to stand for unknown numbers. We translate word statements into symbols."},{"type":"callout","variant":"key_point","content":"Common phrases: ''sum of'' $\\rightarrow$ add; ''product of'' $\\rightarrow$ multiply; ''twice'' $\\rightarrow$ $2\\times$; ''more than'' $\\rightarrow$ add after the number."},{"type":"example","title":"Write an expression for: five more than a number $n$","steps":["''Five more than'' means add $5$ after the number.","Expression: $n + 5$."],"answer":"$n + 5$"},{"type":"example","title":"Write an expression for: the product of $3$ and a number $x$, decreased by $2$","steps":["Product of $3$ and $x$: $3x$.","Decreased by $2$: subtract $2$.","Expression: $3x - 2$."],"answer":"$3x - 2$"},{"type":"question","questionText":"Which expression means ''seven less than a number $y$''?","questionType":"multiple_choice","options":["$7 - y$","$y - 7$","$7y$","$y + 7$"],"correctAnswer":"$y - 7$","explanation":"''Less than $y$'' means start with $y$ and subtract $7$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'forming_expressions'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'From Words to Algebra');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expressions from Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Real-Life Expressions"},{"type":"example","title":"Matatu fare is KES $50$ plus KES $2$ per km. Write fare for $k$ km.","steps":["Fixed part: $50$.","Variable part: $2$ per km $\\rightarrow$ $2k$.","Total: $50 + 2k$."],"answer":"$50 + 2k$ KES"},{"type":"callout","variant":"warning","content":"Do not confuse ''KES $2$ per km'' ($2k$) with ''KES $2$ more than $k$'' ($k+2$)."},{"type":"question","questionText":"A shop sells $n$ notebooks at KES $80$ each. Write the total cost.","questionType":"multiple_choice","options":["$80n$","$n + 80$","$80 - n$","$n/80$"],"correctAnswer":"$80n$","explanation":"Total = price per item $\\times$ number of items."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'forming_expressions'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expressions from Kenyan Contexts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Collecting Like Terms', '{"blocks":[{"type":"heading","content":"Simplifying by Collecting Like Terms"},{"type":"paragraph","content":"Like terms have the same variable part (e.g. $3x$ and $-5x$). Add or subtract their coefficients; constants stay separate."},{"type":"example","title":"Simplify $4x + 3 - 2x + 7$","steps":["Group $x$-terms: $4x - 2x = 2x$.","Group constants: $3 + 7 = 10$.","Result: $2x + 10$."],"answer":"$2x + 10$"},{"type":"example","title":"Simplify $5a - 3b + 2a + b$","steps":["$a$-terms: $5a + 2a = 7a$.","$b$-terms: $-3b + b = -2b$.","Result: $7a - 2b$."],"answer":"$7a - 2b$"},{"type":"callout","variant":"warning","content":"$3x$ and $3y$ are not like terms — do not combine them."},{"type":"question","questionText":"Simplify $6y - 4 + 2y + 1$.","questionType":"multiple_choice","options":["$8y - 3$","$8y + 5$","$4y - 3$","$4y + 5$"],"correctAnswer":"$8y - 3$","explanation":"$6y+2y=8y$; $-4+1=-3$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'simplification'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Collecting Like Terms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding Brackets', '{"blocks":[{"type":"heading","content":"Removing Brackets"},{"type":"paragraph","content":"Multiply each term inside the bracket by the term outside: $a(b + c) = ab + ac$."},{"type":"example","title":"Expand $3(x + 4)$","steps":["$3 \\times x = 3x$.","$3 \\times 4 = 12$.","Result: $3x + 12$."],"answer":"$3x + 12$"},{"type":"example","title":"Expand and simplify $2(3a - 1) + 4a$","steps":["Expand: $6a - 2$.","Add $4a$: $6a + 4a - 2 = 10a - 2$."],"answer":"$10a - 2$"},{"type":"question","questionText":"Expand $5(2m - 3)$.","questionType":"multiple_choice","options":["$10m - 15$","$10m - 3$","$7m - 15$","$2m - 15$"],"correctAnswer":"$10m - 15$","explanation":"$5 \\times 2m = 10m$; $5 \\times (-3) = -15$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'simplification'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding Brackets');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Evaluating Expressions', '{"blocks":[{"type":"heading","content":"Substitution"},{"type":"paragraph","content":"To substitute, replace each variable with the given value, then calculate. Use brackets when substituting negatives."},{"type":"example","title":"If $x = 4$, find $3x + 5$.","steps":["Replace $x$ with $4$: $3(4) + 5$.","$12 + 5 = 17$."],"answer":"$17$"},{"type":"example","title":"If $a = -2$, find $a^2 - 3a + 1$.","steps":["$(-2)^2 = 4$.","$-3(-2) = 6$.","$4 + 6 + 1 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"When $x = -3$, write $2x$ as $2(-3)$, not $2-3$."},{"type":"question","questionText":"If $n = 5$, what is $2n - 7$?","questionType":"multiple_choice","options":["$3$","$17$","$-3$","$10$"],"correctAnswer":"$3$","explanation":"$2(5) - 7 = 10 - 7 = 3$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'substitution'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Evaluating Expressions');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write ''a number $x$ increased by $9$'' as an expression.', 'multiple_choice', '["$x + 9$","$9x$","$x - 9$","$9 - x$"]'::jsonb, '"$x + 9$"'::jsonb, 'easy', '''Increased by'' means add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write ''a number $x$ increased by $9$'' as an expression.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which means ''double a number $n$''?', 'multiple_choice', '["$2n$","$n + 2$","$n^2$","$n/2$"]'::jsonb, '"$2n$"'::jsonb, 'easy', 'Double means multiply by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which means ''double a number $n$''?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cost is KES $100$ plus KES $5$ per item for $p$ items. Expression?', 'multiple_choice', '["$100 + 5p$","$105p$","$100p + 5$","$5 + 100p$"]'::jsonb, '"$100 + 5p$"'::jsonb, 'easy', 'Fixed $100$ plus $5$ per item.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cost is KES $100$ plus KES $5$ per item for $p$ items. Expression?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '''The sum of $a$ and $b$'' is:', 'multiple_choice', '["$a + b$","$ab$","$a - b$","$2ab$"]'::jsonb, '"$a + b$"'::jsonb, 'easy', 'Sum means add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='''The sum of $a$ and $b$'' is:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $5x + 2x$.', 'multiple_choice', '["$7x$","$10x$","$7x^2$","$3x$"]'::jsonb, '"$7x$"'::jsonb, 'easy', 'Add coefficients: $5+2=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $5x + 2x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $8 - 3 + 2$.', 'multiple_choice', '["$7$","$13$","$3$","$9$"]'::jsonb, '"$7$"'::jsonb, 'easy', 'Constants only: $8-3+2=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $8 - 3 + 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $x = 3$, find $x + 4$.', 'multiple_choice', '["$7$","$12$","$1$","$34$"]'::jsonb, '"$7$"'::jsonb, 'easy', '$3 + 4 = 7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $x = 3$, find $x + 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $y = 10$, find $2y$.', 'multiple_choice', '["$20$","$12$","$5$","$100$"]'::jsonb, '"$20$"'::jsonb, 'easy', '$2 \times 10 = 20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $y = 10$, find $2y$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perimeter of square of side $s$: which expression?', 'multiple_choice', '["$4s$","$s^4$","$s + 4$","$2s$"]'::jsonb, '"$4s$"'::jsonb, 'medium', 'Four equal sides: $s+s+s+s=4s$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perimeter of square of side $s$: which expression?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '''$3$ less than twice $x$'' is:', 'multiple_choice', '["$2x - 3$","$3 - 2x$","$2x + 3$","$3x - 2$"]'::jsonb, '"$2x - 3$"'::jsonb, 'medium', 'Twice $x$ is $2x$; three less: $2x-3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='''$3$ less than twice $x$'' is:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tickets: adult KES $a$, child KES $c$. Cost of $2$ adults and $3$ children?', 'multiple_choice', '["$2a + 3c$","$5ac$","$a + c$","$6ac$"]'::jsonb, '"$2a + 3c$"'::jsonb, 'medium', 'Multiply each price by quantity and add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tickets: adult KES $a$, child KES $c$. Cost of $2$ adults and $3$ children?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $4a + 3b - a + 2b$.', 'multiple_choice', '["$3a + 5b$","$5a + 5b$","$3a + b$","$5a + b$"]'::jsonb, '"$3a + 5b$"'::jsonb, 'medium', '$4a-a=3a$; $3b+2b=5b$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $4a + 3b - a + 2b$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $4(2x - 5)$.', 'multiple_choice', '["$8x - 20$","$8x - 5$","$6x - 20$","$2x - 20$"]'::jsonb, '"$8x - 20$"'::jsonb, 'medium', 'Distribute $4$ to both terms.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $4(2x - 5)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $3(x + 2) - 2x$.', 'multiple_choice', '["$x + 6$","$5x + 6$","$x + 2$","$5x + 2$"]'::jsonb, '"$x + 6$"'::jsonb, 'medium', 'Expand $3x+6$; subtract $2x$ $\rightarrow$ $x+6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $3(x + 2) - 2x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $p = -1$, find $p^2 + 2p$.', 'multiple_choice', '["$-1$","$1$","$-3$","$3$"]'::jsonb, '"$-1$"'::jsonb, 'medium', '$1 + (-2) = -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $p = -1$, find $p^2 + 2p$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a = 2$, $b = 3$, find $3a + 2b$.', 'multiple_choice', '["$12$","$13$","$10$","$18$"]'::jsonb, '"$12$"'::jsonb, 'medium', '$6 + 6 = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = 2$, $b = 3$, find $3a + 2b$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $m = -4$, find $m^2 - 1$.', 'multiple_choice', '["$15$","$17$","$-17$","$-15$"]'::jsonb, '"$15$"'::jsonb, 'medium', '$(-4)^2=16$; $16-1=15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $m = -4$, find $m^2 - 1$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Age: Ali is $5$ years older than twice Grace''''s age $g$. Ali''''s age?', 'multiple_choice', '["$2g + 5$","$2(g+5)$","$g + 5$","$5g + 2$"]'::jsonb, '"$2g + 5$"'::jsonb, 'hard', 'Twice Grace''''s age plus $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Age: Ali is $5$ years older than twice Grace''''s age $g$. Ali''''s age?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $2(3x - 1) - 3(x + 2)$.', 'multiple_choice', '["$3x - 8$","$3x - 2$","$9x - 8$","$x - 8$"]'::jsonb, '"$3x - 8$"'::jsonb, 'hard', '$6x-2-3x-6=3x-8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $2(3x - 1) - 3(x + 2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $5x - 2(3 - x) + 4$.', 'multiple_choice', '["$7x - 2$","$7x + 2$","$3x - 2$","$11x - 2$"]'::jsonb, '"$7x - 2$"'::jsonb, 'hard', '$5x-6+2x+4=7x-2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $5x - 2(3 - x) + 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $x = -3$, $y = 2$, find $x^2 + xy - y^2$.', 'multiple_choice', '["$-1$","$1$","$7$","$-7$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$9 + (-6) - 4 = -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $x = -3$, $y = 2$, find $x^2 + xy - y^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle: length $(2x+1)$ cm, width $x$ cm. Perimeter?', 'multiple_choice', '["$6x + 2$","$2x^2 + x$","$4x + 2$","$6x + 1$"]'::jsonb, '"$6x + 2$"'::jsonb, 'hard', '$2(2x+1+x)=2(3x+1)=6x+2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle: length $(2x+1)$ cm, width $x$ cm. Perimeter?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expression $3n^2 - 2n + 1$ when $n = -2$?', 'multiple_choice', '["$17$","$9$","$-3$","$13$"]'::jsonb, '"$17$"'::jsonb, 'hard', '$12+4+1=17$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expression $3n^2 - 2n + 1$ when $n = -2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{6x}{2} + 4x$.', 'multiple_choice', '["$7x$","$3x + 4x$","$10x$","$5x$"]'::jsonb, '"$7x$"'::jsonb, 'hard', '$3x + 4x = 7x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{6x}{2} + 4x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a + b = 7$ and $a = 3$, find $b$ then evaluate $2a + 3b$.', 'multiple_choice', '["$18$","$21$","$15$","$12$"]'::jsonb, '"$18$"'::jsonb, 'hard', '$b=4$; $2(3)+3(4)=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a + b = 7$ and $a = 3$, find $b$ then evaluate $2a + 3b$.');
-- ========== RATES, RATIO & PROPORTION CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Rates', '{"blocks":[{"type":"heading","content":"Rates"},{"type":"paragraph","content":"A rate compares two quantities with different units, e.g. km per hour, KES per kg, litres per minute."},{"type":"math_block","latex":"\\text{Rate} = \\frac{\\text{quantity}}{\\text{time (or unit)}}","caption":"Unit rate = amount per one unit."},{"type":"example","title":"A car travels $120$ km in $2$ hours. Find the speed.","steps":["Rate = distance $\\div$ time.","$120 \\div 2 = 60$ km/h."],"answer":"$60$ km/h"},{"type":"question","questionText":"$8$ books cost KES $400$. What is the cost per book?","questionType":"multiple_choice","options":["KES $50$","KES $32$","KES $408$","KES $392$"],"correctAnswer":"KES $50$","explanation":"$400 \\div 8 = 50$ KES per book."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'rates'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Rates');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Ratio and Sharing', '{"blocks":[{"type":"heading","content":"Ratio and Proportion"},{"type":"paragraph","content":"A ratio compares parts of the same whole, written $a : b$. To share KES $600$ in ratio $2:3$, total parts $= 5$, each part $= 600/5 = 120$."},{"type":"example","title":"Share KES $800$ in the ratio $3:5$","steps":["Total parts: $3 + 5 = 8$.","One part: $800 \\div 8 = 100$.","Shares: $3 \\times 100 = 300$, $5 \\times 100 = 500$."],"answer":"KES $300$ and KES $500$"},{"type":"callout","variant":"warning","content":"Simplify ratios like fractions: $12:8 = 3:2$."},{"type":"question","questionText":"Divide $24$ sweets in ratio $1:3$. How many does the smaller share get?","questionType":"multiple_choice","options":["$6$","$8$","$18$","$12$"],"correctAnswer":"$6$","explanation":"Parts $=4$; $24/4=6$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Ratio and Sharing');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Direct and Inverse Proportion', '{"blocks":[{"type":"heading","content":"Proportion"},{"type":"paragraph","content":"Direct proportion: as one quantity doubles, so does the other ($y = kx$). Inverse proportion: as one doubles, the other halves ($xy = k$)."},{"type":"example","title":"If $5$ workers take $12$ days, how long for $10$ workers? (same job)","steps":["More workers $\\rightarrow$ fewer days (inverse).","$5 \\times 12 = 60$ worker-days.","$60 \\div 10 = 6$ days."],"answer":"$6$ days"},{"type":"question","questionText":"If $3$ pens cost KES $150$, what do $8$ pens cost? (direct)","questionType":"multiple_choice","options":["KES $400$","KES $450$","KES $350$","KES $500$"],"correctAnswer":"KES $400$","explanation":"One pen KES $50$; $8 \\times 50 = 400$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Direct and Inverse Proportion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Working with Percentages', '{"blocks":[{"type":"heading","content":"Percentage"},{"type":"paragraph","content":"Percent means ''per hundred''. $25\\% = \\frac{25}{100} = 0.25$."},{"type":"example","title":"Find $20\\%$ of KES $450$","steps":["Convert: $20\\% = 0.20$.","$0.20 \\times 450 = 90$."],"answer":"KES $90$"},{"type":"example","title":"A shirt was KES $800$, reduced by $15\\%$. Sale price?","steps":["Discount: $0.15 \\times 800 = 120$.","Sale price: $800 - 120 = 680$."],"answer":"KES $680$"},{"type":"question","questionText":"Express $0.35$ as a percentage.","questionType":"multiple_choice","options":["$35\\%$","$3.5\\%$","$350\\%$","$0.35\\%$"],"correctAnswer":"$35\\%$","explanation":"Multiply by $100$: $0.35 \\times 100 = 35\\%$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'percentage'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Working with Percentages');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Profit, Loss and Discount', '{"blocks":[{"type":"heading","content":"Percentage Applications"},{"type":"paragraph","content":"Profit = selling price - cost price. Loss when cost > selling. Profit $\\% = \\frac{\\text{profit}}{\\text{CP}} \\times 100$."},{"type":"example","title":"Bought for KES $400$, sold for KES $500$. Profit and profit $\\%$?","steps":["Profit $= 500 - 400 = 100$.","Profit $\\% = \\frac{100}{400} \\times 100 = 25\\%$."],"answer":"KES $100$ profit, $25\\%$"},{"type":"example","title":"Item marked KES $1000$ with $10\\%$ discount. Customer pays?","steps":["Discount $= 0.10 \\times 1000 = 100$.","Pay $1000 - 100 = 900$."],"answer":"KES $900$"},{"type":"callout","variant":"warning","content":"Profit $\\%$ is on cost price, not selling price."},{"type":"question","questionText":"Cost KES $200$, sold at $10\\%$ loss. Selling price?","questionType":"multiple_choice","options":["KES $180$","KES $220$","KES $190$","KES $210$"],"correctAnswer":"KES $180$","explanation":"Loss $20$; $200 - 20 = 180$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'percentage_applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Profit, Loss and Discount');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A runner covers $5$ km in $25$ minutes. Speed in km/h?', 'multiple_choice', '["$12$ km/h","$10$ km/h","$15$ km/h","$20$ km/h"]'::jsonb, '"$12$ km/h"'::jsonb, 'easy', '$25$ min $= 5/12$ h; $5 \div (5/12) = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A runner covers $5$ km in $25$ minutes. Speed in km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3$ kg of maize costs KES $180$. Price per kg?', 'multiple_choice', '["KES $60$","KES $54$","KES $90$","KES $183$"]'::jsonb, '"KES $60$"'::jsonb, 'easy', '$180 \div 3 = 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3$ kg of maize costs KES $180$. Price per kg?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pump fills $40$ litres in $8$ minutes. Rate per minute?', 'multiple_choice', '["$5$ L/min","$4$ L/min","$32$ L/min","$48$ L/min"]'::jsonb, '"$5$ L/min"'::jsonb, 'easy', '$40 \div 8 = 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pump fills $40$ litres in $8$ minutes. Rate per minute?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $72$ km in $1.5$ hours as a unit rate in km/h.', 'multiple_choice', '["$48$ km/h","$36$ km/h","$108$ km/h","$24$ km/h"]'::jsonb, '"$48$ km/h"'::jsonb, 'easy', '$72 \div 1.5 = 48$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $72$ km in $1.5$ hours as a unit rate in km/h.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify ratio $15:10$.', 'multiple_choice', '["$3:2$","$5:3$","$2:3$","$1:2$"]'::jsonb, '"$3:2$"'::jsonb, 'easy', 'Divide both by $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify ratio $15:10$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Share $20$ in ratio $1:4$. Larger share?', 'multiple_choice', '["$16$","$4$","$5$","$15$"]'::jsonb, '"$16$"'::jsonb, 'easy', 'Parts $5$; $20/5=4$; $4 \times 4 = 16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Share $20$ in ratio $1:4$. Larger share?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is $50\%$ of $80$?', 'multiple_choice', '["$40$","$30$","$50$","$160$"]'::jsonb, '"$40$"'::jsonb, 'easy', 'Half of $80$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is $50\%$ of $80$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{3}{4}$ as a percentage?', 'multiple_choice', '["$75\\%$","$34\\%$","$43\\%$","$25\\%$"]'::jsonb, '"$75\\%$"'::jsonb, 'easy', '$0.75 \times 100 = 75\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{3}{4}$ as a percentage?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Buy KES $500$, sell KES $600$. Profit?', 'multiple_choice', '["KES $100$","KES $50$","KES $1100$","KES $400$"]'::jsonb, '"KES $100$"'::jsonb, 'easy', '$600 - 500 = 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Buy KES $500$, sell KES $600$. Profit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Car at $80$ km/h for $2.5$ hours. Distance?', 'multiple_choice', '["$200$ km","$160$ km","$82.5$ km","$250$ km"]'::jsonb, '"$200$ km"'::jsonb, 'medium', '$80 \times 2.5 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Car at $80$ km/h for $2.5$ hours. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Worker earns KES $1200$ in $6$ days. Daily rate?', 'multiple_choice', '["KES $200$","KES $180$","KES $7200$","KES $240$"]'::jsonb, '"KES $200$"'::jsonb, 'medium', '$1200 \div 6 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Worker earns KES $1200$ in $6$ days. Daily rate?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Divide KES $700$ in ratio $2:5$. Smaller share?', 'multiple_choice', '["KES $200$","KES $500$","KES $350$","KES $140$"]'::jsonb, '"KES $200$"'::jsonb, 'medium', 'Parts $7$; $700/7=100$; $2 \times 100=200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Divide KES $700$ in ratio $2:5$. Smaller share?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $4$ machines make $48$ items in $3$ hours, $6$ machines in same time make?', 'multiple_choice', '["$72$ items","$48$ items","$64$ items","$96$ items"]'::jsonb, '"$72$ items"'::jsonb, 'medium', 'Direct: $48/4=12$ per machine; $6 \times 12=72$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $4$ machines make $48$ items in $3$ hours, $6$ machines in same time make?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$6$ workers finish a job in $10$ days. $5$ workers need?', 'multiple_choice', '["$12$ days","$8$ days","$15$ days","$11$ days"]'::jsonb, '"$12$ days"'::jsonb, 'medium', 'Inverse: $6 \times 10 = 60$; $60/5=12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$6$ workers finish a job in $10$ days. $5$ workers need?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Increase KES $400$ by $15\%$.', 'multiple_choice', '["KES $460$","KES $415$","KES $440$","KES $600$"]'::jsonb, '"KES $460$"'::jsonb, 'medium', '$60$ increase; $400+60=460$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Increase KES $400$ by $15\%$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$45$ is what $\%$ of $180$?', 'multiple_choice', '["$25\\%$","$20\\%$","$30\\%$","$40\\%$"]'::jsonb, '"$25\\%$"'::jsonb, 'medium', '$45/180 = 1/4 = 25\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$45$ is what $\%$ of $180$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cost KES $800$, $25\%$ profit. Selling price?', 'multiple_choice', '["KES $1000$","KES $900$","KES $200$","KES $1025$"]'::jsonb, '"KES $1000$"'::jsonb, 'medium', 'Profit $200$; $800+200=1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cost KES $800$, $25\%$ profit. Selling price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bought at $30\%$ below marked KES $1000$. Cost price?', 'multiple_choice', '["KES $700$","KES $300$","KES $1300$","KES $770$"]'::jsonb, '"KES $700$"'::jsonb, 'medium', '$30\%$ off: $1000-300=700$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bought at $30\%$ below marked KES $1000$. Cost price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclist: $15$ km in $45$ min. Average speed km/h?', 'multiple_choice', '["$20$ km/h","$15$ km/h","$30$ km/h","$10$ km/h"]'::jsonb, '"$20$ km/h"'::jsonb, 'hard', '$45$ min $= 0.75$ h; $15/0.75=20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclist: $15$ km in $45$ min. Average speed km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Map scale $1:50000$. $3$ cm on map represents?', 'multiple_choice', '["$1.5$ km","$150$ m","$15$ km","$1500$ m"]'::jsonb, '"$1.5$ km"'::jsonb, 'hard', '$3 \times 50000$ cm $= 150000$ cm $= 1.5$ km.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Map scale $1:50000$. $3$ cm on map represents?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ages of Ann and Ben are $3:5$. Sum is $32$. Ben''''s age?', 'multiple_choice', '["$20$","$12$","$16$","$18$"]'::jsonb, '"$20$"'::jsonb, 'hard', 'Parts $8$; $32/8=4$; Ben $5 \times 4=20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ages of Ann and Ben are $3:5$. Sum is $32$. Ben''''s age?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Price drops from KES $500$ to KES $425$. Percentage decrease?', 'multiple_choice', '["$15\\%$","$25\\%$","$10\\%$","$75\\%$"]'::jsonb, '"$15\\%$"'::jsonb, 'hard', 'Decrease $75$; $75/500=15\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Price drops from KES $500$ to KES $425$. Percentage decrease?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Marked KES $2000$, $20\%$ discount then $5\%$ VAT on discounted price. Final price?', 'multiple_choice', '["KES $1680$","KES $1600$","KES $1760$","KES $2100$"]'::jsonb, '"KES $1680$"'::jsonb, 'hard', 'After discount $1600$; VAT $80$; total $1680$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Marked KES $2000$, $20\%$ discount then $5\%$ VAT on discounted price. Final price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Agent earns $8\%$ commission on KES $12500$ sales. Commission?', 'multiple_choice', '["KES $1000$","KES $800$","KES $1250$","KES $960$"]'::jsonb, '"KES $1000$"'::jsonb, 'hard', '$0.08 \times 12500 = 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Agent earns $8\%$ commission on KES $12500$ sales. Commission?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pipe A fills tank in $6$ h, Pipe B in $3$ h. Together, time to fill?', 'multiple_choice', '["$2$ hours","$4.5$ hours","$3$ hours","$9$ hours"]'::jsonb, '"$2$ hours"'::jsonb, 'hard', 'Rates $1/6+1/3=1/2$ per h; time $2$ h.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pipe A fills tank in $6$ h, Pipe B in $3$ h. Together, time to fill?');