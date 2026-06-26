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

