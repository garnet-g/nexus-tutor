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

