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

-- ========== CIRCLES: CHORDS AND TANGENTS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Chord Properties of Circles', '{"blocks":[{"type":"heading","content":"Chords in a Circle"},{"type":"paragraph","content":"A **chord** is a straight line joining **two points on the circumference**. The **longest chord** through the centre is a **diameter**."},{"type":"callout","variant":"key_point","content":"**Equal chords** are equidistant from the centre. **Chords equidistant from the centre are equal**."},{"type":"paragraph","content":"Imagine circle centre $O$: chord $AB$ with midpoint $M$. If $OM \\perp AB$, then $AM = MB$ (perpendicular from centre bisects the chord)."},{"type":"question","questionText":"A diameter is a chord that?","questionType":"multiple_choice","options":["Passes through the centre","Touches one point only","Lies outside","Is always shortest"],"correctAnswer":"Passes through the centre","explanation":"Definition."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'chord_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Chord Properties of Circles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Chord Theorems', '{"blocks":[{"type":"heading","content":"Perpendicular from Centre"},{"type":"example","title":"Chord $AB$ length $16$ cm; centre $O$ is $3$ cm from chord. Find radius.","steps":["Half chord $= 8$ cm.","Right triangle: $r^2 = 8^2 + 3^2 = 73$.","$r = \\sqrt{73}$ cm."],"answer":"$\\sqrt{73}$ cm $\\approx 8.54$ cm"},{"type":"callout","variant":"warning","content":"Draw the radius to the **midpoint** of the chord â€” it is perpendicular to the chord."},{"type":"example","title":"Two parallel chords $6$ cm and $8$ cm on opposite sides of centre, distance apart $14$ cm. Find radius.","steps":["Use distances from centre to each chord.","Set up $r^2 = d_1^2 + 9$ and $r^2 = d_2^2 + 16$ with $d_1+d_2=14$.","Solve simultaneously."],"answer":"Radius $= \\sqrt{58}$ cm"},{"type":"question","questionText":"Perpendicular from centre to chord bisects?","questionType":"multiple_choice","options":["The chord","The circle","The tangent","The arc only"],"correctAnswer":"The chord","explanation":"Creates two equal segments."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'chord_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Chord Theorems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Chord Properties â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Chords"},{"type":"example","title":"In circle centre $O$, chord $PQ=24$ cm, $OM \\perp PQ$ at $M$, $OM=5$ cm. Radius?","steps":["$PM=12$.","$r=\\sqrt{12^2+5^2}=13$ cm."],"answer":"$13$ cm"},{"type":"callout","variant":"warning","content":"Always halve the chord before using Pythagoras with the radius."},{"type":"question","questionText":"Equal chords in same circle are?","questionType":"multiple_choice","options":["Equidistant from centre","Parallel always","Perpendicular","Diameters"],"correctAnswer":"Equidistant from centre","explanation":"Chord theorem."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'chord_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Chord Properties â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A chord joins?', 'multiple_choice', '["Two points on circumference","Centre to tangent","Two centres","Two tangents"]'::jsonb, '"Two points on circumference"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A chord joins?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Longest chord in a circle is?', 'multiple_choice', '["Diameter","Radius","Tangent","Arc"]'::jsonb, '"Diameter"'::jsonb, 'easy', 'Through centre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Longest chord in a circle is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular from centre to chord meets chord at?', 'multiple_choice', '["Midpoint","Endpoint","Outside","Tangent point"]'::jsonb, '"Midpoint"'::jsonb, 'easy', 'Bisects chord.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular from centre to chord meets chord at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chord $16$ cm, distance from centre $6$ cm. Radius?', 'multiple_choice', '["$10$ cm","$8$ cm","$\\sqrt{52}$ cm","$22$ cm"]'::jsonb, '"$10$ cm"'::jsonb, 'medium', '$8^2+6^2=100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chord $16$ cm, distance from centre $6$ cm. Radius?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $13$ cm, chord $10$ cm from centre. Chord length?', 'multiple_choice', '["$24$ cm","$12$ cm","$26$ cm","$10$ cm"]'::jsonb, '"$24$ cm"'::jsonb, 'medium', 'Half $=12$; chord $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $13$ cm, chord $10$ cm from centre. Chord length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circle radius $10$; chord $16$ cm. Distance from centre?', 'multiple_choice', '["$6$ cm","$8$ cm","$4$ cm","$\\sqrt{164}$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'hard', '$8^2+d^2=100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circle radius $10$; chord $16$ cm. Distance from centre?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chords $AB$ and $CD$ equal; prove distances from $O$ equal. Uses?', 'multiple_choice', '["Congruent triangles $OMA$ and $ONC$","Parallel lines only","Tangent properties","Area ratios"]'::jsonb, '"Congruent triangles $OMA$ and $ONC$"'::jsonb, 'hard', 'RHS congruence.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='chord_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chords $AB$ and $CD$ equal; prove distances from $O$ equal. Uses?');

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangent Properties', '{"blocks":[{"type":"heading","content":"Tangents to a Circle"},{"type":"paragraph","content":"A **tangent** touches the circle at **exactly one point**. The tangent is **perpendicular to the radius** drawn to the point of contact."},{"type":"math_block","latex":"OT \\perp \\text{tangent at } T","caption":"$O$ centre, $T$ point of contact"},{"type":"callout","variant":"key_point","content":"Tangents from an **external point** to a circle are **equal in length**."},{"type":"question","questionText":"Tangent meets radius at point of contact at?","questionType":"multiple_choice","options":["$90^\\circ$","$45^\\circ$","$180^\\circ$","$60^\\circ$"],"correctAnswer":"$90^\\circ$","explanation":"Perpendicular."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'tangent_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangent Properties');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangent Length and Angles', '{"blocks":[{"type":"heading","content":"Equal Tangents"},{"type":"example","title":"From external point $P$, tangents $PA$ and $PB$ touch circle at $A$, $B$. If $PA=7$ cm, find $PB$.","steps":["Tangents from $P$ are equal.","$PB = 7$ cm."],"answer":"$7$ cm"},{"type":"callout","variant":"warning","content":"The line $OP$ bisects the angle between the two tangents."},{"type":"example","title":"Radius $5$ cm, tangent at $T$. Point $P$ on tangent, $PT=12$ cm. Find $OP$.","steps":["$OT \\perp PT$; $OT=5$, $PT=12$.","$OP=\\sqrt{5^2+12^2}=13$ cm."],"answer":"$13$ cm"},{"type":"question","questionText":"Two tangents from $P$ to circle â€” lengths?","questionType":"multiple_choice","options":["Equal","Unequal always","Sum to radius","Half the diameter"],"correctAnswer":"Equal","explanation":"Tangent theorem."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'tangent_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangent Length and Angles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tangent Properties â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Tangents"},{"type":"example","title":"Circle radius $6$ cm; tangent from $P$ has length $8$ cm. Distance $OP$?","steps":["Right triangle: $OP^2=6^2+8^2=100$.","$OP=10$ cm."],"answer":"$10$ cm"},{"type":"callout","variant":"warning","content":"Diagram in words: draw radius to point of contact â€” it is the height of the right triangle."},{"type":"question","questionText":"Tangent touches circle at how many points?","questionType":"multiple_choice","options":["One","Two","Zero","Infinitely many"],"correctAnswer":"One","explanation":"Definition."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'tangent_properties'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tangent Properties â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent to circle touches at?', 'multiple_choice', '["One point","Two points","No point","All points"]'::jsonb, '"One point"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent to circle touches at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius to point of contact is ___ tangent.', 'multiple_choice', '["Perpendicular to","Parallel to","Equal to","Tangent to"]'::jsonb, '"Perpendicular to"'::jsonb, 'easy', 'Key theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius to point of contact is ___ tangent.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $8$ cm, tangent segment $15$ cm from contact to $P$. $OP$?', 'multiple_choice', '["$17$ cm","$23$ cm","$7$ cm","$\\sqrt{289}$ cm"]'::jsonb, '"$17$ cm"'::jsonb, 'medium', '$8^2+15^2=289$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $8$ cm, tangent segment $15$ cm from contact to $P$. $OP$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangents $TA$, $TB$ from $T$; $TA=9$ cm. $TB$?', 'multiple_choice', '["$9$ cm","$18$ cm","$4.5$ cm","Unknown"]'::jsonb, '"$9$ cm"'::jsonb, 'medium', 'Equal tangents.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangents $TA$, $TB$ from $T$; $TA=9$ cm. $TB$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $r$, distance from centre to external point $d$. Tangent length?', 'multiple_choice', '["$\\sqrt{d^2-r^2}$","$d-r$","$d+r$","$dr$"]'::jsonb, '"$\\sqrt{d^2-r^2}$"'::jsonb, 'medium', 'Pythagoras.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $r$, distance from centre to external point $d$. Tangent length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $10$ cm; tangent from $P$ length $24$ cm. $OP$?', 'multiple_choice', '["$26$ cm","$14$ cm","$34$ cm","$20$ cm"]'::jsonb, '"$26$ cm"'::jsonb, 'hard', '$10^2+24^2=676$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $10$ cm; tangent from $P$ length $24$ cm. $OP$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two tangents from $P$ make $50^\circ$ at $P$. Angle between radii to contact points?', 'multiple_choice', '["$130^\\circ$","$50^\\circ$","$230^\\circ$","$80^\\circ$"]'::jsonb, '"$130^\\circ$"'::jsonb, 'hard', 'Supplementary in cyclic quad.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tangent_properties'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two tangents from $P$ make $50^\circ$ at $P$. Angle between radii to contact points?');

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Intersecting Chords Inside a Circle', '{"blocks":[{"type":"heading","content":"Chord-Chord Products"},{"type":"paragraph","content":"When two chords **intersect inside** a circle at point $P$, the product of the segments of one chord equals the product of the segments of the other."},{"type":"math_block","latex":"PA \\times PB = PC \\times PD","caption":"Chords $AB$ and $CD$ meet at $P$ inside the circle"},{"type":"callout","variant":"key_point","content":"Label segments carefully: each segment is from $P$ to the circumference along that chord."},{"type":"question","questionText":"Intersecting chords meet?","questionType":"multiple_choice","options":["Inside the circle","Always at centre","Outside only","On tangent"],"correctAnswer":"Inside the circle","explanation":"Interior intersection."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'intersecting_chords'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Intersecting Chords Inside a Circle');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Intersecting Chord Problems', '{"blocks":[{"type":"heading","content":"Product Rule"},{"type":"example","title":"Chords intersect at $P$: $PA=4$, $PB=9$, $PC=6$. Find $PD$.","steps":["$PA \\cdot PB = PC \\cdot PD$.","$4 \\times 9 = 6 \\times PD$.","$PD = 6$."],"answer":"$PD = 6$"},{"type":"callout","variant":"warning","content":"Do not mix segments from different chords â€” pair $PA$ with $PB$, and $PC$ with $PD$."},{"type":"example","title":"$AP=3$, $BP=8$, $CP=4$. Find $DP$.","steps":["$3 \\times 8 = 4 \\times DP$.","$DP = 6$."],"answer":"$DP = 6$"},{"type":"question","questionText":"$PA \\cdot PB$ equals?","questionType":"multiple_choice","options":["$PC \\cdot PD$","$PA + PB$","$PC - PD$","$PA / PB$"],"correctAnswer":"$PC \\cdot PD$","explanation":"Intersecting chords theorem."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'intersecting_chords'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Intersecting Chord Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Intersecting Chords â€” Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE â€” Intersecting Chords"},{"type":"example","title":"Two chords cross: segments $5$ cm and $12$ cm on one; one segment $6$ cm on the other. Find unknown segment.","steps":["$5 \\times 12 = 6 \\times x$.","$x = 10$ cm."],"answer":"$10$ cm"},{"type":"callout","variant":"warning","content":"Sketch: mark intersection $P$ and all four segments before calculating."},{"type":"question","questionText":"If $PA=2$, $PB=18$, $PC=3$, then $PD$?","questionType":"multiple_choice","options":["$12$","$6$","$9$","$36$"],"correctAnswer":"$12$","explanation":"$36=3 \\cdot PD$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents' AND st.code = 'intersecting_chords'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Intersecting Chords â€” Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Intersecting chords theorem: $PA \times PB$ equals?', 'multiple_choice', '["$PC \\times PD$","$PA + PB$","$PC + PD$","$PA - PB$"]'::jsonb, '"$PC \\times PD$"'::jsonb, 'easy', 'Product equality.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Intersecting chords theorem: $PA \times PB$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Chords intersect?', 'multiple_choice', '["Inside circle","Outside circle only","At centre always","Never"]'::jsonb, '"Inside circle"'::jsonb, 'easy', 'Interior point $P$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Chords intersect?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$AP=5$, $BP=4$, $CP=10$. Find $DP$.', 'multiple_choice', '["$2$","$5$","$20$","$40$"]'::jsonb, '"$2$"'::jsonb, 'medium', '$20=10 \cdot DP$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$AP=5$, $BP=4$, $CP=10$. Find $DP$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$PA=8$, $PB=3$, $PC=6$. $PD$?', 'multiple_choice', '["$4$","$24$","$2$","$18$"]'::jsonb, '"$4$"'::jsonb, 'medium', '$24=6 \cdot PD$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$PA=8$, $PB=3$, $PC=6$. $PD$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$PA=2.5$, $PB=12$, $PC=4$. $PD$?', 'multiple_choice', '["$7.5$","$30$","$5$","$3$"]'::jsonb, '"$7.5$"'::jsonb, 'hard', '$30=4 \cdot PD$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$PA=2.5$, $PB=12$, $PC=4$. $PD$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Intersecting chords: if one segment triples, other chord product?', 'multiple_choice', '["Unchanged if other segments adjust","Always triples","Halves","Zero"]'::jsonb, '"Unchanged if other segments adjust"'::jsonb, 'hard', 'Product constant for fixed chords.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Intersecting chords: if one segment triples, other chord product?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$PA=x$, $PB=9$, $PC=6$, $PD=6$. $x$?', 'multiple_choice', '["$4$","$9$","$36$","$1$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$9x=36$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='intersecting_chords'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='circles_chords_tangents'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$PA=x$, $PB=9$, $PC=6$, $PD=6$. $x$?');

