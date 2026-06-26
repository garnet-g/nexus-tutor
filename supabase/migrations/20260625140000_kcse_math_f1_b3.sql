-- KCSE Form 1 Mathematics — Wave 1 Batch 3
-- Topics: time, linear_equations, commercial_arithmetic_i, coordinates_graphs, angles_plane_figures
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md

-- ========== TIME ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Units of Time', '{"blocks":[{"type":"heading","content":"Units of Time"},{"type":"paragraph","content":"Time is measured in seconds (s), minutes (min), hours (h), days, weeks, months and years."},{"type":"paragraph","content":"$1$ min $= 60$ s, $1$ h $= 60$ min $= 3600$ s, $1$ day $= 24$ h."},{"type":"callout","variant":"key_point","content":"$1$ week $= 7$ days. $1$ year (ordinary) $= 365$ days."},{"type":"example","title":"Convert $3$ h to minutes","steps":["$3 \\times 60 = 180$ min."],"answer":"$180$ min"},{"type":"callout","variant":"warning","content":"Do not confuse $1.5$ h with $1$ h $50$ min — $1.5$ h $= 90$ min."},{"type":"question","questionText":"How many seconds in $2$ min?","questionType":"multiple_choice","options":["$120$","$60$","$200$","$12$"],"correctAnswer":"$120$","explanation":"$2 \\times 60 = 120$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'units_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Units of Time');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Converting Time Units', '{"blocks":[{"type":"heading","content":"Converting Time Units"},{"type":"example","title":"Convert $2.5$ h to minutes","steps":["$2.5 \\times 60 = 150$ min."],"answer":"$150$ min"},{"type":"example","title":"Convert $4500$ s to h and min","steps":["$4500 \\div 60 = 75$ min.","$75 \\div 60 = 1$ h $15$ min."],"answer":"$1$ h $15$ min"},{"type":"callout","variant":"warning","content":"When converting to a smaller unit, multiply. To a larger unit, divide."},{"type":"question","questionText":"Convert $90$ min to hours.","questionType":"multiple_choice","options":["$1.5$ h","$1$ h $30$ min only","$0.9$ h","$9$ h"],"correctAnswer":"$1.5$ h","explanation":"$90 \\div 60 = 1.5$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'units_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Converting Time Units');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Time Units in KCSE', '{"blocks":[{"type":"heading","content":"Exam Applications — Time Units"},{"type":"example","title":"A matatu journey from Nairobi to Nakuru takes $2$ h $45$ min. Express this in minutes.","steps":["$2 \\times 60 = 120$ min.","$120 + 45 = 165$ min."],"answer":"$165$ min"},{"type":"callout","variant":"warning","content":"Always convert hours to minutes before adding to minutes."},{"type":"question","questionText":"Express $1$ h $20$ min in minutes.","questionType":"multiple_choice","options":["$80$","$120$","$60$","$100$"],"correctAnswer":"$80$","explanation":"$60 + 20 = 80$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'units_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Time Units in KCSE');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Timetables', '{"blocks":[{"type":"heading","content":"Reading Timetables"},{"type":"paragraph","content":"A **timetable** shows when events start and finish. Read rows for days and columns for times."},{"type":"paragraph","content":"Find the start time, end time, then subtract to find duration."},{"type":"callout","variant":"key_point","content":"Duration $=$ end time $-$ start time (watch crossing noon/midnight)."},{"type":"example","title":"School starts $7{:}30$ am and ends $4{:}15$ pm. Find the duration.","steps":["$7{:}30$ am to $12{:}00$ noon $= 4$ h $30$ min.","$12{:}00$ to $4{:}15$ pm $= 4$ h $15$ min.","Total $= 8$ h $45$ min."],"answer":"$8$ h $45$ min"},{"type":"callout","variant":"warning","content":"Use a 24-hour clock or split at noon to avoid errors."},{"type":"question","questionText":"A lesson runs from $10{:}15$ am to $11{:}00$ am. How long?","questionType":"multiple_choice","options":["$45$ min","$55$ min","$1$ h $15$ min","$15$ min"],"correctAnswer":"$45$ min","explanation":"$11{:}00 - 10{:}15 = 45$ min."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'timetables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Timetables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Timetable Calculations', '{"blocks":[{"type":"heading","content":"Timetable Methods"},{"type":"example","title":"Train departs Nairobi $6{:}40$ am, arrives Mombasa $1{:}25$ pm. Journey time?","steps":["To noon: $5$ h $20$ min.","After noon: $1$ h $25$ min.","Total $= 6$ h $45$ min."],"answer":"$6$ h $45$ min"},{"type":"example","title":"Bus leaves every $25$ min from $8{:}00$ am. List the first four departures.","steps":["$8{:}00$, $8{:}25$, $8{:}50$, $9{:}15$ am."],"answer":"$8{:}00$, $8{:}25$, $8{:}50$, $9{:}15$ am"},{"type":"callout","variant":"warning","content":"Adding minutes past $60$ carries to the next hour."},{"type":"question","questionText":"If a bus leaves at $9{:}50$ am every $40$ min, when is the next bus?","questionType":"multiple_choice","options":["$10{:}30$ am","$10{:}40$ am","$10{:}20$ am","$10{:}50$ am"],"correctAnswer":"$10{:}30$ am","explanation":"$9{:}50 + 40$ min $= 10{:}30$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'timetables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Timetable Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Timetable Exam Problems', '{"blocks":[{"type":"heading","content":"KCSE Timetable Problems"},{"type":"example","title":"Wanjiku''''s KCPE revision: Maths $8{:}00$–$9{:}30$ am, English $9{:}45$–$11{:}00$ am, break $11{:}00$–$11{:}30$ am. How long is revision before break?","steps":["Maths: $1$ h $30$ min.","English: $1$ h $15$ min.","Total $= 2$ h $45$ min."],"answer":"$2$ h $45$ min"},{"type":"callout","variant":"warning","content":"Include only the study periods asked for — do not add break time unless required."},{"type":"question","questionText":"A film starts $7{:}45$ pm and ends $9{:}20$ pm. Duration?","questionType":"multiple_choice","options":["$1$ h $35$ min","$1$ h $25$ min","$2$ h $5$ min","$1$ h $45$ min"],"correctAnswer":"$1$ h $35$ min","explanation":"$7{:}45$ to $9{:}20$ pm."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'timetables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Timetable Exam Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Speed, Distance and Time', '{"blocks":[{"type":"heading","content":"Speed, Distance and Time"},{"type":"paragraph","content":"**Speed** tells how fast something moves: distance per unit time."},{"type":"paragraph","content":"$\\text{speed} = \\frac{\\text{distance}}{\\text{time}}$"},{"type":"callout","variant":"key_point","content":"Always use consistent units: km with h, metres with seconds."},{"type":"example","title":"A cyclist covers $15$ km in $1$ h. Find average speed.","steps":["$\\text{speed} = \\frac{15}{1} = 15$ km/h."],"answer":"$15$ km/h"},{"type":"callout","variant":"warning","content":"Do not mix km with minutes without converting."},{"type":"question","questionText":"A runner covers $400$ m in $50$ s. Speed in m/s?","questionType":"multiple_choice","options":["$8$ m/s","$4$ m/s","$80$ m/s","$0.125$ m/s"],"correctAnswer":"$8$ m/s","explanation":"$400 \\div 50 = 8$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'speed_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Speed, Distance and Time');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Speed–Time Calculations', '{"blocks":[{"type":"heading","content":"Worked Speed Problems"},{"type":"example","title":"Find distance if speed $= 60$ km/h and time $= 2.5$ h","steps":["$d = s \\times t = 60 \\times 2.5 = 150$ km."],"answer":"$150$ km"},{"type":"example","title":"Find time if $d = 45$ km and $s = 30$ km/h","steps":["$t = \\frac{d}{s} = \\frac{45}{30} = 1.5$ h."],"answer":"$1.5$ h"},{"type":"callout","variant":"warning","content":"Rearrange: $d = st$, $t = \\frac{d}{s}$, $s = \\frac{d}{t}$."},{"type":"question","questionText":"Speed $40$ km/h for $3$ h. Distance?","questionType":"multiple_choice","options":["$120$ km","$80$ km","$43$ km","$160$ km"],"correctAnswer":"$120$ km","explanation":"$40 \\times 3$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'speed_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Speed–Time Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Speed Exam Applications', '{"blocks":[{"type":"heading","content":"KCSE Speed Problems"},{"type":"example","title":"A bus leaves Kisumu at $8{:}00$ am at $50$ km/h for a $200$ km trip to Nairobi. Arrival time?","steps":["$t = \\frac{200}{50} = 4$ h.","$8{:}00$ am $+ 4$ h $= 12{:}00$ noon."],"answer":"$12{:}00$ noon"},{"type":"callout","variant":"warning","content":"Convert fractional hours to minutes for clock times."},{"type":"question","questionText":"Car travels $90$ km at $60$ km/h. Time in hours?","questionType":"multiple_choice","options":["$1.5$ h","$1$ h $40$ min","$0.67$ h","$2.5$ h"],"correctAnswer":"$1.5$ h","explanation":"$90 \\div 60 = 1.5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time' AND st.code = 'speed_time'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Speed Exam Applications');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many minutes in $3$ hours?', 'multiple_choice', '["$180$","$30$","$360$","$3$"]'::jsonb, '"$180$"'::jsonb, 'easy', '$3 \times 60 = 180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many minutes in $3$ hours?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $120$ seconds to minutes.', 'multiple_choice', '["$2$ min","$12$ min","$0.5$ min","$20$ min"]'::jsonb, '"$2$ min"'::jsonb, 'easy', '$120 \div 60 = 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $120$ seconds to minutes.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many hours in $2$ days?', 'multiple_choice', '["$48$","$24$","$12$","$36$"]'::jsonb, '"$48$"'::jsonb, 'easy', '$2 \times 24 = 48$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many hours in $2$ days?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Lesson from $9{:}00$ am to $9{:}40$ am lasts how long?', 'multiple_choice', '["$40$ min","$50$ min","$1$ h","$30$ min"]'::jsonb, '"$40$ min"'::jsonb, 'easy', '$9{:}40 - 9{:}00$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Lesson from $9{:}00$ am to $9{:}40$ am lasts how long?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bus at $6{:}15$ am, next at $6{:}45$ am. Interval?', 'multiple_choice', '["$30$ min","$15$ min","$45$ min","$1$ h"]'::jsonb, '"$30$ min"'::jsonb, 'easy', '$6{:}45 - 6{:}15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bus at $6{:}15$ am, next at $6{:}45$ am. Interval?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Distance $= 20$ km, time $= 2$ h. Speed?', 'multiple_choice', '["$10$ km/h","$40$ km/h","$5$ km/h","$22$ km/h"]'::jsonb, '"$10$ km/h"'::jsonb, 'easy', '$20 \div 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Distance $= 20$ km, time $= 2$ h. Speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Speed $5$ m/s for $10$ s. Distance?', 'multiple_choice', '["$50$ m","$15$ m","$2$ m","$500$ m"]'::jsonb, '"$50$ m"'::jsonb, 'easy', '$5 \times 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Speed $5$ m/s for $10$ s. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $2$ h $15$ min in minutes.', 'multiple_choice', '["$135$","$215$","$125$","$150$"]'::jsonb, '"$135$"'::jsonb, 'medium', '$120 + 15 = 135$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $2$ h $15$ min in minutes.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $3.25$ hours to minutes.', 'multiple_choice', '["$195$","$325$","$185$","$205$"]'::jsonb, '"$195$"'::jsonb, 'medium', '$3.25 \times 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $3.25$ hours to minutes.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Train $5{:}50$ am to $12{:}20$ pm. Journey time?', 'multiple_choice', '["$6$ h $30$ min","$7$ h $30$ min","$6$ h $20$ min","$5$ h $30$ min"]'::jsonb, '"$6$ h $30$ min"'::jsonb, 'medium', 'Split at noon.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Train $5{:}50$ am to $12{:}20$ pm. Journey time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Departures every $15$ min from $7{:}10$ am. Third departure?', 'multiple_choice', '["$7{:}40$ am","$7{:}35$ am","$7{:}45$ am","$7{:}25$ am"]'::jsonb, '"$7{:}40$ am"'::jsonb, 'medium', '$7{:}10 + 30$ min.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Departures every $15$ min from $7{:}10$ am. Third departure?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A car covers $75$ km in $1.5$ h. Average speed?', 'multiple_choice', '["$50$ km/h","$45$ km/h","$112.5$ km/h","$75$ km/h"]'::jsonb, '"$50$ km/h"'::jsonb, 'medium', '$75 \div 1.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A car covers $75$ km in $1.5$ h. Average speed?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Runner: $5$ km in $25$ min. Speed in km/h?', 'multiple_choice', '["$12$ km/h","$10$ km/h","$5$ km/h","$20$ km/h"]'::jsonb, '"$12$ km/h"'::jsonb, 'medium', '$25$ min $= \frac{5}{12}$ h; $5 \div \frac{5}{12} = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Runner: $5$ km in $25$ min. Speed in km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many seconds in $1$ h $5$ min?', 'multiple_choice', '["$3900$","$65$","$3605$","$3005$"]'::jsonb, '"$3900$"'::jsonb, 'medium', '$(60+5) \times 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many seconds in $1$ h $5$ min?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A worker is paid for $7$ h $45$ min. Express minutes worked.', 'multiple_choice', '["$465$","$475$","$445$","$745$"]'::jsonb, '"$465$"'::jsonb, 'hard', '$7 \times 60 + 45 = 465$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A worker is paid for $7$ h $45$ min. Express minutes worked.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Film $8{:}15$ pm to $10{:}50$ pm with $20$ min ads. Pure film time?', 'multiple_choice', '["$2$ h $15$ min","$2$ h $35$ min","$2$ h $5$ min","$2$ h $50$ min"]'::jsonb, '"$2$ h $15$ min"'::jsonb, 'hard', 'Total $2$ h $35$ min minus $20$ min.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Film $8{:}15$ pm to $10{:}50$ pm with $20$ min ads. Pure film time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Meeting every $45$ min from $2{:}20$ pm. When is the 5th meeting?', 'multiple_choice', '["$5{:}20$ pm","$5{:}05$ pm","$5{:}35$ pm","$4{:}50$ pm"]'::jsonb, '"$5{:}20$ pm"'::jsonb, 'hard', 'Add $4 \times 45 = 180$ min $= 3$ h.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='timetables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Meeting every $45$ min from $2{:}20$ pm. When is the 5th meeting?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bus $60$ km/h leaves $7{:}30$ am for $210$ km. Arrival?', 'multiple_choice', '["$11{:}00$ am","$10{:}30$ am","$11{:}30$ am","$12{:}00$ noon"]'::jsonb, '"$11{:}00$ am"'::jsonb, 'hard', '$t = 3.5$ h.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bus $60$ km/h leaves $7{:}30$ am for $210$ km. Arrival?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclist $18$ km at $12$ km/h, rests $30$ min, then $12$ km at $8$ km/h. Total time?', 'multiple_choice', '["$3$ h $30$ min","$3$ h","$2$ h $30$ min","$4$ h"]'::jsonb, '"$3$ h $30$ min"'::jsonb, 'hard', '$1.5$ h ride $+ 0.5$ h rest $+ 1.5$ h ride.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclist $18$ km at $12$ km/h, rests $30$ min, then $12$ km at $8$ km/h. Total time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two towns $120$ km apart. A leaves at $40$ km/h, B opposite at $60$ km/h. Meet after?', 'multiple_choice', '["$1.2$ h","$2$ h","$0.8$ h","$1.5$ h"]'::jsonb, '"$1.2$ h"'::jsonb, 'hard', 'Combined speed $100$ km/h; $120 \div 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='speed_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two towns $120$ km apart. A leaves at $40$ km/h, B opposite at $60$ km/h. Meet after?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Clock loses $3$ min per day. Loss after $10$ days?', 'multiple_choice', '["$30$ min","$3$ min","$13$ min","$300$ min"]'::jsonb, '"$30$ min"'::jsonb, 'hard', '$3 \times 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='units_time'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='time'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Clock loses $3$ min per day. Loss after $10$ days?');

-- ========== LINEAR EQUATIONS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'What Is a Linear Equation?', '{"blocks":[{"type":"heading","content":"Linear Equations"},{"type":"paragraph","content":"A **linear equation** has the variable to power $1$ only, e.g. $2x + 5 = 13$."},{"type":"paragraph","content":"The **solution** is the value of $x$ that makes both sides equal."},{"type":"callout","variant":"key_point","content":"Whatever you do to one side, do to the other."},{"type":"example","title":"Solve $x + 7 = 15$","steps":["Subtract $7$ from both sides: $x = 8$."],"answer":"$x = 8$"},{"type":"callout","variant":"warning","content":"Check your answer by substituting back."},{"type":"question","questionText":"Solve $x - 4 = 9$.","questionType":"multiple_choice","options":["$x = 13$","$x = 5$","$x = 36$","$x = -5$"],"correctAnswer":"$x = 13$","explanation":"Add $4$ to both sides."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'solving_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'What Is a Linear Equation?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Linear Equations — Methods', '{"blocks":[{"type":"heading","content":"Methods for Solving"},{"type":"example","title":"Solve $3x = 21$","steps":["Divide both sides by $3$: $x = 7$."],"answer":"$x = 7$"},{"type":"example","title":"Solve $2x + 5 = 17$","steps":["Subtract $5$: $2x = 12$.","Divide by $2$: $x = 6$."],"answer":"$x = 6$"},{"type":"example","title":"Solve $4x - 3 = 2x + 9$","steps":["Subtract $2x$: $2x - 3 = 9$.","Add $3$: $2x = 12$.","$x = 6$."],"answer":"$x = 6$"},{"type":"callout","variant":"warning","content":"Collect $x$-terms on one side, numbers on the other."},{"type":"question","questionText":"Solve $5x - 2 = 18$.","questionType":"multiple_choice","options":["$x = 4$","$x = 20$","$x = 3.2$","$x = 16$"],"correctAnswer":"$x = 4$","explanation":"$5x = 20$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'solving_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Linear Equations — Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Linear Equations in Exams', '{"blocks":[{"type":"heading","content":"Exam-Style Solving"},{"type":"example","title":"Solve $\\frac{x}{3} + 2 = 7$","steps":["Subtract $2$: $\\frac{x}{3} = 5$.","Multiply by $3$: $x = 15$."],"answer":"$x = 15$"},{"type":"callout","variant":"warning","content":"Clear fractions early by multiplying through."},{"type":"question","questionText":"Solve $3(x - 2) = 12$.","questionType":"multiple_choice","options":["$x = 6$","$x = 4$","$x = 2$","$x = 10$"],"correctAnswer":"$x = 6$","explanation":"$x - 2 = 4$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'solving_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Linear Equations in Exams');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Forming Equations from Words', '{"blocks":[{"type":"heading","content":"Forming Equations"},{"type":"paragraph","content":"Translate a word problem into algebra. Choose a letter for the unknown."},{"type":"paragraph","content":"\"Five more than a number\" $\\rightarrow x + 5$. \"Twice a number\" $\\rightarrow 2x$."},{"type":"callout","variant":"key_point","content":"Read carefully: \"is\" often means $=$."},{"type":"example","title":"Write an equation: a number plus $8$ is $20$","steps":["Let the number be $x$.","$x + 8 = 20$."],"answer":"$x + 8 = 20$"},{"type":"callout","variant":"warning","content":"\"Less than\" reverses order: $5$ less than $x$ is $x - 5$, not $5 - x$."},{"type":"question","questionText":"\"Three times a number equals $15$.\" Which equation?","questionType":"multiple_choice","options":["$3x = 15$","$x + 3 = 15$","$3 + x = 15$","$x - 3 = 15$"],"correctAnswer":"$3x = 15$","explanation":"Three times means multiply."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'forming_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Forming Equations from Words');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Forming Equations — Practice', '{"blocks":[{"type":"heading","content":"More Formation Examples"},{"type":"example","title":"The sum of two consecutive integers is $47$. Form an equation.","steps":["Let first be $n$, second $n+1$.","$n + (n+1) = 47$."],"answer":"$2n + 1 = 47$"},{"type":"example","title":"Kamau has $x$ shillings. Grace has $50$ more. Together KES $350$.","steps":["Grace: $x + 50$.","$x + (x+50) = 350$."],"answer":"$2x + 50 = 350$"},{"type":"callout","variant":"warning","content":"Define the unknown before writing the equation."},{"type":"question","questionText":"Perimeter of rectangle: length $2$ more than width $w$. Perimeter $28$. Equation?","questionType":"multiple_choice","options":["$2(w + w+2) = 28$","$w + 2 = 28$","$2w + 2 = 28$","$w(w+2) = 28$"],"correctAnswer":"$2(w + w+2) = 28$","explanation":"Perimeter uses both dimensions."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'forming_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Forming Equations — Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Forming Equations — Exam', '{"blocks":[{"type":"heading","content":"KCSE Formation Problems"},{"type":"example","title":"A shop sells pens at KES $15$ and books at KES $40$. Ali buys $3$ pens and $2$ books for KES $125$. Form an equation.","steps":["Let $p$ be pens only if needed; here counts fixed.","$3(15) + 2(40) = 125$ — check: $45 + 80 = 125$. ✓"],"answer":"$3(15) + 2(40) = 125$"},{"type":"callout","variant":"warning","content":"Distinguish forming from solving — KCSE may ask for the equation only."},{"type":"question","questionText":"Age: father $40$, son $x$, father is triple son''''s age. Equation?","questionType":"multiple_choice","options":["$40 = 3x$","$40 + x = 3$","$x = 40 - 3$","$3 + x = 40$"],"correctAnswer":"$40 = 3x$","explanation":"Triple means $3x$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'forming_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Forming Equations — Exam');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Word Problems — Linear Equations', '{"blocks":[{"type":"heading","content":"Applications of Linear Equations"},{"type":"paragraph","content":"Real problems become equations, then solve."},{"type":"paragraph","content":"Money, age, consecutive numbers and geometry are common KCSE types."},{"type":"callout","variant":"key_point","content":"Always state what $x$ represents."},{"type":"example","title":"Three consecutive integers sum to $54$. Find them.","steps":["Let integers be $n, n+1, n+2$.","$3n + 3 = 54$, so $n = 17$.","Numbers: $17, 18, 19$."],"answer":"$17, 18, 19$"},{"type":"callout","variant":"warning","content":"Consecutive even integers step by $2$."},{"type":"question","questionText":"Number plus its double is $27$. Find the number.","questionType":"multiple_choice","options":["$9$","$13.5$","$18$","$3$"],"correctAnswer":"$9$","explanation":"$x + 2x = 27$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'applications_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Word Problems — Linear Equations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applied Linear Equations', '{"blocks":[{"type":"heading","content":"Worked Applications"},{"type":"example","title":"Mwangi bought $x$ oranges at KES $8$ each and paid KES $120$. Find $x$.","steps":["$8x = 120$.","$x = 15$."],"answer":"$15$ oranges"},{"type":"example","title":"Rectangle: length $5$ cm more than width. Perimeter $38$ cm. Find width.","steps":["$2(w + w+5) = 38$.","$4w + 10 = 38$, $w = 7$ cm."],"answer":"$7$ cm"},{"type":"callout","variant":"warning","content":"Include units in the final answer."},{"type":"question","questionText":"Share KES $500$ in ratio $2:3$. Smaller share?","questionType":"multiple_choice","options":["KES $200$","KES $300$","KES $250$","KES $100$"],"correctAnswer":"KES $200$","explanation":"Total parts $5$; $\\frac{2}{5} \\times 500$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'applications_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applied Linear Equations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'KCSE Word Problems', '{"blocks":[{"type":"heading","content":"Exam Word Problems"},{"type":"example","title":"Amina is $4$ years older than Beth. In $6$ years their ages sum to $40$. Find Beth''''s age now.","steps":["Beth now $b$; Amina $b+4$.","In $6$ years: $(b+6) + (b+10) = 40$.","$2b = 24$, $b = 12$."],"answer":"Beth is $12$"},{"type":"callout","variant":"warning","content":"\"In $n$ years\" means add $n$ to each present age."},{"type":"question","questionText":"Tank holds $x$ litres. After using $35$ L, $\\frac{1}{4}$ full remains. Equation?","questionType":"multiple_choice","options":["$x - 35 = \\frac{x}{4}$","$x - 35 = 4x$","$35 = \\frac{x}{4}$","$x + 35 = \\frac{x}{4}$"],"correctAnswer":"$x - 35 = \\frac{x}{4}$","explanation":"Remaining is quarter of full."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations' AND st.code = 'applications_linear'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'KCSE Word Problems');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x + 5 = 12$.', 'multiple_choice', '["$x = 7$","$x = 17$","$x = -7$","$x = 60$"]'::jsonb, '"$x = 7$"'::jsonb, 'easy', 'Subtract $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x + 5 = 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2x = 14$.', 'multiple_choice', '["$x = 7$","$x = 28$","$x = 12$","$x = 16$"]'::jsonb, '"$x = 7$"'::jsonb, 'easy', 'Divide by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2x = 14$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x - 9 = 0$.', 'multiple_choice', '["$x = 9$","$x = -9$","$x = 0$","$x = 81$"]'::jsonb, '"$x = 9$"'::jsonb, 'easy', 'Add $9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x - 9 = 0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Translate: $x$ decreased by $3$ equals $10$.', 'multiple_choice', '["$x - 3 = 10$","$3 - x = 10$","$x + 3 = 10$","$3x = 10$"]'::jsonb, '"$x - 3 = 10$"'::jsonb, 'easy', 'Decreased by means subtract.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Translate: $x$ decreased by $3$ equals $10$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sum of a number and $12$ is $30$. Equation?', 'multiple_choice', '["$x + 12 = 30$","$12x = 30$","$x - 12 = 30$","$x = 12 + 30$"]'::jsonb, '"$x + 12 = 30$"'::jsonb, 'easy', 'Sum means add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sum of a number and $12$ is $30$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cost $8x = 64$. Find $x$.', 'multiple_choice', '["$8$","$56$","$512$","$4$"]'::jsonb, '"$8$"'::jsonb, 'easy', '$64 \div 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cost $8x = 64$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Half of $x$ is $15$. Find $x$.', 'multiple_choice', '["$30$","$7.5$","$15$","$45$"]'::jsonb, '"$30$"'::jsonb, 'easy', '$x = 30$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Half of $x$ is $15$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x + 3 = 3x - 5$.', 'multiple_choice', '["$x = 4$","$x = 8$","$x = -4$","$x = 1$"]'::jsonb, '"$x = 4$"'::jsonb, 'medium', '$2x = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x + 3 = 3x - 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $5x + 1 = 3x + 13$.', 'multiple_choice', '["$x = 6$","$x = 12$","$x = 7$","$x = 4$"]'::jsonb, '"$x = 6$"'::jsonb, 'medium', '$2x = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $5x + 1 = 3x + 13$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{2x}{5} = 8$.', 'multiple_choice', '["$x = 20$","$x = 16$","$x = 4$","$x = 40$"]'::jsonb, '"$x = 20$"'::jsonb, 'medium', 'Multiply by $5$, divide by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{2x}{5} = 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perimeter $26$: square side $s$. Equation?', 'multiple_choice', '["$4s = 26$","$s^2 = 26$","$2s = 26$","$s + 4 = 26$"]'::jsonb, '"$4s = 26$"'::jsonb, 'medium', 'Four equal sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perimeter $26$: square side $s$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Consecutive integers sum $35$. Equation?', 'multiple_choice', '["$n + (n+1) = 35$","$2n = 35$","$n + 1 = 35$","$n^2 = 35$"]'::jsonb, '"$n + (n+1) = 35$"'::jsonb, 'medium', 'Two consecutive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Consecutive integers sum $35$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'KES $x$ salary plus KES $2000$ bonus $= 15000$. Find $x$.', 'multiple_choice', '["KES $13000$","KES $17000$","KES $7500$","KES $15000$"]'::jsonb, '"KES $13000$"'::jsonb, 'medium', '$x = 13000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='KES $x$ salary plus KES $2000$ bonus $= 15000$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Father $45$, son $x$, father is $5$ more than twice son. Find $x$.', 'multiple_choice', '["$20$","$25$","$22.5$","$40$"]'::jsonb, '"$20$"'::jsonb, 'medium', '$45 = 2x + 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Father $45$, son $x$, father is $5$ more than twice son. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $3(x + 4) = 2(x - 1) + 20$.', 'multiple_choice', '["$x = 8$","$x = 4$","$x = 0$","$x = 12$"]'::jsonb, '"$x = 8$"'::jsonb, 'hard', 'Expand and collect.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $3(x + 4) = 2(x - 1) + 20$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $\frac{x+1}{2} = 5$.', 'multiple_choice', '["$x = 9$","$x = 4$","$x = 11$","$x = 2.5$"]'::jsonb, '"$x = 9$"'::jsonb, 'hard', '$x + 1 = 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $\frac{x+1}{2} = 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three consecutive even integers sum $54$. Smallest?', 'multiple_choice', '["$16$","$18$","$17$","$14$"]'::jsonb, '"$16$"'::jsonb, 'hard', '$n + (n+2) + (n+4) = 54$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three consecutive even integers sum $54$. Smallest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Shop: $2$ shirts and $3$ ties cost KES $410$. Shirt KES $100$. Tie price?', 'multiple_choice', '["KES $70$","KES $110$","KES $50$","KES $210$"]'::jsonb, '"KES $70$"'::jsonb, 'hard', '$200 + 3t = 410$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Shop: $2$ shirts and $3$ ties cost KES $410$. Shirt KES $100$. Tie price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Width $w$, length $3w$, perimeter $48$. Find $w$.', 'multiple_choice', '["$6$","$8$","$12$","$4$"]'::jsonb, '"$6$"'::jsonb, 'hard', '$2(w + 3w) = 48$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Width $w$, length $3w$, perimeter $48$. Find $w$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Number: add $7$, double result, get $30$. Original number?', 'multiple_choice', '["$8$","$11$","$15$","$23$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$2(x+7) = 30$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Number: add $7$, double result, get $30$. Original number?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $0.5x - 1.5 = 4$.', 'multiple_choice', '["$x = 11$","$x = 5$","$x = 7$","$x = 2.5$"]'::jsonb, '"$x = 11$"'::jsonb, 'hard', '$0.5x = 5.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_linear'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $0.5x - 1.5 = 4$.');

-- ========== COMMERCIAL ARITHMETIC I ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Profit and Loss Basics', '{"blocks":[{"type":"heading","content":"Profit and Loss"},{"type":"paragraph","content":"**Cost price (CP)** is what a trader pays; **selling price (SP)** is what a customer pays."},{"type":"paragraph","content":"**Profit** $=$ SP $-$ CP (when SP $>$ CP). **Loss** $=$ CP $-$ SP (when SP $<$ CP)."},{"type":"callout","variant":"key_point","content":"Profit $\\% = \\frac{\\text{Profit}}{\\text{CP}} \\times 100\\%$."},{"type":"example","title":"Bought maize at KES $80$, sold at KES $100$. Find profit.","steps":["Profit $= 100 - 80 = 20$."],"answer":"KES $20$ profit"},{"type":"callout","variant":"warning","content":"Percentage profit is on CP, not SP."},{"type":"question","questionText":"CP KES $50$, SP KES $65$. Profit?","questionType":"multiple_choice","options":["KES $15$","KES $115$","KES $-15$","KES $32.5$"],"correctAnswer":"KES $15$","explanation":"SP minus CP."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'profit_loss'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Profit and Loss Basics');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Profit and Loss Calculations', '{"blocks":[{"type":"heading","content":"Worked Profit & Loss"},{"type":"example","title":"CP KES $400$, profit $15\\%$. Find SP.","steps":["Profit $= 0.15 \\times 400 = 60$.","SP $= 400 + 60 = 460$."],"answer":"KES $460$"},{"type":"example","title":"SP KES $540$, loss $10\\%$. Find CP.","steps":["SP $= 90\\%$ of CP.","CP $= 540 \\div 0.9 = 600$."],"answer":"KES $600$"},{"type":"callout","variant":"warning","content":"Loss $10\\%$ means SP $= 90\\%$ of CP."},{"type":"question","questionText":"CP KES $200$, sold at $25\\%$ profit. SP?","questionType":"multiple_choice","options":["KES $250$","KES $225$","KES $175$","KES $50$"],"correctAnswer":"KES $250$","explanation":"$200 \\times 1.25$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'profit_loss'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Profit and Loss Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Profit & Loss Exam Problems', '{"blocks":[{"type":"heading","content":"KCSE Profit & Loss"},{"type":"example","title":"A trader buys $20$ bags at KES $1200$ each, sells at KES $1450$ each. Total profit?","steps":["Profit per bag $= 250$.","Total $= 20 \\times 250 = 5000$."],"answer":"KES $5000$"},{"type":"callout","variant":"warning","content":"For many items, find per-item profit first."},{"type":"question","questionText":"Article CP KES $800$, loss $5\\%$. SP?","questionType":"multiple_choice","options":["KES $760$","KES $840$","KES $795$","KES $750$"],"correctAnswer":"KES $760$","explanation":"$800 \\times 0.95$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'profit_loss'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Profit & Loss Exam Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Discount and Commission', '{"blocks":[{"type":"heading","content":"Discount and Commission"},{"type":"paragraph","content":"A **discount** reduces the marked price: SP $=$ MP $-$ discount."},{"type":"paragraph","content":"**Commission** is a percentage of sales paid to an agent."},{"type":"callout","variant":"key_point","content":"Discount can be a fixed amount or a percentage of MP."},{"type":"example","title":"MP KES $2000$, discount $10\\%$. Find SP.","steps":["Discount $= 200$.","SP $= 1800$."],"answer":"KES $1800$"},{"type":"callout","variant":"warning","content":"Commission is calculated on the sale amount, before or after discount as stated."},{"type":"question","questionText":"MP KES $500$, discount KES $50$. SP?","questionType":"multiple_choice","options":["KES $450$","KES $550$","KES $50$","KES $475$"],"correctAnswer":"KES $450$","explanation":"$500 - 50$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'discount_commission'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Discount and Commission');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Discount & Commission Methods', '{"blocks":[{"type":"heading","content":"Worked Examples"},{"type":"example","title":"Agent sells goods worth KES $40\\,000$ at $5\\%$ commission.","steps":["Commission $= 0.05 \\times 40000 = 2000$."],"answer":"KES $2000$"},{"type":"example","title":"MP KES $1200$, successive discounts $10\\%$ then $5\\%$ on new price.","steps":["After $10\\%$: $1080$.","After $5\\%$: $1080 \\times 0.95 = 1026$."],"answer":"KES $1026$"},{"type":"callout","variant":"warning","content":"Successive discounts multiply: not $15\\%$ total."},{"type":"question","questionText":"$8\\%$ commission on KES $2500$ sales?","questionType":"multiple_choice","options":["KES $200$","KES $208$","KES $300$","KES $180$"],"correctAnswer":"KES $200$","explanation":"$0.08 \\times 2500$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'discount_commission'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Discount & Commission Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Discount Exam Applications', '{"blocks":[{"type":"heading","content":"KCSE Discount & Commission"},{"type":"example","title":"Supermarket: jeans MP KES $3500$, $20\\%$ off. Customer pays with KES $4000$. Change?","steps":["SP $= 3500 \\times 0.8 = 2800$.","Change $= 1200$."],"answer":"KES $1200$"},{"type":"callout","variant":"warning","content":"Read whether discount is on MP or SP."},{"type":"question","questionText":"Salesman KES $18\\,000$ sales, $3\\%$ commission. Earnings?","questionType":"multiple_choice","options":["KES $540$","KES $600$","KES $17460$","KES $900$"],"correctAnswer":"KES $540$","explanation":"$0.03 \\times 18000$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'discount_commission'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Discount Exam Applications');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Simple Interest', '{"blocks":[{"type":"heading","content":"Simple Interest"},{"type":"paragraph","content":"**Principal (P)** is the amount borrowed or invested."},{"type":"paragraph","content":"**Simple interest (I)** is paid on the original principal only each period."},{"type":"callout","variant":"key_point","content":"$I = \\frac{PRT}{100}$ where $R$ is annual rate $\\%$ and $T$ is time in years."},{"type":"example","title":"P KES $5000$, $R = 8\\%$, $T = 2$ years. Find $I$.","steps":["$I = \\frac{5000 \\times 8 \\times 2}{100} = 800$."],"answer":"KES $800$"},{"type":"callout","variant":"warning","content":"Time must be in years unless you adjust the formula."},{"type":"question","questionText":"P $1000$, $R=5\\%$, $T=1$ year. Interest?","questionType":"multiple_choice","options":["KES $50$","KES $500$","KES $1050$","KES $5$"],"correctAnswer":"KES $50$","explanation":"$\\frac{1000 \\times 5 \\times 1}{100}$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'simple_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Simple Interest');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Simple Interest Calculations', '{"blocks":[{"type":"heading","content":"Interest Methods"},{"type":"example","title":"Find $T$ if P KES $8000$, $I = 960$, $R = 6\\%$","steps":["$960 = \\frac{8000 \\times 6 \\times T}{100}$.","$T = 2$ years."],"answer":"$2$ years"},{"type":"example","title":"Amount after $3$ years: P KES $2000$, $R=10\\%$","steps":["$I = 600$.","Amount $= 2600$."],"answer":"KES $2600$"},{"type":"callout","variant":"warning","content":"Amount $=$ P $+$ I."},{"type":"question","questionText":"P KES $4000$, $R=12\\%$, $T=\\frac{1}{2}$ year. $I$?","questionType":"multiple_choice","options":["KES $240$","KES $480$","KES $120$","KES $2000$"],"correctAnswer":"KES $240$","explanation":"Half year in formula."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'simple_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Simple Interest Calculations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Simple Interest Exam Problems', '{"blocks":[{"type":"heading","content":"KCSE Interest Problems"},{"type":"example","title":"Student saves KES $1500$ at $4\\%$ p.a. for $2$ years $6$ months. Interest?","steps":["$T = 2.5$ years.","$I = \\frac{1500 \\times 4 \\times 2.5}{100} = 150$."],"answer":"KES $150$"},{"type":"callout","variant":"warning","content":"Convert months to years: $6$ months $= 0.5$ year."},{"type":"question","questionText":"After $1$ year at $10\\%$, amount on KES $5000$?","questionType":"multiple_choice","options":["KES $5500$","KES $500$","KES $6000$","KES $5100$"],"correctAnswer":"KES $5500$","explanation":"$500$ interest added."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i' AND st.code = 'simple_interest'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Simple Interest Exam Problems');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'CP KES $120$, SP KES $150$. Profit?', 'multiple_choice', '["KES $30$","KES $270$","KES $-30$","KES $25$"]'::jsonb, '"KES $30$"'::jsonb, 'easy', 'SP $-$ CP.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='CP KES $120$, SP KES $150$. Profit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'CP KES $90$, SP KES $72$. Loss?', 'multiple_choice', '["KES $18$","KES $162$","KES $-18$","KES $20$"]'::jsonb, '"KES $18$"'::jsonb, 'easy', 'CP $-$ SP.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='CP KES $90$, SP KES $72$. Loss?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'MP KES $1000$, discount $15\%$. SP?', 'multiple_choice', '["KES $850$","KES $1150$","KES $150$","KES $985$"]'::jsonb, '"KES $850$"'::jsonb, 'easy', '$1000 \times 0.85$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='MP KES $1000$, discount $15\%$. SP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Commission $6\%$ on KES $500$. Amount?', 'multiple_choice', '["KES $30$","KES $470$","KES $60$","KES $300$"]'::jsonb, '"KES $30$"'::jsonb, 'easy', '$0.06 \times 500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Commission $6\%$ on KES $500$. Amount?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $2000$, $R=5\%$, $T=2$ yr. $I$?', 'multiple_choice', '["KES $200$","KES $100$","KES $400$","KES $2200$"]'::jsonb, '"KES $200$"'::jsonb, 'easy', 'Formula gives $200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $2000$, $R=5\%$, $T=2$ yr. $I$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $1000$, $R=10\%$, $T=1$ yr. Amount?', 'multiple_choice', '["KES $1100$","KES $100$","KES $1010$","KES $1200$"]'::jsonb, '"KES $1100$"'::jsonb, 'easy', 'Add interest.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $1000$, $R=10\%$, $T=1$ yr. Amount?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'SP KES $200$, CP KES $160$. Profit percentage on CP?', 'multiple_choice', '["$25\\%$","$20\\%$","$40\\%$","$80\\%$"]'::jsonb, '"$25\\%$"'::jsonb, 'easy', 'Profit KES $40$; $40/160 \times 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='SP KES $200$, CP KES $160$. Profit percentage on CP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'CP KES $250$, $20\%$ profit. SP?', 'multiple_choice', '["KES $300$","KES $270$","KES $200$","KES $312.5$"]'::jsonb, '"KES $300$"'::jsonb, 'medium', '$250 \times 1.2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='CP KES $250$, $20\%$ profit. SP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'SP KES $459$, $10\%$ profit. CP?', 'multiple_choice', '["KES $417.27$","KES $413.1$","KES $450$","KES $505$"]'::jsonb, '"KES $417.27$"'::jsonb, 'medium', 'SP $= 1.1 \times$ CP.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='SP KES $459$, $10\%$ profit. CP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'MP KES $2400$, discount KES $360$. SP?', 'multiple_choice', '["KES $2040$","KES $2760$","KES $2160$","KES $2280$"]'::jsonb, '"KES $2040$"'::jsonb, 'medium', 'Subtract fixed discount.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='MP KES $2400$, discount KES $360$. SP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$12\%$ commission on KES $7500$?', 'multiple_choice', '["KES $900$","KES $6600$","KES $8400$","KES $750$"]'::jsonb, '"KES $900$"'::jsonb, 'medium', '$0.12 \times 7500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$12\%$ commission on KES $7500$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $6000$, $R=8\%$, $T=3$ yr. $I$?', 'multiple_choice', '["KES $1440$","KES $480$","KES $720$","KES $7440$"]'::jsonb, '"KES $1440$"'::jsonb, 'medium', 'Full formula.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $6000$, $R=8\%$, $T=3$ yr. $I$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$I = 300$, P $5000$, $R=6\%$. Time in years?', 'multiple_choice', '["$1$","$0.5$","$2$","$1.5$"]'::jsonb, '"$1$"'::jsonb, 'medium', 'Solve for $T$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$I = 300$, P $5000$, $R=6\%$. Time in years?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bought $15$ items at KES $80$, sold at KES $95$ each. Total profit?', 'multiple_choice', '["KES $225$","KES $1425$","KES $15$","KES $1200$"]'::jsonb, '"KES $225$"'::jsonb, 'hard', '$15 \times 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bought $15$ items at KES $80$, sold at KES $95$ each. Total profit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'CP KES $x$, $25\%$ loss, SP KES $600$. Find CP.', 'multiple_choice', '["KES $800$","KES $750$","KES $480$","KES $625$"]'::jsonb, '"KES $800$"'::jsonb, 'hard', 'SP $= 0.75 \times$ CP.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='CP KES $x$, $25\%$ loss, SP KES $600$. Find CP.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'MP KES $5000$, $15\%$ then $10\%$ successive discounts. Final SP?', 'multiple_choice', '["KES $3825$","KES $3750$","KES $4250$","KES $3500$"]'::jsonb, '"KES $3825$"'::jsonb, 'hard', 'Multiply factors $0.85 \times 0.9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='MP KES $5000$, $15\%$ then $10\%$ successive discounts. Final SP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Agent: KES $12000$ sales, $4\%$ commission plus KES $500$ salary. Total pay?', 'multiple_choice', '["KES $980$","KES $480$","KES $12500$","KES $9800$"]'::jsonb, '"KES $980$"'::jsonb, 'hard', '$480 + 500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='discount_commission'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Agent: KES $12000$ sales, $4\%$ commission plus KES $500$ salary. Total pay?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'P KES $2500$, $R=12\%$, $T=8$ months. $I$?', 'multiple_choice', '["KES $200$","KES $300$","KES $240$","KES $150$"]'::jsonb, '"KES $200$"'::jsonb, 'hard', '$T = \frac{2}{3}$ year.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='P KES $2500$, $R=12\%$, $T=8$ months. $I$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Amount KES $4620$ after $2$ yr at $10\%$. Principal?', 'multiple_choice', '["KES $3850$","KES $4200$","KES $3500$","KES $4000$"]'::jsonb, '"KES $3850$"'::jsonb, 'hard', 'Amount $= P(1 + 0.2)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Amount KES $4620$ after $2$ yr at $10\%$. Principal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trader marks $30\%$ above CP, then allows $10\%$ discount on MP. Net profit $\%$ on CP?', 'multiple_choice', '["$17\\%$","$20\\%$","$27\\%$","$23\\%$"]'::jsonb, '"$17\\%$"'::jsonb, 'hard', 'MP $= 1.3$CP; SP $= 1.17$CP.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='profit_loss'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trader marks $30\%$ above CP, then allows $10\%$ discount on MP. Net profit $\%$ on CP?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equal interest: P KES $4000$ at $5\%$ vs P KES $x$ at $8\%$ for $1$ yr. Find $x$.', 'multiple_choice', '["KES $2500$","KES $3200$","KES $2000$","KES $3000$"]'::jsonb, '"KES $2500$"'::jsonb, 'hard', '$200 = 0.08x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simple_interest'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='commercial_arithmetic_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equal interest: P KES $4000$ at $5\%$ vs P KES $x$ at $8\%$ for $1$ yr. Find $x$.');

-- ========== COORDINATES AND GRAPHS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'The Cartesian Plane', '{"blocks":[{"type":"heading","content":"The Cartesian Plane"},{"type":"paragraph","content":"The **Cartesian plane** has horizontal $x$-axis and vertical $y$-axis meeting at the **origin** $(0,0)$."},{"type":"paragraph","content":"A point is written $(x, y)$: $x$ first (across), then $y$ (up)."},{"type":"callout","variant":"key_point","content":"Quadrants: I $(+,+)$, II $(-,+)$, III $(-,-)$, IV $(+,-)$."},{"type":"example","title":"State the quadrant of $(-3, 4)$","steps":["$x$ negative, $y$ positive $\\rightarrow$ Quadrant II."],"answer":"Quadrant II"},{"type":"callout","variant":"warning","content":"Do not swap $x$ and $y$."},{"type":"question","questionText":"Coordinates of the origin?","questionType":"multiple_choice","options":["$(0,0)$","$(1,1)$","$(0,1)$","$(1,0)$"],"correctAnswer":"$(0,0)$","explanation":"Axes cross at zero."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'cartesian_plane'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'The Cartesian Plane');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Working with the Cartesian Plane', '{"blocks":[{"type":"heading","content":"Plane Skills"},{"type":"example","title":"Plot $(2, -3)$","steps":["From origin, $2$ right, $3$ down."],"answer":"Quadrant IV"},{"type":"example","title":"Distance from $(0,0)$ to $(3,4)$ on grid","steps":["Forms $3$-$4$-$5$ triangle.","Distance $= 5$ units."],"answer":"$5$ units"},{"type":"callout","variant":"warning","content":"Negative $y$ means below the $x$-axis."},{"type":"question","questionText":"Point with $x=0$, $y=-5$ lies on which axis?","questionType":"multiple_choice","options":["$y$-axis","$x$-axis","Origin only","Neither"],"correctAnswer":"$y$-axis","explanation":"$x=0$ on $y$-axis."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'cartesian_plane'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Working with the Cartesian Plane');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cartesian Plane — Exam', '{"blocks":[{"type":"heading","content":"KCSE Coordinate Geometry"},{"type":"example","title":"Vertices of square $O(0,0)$, $A(4,0)$, $B(4,4)$, $C(0,4)$. Side length?","steps":["From $(0,0)$ to $(4,0)$: $4$ units."],"answer":"$4$ units"},{"type":"callout","variant":"warning","content":"On axis-aligned squares, side length is the difference in coordinates."},{"type":"question","questionText":"Midpoint of $(2,6)$ and $(8,6)$?","questionType":"multiple_choice","options":["$(5,6)$","$(6,5)$","$(10,12)$","$(3,0)$"],"correctAnswer":"$(5,6)$","explanation":"Average $x$: $(2+8)/2$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'cartesian_plane'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cartesian Plane — Exam');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Plotting Points', '{"blocks":[{"type":"heading","content":"Plotting Points"},{"type":"paragraph","content":"To plot $(a,b)$: start at origin, move $a$ along $x$, then $b$ parallel to $y$."},{"type":"paragraph","content":"Use sharp pencil marks and label points."},{"type":"callout","variant":"key_point","content":"Scale on axes must be equal for true shape unless told otherwise."},{"type":"example","title":"Plot $(-2, 3)$ and $(1, -1)$","steps":["$(-2,3)$: left $2$, up $3$.","$(1,-1)$: right $1$, down $1$."],"answer":"Quadrants II and IV"},{"type":"callout","variant":"warning","content":"Check the sign of each coordinate before moving."},{"type":"question","questionText":"Which point is $3$ units right and $2$ up from origin?","questionType":"multiple_choice","options":["$(3,2)$","$(2,3)$","$(-3,2)$","$(3,-2)$"],"correctAnswer":"$(3,2)$","explanation":"$x$ first."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'plotting_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Plotting Points');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Plotting and Reading Graphs', '{"blocks":[{"type":"heading","content":"Plotting Methods"},{"type":"example","title":"Table for $y = x + 2$: plot when $x = -1, 0, 1$","steps":["Points: $(-1,1)$, $(0,2)$, $(1,3)$.","Join with straight line."],"answer":"Straight line"},{"type":"example","title":"Read $y$ when $x = 2$ from graph of $y = 2x$","steps":["Substitute: $y = 4$.","Graph should pass through $(2,4)$."],"answer":"$y = 4$"},{"type":"callout","variant":"warning","content":"Plot at least three points for a straight-line graph."},{"type":"question","questionText":"For $y = 5 - x$, find $y$ when $x = 5$.","questionType":"multiple_choice","options":["$0$","$10$","$5$","$-5$"],"correctAnswer":"$0$","explanation":"$5 - 5 = 0$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'plotting_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Plotting and Reading Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Plotting — Exam Practice', '{"blocks":[{"type":"heading","content":"Exam Plotting"},{"type":"example","title":"Draw $y = 3$ (horizontal line). Describe it.","steps":["All points have $y = 3$.","Parallel to $x$-axis through $(0,3)$."],"answer":"Horizontal line"},{"type":"callout","variant":"warning","content":"$y = k$ is horizontal; $x = k$ is vertical."},{"type":"question","questionText":"Equation of vertical line through $(4,0)$?","questionType":"multiple_choice","options":["$x = 4$","$y = 4$","$y = 0$","$x = 0$"],"correctAnswer":"$x = 4$","explanation":"Constant $x$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'plotting_points'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Plotting — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Linear Graphs', '{"blocks":[{"type":"heading","content":"Linear Graphs"},{"type":"paragraph","content":"A **linear graph** is a straight line. Equation form $y = mx + c$."},{"type":"paragraph","content":"$m$ is **gradient** (slope); $c$ is **$y$-intercept** (where $x=0$)."},{"type":"callout","variant":"key_point","content":"Gradient $= \\frac{\\text{change in } y}{\\text{change in } x}$."},{"type":"example","title":"Find gradient between $(1,2)$ and $(3,8)$","steps":["$m = \\frac{8-2}{3-1} = \\frac{6}{2} = 3$."],"answer":"$m = 3$"},{"type":"callout","variant":"warning","content":"Rise over run — keep point order consistent."},{"type":"question","questionText":"$y$-intercept of $y = 2x + 5$?","questionType":"multiple_choice","options":["$5$","$2$","$7$","$-5$"],"correctAnswer":"$5$","explanation":"Constant term when $x=0$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'linear_graphs'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Linear Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing Linear Graphs', '{"blocks":[{"type":"heading","content":"Graph Drawing"},{"type":"example","title":"Draw $y = -x + 4$","steps":["$y$-intercept $(0,4)$.","Gradient $-1$: down $1$, right $1$ to $(1,3)$."],"answer":"Line through $(0,4)$ and $(1,3)$"},{"type":"example","title":"Find equation: gradient $2$, passes $(0,-1)$","steps":["$c = -1$.","$y = 2x - 1$."],"answer":"$y = 2x - 1$"},{"type":"callout","variant":"warning","content":"Negative gradient: line slopes downward left to right."},{"type":"question","questionText":"Gradient of $y = 5 - 2x$?","questionType":"multiple_choice","options":["$-2$","$2$","$5$","$-5$"],"correctAnswer":"$-2$","explanation":"Coefficient of $x$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'linear_graphs'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing Linear Graphs');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Linear Graphs — Exam', '{"blocks":[{"type":"heading","content":"KCSE Linear Graphs"},{"type":"example","title":"Line passes $(2,5)$ and $(4,11)$. Find equation.","steps":["$m = \\frac{11-5}{4-2} = 3$.","$5 = 3(2) + c \\Rightarrow c = -1$.","$y = 3x - 1$."],"answer":"$y = 3x - 1$"},{"type":"callout","variant":"warning","content":"Find $m$ first, then substitute a point for $c$."},{"type":"question","questionText":"Where does $y = 4x - 8$ cross $x$-axis?","questionType":"multiple_choice","options":["$(2,0)$","$(0,-8)$","$(8,0)$","$(-2,0)$"],"correctAnswer":"$(2,0)$","explanation":"Set $y=0$: $x=2$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs' AND st.code = 'linear_graphs'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Linear Graphs — Exam');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Quadrant of $(5, -2)$?', 'multiple_choice', '["IV","I","II","III"]'::jsonb, '"IV"'::jsonb, 'easy', '$x>0$, $y<0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Quadrant of $(5, -2)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Quadrant of $(-1, -6)$?', 'multiple_choice', '["III","II","IV","I"]'::jsonb, '"III"'::jsonb, 'easy', 'Both negative.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Quadrant of $(-1, -6)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Plot description: $(0, 7)$ lies on?', 'multiple_choice', '["$y$-axis","$x$-axis","Quadrant I","Origin"]'::jsonb, '"$y$-axis"'::jsonb, 'easy', '$x=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Plot description: $(0, 7)$ lies on?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Coordinates $4$ left, $3$ up from origin?', 'multiple_choice', '["$(-4, 3)$","$(4, -3)$","$(-4, -3)$","$(4, 3)$"]'::jsonb, '"$(-4, 3)$"'::jsonb, 'easy', 'Left is negative $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Coordinates $4$ left, $3$ up from origin?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient of line $y = 3x + 1$?', 'multiple_choice', '["$3$","$1$","$4$","$\\frac{1}{3}$"]'::jsonb, '"$3$"'::jsonb, 'easy', 'Coefficient of $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient of line $y = 3x + 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y$-intercept of $y = x - 7$?', 'multiple_choice', '["$-7$","$7$","$1$","$0$"]'::jsonb, '"$-7$"'::jsonb, 'easy', 'Constant term.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y$-intercept of $y = x - 7$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which point lies in Quadrant I?', 'multiple_choice', '["$(2, 3)$","$(-1, 4)$","$(-2, -5)$","$(3, -1)$"]'::jsonb, '"$(2, 3)$"'::jsonb, 'easy', 'Both coordinates positive.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which point lies in Quadrant I?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Signs in Quadrant II?', 'multiple_choice', '["$-, +$","$+, +$","$-, -$","$+, -$"]'::jsonb, '"$-, +$"'::jsonb, 'medium', 'Left and up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Signs in Quadrant II?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'For $y = 2x - 3$, find $y$ when $x = 4$.', 'multiple_choice', '["$5$","$11$","$8$","$1$"]'::jsonb, '"$5$"'::jsonb, 'medium', '$8 - 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='For $y = 2x - 3$, find $y$ when $x = 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point on $y = 6$?', 'multiple_choice', '["$(2,6)$","$(6,2)$","$(0,6)$ only","$(6,6)$ only"]'::jsonb, '"$(2,6)$"'::jsonb, 'medium', 'Any $x$ with $y=6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point on $y = 6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Gradient between $(0,1)$ and $(2,5)$?', 'multiple_choice', '["$2$","$4$","$3$","$\\frac{1}{2}$"]'::jsonb, '"$2$"'::jsonb, 'medium', '$\frac{4}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Gradient between $(0,1)$ and $(2,5)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line through origin with gradient $4$. Equation?', 'multiple_choice', '["$y = 4x$","$y = x + 4$","$y = \\frac{x}{4}$","$y = 4$"]'::jsonb, '"$y = 4x$"'::jsonb, 'medium', '$c=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line through origin with gradient $4$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflect $(3, -2)$ in $x$-axis. New point?', 'multiple_choice', '["$(3, 2)$","$(-3, -2)$","$(-3, 2)$","$(3, -2)$"]'::jsonb, '"$(3, 2)$"'::jsonb, 'medium', 'Negate $y$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflect $(3, -2)$ in $x$-axis. New point?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equation: gradient $-2$, $y$-intercept $5$?', 'multiple_choice', '["$y = -2x + 5$","$y = 2x + 5$","$y = -2x - 5$","$y = 5x - 2$"]'::jsonb, '"$y = -2x + 5$"'::jsonb, 'hard', 'Substitute $m$ and $c$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equation: gradient $-2$, $y$-intercept $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find $x$ when $y = 0$ for $y = 3x - 12$.', 'multiple_choice', '["$4$","$-4$","$12$","$3$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$3x = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find $x$ when $y = 0$ for $y = 3x - 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Table: $y = 5 - 2x$. Missing: $x=3$, $y=?$', 'multiple_choice', '["$-1$","$11$","$1$","$-11$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$5 - 6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Table: $y = 5 - 2x$. Missing: $x=3$, $y=?$');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Distance between $(1,2)$ and $(1,7)$ on grid?', 'multiple_choice', '["$5$","$7$","$6$","$\\sqrt{5}$"]'::jsonb, '"$5$"'::jsonb, 'hard', 'Vertical segment.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Distance between $(1,2)$ and $(1,7)$ on grid?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Lines $y = 2x + 1$ and $y = 2x - 3$ are?', 'multiple_choice', '["Parallel","Perpendicular","Same line","Intersect at origin"]'::jsonb, '"Parallel"'::jsonb, 'hard', 'Same gradient.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Lines $y = 2x + 1$ and $y = 2x - 3$ are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Line through $(1,4)$ and $(3,10)$. Equation?', 'multiple_choice', '["$y = 3x + 1$","$y = 2x + 2$","$y = 6x - 2$","$y = 3x - 1$"]'::jsonb, '"$y = 3x + 1$"'::jsonb, 'hard', '$m=3$, solve $c$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='linear_graphs'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Line through $(1,4)$ and $(3,10)$. Equation?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which point lies on the line $y = 2x$?', 'multiple_choice', '["$(3, 6)$","$(3, 5)$","$(6, 3)$","$(2, 5)$"]'::jsonb, '"$(3, 6)$"'::jsonb, 'hard', 'Check $y = 2x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='plotting_points'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which point lies on the line $y = 2x$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point equidistant from axes in QI with $x+y=10$ and $x=y$?', 'multiple_choice', '["$(5,5)$","$(10,0)$","$(0,10)$","$(7,3)$"]'::jsonb, '"$(5,5)$"'::jsonb, 'hard', 'Solve $2x=10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='cartesian_plane'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='coordinates_graphs'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point equidistant from axes in QI with $x+y=10$ and $x=y$?');

-- ========== ANGLES AND PLANE FIGURES ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Types of Angles', '{"blocks":[{"type":"heading","content":"Types of Angles"},{"type":"paragraph","content":"An **angle** measures rotation between two rays from a vertex."},{"type":"paragraph","content":"**Acute** $< 90^\\circ$, **right** $= 90^\\circ$, **obtuse** $90^\\circ$–$180^\\circ$, **reflex** $> 180^\\circ$."},{"type":"callout","variant":"key_point","content":"Angles on a straight line sum to $180^\\circ$; around a point sum to $360^\\circ$."},{"type":"example","title":"Classify $125^\\circ$","steps":["Between $90^\\circ$ and $180^\\circ$ $\\rightarrow$ obtuse."],"answer":"Obtuse"},{"type":"callout","variant":"warning","content":"Right angle is exactly $90^\\circ$, not \"about\" $90^\\circ$."},{"type":"question","questionText":"An angle of $38^\\circ$ is?","questionType":"multiple_choice","options":["Acute","Obtuse","Reflex","Right"],"correctAnswer":"Acute","explanation":"Less than $90^\\circ$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'types_of_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Types of Angles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Measuring and Classifying Angles', '{"blocks":[{"type":"heading","content":"Angle Skills"},{"type":"example","title":"Find complement of $35^\\circ$","steps":["Complement $= 90^\\circ - 35^\\circ = 55^\\circ$."],"answer":"$55^\\circ$"},{"type":"example","title":"Find supplement of $110^\\circ$","steps":["Supplement $= 180^\\circ - 110^\\circ = 70^\\circ$."],"answer":"$70^\\circ$"},{"type":"callout","variant":"warning","content":"Complementary angles sum to $90^\\circ$; supplementary sum to $180^\\circ$."},{"type":"question","questionText":"Supplement of $72^\\circ$?","questionType":"multiple_choice","options":["$108^\\circ$","$18^\\circ$","$92^\\circ$","$288^\\circ$"],"correctAnswer":"$108^\\circ$","explanation":"$180 - 72$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'types_of_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Measuring and Classifying Angles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angles — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Angle Types"},{"type":"example","title":"Three angles on a straight line are $2x^\\circ$, $3x^\\circ$, $40^\\circ$. Find $x$.","steps":["$5x + 40 = 180$.","$x = 28$."],"answer":"$x = 28$"},{"type":"callout","variant":"warning","content":"Always use the straight-line or point sum rule stated."},{"type":"question","questionText":"Reflex angle for $65^\\circ$ acute angle at a point?","questionType":"multiple_choice","options":["$295^\\circ$","$115^\\circ$","$245^\\circ$","$305^\\circ$"],"correctAnswer":"$295^\\circ$","explanation":"$360 - 65$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'types_of_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angles — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angles on Straight Lines', '{"blocks":[{"type":"heading","content":"Angles on Straight Lines"},{"type":"paragraph","content":"When two lines cross, **vertically opposite** angles are equal."},{"type":"paragraph","content":"**Adjacent** angles on a straight line sum to $180^\\circ$."},{"type":"callout","variant":"key_point","content":"Look for the $X$-shape: opposite angles match."},{"type":"example","title":"Two angles on a line are $(3x+10)^\\circ$ and $(2x+30)^\\circ$. Find $x$.","steps":["$5x + 40 = 180$.","$x = 28$."],"answer":"$x = 28$"},{"type":"callout","variant":"warning","content":"Adjacent angles on a line — not vertically opposite."},{"type":"question","questionText":"Vertically opposite to $47^\\circ$?","questionType":"multiple_choice","options":["$47^\\circ$","$133^\\circ$","$43^\\circ$","$90^\\circ$"],"correctAnswer":"$47^\\circ$","explanation":"Equal angles."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'angles_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angles on Straight Lines');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angle Calculations on Lines', '{"blocks":[{"type":"heading","content":"Line Angle Methods"},{"type":"example","title":"Lines cross: one angle $65^\\circ$. Find all angles.","steps":["Opposite $= 65^\\circ$.","Adjacent $= 180 - 65 = 115^\\circ$."],"answer":"$65^\\circ$ and $115^\\circ$ pairs"},{"type":"example","title":"Find $x$ if angles are $(2x)^\\circ$ and $(x+30)^\\circ$ on a line","steps":["$3x + 30 = 180$.","$x = 50$."],"answer":"$x = 50$"},{"type":"callout","variant":"warning","content":"Set up equation from $180^\\circ$ on a straight line."},{"type":"question","questionText":"Angle adjacent to $120^\\circ$ on a straight line?","questionType":"multiple_choice","options":["$60^\\circ$","$120^\\circ$","$240^\\circ$","$30^\\circ$"],"correctAnswer":"$60^\\circ$","explanation":"$180 - 120$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'angles_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angle Calculations on Lines');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Line Angles — Exam', '{"blocks":[{"type":"heading","content":"KCSE Line Angle Problems"},{"type":"example","title":"Four angles at a point: $3x$, $2x$, $x$, $90^\\circ$. Find smallest angle.","steps":["$6x + 90 = 360$.","$x = 45$; smallest $= 45^\\circ$."],"answer":"$45^\\circ$"},{"type":"callout","variant":"warning","content":"Angles at a point sum to $360^\\circ$."},{"type":"question","questionText":"Two lines cross. One angle is $38^\\circ$. Obtuse angle?","questionType":"multiple_choice","options":["$142^\\circ$","$52^\\circ$","$148^\\circ$","$128^\\circ$"],"correctAnswer":"$142^\\circ$","explanation":"Supplement of $38^\\circ$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'angles_straight_lines'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Line Angles — Exam');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Polygons and Angle Sums', '{"blocks":[{"type":"heading","content":"Polygons"},{"type":"paragraph","content":"A **polygon** is a closed plane figure with straight sides."},{"type":"paragraph","content":"Triangle: $3$ sides, sum of interior angles $= 180^\\circ$. Quadrilateral: $360^\\circ$."},{"type":"callout","variant":"key_point","content":"Sum of interior angles of $n$-gon: $(n-2) \\times 180^\\circ$."},{"type":"example","title":"Find missing angle in triangle $50^\\circ$, $60^\\circ$, $x^\\circ$","steps":["$50 + 60 + x = 180$.","$x = 70^\\circ$."],"answer":"$70^\\circ$"},{"type":"callout","variant":"warning","content":"Exterior angles of any convex polygon sum to $360^\\circ$."},{"type":"question","questionText":"Sum of interior angles of a pentagon?","questionType":"multiple_choice","options":["$540^\\circ$","$360^\\circ$","$720^\\circ$","$450^\\circ$"],"correctAnswer":"$540^\\circ$","explanation":"$(5-2) \\times 180$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Polygons and Angle Sums');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Polygon Angle Problems', '{"blocks":[{"type":"heading","content":"Polygon Methods"},{"type":"example","title":"Regular hexagon: one interior angle?","steps":["Sum $= (6-2) \\times 180 = 720^\\circ$.","Each angle $= 720 \\div 6 = 120^\\circ$."],"answer":"$120^\\circ$"},{"type":"example","title":"Quadrilateral angles $85^\\circ$, $95^\\circ$, $110^\\circ$, $x^\\circ$. Find $x$.","steps":["$290 + x = 360$.","$x = 70^\\circ$."],"answer":"$70^\\circ$"},{"type":"callout","variant":"warning","content":"In a regular polygon all interior angles are equal."},{"type":"question","questionText":"Each exterior angle of regular pentagon?","questionType":"multiple_choice","options":["$72^\\circ$","$108^\\circ$","$60^\\circ$","$90^\\circ$"],"correctAnswer":"$72^\\circ$","explanation":"$360 \\div 5$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Polygon Angle Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Polygons — Exam Applications', '{"blocks":[{"type":"heading","content":"KCSE Polygon Problems"},{"type":"example","title":"Regular polygon has exterior angle $30^\\circ$. How many sides?","steps":["$n = \\frac{360}{30} = 12$."],"answer":"$12$ sides"},{"type":"callout","variant":"warning","content":"Number of sides $= 360^\\circ \\div$ each exterior angle (regular)."},{"type":"question","questionText":"Isosceles triangle apex $40^\\circ$. Base angle?","questionType":"multiple_choice","options":["$70^\\circ$","$80^\\circ$","$140^\\circ$","$60^\\circ$"],"correctAnswer":"$70^\\circ$","explanation":"Remaining $140^\\circ$ split equally."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures' AND st.code = 'polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Polygons — Exam Applications');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Classify $89^\circ$.', 'multiple_choice', '["Acute","Right","Obtuse","Straight"]'::jsonb, '"Acute"'::jsonb, 'easy', 'Just under $90^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Classify $89^\circ$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A right angle equals?', 'multiple_choice', '["$90^\\circ$","$180^\\circ$","$45^\\circ$","$360^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A right angle equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angles on a straight line sum to?', 'multiple_choice', '["$180^\\circ$","$360^\\circ$","$90^\\circ$","$270^\\circ$"]'::jsonb, '"$180^\\circ$"'::jsonb, 'easy', 'Straight line rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angles on a straight line sum to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vertically opposite angles are?', 'multiple_choice', '["Equal","Supplementary","Complementary","Unequal"]'::jsonb, '"Equal"'::jsonb, 'easy', 'Crossing lines.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vertically opposite angles are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sum of angles in a triangle?', 'multiple_choice', '["$180^\\circ$","$360^\\circ$","$90^\\circ$","$540^\\circ$"]'::jsonb, '"$180^\\circ$"'::jsonb, 'easy', 'Triangle sum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sum of angles in a triangle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Number of sides of a quadrilateral?', 'multiple_choice', '["$4$","$3$","$5$","$6$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Quad means four.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Number of sides of a quadrilateral?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'An angle of $180^\circ$ is called?', 'multiple_choice', '["Straight","Reflex","Obtuse","Acute"]'::jsonb, '"Straight"'::jsonb, 'easy', 'Forms a straight line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='An angle of $180^\circ$ is called?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Complement of $25^\circ$?', 'multiple_choice', '["$65^\\circ$","$155^\\circ$","$75^\\circ$","$115^\\circ$"]'::jsonb, '"$65^\\circ$"'::jsonb, 'medium', '$90 - 25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Complement of $25^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Obtuse angle could be?', 'multiple_choice', '["$110^\\circ$","$45^\\circ$","$90^\\circ$","$30^\\circ$"]'::jsonb, '"$110^\\circ$"'::jsonb, 'medium', 'Between $90$ and $180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Obtuse angle could be?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Adjacent to $75^\circ$ on straight line?', 'multiple_choice', '["$105^\\circ$","$75^\\circ$","$15^\\circ$","$285^\\circ$"]'::jsonb, '"$105^\\circ$"'::jsonb, 'medium', '$180 - 75$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Adjacent to $75^\circ$ on straight line?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find $x$: $(x+20)^\circ$ and $(2x+10)^\circ$ on a line.', 'multiple_choice', '["$50$","$40$","$60$","$70$"]'::jsonb, '"$50$"'::jsonb, 'medium', '$3x+30=180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find $x$: $(x+20)^\circ$ and $(2x+10)^\circ$ on a line.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Missing angle: triangle $45^\circ$, $55^\circ$, $x^\circ$.', 'multiple_choice', '["$80^\\circ$","$90^\\circ$","$100^\\circ$","$70^\\circ$"]'::jsonb, '"$80^\\circ$"'::jsonb, 'medium', '$180 - 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Missing angle: triangle $45^\circ$, $55^\circ$, $x^\circ$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Interior angle sum of octagon?', 'multiple_choice', '["$1080^\\circ$","$720^\\circ$","$900^\\circ$","$1260^\\circ$"]'::jsonb, '"$1080^\\circ$"'::jsonb, 'medium', '$(8-2) \times 180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Interior angle sum of octagon?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reflex angle for $110^\circ$?', 'multiple_choice', '["$250^\\circ$","$70^\\circ$","$290^\\circ$","$190^\\circ$"]'::jsonb, '"$250^\\circ$"'::jsonb, 'hard', '$360 - 110$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reflex angle for $110^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Crossing lines: one angle $3x^\circ$, opposite $5x-40^\circ$. Find $x$.', 'multiple_choice', '["$20$","$10$","$40$","$25$"]'::jsonb, '"$20$"'::jsonb, 'hard', '$3x = 5x - 40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Crossing lines: one angle $3x^\circ$, opposite $5x-40^\circ$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Four angles at point: $2x$, $3x$, $4x$, $60^\circ$. Find $x$.', 'multiple_choice', '["$40$","$30$","$50$","$45$"]'::jsonb, '"$40$"'::jsonb, 'hard', '$9x + 60 = 360$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Four angles at point: $2x$, $3x$, $4x$, $60^\circ$. Find $x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular polygon interior angle $150^\circ$. Sides?', 'multiple_choice', '["$12$","$10$","$8$","$15$"]'::jsonb, '"$12$"'::jsonb, 'hard', 'Exterior $30^\circ$; $360/30$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular polygon interior angle $150^\circ$. Sides?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pentagon angles four given sum $400^\circ$. Fifth angle?', 'multiple_choice', '["$140^\\circ$","$160^\\circ$","$120^\\circ$","$80^\\circ$"]'::jsonb, '"$140^\\circ$"'::jsonb, 'hard', 'Pentagon sum $540^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pentagon angles four given sum $400^\circ$. Fifth angle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle is twice its complement. Find the angle.', 'multiple_choice', '["$60^\\circ$","$30^\\circ$","$45^\\circ$","$120^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'hard', '$x = 2(90-x)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='types_of_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle is twice its complement. Find the angle.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Exterior angles of regular hexagon each?', 'multiple_choice', '["$60^\\circ$","$120^\\circ$","$72^\\circ$","$90^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'hard', '$360/6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Exterior angles of regular hexagon each?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallel lines cut by transversal: co-interior angles $2x$ and $3x+20$. Find $x$.', 'multiple_choice', '["$32$","$40$","$36$","$28$"]'::jsonb, '"$32$"'::jsonb, 'hard', 'Co-interior sum $180^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='angles_straight_lines'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='angles_plane_figures'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallel lines cut by transversal: co-interior angles $2x$ and $3x+20$. Find $x$.');
