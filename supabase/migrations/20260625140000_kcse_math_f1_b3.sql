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

