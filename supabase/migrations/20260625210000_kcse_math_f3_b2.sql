-- KCSE Form 3 Mathematics â€” Wave 3 Batch 2
-- Topics: commercial_arithmetic_ii, circles_chords_tangents, matrices, formulae_variations, sequences_series
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== COMMERCIAL ARITHMETIC II ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Compound Interest', '{"blocks":[{"type":"heading","content":"Compound Interest"},{"type":"paragraph","content":"**Compound interest** is interest calculated on the **principal plus all interest already earned**. Each period, interest is added to the amount, so the next period earns interest on a larger base."},{"type":"math_block","latex":"A = P\\left(1 + \\frac{R}{100}\\right)^n","caption":"Amount after $n$ years at rate $R\\%$ p.a."},{"type":"callout","variant":"key_point","content":"$A$ = final amount, $P$ = principal, $R$ = annual rate $\\%$, $n$ = number of years."},{"type":"example","title":"P KES $10\\,000$, $R=10\\%$, $n=2$ years. Find $A$.","steps":["$A = 10000(1.1)^2 = 10000 \\times 1.21 = 12100$."],"answer":"KES $12\\,100$"},{"type":"question","questionText":"Compound interest differs from simple interest because?","questionType":"multiple_choice","options":["Interest earns further interest","No interest is paid","Principal decreases","Rate changes daily"],"correctAnswer":"Interest earns further interest","explanation":"Interest is added to principal each period."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'compound_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Compound Interest');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Compound Interest', '{"blocks":[{"type":"heading","content":"Worked Compound Interest"},{"type":"example","title":"Find compound interest on KES $8000$ at $5\\%$ for $3$ years.","steps":["$A = 8000(1.05)^3 = 8000 \\times 1.157625 \\approx 9261$.","CI $= A - P = 9261 - 8000 = 1261$."],"answer":"KES $1261$"},{"type":"callout","variant":"warning","content":"Compound interest $= A - P$, not the same as simple interest unless $n=1$."},{"type":"example","title":"After $2$ years, amount is KES $6050$ from P KES $5000$. Find $R$ if compounded annually.","steps":["$6050 = 5000(1 + R/100)^2$.","$(1.21) = (1 + R/100)^2$.","$R = 10\\%$."],"answer":"$R = 10\\%$"},{"type":"question","questionText":"P KES $2000$, $R=8\\%$, $n=1$. Amount?","questionType":"multiple_choice","options":["KES $2160$","KES $2080$","KES $2008$","KES $2240$"],"correctAnswer":"KES $2160$","explanation":"$2000 \\times 1.08$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'compound_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Compound Interest');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Compound Interest â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Compound Interest"},{"type":"example","title":"A SACCO member deposits KES $15\\,000$ at $12\\%$ p.a. compounded yearly for $2$ years.","steps":["$A = 15000(1.12)^2 = 15000 \\times 1.2544 = 18816$.","Interest $= 3816$."],"answer":"Amount KES $18\\,816$; interest KES $3816$"},{"type":"callout","variant":"warning","content":"Check whether the question wants **amount** or **interest only**."},{"type":"question","questionText":"Which grows faster over several years?","questionType":"multiple_choice","options":["Compound interest","Simple interest at same rate","Both always equal","Neither grows"],"correctAnswer":"Compound interest","explanation":"Interest-on-interest effect."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'compound_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Compound Interest â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Compound interest formula uses?', 'multiple_choice', '["$\\left(1 + \\frac{R}{100}\\right)^n$","$\\frac{PRT}{100}$ only","$P + Rn$","$P - Rn$"]'::jsonb, '"$\\left(1 + \\frac{R}{100}\\right)^n$"'::jsonb, 'easy', 'Growth factor raised to $n$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Compound interest formula uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $5000$, $R=10\%$, $n=2$ yr. Amount?', 'multiple_choice', '["KES $6050$","KES $6000$","KES $5500$","KES $5100$"]'::jsonb, '"KES $6050$"'::jsonb, 'easy', '$5000(1.1)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $5000$, $R=10\%$, $n=2$ yr. Amount?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'CI means interest on?', 'multiple_choice', '["Principal and accumulated interest","Principal only","Interest only","Tax only"]'::jsonb, '"Principal and accumulated interest"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='CI means interest on?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $2500$, $R=8\%$, $n=3$. Amount nearest?', 'multiple_choice', '["KES $3149.92$","KES $3100$","KES $3000$","KES $3250$"]'::jsonb, '"KES $3149.92$"'::jsonb, 'medium', '$2500(1.08)^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $2500$, $R=8\%$, $n=3$. Amount nearest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $12000$, amount after $2$ yr is KES $14520$ compounded annually. Rate $R$?', 'multiple_choice', '["$10\\%$","$8\\%$","$12\\%$","$21\\%$"]'::jsonb, '"$10\\%$"'::jsonb, 'medium', '$(14520/12000)^{1/2} - 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $12000$, amount after $2$ yr is KES $14520$ compounded annually. Rate $R$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $50000$, $R=8\%$, $n=3$. CI?', 'multiple_choice', '["KES $12985.12$","KES $12000$","KES $62985.12$","KES $15000$"]'::jsonb, '"KES $12985.12$"'::jsonb, 'hard', '$A=62985.12$; subtract $P$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $50000$, $R=8\%$, $n=3$. CI?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'KES $10000$ invested at $10\%$ compounded; after $2$ yr withdrawn and reinvested $2$ more yr at $10\%$. Final amount?', 'multiple_choice', '["KES $14641$","KES $14000$","KES $12100$","KES $13000$"]'::jsonb, '"KES $14641$"'::jsonb, 'hard', '$10000(1.1)^4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='compound_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='KES $10000$ invested at $10\%$ compounded; after $2$ yr withdrawn and reinvested $2$ more yr at $10\%$. Final amount?');

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Appreciation and Depreciation', '{"blocks":[{"type":"heading","content":"Value Changes Over Time"},{"type":"paragraph","content":"**Appreciation** is when an asset **increases** in value (e.g. land). **Depreciation** is when value **decreases** (e.g. vehicles, machinery)."},{"type":"math_block","latex":"V_n = V_0\\left(1 + \\frac{r}{100}\\right)^n \\text{ (appreciation)}","caption":"Appreciation uses positive rate"},{"type":"math_block","latex":"V_n = V_0\\left(1 - \\frac{d}{100}\\right)^n \\text{ (depreciation)}","caption":"Depreciation uses reduction factor"},{"type":"callout","variant":"key_point","content":"Same compound-growth idea: multiply by a factor each period."},{"type":"question","questionText":"A car losing $15\\%$ value yearly is?","questionType":"multiple_choice","options":["Depreciation","Appreciation","Simple interest","Commission"],"correctAnswer":"Depreciation","explanation":"Value falls."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'appreciation_depreciation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Appreciation and Depreciation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Appreciation and Depreciation', '{"blocks":[{"type":"heading","content":"Worked Value Problems"},{"type":"example","title":"Land worth KES $500\\,000$ appreciates at $8\\%$ p.a. Value after $3$ years?","steps":["$V = 500000(1.08)^3 = 500000 \\times 1.259712 \\approx 629856$."],"answer":"KES $629\\,856$"},{"type":"example","title":"Machine KES $120\\,000$, depreciates $20\\%$ p.a. Value after $2$ years?","steps":["$V = 120000(0.8)^2 = 120000 \\times 0.64 = 76800$."],"answer":"KES $76\\,800$"},{"type":"callout","variant":"warning","content":"Depreciation rate $d\\%$ means multiply by $(1 - d/100)$ each year, not subtract $d\\%$ of original each time."},{"type":"question","questionText":"$20\\%$ depreciation factor per year?","questionType":"multiple_choice","options":["$0.8$","$1.2$","$0.2$","$1.8$"],"correctAnswer":"$0.8$","explanation":"$1 - 0.2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'appreciation_depreciation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Appreciation and Depreciation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Appreciation & Depreciation â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Value Change"},{"type":"example","title":"House bought KES $2\\,400\\,000$, appreciates $5\\%$ yearly. Worth after $4$ years?","steps":["$V = 2400000(1.05)^4 \\approx 2916030$."],"answer":"KES $2\\,916\\,030$"},{"type":"callout","variant":"warning","content":"State whether the rate is appreciation (+) or depreciation (âˆ’)."},{"type":"question","questionText":"Depreciating asset value after many years?","questionType":"multiple_choice","options":["Approaches zero but compound model never negative","Always negative","Doubles","Stays constant"],"correctAnswer":"Approaches zero but compound model never negative","explanation":"Repeated multiplication by factor $<1$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'appreciation_depreciation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Appreciation & Depreciation â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Appreciation means value?', 'multiple_choice', '["Increases","Decreases","Stays same","Becomes zero"]'::jsonb, '"Increases"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Appreciation means value?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Depreciation means value?', 'multiple_choice', '["Decreases","Increases","Doubles","Is taxed"]'::jsonb, '"Decreases"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Depreciation means value?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Machine KES $50000$, $20\%$ depreciation $2$ yr. Value?', 'multiple_choice', '["KES $32000$","KES $30000$","KES $40000$","KES $25000$"]'::jsonb, '"KES $32000$"'::jsonb, 'medium', '$50000(0.8)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Machine KES $50000$, $20\%$ depreciation $2$ yr. Value?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Asset KES $100000$, appreciates $6\%$ for $2$ yr. Value?', 'multiple_choice', '["KES $112360$","KES $112000$","KES $106000$","KES $120000$"]'::jsonb, '"KES $112360$"'::jsonb, 'medium', '$100000(1.06)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Asset KES $100000$, appreciates $6\%$ for $2$ yr. Value?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Value after $3$ yr: start KES $200000$, depreciate $15\%$/yr?', 'multiple_choice', '["KES $122825$","KES $110000$","KES $140000$","KES $170000$"]'::jsonb, '"KES $122825$"'::jsonb, 'medium', '$200000(0.85)^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Value after $3$ yr: start KES $200000$, depreciate $15\%$/yr?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Motorbike KES $180\,000$, depreciates $15\%$/yr for $4$ yr. Value nearest?', 'multiple_choice', '["KES $78\\,732$","KES $72000$","KES $90000$","KES $108000$"]'::jsonb, '"KES $78\\,732$"'::jsonb, 'hard', '$180000(0.85)^4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Motorbike KES $180\,000$, depreciates $15\%$/yr for $4$ yr. Value nearest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Building KES $5\,000\,000$, appreciates $3\%$ for $5$ yr. Value nearest?', 'multiple_choice', '["KES $5\\,796\\,370$","KES $5750000$","KES $5500000$","KES $6000000$"]'::jsonb, '"KES $5\\,796\\,370$"'::jsonb, 'hard', '$5000000(1.03)^5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='appreciation_depreciation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Building KES $5\,000\,000$, appreciates $3\%$ for $5$ yr. Value nearest?');

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Hire Purchase Agreements', '{"blocks":[{"type":"heading","content":"Hire Purchase (HP)"},{"type":"paragraph","content":"**Hire purchase** lets a buyer take goods after paying a **deposit**, then **monthly instalments** until the total HP price is paid. Ownership transfers when fully paid."},{"type":"callout","variant":"key_point","content":"HP price $=$ deposit $+$ (number of instalments $\\times$ instalment amount)."},{"type":"example","title":"TV cash price KES $48\\,000$; HP: deposit KES $12\\,000$ plus $10$ monthly instalments of KES $4000$.","steps":["HP price $= 12000 + 10 \\times 4000 = 52000$.","Extra cost over cash $= 52000 - 48000 = 4000$."],"answer":"HP price KES $52\\,000$; extra KES $4000$"},{"type":"question","questionText":"Deposit is paid?","questionType":"multiple_choice","options":["At the start","At the end only","Never","After $5$ years"],"correctAnswer":"At the start","explanation":"Up-front payment."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'hire_purchase'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Hire Purchase Agreements');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'HP Calculations and Comparisons', '{"blocks":[{"type":"heading","content":"Comparing Cash and HP"},{"type":"example","title":"Fridge cash KES $36\\,000$. HP: deposit KES $9000$, $12$ instalments of KES $2500$.","steps":["HP total $= 9000 + 12 \\times 2500 = 39000$.","HP interest/charge $= 39000 - 36000 = 3000$."],"answer":"HP costs KES $3000$ more than cash"},{"type":"callout","variant":"warning","content":"HP price is almost always **higher** than cash price â€” the difference is the cost of credit."},{"type":"example","title":"Find deposit if HP price KES $60\\,000$, $15$ instalments of KES $3000$.","steps":["Instalments total $= 45000$.","Deposit $= 60000 - 45000 = 15000$."],"answer":"KES $15\\,000$"},{"type":"question","questionText":"HP total minus cash price gives?","questionType":"multiple_choice","options":["Extra HP cost","Deposit","VAT only","Profit margin"],"correctAnswer":"Extra HP cost","explanation":"Credit charge."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'hire_purchase'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'HP Calculations and Comparisons');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Hire Purchase â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Hire Purchase"},{"type":"example","title":"Laptop cash KES $72\\,000$. Shop A: deposit $25\\%$ of cash plus $8$ months at KES $6500$. Find HP price.","steps":["Deposit $= 0.25 \\times 72000 = 18000$.","HP $= 18000 + 8 \\times 6500 = 70000$."],"answer":"KES $70\\,000$"},{"type":"callout","variant":"warning","content":"Deposit may be quoted as a **percentage of cash price** â€” calculate the actual KES amount first."},{"type":"question","questionText":"$18$ instalments of KES $2000$ plus deposit KES $5000$. HP price?","questionType":"multiple_choice","options":["KES $41000$","KES $36000$","KES $45000$","KES $5000$"],"correctAnswer":"KES $41000$","explanation":"$5000 + 18 \\times 2000$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii' AND st.code = 'hire_purchase'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Hire Purchase â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'HP price equals deposit plus?', 'multiple_choice', '["Total instalments","Cash price only","VAT only","Interest rate"]'::jsonb, '"Total instalments"'::jsonb, 'easy', 'Sum all payments.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='HP price equals deposit plus?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Deposit KES $5000$, $6$ instalments of KES $2000$. HP price?', 'multiple_choice', '["KES $17000$","KES $12000$","KES $7000$","KES $20000$"]'::jsonb, '"KES $17000$"'::jsonb, 'easy', '$5000+6 \times 2000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Deposit KES $5000$, $6$ instalments of KES $2000$. HP price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cash KES $45000$, HP KES $51000$. Extra cost?', 'multiple_choice', '["KES $6000$","KES $4500$","KES $96000$","KES $3000$"]'::jsonb, '"KES $6000$"'::jsonb, 'medium', 'Difference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cash KES $45000$, HP KES $51000$. Extra cost?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'HP KES $56000$, deposit KES $14000$, $14$ equal instalments. Each?', 'multiple_choice', '["KES $3000$","KES $4000$","KES $2800$","KES $3500$"]'::jsonb, '"KES $3000$"'::jsonb, 'medium', '$(56000-14000)/14$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='HP KES $56000$, deposit KES $14000$, $14$ equal instalments. Each?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Furniture cash KES $95000$. HP KES $108000$. Deposit $25\%$ of HP. Deposit?', 'multiple_choice', '["KES $27000$","KES $23750$","KES $25000$","KES $95000$"]'::jsonb, '"KES $27000$"'::jsonb, 'hard', '$0.25 \times 108000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Furniture cash KES $95000$. HP KES $108000$. Deposit $25\%$ of HP. Deposit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Motorbike: cash KES $150000$, HP deposit KES $30000$, balance in $15$ equal instalments. Each instalment?', 'multiple_choice', '["KES $8666.67$","KES $8000$","KES $10000$","KES $12000$"]'::jsonb, '"KES $8666.67$"'::jsonb, 'hard', 'If HP $160000$: $(160000-30000)/15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Motorbike: cash KES $150000$, HP deposit KES $30000$, balance in $15$ equal instalments. Each instalment?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'TV HP KES $84000$ (cash KES $75000$). Deposit KES $21000$, find monthly instalment if $10$ months.', 'multiple_choice', '["KES $6300$","KES $6000$","KES $5400$","KES $7500$"]'::jsonb, '"KES $6300$"'::jsonb, 'hard', '$(84000-21000)/10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='hire_purchase'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_ii'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='TV HP KES $84000$ (cash KES $75000$). Deposit KES $21000$, find monthly instalment if $10$ months.');

