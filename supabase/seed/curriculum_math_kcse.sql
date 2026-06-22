-- KCSE Mathematics skeleton seed — additive topics/subtopics only; lessons/questions via content pipeline
-- Existing topics fractions, algebra, geometry, trigonometry, statistics remain in curriculum_math.sql

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'natural_numbers', 'Natural Numbers', 'KCSE Mathematics — Natural Numbers.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'place_values', 'Place Values & Rounding', 'Place Values & Rounding', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'number_operations', 'Operations & Order', 'Operations & Order', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'number_line', 'Number Line', 'Number Line', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'factors', 'Factors', 'KCSE Mathematics — Factors.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'prime_factors', 'Prime Factorisation', 'Prime Factorisation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'gcd_hcf', 'GCD/HCF', 'GCD/HCF', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'lcm', 'LCM', 'LCM', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'divisibility_tests', 'Divisibility Tests', 'KCSE Mathematics — Divisibility Tests.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tests_2_3_4_5', 'Tests for 2,3,4,5', 'Tests for 2,3,4,5', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tests_6_8_9_10_11', 'Tests for 6,8,9,10,11', 'Tests for 6,8,9,10,11', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications', 'Applications', 'Applications', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'integers', 'Integers', 'KCSE Mathematics — Integers.', 4, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'number_line_integers', 'Integers on the Number Line', 'Integers on the Number Line', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations_integers', 'Operations with Integers', 'Operations with Integers', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'order_of_operations', 'Order of Operations', 'Order of Operations', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'decimals', 'Decimals', 'KCSE Mathematics — Decimals.', 5, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'place_value_decimals', 'Decimal Place Value', 'Decimal Place Value', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations_decimals', 'Operations', 'Operations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'recurring_decimals', 'Recurring Decimals', 'Recurring Decimals', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'squares_square_roots', 'Squares and Square Roots', 'KCSE Mathematics — Squares and Square Roots.', 6, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'squares', 'Squares', 'Squares', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'square_roots_factor', 'Roots by Factorisation', 'Roots by Factorisation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'square_roots_tables', 'Roots by Tables', 'Roots by Tables', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'squares_square_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'algebraic_expressions', 'Algebraic Expressions', 'KCSE Mathematics — Algebraic Expressions.', 7, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'forming_expressions', 'Forming Expressions', 'Forming Expressions', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simplification', 'Simplification', 'Simplification', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'substitution', 'Substitution', 'Substitution', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'rates_ratio_proportion', 'Rates, Ratio, Percentage & Proportion', 'KCSE Mathematics — Rates, Ratio, Percentage & Proportion.', 8, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rates', 'Rates', 'Rates', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ratio_proportion', 'Ratio & Proportion', 'Ratio & Proportion', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'percentage', 'Percentage', 'Percentage', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'length', 'Length', 'KCSE Mathematics — Length.', 9, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'units_length', 'Units & Conversion', 'Units & Conversion', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'perimeter', 'Perimeter', 'Perimeter', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'circumference', 'Circumference', 'Circumference', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'length'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'area', 'Area', 'KCSE Mathematics — Area.', 10, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_plane_figures', 'Area of Plane Figures', 'Area of Plane Figures', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_circle', 'Area of a Circle', 'Area of a Circle', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_combined', 'Combined Shapes', 'Combined Shapes', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'volume_capacity', 'Volume and Capacity', 'KCSE Mathematics — Volume and Capacity.', 11, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'volume_prisms', 'Volume of Prisms', 'Volume of Prisms', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'capacity_units', 'Capacity & Units', 'Capacity & Units', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_volume', 'Applications', 'Applications', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_capacity'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'mass_weight_density', 'Mass, Weight and Density', 'KCSE Mathematics — Mass, Weight and Density.', 12, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mass_weight', 'Mass & Weight', 'Mass & Weight', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'mass_weight_density'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'density', 'Density', 'Density', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'mass_weight_density'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_density', 'Applications', 'Applications', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'mass_weight_density'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'time', 'Time', 'KCSE Mathematics — Time.', 13, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'units_time', 'Units of Time', 'Units of Time', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'timetables', 'Timetables', 'Timetables', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'speed_time', 'Time & Speed Basics', 'Time & Speed Basics', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'time'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'linear_equations', 'Linear Equations', 'KCSE Mathematics — Linear Equations.', 14, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'solving_linear', 'Solving Linear Equations', 'Solving Linear Equations', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'forming_linear', 'Forming Equations', 'Forming Equations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_linear', 'Word Problems', 'Word Problems', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'commercial_arithmetic_i', 'Commercial Arithmetic I', 'KCSE Mathematics — Commercial Arithmetic I.', 15, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'profit_loss', 'Profit & Loss', 'Profit & Loss', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'discount_commission', 'Discount & Commission', 'Discount & Commission', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simple_interest', 'Simple Interest', 'Simple Interest', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'coordinates_graphs', 'Coordinates and Graphs', 'KCSE Mathematics — Coordinates and Graphs.', 16, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cartesian_plane', 'Cartesian Plane', 'Cartesian Plane', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'plotting_points', 'Plotting Points', 'Plotting Points', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'linear_graphs', 'Linear Graphs', 'Linear Graphs', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'coordinates_graphs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'angles_plane_figures', 'Angles and Plane Figures', 'KCSE Mathematics — Angles and Plane Figures.', 17, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'types_of_angles', 'Types of Angles', 'Types of Angles', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'angles_straight_lines', 'Angles on Lines', 'Angles on Lines', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'polygons', 'Polygons', 'Polygons', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angles_plane_figures'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'geometric_constructions', 'Geometric Constructions', 'KCSE Mathematics — Geometric Constructions.', 18, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'construct_angles', 'Constructing Angles', 'Constructing Angles', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'construct_triangles', 'Constructing Triangles', 'Constructing Triangles', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'bisectors', 'Bisectors', 'Bisectors', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'geometric_constructions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'scale_drawing', 'Scale Drawing', 'KCSE Mathematics — Scale Drawing.', 19, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'scales', 'Scales', 'Scales', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'bearings_intro', 'Bearings (intro)', 'Bearings (intro)', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'representation', 'Representation', 'Representation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'scale_drawing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'common_solids', 'Common Solids', 'KCSE Mathematics — Common Solids.', 20, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nets', 'Nets', 'Nets', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'properties_solids', 'Properties', 'Properties', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'surface_models', 'Surface Models', 'Surface Models', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'common_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'cubes_cube_roots', 'Cubes and Cube Roots', 'KCSE Mathematics — Cubes and Cube Roots.', 21, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cubes', 'Cubes', 'Cubes', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cube_roots_factor', 'Roots by Factorisation', 'Roots by Factorisation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cube_roots_tables', 'Roots by Tables', 'Roots by Tables', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'cubes_cube_roots'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'reciprocals', 'Reciprocals', 'KCSE Mathematics — Reciprocals.', 22, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reciprocals_tables', 'Reciprocals by Tables', 'Reciprocals by Tables', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations_reciprocals', 'Operations', 'Operations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications', 'Applications', 'Applications', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reciprocals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'indices_logarithms', 'Indices and Logarithms', 'KCSE Mathematics — Indices and Logarithms.', 23, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'laws_of_indices', 'Laws of Indices', 'Laws of Indices', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'standard_form', 'Standard Form', 'Standard Form', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'logarithms', 'Logarithms', 'Logarithms', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'indices_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'gradient_straight_lines', 'Gradient and Equations of Straight Lines', 'KCSE Mathematics — Gradient and Equations of Straight Lines.', 24, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'gradient', 'Gradient', 'Gradient', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'equation_of_line', 'Equation of a Line', 'Equation of a Line', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'parallel_perpendicular', 'Parallel & Perpendicular', 'Parallel & Perpendicular', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'gradient_straight_lines'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'reflection_congruence', 'Reflection and Congruence', 'KCSE Mathematics — Reflection and Congruence.', 25, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reflection', 'Reflection', 'Reflection', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'congruence', 'Congruence', 'Congruence', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'symmetry', 'Symmetry', 'Symmetry', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'reflection_congruence'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'rotation', 'Rotation', 'KCSE Mathematics — Rotation.', 26, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rotation_basics', 'Rotation Basics', 'Rotation Basics', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'centre_angle', 'Centre & Angle', 'Centre & Angle', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rotational_symmetry', 'Rotational Symmetry', 'Rotational Symmetry', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rotation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'similarity_enlargement', 'Similarity and Enlargement', 'KCSE Mathematics — Similarity and Enlargement.', 27, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'similarity', 'Similarity', 'Similarity', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'enlargement', 'Enlargement', 'Enlargement', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'scale_factor', 'Scale Factor', 'Scale Factor', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'similarity_enlargement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'pythagoras_theorem', 'Pythagoras'' Theorem', 'KCSE Mathematics — Pythagoras'' Theorem.', 28, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'theorem', 'The Theorem', 'The Theorem', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_pythagoras', 'Applications', 'Applications', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, '3d_problems', '3-D Problems', '3-D Problems', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'pythagoras_theorem'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'trigonometry_i', 'Trigonometry I', 'KCSE Mathematics — Trigonometry I.', 29, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sine_cosine_tangent', 'Sine, Cosine, Tangent', 'Sine, Cosine, Tangent', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'trig_tables', 'Trig Tables', 'Trig Tables', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'right_angled_problems', 'Right-Angled Problems', 'Right-Angled Problems', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'area_triangle', 'Area of a Triangle', 'KCSE Mathematics — Area of a Triangle.', 30, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'half_base_height', '½ × base × height', '½ × base × height', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_triangle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'half_ab_sinc', '½ ab sin C', '½ ab sin C', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_triangle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'heros_formula', 'Hero''s Formula', 'Hero''s Formula', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_triangle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'area_quadrilaterals_polygons', 'Area of Quadrilaterals & Other Polygons', 'KCSE Mathematics — Area of Quadrilaterals & Other Polygons.', 31, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'quadrilaterals', 'Quadrilaterals', 'Quadrilaterals', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'regular_polygons', 'Regular Polygons', 'Regular Polygons', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'composite', 'Composite Figures', 'Composite Figures', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_quadrilaterals_polygons'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'area_part_circle', 'Area of Part of a Circle', 'KCSE Mathematics — Area of Part of a Circle.', 32, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sector', 'Sector', 'Sector', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'segment', 'Segment', 'Segment', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'combined', 'Combined Areas', 'Combined Areas', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_part_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'surface_area_solids', 'Surface Area of Solids', 'KCSE Mathematics — Surface Area of Solids.', 33, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'prisms_cylinders', 'Prisms & Cylinders', 'Prisms & Cylinders', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'pyramids_cones', 'Pyramids & Cones', 'Pyramids & Cones', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'spheres', 'Spheres', 'Spheres', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surface_area_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'volume_solids', 'Volume of Solids', 'KCSE Mathematics — Volume of Solids.', 34, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'prisms_cylinders_vol', 'Prisms & Cylinders', 'Prisms & Cylinders', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'pyramids_cones_vol', 'Pyramids & Cones', 'Pyramids & Cones', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'spheres_vol', 'Spheres', 'Spheres', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'volume_solids'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'quadratic_expressions_equations', 'Quadratic Expressions and Equations', 'KCSE Mathematics — Quadratic Expressions and Equations.', 35, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'expansion', 'Expansion', 'Expansion', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'factorisation', 'Factorisation', 'Factorisation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'solving_quadratics', 'Solving by Factorisation', 'Solving by Factorisation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_expressions_equations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'linear_inequalities', 'Linear Inequalities', 'KCSE Mathematics — Linear Inequalities.', 36, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'solving_inequalities', 'Solving Inequalities', 'Solving Inequalities', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'number_line_ineq', 'Number Line', 'Number Line', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'graphical_region', 'Graphical Region', 'Graphical Region', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_inequalities'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'linear_motion', 'Linear Motion', 'KCSE Mathematics — Linear Motion.', 37, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'distance_time', 'Distance–Time', 'Distance–Time', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'velocity_time', 'Velocity–Time', 'Velocity–Time', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'acceleration', 'Acceleration', 'Acceleration', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_motion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'statistics_i', 'Statistics I', 'KCSE Mathematics — Statistics I.', 38, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'data_collection', 'Data Collection', 'Data Collection', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'frequency_tables', 'Frequency Tables', 'Frequency Tables', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mean_median_mode', 'Mean, Median, Mode', 'Mean, Median, Mode', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'angle_properties_circle', 'Angle Properties of a Circle', 'KCSE Mathematics — Angle Properties of a Circle.', 39, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'angles_centre_circumference', 'Centre & Circumference', 'Centre & Circumference', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cyclic_quadrilaterals', 'Cyclic Quadrilaterals', 'Cyclic Quadrilaterals', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tangent_angles', 'Tangent Angles', 'Tangent Angles', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'angle_properties_circle'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'vectors_i', 'Vectors I', 'KCSE Mathematics — Vectors I.', 40, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vector_notation', 'Notation', 'Notation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'addition_subtraction', 'Addition & Subtraction', 'Addition & Subtraction', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'column_vectors', 'Column Vectors', 'Column Vectors', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'quadratic_equations_ii', 'Quadratic Expressions and Equations II', 'KCSE Mathematics — Quadratic Expressions and Equations II.', 41, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'completing_square', 'Completing the Square', 'Completing the Square', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'quadratic_formula', 'Quadratic Formula', 'Quadratic Formula', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'graphs_quadratics', 'Quadratic Graphs', 'Quadratic Graphs', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'quadratic_equations_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'approximations_errors', 'Approximations and Errors', 'KCSE Mathematics — Approximations and Errors.', 42, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rounding_estimation', 'Rounding & Estimation', 'Rounding & Estimation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'absolute_relative_error', 'Absolute & Relative Error', 'Absolute & Relative Error', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'propagation', 'Error Propagation', 'Error Propagation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'approximations_errors'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'trigonometry_ii', 'Trigonometry II', 'KCSE Mathematics — Trigonometry II.', 43, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'unit_circle', 'Unit Circle', 'Unit Circle', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'trig_graphs', 'Trig Graphs', 'Trig Graphs', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sine_cosine_rules', 'Sine & Cosine Rules', 'Sine & Cosine Rules', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'surds', 'Surds', 'KCSE Mathematics — Surds.', 44, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simplifying_surds', 'Simplifying Surds', 'Simplifying Surds', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'operations_surds', 'Operations', 'Operations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rationalising', 'Rationalising the Denominator', 'Rationalising the Denominator', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'surds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'further_logarithms', 'Further Logarithms', 'KCSE Mathematics — Further Logarithms.', 45, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'laws_logarithms', 'Laws of Logarithms', 'Laws of Logarithms', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'further_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'logarithmic_equations', 'Logarithmic Equations', 'Logarithmic Equations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'further_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_logs', 'Applications', 'Applications', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'further_logarithms'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'commercial_arithmetic_ii', 'Commercial Arithmetic II', 'KCSE Mathematics — Commercial Arithmetic II.', 46, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'compound_interest', 'Compound Interest', 'Compound Interest', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'appreciation_depreciation', 'Appreciation & Depreciation', 'Appreciation & Depreciation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hire_purchase', 'Hire Purchase & Taxes', 'Hire Purchase & Taxes', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'commercial_arithmetic_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'circles_chords_tangents', 'Circles: Chords and Tangents', 'KCSE Mathematics — Circles: Chords and Tangents.', 47, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'chord_properties', 'Chord Properties', 'Chord Properties', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tangent_properties', 'Tangent Properties', 'Tangent Properties', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'intersecting_chords', 'Intersecting Chords', 'Intersecting Chords', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'circles_chords_tangents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'matrices', 'Matrices', 'KCSE Mathematics — Matrices.', 48, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'matrix_operations', 'Operations', 'Operations', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'determinant_inverse', 'Determinant & Inverse', 'Determinant & Inverse', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simultaneous_matrices', 'Simultaneous Equations', 'Simultaneous Equations', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'formulae_variations', 'Formulae and Variations', 'KCSE Mathematics — Formulae and Variations.', 49, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'subject_of_formula', 'Change of Subject', 'Change of Subject', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'formulae_variations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'direct_inverse_variation', 'Direct & Inverse Variation', 'Direct & Inverse Variation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'formulae_variations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'joint_partial', 'Joint & Partial Variation', 'Joint & Partial Variation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'formulae_variations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'sequences_series', 'Sequences and Series', 'KCSE Mathematics — Sequences and Series.', 50, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'arithmetic_progression', 'Arithmetic Progression', 'Arithmetic Progression', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'sequences_series'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'geometric_progression', 'Geometric Progression', 'Geometric Progression', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'sequences_series'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'series_sums', 'Series & Sums', 'Series & Sums', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'sequences_series'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'vectors_ii', 'Vectors II', 'KCSE Mathematics — Vectors II.', 51, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'position_vectors', 'Position Vectors', 'Position Vectors', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ratio_theorem', 'Ratio Theorem', 'Ratio Theorem', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vector_geometry', 'Vector Geometry', 'Vector Geometry', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'vectors_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'binomial_expansion', 'Binomial Expansion', 'KCSE Mathematics — Binomial Expansion.', 52, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'pascals_triangle', 'Pascal''s Triangle', 'Pascal''s Triangle', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'expansion_binomial', 'Expansion', 'Expansion', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'approximations_binomial', 'Approximations', 'Approximations', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'binomial_expansion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'probability', 'Probability', 'KCSE Mathematics — Probability.', 53, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'experimental_theoretical', 'Experimental & Theoretical', 'Experimental & Theoretical', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'combined_events', 'Combined Events', 'Combined Events', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tree_diagrams', 'Tree Diagrams', 'Tree Diagrams', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'probability'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'compound_proportions_rates_work', 'Compound Proportions and Rates of Work', 'KCSE Mathematics — Compound Proportions and Rates of Work.', 54, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'compound_proportion', 'Compound Proportion', 'Compound Proportion', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mixtures', 'Mixtures', 'Mixtures', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rates_of_work', 'Rates of Work', 'Rates of Work', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'compound_proportions_rates_work'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'graphical_methods', 'Graphical Methods', 'KCSE Mathematics — Graphical Methods.', 55, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tables_graphs', 'Tables & Graphs', 'Tables & Graphs', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'graphical_methods'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'linear_laws', 'Linear Laws', 'Linear Laws', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'graphical_methods'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'graphical_solutions', 'Graphical Solutions', 'Graphical Solutions', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'graphical_methods'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'matrices_transformations', 'Matrices and Transformations', 'KCSE Mathematics — Matrices and Transformations.', 56, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'transformation_matrices', 'Transformation Matrices', 'Transformation Matrices', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'successive_transformations', 'Successive Transformations', 'Successive Transformations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_scale_factor', 'Area Scale Factor', 'Area Scale Factor', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'matrices_transformations'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'statistics_ii', 'Statistics II', 'KCSE Mathematics — Statistics II.', 57, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'grouped_data', 'Grouped Data', 'Grouped Data', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mean_grouped', 'Mean of Grouped Data', 'Mean of Grouped Data', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'quartiles_deviation', 'Quartiles & Standard Deviation', 'Quartiles & Standard Deviation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'statistics_ii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'loci', 'Loci', 'KCSE Mathematics — Loci.', 58, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'locus_points', 'Locus of Points', 'Locus of Points', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'constructed_loci', 'Constructed Loci', 'Constructed Loci', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'intersecting_loci', 'Intersecting Loci', 'Intersecting Loci', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'loci'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'trigonometry_iii', 'Trigonometry III', 'KCSE Mathematics — Trigonometry III.', 59, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'trig_ratios_general', 'General Angles', 'General Angles', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'trig_equations', 'Trigonometric Equations', 'Trigonometric Equations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'amplitude_period', 'Amplitude & Period', 'Amplitude & Period', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'trigonometry_iii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'three_dimensional_geometry', 'Three Dimensional Geometry', 'KCSE Mathematics — Three Dimensional Geometry.', 60, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'geometric_properties_3d', 'Properties of Solids', 'Properties of Solids', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'three_dimensional_geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'angles_3d', 'Angles in 3-D', 'Angles in 3-D', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'three_dimensional_geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'distances_3d', 'Distances in 3-D', 'Distances in 3-D', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'three_dimensional_geometry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'longitudes_latitudes', 'Longitudes and Latitudes', 'KCSE Mathematics — Longitudes and Latitudes.', 61, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'position_earth', 'Position on the Earth', 'Position on the Earth', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'distances_great_circles', 'Distances & Great Circles', 'Distances & Great Circles', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'time_longitude', 'Time & Longitude', 'Time & Longitude', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'longitudes_latitudes'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'linear_programming', 'Linear Programming', 'KCSE Mathematics — Linear Programming.', 62, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'forming_inequalities', 'Forming Inequalities', 'Forming Inequalities', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'graphical_region_lp', 'Feasible Region', 'Feasible Region', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'optimisation', 'Optimisation', 'Optimisation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'linear_programming'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'differentiation', 'Differentiation', 'KCSE Mathematics — Differentiation.', 63, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'gradient_function', 'Gradient Function', 'Gradient Function', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'derivatives', 'Derivatives', 'Derivatives', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_differentiation', 'Rates, Maxima & Minima', 'Rates, Maxima & Minima', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'differentiation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'area_approximation', 'Area Approximation', 'KCSE Mathematics — Area Approximation.', 64, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'trapezium_rule', 'Trapezium Rule', 'Trapezium Rule', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_approximation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mid_ordinate_rule', 'Mid-Ordinate Rule', 'Mid-Ordinate Rule', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_approximation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'comparisons', 'Comparisons', 'Comparisons', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'area_approximation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'integration', 'Integration', 'KCSE Mathematics — Integration.', 65, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'indefinite_integrals', 'Indefinite Integrals', 'Indefinite Integrals', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integration'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'definite_integrals', 'Definite Integrals', 'Definite Integrals', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integration'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'area_under_curve', 'Area Under a Curve', 'Area Under a Curve', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integration'
ON CONFLICT (topic_id, code) DO NOTHING;

-- Deprecate generic placeholder topics superseded by granular KCSE syllabus topics (fractions stays active)
UPDATE public.topics t
SET is_active = false
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE t.subject_id = s.id
  AND c.code = 'KCSE'
  AND s.code = 'mathematics'
  AND t.code IN ('algebra', 'geometry', 'trigonometry', 'statistics');
