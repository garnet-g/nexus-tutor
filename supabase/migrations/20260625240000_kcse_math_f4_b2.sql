-- KCSE Form 4 Mathematics — Wave 4 Batch 2
-- Topics: longitudes_latitudes, linear_programming, differentiation, area_approximation, integration
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md
-- ========== LONGITUDES AND LATITUDES ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Position on the Earth — Concepts', '{"blocks":[{"type":"heading","content":"Latitude and Longitude"},{"type":"paragraph","content":"The Earth is a sphere. **Latitude** measures north–south position (parallel to the equator). **Longitude** measures east–west position (meridians through the poles)."},{"type":"math_block","latex":"\\text{Latitude } \\phi: 0^\\circ \\text{ at equator to } 90^\\circ\\text{ N/S}","caption":"Latitude range"},{"type":"math_block","latex":"\\text{Longitude } \\lambda: 0^\\circ \\text{ at Greenwich to } 180^\\circ\\text{ E/W}","caption":"Longitude range"},{"type":"callout","variant":"key_point","content":"The **prime meridian** ($0^\\circ$ longitude) passes through Greenwich, London. The **equator** is $0^\\circ$ latitude."},{"type":"question","questionText":"Lines of latitude are?","questionType":"multiple_choice","options":["Parallel to the equator","Through the poles","Only in the Northern Hemisphere","Always vertical"],"correctAnswer":"Parallel to the equator","explanation":"Latitude circles are parallel."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'position_earth'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Position on the Earth — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Coordinates on the Globe', '{"blocks":[{"type":"heading","content":"Latitude–Longitude Notation"},{"type":"table","rows":[["Nairobi","$1^\\circ\\text{S},\\; 37^\\circ\\text{E}$"],["London","$51^\\circ\\text{N},\\; 0^\\circ$"],["Cape Town","$34^\\circ\\text{S},\\; 18^\\circ\\text{E}$"]],"caption":"Sample positions"},{"type":"example","title":"Write the position of a town at $3^\\circ$ south, $40^\\circ$ east.","steps":["South means S; east means E.","Format: latitude first, then longitude."],"answer":"$3^\\circ\\text{S},\\; 40^\\circ\\text{E}$"},{"type":"callout","variant":"warning","content":"Always state **N/S** for latitude and **E/W** for longitude — omitting direction loses marks."},{"type":"question","questionText":"Which is further north: $10^\\circ\\text{N}$ or $5^\\circ\\text{S}$?","questionType":"multiple_choice","options":["$10^\\circ\\text{N}$","$5^\\circ\\text{S}$","Equal","Cannot tell"],"correctAnswer":"$10^\\circ\\text{N}$","explanation":"Positive latitude is north of the equator."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'position_earth'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Coordinates on the Globe');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Position on the Earth — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Position on the Earth"},{"type":"example","title":"A ship is at $15^\\circ\\text{N},\\; 45^\\circ\\text{W}$. In which hemisphere(s)?","steps":["Latitude $15^\\circ\\text{N}$ → Northern Hemisphere.","Longitude $45^\\circ\\text{W}$ → Western Hemisphere."],"answer":"Northern and Western Hemispheres"},{"type":"callout","variant":"warning","content":"KCSE may ask for hemisphere(s) or to compare positions — always justify using N/S and E/W."},{"type":"question","questionText":"Equator has latitude?","questionType":"multiple_choice","options":["$0^\\circ$","$90^\\circ$","$180^\\circ$","$360^\\circ$"],"correctAnswer":"$0^\\circ$","explanation":"Definition of the equator."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'position_earth'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Position on the Earth — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Lines of longitude pass through?', 'multiple_choice', '["The poles","Only the equator","Greenwich only","The tropics"]'::jsonb, '"The poles"'::jsonb, 'easy', 'Meridians are great circles through poles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Lines of longitude pass through?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Prime meridian longitude is?', 'multiple_choice', '["$0^\\circ$","$90^\\circ$","$180^\\circ$","$360^\\circ$"]'::jsonb, '"$0^\\circ$"'::jsonb, 'easy', 'Greenwich reference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Prime meridian longitude is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Maximum latitude magnitude is?', 'multiple_choice', '["$90^\\circ$","$180^\\circ$","$360^\\circ$","$45^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'easy', 'Poles at $\pm 90^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Maximum latitude magnitude is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Town at $2^\circ\text{N},\; 38^\circ\text{E}$ lies in which hemisphere(s)?', 'multiple_choice', '["Northern and Eastern","Southern and Western","Northern only","Eastern only"]'::jsonb, '"Northern and Eastern"'::jsonb, 'medium', 'N and E directions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Town at $2^\circ\text{N},\; 38^\circ\text{E}$ lies in which hemisphere(s)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is further east: $10^\circ\text{E}$ or $20^\circ\text{W}$?', 'multiple_choice', '["$10^\\circ\\text{E}$","$20^\\circ\\text{W}$","Equal","Cannot compare"]'::jsonb, '"$10^\\circ\\text{E}$"'::jsonb, 'medium', 'East longitudes are east of Greenwich.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is further east: $10^\circ\text{E}$ or $20^\circ\text{W}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point $A(25^\circ\text{S},\; 30^\circ\text{E})$ and $B(10^\circ\text{S},\; 30^\circ\text{E})$. Which is further north?', 'multiple_choice', '["$B$","$A$","Same latitude","Same longitude only"]'::jsonb, '"$B$"'::jsonb, 'hard', '$10^\circ\text{S}$ is closer to equator than $25^\circ\text{S}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point $A(25^\circ\text{S},\; 30^\circ\text{E})$ and $B(10^\circ\text{S},\; 30^\circ\text{E})$. Which is further north?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'International Date Line is near longitude?', 'multiple_choice', '["$180^\\circ$","$0^\\circ$","$90^\\circ$","$360^\\circ$"]'::jsonb, '"$180^\\circ$"'::jsonb, 'hard', 'Opposite Greenwich.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='position_earth'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='International Date Line is near longitude?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Great and Small Circles — Concepts', '{"blocks":[{"type":"heading","content":"Circles on a Sphere"},{"type":"paragraph","content":"A **great circle** divides the sphere into two equal halves. Its centre is the centre of the Earth. The equator and all meridians are great circles."},{"type":"paragraph","content":"A **small circle** (e.g. a line of latitude other than the equator) has a smaller radius than the Earth."},{"type":"math_block","latex":"d = R \\theta","caption":"Arc length along a great circle; $\\theta$ in radians, $R$ Earth radius"},{"type":"callout","variant":"key_point","content":"Shortest surface distance between two points on a sphere lies along a **great circle** arc."},{"type":"question","questionText":"The equator is a?","questionType":"multiple_choice","options":["Great circle","Small circle","Straight line on a map","Rhumb line only"],"correctAnswer":"Great circle","explanation":"Centre at Earth''s centre."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'distances_great_circles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Great and Small Circles — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Nautical Miles and Distance', '{"blocks":[{"type":"heading","content":"Nautical Mile"},{"type":"math_block","latex":"1\\text{ nautical mile} = 1\\text{ minute of arc along a meridian}","caption":"KCSE definition"},{"type":"paragraph","content":"Along a meridian, $1^\\circ = 60$ nautical miles. This links angle to distance on the Earth''s surface."},{"type":"example","title":"Two ports differ by $4^\\circ$ of latitude on the same meridian. Distance?","steps":["$1^\\circ = 60$ nautical miles.","$4 \\times 60 = 240$ nautical miles."],"answer":"$240$ nautical miles"},{"type":"callout","variant":"warning","content":"Use latitude difference for north–south distance along a meridian. East–west distance at latitude $\\phi$ uses $\\cos\\phi$."},{"type":"question","questionText":"$1^\\circ$ of latitude along a meridian equals?","questionType":"multiple_choice","options":["$60$ nautical miles","$1$ nautical mile","$90$ nautical miles","$360$ nautical miles"],"correctAnswer":"$60$ nautical miles","explanation":"Standard conversion."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'distances_great_circles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Nautical Miles and Distance');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Great Circles — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Distances on the Earth"},{"type":"example","title":"Ships at $20^\\circ\\text{N}$ and $35^\\circ\\text{N}$ on the same meridian. Distance apart?","steps":["Latitude difference $= 15^\\circ$.","Distance $= 15 \\times 60 = 900$ nautical miles."],"answer":"$900$ nautical miles"},{"type":"math_block","latex":"\\text{Distance} = (\\Delta\\phi) \\times 60 \\text{ nautical miles}","caption":"Same meridian"},{"type":"question","questionText":"Latitude difference $8^\\circ$. Nautical miles?","questionType":"multiple_choice","options":["$480$","$80$","$60$","$8$"],"correctAnswer":"$480$","explanation":"$8 \\times 60$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'distances_great_circles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Great Circles — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Shortest path on a sphere follows a?', 'multiple_choice', '["Great circle","Small circle","Parallel only","Rhumb line always"]'::jsonb, '"Great circle"'::jsonb, 'easy', 'Geodesic on sphere.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Shortest path on a sphere follows a?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '1 nautical mile equals 1 minute of arc on a?', 'multiple_choice', '["Meridian","Parallel only","Equator only","Tropic"]'::jsonb, '"Meridian"'::jsonb, 'easy', 'Standard definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='1 nautical mile equals 1 minute of arc on a?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Latitude difference $5^\circ$. Distance in nautical miles?', 'multiple_choice', '["$300$","$5$","$60$","$150$"]'::jsonb, '"$300$"'::jsonb, 'medium', '$5 \times 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Latitude difference $5^\circ$. Distance in nautical miles?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Points $12^\circ\text{N}$ and $28^\circ\text{N}$ same meridian. Distance?', 'multiple_choice', '["$960$ nm","$16$ nm","$40$ nm","$480$ nm"]'::jsonb, '"$960$ nm"'::jsonb, 'medium', '$16^\circ \times 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Points $12^\circ\text{N}$ and $28^\circ\text{N}$ same meridian. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$2^\circ$ latitude difference equals how many nautical miles?', 'multiple_choice', '["$120$","$60$","$2$","$30$"]'::jsonb, '"$120$"'::jsonb, 'medium', '$2 \times 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$2^\circ$ latitude difference equals how many nautical miles?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tropic of Cancer is a small circle because?', 'multiple_choice', '["Its plane does not pass through Earth''s centre","It is a meridian","It is the shortest path","It has radius $R$"]'::jsonb, '"Its plane does not pass through Earth''s centre"'::jsonb, 'hard', 'Parallel except equator.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tropic of Cancer is a small circle because?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Along meridian from $40^\circ\text{S}$ to $10^\circ\text{S}$: latitude difference?', 'multiple_choice', '["$30^\\circ$","$50^\\circ$","$40^\\circ$","$10^\\circ$"]'::jsonb, '"$30^\\circ$"'::jsonb, 'hard', 'Both south; subtract.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='distances_great_circles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Along meridian from $40^\circ\text{S}$ to $10^\circ\text{S}$: latitude difference?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Time and Longitude — Concepts', '{"blocks":[{"type":"heading","content":"Time Zones and Longitude"},{"type":"paragraph","content":"Earth rotates $360^\\circ$ in $24$ hours, so **$15^\\circ$ of longitude = 1 hour** of time difference."},{"type":"math_block","latex":"\\text{Time difference (hours)} = \\frac{\\Delta\\lambda}{15^\\circ}","caption":"Longitude difference to hours"},{"type":"callout","variant":"key_point","content":"Places **east** of a reference are **ahead** in time; places **west** are **behind**."},{"type":"question","questionText":"Earth rotates through $15^\\circ$ in?","questionType":"multiple_choice","options":["$1$ hour","$15$ hours","$24$ hours","$30$ minutes"],"correctAnswer":"$1$ hour","explanation":"Standard time zone step."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'time_longitude'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Time and Longitude — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Local Time', '{"blocks":[{"type":"heading","content":"Worked Time Problems"},{"type":"example","title":"Greenwich ($0^\\circ$) time is 12:00. Find local time at $45^\\circ\\text{E}$.","steps":["$\\Delta\\lambda = 45^\\circ$ → $45/15 = 3$ hours ahead.","Local time $= 15:00$."],"answer":"$15:00$"},{"type":"example","title":"Local time at $30^\\circ\\text{W}$ when GMT is 08:00?","steps":["$30/15 = 2$ hours behind.","Local time $= 06:00$."],"answer":"$06:00$"},{"type":"callout","variant":"warning","content":"Convert longitude difference to hours **before** adding or subtracting from reference time."},{"type":"question","questionText":"$60^\\circ\\text{E}$ is how many hours ahead of GMT?","questionType":"multiple_choice","options":["$4$","$3$","$2$","$6$"],"correctAnswer":"$4$","explanation":"$60 \\div 15$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'time_longitude'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Local Time');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Time and Longitude — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Time Zones"},{"type":"example","title":"Nairobi ($37^\\circ\\text{E}$) time is 14:30. GMT?","steps":["$37^\\circ$ is not a multiple of $15^\\circ$ — use $\\approx 2\\frac{1}{3}$ h ahead in exact problems; KCSE often uses neat $15^\\circ$ steps.","If $\\Delta\\lambda = 30^\\circ\\text{E}$: GMT $= 12:30$."],"answer":"Depends on given longitude"},{"type":"callout","variant":"warning","content":"Show: longitude difference $\\div 15 =$ hours; state ahead/behind clearly."},{"type":"question","questionText":"Place at $75^\\circ\\text{W}$: time relative to GMT?","questionType":"multiple_choice","options":["$5$ hours behind","$5$ hours ahead","$75$ hours behind","Same as GMT"],"correctAnswer":"$5$ hours behind","explanation":"West is behind."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes' AND st.code = 'time_longitude'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Time and Longitude — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$15^\circ$ of longitude equals?', 'multiple_choice', '["$1$ hour","$15$ hours","$24$ hours","$30$ minutes"]'::jsonb, '"$1$ hour"'::jsonb, 'easy', 'Earth rotation rate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$15^\circ$ of longitude equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Places east of Greenwich are?', 'multiple_choice', '["Ahead in time","Behind in time","Same time always","One day behind"]'::jsonb, '"Ahead in time"'::jsonb, 'easy', 'Sun rises earlier in the east.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Places east of Greenwich are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'GMT 16:00. Local time at $45^\circ\text{W}$?', 'multiple_choice', '["$13:00$","$19:00$","$14:00$","$12:00$"]'::jsonb, '"$13:00$"'::jsonb, 'medium', '$3$ hours behind.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='GMT 16:00. Local time at $45^\circ\text{W}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Longitude difference $90^\circ$. Time difference?', 'multiple_choice', '["$6$ hours","$4$ hours","$90$ hours","$1$ hour"]'::jsonb, '"$6$ hours"'::jsonb, 'medium', '$90 \div 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Longitude difference $90^\circ$. Time difference?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Town A ($60^\circ\text{E}$) 09:00. Town B ($0^\circ$) time?', 'multiple_choice', '["$05:00$","$13:00$","$09:00$","$03:00$"]'::jsonb, '"$05:00$"'::jsonb, 'hard', 'B is $4$ h behind A.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Town A ($60^\circ\text{E}$) 09:00. Town B ($0^\circ$) time?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two places differ by $120^\circ$ longitude. Maximum time difference?', 'multiple_choice', '["$8$ hours","$12$ hours","$4$ hours","$24$ hours"]'::jsonb, '"$8$ hours"'::jsonb, 'hard', '$120 \div 15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two places differ by $120^\circ$ longitude. Maximum time difference?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'GMT 06:00. Time at $90^\circ\text{E}$?', 'multiple_choice', '["$12:00$","$00:00$","$09:00$","$03:00$"]'::jsonb, '"$12:00$"'::jsonb, 'hard', '$6$ hours ahead.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='time_longitude'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='longitudes_latitudes'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='GMT 06:00. Time at $90^\circ\text{E}$?');