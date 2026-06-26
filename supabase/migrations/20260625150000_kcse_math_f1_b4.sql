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

