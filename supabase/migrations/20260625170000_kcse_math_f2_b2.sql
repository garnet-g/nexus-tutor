-- KCSE Form 2 Mathematics — Wave 2 Batch 2
-- Topics: rotation, similarity_enlargement, pythagoras_theorem, trigonometry_i, area_triangle
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md



-- ========== ROTATION ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'What Is a Rotation?', '{"blocks":[{"type":"heading","content":"What Is a Rotation?"},{"type":"paragraph","content":"A **rotation** turns a shape about a fixed point called the **centre of rotation**. Every point moves along a circular arc through the same angle."},{"type":"paragraph","content":"A rotation is described by the centre, the angle (anticlockwise is positive), and the direction of turn."},{"type":"callout","variant":"key_point","content":"Under rotation, distance from the centre is preserved: if $O$ is the centre, then $OP = OP''$ for every point $P$ and its image $P''$."},{"type":"example","title":"Describe a quarter-turn about the origin","steps":["Centre: origin $O(0,0)$.","Angle: $90^\\circ$ anticlockwise.","Each point moves one quadrant around $O$."],"answer":"Centre $O$, angle $90^\\circ$ anticlockwise"},{"type":"question","questionText":"Which stays fixed during a rotation?","questionType":"multiple_choice","options":["Centre of rotation","Every vertex","Only the perimeter","Orientation"],"correctAnswer":"Centre of rotation","explanation":"The centre does not move."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotation_basics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'What Is a Rotation?');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rotating Points on a Grid', '{"blocks":[{"type":"heading","content":"Rotating Points on a Grid"},{"type":"example","title":"Rotate $A(4, 0)$ by $90^\\circ$ anticlockwise about $O$","steps":["$A$ is $4$ units on the positive $x$-axis from $O$.","A $90^\\circ$ anticlockwise turn moves it to the positive $y$-axis.","Image $A''(0, 4)$."],"answer":"$A''(0, 4)$"},{"type":"example","title":"Rotate $B(0, -3)$ by $180^\\circ$ about $O$","steps":["$B$ is $3$ units below $O$.","A half-turn sends it to $(0, 3)$."],"answer":"$B''(0, 3)$"},{"type":"callout","variant":"warning","content":"Clockwise and anticlockwise give different images unless the angle is $0^\\circ$ or $180^\\circ$."},{"type":"question","questionText":"Rotate $(2, 0)$ by $90^\\circ$ anticlockwise about $O$.","questionType":"multiple_choice","options":["$(0, 2)$","$(-2, 0)$","$(0, -2)$","$(2, 2)$"],"correctAnswer":"$(0, 2)$","explanation":"Quarter-turn from $x$-axis to $y$-axis."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotation_basics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rotating Points on a Grid');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rotation Basics — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Rotation Basics"},{"type":"example","title":"Vertices $(1,0)$, $(3,0)$, $(2,2)$ rotated $90^\\circ$ anticlockwise about $O$","steps":["$(1,0) \\to (0,1)$, $(3,0) \\to (0,3)$, $(2,2) \\to (-2,2)$.","Plot the image triangle."],"answer":"$(0,1)$, $(0,3)$, $(-2,2)$"},{"type":"callout","variant":"warning","content":"Rotate every vertex — rotating only one corner is a common error."},{"type":"question","questionText":"$90^\\circ$ clockwise equals $270^\\circ$ anticlockwise.","questionType":"multiple_choice","options":["True","False","Only at origin","Only for squares"],"correctAnswer":"True","explanation":"$360^\\circ - 90^\\circ = 270^\\circ$ anticlockwise."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotation_basics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rotation Basics — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Centre and Angle of Rotation', '{"blocks":[{"type":"heading","content":"Centre and Angle of Rotation"},{"type":"paragraph","content":"A rotation needs the **centre** $O$ and **angle** $\\theta$. Trace paper: pin at $O$, turn through $\\theta$, mark images."},{"type":"math_block","latex":"\\text{Rotation}(O, \\theta): \\; P \\mapsto P''","caption":"Point $P$ maps to image $P''$ after angle $\\theta$ about $O$."},{"type":"callout","variant":"key_point","content":"Angle $360^\\circ$ returns every point to its starting position."},{"type":"example","title":"Rotation mapping $A(1, 2)$ to $A''(-2, 1)$ about $O$","steps":["Both points are $\\sqrt{5}$ from $O$.","Turn from $A$ to $A''$ is $90^\\circ$ anticlockwise."],"answer":"$90^\\circ$ anticlockwise about $O$"},{"type":"question","questionText":"$270^\\circ$ anticlockwise equals?","questionType":"multiple_choice","options":["$90^\\circ$ clockwise","$270^\\circ$ clockwise","$180^\\circ$","No rotation"],"correctAnswer":"$90^\\circ$ clockwise","explanation":"$360^\\circ - 270^\\circ = 90^\\circ$ clockwise."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'centre_angle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Centre and Angle of Rotation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rotations About a Given Centre', '{"blocks":[{"type":"heading","content":"Rotations About a Given Centre"},{"type":"example","title":"Rotate $P(5, 1)$ by $90^\\circ$ anticlockwise about $C(2, 1)$","steps":["Translate: $P - C = (3, 0)$.","Rotate $(3,0)$ by $90^\\circ$ anticlockwise $\\to (0, 3)$.","Translate back: $(2, 4)$."],"answer":"$P''(2, 4)$"},{"type":"example","title":"Rotate $Q(1, 4)$ by $180^\\circ$ about $C(3, 2)$","steps":["$Q - C = (-2, 2)$; half-turn $\\to (2, -2)$.","Add $C$: $(5, 0)$."],"answer":"$Q''(5, 0)$"},{"type":"callout","variant":"warning","content":"For centre not at origin: translate $\\to$ rotate $\\to$ translate back."},{"type":"question","questionText":"Rotate $(4, 3)$ by $180^\\circ$ about $(2, 2)$.","questionType":"multiple_choice","options":["$(0, 1)$","$(6, 5)$","$(0, 5)$","$(6, 1)$"],"correctAnswer":"$(0, 1)$","explanation":"$(2,1)$ half-turn $\\to (-2,-1)$; add $(2,2)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'centre_angle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rotations About a Given Centre');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Centre and Angle — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Centre and Angle"},{"type":"example","title":"Which rotation maps $(0, 5)$ to $(-5, 0)$ about $O$?","steps":["From positive $y$-axis to negative $x$-axis.","Angle $90^\\circ$ anticlockwise, centre $O$."],"answer":"$90^\\circ$ anticlockwise about $O$"},{"type":"callout","variant":"warning","content":"State both centre and angle — partial descriptions lose marks."},{"type":"question","questionText":"Rotate $(1, 0)$ by $90^\\circ$ anticlockwise about $O$.","questionType":"multiple_choice","options":["$(0, 1)$","$(0, -1)$","$(-1, 0)$","$(1, 1)$"],"correctAnswer":"$(0, 1)$","explanation":"Standard quarter-turn."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'centre_angle'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Centre and Angle — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Order of Rotational Symmetry', '{"blocks":[{"type":"heading","content":"Order of Rotational Symmetry"},{"type":"paragraph","content":"A shape has **rotational symmetry** if it looks the same after a rotation of less than $360^\\circ$ about its centre."},{"type":"paragraph","content":"The **order** is how many times the shape matches itself in one full $360^\\circ$ turn."},{"type":"callout","variant":"key_point","content":"A square has rotational symmetry of order $4$ (turns of $90^\\circ$, $180^\\circ$, $270^\\circ$, $360^\\circ$)."},{"type":"example","title":"Order of an equilateral triangle?","steps":["Matches at $120^\\circ$, $240^\\circ$, $360^\\circ$.","Order $= 360^\\circ \\div 120^\\circ = 3$."],"answer":"Order $3$"},{"type":"question","questionText":"Regular hexagon: rotational symmetry order?","questionType":"multiple_choice","options":["$6$","$3$","$12$","$2$"],"correctAnswer":"$6$","explanation":"$360^\\circ \\div 60^\\circ = 6$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotational_symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Order of Rotational Symmetry');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding Rotational Symmetry', '{"blocks":[{"type":"heading","content":"Finding Rotational Symmetry"},{"type":"example","title":"Rectangle (not a square)?","steps":["Matches at $180^\\circ$ and $360^\\circ$ only.","Order $2$."],"answer":"Order $2$"},{"type":"example","title":"Letter S?","steps":["$180^\\circ$ turn about centre maps S onto itself.","Order $2$."],"answer":"Order $2$"},{"type":"callout","variant":"warning","content":"Order $1$ means no rotational symmetry other than a full turn."},{"type":"question","questionText":"Parallelogram (non-rectangle): order?","questionType":"multiple_choice","options":["$2$","$4$","$1$","$8$"],"correctAnswer":"$2$","explanation":"Half-turn about intersection of diagonals."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotational_symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding Rotational Symmetry');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rotational Symmetry — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Rotational Symmetry"},{"type":"example","title":"Regular pentagon — order?","steps":["Angle between matches $72^\\circ$.","Order $= 360 \\div 72 = 5$."],"answer":"Order $5$"},{"type":"callout","variant":"warning","content":"Do not confuse rotational order with lines of reflection symmetry."},{"type":"question","questionText":"Which has rotational symmetry order $1$ only?","questionType":"multiple_choice","options":["Scalene triangle","Square","Regular hexagon","Circle"],"correctAnswer":"Scalene triangle","explanation":"No partial turn maps it onto itself."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation' AND st.code = 'rotational_symmetry'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rotational Symmetry — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A rotation preserves shape and?', 'multiple_choice', '["Size","Colour only","Position of every point","Parallel lines only"]'::jsonb, '"Size"'::jsonb, 'easy', 'Rotation is an isometry.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A rotation preserves shape and?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(3, 0)$ by $90^\circ$ anticlockwise about $O$.', 'multiple_choice', '["$(0, 3)$","$(-3, 0)$","$(0, -3)$","$(3, 3)$"]'::jsonb, '"$(0, 3)$"'::jsonb, 'easy', 'Quarter-turn to the $y$-axis.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(3, 0)$ by $90^\circ$ anticlockwise about $O$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(0, -4)$ by $180^\circ$ about $O$.', 'multiple_choice', '["$(0, 4)$","$(-4, 0)$","$(4, 0)$","$(0, -4)$"]'::jsonb, '"$(0, 4)$"'::jsonb, 'easy', 'Half-turn from origin.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(0, -4)$ by $180^\circ$ about $O$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Positive rotation angle usually means?', 'multiple_choice', '["Anticlockwise","Clockwise","Reflection","Translation"]'::jsonb, '"Anticlockwise"'::jsonb, 'easy', 'Standard convention.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Positive rotation angle usually means?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Under rotation about $O$, lengths $OP$ and $OP''$ are?', 'multiple_choice', '["Equal","Perpendicular","Doubled","Halved"]'::jsonb, '"Equal"'::jsonb, 'easy', 'Distance from centre is fixed.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Under rotation about $O$, lengths $OP$ and $OP''$ are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(-2, 0)$ by $90^\circ$ anticlockwise about $O$.', 'multiple_choice', '["$(0, -2)$","$(0, 2)$","$(2, 0)$","$(-2, -2)$"]'::jsonb, '"$(0, -2)$"'::jsonb, 'easy', 'To negative $y$-axis.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(-2, 0)$ by $90^\circ$ anticlockwise about $O$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'One complete revolution is?', 'multiple_choice', '["$360^\\circ$","$180^\\circ$","$90^\\circ$","$270^\\circ$"]'::jsonb, '"$360^\\circ$"'::jsonb, 'easy', 'Full turn.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotation_basics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='One complete revolution is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(6, 2)$ by $90^\circ$ anticlockwise about $(2, 2)$.', 'multiple_choice', '["$(2, 6)$","$(6, 6)$","$(2, -2)$","$(-2, 2)$"]'::jsonb, '"$(2, 6)$"'::jsonb, 'medium', 'Translate, rotate, translate back.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(6, 2)$ by $90^\circ$ anticlockwise about $(2, 2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$180^\circ$ rotation about $C$ is equivalent to?', 'multiple_choice', '["Point reflection in $C$","Translation","Enlargement scale $2$","Reflection in $x$-axis"]'::jsonb, '"Point reflection in $C$"'::jsonb, 'medium', 'Half-turn through $C$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$180^\circ$ rotation about $C$ is equivalent to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which maps $(1, 0)$ to $(0, 1)$ about $O$?', 'multiple_choice', '["$90^\\circ$ anticlockwise","$90^\\circ$ clockwise","$180^\\circ$","Reflection in $y=x$"]'::jsonb, '"$90^\\circ$ anticlockwise"'::jsonb, 'medium', 'Quarter-turn.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which maps $(1, 0)$ to $(0, 1)$ about $O$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(5, 5)$ by $90^\circ$ clockwise about $O$.', 'multiple_choice', '["$(5, -5)$","$(-5, 5)$","$(-5, -5)$","$(5, 5)$"]'::jsonb, '"$(5, -5)$"'::jsonb, 'medium', 'Clockwise quarter-turn.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(5, 5)$ by $90^\circ$ clockwise about $O$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Centre of rotational symmetry of a regular pentagon?', 'multiple_choice', '["Centre of pentagon","Any vertex","Midpoint of one side only","Outside shape"]'::jsonb, '"Centre of pentagon"'::jsonb, 'medium', 'Geometric centre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Centre of rotational symmetry of a regular pentagon?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Smallest non-zero rotational symmetry angle of a square?', 'multiple_choice', '["$90^\\circ$","$45^\\circ$","$120^\\circ$","$60^\\circ$"]'::jsonb, '"$90^\\circ$"'::jsonb, 'medium', '$360 \div 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Smallest non-zero rotational symmetry angle of a square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(1, 3)$ by $180^\circ$ about $(2, 1)$.', 'multiple_choice', '["$(3, -1)$","$(1, -1)$","$(3, 3)$","$(0, 2)$"]'::jsonb, '"$(3, -1)$"'::jsonb, 'medium', 'Half-turn about given centre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='centre_angle'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(1, 3)$ by $180^\circ$ about $(2, 1)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotational symmetry order of a square?', 'multiple_choice', '["$4$","$2$","$8$","$1$"]'::jsonb, '"$4$"'::jsonb, 'medium', 'Matches every $90^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotational symmetry order of a square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Letter Z — rotational symmetry order?', 'multiple_choice', '["$2$","$1$","$4$","Infinite"]'::jsonb, '"$2$"'::jsonb, 'medium', '$180^\circ$ turn.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Letter Z — rotational symmetry order?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rotate $(2,3)$ by $270^\circ$ anticlockwise about $O$.', 'multiple_choice', '["$(-3, 2)$","$(3, -2)$","$(-2, -3)$","$(3, 2)$"]'::jsonb, '"$(-3, 2)$"'::jsonb, 'hard', 'Same as $90^\circ$ clockwise.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rotate $(2,3)$ by $270^\circ$ anticlockwise about $O$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangle $(0,0)$, $(4,0)$, $(2,3)$: rotate $90^\circ$ anticlockwise about $(2,0)$. Image of $(4,0)$?', 'multiple_choice', '["$(2, 2)$","$(2, -2)$","$(0, 2)$","$(4, 2)$"]'::jsonb, '"$(2, 2)$"'::jsonb, 'hard', 'Translate, rotate, translate back.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangle $(0,0)$, $(4,0)$, $(2,3)$: rotate $90^\circ$ anticlockwise about $(2,0)$. Image of $(4,0)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular octagon: smallest symmetry rotation (not $0^\circ$)?', 'multiple_choice', '["$45^\\circ$","$60^\\circ$","$90^\\circ$","$30^\\circ$"]'::jsonb, '"$45^\\circ$"'::jsonb, 'hard', '$360 \div 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular octagon: smallest symmetry rotation (not $0^\circ$)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If rotational symmetry order is $6$, angle between matches?', 'multiple_choice', '["$60^\\circ$","$30^\\circ$","$120^\\circ$","$90^\\circ$"]'::jsonb, '"$60^\\circ$"'::jsonb, 'hard', '$360 \div 6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If rotational symmetry order is $6$, angle between matches?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram: centre of $180^\circ$ rotational symmetry?', 'multiple_choice', '["Intersection of diagonals","Vertex $A$","Midpoint of $AB$","Outside figure"]'::jsonb, '"Intersection of diagonals"'::jsonb, 'hard', 'Diagonals bisect at centre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rotational_symmetry'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rotation'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram: centre of $180^\circ$ rotational symmetry?');

