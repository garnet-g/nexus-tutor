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
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='GMT 06:00. Time at $90^\circ\text{E}$?');-- ========== LINEAR PROGRAMMING ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Forming Inequalities — Concepts', '{"blocks":[{"type":"heading","content":"Constraints as Inequalities"},{"type":"paragraph","content":"In linear programming, restrictions are written as **linear inequalities** in variables $x$ and $y$, e.g. $2x + 3y \\leq 12$."},{"type":"math_block","latex":"ax + by \\leq c \\quad \\text{or} \\quad ax + by \\geq c","caption":"Linear constraint"},{"type":"callout","variant":"key_point","content":"**Non-negativity**: $x \\geq 0$, $y \\geq 0$ are standard in KCSE problems."},{"type":"question","questionText":"A constraint $x + y \\leq 10$ means?","questionType":"multiple_choice","options":["$x + y$ at most $10$","$x + y$ at least $10$","$x$ equals $10$","$y$ equals $10$"],"correctAnswer":"$x + y$ at most $10$","explanation":"Symbol $\\leq$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'forming_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Forming Inequalities — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Translating Word Problems', '{"blocks":[{"type":"heading","content":"From Words to Inequalities"},{"type":"example","title":"A factory makes chairs ($x$) and tables ($y$). At most 20 chairs: inequality?","steps":["At most $\\Rightarrow \\leq$.","$x \\leq 20$."],"answer":"$x \\leq 20$"},{"type":"example","title":"Each chair needs 2 hours, each table 4 hours. Maximum 40 hours: $2x + 4y \\leq 40$.","steps":["Coefficients from hours per item.","Sum $\\leq$ total available."],"answer":"$2x + 4y \\leq 40$"},{"type":"callout","variant":"warning","content":"Identify **resource limits** (at most) and **minimum requirements** (at least) separately."},{"type":"question","questionText":"At least 5 tables means?","questionType":"multiple_choice","options":["$y \\geq 5$","$y \\leq 5$","$y = 5$","$x \\geq 5$"],"correctAnswer":"$y \\geq 5$","explanation":"At least $\\Rightarrow \\geq$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'forming_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Translating Word Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Forming Inequalities — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Forming Constraints"},{"type":"example","title":"Profit: KES 300 per unit of $x$, KES 500 per unit of $y$. This is the **objective**, not a constraint.","steps":["Constraints limit resources.","Objective $P = 300x + 500y$ to maximise."],"answer":"Objective function"},{"type":"callout","variant":"warning","content":"Do not confuse **constraints** (inequalities) with the **objective function** (expression to optimise)."},{"type":"question","questionText":"Non-negativity constraints are?","questionType":"multiple_choice","options":["$x \\geq 0$, $y \\geq 0$","$x \\leq 0$","$x = y$","$x + y = 0$"],"correctAnswer":"$x \\geq 0$, $y \\geq 0$","explanation":"Standard assumption."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'forming_inequalities'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Forming Inequalities — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Linear programming constraints are usually?', 'multiple_choice', '["Linear inequalities","Quadratic equations","Identities only","Logarithms"]'::jsonb, '"Linear inequalities"'::jsonb, 'easy', 'Linear in two variables.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Linear programming constraints are usually?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x \geq 0$ is called?', 'multiple_choice', '["Non-negativity","Feasible region","Objective","Vertex"]'::jsonb, '"Non-negativity"'::jsonb, 'easy', 'Standard constraint.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x \geq 0$ is called?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At most 15 units of $x$ gives?', 'multiple_choice', '["$x \\leq 15$","$x \\geq 15$","$x = 15$","$y \\leq 15$"]'::jsonb, '"$x \\leq 15$"'::jsonb, 'easy', 'At most $\leq$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At most 15 units of $x$ gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3x + 2y \leq 24$: if $x = 4$, maximum $y$?', 'multiple_choice', '["$6$","$12$","$8$","$4$"]'::jsonb, '"$6$"'::jsonb, 'medium', '$12 + 2y \leq 24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3x + 2y \leq 24$: if $x = 4$, maximum $y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two machines: $x + 2y \leq 10$, $2x + y \leq 12$. Point $(2,3)$ satisfies both?', 'multiple_choice', '["Yes","No, first only","No, second only","No, neither"]'::jsonb, '"Yes"'::jsonb, 'medium', '$2+6=8\leq10$; $4+3=7\leq12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two machines: $x + 2y \leq 10$, $2x + y \leq 12$. Point $(2,3)$ satisfies both?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Minimum 10 items total: $x$ chairs, $y$ tables?', 'multiple_choice', '["$x + y \\geq 10$","$x + y \\leq 10$","$xy \\geq 10$","$x - y \\geq 10$"]'::jsonb, '"$x + y \\geq 10$"'::jsonb, 'hard', 'At least 10 total.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Minimum 10 items total: $x$ chairs, $y$ tables?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$4x + y \leq 20$ and $x \geq 2$. Smallest possible $x$?', 'multiple_choice', '["$2$","$0$","$5$","$20$"]'::jsonb, '"$2$"'::jsonb, 'hard', 'Lower bound from $x \geq 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_inequalities'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$4x + y \leq 20$ and $x \geq 2$. Smallest possible $x$?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Feasible Region — Concepts', '{"blocks":[{"type":"heading","content":"Graphing Linear Inequalities"},{"type":"paragraph","content":"To graph $ax + by \\leq c$: draw the line $ax + by = c$, then shade the side that satisfies the inequality (usually test $(0,0)$ if not on the line)."},{"type":"math_block","latex":"\\text{Feasible region} = \\text{intersection of all constraint half-planes}","caption":"Feasible set"},{"type":"callout","variant":"key_point","content":"The **feasible region** is the set of $(x,y)$ satisfying **all** constraints including $x \\geq 0$, $y \\geq 0$."},{"type":"question","questionText":"Feasible region is where?","questionType":"multiple_choice","options":["All constraints hold","Only one constraint holds","Objective is zero","Outside the axes"],"correctAnswer":"All constraints hold","explanation":"Intersection of half-planes."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'graphical_region_lp'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Feasible Region — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing the Feasible Region', '{"blocks":[{"type":"heading","content":"Worked Graphical Method"},{"type":"example","title":"Constraints: $x + y \\leq 6$, $x \\geq 0$, $y \\geq 0$. Corner points?","steps":["Line $x+y=6$ meets axes at $(6,0)$ and $(0,6)$.","Origin $(0,0)$ also feasible.","Vertices: $(0,0)$, $(6,0)$, $(0,6)$."],"answer":"$(0,0)$, $(6,0)$, $(0,6)$"},{"type":"callout","variant":"warning","content":"Mark **corner points** (vertices) of the feasible polygon — optima occur at vertices in KCSE."},{"type":"question","questionText":"$x \\geq 0$, $y \\geq 0$ restricts to which quadrant?","questionType":"multiple_choice","options":["First quadrant","Second","Third","Fourth"],"correctAnswer":"First quadrant","explanation":"Non-negative axes."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'graphical_region_lp'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing the Feasible Region');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Feasible Region — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Graphical LP"},{"type":"example","title":"$2x + y \\leq 8$, $x + y \\leq 5$, $x,y \\geq 0$. Is $(1,2)$ feasible?","steps":["$2(1)+2=4 \\leq 8$; $1+2=3 \\leq 5$; non-negativity OK."],"answer":"Yes, feasible"},{"type":"math_block","latex":"\\text{Vertices found by solving pairs of boundary lines}","caption":"Corner-point method"},{"type":"question","questionText":"Optimal point in KCSE graphical LP is usually at a?","questionType":"multiple_choice","options":["Vertex of feasible region","Midpoint of a side only","Origin always","Random interior point"],"correctAnswer":"Vertex of feasible region","explanation":"Corner-point theorem."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'graphical_region_lp'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Feasible Region — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Feasible region satisfies?', 'multiple_choice', '["All constraints","One constraint only","Objective function","No constraints"]'::jsonb, '"All constraints"'::jsonb, 'easy', 'Intersection of half-planes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Feasible region satisfies?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'For $x \geq 0$, shade which side of $x = 0$?', 'multiple_choice', '["Right of $y$-axis","Left of $y$-axis","Above $x$-axis","Below"]'::jsonb, '"Right of $y$-axis"'::jsonb, 'easy', 'Positive $x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='For $x \geq 0$, shade which side of $x = 0$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x + y = 6$ meets $y$-axis at?', 'multiple_choice', '["$(0,6)$","$(6,0)$","$(3,3)$","$(0,0)$"]'::jsonb, '"$(0,6)$"'::jsonb, 'medium', 'Set $x=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x + y = 6$ meets $y$-axis at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(2,1)$ satisfies $2x + 3y \leq 9$?', 'multiple_choice', '["Yes","No","On boundary only","Undefined"]'::jsonb, '"Yes"'::jsonb, 'medium', '$4+3=7\leq9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(2,1)$ satisfies $2x + 3y \leq 9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x + 2y \leq 8$ and $x = 2$. Maximum $y$?', 'multiple_choice', '["$3$","$4$","$2$","$6$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$2+2y\leq8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x + 2y \leq 8$ and $x = 2$. Maximum $y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$x+y\leq4$, $x\geq1$, $y\geq1$. Is $(1,1)$ feasible?', 'multiple_choice', '["Yes","No","Only if $x=0$","Only on boundary"]'::jsonb, '"Yes"'::jsonb, 'hard', '$2\leq4$; bounds met.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$x+y\leq4$, $x\geq1$, $y\geq1$. Is $(1,1)$ feasible?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Three constraints in first quadrant: feasible region shape?', 'multiple_choice', '["Convex polygon","Circle","Hyperbola","Always unbounded"]'::jsonb, '"Convex polygon"'::jsonb, 'hard', 'Intersection of half-planes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='graphical_region_lp'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Three constraints in first quadrant: feasible region shape?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Optimisation — Concepts', '{"blocks":[{"type":"heading","content":"Objective Function"},{"type":"paragraph","content":"The **objective function** $P = ax + by$ (or $C$ for cost) is the quantity to **maximise** or **minimise** subject to constraints."},{"type":"math_block","latex":"P = c_1 x + c_2 y","caption":"Linear objective"},{"type":"callout","variant":"key_point","content":"Evaluate $P$ at **each vertex** of the feasible region; the best value is the optimum."},{"type":"question","questionText":"To maximise profit $P = 200x + 300y$, evaluate $P$ at?","questionType":"multiple_choice","options":["Vertices of feasible region","Origin only","Midpoints only","Any point"],"correctAnswer":"Vertices of feasible region","explanation":"Corner-point method."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'optimisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Optimisation — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding Maximum and Minimum', '{"blocks":[{"type":"heading","content":"Corner-Point Method"},{"type":"example","title":"$P = 3x + 2y$. Vertices $(0,0)$, $(4,0)$, $(0,5)$, $(2,3)$. Maximum?","steps":["$P(0,0)=0$; $P(4,0)=12$; $P(0,5)=10$; $P(2,3)=12$.","Maximum $P = 12$."],"answer":"$12$"},{"type":"callout","variant":"warning","content":"If two vertices give the same optimum, every point on that edge is optimal."},{"type":"question","questionText":"Minimising cost: pick vertex with?","questionType":"multiple_choice","options":["Smallest $P$","Largest $P$","Largest $x$","Smallest $y$ only"],"correctAnswer":"Smallest $P$","explanation":"Minimum objective value."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'optimisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding Maximum and Minimum');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Optimisation — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Linear Programming"},{"type":"example","title":"Maximise $P = 5x + 4y$ subject to $x + y \\leq 8$, $2x + y \\leq 10$, $x,y \\geq 0$. At $(2,6)$: $P = 34$. Check other vertices for maximum.","steps":["Systematic vertex check required in exam."],"answer":"Compare all vertices"},{"type":"callout","variant":"warning","content":"State the objective, list vertices with working, then conclude max/min clearly."},{"type":"question","questionText":"Objective $P = 100x + 50y$. Slope of profit line increases if?","questionType":"multiple_choice","options":["$x$ coefficient increases","$y$ coefficient decreases only","Constraints change only","Feasible region empty"],"correctAnswer":"$x$ coefficient increases","explanation":"Steeper in $x$-direction."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming' AND st.code = 'optimisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Optimisation — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Objective function is optimised at?', 'multiple_choice', '["Vertices of feasible region","Centre of region always","Outside region","Only at origin"]'::jsonb, '"Vertices of feasible region"'::jsonb, 'easy', 'Corner-point theorem.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Objective function is optimised at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Maximise means find?', 'multiple_choice', '["Largest value of $P$","Smallest value of $P$","Zero","$x$ only"]'::jsonb, '"Largest value of $P$"'::jsonb, 'easy', 'Definition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Maximise means find?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Vertices $(0,0)$, $(5,0)$, $(0,4)$. Max $P=3x+4y$?', 'multiple_choice', '["$16$","$15$","$0$","$12$"]'::jsonb, '"$16$"'::jsonb, 'medium', '$P(0,4)=16$ is largest.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Vertices $(0,0)$, $(5,0)$, $(0,4)$. Max $P=3x+4y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Min $C = 5x + 2y$ at $(0,0)$, $(6,0)$, $(0,3)$?', 'multiple_choice', '["$0$","$30$","$6$","$12$"]'::jsonb, '"$0$"'::jsonb, 'medium', 'Origin gives minimum.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Min $C = 5x + 2y$ at $(0,0)$, $(6,0)$, $(0,3)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$P=4x+6y$. $(2,2)$ and $(0,5)$ both give $P=30$. Conclusion?', 'multiple_choice', '["Multiple optimal points on edge","No solution","Error in graph","$P$ undefined"]'::jsonb, '"Multiple optimal points on edge"'::jsonb, 'hard', 'Equal objective on segment.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$P=4x+6y$. $(2,2)$ and $(0,5)$ both give $P=30$. Conclusion?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Feasible region empty. LP problem has?', 'multiple_choice', '["No feasible solution","Infinite optimum","Optimum at origin","Unique vertex"]'::jsonb, '"No feasible solution"'::jsonb, 'hard', 'Conflicting constraints.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Feasible region empty. LP problem has?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Max $P=2x+y$ at $(0,0)$, $(4,0)$, $(0,6)$. Maximum?', 'multiple_choice', '["$6$","$8$","$4$","$0$"]'::jsonb, '"$6$"'::jsonb, 'hard', '$P(0,6)=6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='optimisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='linear_programming'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Max $P=2x+y$ at $(0,0)$, $(4,0)$, $(0,6)$. Maximum?');-- ========== DIFFERENTIATION ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Gradient Function — Concepts', '{"blocks":[{"type":"heading","content":"Rate of Change"},{"type":"paragraph","content":"For $y = f(x)$, the **gradient function** (derivative) $f''(x)$ or $\\frac{dy}{dx}$ measures the rate of change of $y$ with respect to $x$."},{"type":"math_block","latex":"\\frac{dy}{dx} = \\lim_{\\delta x \\to 0} \\frac{\\delta y}{\\delta x}","caption":"Definition of derivative"},{"type":"callout","variant":"key_point","content":"At a point on the curve, $\\frac{dy}{dx}$ equals the **gradient of the tangent** at that point."},{"type":"question","questionText":"$\\frac{dy}{dx}$ represents?","questionType":"multiple_choice","options":["Gradient of tangent","Area under curve","Y-intercept only","Curvature only"],"correctAnswer":"Gradient of tangent","explanation":"Geometric meaning."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'gradient_function'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Gradient Function — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding the Gradient Function', '{"blocks":[{"type":"heading","content":"Power Rule"},{"type":"math_block","latex":"\\frac{d}{dx}(x^n) = nx^{n-1}","caption":"Power rule for differentiation"},{"type":"example","title":"If $y = x^3$, find $\\frac{dy}{dx}$.","steps":["$n = 3$.","$\\frac{dy}{dx} = 3x^2$."],"answer":"$3x^2$"},{"type":"callout","variant":"warning","content":"Differentiate term by term for sums; constants differentiate to zero."},{"type":"question","questionText":"$\\frac{d}{dx}(x^4)$ equals?","questionType":"multiple_choice","options":["$4x^3$","$x^4$","$4x$","$x^3$"],"correctAnswer":"$4x^3$","explanation":"Power rule."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'gradient_function'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding the Gradient Function');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Gradient Function — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Gradient Function"},{"type":"example","title":"$y = 5x^2 - 3x + 2$. Find $\\frac{dy}{dx}$.","steps":["$\\frac{dy}{dx} = 10x - 3$."],"answer":"$10x - 3$"},{"type":"math_block","latex":"\\frac{d}{dx}(ax^n) = nax^{n-1}","caption":"Constant multiple rule"},{"type":"question","questionText":"Gradient of $y = x^2$ at $x = 3$?","questionType":"multiple_choice","options":["$6$","$9$","$3$","$2$"],"correctAnswer":"$6$","explanation":"$2x$ at $x=3$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'gradient_function'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Gradient Function — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{dy}{dx}$ is also written as?', 'multiple_choice', '["$f''(x)$","$f(x)$","$\\int y\\,dx$","$y^2$"]'::jsonb, '"$f''(x)$"'::jsonb, 'easy', 'Derivative notation.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{dy}{dx}$ is also written as?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{d}{dx}(x^2)$ equals?', 'multiple_choice', '["$2x$","$x$","$x^2$","$2$"]'::jsonb, '"$2x$"'::jsonb, 'easy', 'Power rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{d}{dx}(x^2)$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Derivative of a constant is?', 'multiple_choice', '["$0$","$1$","The constant","Undefined"]'::jsonb, '"$0$"'::jsonb, 'easy', 'No change.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Derivative of a constant is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 3x^3$. $\frac{dy}{dx}$?', 'multiple_choice', '["$9x^2$","$3x^2$","$9x$","$x^3$"]'::jsonb, '"$9x^2$"'::jsonb, 'medium', '$3 \times 3x^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 3x^3$. $\frac{dy}{dx}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^2 + 4x$. Gradient at $x = 1$?', 'multiple_choice', '["$6$","$5$","$4$","$2$"]'::jsonb, '"$6$"'::jsonb, 'medium', '$2x+4$ at $x=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^2 + 4x$. Gradient at $x = 1$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 2x^2 - 5$. $\frac{dy}{dx}$ at $x = -2$?', 'multiple_choice', '["$-8$","$8$","$-4$","$3$"]'::jsonb, '"$-8$"'::jsonb, 'hard', '$4x$ at $x=-2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 2x^2 - 5$. $\frac{dy}{dx}$ at $x = -2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tangent gradient zero when $\frac{dy}{dx}$ equals?', 'multiple_choice', '["$0$","$1$","Undefined","Always at origin"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Stationary point condition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gradient_function'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tangent gradient zero when $\frac{dy}{dx}$ equals?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Derivatives — Concepts', '{"blocks":[{"type":"heading","content":"Rules of Differentiation"},{"type":"paragraph","content":"KCSE Form 4 uses the **power rule**, constant multiples, and sums. For $y = ax^n$, $\\frac{dy}{dx} = nax^{n-1}$."},{"type":"table","rows":[["$y = x^n$","$\\frac{dy}{dx} = nx^{n-1}$"],["$y = c$ (constant)","$\\frac{dy}{dx} = 0$"],["$y = ax^n$","$\\frac{dy}{dx} = nax^{n-1}$"]],"caption":"Basic rules"},{"type":"callout","variant":"key_point","content":"Write $y$ with **positive indices** before differentiating fractional powers."},{"type":"question","questionText":"$\\frac{d}{dx}(5)$ equals?","questionType":"multiple_choice","options":["$0$","$5$","$5x$","$1$"],"correctAnswer":"$0$","explanation":"Constant rule."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'derivatives'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Derivatives — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Differentiating Polynomials', '{"blocks":[{"type":"heading","content":"Worked Examples"},{"type":"example","title":"$y = 4x^3 - 2x + 7$. Find $\\frac{dy}{dx}$.","steps":["$12x^2 - 2$."],"answer":"$12x^2 - 2$"},{"type":"example","title":"$y = \\frac{1}{x} = x^{-1}$. $\\frac{dy}{dx}$?","steps":["$-x^{-2} = -\\frac{1}{x^2}$."],"answer":"$-\\frac{1}{x^2}$"},{"type":"callout","variant":"warning","content":"Rewrite $\\frac{1}{x^n}$ as $x^{-n}$ before using the power rule."},{"type":"question","questionText":"$\\frac{d}{dx}(x^{-2})$ equals?","questionType":"multiple_choice","options":["$-2x^{-3}$","$x^{-3}$","$-2x^{-1}$","$2x^{-3}$"],"correctAnswer":"$-2x^{-3}$","explanation":"Power rule on negative index."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'derivatives'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Differentiating Polynomials');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Derivatives — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Differentiation"},{"type":"example","title":"$y = 3x^4 - x^2 + 6$. $\\frac{dy}{dx}$?","steps":["$12x^3 - 2x$."],"answer":"$12x^3 - 2x$"},{"type":"callout","variant":"warning","content":"Show each term''s derivative; simplify final expression."},{"type":"question","questionText":"$y = \\sqrt{x} = x^{1/2}$. $\\frac{dy}{dx}$?","questionType":"multiple_choice","options":["$\\frac{1}{2}x^{-1/2}$","$x^{-1/2}$","$\\frac{1}{2\\sqrt{x}}$","$\\frac{1}{2}x^{-1/2}$"],"correctAnswer":"$\\frac{1}{2}x^{-1/2}$","explanation":"Power rule with $n=\\frac{1}{2}$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'derivatives'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Derivatives — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Power rule: $\frac{d}{dx}(x^5)$?', 'multiple_choice', '["$5x^4$","$x^4$","$5x^5$","$4x^5$"]'::jsonb, '"$5x^4$"'::jsonb, 'easy', 'Standard rule.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Power rule: $\frac{d}{dx}(x^5)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{d}{dx}(7x^2)$ equals?', 'multiple_choice', '["$14x$","$7x$","$14x^2$","$7$"]'::jsonb, '"$14x$"'::jsonb, 'easy', '$7 \times 2x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{d}{dx}(7x^2)$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 2x^3 - 4x$. $\frac{dy}{dx}$ at $x = 2$?', 'multiple_choice', '["$20$","$16$","$12$","$8$"]'::jsonb, '"$20$"'::jsonb, 'medium', '$6x^2-4$ at $x=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 2x^3 - 4x$. $\frac{dy}{dx}$ at $x = 2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^2 - 1$. $\frac{dy}{dx}$ at $x = 4$?', 'multiple_choice', '["$8$","$16$","$15$","$4$"]'::jsonb, '"$8$"'::jsonb, 'medium', '$2x$ at $x=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^2 - 1$. $\frac{dy}{dx}$ at $x = 4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = \frac{3}{x^2}$. $\frac{dy}{dx}$?', 'multiple_choice', '["$-6x^{-3}$","$6x^{-3}$","$-3x^{-1}$","$3x^{-2}$"]'::jsonb, '"$-6x^{-3}$"'::jsonb, 'medium', '$3x^{-2}$ differentiated.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = \frac{3}{x^2}$. $\frac{dy}{dx}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 5\sqrt{x}$. $\frac{dy}{dx}$?', 'multiple_choice', '["$\\frac{5}{2\\sqrt{x}}$","$5x^{-1/2}$","$\\frac{5}{2}x^{1/2}$","$10\\sqrt{x}$"]'::jsonb, '"$\\frac{5}{2\\sqrt{x}}$"'::jsonb, 'hard', '$5 \cdot \frac{1}{2}x^{-1/2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 5\sqrt{x}$. $\frac{dy}{dx}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^4 - 2x^2 + 1$. $\frac{dy}{dx} = 0$ when?', 'multiple_choice', '["$x = 0$ or $x = \\pm 1$","$x = 0$ only","$x = 2$ only","Never"]'::jsonb, '"$x = 0$ or $x = \\pm 1$"'::jsonb, 'hard', '$4x^3-4x=4x(x^2-1)=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='derivatives'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^4 - 2x^2 + 1$. $\frac{dy}{dx} = 0$ when?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applications — Concepts', '{"blocks":[{"type":"heading","content":"Rates, Maxima and Minima"},{"type":"paragraph","content":"Set $\\frac{dy}{dx} = 0$ to find **stationary points** (turning points). Use the sign of $\\frac{dy}{dx}$ or second derivative to classify max/min."},{"type":"math_block","latex":"\\frac{dy}{dx} = 0 \\Rightarrow \\text{stationary point}","caption":"Turning point condition"},{"type":"callout","variant":"key_point","content":"**Velocity** is rate of change of displacement; **acceleration** is rate of change of velocity."},{"type":"question","questionText":"Maximum or minimum often found when?","questionType":"multiple_choice","options":["$\\frac{dy}{dx} = 0$","$y = 0$","$x = 0$ only","$\\int y\\,dx = 0$"],"correctAnswer":"$\\frac{dy}{dx} = 0$","explanation":"Stationary point."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'applications_differentiation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applications — Concepts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Optimisation Problems', '{"blocks":[{"type":"heading","content":"Worked Application"},{"type":"example","title":"A rectangle has perimeter $20$ cm. If width is $x$, length $10-x$, area $A = x(10-x)$. Maximise $A$.","steps":["$A = 10x - x^2$.","$\\frac{dA}{dx} = 10 - 2x = 0 \\Rightarrow x = 5$.","Maximum area when square: $25$ cm$^2$."],"answer":"$25$ cm$^2$ at $x = 5$"},{"type":"callout","variant":"warning","content":"Form $y$ or $A$ in one variable, differentiate, solve $\\frac{dy}{dx} = 0$, verify max/min."},{"type":"question","questionText":"If $\\frac{dy}{dx}$ changes from $+$ to $-$ at a point, the point is a?","questionType":"multiple_choice","options":["Maximum","Minimum","Inflection","Origin"],"correctAnswer":"Maximum","explanation":"Sign change test."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'applications_differentiation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Optimisation Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applications — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Applications"},{"type":"example","title":"$s = 2t^2 + 3t$. Velocity $v = \\frac{ds}{dt}$ at $t = 2$?","steps":["$v = 4t + 3$.","At $t = 2$: $v = 11$ m/s."],"answer":"$11$ m/s"},{"type":"callout","variant":"warning","content":"State units in motion problems; show differentiation step clearly."},{"type":"question","questionText":"$y = x^2 - 4x + 5$. Minimum value of $y$?","questionType":"multiple_choice","options":["$1$","$5$","$-4$","$0$"],"correctAnswer":"$1$","explanation":"Vertex at $x=2$, $y=1$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation' AND st.code = 'applications_differentiation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applications — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stationary point satisfies?', 'multiple_choice', '["$\\frac{dy}{dx} = 0$","$y = 0$","$x = 0$","$\\frac{d^2y}{dx^2} = 0$ always"]'::jsonb, '"$\\frac{dy}{dx} = 0$"'::jsonb, 'easy', 'Zero gradient.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stationary point satisfies?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Velocity is derivative of?', 'multiple_choice', '["Displacement","Time","Acceleration","Distance only"]'::jsonb, '"Displacement"'::jsonb, 'easy', '$v = ds/dt$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Velocity is derivative of?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^2 - 6x + 10$. $\frac{dy}{dx} = 0$ when $x$ equals?', 'multiple_choice', '["$3$","$6$","$0$","$-3$"]'::jsonb, '"$3$"'::jsonb, 'medium', '$2x-6=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^2 - 6x + 10$. $\frac{dy}{dx} = 0$ when $x$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$A = 12x - x^2$. Maximum when $x$ equals?', 'multiple_choice', '["$6$","$12$","$0$","$3$"]'::jsonb, '"$6$"'::jsonb, 'medium', '$12-2x=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$A = 12x - x^2$. Maximum when $x$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = x^3 - 3x$. $\frac{dy}{dx} = 0$ at?', 'multiple_choice', '["$x = \\pm 1$","$x = 0$ only","$x = 3$","$x = -3$ only"]'::jsonb, '"$x = \\pm 1$"'::jsonb, 'hard', '$3x^2-3=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = x^3 - 3x$. $\frac{dy}{dx} = 0$ at?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$s = t^3 - 6t$. Acceleration $\frac{d^2s}{dt^2}$ at $t = 2$?', 'multiple_choice', '["$12$","$8$","$6$","$4$"]'::jsonb, '"$12$"'::jsonb, 'hard', '$a=6t$ at $t=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$s = t^3 - 6t$. Acceleration $\frac{d^2s}{dt^2}$ at $t = 2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$y = 3x^2 - 12x + 7$. Minimum at $x$ equals?', 'multiple_choice', '["$2$","$4$","$0$","$-2$"]'::jsonb, '"$2$"'::jsonb, 'hard', '$6x-12=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_differentiation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='differentiation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$y = 3x^2 - 12x + 7$. Minimum at $x$ equals?');