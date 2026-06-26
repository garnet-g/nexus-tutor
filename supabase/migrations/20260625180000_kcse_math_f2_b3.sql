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

