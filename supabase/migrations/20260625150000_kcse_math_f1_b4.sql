-- KCSE Form 1 Mathematics — Wave 1 Batch 4
-- Topics: geometric_constructions, scale_drawing, common_solids
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== GEOMETRIC CONSTRUCTIONS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Construction Tools and Rules', '{"blocks":[{"type":"heading","content":"Construction Tools and Rules"},{"type":"paragraph","content":"A **geometric construction** uses only a ruler (for drawing straight lines) and a pair of compasses. We do not measure angles with a protractor in pure construction work — we build them from known steps."},{"type":"callout","variant":"key_point","content":"Leave construction arcs visible unless the question says otherwise. They show your method."},{"type":"paragraph","content":"A **straight line** is drawn through two points. An **arc** is part of a circle drawn with compasses fixed at one centre."},{"type":"example","title":"Draw a line segment $AB$ of length $6$ cm","steps":["Mark point $A$.","Place ruler through $A$, mark $B$ so $AB = 6$ cm.","Join $A$ and $B$ with a straight line."],"answer":"Line segment $AB = 6$ cm"},{"type":"callout","variant":"warning","content":"Do not use a protractor when the paper says \"construct\" — examiners want compass-and-ruler methods."},{"type":"question","questionText":"Which tool draws arcs in constructions?","questionType":"multiple_choice","options":["Compasses","Protractor","Set square only","Calculator"],"correctAnswer":"Compasses","explanation":"Compasses trace circular arcs."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Construction Tools and Rules');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Constructing $60^\circ$ and $90^\circ$ Angles', '{"blocks":[{"type":"heading","content":"Constructing $60^\\circ$ and $90^\\circ$ Angles"},{"type":"example","title":"Construct a $60^\\circ$ angle at point $O$","steps":["Draw ray $OA$.","With centre $O$, draw an arc cutting $OA$ at $P$.","With centre $P$ and same radius, draw an arc cutting the first arc at $Q$.","Join $O$ to $Q$. Then $\\angle AOQ = 60^\\circ$."],"answer":"$\\angle AOQ = 60^\\circ$"},{"type":"example","title":"Construct a $90^\\circ$ angle at point $O$","steps":["Construct $60^\\circ$ as above to get ray $OQ$ with $\\angle AOQ = 60^\\circ$.","With centre $O$, mark $Q$ on the arc; with centre $Q$, draw another $60^\\circ$ step to ray $OR$.","Then $\\angle AOQ = 60^\\circ$ and $\\angle QOR = 60^\\circ$, so $\\angle AOR = 120^\\circ$; bisect $\\angle AOQ$ to get $90^\\circ$.","Alternatively: construct perpendicular by bisecting a straight angle or using the standard perpendicular-at-a-point method."],"answer":"$\\angle = 90^\\circ$"},{"type":"callout","variant":"warning","content":"$60^\\circ$ comes from equilateral triangle geometry — all angles are $60^\\circ$."},{"type":"question","questionText":"An equilateral triangle has each angle equal to?","questionType":"multiple_choice","options":["$60^\\circ$","$90^\\circ$","$45^\\circ$","$120^\\circ$"],"correctAnswer":"$60^\\circ$","explanation":"$180^\\circ \\div 3 = 60^\\circ$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Constructing $60^\circ$ and $90^\circ$ Angles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angle Construction — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Angle Construction"},{"type":"example","title":"Construct $150^\\circ$ at point $O$","steps":["Construct $120^\\circ$ as $60^\\circ + 60^\\circ$ on a straight base.","Add a further $30^\\circ$ by bisecting a $60^\\circ$ angle, or build $180^\\circ - 30^\\circ$.","Check: $150^\\circ = 90^\\circ + 60^\\circ$ — construct right angle then add $60^\\circ$."],"answer":"$\\angle = 150^\\circ$"},{"type":"callout","variant":"warning","content":"Break unfamiliar angles into sums or differences of $60^\\circ$, $90^\\circ$, and $45^\\circ$ (bisect $90^\\circ$)."},{"type":"question","questionText":"$45^\\circ$ can be found by bisecting which angle?","questionType":"multiple_choice","options":["$90^\\circ$","$60^\\circ$","$180^\\circ$","$30^\\circ$"],"correctAnswer":"$90^\\circ$","explanation":"Angle bisector of a right angle."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_angles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angle Construction — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Constructing Triangles — SSS', '{"blocks":[{"type":"heading","content":"SSS Triangle Construction"},{"type":"paragraph","content":"Given three side lengths, we can construct a triangle when the **triangle inequality** holds: the sum of any two sides exceeds the third."},{"type":"callout","variant":"key_point","content":"**SSS**: draw the base, then arcs of the other two lengths from the endpoints."},{"type":"example","title":"Construct $\\triangle ABC$ with $AB = 7$ cm, $BC = 5$ cm, $AC = 6$ cm","steps":["Draw base $AB = 7$ cm.","With centre $A$, radius $6$ cm, draw an arc above $AB$.","With centre $B$, radius $5$ cm, draw an arc to meet the first at $C$.","Join $AC$ and $BC$."],"answer":"$\\triangle ABC$ constructed"},{"type":"callout","variant":"warning","content":"If arcs do not meet, the three lengths cannot form a triangle."},{"type":"question","questionText":"SSS construction needs how many side lengths?","questionType":"multiple_choice","options":["$3$","$2$","$1$","$4$"],"correctAnswer":"$3$","explanation":"Side-Side-Side."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_triangles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Constructing Triangles — SSS');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Constructing Triangles — SAS and ASA', '{"blocks":[{"type":"heading","content":"SAS and ASA Constructions"},{"type":"example","title":"Construct $\\triangle PQR$ with $PQ = 8$ cm, $\\angle Q = 60^\\circ$, $QR = 5$ cm (SAS)","steps":["Draw $PQ = 8$ cm.","At $Q$, construct $\\angle PQX = 60^\\circ$.","Mark $QR = 5$ cm on ray $QX$.","Join $PR$."],"answer":"$\\triangle PQR$ with SAS data"},{"type":"example","title":"Construct $\\triangle LMN$ with $LM = 6$ cm, $\\angle L = 45^\\circ$, $\\angle M = 75^\\circ$ (ASA)","steps":["Draw $LM = 6$ cm.","Construct $\\angle L = 45^\\circ$ and $\\angle M = 75^\\circ$ at the base.","Extend the angle rays to meet at $N$."],"answer":"$\\triangle LMN$ with ASA data"},{"type":"callout","variant":"warning","content":"SAS: the angle must be **between** the two given sides."},{"type":"question","questionText":"In SAS, the given angle lies where?","questionType":"multiple_choice","options":["Between the two given sides","Opposite the longest side","At the third vertex only","Anywhere"],"correctAnswer":"Between the two given sides","explanation":"SAS = Side-Angle-Side."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_triangles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Constructing Triangles — SAS and ASA');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Triangle Construction — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Triangle Construction"},{"type":"example","title":"Construct an isosceles $\\triangle ABC$ with $AB = AC = 5$ cm and base $BC = 6$ cm","steps":["Draw base $BC = 6$ cm.","Bisect $BC$ at right angles (perpendicular bisector).","Mark $A$ on the bisector with $AB = 5$ cm (arc from $B$ and $C$).","Join $AB$ and $AC$."],"answer":"Isosceles triangle with equal sides $5$ cm"},{"type":"callout","variant":"warning","content":"Isosceles triangles have symmetry on the perpendicular bisector of the base."},{"type":"question","questionText":"An isosceles triangle has two sides equal. The axis of symmetry is the?","questionType":"multiple_choice","options":["Perpendicular bisector of the base","Base itself","Any angle bisector","Median from apex only"],"correctAnswer":"Perpendicular bisector of the base","explanation":"Symmetry line through the apex."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'construct_triangles'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Triangle Construction — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Perpendicular Bisectors', '{"blocks":[{"type":"heading","content":"Perpendicular Bisector of a Line Segment"},{"type":"paragraph","content":"The **perpendicular bisector** of $AB$ is the line through the midpoint of $AB$ at $90^\\circ$ to $AB$. Every point on it is equidistant from $A$ and $B$."},{"type":"callout","variant":"key_point","content":"Construction: arcs of equal radius from $A$ and $B$ above and below the segment; join the intersection points."},{"type":"example","title":"Construct the perpendicular bisector of $PQ = 8$ cm","steps":["Draw $PQ = 8$ cm.","With centres $P$ and $Q$, draw equal arcs (radius $> 4$ cm) above $PQ$ meeting at $R$.","Repeat below to get $S$.","Join $RS$ — this bisects $PQ$ at $90^\\circ$."],"answer":"Line $RS$ is the perpendicular bisector"},{"type":"callout","variant":"warning","content":"Arc radius must be greater than half of $PQ$ or arcs will not cross."},{"type":"question","questionText":"A point on the perpendicular bisector of $AB$ is equidistant from?","questionType":"multiple_choice","options":["$A$ and $B$","$A$ only","$B$ only","The midpoint only"],"correctAnswer":"$A$ and $B$","explanation":"Equal distance property."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'bisectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Perpendicular Bisectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angle Bisectors', '{"blocks":[{"type":"heading","content":"Angle Bisector Construction"},{"type":"paragraph","content":"The **angle bisector** divides an angle into two equal parts. Points on it are equidistant from the two arms of the angle."},{"type":"example","title":"Bisect $\\angle AOB$","steps":["With centre $O$, draw an arc cutting $OA$ at $P$ and $OB$ at $Q$.","With centres $P$ and $Q$, draw equal arcs inside the angle meeting at $R$.","Join $O$ to $R$. Ray $OR$ bisects $\\angle AOB$."],"answer":"$\\angle AOR = \\angle ROB$"},{"type":"callout","variant":"warning","content":"Use the same compass width for the arcs from $P$ and $Q$."},{"type":"question","questionText":"An angle bisector divides an angle into?","questionType":"multiple_choice","options":["Two equal angles","Two right angles","A straight line","Parallel rays"],"correctAnswer":"Two equal angles","explanation":"Halves the angle."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'bisectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angle Bisectors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Bisectors — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Bisector Problems"},{"type":"example","title":"Construct the locus of points equidistant from two lines $L_1$ and $L_2$ meeting at $O$","steps":["Bisect the angle between $L_1$ and $L_2$.","The angle bisector is the required locus."],"answer":"Angle bisector through $O$"},{"type":"example","title":"Find a point $X$ equidistant from $A$, $B$, and $C$ (triangle circumcentre idea)","steps":["Construct perpendicular bisector of $AB$.","Construct perpendicular bisector of $BC$.","Their intersection is equidistant from $A$, $B$, and $C$."],"answer":"Intersection of two perpendicular bisectors"},{"type":"callout","variant":"warning","content":"Perpendicular bisector $\\rightarrow$ equal distance from endpoints. Angle bisector $\\rightarrow$ equal distance from two lines."},{"type":"question","questionText":"To locate a point equidistant from $P$ and $Q$, construct the?","questionType":"multiple_choice","options":["Perpendicular bisector of $PQ$","Angle bisector at $P$","Parallel line through $P$","Circle centre $P$ radius $PQ$ only"],"correctAnswer":"Perpendicular bisector of $PQ$","explanation":"Equidistant from endpoints."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions' AND st.code = 'bisectors'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Bisectors — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which instrument is essential for drawing construction arcs?', 'multiple_choice', '["Compasses","Protractor","Divider only","Eraser"]'::jsonb, '"Compasses"'::jsonb, 'easy', 'Compasses draw arcs.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which instrument is essential for drawing construction arcs?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A $60^\circ$ angle is obtained from which regular polygon corner?', 'multiple_choice', '["Equilateral triangle","Square","Pentagon","Hexagon"]'::jsonb, '"Equilateral triangle"'::jsonb, 'easy', 'Each angle is $60^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A $60^\circ$ angle is obtained from which regular polygon corner?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many $60^\circ$ steps make $180^\circ$?', 'multiple_choice', '["$3$","$2$","$4$","$6$"]'::jsonb, '"$3$"'::jsonb, 'easy', '$60 \times 3 = 180$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many $60^\circ$ steps make $180^\circ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'SSS needs arcs drawn from which points?', 'multiple_choice', '["Both endpoints of the base","The apex only","Midpoint only","Any point"]'::jsonb, '"Both endpoints of the base"'::jsonb, 'easy', 'Arcs from $A$ and $B$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='SSS needs arcs drawn from which points?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Can sides $3$ cm, $4$ cm, $8$ cm form a triangle?', 'multiple_choice', '["No","Yes","Only isosceles","Only right-angled"]'::jsonb, '"No"'::jsonb, 'easy', '$3+4 < 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Can sides $3$ cm, $4$ cm, $8$ cm form a triangle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular bisector meets the segment at what angle?', 'multiple_choice', '["$90^\\circ$","$60^\\circ$","$45^\\circ$","$180^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'easy', 'Perpendicular means $90^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular bisector meets the segment at what angle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle bisector divides the angle into parts that are?', 'multiple_choice', '["Equal","Supplementary","Complementary","Right"]'::jsonb, '"Equal"'::jsonb, 'easy', 'Two equal angles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle bisector divides the angle into parts that are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'To construct $45^\circ$, first construct which angle?', 'multiple_choice', '["$90^\\circ$","$60^\\circ$","$180^\\circ$","$30^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'medium', 'Bisect a right angle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='To construct $45^\circ$, first construct which angle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$135^\circ$ equals which sum?', 'multiple_choice', '["$90^\\circ + 45^\\circ$","$60^\\circ + 60^\\circ$","$180^\\circ - 90^\\circ$","$45^\\circ + 30^\\circ$"]'::jsonb, '"$90^\\circ + 45^\\circ$"'::jsonb, 'medium', 'Right angle plus half right.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$135^\circ$ equals which sum?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'SAS data: $5$ cm, $50^\circ$, $7$ cm. Which side is missing?', 'multiple_choice', '["The side opposite $50^\\circ$","The base only","None — all given","The altitude"]'::jsonb, '"The side opposite $50^\\circ$"'::jsonb, 'medium', 'Two sides and included angle given.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='SAS data: $5$ cm, $50^\circ$, $7$ cm. Which side is missing?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Construct triangle with sides $4$, $5$, $6$ cm. First step?', 'multiple_choice', '["Draw longest side $6$ cm as base","Draw shortest side only","Bisect an angle","Draw a circle"]'::jsonb, '"Draw longest side $6$ cm as base"'::jsonb, 'medium', 'Base then arcs.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Construct triangle with sides $4$, $5$, $6$ cm. First step?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Arc radius for perpendicular bisector of $10$ cm line must be?', 'multiple_choice', '["Greater than $5$ cm","Exactly $5$ cm","Less than $5$ cm","$10$ cm only"]'::jsonb, '"Greater than $5$ cm"'::jsonb, 'medium', 'More than half the segment.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Arc radius for perpendicular bisector of $10$ cm line must be?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point equidistant from two intersecting lines lies on the?', 'multiple_choice', '["Angle bisector","Perpendicular bisector of any segment","$x$-axis","Parallel line"]'::jsonb, '"Angle bisector"'::jsonb, 'medium', 'Angle bisector locus.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point equidistant from two intersecting lines lies on the?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Construct $30^\circ$ by bisecting which angle?', 'multiple_choice', '["$60^\\circ$","$90^\\circ$","$120^\\circ$","$45^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'medium', 'Half of $60^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Construct $30^\circ$ by bisecting which angle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Isosceles triangle: equal sides $6$ cm, base $8$ cm. Axis of symmetry length?', 'multiple_choice', '["$\\sqrt{20}$ cm","$4$ cm","$6$ cm","$8$ cm"]'::jsonb, '"$\\sqrt{20}$ cm"'::jsonb, 'hard', 'Altitude from Pythagoras: $\sqrt{36-16}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Isosceles triangle: equal sides $6$ cm, base $8$ cm. Axis of symmetry length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Construct $105^\circ$ as which combination?', 'multiple_choice', '["$60^\\circ + 45^\\circ$","$90^\\circ + 30^\\circ$","$120^\\circ - 15^\\circ$","$180^\\circ - 75^\\circ$"]'::jsonb, '"$60^\\circ + 45^\\circ$"'::jsonb, 'hard', 'Standard KCSE combination.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Construct $105^\circ$ as which combination?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Right triangle: legs $3$ cm and $4$ cm. Hypotenuse length?', 'multiple_choice', '["$5$ cm","$7$ cm","$12$ cm","$1$ cm"]'::jsonb, '"$5$ cm"'::jsonb, 'hard', '$3$-$4$-$5$ triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Right triangle: legs $3$ cm and $4$ cm. Hypotenuse length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perpendicular bisectors of $AB$ and $AC$ meet at a point equidistant from?', 'multiple_choice', '["$A$, $B$, and $C$","$A$ only","$B$ and $C$ only","No points"]'::jsonb, '"$A$, $B$, and $C$"'::jsonb, 'hard', 'Circumcentre construction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perpendicular bisectors of $AB$ and $AC$ meet at a point equidistant from?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'In triangle $PQR$, to find centre of inscribed circle, bisect which angles?', 'multiple_choice', '["All three angles (incentre)","Only $\\angle P$","Only the base","External angles only"]'::jsonb, '"All three angles (incentre)"'::jsonb, 'hard', 'Angle bisectors meet at incentre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bisectors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='In triangle $PQR$, to find centre of inscribed circle, bisect which angles?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'After constructing equilateral $\triangle OPQ$ on ray $OA$, $\angle POQ$ equals?', 'multiple_choice', '["$60^\\circ$","$90^\\circ$","$120^\\circ$","$30^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'hard', 'Equilateral triangle angle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_angles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='After constructing equilateral $\triangle OPQ$ on ray $OA$, $\angle POQ$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sides $7$, $7$, $10$ cm. Where is apex for SSS construction?', 'multiple_choice', '["On perpendicular bisector of $10$ cm base","At midpoint only","Outside the arcs","On the base"]'::jsonb, '"On perpendicular bisector of $10$ cm base"'::jsonb, 'hard', 'Isosceles symmetry.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='construct_triangles'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='geometric_constructions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sides $7$, $7$, $10$ cm. Where is apex for SSS construction?');


-- ========== SCALE DRAWING ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Scale Ratios', '{"blocks":[{"type":"heading","content":"Understanding Scale Ratios"},{"type":"paragraph","content":"A **scale** compares a length on a drawing or map to the real length. We write it as a ratio, e.g. $1 : 50\\,000$."},{"type":"callout","variant":"key_point","content":"Scale $1 : n$ means $1$ unit on the drawing represents $n$ units in reality."},{"type":"math_block","latex":"\\text{scale} = \\frac{\\text{drawing length}}{\\text{actual length}}","caption":"Same units on both sides before forming the ratio."},{"type":"example","title":"A map uses scale $1 : 25\\,000$. What real distance does $2$ cm represent?","steps":["Actual $= 2 \\times 25\\,000 = 50\\,000$ cm.","$50\\,000$ cm $= 500$ m $= 0.5$ km."],"answer":"$500$ m"},{"type":"callout","variant":"warning","content":"Convert to the units asked for in the question — km, m or cm."},{"type":"question","questionText":"On scale $1 : 100$, $3$ cm on the drawing equals how many cm in reality?","questionType":"multiple_choice","options":["$300$ cm","$100$ cm","$3$ cm","$30$ cm"],"correctAnswer":"$300$ cm","explanation":"$3 \\times 100 = 300$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'scales'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Scale Ratios');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scale Calculation Methods', '{"blocks":[{"type":"heading","content":"Scale Calculation Methods"},{"type":"example","title":"A room is $4$ m long. Draw it at scale $1 : 100$.","steps":["Convert $4$ m $= 400$ cm actual.","Drawing length $= \\frac{400}{100} = 4$ cm."],"answer":"$4$ cm on the drawing"},{"type":"example","title":"On a plan, a wall measures $6$ cm. Scale is $1 : 200$. Find the real length in metres.","steps":["Actual $= 6 \\times 200 = 1200$ cm.","$1200$ cm $= 12$ m."],"answer":"$12$ m"},{"type":"callout","variant":"warning","content":"Drawing $\\rightarrow$ actual: multiply by the scale factor. Actual $\\rightarrow$ drawing: divide."},{"type":"question","questionText":"Actual length $8$ m at $1 : 50$. Drawing length in cm?","questionType":"multiple_choice","options":["$16$ cm","$8$ cm","$400$ cm","$4$ cm"],"correctAnswer":"$16$ cm","explanation":"$800 \\div 50 = 16$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'scales'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scale Calculation Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scale Problems — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Scale Problems"},{"type":"example","title":"A rectangular field is $120$ m by $80$ m. Draw a rectangle $6$ cm by $4$ cm. Find the scale.","steps":["Compare corresponding sides: $\\frac{120\\,000}{6} = 20\\,000$ and $\\frac{80\\,000}{4} = 20\\,000$.","Scale is $1 : 20\\,000$."],"answer":"$1 : 20\\,000$"},{"type":"callout","variant":"warning","content":"Check both dimensions give the same ratio before stating the scale."},{"type":"question","questionText":"Scale $1 : 5000$. Real distance $250$ m equals how many cm on the map?","questionType":"multiple_choice","options":["$5$ cm","$50$ cm","$0.5$ cm","$25$ cm"],"correctAnswer":"$5$ cm","explanation":"$25\\,000 \\div 5000 = 5$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'scales'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scale Problems — KCSE Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'What Are Bearings?', '{"blocks":[{"type":"heading","content":"What Are Bearings?"},{"type":"paragraph","content":"A **bearing** is the direction of one point from another, measured **clockwise from North**."},{"type":"callout","variant":"key_point","content":"Bearings are written as three digits: $045^\\circ$, $120^\\circ$, $270^\\circ$."},{"type":"paragraph","content":"North is $000^\\circ$ (or $360^\\circ$). East is $090^\\circ$, South $180^\\circ$, West $270^\\circ$."},{"type":"example","title":"State the bearing of East from an observer.","steps":["From North, turn clockwise to East.","That is a quarter turn: $90^\\circ$.","Bearing $= 090^\\circ$."],"answer":"$090^\\circ$"},{"type":"callout","variant":"warning","content":"Never measure anticlockwise — bearings are always clockwise from North."},{"type":"question","questionText":"The bearing of South is?","questionType":"multiple_choice","options":["$180^\\circ$","$090^\\circ$","$270^\\circ$","$360^\\circ$"],"correctAnswer":"$180^\\circ$","explanation":"Half turn from North."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'bearings_intro'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'What Are Bearings?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Measuring and Drawing Bearings', '{"blocks":[{"type":"heading","content":"Measuring and Drawing Bearings"},{"type":"example","title":"Draw a bearing of $060^\\circ$ from point $A$","steps":["Draw a vertical line upwards from $A$ and mark North ($N$).","Place protractor centre at $A$ with $0^\\circ$ on North.","Mark $60^\\circ$ clockwise and draw ray $AB$."],"answer":"Ray at $060^\\circ$ from North"},{"type":"example","title":"Find the bearing of $B$ from $A$ if $B$ lies North-East of $A$","steps":["North-East is halfway between North and East.","Clockwise from North: $45^\\circ$.","Bearing $= 045^\\circ$."],"answer":"$045^\\circ$"},{"type":"callout","variant":"warning","content":"Always draw a North line at the point you are measuring **from**."},{"type":"question","questionText":"North-West as a bearing is?","questionType":"multiple_choice","options":["$315^\\circ$","$225^\\circ$","$135^\\circ$","$045^\\circ$"],"correctAnswer":"$315^\\circ$","explanation":"$360^\\circ - 45^\\circ = 315^\\circ$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'bearings_intro'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Measuring and Drawing Bearings');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Bearings — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Bearing Problems"},{"type":"example","title":"Town $B$ is on a bearing of $140^\\circ$ from town $A$. Draw the line and describe the direction.","steps":["Draw North at $A$.","Mark $140^\\circ$ clockwise — south-east of North.","Join $A$ to $B$ along that ray."],"answer":"$B$ lies SE of $A$"},{"type":"callout","variant":"warning","content":"Back-bearing: if bearing of $B$ from $A$ is $\\theta$, bearing of $A$ from $B$ is $\\theta \\pm 180^\\circ$ (adjust to $000$–$360$)."},{"type":"question","questionText":"Bearing of $B$ from $A$ is $030^\\circ$. Bearing of $A$ from $B$?","questionType":"multiple_choice","options":["$210^\\circ$","$150^\\circ$","$030^\\circ$","$330^\\circ$"],"correctAnswer":"$210^\\circ$","explanation":"$30 + 180 = 210$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'bearings_intro'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Bearings — KCSE Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scale Drawings and Plans', '{"blocks":[{"type":"heading","content":"Scale Drawings and Plans"},{"type":"paragraph","content":"A **scale drawing** is an accurate diagram of a real object or place, with every length reduced (or enlarged) by the same factor."},{"type":"callout","variant":"key_point","content":"Angles are unchanged in scale drawings; only lengths scale."},{"type":"paragraph","content":"Architects and surveyors use plans at scales like $1 : 100$ or $1 : 500$."},{"type":"example","title":"A door is $2$ m high. On a $1 : 50$ plan, how high is the door?","steps":["$2$ m $= 200$ cm.","Drawing height $= 200 \\div 50 = 4$ cm."],"answer":"$4$ cm"},{"type":"callout","variant":"warning","content":"Label the scale on your drawing in exams."},{"type":"question","questionText":"In a scale drawing, what stays the same as the real object?","questionType":"multiple_choice","options":["Angles","Areas","Volumes","Perimeters"],"correctAnswer":"Angles","explanation":"Shape is similar; angles match."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'representation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scale Drawings and Plans');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing to Scale', '{"blocks":[{"type":"heading","content":"Drawing to Scale"},{"type":"example","title":"Draw a rectangular plot $40$ m by $30$ m at scale $1 : 1000$","steps":["$40$ m $= 40\\,000$ mm; drawing $= 40\\,000 \\div 1000 = 40$ mm $= 4$ cm.","$30$ m gives $3$ cm.","Draw rectangle $4$ cm $\\times$ $3$ cm; label scale $1 : 1000$."],"answer":"Rectangle $4$ cm by $3$ cm"},{"type":"example","title":"Enlarge triangle sides $3$, $4$, $5$ cm by scale factor $2$","steps":["Multiply each side by $2$: $6$ cm, $8$ cm, $10$ cm.","Draw the enlarged triangle with the same angles."],"answer":"Sides $6$, $8$, $10$ cm"},{"type":"callout","variant":"warning","content":"Scale factor $> 1$ enlarges; scale factor between $0$ and $1$ reduces."},{"type":"question","questionText":"Scale factor $\\frac{1}{2}$ means the drawing is?","questionType":"multiple_choice","options":["Half the real size","Twice the real size","Same size","Four times the size"],"correctAnswer":"Half the real size","explanation":"Multiply lengths by $\\frac{1}{2}$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'representation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing to Scale');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Representation — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Representation Problems"},{"type":"example","title":"A school field measures $90$ m $\\times$ $60$ m. On a drawing the longer side is $9$ cm. Find the scale and the shorter side on the drawing.","steps":["$90$ m $= 9000$ cm; scale $= 9 : 9000 = 1 : 1000$.","Shorter side $= 60\\,000 \\div 1000 = 6$ cm."],"answer":"Scale $1 : 1000$; shorter side $6$ cm"},{"type":"callout","variant":"warning","content":"When finding an unknown scale, use one known pair of lengths first."},{"type":"question","questionText":"Map scale $1 : 50\\,000$. Two towns $7.5$ cm apart on the map. Real distance in km?","questionType":"multiple_choice","options":["$3.75$ km","$37.5$ km","$0.375$ km","$375$ km"],"correctAnswer":"$3.75$ km","explanation":"$7.5 \\times 50\\,000$ cm $= 3.75$ km."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing' AND st.code = 'representation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Representation — KCSE Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Scale $1 : 200$. Real length $400$ cm equals how many cm on the drawing?', 'multiple_choice', '["$2$ cm","$200$ cm","$4$ cm","$800$ cm"]'::jsonb, '"$2$ cm"'::jsonb, 'easy', '$400 \div 200 = 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Scale $1 : 200$. Real length $400$ cm equals how many cm on the drawing?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'On scale $1 : 50$, a line $5$ cm long represents real length?', 'multiple_choice', '["$250$ cm","$50$ cm","$5$ cm","$2.5$ m"]'::jsonb, '"$250$ cm"'::jsonb, 'easy', '$5 \times 50 = 250$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='On scale $1 : 50$, a line $5$ cm long represents real length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A scale of $1 : 10\,000$ means $1$ cm represents?', 'multiple_choice', '["$100$ m","$10$ m","$1$ km","$10$ km"]'::jsonb, '"$100$ m"'::jsonb, 'easy', '$10\,000$ cm $= 100$ m.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A scale of $1 : 10\,000$ means $1$ cm represents?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bearing of East from a point is?', 'multiple_choice', '["$090^\\circ$","$000^\\circ$","$180^\\circ$","$270^\\circ$"]'::jsonb, '"$090^\\circ$"'::jsonb, 'easy', 'Quarter turn clockwise from North.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bearing of East from a point is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bearings are measured from which direction?', 'multiple_choice', '["North","East","South","West"]'::jsonb, '"North"'::jsonb, 'easy', 'Always clockwise from North.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bearings are measured from which direction?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bearing $270^\circ$ points towards?', 'multiple_choice', '["West","East","North","South"]'::jsonb, '"West"'::jsonb, 'easy', 'Three-quarter turn from North.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bearing $270^\circ$ points towards?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'In a scale drawing, lengths are reduced but what is preserved?', 'multiple_choice', '["Angles","Areas","Volumes","Mass"]'::jsonb, '"Angles"'::jsonb, 'easy', 'Similar shapes keep angles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='In a scale drawing, lengths are reduced but what is preserved?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Actual distance $3$ km. Scale $1 : 25\,000$. Map distance in cm?', 'multiple_choice', '["$12$ cm","$75$ cm","$1.2$ cm","$120$ cm"]'::jsonb, '"$12$ cm"'::jsonb, 'medium', '$300\,000 \div 25\,000 = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Actual distance $3$ km. Scale $1 : 25\,000$. Map distance in cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Drawing length $8$ cm at $1 : 500$. Real length in metres?', 'multiple_choice', '["$40$ m","$4$ m","$400$ m","$0.4$ m"]'::jsonb, '"$40$ m"'::jsonb, 'medium', '$8 \times 500 = 4000$ cm $= 40$ m.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Drawing length $8$ cm at $1 : 500$. Real length in metres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bearing of $P$ from $Q$ is $075^\circ$. Bearing of $Q$ from $P$?', 'multiple_choice', '["$255^\\circ$","$105^\\circ$","$075^\\circ$","$285^\\circ$"]'::jsonb, '"$255^\\circ$"'::jsonb, 'medium', '$75 + 180 = 255$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bearing of $P$ from $Q$ is $075^\circ$. Bearing of $Q$ from $P$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A ship sails on a bearing of $150^\circ$. Its direction is?', 'multiple_choice', '["South-east of North","North-west","Due East","Due West"]'::jsonb, '"South-east of North"'::jsonb, 'medium', '$150^\circ$ is between $090^\circ$ and $180^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A ship sails on a bearing of $150^\circ$. Its direction is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Plot $50$ m by $20$ m drawn as $10$ cm by $4$ cm. The scale is?', 'multiple_choice', '["$1 : 500$","$1 : 50$","$1 : 200$","$1 : 1000$"]'::jsonb, '"$1 : 500$"'::jsonb, 'medium', '$5000 : 10 = 500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Plot $50$ m by $20$ m drawn as $10$ cm by $4$ cm. The scale is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlarge a $6$ cm line by scale factor $3$. New length?', 'multiple_choice', '["$18$ cm","$9$ cm","$2$ cm","$3$ cm"]'::jsonb, '"$18$ cm"'::jsonb, 'medium', '$6 \times 3 = 18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlarge a $6$ cm line by scale factor $3$. New length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Field $150$ m by $100$ m. Scale $1 : 5000$. Drawing dimensions in cm?', 'multiple_choice', '["$3$ cm by $2$ cm","$30$ cm by $20$ cm","$1.5$ cm by $1$ cm","$15$ cm by $10$ cm"]'::jsonb, '"$3$ cm by $2$ cm"'::jsonb, 'hard', 'Divide each side by $5000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Field $150$ m by $100$ m. Scale $1 : 5000$. Drawing dimensions in cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Town $A$ is $12$ km from $B$ on bearing $040^\circ$. Town $C$ is $12$ km from $B$ on bearing $130^\circ$. Angle $ABC$?', 'multiple_choice', '["$90^\\circ$","$40^\\circ$","$130^\\circ$","$50^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'hard', '$130 - 40 = 90$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Town $A$ is $12$ km from $B$ on bearing $040^\circ$. Town $C$ is $12$ km from $B$ on bearing $130^\circ$. Angle $ABC$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Map scale $2$ cm $:$ $5$ km. Two lakes $9$ cm apart on the map. Real distance?', 'multiple_choice', '["$22.5$ km","$18$ km","$4.5$ km","$45$ km"]'::jsonb, '"$22.5$ km"'::jsonb, 'hard', '$9 \div 2 \times 5 = 22.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Map scale $2$ cm $:$ $5$ km. Two lakes $9$ cm apart on the map. Real distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A plan shows a road $4.5$ cm long. Scale $1 : 20\,000$. Real length in km?', 'multiple_choice', '["$0.9$ km","$9$ km","$90$ km","$0.09$ km"]'::jsonb, '"$0.9$ km"'::jsonb, 'hard', '$4.5 \times 20\,000$ cm $= 0.9$ km.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A plan shows a road $4.5$ cm long. Scale $1 : 20\,000$. Real length in km?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Village $X$: bearing of $Y$ is $220^\circ$. Bearing of $X$ from $Y$?', 'multiple_choice', '["$040^\\circ$","$220^\\circ$","$140^\\circ$","$320^\\circ$"]'::jsonb, '"$040^\\circ$"'::jsonb, 'hard', '$220 - 180 = 40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='bearings_intro'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Village $X$: bearing of $Y$ is $220^\circ$. Bearing of $X$ from $Y$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Reduce a rectangle $12$ cm by $8$ cm using scale factor $\frac{1}{4}$. New area in cm$^2$?', 'multiple_choice', '["$6$ cm$^2$","$24$ cm$^2$","$96$ cm$^2$","$1.5$ cm$^2$"]'::jsonb, '"$6$ cm$^2$"'::jsonb, 'hard', 'Sides $3$ and $2$; area $= 6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Reduce a rectangle $12$ cm by $8$ cm using scale factor $\frac{1}{4}$. New area in cm$^2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Real length $600$ m. Scale $1 : 50\,000$. Map length in cm?', 'multiple_choice', '["$1.2$ cm","$12$ cm","$0.12$ cm","$120$ cm"]'::jsonb, '"$1.2$ cm"'::jsonb, 'medium', '$60\,000 \div 50\,000 = 1.2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scales'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Real length $600$ m. Scale $1 : 50\,000$. Map length in cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Similar triangles have sides $3,4,5$ cm and $9,12,15$ cm. Scale factor from small to large?', 'multiple_choice', '["$3$","$2$","$\frac{1}{3}$","$5$"]'::jsonb, '"$3$"'::jsonb, 'hard', '$9 \div 3 = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='representation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='scale_drawing'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Similar triangles have sides $3,4,5$ cm and $9,12,15$ cm. Scale factor from small to large?');

-- ========== COMMON SOLIDS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Nets of 3D Solids', '{"blocks":[{"type":"heading","content":"Nets of 3D Solids"},{"type":"paragraph","content":"A **net** is a flat shape that folds up to make a 3D solid. Each face of the solid appears once in the net."},{"type":"callout","variant":"key_point","content":"A cube has $6$ square faces. Its net has $6$ connected squares."},{"type":"paragraph","content":"Common Form 1 solids: cube, cuboid, cylinder, cone, square-based pyramid, triangular prism."},{"type":"example","title":"Name the solid from a net of $6$ identical squares in a cross shape","steps":["Count faces: $6$ squares of equal size.","Fold mentally: opposite faces pair up.","The solid is a **cube**."],"answer":"Cube"},{"type":"callout","variant":"warning","content":"Squares must join along full edges — partial overlaps are not valid nets."},{"type":"question","questionText":"How many faces does a cube net have?","questionType":"multiple_choice","options":["$6$","$4$","$8$","$12$"],"correctAnswer":"$6$","explanation":"A cube has $6$ faces."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'nets'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Nets of 3D Solids');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing and Folding Nets', '{"blocks":[{"type":"heading","content":"Drawing and Folding Nets"},{"type":"example","title":"Draw a net for a cuboid $4$ cm $\\times$ $3$ cm $\\times$ $2$ cm","steps":["Draw three pairs of rectangles: $4 \\times 3$, $4 \\times 2$, $3 \\times 2$.","Arrange them in a cross so shared edges match.","Label dimensions on each face."],"answer":"Net with $6$ rectangles of the three sizes"},{"type":"example","title":"Which net folds to a square pyramid?","steps":["Look for $1$ square base and $4$ identical triangles attached to its sides.","Triangles meet at the apex when folded."],"answer":"One square + four triangles"},{"type":"callout","variant":"warning","content":"A cylinder net has $2$ circles and $1$ rectangle (curved surface)."},{"type":"question","questionText":"A triangular prism net has how many rectangular faces?","questionType":"multiple_choice","options":["$3$","$2$","$5$","$6$"],"correctAnswer":"$3$","explanation":"Three lateral rectangles between two triangles."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'nets'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing and Folding Nets');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Nets — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Net Problems"},{"type":"example","title":"A cube has edge $5$ cm. Find the area of its net.","steps":["Each face is a $5 \\times 5$ square: area $= 25$ cm$^2$.","$6$ faces: total $= 6 \\times 25 = 150$ cm$^2$."],"answer":"$150$ cm$^2$"},{"type":"callout","variant":"warning","content":"Net area equals total surface area of the solid."},{"type":"question","questionText":"Cube edge $3$ cm. Area of one face?","questionType":"multiple_choice","options":["$9$ cm$^2$","$6$ cm$^2$","$27$ cm$^2$","$18$ cm$^2$"],"correctAnswer":"$9$ cm$^2$","explanation":"$3 \\times 3 = 9$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'nets'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Nets — KCSE Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Properties of Common Solids', '{"blocks":[{"type":"heading","content":"Properties of Common Solids"},{"type":"paragraph","content":"Solids have **faces** (flat surfaces), **edges** (where faces meet) and **vertices** (corner points)."},{"type":"callout","variant":"key_point","content":"Euler''s rule: $F + V - E = 2$ for many convex polyhedra."},{"type":"paragraph","content":"A **cube** has $6$ faces, $12$ edges, $8$ vertices. A **cuboid** has the same counts."},{"type":"example","title":"List faces, edges and vertices of a square pyramid","steps":["Faces: $1$ square + $4$ triangles $= 5$.","Vertices: $4$ on base + $1$ apex $= 5$.","Edges: $4$ on base + $4$ sloping $= 8$."],"answer":"$F=5$, $V=5$, $E=8$"},{"type":"callout","variant":"warning","content":"Curved solids (sphere, cylinder) are not polyhedra — Euler''s rule applies to flat-faced solids."},{"type":"question","questionText":"A cube has how many edges?","questionType":"multiple_choice","options":["$12$","$6$","$8$","$4$"],"correctAnswer":"$12$","explanation":"$4$ on top, $4$ on bottom, $4$ vertical."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'properties_solids'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Properties of Common Solids');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Edges, Faces and Vertices', '{"blocks":[{"type":"heading","content":"Edges, Faces and Vertices"},{"type":"example","title":"Verify Euler''s formula for a cuboid","steps":["$F = 6$, $V = 8$, $E = 12$.","$F + V - E = 6 + 8 - 12 = 2$."],"answer":"$F + V - E = 2$"},{"type":"example","title":"A triangular prism: count $F$, $V$, $E$","steps":["Faces: $2$ triangles + $3$ rectangles $= 5$.","Vertices: $3 + 3 = 6$.","Edges: $3 + 3 + 3 = 9$."],"answer":"$F=5$, $V=6$, $E=9$"},{"type":"callout","variant":"warning","content":"Count systematically — do not double-count edges."},{"type":"question","questionText":"Triangular prism: how many vertices?","questionType":"multiple_choice","options":["$6$","$5$","$9$","$3$"],"correctAnswer":"$6$","explanation":"$3$ on each triangular end."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'properties_solids'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Edges, Faces and Vertices');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solid Properties — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Solid Property Problems"},{"type":"example","title":"A polyhedron has $7$ faces and $10$ vertices. How many edges?","steps":["Use $F + V - E = 2$.","$7 + 10 - E = 2$ so $E = 15$."],"answer":"$15$ edges"},{"type":"callout","variant":"warning","content":"Euler''s formula is a quick check when one count is missing."},{"type":"question","questionText":"Square pyramid: total number of faces?","questionType":"multiple_choice","options":["$5$","$4$","$6$","$8$"],"correctAnswer":"$5$","explanation":"$1$ square + $4$ triangles."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'properties_solids'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solid Properties — KCSE Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area Models', '{"blocks":[{"type":"heading","content":"Surface Area Models"},{"type":"paragraph","content":"**Surface area** is the total area of all outer faces of a solid."},{"type":"callout","variant":"key_point","content":"Cube: $SA = 6s^2$. Cuboid: $SA = 2(lw + lh + wh)$."},{"type":"math_block","latex":"SA_{\\text{cuboid}} = 2(lw + lh + wh)","caption":"$l$ = length, $w$ = width, $h$ = height."},{"type":"example","title":"Find surface area of a cube of edge $4$ cm","steps":["One face $= 4 \\times 4 = 16$ cm$^2$.","$SA = 6 \\times 16 = 96$ cm$^2$."],"answer":"$96$ cm$^2$"},{"type":"callout","variant":"warning","content":"Units are squared: cm$^2$, m$^2$."},{"type":"question","questionText":"Cube edge $2$ cm. Surface area?","questionType":"multiple_choice","options":["$24$ cm$^2$","$8$ cm$^2$","$12$ cm$^2$","$6$ cm$^2$"],"correctAnswer":"$24$ cm$^2$","explanation":"$6 \\times 4 = 24$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'surface_models'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area Models');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Surface Areas', '{"blocks":[{"type":"heading","content":"Calculating Surface Areas"},{"type":"example","title":"Cuboid $6$ cm $\\times$ $4$ cm $\\times$ $3$ cm — find $SA$","steps":["$lw = 24$, $lh = 18$, $wh = 12$.","$SA = 2(24 + 18 + 12) = 2 \\times 54 = 108$ cm$^2$."],"answer":"$108$ cm$^2$"},{"type":"example","title":"Open-top box (no lid): $5$ cm $\\times$ $5$ cm $\\times$ $4$ cm","steps":["Base: $25$ cm$^2$.","Four sides: $2 \\times (5 \\times 4) + 2 \\times (5 \\times 4) = 80$ cm$^2$.","Total $= 105$ cm$^2$."],"answer":"$105$ cm$^2$"},{"type":"callout","variant":"warning","content":"Open boxes exclude the missing face from the total."},{"type":"question","questionText":"Cube edge $5$ cm. One face area?","questionType":"multiple_choice","options":["$25$ cm$^2$","$30$ cm$^2$","$125$ cm$^2$","$150$ cm$^2$"],"correctAnswer":"$25$ cm$^2$","explanation":"$5 \\times 5$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'surface_models'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Surface Areas');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Models — KCSE Practice', '{"blocks":[{"type":"heading","content":"KCSE Surface Area Problems"},{"type":"example","title":"Gift box cuboid $20$ cm $\\times$ $15$ cm $\\times$ $10$ cm. Wrapping paper needed (full cover)?","steps":["$SA = 2(20 \\times 15 + 20 \\times 10 + 15 \\times 10)$.","$= 2(300 + 200 + 150) = 1300$ cm$^2$."],"answer":"$1300$ cm$^2$"},{"type":"callout","variant":"warning","content":"Real wrapping may add overlap — read the question."},{"type":"question","questionText":"Cuboid $10$ cm $\\times$ $2$ cm $\\times$ $2$ cm. Surface area?","questionType":"multiple_choice","options":["$88$ cm$^2$","$40$ cm$^2$","$44$ cm$^2$","$104$ cm$^2$"],"correctAnswer":"$88$ cm$^2$","explanation":"$2(20+20+4)=88$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids' AND st.code = 'surface_models'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Models — KCSE Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A cube has how many faces?', 'multiple_choice', '["$6$","$4$","$8$","$12$"]'::jsonb, '"$6$"'::jsonb, 'easy', 'Six square faces.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A cube has how many faces?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which solid has a net of two circles and one rectangle?', 'multiple_choice', '["Cylinder","Cube","Cone","Pyramid"]'::jsonb, '"Cylinder"'::jsonb, 'easy', 'Circular bases and curved side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which solid has a net of two circles and one rectangle?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A square pyramid net has one square and how many triangles?', 'multiple_choice', '["$4$","$3$","$5$","$6$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Four triangular faces.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A square pyramid net has one square and how many triangles?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many vertices does a cube have?', 'multiple_choice', '["$8$","$6$","$12$","$4$"]'::jsonb, '"$8$"'::jsonb, 'easy', 'Four on top, four on bottom.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many vertices does a cube have?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Euler''s formula states $F + V - E$ equals?', 'multiple_choice', '["$2$","$0$","$1$","$4$"]'::jsonb, '"$2$"'::jsonb, 'easy', 'For convex polyhedra.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Euler''s formula states $F + V - E$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Surface area of a cube of edge $3$ cm?', 'multiple_choice', '["$54$ cm$^2$","$27$ cm$^2$","$18$ cm$^2$","$9$ cm$^2$"]'::jsonb, '"$54$ cm$^2$"'::jsonb, 'easy', '$6 \times 9 = 54$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Surface area of a cube of edge $3$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'One face of a cube is $16$ cm$^2$. Total surface area?', 'multiple_choice', '["$96$ cm$^2$","$64$ cm$^2$","$48$ cm$^2$","$32$ cm$^2$"]'::jsonb, '"$96$ cm$^2$"'::jsonb, 'easy', '$6 \times 16 = 96$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='One face of a cube is $16$ cm$^2$. Total surface area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid $5$ cm $\times$ $4$ cm $\times$ $3$ cm. Surface area?', 'multiple_choice', '["$94$ cm$^2$","$60$ cm$^2$","$47$ cm$^2$","$120$ cm$^2$"]'::jsonb, '"$94$ cm$^2$"'::jsonb, 'medium', '$2(20+15+12)=94$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid $5$ cm $\times$ $4$ cm $\times$ $3$ cm. Surface area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangular prism has how many edges?', 'multiple_choice', '["$9$","$6$","$5$","$12$"]'::jsonb, '"$9$"'::jsonb, 'medium', '$3+3+3$ edges.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangular prism has how many edges?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Net of a cube: total squares if each edge is $2$ cm?', 'multiple_choice', '["$6$ squares","$4$ squares","$8$ squares","$12$ squares"]'::jsonb, '"$6$ squares"'::jsonb, 'medium', 'Six faces on any cube net.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Net of a cube: total squares if each edge is $2$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square pyramid: how many edges?', 'multiple_choice', '["$8$","$5$","$6$","$10$"]'::jsonb, '"$8$"'::jsonb, 'medium', '$4$ base + $4$ sloping.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square pyramid: how many edges?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Open cubical box (no top), edge $4$ cm. Outer surface area?', 'multiple_choice', '["$80$ cm$^2$","$96$ cm$^2$","$64$ cm$^2$","$48$ cm$^2$"]'::jsonb, '"$80$ cm$^2$"'::jsonb, 'medium', 'Five faces: $5 \times 16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Open cubical box (no top), edge $4$ cm. Outer surface area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone net consists of one circle and what else?', 'multiple_choice', '["A sector of a circle","A rectangle","A triangle","A square"]'::jsonb, '"A sector of a circle"'::jsonb, 'medium', 'Curved surface unfolds to a sector.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone net consists of one circle and what else?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Polyhedron: $F=6$, $E=12$. Number of vertices?', 'multiple_choice', '["$8$","$6$","$10$","$4$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$6+V-12=2$ so $V=8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Polyhedron: $F=6$, $E=12$. Number of vertices?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube edge $5$ cm. Total area of its net?', 'multiple_choice', '["$150$ cm$^2$","$125$ cm$^2$","$30$ cm$^2$","$75$ cm$^2$"]'::jsonb, '"$150$ cm$^2$"'::jsonb, 'hard', '$6 \times 25 = 150$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube edge $5$ cm. Total area of its net?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Storage crate $2$ m $\times$ $1.5$ m $\times$ $1$ m (no base on ground). Paint all other outer faces. Area in m$^2$?', 'multiple_choice', '["$10$ m$^2$","$13$ m$^2$","$11$ m$^2$","$7$ m$^2$"]'::jsonb, '"$10$ m$^2$"'::jsonb, 'hard', 'Top $3$ m$^2$ plus four walls $7$ m$^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Storage crate $2$ m $\times$ $1.5$ m $\times$ $1$ m (no base on ground). Paint all other outer faces. Area in m$^2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid net missing one $3$ cm $\times$ $4$ cm face. Solid edge lengths include $3$, $4$ and?', 'multiple_choice', '["$5$ cm","$7$ cm","$12$ cm","$6$ cm"]'::jsonb, '"$5$ cm"'::jsonb, 'hard', 'Third dimension from remaining faces.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='nets'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid net missing one $3$ cm $\times$ $4$ cm face. Solid edge lengths include $3$, $4$ and?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangular prism: $F=5$, $V=6$. Edges $E$?', 'multiple_choice', '["$9$","$11$","$7$","$10$"]'::jsonb, '"$9$"'::jsonb, 'hard', '$5+6-E=2$ gives $E=9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangular prism: $F=5$, $V=6$. Edges $E$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Room $4$ m $\times$ $3$ m $\times$ $2.5$ m. Walls and ceiling only (no floor). Area to paint?', 'multiple_choice', '["$47$ m$^2$","$59$ m$^2$","$35$ m$^2$","$41$ m$^2$"]'::jsonb, '"$47$ m$^2$"'::jsonb, 'hard', 'Ceiling $12$ m$^2$ plus walls $35$ m$^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Room $4$ m $\times$ $3$ m $\times$ $2.5$ m. Walls and ceiling only (no floor). Area to paint?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A cuboid has $6$ faces. How many edges?', 'multiple_choice', '["$12$","$8$","$6$","$10$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Same edge count as a cube.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='properties_solids'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A cuboid has $6$ faces. How many edges?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube total surface area $150$ cm$^2$. Edge length?', 'multiple_choice', '["$5$ cm","$25$ cm","$6$ cm","$10$ cm"]'::jsonb, '"$5$ cm"'::jsonb, 'hard', 'One face $25$ cm$^2$; edge $5$ cm.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='surface_models'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='common_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube total surface area $150$ cm$^2$. Edge length?');
