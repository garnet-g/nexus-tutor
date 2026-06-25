-- KCSE Form 1 Mathematics — Wave 1 Batch 1
-- Topics: fractions (re-instate + rebuild), natural_numbers, factors, divisibility_tests, decimals
-- Idempotent seed: subtopics, lessons, practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== FRACTIONS (re-instate + rebuild) ==========

UPDATE public.topics t SET is_active = true
FROM public.subjects s, public.curricula c
WHERE t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';

UPDATE public.subtopics st SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.lessons l SET is_active=false
FROM public.subtopics st, public.topics t, public.subjects s, public.curricula c
WHERE l.subtopic_id=st.id AND st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.practice_questions pq SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_types', 'Types of Fractions', 'Proper, improper, mixed numbers, equivalence and simplification.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_operations', 'Fraction Operations', 'Add, subtract, multiply and divide fractions.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_bodmas', 'BODMAS with Fractions', 'Order of operations involving fractions.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_word_problems', 'Fraction Word Problems', 'Apply fractions in Kenyan contexts.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Fractions', '{"blocks":[{"type":"heading","content":"Understanding Fractions"},{"type":"paragraph","content":"A fraction $\\frac{a}{b}$ shows $a$ equal parts taken from a whole divided into $b$ equal parts. The top number is the **numerator**; the bottom is the **denominator**."},{"type":"callout","variant":"key_point","content":"A **proper** fraction has numerator $<$ denominator (e.g. $\\frac{3}{5}$). An **improper** fraction has numerator $\\geq$ denominator (e.g. $\\frac{7}{4}$)."},{"type":"example","title":"Write $\\frac{11}{4}$ as a mixed number","steps":["Divide: $11 \\div 4 = 2$ remainder $3$.","Whole part $= 2$, fractional part $= \\frac{3}{4}$."],"answer":"$2\\frac{3}{4}$"},{"type":"callout","variant":"warning","content":"Do not confuse $\\frac{3}{4}$ with $3 \\div 4$ notation — they mean the same value, but in exams write fractions clearly."},{"type":"question","questionText":"Which is an improper fraction?","questionType":"multiple_choice","options":["$\\frac{2}{7}$","$\\frac{5}{5}$","$\\frac{3}{8}$","$\\frac{1}{6}$"],"correctAnswer":"$\\frac{5}{5}$","explanation":"Numerator equals denominator, so it is improper (equals $1$)."}],"shortQuiz":{"questions":[{"questionText":"In $\\frac{5}{9}$, what is the denominator?","options":["$5$","$9$","$14$","$4$"],"correctAnswer":"$9$"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_types'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Equivalent Fractions and Simplifying', '{"blocks":[{"type":"heading","content":"Equivalent Fractions and Simplifying"},{"type":"paragraph","content":"Equivalent fractions name the same amount. Multiply or divide numerator and denominator by the same non-zero number."},{"type":"math_block","latex":"\\frac{a}{b} = \\frac{a \\times k}{b \\times k} = \\frac{a \\div k}{b \\div k}","caption":"Scaling both parts equally keeps the value."},{"type":"example","title":"Simplify $\\frac{18}{24}$","steps":["Find HCF of $18$ and $24$: it is $6$.","Divide top and bottom by $6$: $\\frac{18 \\div 6}{24 \\div 6} = \\frac{3}{4}$."],"answer":"$\\frac{3}{4}$"},{"type":"example","title":"Find an equivalent fraction for $\\frac{2}{5}$ with denominator $20$","steps":["$5 \\times 4 = 20$, so multiply top by $4$.","$\\frac{2 \\times 4}{5 \\times 4} = \\frac{8}{20}$."],"answer":"$\\frac{8}{20}$"},{"type":"question","questionText":"Simplify $\\frac{15}{25}$","questionType":"multiple_choice","options":["$\\frac{3}{5}$","$\\frac{5}{3}$","$\\frac{15}{25}$","$\\frac{1}{5}$"],"correctAnswer":"$\\frac{3}{5}$","explanation":"Divide numerator and denominator by $5$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_types'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Equivalent Fractions and Simplifying'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Fractions', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Fractions"},{"type":"paragraph","content":"Same denominator: add/subtract numerators, keep denominator. Different denominators: find the LCM, convert to equivalent fractions, then add/subtract."},{"type":"example","title":"Evaluate $\\frac{2}{7} + \\frac{3}{7}$","steps":["Denominators match.","$\\frac{2+3}{7} = \\frac{5}{7}$."],"answer":"$\\frac{5}{7}$"},{"type":"example","title":"Evaluate $\\frac{3}{4} - \\frac{1}{6}$","steps":["LCM of $4$ and $6$ is $12$.","$\\frac{9}{12} - \\frac{2}{12} = \\frac{7}{12}$."],"answer":"$\\frac{7}{12}$"},{"type":"callout","variant":"warning","content":"A common mistake is adding denominators: $\\frac{1}{2} + \\frac{1}{3} \\neq \\frac{2}{5}$."},{"type":"question","questionText":"Evaluate $\\frac{1}{3} + \\frac{1}{3}$","questionType":"multiple_choice","options":["$\\frac{2}{3}$","$\\frac{2}{6}$","$\\frac{1}{3}$","$\\frac{2}{9}$"],"correctAnswer":"$\\frac{2}{3}$","explanation":"Same denominator: add numerators."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying and Dividing Fractions', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Fractions"},{"type":"callout","variant":"key_point","content":"Multiply: $\\frac{a}{b} \\times \\frac{c}{d} = \\frac{ac}{bd}$. Divide: multiply by the reciprocal: $\\frac{a}{b} \\div \\frac{c}{d} = \\frac{a}{b} \\times \\frac{d}{c}$."},{"type":"example","title":"Evaluate $\\frac{2}{3} \\times \\frac{5}{7}$","steps":["Multiply numerators: $2 \\times 5 = 10$.","Multiply denominators: $3 \\times 7 = 21$.","Simplify if possible: $\\frac{10}{21}$."],"answer":"$\\frac{10}{21}$"},{"type":"example","title":"Evaluate $\\frac{3}{4} \\div \\frac{2}{5}$","steps":["Multiply by reciprocal: $\\frac{3}{4} \\times \\frac{5}{2}$.","$= \\frac{15}{8} = 1\\frac{7}{8}$."],"answer":"$1\\frac{7}{8}$"},{"type":"question","questionText":"Evaluate $\\frac{1}{2} \\div \\frac{1}{4}$","questionType":"multiple_choice","options":["$2$","$\\frac{1}{8}$","$\\frac{1}{2}$","$4$"],"correctAnswer":"$2$","explanation":"$\\frac{1}{2} \\times \\frac{4}{1} = 2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'BODMAS with Fractions', '{"blocks":[{"type":"heading","content":"Order of Operations with Fractions"},{"type":"paragraph","content":"Follow BODMAS: Brackets, Orders, Division/Multiplication (left to right), Addition/Subtraction (left to right)."},{"type":"example","title":"Evaluate $\\frac{1}{2} + \\frac{1}{3} \\times 3$","steps":["Multiply first: $\\frac{1}{3} \\times 3 = 1$.","Add: $\\frac{1}{2} + 1 = 1\\frac{1}{2}$."],"answer":"$1\\frac{1}{2}$"},{"type":"example","title":"Evaluate $\\left(\\frac{2}{3} + \\frac{1}{6}\\right) \\div \\frac{5}{2}$","steps":["Brackets: $\\frac{4}{6} + \\frac{1}{6} = \\frac{5}{6}$.","Divide: $\\frac{5}{6} \\times \\frac{2}{5} = \\frac{1}{3}$."],"answer":"$\\frac{1}{3}$"},{"type":"callout","variant":"warning","content":"Do not work left to right when multiplication is present."},{"type":"question","questionText":"Evaluate $2 \\times \\frac{3}{4} - \\frac{1}{2}$","questionType":"multiple_choice","options":["$1$","$\\frac{1}{2}$","$\\frac{5}{4}$","$2$"],"correctAnswer":"$1$","explanation":"$\\frac{3}{2} - \\frac{1}{2} = 1$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_bodmas'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Fractions in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Fraction Word Problems"},{"type":"paragraph","content":"Fractions appear when sharing sukuma wiki at the market, mixing porridge, or finding what fraction of a class passed an exam."},{"type":"example","title":"Grace bought $\\frac{2}{5}$ kg of sugar and used $\\frac{1}{5}$ kg for tea. How much remains?","steps":["Same denominators: $\\frac{2}{5} - \\frac{1}{5} = \\frac{1}{5}$ kg."],"answer":"$\\frac{1}{5}$ kg"},{"type":"example","title":"A farmer planted maize on $\\frac{3}{8}$ of his $24$-acre shamba. How many acres?","steps":["$\\frac{3}{8} \\times 24 = 9$ acres."],"answer":"$9$ acres"},{"type":"callout","variant":"warning","content":"Of means multiply. Remaining often means subtract from the whole ($1$ or total)."},{"type":"question","questionText":"Peter ate $\\frac{1}{4}$ of a chapati. What fraction is left?","questionType":"multiple_choice","options":["$\\frac{3}{4}$","$\\frac{1}{4}$","$\\frac{1}{2}$","$\\frac{2}{4}$"],"correctAnswer":"$\\frac{3}{4}$","explanation":"$1 - \\frac{1}{4} = \\frac{3}{4}$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_word_problems'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Fractions in Kenyan Contexts'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which fraction is proper?', 'multiple_choice', '["$\\frac{7}{9}$","$\\frac{9}{7}$","$\\frac{9}{9}$","$2\\frac{1}{3}$"]'::jsonb, '"$\\frac{7}{9}$"'::jsonb, 'easy', 'Numerator is less than denominator.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which fraction is proper?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{8}{12}$.', 'multiple_choice', '["$\\frac{2}{3}$","$\\frac{4}{6}$","$\\frac{3}{2}$","$\\frac{1}{4}$"]'::jsonb, '"$\\frac{2}{3}$"'::jsonb, 'easy', 'Divide top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{8}{12}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{9}{4}$ to a mixed number.', 'multiple_choice', '["$2\\frac{1}{4}$","$1\\frac{5}{4}$","$4\\frac{1}{9}$","$\\frac{13}{4}$"]'::jsonb, '"$2\\frac{1}{4}$"'::jsonb, 'easy', '$9 \div 4 = 2$ remainder $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{9}{4}$ to a mixed number.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{5} + \frac{2}{5}$.', 'multiple_choice', '["$\\frac{3}{5}$","$\\frac{3}{10}$","$\\frac{2}{5}$","$\\frac{1}{5}$"]'::jsonb, '"$\\frac{3}{5}$"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{5} + \frac{2}{5}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3}{4} - \frac{1}{4}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{2}{4}$","$\\frac{4}{4}$","$\\frac{2}{8}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'easy', '$\frac{3-1}{4} = \frac{2}{4} = \frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3}{4} - \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} \times \frac{2}{3}$.', 'multiple_choice', '["$\\frac{1}{3}$","$\\frac{2}{5}$","$\\frac{3}{4}$","$\\frac{2}{6}$"]'::jsonb, '"$\\frac{1}{3}$"'::jsonb, 'easy', '$\frac{2}{6} = \frac{1}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} \times \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.', 'multiple_choice', '["$1\\frac{1}{2}$","$2$","$1$","$\\frac{3}{2}$"]'::jsonb, '"$1\\frac{1}{2}$"'::jsonb, 'easy', 'Multiply first: $1 + 1 = 1\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is equivalent to $\frac{3}{5}$?', 'multiple_choice', '["$\\frac{12}{20}$","$\\frac{5}{3}$","$\\frac{6}{15}$","$\\frac{9}{25}$"]'::jsonb, '"$\\frac{12}{20}$"'::jsonb, 'medium', 'Multiply top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is equivalent to $\frac{3}{5}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{2}{3} + \frac{1}{4}$.', 'multiple_choice', '["$\\frac{11}{12}$","$\\frac{3}{7}$","$\\frac{3}{12}$","$\\frac{8}{12}$"]'::jsonb, '"$\\frac{11}{12}$"'::jsonb, 'medium', 'LCM $12$: $\frac{8}{12}+\frac{3}{12}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{2}{3} + \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{5}{6} - \frac{1}{3}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{4}{3}$","$\\frac{4}{6}$","$\\frac{1}{3}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', '$\frac{5}{6}-\frac{2}{6}=\frac{3}{6}=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{5}{6} - \frac{1}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{4}{5} \div \frac{2}{3}$.', 'multiple_choice', '["$1\\frac{1}{5}$","$\\frac{6}{20}$","$\\frac{8}{15}$","$\\frac{2}{5}$"]'::jsonb, '"$1\\frac{1}{5}$"'::jsonb, 'medium', '$\frac{4}{5}\times\frac{3}{2}=\frac{12}{10}=1\frac{1}{5}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{4}{5} \div \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\left(\frac{1}{2}+\frac{1}{3}\right) \times 6$.', 'multiple_choice', '["$5$","$3$","$4$","$6$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Brackets: $\frac{5}{6}\times 6 = 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\left(\frac{1}{2}+\frac{1}{3}\right) \times 6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $3 - \frac{2}{5} \times \frac{5}{2}$.', 'multiple_choice', '["$2$","$1$","$\\frac{11}{5}$","$3$"]'::jsonb, '"$2$"'::jsonb, 'medium', 'Multiply: $3-1=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $3 - \frac{2}{5} \times \frac{5}{2}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A jug is $\frac{3}{4}$ full. $\frac{1}{4}$ is poured out. What fraction remains?', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{1}{4}$","$\\frac{2}{4}$","$\\frac{3}{4}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', '$\frac{3}{4}-\frac{1}{4}=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A jug is $\frac{3}{4}$ full. $\frac{1}{4}$ is poured out. What fraction remains?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At a kiosk, $\frac{2}{5}$ of KES $500$ was spent on bread. How much was spent?', 'multiple_choice', '["KES $200$","KES $250$","KES $300$","KES $125$"]'::jsonb, '"KES $200$"'::jsonb, 'hard', '$\frac{2}{5}\times 500 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At a kiosk, $\frac{2}{5}$ of KES $500$ was spent on bread. How much was spent?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{2}{3} \div \left(\frac{1}{2} + \frac{1}{6}\right)$.', 'multiple_choice', '["$1$","$\\frac{4}{3}$","$\\frac{2}{3}$","$\\frac{1}{2}$"]'::jsonb, '"$1$"'::jsonb, 'hard', 'Bracket $=\frac{2}{3}$; $\frac{2}{3}\div\frac{2}{3}=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{2}{3} \div \left(\frac{1}{2} + \frac{1}{6}\right)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1\frac{1}{3} - \frac{2}{5}$.', 'multiple_choice', '["$\\frac{14}{15}$","$\\frac{8}{15}$","$\\frac{11}{15}$","$\\frac{3}{8}$"]'::jsonb, '"$\\frac{14}{15}$"'::jsonb, 'hard', '$\frac{4}{3}-\frac{2}{5}=\frac{20-6}{15}=\frac{14}{15}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1\frac{1}{3} - \frac{2}{5}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3}{4} \times \frac{8}{9} \div \frac{2}{3}$.', 'multiple_choice', '["$1$","$\\frac{2}{3}$","$\\frac{4}{3}$","$\\frac{1}{2}$"]'::jsonb, '"$1$"'::jsonb, 'hard', '$\frac{2}{3}\div\frac{2}{3}=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3}{4} \times \frac{8}{9} \div \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'In a class of $40$, $\frac{3}{8}$ are girls. How many boys are there?', 'multiple_choice', '["$25$","$15$","$24$","$16$"]'::jsonb, '"$25$"'::jsonb, 'hard', 'Girls $=15$; boys $=40-15=25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='In a class of $40$, $\frac{3}{8}$ are girls. How many boys are there?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $3\frac{2}{5}$ as an improper fraction.', 'multiple_choice', '["$\\frac{17}{5}$","$\\frac{15}{5}$","$\\frac{13}{5}$","$\\frac{32}{5}$"]'::jsonb, '"$\\frac{17}{5}$"'::jsonb, 'hard', '$3\times 5 + 2 = 17$ over $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $3\frac{2}{5}$ as an improper fraction.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.', 'multiple_choice', '["$1\\frac{1}{2}$","$\\frac{3}{4}$","$2$","$1$"]'::jsonb, '"$1\\frac{1}{2}$"'::jsonb, 'hard', 'Bracket $=1$; $\frac{1}{2}\div\frac{1}{3}=\frac{3}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.');

-- ========== NATURAL NUMBERS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Place Value and Reading Numbers', '{"blocks":[{"type":"heading","content":"Place Value"},{"type":"paragraph","content":"Each digit in a number has a place value: ones, tens, hundreds, thousands, and so on. In $4\\,582$, the $4$ is in the thousands place ($4\\,000$)."},{"type":"callout","variant":"key_point","content":"Moving one place left multiplies value by $10$. Moving right divides by $10$."},{"type":"example","title":"Write the value of $7$ in $37\\,205$","steps":["$7$ is in the thousands place.","Value $= 7\\,000$."],"answer":"$7\\,000$"},{"type":"question","questionText":"What is the place value of $5$ in $2\\,531$?","questionType":"multiple_choice","options":["$500$","$50$","$5$","$5\\,000$"],"correctAnswer":"$500$","explanation":"$5$ is in the hundreds place."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'place_values'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Place Value and Reading Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rounding Off Numbers', '{"blocks":[{"type":"heading","content":"Rounding Off"},{"type":"paragraph","content":"To round to the nearest ten, hundred, or thousand, look at the digit to the right. If it is $5$ or more, round up; otherwise round down."},{"type":"example","title":"Round $4\\,678$ to the nearest hundred","steps":["Hundreds digit is $6$; tens digit is $7$ ($\\geq 5$).","Round up: $4\\,700$."],"answer":"$4\\,700$"},{"type":"callout","variant":"warning","content":"Rounding to nearest ten uses the ones digit; to nearest hundred uses the tens digit."},{"type":"question","questionText":"Round $12\\,350$ to the nearest thousand.","questionType":"multiple_choice","options":["$12\\,000$","$13\\,000$","$12\\,400$","$12\\,300$"],"correctAnswer":"$12\\,000$","explanation":"Hundreds digit $3 < 5$, round down."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'place_values'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rounding Off Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations with Natural Numbers', '{"blocks":[{"type":"heading","content":"Operations with Natural Numbers"},{"type":"paragraph","content":"Natural numbers are counting numbers $1, 2, 3, \\ldots$ We add, subtract, multiply and divide them following place-value rules and BODMAS."},{"type":"example","title":"Evaluate $456 + 278$","steps":["Ones: $6+8=14$, carry $1$.","Tens: $5+7+1=13$, carry $1$.","Hundreds: $4+2+1=7$."],"answer":"$734$"},{"type":"example","title":"Evaluate $8\\,400 \\div 12$","steps":["$84 \\div 12 = 7$.","Bring down $0$: $70 \\times 12 = 840$."],"answer":"$700$"},{"type":"question","questionText":"Evaluate $25 \\times 16$.","questionType":"multiple_choice","options":["$400$","$350$","$410$","$390$"],"correctAnswer":"$400$","explanation":"$25 \\times 16 = 400$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'number_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations with Natural Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'The Number Line', '{"blocks":[{"type":"heading","content":"Natural Numbers on the Number Line"},{"type":"paragraph","content":"A number line shows order. Numbers increase to the right. Natural numbers start at $1$."},{"type":"example","title":"Which is greater: $847$ or $874$?","steps":["Compare hundreds: both $8$.","Compare tens: $4 < 7$, so $847 < 874$."],"answer":"$874$ is greater"},{"type":"callout","variant":"warning","content":"When digits match from the left, the number with the larger next digit is greater."},{"type":"question","questionText":"On a number line, which is furthest right: $502$, $520$, or $250$?","questionType":"multiple_choice","options":["$520$","$502$","$250$","All equal"],"correctAnswer":"$520$","explanation":"$520$ is the greatest."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'number_line'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'The Number Line'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is the value of $3$ in $13\,472$?', 'multiple_choice', '["$3\\,000$","$300$","$30$","$3$"]'::jsonb, '"$3\\,000$"'::jsonb, 'easy', '$3$ is in the thousands place.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is the value of $3$ in $13\,472$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $567$ to the nearest ten.', 'multiple_choice', '["$570$","$560$","$600$","$500$"]'::jsonb, '"$570$"'::jsonb, 'easy', 'Ones digit $7 \geq 5$, round up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $567$ to the nearest ten.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $125 + 75$.', 'multiple_choice', '["$200$","$190$","$210$","$195$"]'::jsonb, '"$200$"'::jsonb, 'easy', 'Direct addition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $125 + 75$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $144 \div 12$.', 'multiple_choice', '["$12$","$11$","$13$","$14$"]'::jsonb, '"$12$"'::jsonb, 'easy', '$12 \times 12 = 144$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $144 \div 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is smallest: $305$, $350$, $503$?', 'multiple_choice', '["$305$","$350$","$503$","$530$"]'::jsonb, '"$305$"'::jsonb, 'easy', '$305$ has the smallest hundreds digit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is smallest: $305$, $350$, $503$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $15 \times 8$.', 'multiple_choice', '["$120$","$115$","$125$","$80$"]'::jsonb, '"$120$"'::jsonb, 'easy', '$15 \times 8 = 120$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \times 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $9\,006$ in words.', 'multiple_choice', '["Nine thousand and six","Nine hundred and six","Ninety thousand six","Nine thousand sixty"]'::jsonb, '"Nine thousand and six"'::jsonb, 'easy', 'No hundreds or tens digits.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $9\,006$ in words.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $4\,950$ to the nearest hundred.', 'multiple_choice', '["$5\\,000$","$4\\,900$","$4\\,000$","$5\\,100$"]'::jsonb, '"$5\\,000$"'::jsonb, 'medium', 'Tens digit $5$, round hundreds up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $4\,950$ to the nearest hundred.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1\,024 - 378$.', 'multiple_choice', '["$646$","$656$","$636$","$746$"]'::jsonb, '"$646$"'::jsonb, 'medium', 'Column subtraction with borrowing.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1\,024 - 378$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $35 \times 24$.', 'multiple_choice', '["$840$","$800$","$850$","$740$"]'::jsonb, '"$840$"'::jsonb, 'medium', '$35 \times 24 = 840$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $35 \times 24$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Arrange $1\,204$, $1\,240$, $1\,042$ from smallest to largest.', 'multiple_choice', '["$1\\,042, 1\\,204, 1\\,240$","$1\\,240, 1\\,204, 1\\,042$","$1\\,204, 1\\,042, 1\\,240$","$1\\,042, 1\\,240, 1\\,204$"]'::jsonb, '"$1\\,042, 1\\,204, 1\\,240$"'::jsonb, 'medium', 'Compare place values left to right.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Arrange $1\,204$, $1\,240$, $1\,042$ from smallest to largest.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A shop sells $18$ eggs per tray. How many eggs in $45$ trays?', 'multiple_choice', '["$810$","$800$","$720$","$900$"]'::jsonb, '"$810$"'::jsonb, 'medium', '$18 \times 45 = 810$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A shop sells $18$ eggs per tray. How many eggs in $45$ trays?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $99\,499$ to the nearest thousand.', 'multiple_choice', '["$99\\,000$","$100\\,000$","$99\\,500$","$99\\,400$"]'::jsonb, '"$99\\,000$"'::jsonb, 'medium', 'Hundreds digit $4 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $99\,499$ to the nearest thousand.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $2\,500 \div 25$.', 'multiple_choice', '["$100$","$125$","$90$","$250$"]'::jsonb, '"$100$"'::jsonb, 'medium', '$25 \times 100 = 2\,500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $2\,500 \div 25$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A school has $1\,248$ pupils. Round to the nearest hundred for a report.', 'multiple_choice', '["$1\\,200$","$1\\,300$","$1\\,250$","$1\\,000$"]'::jsonb, '"$1\\,200$"'::jsonb, 'hard', 'Tens digit $4 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A school has $1\,248$ pupils. Round to the nearest hundred for a report.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A bus carries $62$ passengers per trip. How many passengers in $38$ full trips?', 'multiple_choice', '["$2\\,356$","$2\\,336$","$2\\,346$","$2\\,376$"]'::jsonb, '"$2\\,356$"'::jsonb, 'hard', '$62 \times 38 = 2\,356$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bus carries $62$ passengers per trip. How many passengers in $38$ full trips?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate which number is halfway between $400$ and $600$ on the number line.', 'multiple_choice', '["$500$","$550$","$450$","$520$"]'::jsonb, '"$500$"'::jsonb, 'hard', 'Midpoint of $400$ and $600$ is $500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate which number is halfway between $400$ and $600$ on the number line.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $10\,000 - 3\,456$.', 'multiple_choice', '["$6\\,544$","$6\\,554$","$6\\,444$","$7\\,544$"]'::jsonb, '"$6\\,544$"'::jsonb, 'hard', 'Borrow across zeros carefully.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10\,000 - 3\,456$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'The digit $8$ appears twice in $18\,829$. What is the total value of both $8$s?', 'multiple_choice', '["$8\\,800$","$808$","$880$","$8\\,080$"]'::jsonb, '"$8\\,800$"'::jsonb, 'hard', '$8\,000 + 800 = 8\,800$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='The digit $8$ appears twice in $18\,829$. What is the total value of both $8$s?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A farmer packs $125$ oranges per crate. How many oranges in $64$ crates?', 'multiple_choice', '["$8\\,000$","$7\\,500$","$8\\,125$","$7\\,875$"]'::jsonb, '"$8\\,000$"'::jsonb, 'hard', '$125 \times 64 = 8\,000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A farmer packs $125$ oranges per crate. How many oranges in $64$ crates?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which inequality is correct?', 'multiple_choice', '["$2\\,305 < 2\\,350$","$2\\,305 > 2\\,350$","$2\\,305 = 2\\,350$","$2\\,350 < 2\\,305$"]'::jsonb, '"$2\\,305 < 2\\,350$"'::jsonb, 'hard', 'Compare tens: $0 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which inequality is correct?');

-- ========== FACTORS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prime Numbers and Factorisation', '{"blocks":[{"type":"heading","content":"Prime Factorisation"},{"type":"paragraph","content":"A **prime** number has exactly two factors: $1$ and itself. To factorise a composite number, split it into prime factors using a factor tree or repeated division."},{"type":"example","title":"Write $72$ as a product of primes","steps":["$72 = 2 \\times 36 = 2 \\times 2 \\times 18$.","$= 2 \\times 2 \\times 2 \\times 9 = 2^3 \\times 3^2$."],"answer":"$2^3 \\times 3^2$"},{"type":"callout","variant":"key_point","content":"Every whole number greater than $1$ is either prime or a unique product of primes."},{"type":"question","questionText":"Which is prime?","questionType":"multiple_choice","options":["$17$","$21$","$27$","$33$"],"correctAnswer":"$17$","explanation":"$17$ has only factors $1$ and $17$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'prime_factors'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prime Numbers and Factorisation'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Greatest Common Divisor (GCD/HCF)', '{"blocks":[{"type":"heading","content":"GCD / HCF"},{"type":"paragraph","content":"The GCD (or HCF) of two numbers is the largest number that divides both exactly. Use prime factorisation or listing factors."},{"type":"example","title":"Find the HCF of $48$ and $72$","steps":["$48 = 2^4 \\times 3$; $72 = 2^3 \\times 3^2$.","Common primes with lowest powers: $2^3 \\times 3 = 24$."],"answer":"$24$"},{"type":"callout","variant":"warning","content":"HCF uses the **lowest** power of each common prime; LCM uses the **highest**."},{"type":"question","questionText":"Find the HCF of $18$ and $24$.","questionType":"multiple_choice","options":["$6$","$12$","$3$","$72$"],"correctAnswer":"$6$","explanation":"Common factors: $1,2,3,6$; greatest is $6$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'gcd_hcf'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Greatest Common Divisor (GCD/HCF)'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Lowest Common Multiple (LCM)', '{"blocks":[{"type":"heading","content":"LCM"},{"type":"paragraph","content":"The LCM is the smallest positive number that is a multiple of both numbers. Useful for adding fractions and scheduling events."},{"type":"example","title":"Find the LCM of $12$ and $18$","steps":["$12 = 2^2 \\times 3$; $18 = 2 \\times 3^2$.","LCM $= 2^2 \\times 3^2 = 36$."],"answer":"$36$"},{"type":"example","title":"Buses leave a stage every $12$ min and $18$ min. When do they next leave together?","steps":["Need LCM of $12$ and $18$.","LCM $= 36$ minutes."],"answer":"After $36$ minutes"},{"type":"question","questionText":"Find the LCM of $8$ and $12$.","questionType":"multiple_choice","options":["$24$","$96$","$4$","$48$"],"correctAnswer":"$24$","explanation":"$24$ is the smallest common multiple."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'lcm'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Lowest Common Multiple (LCM)'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a prime number?', 'multiple_choice', '["$29$","$39$","$49$","$51$"]'::jsonb, '"$29$"'::jsonb, 'easy', '$29$ has only two factors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a prime number?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many factors does $13$ have?', 'multiple_choice', '["$2$","$3$","$1$","$13$"]'::jsonb, '"$2$"'::jsonb, 'easy', 'Prime numbers have exactly two factors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many factors does $13$ have?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $30$ as a product of primes.', 'multiple_choice', '["$2 \\times 3 \\times 5$","$5 \\times 6$","$2 \\times 15$","$3 \\times 10$"]'::jsonb, '"$2 \\times 3 \\times 5$"'::jsonb, 'easy', 'All factors are prime.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $30$ as a product of primes.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $12$ and $16$.', 'multiple_choice', '["$4$","$8$","$2$","$48$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Common factors: $1,2,4$; HCF $=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $12$ and $16$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $9$ and $15$.', 'multiple_choice', '["$3$","$5$","$45$","$6$"]'::jsonb, '"$3$"'::jsonb, 'easy', 'Both divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $9$ and $15$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $4$ and $6$.', 'multiple_choice', '["$12$","$24$","$2$","$10$"]'::jsonb, '"$12$"'::jsonb, 'easy', 'Multiples: $4,8,12$ and $6,12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $4$ and $6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $5$ and $7$.', 'multiple_choice', '["$35$","$12$","$1$","$70$"]'::jsonb, '"$35$"'::jsonb, 'easy', 'Coprime: product gives LCM.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $5$ and $7$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $60$ in prime factor form.', 'multiple_choice', '["$2^2 \\times 3 \\times 5$","$2 \\times 30$","$4 \\times 15$","$6 \\times 10$"]'::jsonb, '"$2^2 \\times 3 \\times 5$"'::jsonb, 'medium', 'Factor tree gives $2,2,3,5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $60$ in prime factor form.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $36$ and $54$.', 'multiple_choice', '["$18$","$9$","$6$","$108$"]'::jsonb, '"$18$"'::jsonb, 'medium', '$36=2^2\times3^2$; $54=2\times3^3$; HCF $=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $36$ and $54$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $15$ and $20$.', 'multiple_choice', '["$60$","$300$","$5$","$35$"]'::jsonb, '"$60$"'::jsonb, 'medium', '$15=3\times5$; $20=2^2\times5$; LCM $=60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $15$ and $20$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tiles of size $12$ cm and $18$ cm — largest square tile dividing both?', 'multiple_choice', '["$6$ cm","$3$ cm","$12$ cm","$36$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'medium', 'HCF of $12$ and $18$ is $6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tiles of size $12$ cm and $18$ cm — largest square tile dividing both?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two bells ring every $8$ s and $12$ s. Together again after?', 'multiple_choice', '["$24$ s","$20$ s","$4$ s","$96$ s"]'::jsonb, '"$24$ s"'::jsonb, 'medium', 'LCM of $8$ and $12$ is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two bells ring every $8$ s and $12$ s. Together again after?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is the prime factorisation of $84$?', 'multiple_choice', '["$2^2 \\times 3 \\times 7$","$2 \\times 42$","$4 \\times 21$","$6 \\times 14$"]'::jsonb, '"$2^2 \\times 3 \\times 7$"'::jsonb, 'medium', 'Divide by primes: $84=2\times2\times3\times7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the prime factorisation of $84$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $45$ and $75$.', 'multiple_choice', '["$15$","$5$","$3$","$225$"]'::jsonb, '"$15$"'::jsonb, 'medium', '$45=3^2\times5$; $75=3\times5^2$; HCF $=15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $45$ and $75$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A number has prime factors $2^3 \times 5$. What is the number?', 'multiple_choice', '["$40$","$80$","$10$","$25$"]'::jsonb, '"$40$"'::jsonb, 'hard', '$8 \times 5 = 40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A number has prime factors $2^3 \times 5$. What is the number?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $84$ and $126$.', 'multiple_choice', '["$42$","$21$","$14$","$7$"]'::jsonb, '"$42$"'::jsonb, 'hard', 'Common: $2\times3\times7=42$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $84$ and $126$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $18$ and $24$.', 'multiple_choice', '["$72$","$432$","$6$","$48$"]'::jsonb, '"$72$"'::jsonb, 'hard', '$18=2\times3^2$; $24=2^3\times3$; LCM $=72$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $18$ and $24$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Matatu A every $15$ min, B every $20$ min. Next together?', 'multiple_choice', '["$60$ min","$35$ min","$5$ min","$300$ min"]'::jsonb, '"$60$ min"'::jsonb, 'hard', 'LCM of $15$ and $20$ is $60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Matatu A every $15$ min, B every $20$ min. Next together?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cut ropes of $48$ m and $72$ m into equal pieces — longest piece?', 'multiple_choice', '["$24$ m","$12$ m","$6$ m","$48$ m"]'::jsonb, '"$24$ m"'::jsonb, 'hard', 'HCF of $48$ and $72$ is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cut ropes of $48$ m and $72$ m into equal pieces — longest piece?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many prime factors (with repetition) in $100$?', 'multiple_choice', '["$4$","$2$","$3$","$5$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$100=2\times2\times5\times5$: four primes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many prime factors (with repetition) in $100$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'LCM of $14$, $21$ and $6$?', 'multiple_choice', '["$42$","$84$","$126$","$7$"]'::jsonb, '"$42$"'::jsonb, 'hard', '$42$ is divisible by $14$, $21$ and $6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='LCM of $14$, $21$ and $6$?');

-- ========== DIVISIBILITY TESTS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Divisibility by 2, 3, 4 and 5', '{"blocks":[{"type":"heading","content":"Tests for 2, 3, 4 and 5"},{"type":"callout","variant":"key_point","content":"Divisible by $2$ or $5$: check the **last digit**. Divisible by $3$: sum of digits divisible by $3$. Divisible by $4$: last **two** digits form a number divisible by $4$."},{"type":"example","title":"Is $3\\,456$ divisible by $3$?","steps":["Sum of digits: $3+4+5+6=18$.","$18$ is divisible by $3$, so $3\\,456$ is divisible by $3$."],"answer":"Yes"},{"type":"example","title":"Is $7\\,128$ divisible by $4$?","steps":["Last two digits: $28$.","$28 \\div 4 = 7$, so divisible by $4$."],"answer":"Yes"},{"type":"question","questionText":"Which number is divisible by $5$?","questionType":"multiple_choice","options":["$1\\,235$","$1\\,234$","$1\\,236$","$1\\,233$"],"correctAnswer":"$1\\,235$","explanation":"Last digit must be $0$ or $5$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'tests_2_3_4_5'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Divisibility by 2, 3, 4 and 5'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Divisibility by 6, 8, 9, 10 and 11', '{"blocks":[{"type":"heading","content":"Tests for 6, 8, 9, 10 and 11"},{"type":"paragraph","content":"Divisible by $6$: divisible by both $2$ and $3$. Divisible by $8$: last three digits divisible by $8$. Divisible by $9$: digit sum divisible by $9$. Divisible by $10$: last digit $0$. Divisible by $11$: alternating sum of digits divisible by $11$."},{"type":"example","title":"Is $5\\,544$ divisible by $8$?","steps":["Last three digits: $544$.","$544 \\div 8 = 68$, so yes."],"answer":"Yes"},{"type":"callout","variant":"warning","content":"For $11$, subtract and add digits alternately from the right."},{"type":"question","questionText":"Which is divisible by $9$?","questionType":"multiple_choice","options":["$5\\,463$","$5\\,464$","$5\\,465$","$5\\,462$"],"correctAnswer":"$5\\,463$","explanation":"Digit sum $5+4+6+3=18$, divisible by $9$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'tests_6_8_9_10_11'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Divisibility by 6, 8, 9, 10 and 11'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Divisibility in Problems', '{"blocks":[{"type":"heading","content":"Applications of Divisibility"},{"type":"paragraph","content":"Divisibility tests speed up factorisation, simplifying fractions, and checking whether a number is prime or composite."},{"type":"example","title":"Is $2\\,731$ divisible by $11$?","steps":["Alternating sum: $1-3+7-2=3$.","$3$ is not divisible by $11$, so $2\\,731$ is not."],"answer":"No"},{"type":"example","title":"Find the missing digit so $4\\,5\\_2$ is divisible by $3$","steps":["Sum so far: $4+5+2=11$.","Try digit $1$: sum $12$, divisible by $3$."],"answer":"$1$"},{"type":"question","questionText":"A number ending in $0$ is always divisible by:","questionType":"multiple_choice","options":["$10$","$3$","$4$","$8$"],"correctAnswer":"$10$","explanation":"Last digit $0$ means divisible by $10$ (and $2$ and $5$)."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'applications'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Divisibility in Problems'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $2$?', 'multiple_choice', '["$346$","$351$","$355$","$357$"]'::jsonb, '"$346$"'::jsonb, 'easy', 'Last digit must be even.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $5$?', 'multiple_choice', '["$2\\,450$","$2\\,451$","$2\\,452$","$2\\,453$"]'::jsonb, '"$2\\,450$"'::jsonb, 'easy', 'Last digit $0$ or $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $123$ divisible by $3$?', 'multiple_choice', '["Yes","No","Cannot tell","Only by $1$"]'::jsonb, '"Yes"'::jsonb, 'easy', 'Digit sum $1+2+3=6$, divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $123$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $4$?', 'multiple_choice', '["$316$","$318$","$322$","$326$"]'::jsonb, '"$316$"'::jsonb, 'easy', 'Last two digits $16$; $16\div4=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $10$?', 'multiple_choice', '["$1\\,230$","$1\\,235$","$1\\,236$","$1\\,239$"]'::jsonb, '"$1\\,230$"'::jsonb, 'easy', 'Must end in $0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $10$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $9$?', 'multiple_choice', '["$729$","$728$","$730$","$731$"]'::jsonb, '"$729$"'::jsonb, 'easy', 'Digit sum $7+2+9=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $6$?', 'multiple_choice', '["$234$","$235$","$237$","$239$"]'::jsonb, '"$234$"'::jsonb, 'easy', 'Even and digit sum $9$ (div by $3$).'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Smallest digit to make $45\_8$ divisible by $3$?', 'multiple_choice', '["$1$","$2$","$0$","$4$"]'::jsonb, '"$1$"'::jsonb, 'medium', 'Sum $4+5+8=17$; add $1$ gives $18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Smallest digit to make $45\_8$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $8$?', 'multiple_choice', '["$5\\,024$","$5\\,026$","$5\\,028$","$5\\,030$"]'::jsonb, '"$5\\,024$"'::jsonb, 'medium', 'Last three digits $024=24$; $24\div8=3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $11$?', 'multiple_choice', '["$1\\,221$","$1\\,222$","$1\\,223$","$1\\,224$"]'::jsonb, '"$1\\,221$"'::jsonb, 'medium', 'Alt sum $1-2+2-1=0$, divisible by $11$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $11$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which number is divisible by both $2$ and $5$?', 'multiple_choice', '["$340$","$345$","$342$","$343$"]'::jsonb, '"$340$"'::jsonb, 'medium', 'Ends in $0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which number is divisible by both $2$ and $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'To check if $7\,848$ is divisible by $4$, you examine:', 'multiple_choice', '["Last two digits","Last digit only","First digit","Digit sum"]'::jsonb, '"Last two digits"'::jsonb, 'medium', 'Divisibility by $4$ uses last two digits.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='To check if $7\,848$ is divisible by $4$, you examine:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $5\,832$ divisible by $9$?', 'multiple_choice', '["Yes","No","Only by $3$","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Sum $5+8+3+2=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $5\,832$ divisible by $9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A number divisible by $6$ must be:', 'multiple_choice', '["Even and sum of digits div by $3$","Odd only","Ending in $5$","Sum of digits div by $2$"]'::jsonb, '"Even and sum of digits div by $3$"'::jsonb, 'medium', 'Rule for $6$: both $2$ and $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A number divisible by $6$ must be:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Largest 3-digit number divisible by $5$?', 'multiple_choice', '["$995$","$990$","$999$","$985$"]'::jsonb, '"$995$"'::jsonb, 'hard', 'Must end in $0$ or $5$; $995$ is largest.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Largest 3-digit number divisible by $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $9\,072$ divisible by $8$?', 'multiple_choice', '["Yes","No","Only by $4$","Only by $2$"]'::jsonb, '"Yes"'::jsonb, 'hard', 'Last three digits $072=72$; $72\div8=9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $9\,072$ divisible by $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which digit makes $24\_6$ divisible by $3$?', 'multiple_choice', '["$0$","$1$","$2$","$4$"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Sum $2+4+0+6=12$, divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which digit makes $24\_6$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is NOT divisible by $11$?', 'multiple_choice', '["$1\\,234$","$1\\,221$","$1\\,331$","$1\\,111$"]'::jsonb, '"$1\\,234$"'::jsonb, 'hard', 'Alt sum $4-3+2-1=2$, not divisible by $11$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is NOT divisible by $11$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $84/126$ in lowest terms?', 'multiple_choice', '["No — HCF is $42$","Yes","No — HCF is $6$","No — HCF is $21$"]'::jsonb, '"No — HCF is $42$"'::jsonb, 'hard', 'HCF $42$; reduces to $2/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $84/126$ in lowest terms?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many integers from $100$ to $108$ inclusive are divisible by $3$?', 'multiple_choice', '["$3$","$4$","$2$","$5$"]'::jsonb, '"$3$"'::jsonb, 'hard', '$102$, $105$, $108$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers from $100$ to $108$ inclusive are divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A 4-digit number ends in $20$ and digit sum is $18$. It is divisible by:', 'multiple_choice', '["$9$ and $10$","$8$ only","$11$ only","$4$ only"]'::jsonb, '"$9$ and $10$"'::jsonb, 'hard', 'Ends $20$ → div $10$; sum $18$ → div $9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A 4-digit number ends in $20$ and digit sum is $18$. It is divisible by:');

-- ========== DECIMALS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Decimal Place Value', '{"blocks":[{"type":"heading","content":"Decimal Place Value"},{"type":"paragraph","content":"Decimals extend place value to tenths, hundredths, thousandths. The decimal point separates whole and fractional parts."},{"type":"callout","variant":"key_point","content":"In $3.45$, the $4$ is in the tenths place ($0.4$) and $5$ in hundredths ($0.05$)."},{"type":"example","title":"Write the value of $7$ in $12.73$","steps":["$7$ is in the tenths place.","Value $= 0.7$."],"answer":"$0.7$"},{"type":"question","questionText":"Which is greater: $0.8$ or $0.75$?","questionType":"multiple_choice","options":["$0.8$","$0.75$","Equal","Cannot tell"],"correctAnswer":"$0.8$","explanation":"$0.8 = 0.80 > 0.75$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'place_value_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Decimal Place Value'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations with Decimals', '{"blocks":[{"type":"heading","content":"Operations with Decimals"},{"type":"paragraph","content":"Line up decimal points for addition and subtraction. For multiplication, count total decimal places. For division, shift decimals to make the divisor a whole number."},{"type":"example","title":"Evaluate $2.5 + 1.35$","steps":["Align decimals: $2.50 + 1.35$.","Sum $= 3.85$."],"answer":"$3.85$"},{"type":"example","title":"Evaluate $0.4 \\times 0.3$","steps":["$4 \\times 3 = 12$.","Two decimal places: $0.12$."],"answer":"$0.12$"},{"type":"callout","variant":"warning","content":"Do not line up digits without aligning the decimal point."},{"type":"question","questionText":"Evaluate $5.6 - 2.4$","questionType":"multiple_choice","options":["$3.2$","$3.0$","$2.2$","$4.0$"],"correctAnswer":"$3.2$","explanation":"Subtract tenths: $5.6 - 2.4 = 3.2$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'operations_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations with Decimals'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Recurring Decimals and Conversions', '{"blocks":[{"type":"heading","content":"Recurring Decimals"},{"type":"paragraph","content":"Some fractions produce decimals that repeat forever, e.g. $\\frac{1}{3} = 0.333\\ldots$ written $0.\\dot{3}$. Convert fractions to decimals by division."},{"type":"example","title":"Convert $\\frac{3}{8}$ to a decimal","steps":["$3 \\div 8 = 0.375$.","Terminating decimal."],"answer":"$0.375$"},{"type":"example","title":"Convert $0.25$ to a fraction","steps":["$0.25 = \\frac{25}{100}$.","Simplify: $\\frac{1}{4}$."],"answer":"$\\frac{1}{4}$"},{"type":"question","questionText":"Which fraction equals $0.5$?","questionType":"multiple_choice","options":["$\\frac{1}{2}$","$\\frac{1}{5}$","$\\frac{2}{5}$","$\\frac{1}{4}$"],"correctAnswer":"$\\frac{1}{2}$","explanation":"$0.5 = \\frac{5}{10} = \\frac{1}{2}$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'recurring_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Recurring Decimals and Conversions'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is the place value of $6$ in $4.62$?', 'multiple_choice', '["Tenths","Hundredths","Ones","Thousandths"]'::jsonb, '"Hundredths"'::jsonb, 'easy', '$6$ is in the hundredths place.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is the place value of $6$ in $4.62$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $0.7$ as a fraction.', 'multiple_choice', '["$\\frac{7}{10}$","$\\frac{7}{100}$","$\\frac{1}{7}$","$\\frac{70}{10}$"]'::jsonb, '"$\\frac{7}{10}$"'::jsonb, 'easy', 'One decimal place → tenths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $0.7$ as a fraction.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1.2 + 0.5$.', 'multiple_choice', '["$1.7$","$1.5$","$0.7$","$2.0$"]'::jsonb, '"$1.7$"'::jsonb, 'easy', 'Add tenths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1.2 + 0.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $3.0 - 1.8$.', 'multiple_choice', '["$1.2$","$1.8$","$2.2$","$4.8$"]'::jsonb, '"$1.2$"'::jsonb, 'easy', 'Column subtraction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $3.0 - 1.8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{1}{2}$ to a decimal.', 'multiple_choice', '["$0.5$","$0.2$","$0.25$","$0.12$"]'::jsonb, '"$0.5$"'::jsonb, 'easy', '$1 \div 2 = 0.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{1}{2}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is smallest: $0.4$, $0.35$, $0.5$?', 'multiple_choice', '["$0.35$","$0.4$","$0.5$","All equal"]'::jsonb, '"$0.35$"'::jsonb, 'easy', 'Compare hundredths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is smallest: $0.4$, $0.35$, $0.5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $0.2 \times 0.5$.', 'multiple_choice', '["$0.1$","$0.01$","$0.7$","$1.0$"]'::jsonb, '"$0.1$"'::jsonb, 'easy', '$2 \times 5 = 10$; two decimal places → $0.10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $0.2 \times 0.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $3.456$ to 1 decimal place.', 'multiple_choice', '["$3.5$","$3.4$","$3.46$","$3.0$"]'::jsonb, '"$3.5$"'::jsonb, 'medium', 'Hundredths digit $5$, round up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $3.456$ to 1 decimal place.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $2.4 \times 1.5$.', 'multiple_choice', '["$3.6$","$3.0$","$2.9$","$4.0$"]'::jsonb, '"$3.6$"'::jsonb, 'medium', '$24 \times 15 = 360$; two decimal places.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $2.4 \times 1.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $7.2 \div 0.9$.', 'multiple_choice', '["$8$","$0.8$","$6.3$","$80$"]'::jsonb, '"$8$"'::jsonb, 'medium', 'Multiply both by $10$: $72 \div 9 = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $7.2 \div 0.9$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{1}{4}$ to a decimal.', 'multiple_choice', '["$0.25$","$0.4$","$0.5$","$0.75$"]'::jsonb, '"$0.25$"'::jsonb, 'medium', '$1 \div 4 = 0.25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{1}{4}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $0.75$ as a fraction in lowest terms.', 'multiple_choice', '["$\\frac{3}{4}$","$\\frac{75}{100}$","$\\frac{7}{5}$","$\\frac{1}{4}$"]'::jsonb, '"$\\frac{3}{4}$"'::jsonb, 'medium', '$\frac{75}{100} = \frac{3}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $0.75$ as a fraction in lowest terms.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Order $0.09$, $0.9$, $0.099$ from smallest.', 'multiple_choice', '["$0.09, 0.099, 0.9$","$0.9, 0.099, 0.09$","$0.099, 0.09, 0.9$","$0.09, 0.9, 0.099$"]'::jsonb, '"$0.09, 0.099, 0.9$"'::jsonb, 'medium', 'Compare place values carefully.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Order $0.09$, $0.9$, $0.099$ from smallest.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A book costs KES $45.50$. Pay with KES $50$. Change?', 'multiple_choice', '["KES $4.50$","KES $5.50$","KES $4.00$","KES $5.00$"]'::jsonb, '"KES $4.50$"'::jsonb, 'medium', '$50.00 - 45.50 = 4.50$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A book costs KES $45.50$. Pay with KES $50$. Change?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $2\,000 + 0.03$ as a decimal.', 'multiple_choice', '["$2\\,000.03$","$200.03$","$2\\,003$","$20.03$"]'::jsonb, '"$2\\,000.03$"'::jsonb, 'hard', 'Whole plus hundredths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $2\,000 + 0.03$ as a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(1.5 + 0.5) \times 2.0$.', 'multiple_choice', '["$4.0$","$3.0$","$2.5$","$5.0$"]'::jsonb, '"$4.0$"'::jsonb, 'hard', 'Brackets: $2.0 \times 2.0 = 4.0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(1.5 + 0.5) \times 2.0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a recurring decimal?', 'multiple_choice', '["$0.\\dot{3}$","$0.25$","$0.5$","$0.125$"]'::jsonb, '"$0.\\dot{3}$"'::jsonb, 'hard', '$\frac{1}{3}$ repeats; others terminate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a recurring decimal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $0.48 \div 0.06$.', 'multiple_choice', '["$8$","$0.8$","$80$","$6$"]'::jsonb, '"$8$"'::jsonb, 'hard', 'Scale: $48 \div 6 = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $0.48 \div 0.06$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{5}{8}$ to a decimal.', 'multiple_choice', '["$0.625$","$0.58$","$0.85$","$0.125$"]'::jsonb, '"$0.625$"'::jsonb, 'hard', '$5 \div 8 = 0.625$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{5}{8}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A length is $3.05$ m. Express in cm.', 'multiple_choice', '["$305$ cm","$30.5$ cm","$350$ cm","$3\\,050$ cm"]'::jsonb, '"$305$ cm"'::jsonb, 'hard', 'Multiply by $100$: $305$ cm.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A length is $3.05$ m. Express in cm.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $12.6 \div 0.3 + 1.2$.', 'multiple_choice', '["$43.2$","$42.0$","$4.2$","$13.8$"]'::jsonb, '"$43.2$"'::jsonb, 'hard', '$12.6 \div 0.3 = 42$; $42 + 1.2 = 43.2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $12.6 \div 0.3 + 1.2$.');