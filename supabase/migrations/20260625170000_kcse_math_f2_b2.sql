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

-- ========== SIMILARITY AND ENLARGEMENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Similar Figures', '{"blocks":[{"type":"heading","content":"Similar Figures"},{"type":"paragraph","content":"Two figures are **similar** if they have the same shape but not necessarily the same size. Corresponding angles are equal and corresponding sides are in proportion."},{"type":"callout","variant":"key_point","content":"For similar triangles: $\\frac{AB}{PQ} = \\frac{BC}{QR} = \\frac{CA}{RP}$ and matching angles are equal."},{"type":"example","title":"Are two equilateral triangles always similar?","steps":["All angles are $60^\\circ$.","Corresponding sides are in proportion.","Yes — all equilateral triangles are similar."],"answer":"Yes, always similar"},{"type":"question","questionText":"Similar shapes have equal?","questionType":"multiple_choice","options":["Corresponding angles","All side lengths","Perimeters","Areas"],"correctAnswer":"Corresponding angles","explanation":"Sides are proportional, not necessarily equal."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'similarity'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Similar Figures');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding Missing Sides in Similar Triangles', '{"blocks":[{"type":"heading","content":"Missing Sides"},{"type":"example","title":"$\\triangle ABC \\sim \\triangle PQR$. $AB=6$, $PQ=9$, $BC=8$. Find $QR$.","steps":["Scale factor $k = \\frac{PQ}{AB} = \\frac{9}{6} = \\frac{3}{2}$.","$QR = BC \\times k = 8 \\times \\frac{3}{2} = 12$."],"answer":"$QR = 12$"},{"type":"example","title":"Rectangles $4$ cm $\\times$ $6$ cm and $6$ cm $\\times$ $9$ cm — similar?","steps":["Check ratios: $\\frac{4}{6} = \\frac{2}{3}$, $\\frac{6}{9} = \\frac{2}{3}$.","Same ratio — similar."],"answer":"Yes"},{"type":"callout","variant":"warning","content":"Match corresponding sides correctly — order matters."},{"type":"question","questionText":"$\\triangle ABC \\sim \\triangle DEF$. $AB=4$, $DE=10$, $BC=6$. Find $EF$.","questionType":"multiple_choice","options":["$15$","$12$","$8$","$24$"],"correctAnswer":"$15$","explanation":"$EF = 6 \\times \\frac{10}{4} = 15$."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'similarity'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding Missing Sides in Similar Triangles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Similarity — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Similarity"},{"type":"example","title":"A tree casts a $4$ m shadow when a $1.5$ m stick casts $2$ m. Height of tree?","steps":["Similar triangles: $\\frac{h}{1.5} = \\frac{4}{2}$.","$h = 1.5 \\times 2 = 3$ m."],"answer":"$3$ m"},{"type":"callout","variant":"warning","content":"Set up ratios with corresponding lengths on the same side of each fraction."},{"type":"question","questionText":"Two maps: scale $1:50000$ and $1:25000$. The second map lengths are?","questionType":"multiple_choice","options":["Twice as long","Half as long","Same","Four times"],"correctAnswer":"Twice as long","explanation":"Smaller scale denominator means larger drawing."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'similarity'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Similarity — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Enlargement Transformations', '{"blocks":[{"type":"heading","content":"Enlargement"},{"type":"paragraph","content":"An **enlargement** maps every point $P$ to $P''$ so that $OP'' = k \\cdot OP$ from a centre $O$, where $k$ is the scale factor."},{"type":"callout","variant":"key_point","content":"$k > 1$ enlarges; $0 < k < 1$ reduces; $k < 0$ inverts through the centre."},{"type":"example","title":"Enlarge shape from $O$ with scale factor $2$","steps":["Each point moves twice as far from $O$ along the ray $OP$.","A side of length $3$ cm becomes $6$ cm."],"answer":"Lengths multiplied by $2$"},{"type":"question","questionText":"Scale factor $0.5$ means?","questionType":"multiple_choice","options":["Half the size","Double the size","Same size","Inverted"],"correctAnswer":"Half the size","explanation":"$k < 1$ is a reduction."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'enlargement'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Enlargement Transformations');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Drawing Enlargements', '{"blocks":[{"type":"heading","content":"Drawing Enlargements"},{"type":"example","title":"Enlarge $\\triangle ABC$ with $A(2,0)$, $B(4,0)$, $C(3,2)$ from $O(0,0)$ by factor $3$","steps":["$A''(6,0)$, $B''(12,0)$, $C''(9,6)$ — multiply each coordinate by $3$."],"answer":"Vertices $(6,0)$, $(12,0)$, $(9,6)$"},{"type":"example","title":"Enlarge from centre $C(1,1)$ with factor $2$. Point $P(3,1)$.","steps":["Vector $\\overrightarrow{CP} = (2,0)$.","$\\overrightarrow{CP''} = 2(2,0) = (4,0)$.","$P'' = C + (4,0) = (5,1)$."],"answer":"$P''(5,1)$"},{"type":"callout","variant":"warning","content":"From centre not at origin: use vectors from centre, multiply by $k$, add back."},{"type":"question","questionText":"Enlarge $(2,4)$ from $O$ by factor $-1$.","questionType":"multiple_choice","options":["$(-2,-4)$","$(2,-4)$","$(-2,4)$","$(4,2)$"],"correctAnswer":"$(-2,-4)$","explanation":"$k=-1$ is a half-turn about $O$."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'enlargement'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Drawing Enlargements');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Enlargement — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Enlargement"},{"type":"example","title":"Photo enlarged from $6$ cm $\\times$ $4$ cm to width $15$ cm. New height?","steps":["Scale factor $k = \\frac{15}{6} = 2.5$.","Height $= 4 \\times 2.5 = 10$ cm."],"answer":"$10$ cm"},{"type":"callout","variant":"warning","content":"Area scales as $k^2$, not $k$."},{"type":"question","questionText":"Linear scale factor $3$. Area factor?","questionType":"multiple_choice","options":["$9$","$3$","$6$","$27$"],"correctAnswer":"$9$","explanation":"$k^2 = 9$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'enlargement'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Enlargement — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scale Factor', '{"blocks":[{"type":"heading","content":"Scale Factor"},{"type":"paragraph","content":"The **scale factor** $k$ compares image length to object length: $k = \\frac{\\text{image}}{\\text{object}}$."},{"type":"math_block","latex":"k = \\frac{OP''}{OP}","caption":"Scale factor from centre $O$"},{"type":"callout","variant":"key_point","content":"If $k = \\frac{3}{2}$, every length on the image is $\\frac{3}{2}$ times the original."},{"type":"example","title":"Object side $8$ cm, image side $12$ cm. Scale factor?","steps":["$k = \\frac{12}{8} = \\frac{3}{2}$."],"answer":"$k = \\frac{3}{2}$"},{"type":"question","questionText":"Scale factor from $5$ cm to $2$ cm?","questionType":"multiple_choice","options":["$\\frac{2}{5}$","$\\frac{5}{2}$","$3$","$10$"],"correctAnswer":"$\\frac{2}{5}$","explanation":"Image $\\div$ object $= \\frac{2}{5}$."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scale Factor');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area and Volume Scale Factors', '{"blocks":[{"type":"heading","content":"Area and Volume"},{"type":"paragraph","content":"If linear scale factor is $k$, then area scales as $k^2$ and volume as $k^3$."},{"type":"example","title":"Similar triangles: sides ratio $2:3$. Area ratio?","steps":["Linear $k = \\frac{3}{2}$.","Area ratio $= k^2 = \\frac{9}{4}$."],"answer":"$9:4$"},{"type":"example","title":"Cube side doubled. Volume factor?","steps":["$k = 2$, volume factor $= 2^3 = 8$."],"answer":"$8$ times"},{"type":"callout","variant":"warning","content":"Do not multiply area by $k$ — use $k^2$."},{"type":"question","questionText":"Linear factor $4$. Volume factor?","questionType":"multiple_choice","options":["$64$","$16$","$4$","$12$"],"correctAnswer":"$64$","explanation":"$4^3 = 64$."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area and Volume Scale Factors');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Scale Factor — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Scale Factor"},{"type":"example","title":"Model ship $1:200$. Real mast $30$ m. Model mast?","steps":["$\\frac{\\text{model}}{30} = \\frac{1}{200}$.","Model $= 0.15$ m $= 15$ cm."],"answer":"$15$ cm"},{"type":"callout","variant":"warning","content":"Convert units before applying scale factor."},{"type":"question","questionText":"Areas in ratio $25:16$. Linear scale factor (image:object)?","questionType":"multiple_choice","options":["$\\frac{5}{4}$","$\\frac{25}{16}$","$\\frac{4}{5}$","$5$"],"correctAnswer":"$\\frac{5}{4}$","explanation":"$k = \\sqrt{\\frac{25}{16}} = \\frac{5}{4}$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement' AND st.code = 'scale_factor'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Scale Factor — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Similar figures have equal corresponding?', 'multiple_choice', '["Angles","Side lengths","Perimeters","Volumes"]'::jsonb, '"Angles"'::jsonb, 'easy', 'Sides are proportional.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Similar figures have equal corresponding?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'All equilateral triangles are?', 'multiple_choice', '["Similar","Congruent","Different shapes","Never similar"]'::jsonb, '"Similar"'::jsonb, 'easy', 'Equal angles, proportional sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='All equilateral triangles are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Scale factor $k = 3$ multiplies lengths by?', 'multiple_choice', '["$3$","$6$","$9$","$1$"]'::jsonb, '"$3$"'::jsonb, 'easy', 'Linear scale factor.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Scale factor $k = 3$ multiplies lengths by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlargement with $k = 0.25$ is a?', 'multiple_choice', '["Reduction","Doubling","Rotation","Translation"]'::jsonb, '"Reduction"'::jsonb, 'easy', '$k < 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='enlargement'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlargement with $k = 0.25$ is a?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Negative scale factor $k = -2$ gives?', 'multiple_choice', '["Enlargement and inversion through centre","Reduction only","Same shape orientation","Translation"]'::jsonb, '"Enlargement and inversion through centre"'::jsonb, 'easy', '$|k|>1$ enlarges; sign inverts.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='enlargement'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Negative scale factor $k = -2$ gives?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Similar triangles: sides $3$ cm and $5$ cm correspond. Ratio $AB:PQ$?', 'multiple_choice', '["$3:5$","$5:3$","$9:25$","$1:1$"]'::jsonb, '"$3:5$"'::jsonb, 'easy', 'Object to image order.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Similar triangles: sides $3$ cm and $5$ cm correspond. Ratio $AB:PQ$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Linear factor $2$. Area multiplied by?', 'multiple_choice', '["$4$","$2$","$8$","$6$"]'::jsonb, '"$4$"'::jsonb, 'easy', '$k^2 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Linear factor $2$. Area multiplied by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\triangle ABC \sim \triangle DEF$. $AB=5$, $DE=15$, $BC=8$. Find $EF$.', 'multiple_choice', '["$24$","$16$","$12$","$40$"]'::jsonb, '"$24$"'::jsonb, 'medium', '$EF = 8 \times \frac{15}{5} = 24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\triangle ABC \sim \triangle DEF$. $AB=5$, $DE=15$, $BC=8$. Find $EF$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlarge $(4,2)$ from $O(0,0)$ by factor $1.5$.', 'multiple_choice', '["$(6,3)$","$(5.5,3.5)$","$(8,4)$","$(2,1)$"]'::jsonb, '"$(6,3)$"'::jsonb, 'medium', 'Multiply coordinates by $1.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='enlargement'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlarge $(4,2)$ from $O(0,0)$ by factor $1.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Stick $1.2$ m casts $1.8$ m shadow. Tree shadow $12$ m. Tree height?', 'multiple_choice', '["$8$ m","$14.4$ m","$6$ m","$20$ m"]'::jsonb, '"$8$ m"'::jsonb, 'medium', '$\frac{h}{1.2} = \frac{12}{1.8}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Stick $1.2$ m casts $1.8$ m shadow. Tree shadow $12$ m. Tree height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Photo $10$ cm wide enlarged to $25$ cm. Linear scale factor?', 'multiple_choice', '["$2.5$","$0.4$","$15$","$1.5$"]'::jsonb, '"$2.5$"'::jsonb, 'medium', '$\frac{25}{10}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Photo $10$ cm wide enlarged to $25$ cm. Linear scale factor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Similar solids: linear ratio $3:2$. Volume ratio?', 'multiple_choice', '["$27:8$","$9:4$","$3:2$","$6:4$"]'::jsonb, '"$27:8$"'::jsonb, 'medium', '$k^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Similar solids: linear ratio $3:2$. Volume ratio?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlarge $(2,6)$ from $C(1,2)$ by factor $3$.', 'multiple_choice', '["$(4,14)$","$(6,18)$","$(3,8)$","$(5,12)$"]'::jsonb, '"$(4,14)$"'::jsonb, 'medium', 'Vector $(1,4)$ times $3$ plus centre.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='enlargement'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlarge $(2,6)$ from $C(1,2)$ by factor $3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Map scale $1:25000$. $4$ cm on map equals real distance?', 'multiple_choice', '["$1$ km","$0.25$ km","$10$ km","$100$ m"]'::jsonb, '"$1$ km"'::jsonb, 'medium', '$4 \times 25000$ cm $= 1$ km.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Map scale $1:25000$. $4$ cm on map equals real distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Areas $36$ cm$^2$ and $81$ cm$^2$ on similar shapes. Linear scale (larger:smaller)?', 'multiple_choice', '["$3:2$","$9:4$","$2:3$","$81:36$"]'::jsonb, '"$3:2$"'::jsonb, 'hard', '$k = \sqrt{\frac{81}{36}} = \frac{3}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Areas $36$ cm$^2$ and $81$ cm$^2$ on similar shapes. Linear scale (larger:smaller)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder radius doubled, height unchanged. Volume factor?', 'multiple_choice', '["$4$","$2$","$8$","$6$"]'::jsonb, '"$4$"'::jsonb, 'hard', 'Volume $\propto r^2 h$; only $r$ doubles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder radius doubled, height unchanged. Volume factor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\triangle ABC \sim \triangle PQR$. Perimeter $ABC$ is $24$ cm, $PQ=9$, $AB=6$. Perimeter $PQR$?', 'multiple_choice', '["$36$ cm","$27$ cm","$18$ cm","$48$ cm"]'::jsonb, '"$36$ cm"'::jsonb, 'hard', 'Scale $\frac{3}{2}$; $24 \times \frac{3}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\triangle ABC \sim \triangle PQR$. Perimeter $ABC$ is $24$ cm, $PQ=9$, $AB=6$. Perimeter $PQR$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Model $1:100$. Real floor $4$ m $\times$ $5$ m. Model area?', 'multiple_choice', '["$20$ cm$^2$","$200$ cm$^2$","$2$ cm$^2$","$0.2$ cm$^2$"]'::jsonb, '"$20$ cm$^2$"'::jsonb, 'hard', 'Sides $4$ cm and $5$ cm; area $20$ cm$^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='scale_factor'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Model $1:100$. Real floor $4$ m $\times$ $5$ m. Model area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Enlargement centre $O$, $A(6,0)$ maps to $A''(9,0)$. Scale factor?', 'multiple_choice', '["$1.5$","$3$","$0.67$","$15$"]'::jsonb, '"$1.5$"'::jsonb, 'hard', '$\frac{9}{6} = 1.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='enlargement'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Enlargement centre $O$, $A(6,0)$ maps to $A''(9,0)$. Scale factor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two similar rectangles: widths $6$ and $15$ cm. Smaller area $24$ cm$^2$. Larger area?', 'multiple_choice', '["$150$ cm$^2$","$60$ cm$^2$","$96$ cm$^2$","$375$ cm$^2$"]'::jsonb, '"$150$ cm$^2$"'::jsonb, 'hard', '$k=2.5$; area $\times 6.25$ — ratio $(15/6)^2 = 6.25$; $24 \times 6.25 = 150$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='similarity'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='similarity_enlargement'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two similar rectangles: widths $6$ and $15$ cm. Smaller area $24$ cm$^2$. Larger area?');

-- ========== PYTHAGORAS THEOREM ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pythagoras'' Theorem', '{"blocks":[{"type":"heading","content":"Pythagoras'' Theorem"},{"type":"paragraph","content":"In a **right-angled triangle**, the square on the hypotenuse equals the sum of squares on the other two sides."},{"type":"math_block","latex":"a^2 + b^2 = c^2","caption":"$c$ is the hypotenuse (longest side, opposite the right angle)"},{"type":"callout","variant":"key_point","content":"The theorem applies only to right-angled triangles."},{"type":"example","title":"Right triangle: legs $3$ cm and $4$ cm. Hypotenuse?","steps":["$c^2 = 3^2 + 4^2 = 9 + 16 = 25$.","$c = 5$ cm."],"answer":"$5$ cm"},{"type":"question","questionText":"Legs $5$ and $12$. Hypotenuse?","questionType":"multiple_choice","options":["$13$","$17$","$7$","$169$"],"correctAnswer":"$13$","explanation":"$25 + 144 = 169$; $\\sqrt{169}=13$."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pythagoras'' Theorem');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding a Shorter Side', '{"blocks":[{"type":"heading","content":"Finding a Shorter Side"},{"type":"example","title":"Hypotenuse $13$ cm, one leg $5$ cm. Other leg?","steps":["$b^2 = 13^2 - 5^2 = 169 - 25 = 144$.","$b = 12$ cm."],"answer":"$12$ cm"},{"type":"callout","variant":"warning","content":"Subtract the smaller squares from the square on the hypotenuse."},{"type":"question","questionText":"Hypotenuse $10$, leg $6$. Other leg?","questionType":"multiple_choice","options":["$8$","$4$","$16$","$2$"],"correctAnswer":"$8$","explanation":"$100 - 36 = 64$."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding a Shorter Side');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Theorem — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Theorem"},{"type":"example","title":"Is a triangle with sides $7$, $24$, $25$ right-angled?","steps":["$7^2 + 24^2 = 49 + 576 = 625$.","$25^2 = 625$ — yes, right-angled."],"answer":"Yes"},{"type":"callout","variant":"warning","content":"Identify the hypotenuse as the longest side before substituting."},{"type":"question","questionText":"Sides $8$, $15$, $16$ — right triangle?","questionType":"multiple_choice","options":["No","Yes","Cannot tell","Only if isosceles"],"correctAnswer":"No","explanation":"$64+225=289 \\neq 256$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'theorem'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Theorem — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applications of Pythagoras', '{"blocks":[{"type":"heading","content":"Applications"},{"type":"paragraph","content":"Use Pythagoras for distances on grids, ladders against walls, and diagonals of rectangles."},{"type":"example","title":"Rectangle $6$ m $\\times$ $8$ m. Diagonal length?","steps":["$d^2 = 6^2 + 8^2 = 36 + 64 = 100$.","$d = 10$ m."],"answer":"$10$ m"},{"type":"question","questionText":"Ladder $5$ m reaches $3$ m up a wall. Base distance from wall?","questionType":"multiple_choice","options":["$4$ m","$2$ m","$8$ m","$15$ m"],"correctAnswer":"$4$ m","explanation":"$25 - 9 = 16$."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'applications_pythagoras'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applications of Pythagoras');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance Between Two Points', '{"blocks":[{"type":"heading","content":"Distance Formula"},{"type":"paragraph","content":"Distance between $(x_1,y_1)$ and $(x_2,y_2)$: $d = \\sqrt{(x_2-x_1)^2 + (y_2-y_1)^2}$."},{"type":"example","title":"Distance from $(1,2)$ to $(4,6)$","steps":["$d = \\sqrt{3^2 + 4^2} = 5$."],"answer":"$5$ units"},{"type":"callout","variant":"warning","content":"Draw a right triangle with horizontal and vertical legs."},{"type":"question","questionText":"Distance $(0,0)$ to $(5,12)$?","questionType":"multiple_choice","options":["$13$","$17$","$7$","$25$"],"correctAnswer":"$13$","explanation":"$5$-$12$-$13$ triangle."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'applications_pythagoras'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance Between Two Points');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Applications — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE Applications"},{"type":"example","title":"Town A is $9$ km east and $12$ km north of B. Direct distance?","steps":["$d = \\sqrt{81 + 144} = 15$ km."],"answer":"$15$ km"},{"type":"callout","variant":"warning","content":"Sketch the right triangle before calculating."},{"type":"question","questionText":"Square side $10$ cm. Diagonal?","questionType":"multiple_choice","options":["$10\\sqrt{2}$ cm","$20$ cm","$100$ cm","$5\\sqrt{2}$ cm"],"correctAnswer":"$10\\sqrt{2}$ cm","explanation":"$d = s\\sqrt{2}$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = 'applications_pythagoras'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Applications — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pythagoras in 3-D', '{"blocks":[{"type":"heading","content":"3-D Problems"},{"type":"paragraph","content":"In 3-D, find a right triangle in the solid — often the space diagonal uses two applications of $a^2+b^2=c^2$."},{"type":"example","title":"Cuboid $3$ cm $\\times$ $4$ cm $\\times$ $12$ cm. Space diagonal?","steps":["Base diagonal $d_1 = \\sqrt{3^2+4^2} = 5$.","Space diagonal $= \\sqrt{5^2+12^2} = 13$ cm."],"answer":"$13$ cm"},{"type":"callout","variant":"key_point","content":"Space diagonal of cuboid $l,w,h$: $\\sqrt{l^2+w^2+h^2}$."},{"type":"question","questionText":"Cube side $4$ cm. Space diagonal?","questionType":"multiple_choice","options":["$4\\sqrt{3}$ cm","$12$ cm","$8$ cm","$16$ cm"],"correctAnswer":"$4\\sqrt{3}$ cm","explanation":"$\\sqrt{3} \\times$ side."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = '3d_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pythagoras in 3-D');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, '3-D Diagonals — Worked Methods', '{"blocks":[{"type":"heading","content":"3-D Methods"},{"type":"example","title":"Square-based pyramid: base $6$ cm, height $4$ cm. Slant edge from apex to base corner?","steps":["Half diagonal of base $= \\frac{6\\sqrt{2}}{2} = 3\\sqrt{2}$.","Slant $= \\sqrt{(3\\sqrt{2})^2 + 4^2} = \\sqrt{18+16} = \\sqrt{34}$ cm."],"answer":"$\\sqrt{34}$ cm"},{"type":"callout","variant":"warning","content":"Find the right triangle that contains the length you need."},{"type":"question","questionText":"Cuboid $6$, $8$, $10$ cm. Space diagonal?","questionType":"multiple_choice","options":["$10\\sqrt{2}$ cm","$24$ cm","$14$ cm","$100$ cm"],"correctAnswer":"$10\\sqrt{2}$ cm","explanation":"$\\sqrt{36+64+100}=\\sqrt{200}$."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = '3d_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = '3-D Diagonals — Worked Methods');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, '3-D — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE 3-D"},{"type":"example","title":"Room $4$ m $\\times$ $3$ m $\\times$ $2.5$ m. Longest stick that fits?","steps":["$L = \\sqrt{16+9+6.25} = \\sqrt{31.25} \\approx 5.59$ m."],"answer":"$\\sqrt{31.25}$ m $\\approx 5.6$ m"},{"type":"callout","variant":"warning","content":"The longest segment in a cuboid is the space diagonal."},{"type":"question","questionText":"Cube diagonal $6\\sqrt{3}$ cm. Side length?","questionType":"multiple_choice","options":["$6$ cm","$3$ cm","$12$ cm","$18$ cm"],"correctAnswer":"$6$ cm","explanation":"$s\\sqrt{3}=6\\sqrt{3}$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem' AND st.code = '3d_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = '3-D — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pythagoras applies to?', 'multiple_choice', '["Right-angled triangles","All triangles","Circles","Parallelograms"]'::jsonb, '"Right-angled triangles"'::jsonb, 'easy', 'Needs a right angle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pythagoras applies to?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Legs $6$ and $8$. Hypotenuse?', 'multiple_choice', '["$10$","$14$","$2$","$48$"]'::jsonb, '"$10$"'::jsonb, 'easy', '$36+64=100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Legs $6$ and $8$. Hypotenuse?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hypotenuse $25$, leg $7$. Other leg?', 'multiple_choice', '["$24$","$18$","$32$","$576$"]'::jsonb, '"$24$"'::jsonb, 'easy', '$625-49=576$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hypotenuse $25$, leg $7$. Other leg?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a Pythagorean triple?', 'multiple_choice', '["$5,12,13$","$4,5,6$","$3,4,6$","$8,9,10$"]'::jsonb, '"$5,12,13$"'::jsonb, 'easy', '$25+144=169$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a Pythagorean triple?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $5$ cm $\times$ $12$ cm. Diagonal?', 'multiple_choice', '["$13$ cm","$17$ cm","$60$ cm","$7$ cm"]'::jsonb, '"$13$ cm"'::jsonb, 'easy', 'Standard triple.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $5$ cm $\times$ $12$ cm. Diagonal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Distance $(2,1)$ to $(6,4)$?', 'multiple_choice', '["$5$","$7$","$25$","$3$"]'::jsonb, '"$5$"'::jsonb, 'easy', '$3$-$4$-$5$ triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Distance $(2,1)$ to $(6,4)$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube side $5$ cm. Face diagonal?', 'multiple_choice', '["$5\\sqrt{2}$ cm","$5\\sqrt{3}$ cm","$10$ cm","$25$ cm"]'::jsonb, '"$5\\sqrt{2}$ cm"'::jsonb, 'easy', 'Diagonal of square face.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='3d_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube side $5$ cm. Face diagonal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ladder $10$ m, foot $6$ m from wall. How high?', 'multiple_choice', '["$8$ m","$4$ m","$16$ m","$2$ m"]'::jsonb, '"$8$ m"'::jsonb, 'medium', '$100-36=64$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ladder $10$ m, foot $6$ m from wall. How high?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is triangle with sides $9$, $40$, $41$ right-angled?', 'multiple_choice', '["Yes","No","Only equilateral","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'medium', '$81+1600=1681=41^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is triangle with sides $9$, $40$, $41$ right-angled?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid $5$, $12$, $13$ cm. Space diagonal?', 'multiple_choice', '["$13\\sqrt{2}$ cm","$30$ cm","$26$ cm","$169$ cm"]'::jsonb, '"$13\\sqrt{2}$ cm"'::jsonb, 'medium', '$\sqrt{25+144+169}=\sqrt{338}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='3d_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid $5$, $12$, $13$ cm. Space diagonal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square side $5$ cm. Diagonal length?', 'multiple_choice', '["$5\\sqrt{2}$ cm","$10$ cm","$25$ cm","$7$ cm"]'::jsonb, '"$5\\sqrt{2}$ cm"'::jsonb, 'medium', '$d = s\sqrt{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square side $5$ cm. Diagonal length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Point $(7,24)$ from origin. Distance?', 'multiple_choice', '["$25$","$31$","$17$","$576$"]'::jsonb, '"$25$"'::jsonb, 'medium', '$7$-$24$-$25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Point $(7,24)$ from origin. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hypotenuse $2\sqrt{5}$, leg $4$. Other leg?', 'multiple_choice', '["$2$","$6$","$\\sqrt{20}$","$8$"]'::jsonb, '"$2$"'::jsonb, 'medium', '$20-16=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hypotenuse $2\sqrt{5}$, leg $4$. Other leg?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid base $3$ cm $\times$ $4$ cm, space diagonal $13$ cm. Height?', 'multiple_choice', '["$12$ cm","$5$ cm","$10$ cm","$6$ cm"]'::jsonb, '"$12$ cm"'::jsonb, 'hard', 'Base diagonal $5$; $h=\sqrt{169-25}=12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='3d_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid base $3$ cm $\times$ $4$ cm, space diagonal $13$ cm. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ship sails $15$ km east then $20$ km north. Direct distance from start?', 'multiple_choice', '["$25$ km","$35$ km","$5$ km","$300$ km"]'::jsonb, '"$25$ km"'::jsonb, 'hard', '$15$-$20$-$25$ triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ship sails $15$ km east then $20$ km north. Direct distance from start?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Isosceles right triangle: legs $7$ cm. Hypotenuse?', 'multiple_choice', '["$7\\sqrt{2}$ cm","$14$ cm","$49$ cm","$7$ cm"]'::jsonb, '"$7\\sqrt{2}$ cm"'::jsonb, 'hard', '$c = l\sqrt{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='theorem'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Isosceles right triangle: legs $7$ cm. Hypotenuse?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube space diagonal $6\sqrt{3}$ cm. Volume?', 'multiple_choice', '["$216$ cm$^3$","$36$ cm$^3$","$108$ cm$^3$","$729$ cm$^3$"]'::jsonb, '"$216$ cm$^3$"'::jsonb, 'hard', 'Side $6$ cm; $6^3=216$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='3d_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube space diagonal $6\sqrt{3}$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rhombus diagonals $10$ cm and $24$ cm. Side length?', 'multiple_choice', '["$13$ cm","$17$ cm","$14$ cm","$26$ cm"]'::jsonb, '"$13$ cm"'::jsonb, 'hard', 'Half-diagonals $5$ and $12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications_pythagoras'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='pythagoras_theorem'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rhombus diagonals $10$ cm and $24$ cm. Side length?');

-- ========== TRIGONOMETRY I ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sine, Cosine and Tangent', '{"blocks":[{"type":"heading","content":"Sine, Cosine and Tangent"},{"type":"paragraph","content":"In a right-angled triangle, for angle $\\theta$: **opposite**, **adjacent**, and **hypotenuse** are used in the ratios."},{"type":"math_block","latex":"\\sin\\theta = \\frac{\\text{opp}}{\\text{hyp}}, \\quad \\cos\\theta = \\frac{\\text{adj}}{\\text{hyp}}, \\quad \\tan\\theta = \\frac{\\text{opp}}{\\text{adj}}","caption":"SOH CAH TOA"},{"type":"callout","variant":"key_point","content":"Label sides relative to the angle you are using — opposite and adjacent swap when the angle changes."},{"type":"example","title":"Right triangle: opp $3$, hyp $5$. Find $\\sin\\theta$.","steps":["$\\sin\\theta = \\frac{3}{5}$."],"answer":"$\\frac{3}{5}$"},{"type":"question","questionText":"SOH CAH TOA: $\\tan\\theta$ uses?","questionType":"multiple_choice","options":["Opposite $\\div$ adjacent","Opposite $\\div$ hypotenuse","Adjacent $\\div$ hypotenuse","Hypotenuse $\\div$ opposite"],"correctAnswer":"Opposite $\\div$ adjacent","explanation":"TOA."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'sine_cosine_tangent'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sine, Cosine and Tangent');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Trig Ratios', '{"blocks":[{"type":"heading","content":"Calculating Ratios"},{"type":"example","title":"Triangle: adj $4$, hyp $5$. Find $\\cos\\theta$.","steps":["$\\cos\\theta = \\frac{4}{5}$."],"answer":"$0.8$"},{"type":"example","title":"opp $7$, adj $24$. Find $\\tan\\theta$.","steps":["$\\tan\\theta = \\frac{7}{24}$."],"answer":"$\\frac{7}{24}$"},{"type":"callout","variant":"warning","content":"Always check which angle is $\\theta$ before labelling opposite and adjacent."},{"type":"question","questionText":"opp $8$, hyp $17$. $\\sin\\theta$?","questionType":"multiple_choice","options":["$\\frac{8}{17}$","$\\frac{15}{17}$","$\\frac{8}{15}$","$\\frac{17}{8}$"],"correctAnswer":"$\\frac{8}{17}$","explanation":"SOH."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'sine_cosine_tangent'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Trig Ratios');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Trig Ratios — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Ratios"},{"type":"example","title":"Right triangle with $\\theta = 30^\\circ$, hyp $10$ cm. Find opposite.","steps":["$\\sin 30^\\circ = \\frac{1}{2}$.","opp $= 10 \\times \\frac{1}{2} = 5$ cm."],"answer":"$5$ cm"},{"type":"callout","variant":"warning","content":"Know exact values: $\\sin 30^\\circ = \\frac{1}{2}$, $\\cos 60^\\circ = \\frac{1}{2}$, $\\tan 45^\\circ = 1$."},{"type":"question","questionText":"$\\cos 60^\\circ$ equals?","questionType":"multiple_choice","options":["$\\frac{1}{2}$","$\\frac{\\sqrt{3}}{2}$","$1$","$0$"],"correctAnswer":"$\\frac{1}{2}$","explanation":"Standard exact value."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'sine_cosine_tangent'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Trig Ratios — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Trigonometric Tables', '{"blocks":[{"type":"heading","content":"Trig Tables"},{"type":"paragraph","content":"Trig tables give $\\sin$, $\\cos$, $\\tan$ for angles in degrees. Read the angle in the row/column, find the value at the intersection."},{"type":"example","title":"Use tables: $\\sin 35^\\circ$","steps":["Locate $35^\\circ$ in the table.","$\\sin 35^\\circ \\approx 0.5736$."],"answer":"$0.5736$"},{"type":"question","questionText":"Tables give values for angles in?","questionType":"multiple_choice","options":["Degrees","Radians only","Gradians only","Minutes only"],"correctAnswer":"Degrees","explanation":"KCSE tables use degrees."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'trig_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Trigonometric Tables');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading Tables and Interpolation', '{"blocks":[{"type":"heading","content":"Reading Tables"},{"type":"example","title":"From tables, $\\tan 42^\\circ \\approx 0.9004$. Estimate $\\tan 42^\\circ 30''$.","steps":["Halfway between $42^\\circ$ and $43^\\circ$ values — slight increase.","Approximate by linear interpolation if needed."],"answer":"Slightly above $0.9004$"},{"type":"callout","variant":"warning","content":"For KCSE, round as instructed — usually 4 decimal places or 1 decimal for lengths."},{"type":"question","questionText":"$\\sin 90^\\circ$ from tables equals?","questionType":"multiple_choice","options":["$1$","$0$","Undefined","$0.5$"],"correctAnswer":"$1$","explanation":"Top of sine range."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'trig_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading Tables and Interpolation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Trig Tables — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Tables"},{"type":"example","title":"If $\\cos 53^\\circ = 0.6018$, find adj when hyp $= 20$ cm.","steps":["adj $= 20 \\times 0.6018 = 12.036$ cm.","$\\approx 12.0$ cm to 1 d.p."],"answer":"$12.0$ cm"},{"type":"callout","variant":"warning","content":"Multiply hypotenuse by cosine to find adjacent."},{"type":"question","questionText":"$\\sin 0^\\circ$ equals?","questionType":"multiple_choice","options":["$0$","$1$","Undefined","$-1$"],"correctAnswer":"$0$","explanation":"No opposite side at $0^\\circ$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'trig_tables'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Trig Tables — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Right-Angled Triangle Problems', '{"blocks":[{"type":"heading","content":"Right-Angled Problems"},{"type":"paragraph","content":"Draw a diagram, mark the known angle and sides, choose the correct ratio (sin, cos, or tan), then solve."},{"type":"example","title":"Ladder $6$ m long makes $60^\\circ$ with ground. Height on wall?","steps":["Height is opposite, ladder is hypotenuse.","$h = 6 \\sin 60^\\circ = 6 \\times 0.8660 \\approx 5.2$ m."],"answer":"$5.2$ m"},{"type":"question","questionText":"To find height with angle and hypotenuse, use?","questionType":"multiple_choice","options":["Sine","Cosine","Tangent","Pythagoras only"],"correctAnswer":"Sine","explanation":"opp/hyp."}]}'::jsonb, 10, 1
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'right_angled_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Right-Angled Triangle Problems');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angles of Elevation and Depression', '{"blocks":[{"type":"heading","content":"Elevation and Depression"},{"type":"paragraph","content":"**Angle of elevation** is measured upward from horizontal; **angle of depression** is measured downward."},{"type":"example","title":"From a point $40$ m from a building base, the top is at $35^\\circ$ elevation. Height?","steps":["$h = 40 \\tan 35^\\circ \\approx 40 \\times 0.7002 = 28.0$ m."],"answer":"$28$ m"},{"type":"callout","variant":"warning","content":"Angle of depression from the top equals angle of elevation from the bottom (alternate angles)."},{"type":"question","questionText":"Angle of depression from a cliff top to a boat equals angle of elevation from boat to cliff top?","questionType":"multiple_choice","options":["Yes","No","Only at noon","Only if equal height"],"correctAnswer":"Yes","explanation":"Alternate angles with horizontal."}]}'::jsonb, 12, 2
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'right_angled_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angles of Elevation and Depression');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Right-Angled — Exam Practice', '{"blocks":[{"type":"heading","content":"KCSE — Right Triangles"},{"type":"example","title":"Kite string $50$ m at $40^\\circ$ to horizontal. Vertical height of kite?","steps":["$h = 50 \\sin 40^\\circ \\approx 32.1$ m."],"answer":"$32.1$ m"},{"type":"callout","variant":"warning","content":"Identify whether the unknown is opposite, adjacent, or hypotenuse before choosing a ratio."},{"type":"question","questionText":"From top of $30$ m tower, depression to car is $25^\\circ$. Horizontal distance?","questionType":"multiple_choice","options":["$30 \\cot 25^\\circ$ m","$30 \\tan 25^\\circ$ m","$30 \\sin 25^\\circ$ m","$30$ m"],"correctAnswer":"$30 \\cot 25^\\circ$ m","explanation":"adj $= 30 / \\tan 25^\\circ$."}]}'::jsonb, 10, 3
FROM public.subtopics st JOIN public.topics t ON t.id = st.topic_id JOIN public.subjects s ON s.id = t.subject_id JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i' AND st.code = 'right_angled_problems'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Right-Angled — Exam Practice');

INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin\theta =$ opposite divided by?', 'multiple_choice', '["Hypotenuse","Adjacent","Opposite","$180^\\circ$"]'::jsonb, '"Hypotenuse"'::jsonb, 'easy', 'SOH.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin\theta =$ opposite divided by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\tan 45^\circ$ equals?', 'multiple_choice', '["$1$","$0$","$\\frac{1}{2}$","$\\sqrt{3}$"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Equal legs.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\tan 45^\circ$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin 30^\circ$ equals?', 'multiple_choice', '["$0.5$","$0.866$","$1$","$0$"]'::jsonb, '"$0.5$"'::jsonb, 'easy', 'Exact value.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin 30^\circ$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'opp $5$, hyp $13$. $\sin\theta$?', 'multiple_choice', '["$\\frac{5}{13}$","$\\frac{12}{13}$","$\\frac{5}{12}$","$\\frac{13}{5}$"]'::jsonb, '"$\\frac{5}{13}$"'::jsonb, 'easy', 'SOH.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='opp $5$, hyp $13$. $\sin\theta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos\theta =$ adjacent divided by?', 'multiple_choice', '["Hypotenuse","Opposite","Adjacent","$90^\\circ$"]'::jsonb, '"Hypotenuse"'::jsonb, 'easy', 'CAH.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos\theta =$ adjacent divided by?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\sin 90^\circ$ equals?', 'multiple_choice', '["$1$","$0$","$0.5$","Undefined in tables"]'::jsonb, '"$1$"'::jsonb, 'easy', 'Maximum sine.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\sin 90^\circ$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trig tables at KCSE typically use?', 'multiple_choice', '["Degrees","Radians","Gradians","Seconds only"]'::jsonb, '"Degrees"'::jsonb, 'easy', 'Standard school tables.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trig tables at KCSE typically use?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hyp $20$ cm, $\cos\theta = 0.6$. Adjacent length?', 'multiple_choice', '["$12$ cm","$16$ cm","$10$ cm","$8$ cm"]'::jsonb, '"$12$ cm"'::jsonb, 'medium', '$20 \times 0.6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hyp $20$ cm, $\cos\theta = 0.6$. Adjacent length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ladder $8$ m at $50^\circ$ to ground. Height on wall?', 'multiple_choice', '["$8\\sin 50^\\circ$ m","$8\\cos 50^\\circ$ m","$8\\tan 50^\\circ$ m","$4$ m"]'::jsonb, '"$8\\sin 50^\\circ$ m"'::jsonb, 'medium', 'opp $=$ hyp $\sin\theta$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ladder $8$ m at $50^\circ$ to ground. Height on wall?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\cos 60^\circ$ equals?', 'multiple_choice', '["$0.5$","$0.866$","$1$","$0$"]'::jsonb, '"$0.5$"'::jsonb, 'medium', 'Exact value.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\cos 60^\circ$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle of elevation is measured from?', 'multiple_choice', '["Horizontal upward","Vertical","Horizontal downward","North"]'::jsonb, '"Horizontal upward"'::jsonb, 'medium', 'Up from horizontal.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle of elevation is measured from?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'From point $50$ m from building, elevation $40^\circ$. Height?', 'multiple_choice', '["$50\\tan 40^\\circ$ m","$50\\sin 40^\\circ$ m","$50\\cos 40^\\circ$ m","$40$ m"]'::jsonb, '"$50\\tan 40^\\circ$ m"'::jsonb, 'medium', 'opp $=$ adj $\tan\theta$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='From point $50$ m from building, elevation $40^\circ$. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'adj $9$, opp $12$. $\tan\theta$?', 'multiple_choice', '["$\\frac{4}{3}$","$\\frac{3}{4}$","$\\frac{12}{9}$","$\\frac{9}{12}$"]'::jsonb, '"$\\frac{4}{3}$"'::jsonb, 'medium', '$12/9 = 4/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='adj $9$, opp $12$. $\tan\theta$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tower $40$ m high. Angle of depression to car $30^\circ$. Distance from base?', 'multiple_choice', '["$40\\cot 30^\\circ$ m","$40\\tan 30^\\circ$ m","$20$ m","$40\\sin 30^\\circ$ m"]'::jsonb, '"$40\\cot 30^\\circ$ m"'::jsonb, 'hard', 'adj $= 40/\tan 30^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tower $40$ m high. Angle of depression to car $30^\circ$. Distance from base?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Right triangle: $\sin\theta=0.8$, hyp $25$ cm. Opposite?', 'multiple_choice', '["$20$ cm","$15$ cm","$7$ cm","$32$ cm"]'::jsonb, '"$20$ cm"'::jsonb, 'hard', '$25 \times 0.8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='trig_tables'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Right triangle: $\sin\theta=0.8$, hyp $25$ cm. Opposite?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find angle if opp $7$, adj $7$.', 'multiple_choice', '["$45^\\circ$","$30^\\circ$","$60^\\circ$","$90^\\circ$"]'::jsonb, '"$45^\\circ$"'::jsonb, 'hard', '$\tan\theta = 1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find angle if opp $7$, adj $7$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Kite string $60$ m, angle $55^\circ$. Ground distance from holder?', 'multiple_choice', '["$60\\cos 55^\\circ$ m","$60\\sin 55^\\circ$ m","$60\\tan 55^\\circ$ m","$30$ m"]'::jsonb, '"$60\\cos 55^\\circ$ m"'::jsonb, 'hard', 'adj $=$ hyp $\cos\theta$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Kite string $60$ m, angle $55^\circ$. Ground distance from holder?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $\tan\theta = \frac{3}{4}$ and hyp $10$, find opposite.', 'multiple_choice', '["$6$","$8$","$5$","$7.5$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Triangle $6$-$8$-$10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sine_cosine_tangent'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $\tan\theta = \frac{3}{4}$ and hyp $10$, find opposite.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Building height $h$: from $40$ m away elevation $60^\circ$. Find $h$.', 'multiple_choice', '["$40\\sqrt{3}$ m","$40$ m","$20\\sqrt{3}$ m","$80$ m"]'::jsonb, '"$40\\sqrt{3}$ m"'::jsonb, 'hard', '$h = 40 \tan 60^\circ$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id JOIN public.subtopics st ON st.topic_id=t.id AND st.code='right_angled_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='trigonometry_i'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Building height $h$: from $40$ m away elevation $60^\circ$. Find $h$.');

