-- KCSE Form 2 Mathematics — Wave 2 Batch 3
-- Topics: area_quadrilaterals_polygons, area_part_circle, surface_area_solids, volume_solids, quadratic_expressions_equations
-- Idempotent migration: lessons + practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== AREA OF QUADRILATERALS AND POLYGONS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of Parallelograms and Rectangles', '{"blocks": [{"type": "heading", "content": "Parallelograms and Rectangles"}, {"type": "paragraph", "content": "A **parallelogram** has opposite sides parallel and equal. Its area equals base times perpendicular height."}, {"type": "math_block", "latex": "A_{\\text{parallelogram}} = b \\times h", "caption": "Height must be perpendicular to the base"}, {"type": "callout", "variant": "key_point", "content": "A rectangle is a parallelogram with right angles, so $A = l \\times w$."}, {"type": "example", "title": "Rectangle: length $12$ cm, width $5$ cm. Area?", "steps": ["$A = 12 \\times 5 = 60$ cm$^2$."], "answer": "$60$ cm$^2$"}, {"type": "question", "questionText": "Parallelogram base $8$ cm, height $6$ cm. Area?", "questionType": "multiple_choice", "options": ["$48$ cm$^2$", "$14$ cm$^2$", "$24$ cm$^2$", "$32$ cm$^2$"], "correctAnswer": "$48$ cm$^2$", "explanation": "$8 \\times 6$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of Parallelograms and Rectangles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of Rhombuses and Trapeziums', '{"blocks": [{"type": "heading", "content": "Rhombuses and Trapeziums"}, {"type": "math_block", "latex": "A_{\\text{rhombus}} = \\frac{1}{2} d_1 d_2", "caption": "Diagonals $d_1$ and $d_2$ are perpendicular"}, {"type": "paragraph", "content": "A **trapezium** has one pair of parallel sides (the parallel sides are the bases)."}, {"type": "math_block", "latex": "A_{\\text{trapezium}} = \\frac{1}{2}(a+b)h", "caption": "$a$ and $b$ are parallel sides; $h$ is perpendicular height"}, {"type": "example", "title": "Trapezium: parallel sides $10$ cm and $6$ cm, height $4$ cm.", "steps": ["$A = \\frac{1}{2}(10+6)(4) = 32$ cm$^2$."], "answer": "$32$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Do not use a slant side as height — height must meet the base at $90^\\circ$."}, {"type": "question", "questionText": "Rhombus diagonals $10$ cm and $24$ cm. Area?", "questionType": "multiple_choice", "options": ["$120$ cm$^2$", "$240$ cm$^2$", "$60$ cm$^2$", "$34$ cm$^2$"], "correctAnswer": "$120$ cm$^2$", "explanation": "$\\frac{1}{2}(10)(24)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of Rhombuses and Trapeziums');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Quadrilaterals — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Quadrilateral Areas"}, {"type": "example", "title": "Parallelogram: base $15$ m, slant side $13$ m, height $12$ m. Area?", "steps": ["Use perpendicular height $12$ m, not slant $13$ m.", "$A = 15 \\times 12 = 180$ m$^2$."], "answer": "$180$ m$^2$"}, {"type": "callout", "variant": "warning", "content": "KCSE often gives a slant length to test whether you use the correct height."}, {"type": "question", "questionText": "Trapezium: parallel sides $8$ cm and $14$ cm, height $5$ cm. Area?", "questionType": "multiple_choice", "options": ["$55$ cm$^2$", "$110$ cm$^2$", "$35$ cm$^2$", "$22$ cm$^2$"], "correctAnswer": "$55$ cm$^2$", "explanation": "$\\frac{1}{2}(22)(5)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'quadrilaterals'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Quadrilaterals — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of Regular Polygons', '{"blocks": [{"type": "heading", "content": "Regular Polygons"}, {"type": "paragraph", "content": "A **regular polygon** has equal sides and equal angles. Split it into congruent isosceles triangles from the centre."}, {"type": "math_block", "latex": "A = \\frac{1}{2} n r^2 \\sin\\left(\\frac{360^\\circ}{n}\\right)", "caption": "$n$ = number of sides; $r$ = distance from centre to vertex (circumradius)"}, {"type": "callout", "variant": "key_point", "content": "Equilateral triangle side $s$: $A = \\frac{\\sqrt{3}}{4}s^2$. Square side $s$: $A = s^2$."}, {"type": "example", "title": "Regular hexagon side $4$ cm. Area using triangles?", "steps": ["Six equilateral triangles side $4$.", "Each: $\\frac{\\sqrt{3}}{4}(16)$; total $6 \\times 4\\sqrt{3} = 24\\sqrt{3}$ cm$^2$."], "answer": "$24\\sqrt{3}$ cm$^2$"}, {"type": "question", "questionText": "Regular pentagon has how many equal sides?", "questionType": "multiple_choice", "options": ["$5$", "$4$", "$6$", "$8$"], "correctAnswer": "$5$", "explanation": "Penta means five."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'regular_polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of Regular Polygons');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Apothem and Perimeter', '{"blocks": [{"type": "heading", "content": "Apothem Method"}, {"type": "paragraph", "content": "The **apothem** $a$ is the perpendicular distance from the centre to a side. For a regular polygon:"}, {"type": "math_block", "latex": "A = \\frac{1}{2} \\times \\text{perimeter} \\times a"}, {"type": "example", "title": "Regular octagon: perimeter $40$ cm, apothem $6$ cm.", "steps": ["$A = \\frac{1}{2} \\times 40 \\times 6 = 120$ cm$^2$."], "answer": "$120$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Apothem is not the same as the side length or the radius to a vertex."}, {"type": "question", "questionText": "Square side $6$ cm. Area?", "questionType": "multiple_choice", "options": ["$36$ cm$^2$", "$24$ cm$^2$", "$12$ cm$^2$", "$18$ cm$^2$"], "correctAnswer": "$36$ cm$^2$", "explanation": "$6^2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'regular_polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Apothem and Perimeter');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Regular Polygons — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Regular Polygons"}, {"type": "example", "title": "Equilateral triangle side $8$ cm. Area?", "steps": ["$A = \\frac{\\sqrt{3}}{4}(64) = 16\\sqrt{3}$ cm$^2$."], "answer": "$16\\sqrt{3}$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Memorise special cases: equilateral triangle and square formulas save time in exams."}, {"type": "question", "questionText": "Regular hexagon side $2$ cm. Area? ($\\approx$ use $6$ equilateral triangles)", "questionType": "multiple_choice", "options": ["$6\\sqrt{3}$ cm$^2$", "$12$ cm$^2$", "$3\\sqrt{3}$ cm$^2$", "$24$ cm$^2$"], "correctAnswer": "$6\\sqrt{3}$ cm$^2$", "explanation": "Six triangles each $\\frac{\\sqrt{3}}{4}(4)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'regular_polygons'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Regular Polygons — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Splitting Composite Figures', '{"blocks": [{"type": "heading", "content": "Composite Figures"}, {"type": "paragraph", "content": "A **composite figure** is made from simpler shapes. Strategy: divide into rectangles, triangles, semicircles, etc., find each area, then add or subtract."}, {"type": "callout", "variant": "key_point", "content": "Draw dotted lines to show how you split the shape — examiners award method marks for a clear plan."}, {"type": "example", "title": "L-shaped room: rectangle $10$ m $\\times$ $6$ m minus corner $4$ m $\\times$ $3$ m.", "steps": ["Full rectangle: $60$ m$^2$.", "Corner removed: $12$ m$^2$.", "Area $= 48$ m$^2$."], "answer": "$48$ m$^2$"}, {"type": "question", "questionText": "Composite area strategy: first step?", "questionType": "multiple_choice", "options": ["Divide into familiar shapes", "Guess and check", "Multiply all sides", "Use circumference only"], "correctAnswer": "Divide into familiar shapes", "explanation": "Split then add/subtract."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'composite'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Splitting Composite Figures');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Shaded and Overlapping Regions', '{"blocks": [{"type": "heading", "content": "Shaded Regions"}, {"type": "example", "title": "Rectangle $12$ cm $\\times$ $8$ cm with triangular corner cut: triangle base $4$ cm, height $6$ cm.", "steps": ["Rectangle: $96$ cm$^2$.", "Triangle: $\\frac{1}{2}(24) = 12$ cm$^2$.", "Remaining: $84$ cm$^2$."], "answer": "$84$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Shaded region between two shapes often means subtract the inner area from the outer."}, {"type": "question", "questionText": "Outer square $10$ cm, inner square $6$ cm (concentric). Shaded frame area?", "questionType": "multiple_choice", "options": ["$64$ cm$^2$", "$100$ cm$^2$", "$36$ cm$^2$", "$76$ cm$^2$"], "correctAnswer": "$64$ cm$^2$", "explanation": "$100 - 36$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'composite'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Shaded and Overlapping Regions');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Composite Figures — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Composite Areas"}, {"type": "example", "title": "Field: rectangle $50$ m $\\times$ $30$ m with semicircular pond radius $5$ m removed from one end.", "steps": ["Rectangle: $1500$ m$^2$.", "Semicircle: $\\frac{1}{2}\\pi(25) \\approx 39.3$ m$^2$.", "Net $\\approx 1460.7$ m$^2$."], "answer": "$1500 - \\frac{25\\pi}{2}$ m$^2$"}, {"type": "callout", "variant": "warning", "content": "State whether you add or subtract each part. A common error is adding a piece that should be removed."}, {"type": "question", "questionText": "T-shaped figure: stem $4$ cm $\\times$ $10$ cm, crossbar $10$ cm $\\times$ $4$ cm (overlap $4$ cm $\\times$ $4$ cm). Total area?", "questionType": "multiple_choice", "options": ["$88$ cm$^2$", "$80$ cm$^2$", "$104$ cm$^2$", "$72$ cm$^2$"], "correctAnswer": "$88$ cm$^2$", "explanation": "$40+40+8$ after subtracting double-counted overlap."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons' AND st.code = 'composite'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Composite Figures — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle area formula?', 'multiple_choice', '["$lw$", "$2(l+w)$", "$l+w$", "$\\frac{1}{2}lw$"]'::jsonb, '"$lw$"'::jsonb, 'easy', 'Length times width.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle area formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram: base $9$ cm, height $7$ cm. Area?', 'multiple_choice', '["$63$ cm$^2$", "$32$ cm$^2$", "$16$ cm$^2$", "$126$ cm$^2$"]'::jsonb, '"$63$ cm$^2$"'::jsonb, 'easy', '$9 \times 7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram: base $9$ cm, height $7$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square side $11$ cm. Area?', 'multiple_choice', '["$121$ cm$^2$", "$44$ cm$^2$", "$22$ cm$^2$", "$60.5$ cm$^2$"]'::jsonb, '"$121$ cm$^2$"'::jsonb, 'easy', '$11^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square side $11$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rhombus area uses?', 'multiple_choice', '["Half product of diagonals", "Side squared only", "Circumference", "Sum of sides"]'::jsonb, '"Half product of diagonals"'::jsonb, 'easy', '$\frac{1}{2}d_1 d_2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rhombus area uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trapezium parallel sides are called?', 'multiple_choice', '["Bases", "Heights", "Apothems", "Radii"]'::jsonb, '"Bases"'::jsonb, 'easy', 'The two parallel sides.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trapezium parallel sides are called?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $7$ cm by $4$ cm. Area?', 'multiple_choice', '["$28$ cm$^2$", "$22$ cm$^2$", "$14$ cm$^2$", "$56$ cm$^2$"]'::jsonb, '"$28$ cm$^2$"'::jsonb, 'easy', '$7 \times 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $7$ cm by $4$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram area $54$ cm$^2$, base $9$ cm. Height?', 'multiple_choice', '["$6$ cm", "$5$ cm", "$4.5$ cm", "$12$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'easy', '$h = A/b$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram area $54$ cm$^2$, base $9$ cm. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular polygon: all sides and angles are?', 'multiple_choice', '["Equal", "Different", "Right angles only", "Obtuse only"]'::jsonb, '"Equal"'::jsonb, 'easy', 'Definition of regular.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular polygon: all sides and angles are?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equilateral triangle side $4$ cm. Area?', 'multiple_choice', '["$4\\sqrt{3}$ cm$^2$", "$16$ cm$^2$", "$8$ cm$^2$", "$12$ cm$^2$"]'::jsonb, '"$4\\sqrt{3}$ cm$^2$"'::jsonb, 'medium', '$\frac{\sqrt{3}}{4}(16)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equilateral triangle side $4$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square diagonal $10$ cm. Area?', 'multiple_choice', '["$50$ cm$^2$", "$100$ cm$^2$", "$25$ cm$^2$", "$20$ cm$^2$"]'::jsonb, '"$50$ cm$^2$"'::jsonb, 'medium', 'Side $= 10/\sqrt{2}$; area $= 50$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square diagonal $10$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular hexagon side $6$ cm. Area?', 'multiple_choice', '["$54\\sqrt{3}$ cm$^2$", "$36$ cm$^2$", "$108$ cm$^2$", "$18\\sqrt{3}$ cm$^2$"]'::jsonb, '"$54\\sqrt{3}$ cm$^2$"'::jsonb, 'medium', 'Six equilateral triangles.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular hexagon side $6$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Octagon perimeter $32$ cm, apothem $5$ cm. Area?', 'multiple_choice', '["$80$ cm$^2$", "$160$ cm$^2$", "$40$ cm$^2$", "$64$ cm$^2$"]'::jsonb, '"$80$ cm$^2$"'::jsonb, 'medium', '$\frac{1}{2}(32)(5)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Octagon perimeter $32$ cm, apothem $5$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Regular pentagon side $10$ cm. Perimeter?', 'multiple_choice', '["$50$ cm", "$25$ cm", "$100$ cm", "$40$ cm"]'::jsonb, '"$50$ cm"'::jsonb, 'medium', '$5 \times 10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Regular pentagon side $10$ cm. Perimeter?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area of regular polygon: $\frac{1}{2} \times p \times a$ where $a$ is?', 'multiple_choice', '["Apothem", "Altitude of triangle", "Arc length", "Angle"]'::jsonb, '"Apothem"'::jsonb, 'medium', 'Perpendicular to side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area of regular polygon: $\frac{1}{2} \times p \times a$ where $a$ is?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Equilateral triangle height $6$ cm. Side? (use $h = \frac{\sqrt{3}}{2}s$)', 'multiple_choice', '["$4\\sqrt{3}$ cm", "$6$ cm", "$12$ cm", "$3\\sqrt{3}$ cm"]'::jsonb, '"$4\\sqrt{3}$ cm"'::jsonb, 'medium', '$s = 2h/\sqrt{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='regular_polygons'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Equilateral triangle height $6$ cm. Side? (use $h = \frac{\sqrt{3}}{2}s$)');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'L-shape: $8$ cm $\times$ $6$ cm rectangle minus $3$ cm $\times$ $2$ cm corner. Area?', 'multiple_choice', '["$42$ cm$^2$", "$48$ cm$^2$", "$36$ cm$^2$", "$54$ cm$^2$"]'::jsonb, '"$42$ cm$^2$"'::jsonb, 'medium', '$48-6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='L-shape: $8$ cm $\times$ $6$ cm rectangle minus $3$ cm $\times$ $2$ cm corner. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Shaded ring: outer radius $5$ cm, inner radius $3$ cm. Area?', 'multiple_choice', '["$16\\pi$ cm$^2$", "$25\\pi$ cm$^2$", "$9\\pi$ cm$^2$", "$8\\pi$ cm$^2$"]'::jsonb, '"$16\\pi$ cm$^2$"'::jsonb, 'hard', '$\pi(25-9)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Shaded ring: outer radius $5$ cm, inner radius $3$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Garden $20$ m $\times$ $15$ m with circular fountain radius $2$ m. Grass area?', 'multiple_choice', '["$300 - 4\\pi$ m$^2$", "$300$ m$^2$", "$4\\pi$ m$^2$", "$296$ m$^2$"]'::jsonb, '"$300 - 4\\pi$ m$^2$"'::jsonb, 'hard', 'Subtract circle from rectangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Garden $20$ m $\times$ $15$ m with circular fountain radius $2$ m. Grass area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cross shape: vertical bar $2$ cm $\times$ $12$ cm, horizontal $10$ cm $\times$ $2$ cm. Area?', 'multiple_choice', '["$44$ cm$^2$", "$40$ cm$^2$", "$24$ cm$^2$", "$52$ cm$^2$"]'::jsonb, '"$44$ cm$^2$"'::jsonb, 'hard', '$24+20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cross shape: vertical bar $2$ cm $\times$ $12$ cm, horizontal $10$ cm $\times$ $2$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trapezium field: parallel sides $40$ m and $60$ m, height $25$ m. Area?', 'multiple_choice', '["$1250$ m$^2$", "$2500$ m$^2$", "$1000$ m$^2$", "$1500$ m$^2$"]'::jsonb, '"$1250$ m$^2$"'::jsonb, 'hard', '$\frac{1}{2}(100)(25)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trapezium field: parallel sides $40$ m and $60$ m, height $25$ m. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Parallelogram base $20$ cm, height $8$ cm, slant $17$ cm. Area?', 'multiple_choice', '["$160$ cm$^2$", "$340$ cm$^2$", "$136$ cm$^2$", "$80$ cm$^2$"]'::jsonb, '"$160$ cm$^2$"'::jsonb, 'hard', 'Use height $8$, not slant $17$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Parallelogram base $20$ cm, height $8$ cm, slant $17$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rhombus diagonals $14$ cm and $20$ cm. Area?', 'multiple_choice', '["$140$ cm$^2$", "$280$ cm$^2$", "$70$ cm$^2$", "$34$ cm$^2$"]'::jsonb, '"$140$ cm$^2$"'::jsonb, 'hard', '$\frac{1}{2}(280)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='quadrilaterals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rhombus diagonals $14$ cm and $20$ cm. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Plot: square $12$ m with right triangle $6$ m $\times$ $8$ m attached. Total area?', 'multiple_choice', '["$168$ m$^2$", "$144$ m$^2$", "$120$ m$^2$", "$192$ m$^2$"]'::jsonb, '"$168$ m$^2$"'::jsonb, 'hard', '$144+24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='composite'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_quadrilaterals_polygons'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Plot: square $12$ m with right triangle $6$ m $\times$ $8$ m attached. Total area?');

-- ========== AREA OF PART OF A CIRCLE ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sector Area Concept', '{"blocks": [{"type": "heading", "content": "Sector of a Circle"}, {"type": "paragraph", "content": "A **sector** is a pizza-slice portion of a circle bounded by two radii and an arc."}, {"type": "math_block", "latex": "A_{\\text{sector}} = \\frac{\\theta}{360^\\circ} \\times \\pi r^2", "caption": "$\\theta$ is the angle at the centre in degrees"}, {"type": "callout", "variant": "key_point", "content": "Arc length $= \\frac{\\theta}{360} \\times 2\\pi r$."}, {"type": "example", "title": "Radius $6$ cm, angle $60^\\circ$. Sector area?", "steps": ["$A = \\frac{60}{360} \\times \\pi (36) = 6\\pi$ cm$^2$."], "answer": "$6\\pi$ cm$^2$"}, {"type": "question", "questionText": "Sector needs which measurements?", "questionType": "multiple_choice", "options": ["Radius and angle", "Diameter only", "Chord only", "Tangent"], "correctAnswer": "Radius and angle", "explanation": "Centre angle and radius."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'sector'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sector Area Concept');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating Sector Areas', '{"blocks": [{"type": "heading", "content": "Sector Calculations"}, {"type": "example", "title": "Radius $10$ cm, angle $90^\\circ$.", "steps": ["$A = \\frac{90}{360} \\times \\pi(100) = 25\\pi$ cm$^2$."], "answer": "$25\\pi$ cm$^2$"}, {"type": "example", "title": "Radius $7$ cm, angle $120^\\circ$.", "steps": ["$A = \\frac{120}{360} \\times 49\\pi = \\frac{49\\pi}{3}$ cm$^2$."], "answer": "$\\frac{49\\pi}{3}$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Use the angle at the **centre**, not at the circumference."}, {"type": "question", "questionText": "Radius $4$ cm, angle $180^\\circ$. Sector area?", "questionType": "multiple_choice", "options": ["$8\\pi$ cm$^2$", "$16\\pi$ cm$^2$", "$4\\pi$ cm$^2$", "$2\\pi$ cm$^2$"], "correctAnswer": "$8\\pi$ cm$^2$", "explanation": "Semicircle: half of $\\pi r^2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'sector'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating Sector Areas');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sector — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Sectors"}, {"type": "example", "title": "Clock face radius $14$ cm. Area swept from 12 to 3 o''clock?", "steps": ["Angle $90^\\circ$.", "$A = \\frac{1}{4}\\pi(196) = 49\\pi$ cm$^2$."], "answer": "$49\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Word problems: convert the situation to a centre angle first."}, {"type": "question", "questionText": "Full circle sector angle $360^\\circ$ gives area?", "questionType": "multiple_choice", "options": ["$\\pi r^2$", "$2\\pi r$", "$\\frac{\\pi r^2}{2}$", "$4\\pi r^2$"], "correctAnswer": "$\\pi r^2$", "explanation": "Whole circle."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'sector'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sector — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Segment Area Concept', '{"blocks": [{"type": "heading", "content": "Segment of a Circle"}, {"type": "paragraph", "content": "A **segment** is the region between a chord and its arc."}, {"type": "math_block", "latex": "A_{\\text{segment}} = A_{\\text{sector}} - A_{\\text{triangle}}", "caption": "Subtract the triangular part from the sector"}, {"type": "callout", "variant": "key_point", "content": "For a segment, find sector area first, then subtract the isosceles triangle formed by the two radii and the chord."}, {"type": "example", "title": "Radius $6$ cm, angle $90^\\circ$. Segment area?", "steps": ["Sector: $\\frac{1}{4}\\pi(36) = 9\\pi$.", "Triangle: $\\frac{1}{2}(6)(6) = 18$.", "Segment: $9\\pi - 18$ cm$^2$."], "answer": "$9\\pi - 18$ cm$^2$"}, {"type": "question", "questionText": "Segment area equals sector minus?", "questionType": "multiple_choice", "options": ["Triangle", "Rectangle", "Square", "Semicircle"], "correctAnswer": "Triangle", "explanation": "Chord-radii triangle."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'segment'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Segment Area Concept');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Working with Segments', '{"blocks": [{"type": "heading", "content": "Segment Calculations"}, {"type": "example", "title": "Radius $10$ cm, angle $60^\\circ$.", "steps": ["Sector: $\\frac{60}{360}\\pi(100) = \\frac{50\\pi}{3}$.", "Equilateral triangle area $\\frac{\\sqrt{3}}{4}(100)$.", "Subtract."], "answer": "Sector minus equilateral triangle"}, {"type": "callout", "variant": "warning", "content": "When angle is $60^\\circ$ and radii equal, the triangle is equilateral."}, {"type": "question", "questionText": "Minor segment always has angle less than?", "questionType": "multiple_choice", "options": ["$180^\\circ$", "$90^\\circ$", "$360^\\circ$", "$270^\\circ$"], "correctAnswer": "$180^\\circ$", "explanation": "Minor arc corresponds to angle $< 180^\\circ$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'segment'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Working with Segments');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Segment — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Segments"}, {"type": "example", "title": "Radius $8$ cm, angle $120^\\circ$. Segment area outline?", "steps": ["Sector $\\frac{120}{360}\\pi(64)$.", "Triangle $\\frac{1}{2}(8)(8)\\sin 120^\\circ$.", "Subtract triangle from sector."], "answer": "Use $\\frac{1}{2}ab\\sin C$ for triangle"}, {"type": "callout", "variant": "warning", "content": "Show sector and triangle areas separately for method marks."}, {"type": "question", "questionText": "Segment with angle $180^\\circ$ is a?", "questionType": "multiple_choice", "options": ["Semicircle", "Quadrant", "Full circle", "Ring"], "correctAnswer": "Semicircle", "explanation": "Diameter chord."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'segment'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Segment — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combining Circular and Rectilinear Areas', '{"blocks": [{"type": "heading", "content": "Combined Areas"}, {"type": "paragraph", "content": "Many KCSE figures combine rectangles, triangles, semicircles, sectors, and segments."}, {"type": "callout", "variant": "key_point", "content": "Label each part A, B, C… write an area equation, then substitute."}, {"type": "example", "title": "Window: rectangle $1$ m $\\times$ $0.5$ m topped by semicircle diameter $1$ m.", "steps": ["Rectangle: $0.5$ m$^2$.", "Semicircle: $\\frac{1}{2}\\pi(0.25) = \\frac{\\pi}{8}$ m$^2$.", "Total $= 0.5 + \\frac{\\pi}{8}$ m$^2$."], "answer": "$0.5 + \\frac{\\pi}{8}$ m$^2$"}, {"type": "question", "questionText": "Combined area problems: final step?", "questionType": "multiple_choice", "options": ["Add/subtract part areas", "Multiply all radii", "Average the parts", "Use perimeter only"], "correctAnswer": "Add/subtract part areas", "explanation": "Sum of simple areas."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combining Circular and Rectilinear Areas');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Shaded Regions with Circles', '{"blocks": [{"type": "heading", "content": "Shaded Circular Regions"}, {"type": "example", "title": "Square side $10$ cm with quarter-circle cut from one corner, radius $10$ cm.", "steps": ["Square: $100$ cm$^2$.", "Quarter circle: $\\frac{1}{4}\\pi(100) = 25\\pi$ cm$^2$.", "Remaining: $100 - 25\\pi$ cm$^2$."], "answer": "$100 - 25\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Check whether the figure uses a semicircle, quadrant, or general sector."}, {"type": "question", "questionText": "Running track: two semicircles radius $35$ m plus rectangle $100$ m $\\times$ $70$ m. Straight part area?", "questionType": "multiple_choice", "options": ["$7000$ m$^2$", "$3500$ m$^2$", "$14000$ m$^2$", "$2450\\pi$ m$^2$"], "correctAnswer": "$7000$ m$^2$", "explanation": "Rectangle only: $100 \\times 70$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Shaded Regions with Circles');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Combined Areas — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Combined Circle Areas"}, {"type": "example", "title": "Logo: circle radius $5$ cm with inner sector angle $90^\\circ$ removed.", "steps": ["Circle: $25\\pi$.", "Removed sector: $\\frac{1}{4}(25\\pi)$.", "Shaded $= \\frac{3}{4}(25\\pi) = \\frac{75\\pi}{4}$ cm$^2$."], "answer": "$\\frac{75\\pi}{4}$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Leave answers in terms of $\\pi$ unless the question asks for a decimal."}, {"type": "question", "questionText": "Annulus: outer $R=6$ cm, inner $r=4$ cm. Area?", "questionType": "multiple_choice", "options": ["$20\\pi$ cm$^2$", "$36\\pi$ cm$^2$", "$16\\pi$ cm$^2$", "$10\\pi$ cm$^2$"], "correctAnswer": "$20\\pi$ cm$^2$", "explanation": "$\\pi(36-16)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle' AND st.code = 'combined'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Combined Areas — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sector area formula (degrees)?', 'multiple_choice', '["$\\frac{\\theta}{360}\\pi r^2$", "$\\pi r^2$", "$2\\pi r$", "$\\frac{1}{2}\\pi r$"]'::jsonb, '"$\\frac{\\theta}{360}\\pi r^2$"'::jsonb, 'easy', 'Proportion of full circle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sector area formula (degrees)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $6$ cm, angle $90^\circ$. Sector area?', 'multiple_choice', '["$9\\pi$ cm$^2$", "$36\\pi$ cm$^2$", "$18\\pi$ cm$^2$", "$6\\pi$ cm$^2$"]'::jsonb, '"$9\\pi$ cm$^2$"'::jsonb, 'easy', '$\frac{1}{4}\pi(36)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $6$ cm, angle $90^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Angle $60^\circ$ is what fraction of a full turn?', 'multiple_choice', '["$\\frac{1}{6}$", "$\\frac{1}{3}$", "$\\frac{1}{4}$", "$\\frac{1}{2}$"]'::jsonb, '"$\\frac{1}{6}$"'::jsonb, 'easy', '$60/360$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Angle $60^\circ$ is what fraction of a full turn?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $5$ cm, angle $180^\circ$. Area?', 'multiple_choice', '["$\\frac{25\\pi}{2}$ cm$^2$", "$25\\pi$ cm$^2$", "$5\\pi$ cm$^2$", "$50\\pi$ cm$^2$"]'::jsonb, '"$\\frac{25\\pi}{2}$ cm$^2$"'::jsonb, 'easy', 'Semicircle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $5$ cm, angle $180^\circ$. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Arc length formula?', 'multiple_choice', '["$\\frac{\\theta}{360} \\times 2\\pi r$", "$\\pi r^2$", "$2\\pi r$", "$\\frac{1}{2}bh$"]'::jsonb, '"$\\frac{\\theta}{360} \\times 2\\pi r$"'::jsonb, 'easy', 'Fraction of circumference.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Arc length formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $8$ cm, angle $45^\circ$. Sector area?', 'multiple_choice', '["$2\\pi$ cm$^2$", "$8\\pi$ cm$^2$", "$16\\pi$ cm$^2$", "$4\\pi$ cm$^2$"]'::jsonb, '"$2\\pi$ cm$^2$"'::jsonb, 'easy', '$\frac{45}{360} = \frac{1}{8}$ of $\pi(64)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $8$ cm, angle $45^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $3$ cm, angle $120^\circ$. Sector area?', 'multiple_choice', '["$3\\pi$ cm$^2$", "$9\\pi$ cm$^2$", "$6\\pi$ cm$^2$", "$\\frac{3\\pi}{2}$ cm$^2$"]'::jsonb, '"$3\\pi$ cm$^2$"'::jsonb, 'easy', '$\frac{1}{3}\pi(9)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $3$ cm, angle $120^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Segment area = sector minus?', 'multiple_choice', '["Triangle", "Square", "Rectangle", "Trapezium"]'::jsonb, '"Triangle"'::jsonb, 'easy', 'Standard method.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Segment area = sector minus?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $10$ cm, angle $90^\circ$. Sector area?', 'multiple_choice', '["$25\\pi$ cm$^2$", "$50\\pi$ cm$^2$", "$100\\pi$ cm$^2$", "$5\\pi$ cm$^2$"]'::jsonb, '"$25\\pi$ cm$^2$"'::jsonb, 'medium', 'Quarter circle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $10$ cm, angle $90^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $6$ cm, angle $90^\circ$. Triangle area (two radii)?', 'multiple_choice', '["$18$ cm$^2$", "$36$ cm$^2$", "$9$ cm$^2$", "$12$ cm$^2$"]'::jsonb, '"$18$ cm$^2$"'::jsonb, 'medium', '$\frac{1}{2}(6)(6)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $6$ cm, angle $90^\circ$. Triangle area (two radii)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $6$ cm, angle $90^\circ$. Segment area?', 'multiple_choice', '["$9\\pi - 18$ cm$^2$", "$9\\pi$ cm$^2$", "$18$ cm$^2$", "$6\\pi$ cm$^2$"]'::jsonb, '"$9\\pi - 18$ cm$^2$"'::jsonb, 'medium', 'Sector minus triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $6$ cm, angle $90^\circ$. Segment area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $4$ cm, angle $60^\circ$. Sector area?', 'multiple_choice', '["$\\frac{8\\pi}{3}$ cm$^2$", "$16\\pi$ cm$^2$", "$8\\pi$ cm$^2$", "$\\frac{16\\pi}{3}$ cm$^2$"]'::jsonb, '"$\\frac{8\\pi}{3}$ cm$^2$"'::jsonb, 'medium', '$\frac{1}{6}\pi(16)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $4$ cm, angle $60^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle $6$ cm $\times$ $4$ cm plus semicircle diameter $6$ cm. Total area?', 'multiple_choice', '["$24 + \\frac{9\\pi}{2}$ cm$^2$", "$24$ cm$^2$", "$9\\pi$ cm$^2$", "$30$ cm$^2$"]'::jsonb, '"$24 + \\frac{9\\pi}{2}$ cm$^2$"'::jsonb, 'medium', 'Add semicircle on $6$ cm side.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle $6$ cm $\times$ $4$ cm plus semicircle diameter $6$ cm. Total area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square side $8$ cm, quarter circle radius $8$ cm removed from corner. Area?', 'multiple_choice', '["$64 - 16\\pi$ cm$^2$", "$64$ cm$^2$", "$16\\pi$ cm$^2$", "$48$ cm$^2$"]'::jsonb, '"$64 - 16\\pi$ cm$^2$"'::jsonb, 'medium', 'Subtract quadrant.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square side $8$ cm, quarter circle radius $8$ cm removed from corner. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Circle radius $7$ cm, square side $14$ cm inscribed. Shaded outside square?', 'multiple_choice', '["$49\\pi - 196$ cm$^2$", "$49\\pi$ cm$^2$", "$196$ cm$^2$", "$245$ cm$^2$"]'::jsonb, '"$49\\pi - 196$ cm$^2$"'::jsonb, 'medium', 'Circle minus square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Circle radius $7$ cm, square side $14$ cm inscribed. Shaded outside square?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $12$ cm, angle $150^\circ$. Sector area?', 'multiple_choice', '["$60\\pi$ cm$^2$", "$144\\pi$ cm$^2$", "$30\\pi$ cm$^2$", "$72\\pi$ cm$^2$"]'::jsonb, '"$60\\pi$ cm$^2$"'::jsonb, 'hard', '$\frac{150}{360}\pi(144)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $12$ cm, angle $150^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $10$ cm, angle $120^\circ$. Sector area?', 'multiple_choice', '["$\\frac{100\\pi}{3}$ cm$^2$", "$100\\pi$ cm$^2$", "$50\\pi$ cm$^2$", "$\\frac{50\\pi}{3}$ cm$^2$"]'::jsonb, '"$\\frac{100\\pi}{3}$ cm$^2$"'::jsonb, 'hard', '$\frac{1}{3}\pi(100)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $10$ cm, angle $120^\circ$. Sector area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Field: rectangle $40$ m $\times$ $25$ m with semicircular ends radius $12.5$ m (on $25$ m side). Total area?', 'multiple_choice', '["$1000 + \\frac{625\\pi}{8}$ m$^2$", "$1000$ m$^2$", "$625\\pi$ m$^2$", "$1250$ m$^2$"]'::jsonb, '"$1000 + \\frac{625\\pi}{8}$ m$^2$"'::jsonb, 'hard', 'Rectangle plus semicircle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Field: rectangle $40$ m $\times$ $25$ m with semicircular ends radius $12.5$ m (on $25$ m side). Total area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two equal circles radius $5$ cm overlap. Lens: two segments angle $60^\circ$ each. Strategy?', 'multiple_choice', '["Find segment area twice", "Use rectangle only", "Multiply radii", "Ignore overlap"]'::jsonb, '"Find segment area twice"'::jsonb, 'hard', 'Each segment from $60^\circ$ sector.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two equal circles radius $5$ cm overlap. Lens: two segments angle $60^\circ$ each. Strategy?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pizza slice: radius $18$ cm, angle $40^\circ$. Area?', 'multiple_choice', '["$36\\pi$ cm$^2$", "$324\\pi$ cm$^2$", "$18\\pi$ cm$^2$", "$72\\pi$ cm$^2$"]'::jsonb, '"$36\\pi$ cm$^2$"'::jsonb, 'hard', '$\frac{40}{360}\pi(324)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='sector'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pizza slice: radius $18$ cm, angle $40^\circ$. Area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Radius $14$ cm, angle $90^\circ$. Segment area?', 'multiple_choice', '["$49\\pi - 98$ cm$^2$", "$49\\pi$ cm$^2$", "$98$ cm$^2$", "$24.5\\pi$ cm$^2$"]'::jsonb, '"$49\\pi - 98$ cm$^2$"'::jsonb, 'hard', 'Quarter circle minus triangle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='segment'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Radius $14$ cm, angle $90^\circ$. Segment area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Badge: equilateral triangle side $6$ cm on each side of semicircle diameter $6$ cm. Total?', 'multiple_choice', '["$9\\sqrt{3} + \\frac{9\\pi}{2}$ cm$^2$", "$36$ cm$^2$", "$9\\pi$ cm$^2$", "$18$ cm$^2$"]'::jsonb, '"$9\\sqrt{3} + \\frac{9\\pi}{2}$ cm$^2$"'::jsonb, 'hard', 'Triangle plus semicircle.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='combined'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='area_part_circle'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Badge: equilateral triangle side $6$ cm on each side of semicircle diameter $6$ cm. Total?');

-- ========== SURFACE AREA OF SOLIDS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area of Prisms', '{"blocks": [{"type": "heading", "content": "Prisms"}, {"type": "paragraph", "content": "A **prism** has uniform cross-section. Surface area = sum of areas of all faces (two identical ends plus rectangles around the sides)."}, {"type": "math_block", "latex": "A_{\\text{cuboid}} = 2(lw + lh + wh)", "caption": "Cuboid with length $l$, width $w$, height $h$"}, {"type": "callout", "variant": "key_point", "content": "Draw a net: count each face once."}, {"type": "example", "title": "Cuboid $5$ cm $\\times$ $4$ cm $\\times$ $3$ cm.", "steps": ["Ends: $2(20) = 40$.", "Sides: $2(15) + 2(12) = 54$.", "Total $94$ cm$^2$."], "answer": "$94$ cm$^2$"}, {"type": "question", "questionText": "Prism surface area means?", "questionType": "multiple_choice", "options": ["Total area of all faces", "Volume only", "Perimeter of base", "Diagonal length"], "correctAnswer": "Total area of all faces", "explanation": "Sum of face areas."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'prisms_cylinders'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area of Prisms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area of Cylinders', '{"blocks": [{"type": "heading", "content": "Cylinders"}, {"type": "math_block", "latex": "A_{\\text{cylinder}} = 2\\pi r^2 + 2\\pi rh = 2\\pi r(r + h)", "caption": "Two circular ends plus curved surface"}, {"type": "example", "title": "Cylinder: radius $3$ cm, height $10$ cm.", "steps": ["Ends: $2\\pi(9) = 18\\pi$.", "Curved: $2\\pi(3)(10) = 60\\pi$.", "Total $78\\pi$ cm$^2$."], "answer": "$78\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Curved surface unwraps to a rectangle: width $= 2\\pi r$, height $= h$."}, {"type": "question", "questionText": "Cylinder curved surface area?", "questionType": "multiple_choice", "options": ["$2\\pi rh$", "$\\pi r^2$", "$\\pi rh$", "$2\\pi r$"], "correctAnswer": "$2\\pi rh$", "explanation": "Rectangle $2\\pi r \\times h$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'prisms_cylinders'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area of Cylinders');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prisms and Cylinders — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Prisms and Cylinders"}, {"type": "example", "title": "Open-top box $8$ cm $\\times$ $6$ cm $\\times$ $5$ cm. Outer surface area?", "steps": ["Base + four sides: $48 + 2(40) + 2(30) = 188$ cm$^2$."], "answer": "$188$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Open container: do not include the missing face."}, {"type": "question", "questionText": "Closed cylinder $r=4$ cm, $h=9$ cm. Total SA?", "questionType": "multiple_choice", "options": ["$104\\pi$ cm$^2$", "$72\\pi$ cm$^2$", "$32\\pi$ cm$^2$", "$36\\pi$ cm$^2$"], "correctAnswer": "$104\\pi$ cm$^2$", "explanation": "$2\\pi(16) + 2\\pi(36)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'prisms_cylinders'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prisms and Cylinders — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area of Pyramids', '{"blocks": [{"type": "heading", "content": "Pyramids"}, {"type": "paragraph", "content": "A **pyramid** has a polygon base and triangular faces meeting at the apex."}, {"type": "math_block", "latex": "A_{\\text{square pyramid}} = s^2 + 2s\\sqrt{\\left(\\frac{s}{2}\\right)^2 + h^2}", "caption": "Square base side $s$, slant height from apex to base edge"}, {"type": "callout", "variant": "key_point", "content": "Use **slant height** on triangular faces, not vertical height, unless the face is a right triangle."}, {"type": "example", "title": "Square pyramid: base $6$ cm, slant height $5$ cm.", "steps": ["Base: $36$.", "Four triangles: $4 \\times \\frac{1}{2}(6)(5) = 60$.", "Total $96$ cm$^2$."], "answer": "$96$ cm$^2$"}, {"type": "question", "questionText": "Pyramid lateral faces are?", "questionType": "multiple_choice", "options": ["Triangles", "Rectangles", "Circles", "Trapeziums only"], "correctAnswer": "Triangles", "explanation": "Triangular faces to apex."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'pyramids_cones'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area of Pyramids');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area of Cones', '{"blocks": [{"type": "heading", "content": "Cones"}, {"type": "math_block", "latex": "A_{\\text{cone}} = \\pi r^2 + \\pi r l", "caption": "$l$ = slant height; $\\pi r l$ is curved surface"}, {"type": "example", "title": "Cone: radius $3$ cm, slant height $5$ cm.", "steps": ["Base: $9\\pi$.", "Curved: $15\\pi$.", "Total $24\\pi$ cm$^2$."], "answer": "$24\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Find slant height with $l = \\sqrt{r^2 + h^2}$ when given $r$ and vertical $h$."}, {"type": "question", "questionText": "Cone curved surface area?", "questionType": "multiple_choice", "options": ["$\\pi r l$", "$2\\pi r l$", "$\\pi r^2$", "$\\pi r h$"], "correctAnswer": "$\\pi r l$", "explanation": "Half the cone net sector."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'pyramids_cones'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area of Cones');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pyramids and Cones — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Pyramids and Cones"}, {"type": "example", "title": "Cone $r=6$ cm, $h=8$ cm. Find $l$ then SA.", "steps": ["$l = \\sqrt{36+64} = 10$ cm.", "$SA = 36\\pi + 60\\pi = 96\\pi$ cm$^2$."], "answer": "$96\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Show Pythagoras step for $l$ — method marks."}, {"type": "question", "questionText": "Square pyramid base $10$ cm, slant edge $13$ cm to midpoint of side. Triangle area each?", "questionType": "multiple_choice", "options": ["$65$ cm$^2$", "$130$ cm$^2$", "$50$ cm$^2$", "$120$ cm$^2$"], "correctAnswer": "$65$ cm$^2$", "explanation": "$\\frac{1}{2}(10)(13)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'pyramids_cones'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pyramids and Cones — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Surface Area of Spheres', '{"blocks": [{"type": "heading", "content": "Spheres"}, {"type": "math_block", "latex": "A_{\\text{sphere}} = 4\\pi r^2", "caption": "Same as area of four great circles"}, {"type": "callout", "variant": "key_point", "content": "A hemisphere includes the flat circular face: $SA = 2\\pi r^2 + \\pi r^2 = 3\\pi r^2$."}, {"type": "example", "title": "Sphere radius $5$ cm.", "steps": ["$A = 4\\pi(25) = 100\\pi$ cm$^2$."], "answer": "$100\\pi$ cm$^2$"}, {"type": "question", "questionText": "Sphere SA formula?", "questionType": "multiple_choice", "options": ["$4\\pi r^2$", "$\\frac{4}{3}\\pi r^3$", "$2\\pi r$", "$\\pi r^2$"], "correctAnswer": "$4\\pi r^2$", "explanation": "Standard formula."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'spheres'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Surface Area of Spheres');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Hemispheres and Composite SA', '{"blocks": [{"type": "heading", "content": "Hemispheres"}, {"type": "example", "title": "Hemisphere radius $7$ cm (closed, including base).", "steps": ["Curved: $2\\pi(49) = 98\\pi$.", "Base: $49\\pi$.", "Total $147\\pi$ cm$^2$."], "answer": "$147\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Open hemisphere (no base) uses only $2\\pi r^2$."}, {"type": "question", "questionText": "Hemisphere curved area only?", "questionType": "multiple_choice", "options": ["$2\\pi r^2$", "$4\\pi r^2$", "$3\\pi r^2$", "$\\pi r^2$"], "correctAnswer": "$2\\pi r^2$", "explanation": "Half the sphere."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'spheres'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Hemispheres and Composite SA');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Spheres — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Spheres"}, {"type": "example", "title": "Solid: cylinder radius $4$ cm, height $10$ cm, topped by hemisphere radius $4$ cm.", "steps": ["Cylinder SA (no top): $2\\pi(16) + 2\\pi(40) = 112\\pi$.", "Add hemisphere curved $32\\pi$.", "Total $144\\pi$ cm$^2$."], "answer": "$144\\pi$ cm$^2$"}, {"type": "callout", "variant": "warning", "content": "Composite solids: only count exposed surfaces."}, {"type": "question", "questionText": "Sphere diameter $12$ cm. Surface area?", "questionType": "multiple_choice", "options": ["$144\\pi$ cm$^2$", "$36\\pi$ cm$^2$", "$288\\pi$ cm$^2$", "$72\\pi$ cm$^2$"], "correctAnswer": "$144\\pi$ cm$^2$", "explanation": "$r=6$; $4\\pi(36)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids' AND st.code = 'spheres'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Spheres — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid SA: $2(lw+lh+wh)$ counts?', 'multiple_choice', '["All six faces", "Four faces only", "Two faces", "Volume"]'::jsonb, '"All six faces"'::jsonb, 'easy', 'Closed cuboid.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid SA: $2(lw+lh+wh)$ counts?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder radius $5$ cm, height $8$ cm. Curved SA?', 'multiple_choice', '["$80\\pi$ cm$^2$", "$40\\pi$ cm$^2$", "$25\\pi$ cm$^2$", "$50\\pi$ cm$^2$"]'::jsonb, '"$80\\pi$ cm$^2$"'::jsonb, 'easy', '$2\pi(5)(8)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder radius $5$ cm, height $8$ cm. Curved SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube edge $4$ cm. Total SA?', 'multiple_choice', '["$96$ cm$^2$", "$64$ cm$^2$", "$48$ cm$^2$", "$16$ cm$^2$"]'::jsonb, '"$96$ cm$^2$"'::jsonb, 'easy', '$6 \times 16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube edge $4$ cm. Total SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder base area?', 'multiple_choice', '["$\\pi r^2$", "$2\\pi r$", "$2\\pi rh$", "$\\pi r l$"]'::jsonb, '"$\\pi r^2$"'::jsonb, 'easy', 'One circular end.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder base area?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Open cylinder (no top): SA includes?', 'multiple_choice', '["Base + curved only", "Two bases + curved", "Curved only", "Two bases only"]'::jsonb, '"Base + curved only"'::jsonb, 'easy', 'Missing top face.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Open cylinder (no top): SA includes?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Triangular prism: faces include?', 'multiple_choice', '["Two triangles + three rectangles", "Six squares", "One circle", "Four triangles"]'::jsonb, '"Two triangles + three rectangles"'::jsonb, 'easy', 'Standard triangular prism.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Triangular prism: faces include?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder $r=3$, $h=7$. Total closed SA?', 'multiple_choice', '["$60\\pi$ cm$^2$", "$42\\pi$ cm$^2$", "$18\\pi$ cm$^2$", "$21\\pi$ cm$^2$"]'::jsonb, '"$60\\pi$ cm$^2$"'::jsonb, 'easy', '$18\pi + 42\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder $r=3$, $h=7$. Total closed SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone SA formula?', 'multiple_choice', '["$\\pi r^2 + \\pi r l$", "$\\pi r l$ only", "$2\\pi r^2$", "$\\frac{1}{3}\\pi r^2 h$"]'::jsonb, '"$\\pi r^2 + \\pi r l$"'::jsonb, 'easy', 'Base plus curved.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone SA formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone $r=3$, $l=5$. Total SA?', 'multiple_choice', '["$24\\pi$ cm$^2$", "$15\\pi$ cm$^2$", "$9\\pi$ cm$^2$", "$30\\pi$ cm$^2$"]'::jsonb, '"$24\\pi$ cm$^2$"'::jsonb, 'medium', '$9\pi + 15\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone $r=3$, $l=5$. Total SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone $r=6$, $h=8$. Slant height?', 'multiple_choice', '["$10$ cm", "$14$ cm", "$48$ cm", "$2$ cm"]'::jsonb, '"$10$ cm"'::jsonb, 'medium', '$\sqrt{36+64}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone $r=6$, $h=8$. Slant height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square pyramid base $8$ cm, slant height $6$ cm. Lateral SA?', 'multiple_choice', '["$96$ cm$^2$", "$64$ cm$^2$", "$48$ cm$^2$", "$192$ cm$^2$"]'::jsonb, '"$96$ cm$^2$"'::jsonb, 'medium', 'Four triangles: $4 \times \frac{1}{2}(8)(6)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square pyramid base $8$ cm, slant height $6$ cm. Lateral SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder radius $7$ cm, height $5$ cm. Total closed SA?', 'multiple_choice', '["$168\\pi$ cm$^2$", "$70\\pi$ cm$^2$", "$98\\pi$ cm$^2$", "$35\\pi$ cm$^2$"]'::jsonb, '"$168\\pi$ cm$^2$"'::jsonb, 'medium', '$2\pi(49) + 2\pi(35)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder radius $7$ cm, height $5$ cm. Total closed SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sphere radius $4$ cm. SA?', 'multiple_choice', '["$64\\pi$ cm$^2$", "$16\\pi$ cm$^2$", "$\\frac{256\\pi}{3}$ cm$^2$", "$32\\pi$ cm$^2$"]'::jsonb, '"$64\\pi$ cm$^2$"'::jsonb, 'medium', '$4\pi(16)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sphere radius $4$ cm. SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hemisphere radius $5$ cm including base. SA?', 'multiple_choice', '["$75\\pi$ cm$^2$", "$50\\pi$ cm$^2$", "$100\\pi$ cm$^2$", "$25\\pi$ cm$^2$"]'::jsonb, '"$75\\pi$ cm$^2$"'::jsonb, 'medium', '$50\pi + 25\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hemisphere radius $5$ cm including base. SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid $10$ cm $\times$ $6$ cm $\times$ $4$ cm. SA?', 'multiple_choice', '["$248$ cm$^2$", "$240$ cm$^2$", "$124$ cm$^2$", "$200$ cm$^2$"]'::jsonb, '"$248$ cm$^2$"'::jsonb, 'medium', '$2(60+40+24)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid $10$ cm $\times$ $6$ cm $\times$ $4$ cm. SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone $r=5$, $h=12$. Total SA?', 'multiple_choice', '["$90\\pi$ cm$^2$", "$65\\pi$ cm$^2$", "$25\\pi$ cm$^2$", "$60\\pi$ cm$^2$"]'::jsonb, '"$90\\pi$ cm$^2$"'::jsonb, 'hard', '$l=13$; $25\pi + 65\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone $r=5$, $h=12$. Total SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pipe internal $r=2$ cm, external $R=3$ cm, length $50$ cm. Curved SA (both surfaces)?', 'multiple_choice', '["$500\\pi$ cm$^2$", "$300\\pi$ cm$^2$", "$200\\pi$ cm$^2$", "$100\\pi$ cm$^2$"]'::jsonb, '"$500\\pi$ cm$^2$"'::jsonb, 'hard', '$2\pi(3)(50) + 2\pi(2)(50)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pipe internal $r=2$ cm, external $R=3$ cm, length $50$ cm. Curved SA (both surfaces)?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hemisphere open at top (no base). SA?', 'multiple_choice', '["$50\\pi$ cm$^2$ for $r=5$", "$75\\pi$ cm$^2$", "$25\\pi$ cm$^2$", "$100\\pi$ cm$^2$"]'::jsonb, '"$50\\pi$ cm$^2$ for $r=5$"'::jsonb, 'hard', 'Curved only: $2\pi(25)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hemisphere open at top (no base). SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frustum of cone: strategy for SA?', 'multiple_choice', '["Add/subtract exposed faces of parts", "Use volume formula", "Multiply radius by height only", "Ignore slant height"]'::jsonb, '"Add/subtract exposed faces of parts"'::jsonb, 'hard', 'Composite or net method.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frustum of cone: strategy for SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder with hemisphere on one end $r=4$, $h=10$. Exposed SA?', 'multiple_choice', '["$112\\pi$ cm$^2$", "$144\\pi$ cm$^2$", "$80\\pi$ cm$^2$", "$96\\pi$ cm$^2$"]'::jsonb, '"$112\\pi$ cm$^2$"'::jsonb, 'hard', 'Cylinder minus one base plus hemisphere curved.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder with hemisphere on one end $r=4$, $h=10$. Exposed SA?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube SA $150$ cm$^2$. Edge length?', 'multiple_choice', '["$5$ cm", "$25$ cm", "$6$ cm", "$10$ cm"]'::jsonb, '"$5$ cm"'::jsonb, 'hard', '$6e^2 = 150$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube SA $150$ cm$^2$. Edge length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sphere SA $196\pi$ cm$^2$. Radius?', 'multiple_choice', '["$7$ cm", "$14$ cm", "$49$ cm", "$3.5$ cm"]'::jsonb, '"$7$ cm"'::jsonb, 'hard', '$4\pi r^2 = 196\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sphere SA $196\pi$ cm$^2$. Radius?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square pyramid base $12$ cm, slant height $10$ cm. Total SA?', 'multiple_choice', '["$384$ cm$^2$", "$240$ cm$^2$", "$144$ cm$^2$", "$480$ cm$^2$"]'::jsonb, '"$384$ cm$^2$"'::jsonb, 'hard', '$144 + 4(60)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='surface_area_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square pyramid base $12$ cm, slant height $10$ cm. Total SA?');

-- ========== VOLUME OF SOLIDS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Prisms', '{"blocks": [{"type": "heading", "content": "Prism Volume"}, {"type": "math_block", "latex": "V_{\\text{prism}} = A_{\\text{cross-section}} \\times h", "caption": "Uniform cross-section times length/height"}, {"type": "callout", "variant": "key_point", "content": "Cuboid: $V = lwh$. Cylinder is a prism with circular cross-section."}, {"type": "example", "title": "Cuboid $6$ cm $\\times$ $4$ cm $\\times$ $5$ cm.", "steps": ["$V = 120$ cm$^3$."], "answer": "$120$ cm$^3$"}, {"type": "question", "questionText": "Prism volume equals?", "questionType": "multiple_choice", "options": ["Cross-section area $\\times$ length", "Surface area $\\times$ 2", "$\\pi r^2 h$ only", "Sum of edges"], "correctAnswer": "Cross-section area $\\times$ length", "explanation": "Uniform cross-section."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'prisms_cylinders_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Prisms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Cylinders', '{"blocks": [{"type": "heading", "content": "Cylinder Volume"}, {"type": "math_block", "latex": "V_{\\text{cylinder}} = \\pi r^2 h"}, {"type": "example", "title": "Cylinder $r=4$ cm, $h=10$ cm.", "steps": ["$V = \\pi(16)(10) = 160\\pi$ cm$^3$."], "answer": "$160\\pi$ cm$^3$"}, {"type": "callout", "variant": "warning", "content": "Use radius, not diameter, in $\\pi r^2 h$."}, {"type": "question", "questionText": "Cylinder diameter $6$ cm, height $5$ cm. Volume?", "questionType": "multiple_choice", "options": ["$45\\pi$ cm$^3$", "$90\\pi$ cm$^3$", "$30\\pi$ cm$^3$", "$180\\pi$ cm$^3$"], "correctAnswer": "$45\\pi$ cm$^3$", "explanation": "$r=3$; $\\pi(9)(5)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'prisms_cylinders_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Cylinders');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prisms and Cylinders Volume — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Prism and Cylinder Volume"}, {"type": "example", "title": "Water tank cylinder $r=1.4$ m, $h=3$ m. Capacity in m$^3$?", "steps": ["$V = \\pi(1.96)(3) = 5.88\\pi \\approx 18.5$ m$^3$."], "answer": "$5.88\\pi$ m$^3$"}, {"type": "callout", "variant": "warning", "content": "Capacity questions may ask for litres: $1$ m$^3 = 1000$ L."}, {"type": "question", "questionText": "Triangular prism: triangle base area $12$ cm$^2$, length $15$ cm. Volume?", "questionType": "multiple_choice", "options": ["$180$ cm$^3$", "$27$ cm$^3$", "$90$ cm$^3$", "$360$ cm$^3$"], "correctAnswer": "$180$ cm$^3$", "explanation": "$12 \\times 15$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'prisms_cylinders_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prisms and Cylinders Volume — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Pyramids', '{"blocks": [{"type": "heading", "content": "Pyramid Volume"}, {"type": "math_block", "latex": "V_{\\text{pyramid}} = \\frac{1}{3} \\times A_{\\text{base}} \\times h", "caption": "One-third of prism with same base and height"}, {"type": "example", "title": "Square pyramid: base side $6$ cm, height $9$ cm.", "steps": ["Base area $36$.", "$V = \\frac{1}{3}(36)(9) = 108$ cm$^3$."], "answer": "$108$ cm$^3$"}, {"type": "callout", "variant": "key_point", "content": "Pyramid volume is exactly $\\frac{1}{3}$ of the enclosing prism."}, {"type": "question", "questionText": "Pyramid volume factor vs prism?", "questionType": "multiple_choice", "options": ["$\\frac{1}{3}$", "$\\frac{1}{2}$", "$2$", "$3$"], "correctAnswer": "$\\frac{1}{3}$", "explanation": "Standard relationship."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'pyramids_cones_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Pyramids');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Cones', '{"blocks": [{"type": "heading", "content": "Cone Volume"}, {"type": "math_block", "latex": "V_{\\text{cone}} = \\frac{1}{3}\\pi r^2 h"}, {"type": "example", "title": "Cone $r=3$ cm, $h=12$ cm.", "steps": ["$V = \\frac{1}{3}\\pi(9)(12) = 36\\pi$ cm$^3$."], "answer": "$36\\pi$ cm$^3$"}, {"type": "callout", "variant": "warning", "content": "$h$ is the perpendicular height from apex to base, not slant height $l$."}, {"type": "question", "questionText": "Cone $r=6$, $h=4$. Volume?", "questionType": "multiple_choice", "options": ["$48\\pi$ cm$^3$", "$144\\pi$ cm$^3$", "$24\\pi$ cm$^3$", "$96\\pi$ cm$^3$"], "correctAnswer": "$48\\pi$ cm$^3$", "explanation": "$\\frac{1}{3}\\pi(36)(4)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'pyramids_cones_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Cones');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Pyramids and Cones Volume — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Pyramid and Cone Volume"}, {"type": "example", "title": "Conical heap of grain: diameter $4$ m, height $3$ m.", "steps": ["$r=2$.", "$V = \\frac{1}{3}\\pi(4)(3) = 4\\pi$ m$^3$."], "answer": "$4\\pi$ m$^3$"}, {"type": "callout", "variant": "warning", "content": "Frustum volume = large cone minus small cone removed."}, {"type": "question", "questionText": "Pyramid base $10$ cm $\\times$ $10$ cm, height $15$ cm. Volume?", "questionType": "multiple_choice", "options": ["$500$ cm$^3$", "$1500$ cm$^3$", "$250$ cm$^3$", "$750$ cm$^3$"], "correctAnswer": "$500$ cm$^3$", "explanation": "$\\frac{1}{3}(100)(15)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'pyramids_cones_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Pyramids and Cones Volume — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume of Spheres', '{"blocks": [{"type": "heading", "content": "Sphere Volume"}, {"type": "math_block", "latex": "V_{\\text{sphere}} = \\frac{4}{3}\\pi r^3"}, {"type": "callout", "variant": "key_point", "content": "Hemisphere volume (solid): $V = \\frac{2}{3}\\pi r^3$."}, {"type": "example", "title": "Sphere radius $3$ cm.", "steps": ["$V = \\frac{4}{3}\\pi(27) = 36\\pi$ cm$^3$."], "answer": "$36\\pi$ cm$^3$"}, {"type": "question", "questionText": "Sphere volume formula?", "questionType": "multiple_choice", "options": ["$\\frac{4}{3}\\pi r^3$", "$4\\pi r^2$", "$\\pi r^2 h$", "$\\frac{1}{3}\\pi r^2 h$"], "correctAnswer": "$\\frac{4}{3}\\pi r^3$", "explanation": "Standard formula."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'spheres_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume of Spheres');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Hemispheres and Composite Volume', '{"blocks": [{"type": "heading", "content": "Composite Volumes"}, {"type": "example", "title": "Solid hemisphere radius $6$ cm on cylinder $r=6$, $h=10$ cm.", "steps": ["Hemisphere: $\\frac{2}{3}\\pi(216) = 144\\pi$.", "Cylinder: $\\pi(36)(10) = 360\\pi$.", "Total $504\\pi$ cm$^3$."], "answer": "$504\\pi$ cm$^3$"}, {"type": "callout", "variant": "warning", "content": "Add volumes of parts; for hollow solids subtract inner volume."}, {"type": "question", "questionText": "Hemisphere radius $3$ cm. Volume?", "questionType": "multiple_choice", "options": ["$18\\pi$ cm$^3$", "$36\\pi$ cm$^3$", "$9\\pi$ cm$^3$", "$27\\pi$ cm$^3$"], "correctAnswer": "$18\\pi$ cm$^3$", "explanation": "$\\frac{2}{3}\\pi(27)$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'spheres_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Hemispheres and Composite Volume');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Volume — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Volume of Solids"}, {"type": "example", "title": "Frustum: cone height $12$ cm, top radius $2$ cm, bottom $5$ cm. Method?", "steps": ["Volume large cone minus small cone cut off.", "Use similar triangles to find removed cone height."], "answer": "Subtract cone volumes"}, {"type": "callout", "variant": "warning", "content": "Always sketch and label $r$, $R$, $h$ on frustums."}, {"type": "question", "questionText": "Sphere diameter $10$ cm. Volume?", "questionType": "multiple_choice", "options": ["$\\frac{500\\pi}{3}$ cm$^3$", "$\\frac{250\\pi}{3}$ cm$^3$", "$500\\pi$ cm$^3$", "$100\\pi$ cm$^3$"], "correctAnswer": "$\\frac{500\\pi}{3}$ cm$^3$", "explanation": "$r=5$; $\\frac{4}{3}\\pi(125)$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids' AND st.code = 'spheres_vol'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Volume — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid volume formula?', 'multiple_choice', '["$lwh$", "$2(l+w)$", "$lw+h$", "$\\pi r^2 h$"]'::jsonb, '"$lwh$"'::jsonb, 'easy', 'Product of three dimensions.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid volume formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder volume?', 'multiple_choice', '["$\\pi r^2 h$", "$2\\pi rh$", "$\\frac{4}{3}\\pi r^3$", "$\\pi r l$"]'::jsonb, '"$\\pi r^2 h$"'::jsonb, 'easy', 'Base area times height.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cube edge $3$ cm. Volume?', 'multiple_choice', '["$27$ cm$^3$", "$9$ cm$^3$", "$18$ cm$^3$", "$54$ cm$^3$"]'::jsonb, '"$27$ cm$^3$"'::jsonb, 'easy', '$3^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cube edge $3$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder $r=2$, $h=10$. Volume?', 'multiple_choice', '["$40\\pi$ cm$^3$", "$20\\pi$ cm$^3$", "$4\\pi$ cm$^3$", "$80\\pi$ cm$^3$"]'::jsonb, '"$40\\pi$ cm$^3$"'::jsonb, 'easy', '$\pi(4)(10)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder $r=2$, $h=10$. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Prism volume uses?', 'multiple_choice', '["Constant cross-section", "Slant height only", "Surface area", "Perimeter"]'::jsonb, '"Constant cross-section"'::jsonb, 'easy', 'Area of end times length.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Prism volume uses?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid $5 \times 4 \times 2$ cm. Volume?', 'multiple_choice', '["$40$ cm$^3$", "$20$ cm$^3$", "$80$ cm$^3$", "$11$ cm$^3$"]'::jsonb, '"$40$ cm$^3$"'::jsonb, 'easy', '$5 \times 4 \times 2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid $5 \times 4 \times 2$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cylinder volume $100\pi$ cm$^3$, $r=5$ cm. Height?', 'multiple_choice', '["$4$ cm", "$5$ cm", "$10$ cm", "$20$ cm"]'::jsonb, '"$4$ cm"'::jsonb, 'easy', '$h = V/(\pi r^2)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cylinder volume $100\pi$ cm$^3$, $r=5$ cm. Height?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pyramid volume formula?', 'multiple_choice', '["$\\frac{1}{3}Ah$", "$Ah$", "$\\frac{1}{2}Ah$", "$\\frac{1}{3}\\pi r^2 h$"]'::jsonb, '"$\\frac{1}{3}Ah$"'::jsonb, 'easy', 'One-third of prism.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pyramid volume formula?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone volume?', 'multiple_choice', '["$\\frac{1}{3}\\pi r^2 h$", "$\\pi r^2 h$", "$\\frac{1}{3}\\pi r l$", "$2\\pi r^2 h$"]'::jsonb, '"$\\frac{1}{3}\\pi r^2 h$"'::jsonb, 'medium', 'One-third of cylinder.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone $r=3$, $h=9$. Volume?', 'multiple_choice', '["$27\\pi$ cm$^3$", "$81\\pi$ cm$^3$", "$9\\pi$ cm$^3$", "$54\\pi$ cm$^3$"]'::jsonb, '"$27\\pi$ cm$^3$"'::jsonb, 'medium', '$\frac{1}{3}\pi(9)(9)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone $r=3$, $h=9$. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Square pyramid base area $25$ cm$^2$, $h=6$ cm. Volume?', 'multiple_choice', '["$50$ cm$^3$", "$150$ cm$^3$", "$75$ cm$^3$", "$25$ cm$^3$"]'::jsonb, '"$50$ cm$^3$"'::jsonb, 'medium', '$\frac{1}{3}(25)(6)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Square pyramid base area $25$ cm$^2$, $h=6$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cuboid volume $120$ cm$^3$, base $10$ cm$^2$. Length?', 'multiple_choice', '["$12$ cm", "$10$ cm", "$110$ cm", "$20$ cm"]'::jsonb, '"$12$ cm"'::jsonb, 'medium', '$V = Ah$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cuboid volume $120$ cm$^3$, base $10$ cm$^2$. Length?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sphere volume $r=3$ cm?', 'multiple_choice', '["$36\\pi$ cm$^3$", "$27\\pi$ cm$^3$", "$12\\pi$ cm$^3$", "$9\\pi$ cm$^3$"]'::jsonb, '"$36\\pi$ cm$^3$"'::jsonb, 'medium', '$\frac{4}{3}\pi(27)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sphere volume $r=3$ cm?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hemisphere $r=6$ cm. Volume?', 'multiple_choice', '["$144\\pi$ cm$^3$", "$288\\pi$ cm$^3$", "$72\\pi$ cm$^3$", "$216\\pi$ cm$^3$"]'::jsonb, '"$144\\pi$ cm$^3$"'::jsonb, 'medium', '$\frac{2}{3}\pi(216)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hemisphere $r=6$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tank cylinder $r=0.7$ m, $h=2$ m. Volume in litres?', 'multiple_choice', '["$3079$ L approx", "$1000$ L", "$1400$ L", "$6158$ L"]'::jsonb, '"$3079$ L approx"'::jsonb, 'medium', '$\pi(0.49)(2) \times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tank cylinder $r=0.7$ m, $h=2$ m. Volume in litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cone diameter $8$ cm, $h=6$ cm. Volume?', 'multiple_choice', '["$32\\pi$ cm$^3$", "$96\\pi$ cm$^3$", "$16\\pi$ cm$^3$", "$64\\pi$ cm$^3$"]'::jsonb, '"$32\\pi$ cm$^3$"'::jsonb, 'hard', '$r=4$; $\frac{1}{3}\pi(16)(6)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cone diameter $8$ cm, $h=6$ cm. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Metal ball radius $9$ cm melted into cone $r=6$, $h=18$ cm. Same volume?', 'multiple_choice', '["Yes", "No", "Cone larger", "Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'hard', 'Both $= 216\pi$ cm$^3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Metal ball radius $9$ cm melted into cone $r=6$, $h=18$ cm. Same volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Hollow cylinder $R=5$, $r=3$, $h=10$. Volume of material?', 'multiple_choice', '["$160\\pi$ cm$^3$", "$250\\pi$ cm$^3$", "$90\\pi$ cm$^3$", "$100\\pi$ cm$^3$"]'::jsonb, '"$160\\pi$ cm$^3$"'::jsonb, 'hard', '$\pi(25-9)(10)$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Hollow cylinder $R=5$, $r=3$, $h=10$. Volume of material?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Frustum: full cone $h=12$, $R=6$; top cut $h=4$. Volume frustum?', 'multiple_choice', '["$128\\pi$ cm$^3$", "$144\\pi$ cm$^3$", "$96\\pi$ cm$^3$", "$192\\pi$ cm$^3$"]'::jsonb, '"$128\\pi$ cm$^3$"'::jsonb, 'hard', 'Large minus small similar cone.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Frustum: full cone $h=12$, $R=6$; top cut $h=4$. Volume frustum?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Sphere volume $288\pi$ cm$^3$. Radius?', 'multiple_choice', '["$6$ cm", "$4$ cm", "$8$ cm", "$12$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'hard', '$r^3 = 216$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Sphere volume $288\pi$ cm$^3$. Radius?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Water fills cuboid $2$ m $\times$ $1.5$ m $\times$ $0.4$ m. Litres?', 'multiple_choice', '["$1200$ L", "$12$ L", "$120$ L", "$12000$ L"]'::jsonb, '"$1200$ L"'::jsonb, 'hard', '$1.2$ m$^3 \times 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prisms_cylinders_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Water fills cuboid $2$ m $\times$ $1.5$ m $\times$ $0.4$ m. Litres?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solid: cylinder $r=4$, $h=6$ plus hemisphere $r=4$. Volume?', 'multiple_choice', '["$224\\pi$ cm$^3$", "$160\\pi$ cm$^3$", "$96\\pi$ cm$^3$", "$256\\pi$ cm$^3$"]'::jsonb, '"$224\\pi$ cm$^3$"'::jsonb, 'hard', '$96\pi + \frac{128\pi}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='spheres_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solid: cylinder $r=4$, $h=6$ plus hemisphere $r=4$. Volume?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pyramid same base and height as cylinder $r=3$, $h=8$. Pyramid volume?', 'multiple_choice', '["$24\\pi$ cm$^3$", "$72\\pi$ cm$^3$", "$8\\pi$ cm$^3$", "$216\\pi$ cm$^3$"]'::jsonb, '"$24\\pi$ cm$^3$"'::jsonb, 'hard', '$\frac{1}{3}$ of $72\pi$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='pyramids_cones_vol'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='volume_solids'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pyramid same base and height as cylinder $r=3$, $h=8$. Pyramid volume?');

-- ========== QUADRATIC EXPRESSIONS AND EQUATIONS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding Binomial Products', '{"blocks": [{"type": "heading", "content": "Expanding $(a+b)(c+d)$"}, {"type": "paragraph", "content": "Use the **FOIL** pattern or grid method: every term in the first bracket multiplies every term in the second."}, {"type": "math_block", "latex": "(x+a)(x+b) = x^2 + (a+b)x + ab"}, {"type": "callout", "variant": "key_point", "content": "For $(x+a)^2$: $x^2 + 2ax + a^2$ — do not forget the middle term $2ax$."}, {"type": "example", "title": "Expand $(x+3)(x+5)$.", "steps": ["$x^2 + 5x + 3x + 15$.", "$x^2 + 8x + 15$."], "answer": "$x^2 + 8x + 15$"}, {"type": "question", "questionText": "Expand $(x+2)(x+4)$.", "questionType": "multiple_choice", "options": ["$x^2+6x+8$", "$x^2+8x+6$", "$x^2+2x+8$", "$2x^2+6x+8$"], "correctAnswer": "$x^2+6x+8$", "explanation": "FOIL."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'expansion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding Binomial Products');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding with Negatives', '{"blocks": [{"type": "heading", "content": "Negative Terms in Expansion"}, {"type": "example", "title": "Expand $(x-4)(x+7)$.", "steps": ["$x^2 + 7x - 4x - 28$.", "$x^2 + 3x - 28$."], "answer": "$x^2 + 3x - 28$"}, {"type": "example", "title": "Expand $(2x+1)(x-3)$.", "steps": ["$2x^2 - 6x + x - 3$.", "$2x^2 - 5x - 3$."], "answer": "$2x^2 - 5x - 3$"}, {"type": "callout", "variant": "warning", "content": "$(x-3)^2 = x^2 - 6x + 9$, not $x^2 - 9$."}, {"type": "question", "questionText": "Expand $(x-5)^2$.", "questionType": "multiple_choice", "options": ["$x^2-10x+25$", "$x^2-25$", "$x^2+10x+25$", "$x^2-5x+25$"], "correctAnswer": "$x^2-10x+25$", "explanation": "Perfect square."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'expansion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding with Negatives');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expansion — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Expansion"}, {"type": "example", "title": "Expand $(3x-2)(2x+5)$.", "steps": ["$6x^2 + 15x - 4x - 10$.", "$6x^2 + 11x - 10$."], "answer": "$6x^2 + 11x - 10$"}, {"type": "callout", "variant": "warning", "content": "Check signs when multiplying negatives."}, {"type": "question", "questionText": "Expand $(x+9)(x-9)$.", "questionType": "multiple_choice", "options": ["$x^2-81$", "$x^2+81$", "$x^2-18x+81$", "$2x^2-81$"], "correctAnswer": "$x^2-81$", "explanation": "Difference of squares."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'expansion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expansion — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Factorising by Common Factor', '{"blocks": [{"type": "heading", "content": "Common Factor"}, {"type": "paragraph", "content": "Factorisation reverses expansion. First step: take out the **highest common factor** (HCF)."}, {"type": "example", "title": "Factorise $6x^2 + 9x$.", "steps": ["HCF $3x$.", "$3x(2x + 3)$."], "answer": "$3x(2x+3)$"}, {"type": "callout", "variant": "key_point", "content": "Always check for an HCF before using other methods."}, {"type": "question", "questionText": "Factorise $4x^2 - 8x$.", "questionType": "multiple_choice", "options": ["$4x(x-2)$", "$4(x^2-2x)$", "$2x(2x-4)$", "$x(4x-8)$"], "correctAnswer": "$4x(x-2)$", "explanation": "HCF $4x$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'factorisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Factorising by Common Factor');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Factorising Trinomials', '{"blocks": [{"type": "heading", "content": "Quadratic Trinomials"}, {"type": "math_block", "latex": "x^2 + bx + c = (x+p)(x+q) \\text{ where } p+q=b,\\; pq=c"}, {"type": "example", "title": "Factorise $x^2 + 7x + 12$.", "steps": ["Find numbers sum $7$, product $12$: $3$ and $4$.", "$(x+3)(x+4)$."], "answer": "$(x+3)(x+4)$"}, {"type": "callout", "variant": "warning", "content": "If $c$ is positive and $b$ positive, both factors are positive."}, {"type": "question", "questionText": "Factorise $x^2 + 5x + 6$.", "questionType": "multiple_choice", "options": ["$(x+2)(x+3)$", "$(x+1)(x+6)$", "$(x+5)(x+1)$", "$(x+2)(x+4)$"], "correctAnswer": "$(x+2)(x+3)$", "explanation": "$2+3=5$, $2 \\times 3=6$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'factorisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Factorising Trinomials');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Factorisation — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Factorisation"}, {"type": "example", "title": "Factorise $2x^2 + 7x + 3$.", "steps": ["$ac$ method: $2 \\times 3 = 6$; numbers $6$ and $1$.", "$(2x+1)(x+3)$."], "answer": "$(2x+1)(x+3)$"}, {"type": "example", "title": "Factorise $x^2 - 9$.", "steps": ["Difference of squares: $(x+3)(x-3)$."], "answer": "$(x+3)(x-3)$"}, {"type": "callout", "variant": "warning", "content": "For $ax^2+bx+c$ when $a \\neq 1$, use grouping or $ac$ method."}, {"type": "question", "questionText": "Factorise $x^2 - x - 12$.", "questionType": "multiple_choice", "options": ["$(x-4)(x+3)$", "$(x+4)(x-3)$", "$(x-6)(x+2)$", "$(x+2)(x+6)$"], "correctAnswer": "$(x-4)(x+3)$", "explanation": "$-4+3=-1$, $-12$ product."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'factorisation'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Factorisation — Exam Practice');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving by Factorisation', '{"blocks": [{"type": "heading", "content": "Zero Product Property"}, {"type": "paragraph", "content": "If $(x-a)(x-b)=0$, then $x=a$ or $x=b$. Rewrite equation as product $= 0$, factorise, solve each factor."}, {"type": "example", "title": "Solve $x^2 + 5x + 6 = 0$.", "steps": ["$(x+2)(x+3)=0$.", "$x=-2$ or $x=-3$."], "answer": "$x=-2, -3$"}, {"type": "callout", "variant": "key_point", "content": "Rearrange to standard form $ax^2+bx+c=0$ before factorising."}, {"type": "question", "questionText": "Solve $(x-4)(x+1)=0$.", "questionType": "multiple_choice", "options": ["$x=4$ or $x=-1$", "$x=-4$ or $x=1$", "$x=4$ only", "$x=0$"], "correctAnswer": "$x=4$ or $x=-1$", "explanation": "Zero product."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'solving_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving by Factorisation');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Word Problems Leading to Quadratics', '{"blocks": [{"type": "heading", "content": "Quadratic Word Problems"}, {"type": "example", "title": "Two consecutive integers with product $132$. Setup?", "steps": ["Let $n$, $n+1$: $n(n+1)=132$.", "$n^2+n-132=0$.", "$(n+12)(n-11)=0$; $n=11$."], "answer": "$11$ and $12$"}, {"type": "callout", "variant": "warning", "content": "Reject solutions that do not fit the context (e.g. negative length)."}, {"type": "question", "questionText": "Solve $x^2 - 9 = 0$.", "questionType": "multiple_choice", "options": ["$x=\\pm 3$", "$x=3$ only", "$x=-3$ only", "$x=9$"], "correctAnswer": "$x=\\pm 3$", "explanation": "Difference of squares."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'solving_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Word Problems Leading to Quadratics');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving Quadratics — Exam Practice', '{"blocks": [{"type": "heading", "content": "KCSE — Solving Quadratics"}, {"type": "example", "title": "Solve $2x^2 - 5x - 3 = 0$.", "steps": ["$(2x+1)(x-3)=0$.", "$x = -\\frac{1}{2}$ or $x=3$."], "answer": "$x = -\\frac{1}{2}, 3$"}, {"type": "callout", "variant": "warning", "content": "Always substitute answers back to verify."}, {"type": "question", "questionText": "Rectangle: length $2$ m more than width, area $24$ m$^2$. Width?", "questionType": "multiple_choice", "options": ["$4$ m", "$6$ m", "$3$ m", "$8$ m"], "correctAnswer": "$4$ m", "explanation": "$w(w+2)=24$; $w=4$."}]}'::jsonb, 10, 3
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations' AND st.code = 'solving_quadratics'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving Quadratics — Exam Practice');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(x+1)(x+2)$.', 'multiple_choice', '["$x^2+3x+2$", "$x^2+2x+1$", "$2x^2+3x+2$", "$x^2+3x+1$"]'::jsonb, '"$x^2+3x+2$"'::jsonb, 'easy', 'FOIL.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(x+1)(x+2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(x+4)(x-4)$.', 'multiple_choice', '["$x^2-16$", "$x^2+16$", "$x^2-8$", "$2x^2-16$"]'::jsonb, '"$x^2-16$"'::jsonb, 'easy', 'Difference of squares.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(x+4)(x-4)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x+3)^2$ equals?', 'multiple_choice', '["$x^2+6x+9$", "$x^2+9$", "$x^2+3x+9$", "$2x^2+6x+9$"]'::jsonb, '"$x^2+6x+9$"'::jsonb, 'easy', 'Perfect square.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x+3)^2$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(x-2)(x+5)$.', 'multiple_choice', '["$x^2+3x-10$", "$x^2+7x-10$", "$x^2-3x-10$", "$x^2+3x+10$"]'::jsonb, '"$x^2+3x-10$"'::jsonb, 'easy', '$-2x+5x=3x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(x-2)(x+5)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(2x)(x+3)$.', 'multiple_choice', '["$2x^2+6x$", "$2x^2+3x$", "$x^2+6x$", "$3x^2+6x$"]'::jsonb, '"$2x^2+6x$"'::jsonb, 'easy', 'Distribute $2x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(2x)(x+3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$(x-1)^2$ equals?', 'multiple_choice', '["$x^2-2x+1$", "$x^2-1$", "$x^2+2x+1$", "$x^2-2x-1$"]'::jsonb, '"$x^2-2x+1$"'::jsonb, 'easy', 'Square binomial.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$(x-1)^2$ equals?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(x+0)(x+7)$.', 'multiple_choice', '["$x^2+7x$", "$x^2+7$", "$7x$", "$x^2+0x+7$"]'::jsonb, '"$x^2+7x$"'::jsonb, 'easy', 'Simplify.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(x+0)(x+7)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $x^2+8x+15$.', 'multiple_choice', '["$(x+3)(x+5)$", "$(x+1)(x+15)$", "$(x+2)(x+7)$", "$(x+4)(x+4)$"]'::jsonb, '"$(x+3)(x+5)$"'::jsonb, 'medium', '$3+5=8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $x^2+8x+15$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $x^2-16$.', 'multiple_choice', '["$(x+4)(x-4)$", "$(x-4)^2$", "$(x+8)(x-2)$", "$(x+16)(x-1)$"]'::jsonb, '"$(x+4)(x-4)$"'::jsonb, 'medium', 'DOTS.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $x^2-16$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $3x^2+6x$.', 'multiple_choice', '["$3x(x+2)$", "$3(x^2+2x)$", "$x(3x+6)$", "$6x(x+1)$"]'::jsonb, '"$3x(x+2)$"'::jsonb, 'medium', 'HCF $3x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $3x^2+6x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $x^2-5x+6$.', 'multiple_choice', '["$(x-2)(x-3)$", "$(x+2)(x+3)$", "$(x-1)(x-6)$", "$(x+1)(x+6)$"]'::jsonb, '"$(x-2)(x-3)$"'::jsonb, 'medium', 'Product $6$, sum $-5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $x^2-5x+6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $2x^2+5x+2$.', 'multiple_choice', '["$(2x+1)(x+2)$", "$(2x+2)(x+1)$", "$(x+2)(x+2)$", "$(2x+4)(x+1)$"]'::jsonb, '"$(2x+1)(x+2)$"'::jsonb, 'medium', '$ac$ method.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $2x^2+5x+2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $x^2+x-20$.', 'multiple_choice', '["$(x+5)(x-4)$", "$(x-5)(x+4)$", "$(x+2)(x-10)$", "$(x+10)(x-2)$"]'::jsonb, '"$(x+5)(x-4)$"'::jsonb, 'medium', '$5-4=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $x^2+x-20$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2-4=0$.', 'multiple_choice', '["$x=\\pm 2$", "$x=2$ only", "$x=4$", "$x=0$"]'::jsonb, '"$x=\\pm 2$"'::jsonb, 'medium', '$x^2=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2-4=0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2+6x+9=0$.', 'multiple_choice', '["$x=-3$", "$x=3$", "$x=\\pm 3$", "$x=0$"]'::jsonb, '"$x=-3$"'::jsonb, 'medium', 'Perfect square $(x+3)^2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2+6x+9=0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2-7x+12=0$.', 'multiple_choice', '["$x=3,4$", "$x=-3,-4$", "$x=2,6$", "$x=1,12$"]'::jsonb, '"$x=3,4$"'::jsonb, 'hard', '$(x-3)(x-4)=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2-7x+12=0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $2x^2-x-3=0$.', 'multiple_choice', '["$x=\\frac{3}{2}, -1$", "$x=3, -1$", "$x=\\frac{3}{2}, 1$", "$x=-\\frac{3}{2}, 1$"]'::jsonb, '"$x=\\frac{3}{2}, -1$"'::jsonb, 'hard', '$(2x-3)(x+1)=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $2x^2-x-3=0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Product of two consecutive even integers is $48$. Larger integer?', 'multiple_choice', '["$8$", "$6$", "$12$", "$4$"]'::jsonb, '"$8$"'::jsonb, 'hard', '$6 \times 8 = 48$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Product of two consecutive even integers is $48$. Larger integer?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $(3x-1)(x+4)$.', 'multiple_choice', '["$3x^2+11x-4$", "$3x^2+12x-1$", "$3x^2+11x+4$", "$4x^2+11x-4$"]'::jsonb, '"$3x^2+11x-4$"'::jsonb, 'hard', 'Full FOIL.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='expansion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $(3x-1)(x+4)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Solve $x^2+2x-15=0$.', 'multiple_choice', '["$x=3, -5$", "$x=-3, 5$", "$x=5, -3$", "$x=15, -1$"]'::jsonb, '"$x=3, -5$"'::jsonb, 'hard', '$(x+5)(x-3)=0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Solve $x^2+2x-15=0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Factorise $6x^2-x-2$.', 'multiple_choice', '["$(3x-2)(2x+1)$", "$(6x+1)(x-2)$", "$(3x+2)(2x-1)$", "$(2x-1)(3x+2)$"]'::jsonb, '"$(3x-2)(2x+1)$"'::jsonb, 'hard', '$ac=-12$; $-4+3=-1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='factorisation'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Factorise $6x^2-x-2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Area rectangle: width $x$, length $x+5$, area $50$. Find $x$.', 'multiple_choice', '["$5$", "$10$", "$-10$", "$25$"]'::jsonb, '"$5$"'::jsonb, 'hard', '$x(x+5)=50$; $x=5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='solving_quadratics'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='quadratic_expressions_equations'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Area rectangle: width $x$, length $x+5$, area $50$. Find $x$.');
