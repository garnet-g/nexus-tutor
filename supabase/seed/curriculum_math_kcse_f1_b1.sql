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
SELECT t.id, st.id, 'Which fraction is proper?', 'multiple_choice', '["$\\frac{7}{9}$","$\\frac{9}{7}$","$\\frac{9}{9}$","$2\\frac{1}{3}$"]'::jsonb, '"$\frac{7}{9}$"'::jsonb, 'easy', 'Numerator is less than denominator.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which fraction is proper?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{8}{12}$.', 'multiple_choice', '["$\\frac{2}{3}$","$\\frac{4}{6}$","$\\frac{3}{2}$","$\\frac{1}{4}$"]'::jsonb, '"$\frac{2}{3}$"'::jsonb, 'easy', 'Divide top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{8}{12}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{9}{4}$ to a mixed number.', 'multiple_choice', '["$2\\frac{1}{4}$","$1\\frac{5}{4}$","$4\\frac{1}{9}$","$\\frac{13}{4}$"]'::jsonb, '"$2\frac{1}{4}$"'::jsonb, 'easy', '$9 \div 4 = 2$ remainder $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{9}{4}$ to a mixed number.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{5} + \frac{2}{5}$.', 'multiple_choice', '["$\\frac{3}{5}$","$\\frac{3}{10}$","$\\frac{2}{5}$","$\\frac{1}{5}$"]'::jsonb, '"$\frac{3}{5}$"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{5} + \frac{2}{5}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3}{4} - \frac{1}{4}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{2}{4}$","$\\frac{4}{4}$","$\\frac{2}{8}$"]'::jsonb, '"$\frac{1}{2}$"'::jsonb, 'easy', '$\frac{3-1}{4} = \frac{2}{4} = \frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3}{4} - \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} \times \frac{2}{3}$.', 'multiple_choice', '["$\\frac{1}{3}$","$\\frac{2}{5}$","$\\frac{3}{4}$","$\\frac{2}{6}$"]'::jsonb, '"$\frac{1}{3}$"'::jsonb, 'easy', '$\frac{2}{6} = \frac{1}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} \times \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.', 'multiple_choice', '["$1\\frac{1}{2}$","$2$","$1$","$\\frac{3}{2}$"]'::jsonb, '"$1\frac{1}{2}$"'::jsonb, 'easy', 'Multiply first: $1 + 1 = 1\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is equivalent to $\frac{3}{5}$?', 'multiple_choice', '["$\\frac{12}{20}$","$\\frac{5}{3}$","$\\frac{6}{15}$","$\\frac{9}{25}$"]'::jsonb, '"$\frac{12}{20}$"'::jsonb, 'medium', 'Multiply top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is equivalent to $\frac{3}{5}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{2}{3} + \frac{1}{4}$.', 'multiple_choice', '["$\\frac{11}{12}$","$\\frac{3}{7}$","$\\frac{3}{12}$","$\\frac{8}{12}$"]'::jsonb, '"$\frac{11}{12}$"'::jsonb, 'medium', 'LCM $12$: $\frac{8}{12}+\frac{3}{12}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{2}{3} + \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{5}{6} - \frac{1}{3}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{4}{3}$","$\\frac{4}{6}$","$\\frac{1}{3}$"]'::jsonb, '"$\frac{1}{2}$"'::jsonb, 'medium', '$\frac{5}{6}-\frac{2}{6}=\frac{3}{6}=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{5}{6} - \frac{1}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{4}{5} \div \frac{2}{3}$.', 'multiple_choice', '["$1\\frac{1}{5}$","$\\frac{6}{20}$","$\\frac{8}{15}$","$\\frac{2}{5}$"]'::jsonb, '"$1\frac{1}{5}$"'::jsonb, 'medium', '$\frac{4}{5}\times\frac{3}{2}=\frac{12}{10}=1\frac{1}{5}$.'
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
SELECT t.id, st.id, 'A jug is $\frac{3}{4}$ full. $\frac{1}{4}$ is poured out. What fraction remains?', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{1}{4}$","$\\frac{2}{4}$","$\\frac{3}{4}$"]'::jsonb, '"$\frac{1}{2}$"'::jsonb, 'medium', '$\frac{3}{4}-\frac{1}{4}=\frac{1}{2}$.'
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
SELECT t.id, st.id, 'Evaluate $1\frac{1}{3} - \frac{2}{5}$.', 'multiple_choice', '["$\\frac{14}{15}$","$\\frac{8}{15}$","$\\frac{11}{15}$","$\\frac{3}{8}$"]'::jsonb, '"$\frac{14}{15}$"'::jsonb, 'hard', '$\frac{4}{3}-\frac{2}{5}=\frac{20-6}{15}=\frac{14}{15}$.'
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
SELECT t.id, st.id, 'Express $3\frac{2}{5}$ as an improper fraction.', 'multiple_choice', '["$\\frac{17}{5}$","$\\frac{15}{5}$","$\\frac{13}{5}$","$\\frac{32}{5}$"]'::jsonb, '"$\frac{17}{5}$"'::jsonb, 'hard', '$3\times 5 + 2 = 17$ over $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $3\frac{2}{5}$ as an improper fraction.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.', 'multiple_choice', '["$1\\frac{1}{2}$","$\\frac{3}{4}$","$2$","$1$"]'::jsonb, '"$1\frac{1}{2}$"'::jsonb, 'hard', 'Bracket $=1$; $\frac{1}{2}\div\frac{1}{3}=\frac{3}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.');