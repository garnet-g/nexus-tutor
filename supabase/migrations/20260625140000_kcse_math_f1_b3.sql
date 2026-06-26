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

