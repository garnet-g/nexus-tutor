-- Mathematics curriculum seed (CBC + KCSE)
-- Nexus V1 Wave 2

-- CBC topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'fractions', 'Fractions', 'Understand parts of a whole using Kenyan market examples.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'intro', 'Introduction to Fractions', 'What fractions represent.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Fractions', '{"blocks":[{"type":"heading","content":"Understanding Fractions"},{"type":"paragraph","content":"A fraction shows part of a whole. If Grace shares 3 of 8 mangoes, she has 3/8 of the mangoes."},{"type":"example","title":"Grace has 8 mangoes and gives 3 to her friend. What fraction did she give away?","steps":["Identify the whole: 8 mangoes","Count the part given: 3 mangoes","Write as fraction: 3/8"],"answer":"3/8"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'intro'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Fractions'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'equivalent', 'Equivalent Fractions', 'Same value, different forms.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding Equivalent Fractions', '{"blocks":[{"type":"heading","content":"Finding Equivalent Fractions"},{"type":"paragraph","content":"Equivalent fractions name the same amount. Multiply or divide numerator and denominator by the same number."},{"type":"example","title":"Write an equivalent fraction for 2/5.","steps":["Multiply top and bottom by 2","2×2 = 4 and 5×2 = 10","Equivalent fraction is 4/10"],"answer":"4/10"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'equivalent'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding Equivalent Fractions'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations', 'Fraction Operations', 'Add, subtract, multiply, and divide fractions.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding Fractions with Same Denominator', '{"blocks":[{"type":"heading","content":"Adding Fractions with Same Denominator"},{"type":"paragraph","content":"When denominators match, add the numerators and keep the denominator."},{"type":"example","title":"Kamau ate 2/8 of a chapati and later 3/8. How much did he eat in total?","steps":["Denominators are both 8","Add numerators: 2 + 3 = 5","Answer: 5/8 of the chapati"],"answer":"5/8"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding Fractions with Same Denominator'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'algebra', 'Algebra', 'Use letters to represent unknown values and solve simple equations.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'expressions', 'Algebraic Expressions', 'Combine numbers and variables.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Letters for Unknowns', '{"blocks":[{"type":"heading","content":"Using Letters for Unknowns"},{"type":"paragraph","content":"A variable stands for a number we do not know yet. In 2n, n is the number of notebooks."},{"type":"example","title":"If each notebook costs n shillings, write the cost of 4 notebooks.","steps":["Use multiplication for repeated cost","4 notebooks means 4 × n","Expression: 4n shillings"],"answer":"4n"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'expressions'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Letters for Unknowns'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simple_equations', 'Simple Equations', 'One-step equations.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving x + 5 = 12', '{"blocks":[{"type":"heading","content":"Solving x + 5 = 12"},{"type":"paragraph","content":"Undo addition by subtracting the same value from both sides."},{"type":"example","title":"Solve x + 5 = 12.","steps":["Subtract 5 from both sides","x + 5 - 5 = 12 - 5","x = 7"],"answer":"x = 7"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'simple_equations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving x + 5 = 12'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'linear_equations', 'Linear Equations', 'Two-step linear equations.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving 3x = 18', '{"blocks":[{"type":"heading","content":"Solving 3x = 18"},{"type":"paragraph","content":"Undo multiplication by dividing both sides by the same number."},{"type":"example","title":"Solve 3x = 18.","steps":["Divide both sides by 3","3x ÷ 3 = 18 ÷ 3","x = 6"],"answer":"x = 6"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'linear_equations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving 3x = 18'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'geometry', 'Geometry Basics', 'Explore shapes, angles, and area in everyday Kenyan settings.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'shapes', 'Shapes', 'Identify 2D shapes and properties.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Properties of Rectangles', '{"blocks":[{"type":"heading","content":"Properties of Rectangles"},{"type":"paragraph","content":"A rectangle has four right angles and opposite sides equal."},{"type":"example","title":"A classroom door is a rectangle 2 m by 1 m. Name two equal sides.","steps":["Opposite sides are equal in a rectangle","Two lengths are 2 m each","Two widths are 1 m each"],"answer":"2 m and 1 m pairs"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'shapes'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Properties of Rectangles'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'angles', 'Angles', 'Measure and classify angles.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Types of Angles', '{"blocks":[{"type":"heading","content":"Types of Angles"},{"type":"paragraph","content":"Angles less than 90° are acute, exactly 90° are right, and greater than 90° are obtuse."},{"type":"example","title":"Classify a 45° angle.","steps":["Compare 45° to 90°","45° is less than 90°","It is an acute angle"],"answer":"Acute angle"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'angles'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Types of Angles'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_perimeter', 'Area & Perimeter', 'Calculate around and inside shapes.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Area of a Rectangle', '{"blocks":[{"type":"heading","content":"Area of a Rectangle"},{"type":"paragraph","content":"Area = length × width. Use consistent units such as cm or m."},{"type":"example","title":"Find the area of a mat 3 m long and 2 m wide.","steps":["Use A = l × w","A = 3 × 2","Area = 6 m²"],"answer":"6 m²"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'area_perimeter'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Area of a Rectangle'
);

-- KCSE topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'algebra', 'Algebra', 'Manipulate expressions and solve equations at secondary level.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'linear_equations', 'Linear Equations', 'Solve equations with one variable.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Solving 2x - 4 = 10', '{"blocks":[{"type":"heading","content":"Solving 2x - 4 = 10"},{"type":"paragraph","content":"Isolate the variable using inverse operations in balance."},{"type":"example","title":"Solve 2x - 4 = 10.","steps":["Add 4 to both sides: 2x = 14","Divide both sides by 2","x = 7"],"answer":"x = 7"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'linear_equations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Solving 2x - 4 = 10'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'quadratic_expressions', 'Quadratic Expressions', 'Expand and factor simple quadratics.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding (x + 2)(x + 3)', '{"blocks":[{"type":"heading","content":"Expanding (x + 2)(x + 3)"},{"type":"paragraph","content":"Use the distributive property or FOIL for binomials."},{"type":"example","title":"Expand (x + 2)(x + 3).","steps":["x·x = x²","x·3 + 2·x = 5x","2·3 = 6, so x² + 5x + 6"],"answer":"x² + 5x + 6"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'quadratic_expressions'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding (x + 2)(x + 3)'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'indices', 'Indices', 'Apply laws of indices.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Law of Indices: a^m × a^n', '{"blocks":[{"type":"heading","content":"Law of Indices: a^m × a^n"},{"type":"paragraph","content":"When bases match, add the powers."},{"type":"example","title":"Simplify 2³ × 2².","steps":["Same base 2","Add powers: 3 + 2 = 5","Answer: 2⁵ = 32"],"answer":"2⁵ or 32"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra' AND st.code = 'indices'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Law of Indices: a^m × a^n'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'fractions', 'Fractions', 'Work with rational numbers in exam-style problems.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simplifying', 'Simplifying Fractions', 'Reduce to lowest terms.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Simplifying 12/18', '{"blocks":[{"type":"heading","content":"Simplifying 12/18"},{"type":"paragraph","content":"Divide numerator and denominator by their HCF."},{"type":"example","title":"Simplify 12/18.","steps":["HCF of 12 and 18 is 6","12÷6 = 2 and 18÷6 = 3","Simplest form: 2/3"],"answer":"2/3"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'simplifying'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Simplifying 12/18'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations', 'Fraction Operations', 'All four operations with fractions.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Dividing Fractions', '{"blocks":[{"type":"heading","content":"Dividing Fractions"},{"type":"paragraph","content":"Multiply by the reciprocal of the divisor."},{"type":"example","title":"Calculate 3/4 ÷ 2/5.","steps":["Keep 3/4, change ÷ to ×, flip 2/5 to 5/2","3/4 × 5/2 = 15/8","Answer: 15/8 or 1 7/8"],"answer":"15/8"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Dividing Fractions'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'word_problems', 'Word Problems', 'Apply fractions in context.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Fraction of an Amount', '{"blocks":[{"type":"heading","content":"Fraction of an Amount"},{"type":"paragraph","content":"Multiply the fraction by the whole amount."},{"type":"example","title":"A school fund of KES 24,000 uses 5/8 for books. How much is that?","steps":["Multiply 5/8 × 24,000","24,000 ÷ 8 = 3,000","5 × 3,000 = KES 15,000"],"answer":"KES 15,000"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'word_problems'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Fraction of an Amount'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'geometry', 'Geometry Basics', 'Coordinate geometry, circles, and transformations.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'coordinate_geometry', 'Coordinate Geometry', 'Plot points and find distance.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Distance Between Two Points', '{"blocks":[{"type":"heading","content":"Distance Between Two Points"},{"type":"paragraph","content":"Use distance formula or Pythagoras on coordinate grid."},{"type":"example","title":"Find distance between (0,0) and (3,4).","steps":["Horizontal change = 3, vertical = 4","Use 3² + 4² = 25","Distance = √25 = 5 units"],"answer":"5 units"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'coordinate_geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Distance Between Two Points'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'circles', 'Circles', 'Circumference and area of circles.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Circumference of a Circle', '{"blocks":[{"type":"heading","content":"Circumference of a Circle"},{"type":"paragraph","content":"C = 2πr or C = πd where r is radius."},{"type":"example","title":"Find circumference when r = 7 cm (use π = 22/7).","steps":["C = 2 × 22/7 × 7","The 7 cancels","C = 44 cm"],"answer":"44 cm"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'circles'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Circumference of a Circle'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'transformations', 'Transformations', 'Reflection, rotation, and translation.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Translation on a Grid', '{"blocks":[{"type":"heading","content":"Translation on a Grid"},{"type":"paragraph","content":"A translation moves every point by the same vector."},{"type":"example","title":"Translate point (2,3) by vector (4,-1).","steps":["Add 4 to x-coordinate: 2 + 4 = 6","Add -1 to y-coordinate: 3 + (-1) = 2","Image point: (6,2)"],"answer":"(6,2)"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry' AND st.code = 'transformations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Translation on a Grid'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'trigonometry', 'Trigonometry', 'Work with sin, cos, tan and apply them to triangles and heights.', 4, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ratios', 'Sin, Cos & Tan', 'Trigonometric ratios in right-angled triangles.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sine Ratio in Right Triangles', '{"blocks":[{"type":"heading","content":"Sine Ratio in Right Triangles"},{"type":"paragraph","content":"In a right triangle, sin θ = opposite ÷ hypotenuse."},{"type":"example","title":"Find sin θ when opposite = 3 and hypotenuse = 5.","steps":["Write sin θ = 3/5","3 and 5 have no common factor","sin θ = 3/5"],"answer":"3/5"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry' AND st.code = 'ratios'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sine Ratio in Right Triangles'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'identities', 'Identities', 'Key identities and special angles.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Cosine and Tangent Ratios', '{"blocks":[{"type":"heading","content":"Cosine and Tangent Ratios"},{"type":"paragraph","content":"cos θ = adjacent ÷ hypotenuse and tan θ = opposite ÷ adjacent."},{"type":"example","title":"A triangle has adjacent 4 and hypotenuse 5. Find cos θ.","steps":["cos θ = 4/5","Check the ratio uses adjacent over hypotenuse","cos θ = 4/5"],"answer":"4/5"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry' AND st.code = 'identities'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Cosine and Tangent Ratios'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications', 'Applications', 'Heights, distances, and bearings.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Angle of Elevation', '{"blocks":[{"type":"heading","content":"Angle of Elevation"},{"type":"paragraph","content":"Use tan to find heights when you know distance and angle."},{"type":"example","title":"From 20 m away, the angle of elevation to a flagpole top is 45°. Find the height.","steps":["Use tan 45° = height ÷ 20","tan 45° = 1","Height = 20 m"],"answer":"20 m"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry' AND st.code = 'applications'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Angle of Elevation'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'statistics', 'Statistics', 'Summarise data, calculate probability, and read charts.', 5, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'central_tendency', 'Mean, Median & Mode', 'Describe data with one value.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Calculating the Mean', '{"blocks":[{"type":"heading","content":"Calculating the Mean"},{"type":"paragraph","content":"Mean = sum of values ÷ number of values."},{"type":"example","title":"Find the mean of 4, 6, and 8.","steps":["Sum = 4 + 6 + 8 = 18","There are 3 values","Mean = 18 ÷ 3 = 6"],"answer":"6"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics' AND st.code = 'central_tendency'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Calculating the Mean'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'probability', 'Probability', 'Chance of events happening.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Median and Mode', '{"blocks":[{"type":"heading","content":"Median and Mode"},{"type":"paragraph","content":"Median is the middle value; mode is the most frequent value."},{"type":"example","title":"Find the median of 2, 5, 7, 9, 11.","steps":["Order the values: 2, 5, 7, 9, 11","The middle value is 7","Median = 7"],"answer":"7"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics' AND st.code = 'probability'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Median and Mode'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'data_representation', 'Data Representation', 'Tables, bar charts, and pie charts.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading a Bar Chart', '{"blocks":[{"type":"heading","content":"Reading a Bar Chart"},{"type":"paragraph","content":"Compare categories using bar heights on a chart."},{"type":"example","title":"A bar chart shows sales: Mon 5, Tue 8, Wed 6. Which day had highest sales?","steps":["Compare bar heights","Tuesday''s bar is tallest at 8","Tuesday had the highest sales"],"answer":"Tuesday"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics' AND st.code = 'data_representation'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading a Bar Chart'
);

-- Practice questions (21 per topic)
INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 1: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 1: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 2: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'easy', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 2: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 3: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'easy', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 3: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 4: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 4: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 5: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'easy', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 5: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 6: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'easy', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 6: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 7: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 7: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 8: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 8: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 9: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'medium', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 9: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 10: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 10: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 11: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 11: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 12: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'medium', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 12: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 13: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 13: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 14: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 14: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 15: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 15: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 16: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'hard', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 16: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 17: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'hard', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 17: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 18: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 18: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 19: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'hard', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 19: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 20: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'hard', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 20: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC fractions practice 21: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC fractions practice 21: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 1: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 1: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 2: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 2: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 3: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'easy', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 3: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 4: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 4: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 5: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 5: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 6: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'easy', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 6: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 7: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 7: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 8: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 8: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 9: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'medium', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 9: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 10: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'medium', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 10: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 11: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 11: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 12: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'medium', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 12: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 13: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'medium', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 13: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 14: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 14: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 15: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 15: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 16: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'hard', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 16: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 17: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 17: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 18: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 18: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 19: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'hard', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 19: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 20: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 20: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC algebra practice 21: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC algebra practice 21: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 1: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 1: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 2: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'easy', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 2: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 3: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 3: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 4: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 4: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 5: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'easy', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 5: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 6: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 6: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 7: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 7: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 8: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 8: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 9: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 9: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 10: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'medium', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 10: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 11: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 11: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 12: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 12: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 13: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'medium', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 13: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 14: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 14: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 15: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 15: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 16: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'hard', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 16: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 17: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'hard', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 17: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 18: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 18: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 19: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'hard', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 19: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 20: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'hard', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 20: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC geometry practice 21: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC geometry practice 21: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 1: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 1: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 2: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 2: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 3: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'easy', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 3: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 4: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 4: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 5: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 5: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 6: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'easy', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 6: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 7: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 7: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 8: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 8: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 9: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'medium', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 9: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 10: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'medium', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 10: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 11: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 11: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 12: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'medium', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 12: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 13: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'medium', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 13: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 14: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 14: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 15: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 15: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 16: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'hard', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 16: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 17: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 17: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 18: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 18: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 19: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'hard', 'Subtract 3 from both sides.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 19: Solve x + 3 = 9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 20: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 'Substitute x = 5 into 2x.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 20: Evaluate 2x when x = 5.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE algebra practice 21: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'hard', 'Multiply 2 by each term in the bracket.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebra'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE algebra practice 21: Expand 2(x + 4).'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 1: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 1: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 2: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'easy', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 2: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 3: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'easy', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 3: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 4: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 4: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 5: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'easy', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 5: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 6: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'easy', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 6: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 7: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 7: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 8: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 8: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 9: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'medium', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 9: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 10: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 10: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 11: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 11: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 12: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'medium', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 12: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 13: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 13: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 14: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'medium', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 14: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 15: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 15: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 16: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'hard', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 16: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 17: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'hard', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 17: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 18: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 18: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 19: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'hard', 'Add numerators when denominators match.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 19: What is 1/4 + 1/4?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 20: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'hard', 'Divide numerator and denominator by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 20: Simplify 6/9.'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE fractions practice 21: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'hard', 'Multiply top and bottom by 2.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE fractions practice 21: Which fraction is equivalent to 3/5?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 1: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 1: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 2: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'easy', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 2: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 3: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 3: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 4: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 4: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 5: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'easy', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 5: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 6: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 6: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 7: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'easy', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 7: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 8: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 8: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 9: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 9: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 10: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'medium', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 10: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 11: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 11: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 12: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 12: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 13: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'medium', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 13: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 14: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'medium', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 14: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 15: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 15: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 16: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'hard', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 16: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 17: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'hard', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 17: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 18: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 18: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 19: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'hard', 'Tri means three.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 19: How many sides does a triangle have?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 20: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'hard', 'A right angle is exactly 90°.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 20: A right angle measures how many degrees?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE geometry practice 21: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 'Area = length × width.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE geometry practice 21: Area of a 4 cm by 5 cm rectangle?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 1: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'easy', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 1: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 2: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'easy', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 2: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 3: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'easy', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 3: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 4: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'easy', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 4: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 5: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'easy', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 5: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 6: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'easy', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 6: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 7: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'easy', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 7: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 8: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'medium', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 8: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 9: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'medium', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 9: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 10: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'medium', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 10: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 11: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'medium', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 11: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 12: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'medium', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 12: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 13: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'medium', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 13: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 14: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'medium', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 14: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 15: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'hard', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 15: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 16: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'hard', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 16: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 17: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'hard', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 17: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 18: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'hard', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 18: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 19: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'hard', 'sin 30° is a special angle value.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 19: What is sin 30°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 20: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'hard', 'cos 60° equals 0.5.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 20: What is cos 60°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE trigonometry practice 21: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'hard', 'tan 45° equals 1.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE trigonometry practice 21: What is tan 45°?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 1: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'easy', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 1: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 2: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'easy', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 2: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 3: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'easy', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 3: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 4: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'easy', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 4: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 5: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'easy', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 5: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 6: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'easy', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 6: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 7: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'easy', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 7: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 8: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'medium', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 8: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 9: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'medium', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 9: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 10: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'medium', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 10: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 11: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'medium', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 11: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 12: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'medium', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 12: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 13: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'medium', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 13: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 14: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'medium', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 14: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 15: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'hard', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 15: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 16: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'hard', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 16: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 17: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'hard', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 17: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 18: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'hard', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 18: Probability of heads on a fair coin?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 19: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'hard', 'Sum is 12; divide by 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 19: What is the mean of 2, 4, and 6?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 20: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'hard', 'The middle value is 3.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 20: What is the median of 1, 3, and 9?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE statistics practice 21: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'hard', 'Two equally likely outcomes.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE statistics practice 21: Probability of heads on a fair coin?'
);

INSERT INTO public.diagnostic_assessments (curriculum_id, subject_id, title, question_count)
SELECT c.id, s.id, 'CBC Mathematics Diagnostic', 20
FROM public.curricula c
JOIN public.subjects s ON s.curriculum_id = c.id AND s.code = 'mathematics'
WHERE c.code = 'CBC'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_assessments da
  WHERE da.curriculum_id = c.id AND da.subject_id = s.id
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q1: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 1
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 1
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q2: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 2
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 2
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q3: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 3
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 3
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q4: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 4
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 4
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q5: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 5
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 5
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q6: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 6
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 6
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q7: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 7
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 7
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q8: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'easy', 8
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 8
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q9: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 9
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 9
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q10: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 10
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 10
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q11: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 11
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 11
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q12: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 12
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 12
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q13: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 13
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 13
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q14: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 14
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 14
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q15: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'medium', 15
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 15
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q16: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'medium', 16
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 16
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q17: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 17
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 17
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q18: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 18
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 18
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q19: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'hard', 19
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 19
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'CBC diagnostic Q20: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'hard', 20
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'CBC' AND s.code = 'mathematics' AND da.title = 'CBC Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 20
);

INSERT INTO public.diagnostic_assessments (curriculum_id, subject_id, title, question_count)
SELECT c.id, s.id, 'KCSE Mathematics Diagnostic', 20
FROM public.curricula c
JOIN public.subjects s ON s.curriculum_id = c.id AND s.code = 'mathematics'
WHERE c.code = 'KCSE'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_assessments da
  WHERE da.curriculum_id = c.id AND da.subject_id = s.id
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q1: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'easy', 1
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 1
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q2: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'easy', 2
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 2
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q3: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'easy', 3
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 3
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q4: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'easy', 4
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'trigonometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 4
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q5: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'easy', 5
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'statistics'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 5
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q6: Expand 2(x + 4).', 'multiple_choice', '["2x+4","2x+8","x+8","4x+2"]'::jsonb, '"2x+8"'::jsonb, 'easy', 6
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 6
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q7: What is 1/4 + 1/4?', 'multiple_choice', '["1/8","1/2","2/4","3/4"]'::jsonb, '"1/2"'::jsonb, 'easy', 7
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 7
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q8: A right angle measures how many degrees?', 'multiple_choice', '["45","90","180","360"]'::jsonb, '"90"'::jsonb, 'easy', 8
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 8
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q9: What is tan 45°?', 'multiple_choice', '["0","0.5","1","2"]'::jsonb, '"1"'::jsonb, 'medium', 9
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'trigonometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 9
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q10: What is the mean of 2, 4, and 6?', 'multiple_choice', '["3","4","5","6"]'::jsonb, '"4"'::jsonb, 'medium', 10
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'statistics'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 10
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q11: Evaluate 2x when x = 5.', 'multiple_choice', '["7","10","25","2/5"]'::jsonb, '"10"'::jsonb, 'medium', 11
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 11
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q12: Which fraction is equivalent to 3/5?', 'multiple_choice', '["6/10","3/10","5/3","9/20"]'::jsonb, '"6/10"'::jsonb, 'medium', 12
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 12
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q13: How many sides does a triangle have?', 'multiple_choice', '["2","3","4","5"]'::jsonb, '"3"'::jsonb, 'medium', 13
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 13
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q14: What is cos 60°?', 'multiple_choice', '["0.5","0.866","1","0"]'::jsonb, '"0.5"'::jsonb, 'medium', 14
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'trigonometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 14
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q15: Probability of heads on a fair coin?', 'multiple_choice', '["0.25","0.5","0.75","1"]'::jsonb, '"0.5"'::jsonb, 'medium', 15
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'statistics'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 15
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q16: Solve x + 3 = 9.', 'multiple_choice', '["x=6","x=12","x=3","x=9"]'::jsonb, '"x=6"'::jsonb, 'medium', 16
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'algebra'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 16
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q17: Simplify 6/9.', 'multiple_choice', '["2/3","3/2","6/9","1/3"]'::jsonb, '"2/3"'::jsonb, 'hard', 17
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'fractions'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 17
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q18: Area of a 4 cm by 5 cm rectangle?', 'multiple_choice', '["9 cm²","18 cm²","20 cm²","25 cm²"]'::jsonb, '"20 cm²"'::jsonb, 'hard', 18
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'geometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 18
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q19: What is sin 30°?', 'multiple_choice', '["0.5","1","0.866","0.707"]'::jsonb, '"0.5"'::jsonb, 'hard', 19
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'trigonometry'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 19
);

INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, 'KCSE diagnostic Q20: What is the median of 1, 3, and 9?', 'multiple_choice', '["1","3","5","9"]'::jsonb, '"3"'::jsonb, 'hard', 20
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = 'statistics'
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND da.title = 'KCSE Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = 20
);

