-- KCSE Mathematics content deploy (skeleton + slice + Form 1 Batch 1)
-- Idempotent; safe to re-run. Bundles existing seed content for hosted deploy via 'supabase db push'.
-- Prereq present on hosted: curricula (KCSE), subjects (mathematics), legacy fractions topic.

-- ===== 1/3 KCSE skeleton (topics + subtopics) =====
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

-- ===== 2/3 Slice content (integers, algebraic_expressions, rates_ratio_proportion; soft-retire legacy) =====
-- KCSE Form 1 Mathematics content slice (integers, algebraic_expressions, rates_ratio_proportion)
-- Idempotent seed: lessons + practice questions; soft-retires legacy generic KCSE math topics.

-- Soft-retire legacy generic KCSE math topics (CBC topics with same codes are untouched)
UPDATE public.topics t
SET is_active = false
FROM public.subjects s, public.curricula c
WHERE t.subject_id = s.id AND s.curriculum_id = c.id
  AND c.code = 'KCSE' AND s.code = 'mathematics'
  AND t.code IN ('algebra','fractions','geometry','trigonometry','statistics');

-- Added subtopics (confirmed Form 1 KNEC scope)
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'integer_applications', 'Integers in Real Life', 'Real-life integer problems.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'percentage_applications', 'Percentage Applications', 'Profit, loss, discount and commission.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion'
ON CONFLICT (topic_id, code) DO NOTHING;


-- ========== INTEGERS CONTENT ==========





INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Integers on the Number Line', '{"blocks":[{"type":"heading","content":"Integers on the Number Line"},{"type":"paragraph","content":"Integers are whole numbers and their opposites: $\\ldots, -3, -2, -1, 0, 1, 2, 3, \\ldots$ Numbers greater than zero are positive; numbers less than zero are negative; zero is neither."},{"type":"math_block","latex":"\\ldots\\; -3 \\; -2 \\; -1 \\; 0 \\; 1 \\; 2 \\; 3 \\; \\ldots","caption":"A number line: values increase to the right."},{"type":"callout","variant":"key_point","content":"On a number line, a number to the right is always greater. So $-1 > -3$, even though 3 looks bigger than 1."},{"type":"paragraph","content":"We use integers every day: a temperature of $-4^{\\circ}\\text{C}$, a debt of KES 200 written as $-200$, or 50 m below sea level as $-50$."},{"type":"example","title":"Order these from smallest to largest: $2, -5, 0, -1, 3$","steps":["Place each on the number line in your mind: the further left, the smaller.","The most negative is $-5$, then $-1$, then $0$, then $2$, then $3$."],"answer":"$-5, -1, 0, 2, 3$"},{"type":"callout","variant":"warning","content":"A common mistake is thinking $-5 > -1$ because 5 > 1. With negatives it is the opposite: $-5 < -1$."},{"type":"question","questionText":"Which number is greater: $-7$ or $-2$?","questionType":"multiple_choice","options":["$-7$","$-2$","They are equal","Cannot tell"],"correctAnswer":"$-2$","explanation":"On the number line $-2$ is to the right of $-7$, so $-2 > -7$."}],"shortQuiz":{"questions":[{"questionText":"Which of these is the smallest integer?","options":["$-3$","$-10$","$0$","$4$"],"correctAnswer":"$-10$"}]}}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Adding and Subtracting Integers', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Integers"},{"type":"paragraph","content":"When adding integers with the same sign, add the magnitudes and keep the sign. When signs differ, subtract the smaller magnitude from the larger and keep the sign of the larger."},{"type":"callout","variant":"key_point","content":"Subtracting a number is the same as adding its opposite: $a - b = a + (-b)$."},{"type":"example","title":"Evaluate $(-8) + (-3)$","steps":["Both numbers are negative — add magnitudes: $8 + 3 = 11$.","Keep the negative sign: $(-8) + (-3) = -11$."],"answer":"$-11$"},{"type":"example","title":"Evaluate $7 - (-4)$","steps":["Subtracting $-4$ means adding $+4$.","$7 + 4 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"Do not write $7 - -4$ without brackets — use $7 - (-4)$ to avoid sign errors."},{"type":"question","questionText":"Evaluate $5 + (-9)$.","questionType":"multiple_choice","options":["$-4$","$4$","$-14$","$14$"],"correctAnswer":"$-4$","explanation":"Signs differ: $9 - 5 = 4$; the larger magnitude is negative, so $-4$."}]}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Multiplying and Dividing Integers', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Integers"},{"type":"paragraph","content":"Same signs give a positive result. Different signs give a negative result."},{"type":"math_block","latex":"(+) \\times (+) = (+) \\quad (-) \\times (-) = (+) \\quad (+) \\times (-) = (-)","caption":"Sign rules for multiplication (division follows the same rules)."},{"type":"example","title":"Evaluate $(-6) \\times 4$","steps":["Signs are different, so the answer is negative.","$(-6) \\times 4 = -24$."],"answer":"$-24$"},{"type":"example","title":"Evaluate $(-20) \\div (-5)$","steps":["Both negative — result is positive.","$(-20) \\div (-5) = 4$."],"answer":"$4$"},{"type":"question","questionText":"Evaluate $(-3) \\times (-7)$.","questionType":"multiple_choice","options":["$21$","$-21$","$-10$","$10$"],"correctAnswer":"$21$","explanation":"Negative times negative = positive: $3 \\times 7 = 21$."}]}'::jsonb, 10, 2

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'BODMAS with Integers', '{"blocks":[{"type":"heading","content":"Order of Operations (BODMAS)"},{"type":"paragraph","content":"When an expression mixes operations, follow BODMAS: Brackets, Orders (powers), Division and Multiplication (left to right), Addition and Subtraction (left to right)."},{"type":"example","title":"Evaluate $3 + 4 \\times (-2)$","steps":["Multiplication before addition: $4 \\times (-2) = -8$.","$3 + (-8) = -5$."],"answer":"$-5$"},{"type":"example","title":"Evaluate $(6 - 10) \\div 2 + 3$","steps":["Brackets first: $6 - 10 = -4$.","Division: $(-4) \\div 2 = -2$.","Addition: $-2 + 3 = 1$."],"answer":"$1$"},{"type":"callout","variant":"warning","content":"A common mistake is working left to right and doing $3 + 4$ first in $3 + 4 \\times 2$."},{"type":"question","questionText":"Evaluate $2 \\times (5 - 8)^2$.","questionType":"multiple_choice","options":["$18$","$-18$","$36$","$-36$"],"correctAnswer":"$18$","explanation":"Brackets: $5-8=-3$; order: $(-3)^2=9$; $2 \\times 9 = 18$."}]}'::jsonb, 12, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'order_of_operations'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Integers'

);



INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)

SELECT st.id, 'Integers in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Integers in Real Life"},{"type":"paragraph","content":"Integers model gains and losses: profit/loss in KES, temperature changes, altitude above/below sea level, and football goal differences."},{"type":"example","title":"A trader starts with KES 500. She makes a profit of KES 120, then a loss of KES 80. What is her net change?","steps":["Represent profit as $+120$ and loss as $-80$.","Net change: $120 + (-80) = 40$."],"answer":"Net gain of KES $40$"},{"type":"example","title":"The temperature at 6 a.m. was $-2^{\\circ}\\text{C}$. By noon it rose $9^{\\circ}\\text{C}$. What was the noon temperature?","steps":["Rise means add: $-2 + 9 = 7$."],"answer":"$7^{\\circ}\\text{C}$"},{"type":"callout","variant":"warning","content":"In word problems, decide whether each change is positive or negative before you calculate."},{"type":"question","questionText":"A submarine is at $-45$ m. It rises $20$ m. What is its new depth?","questionType":"multiple_choice","options":["$-25$ m","$-65$ m","$25$ m","$65$ m"],"correctAnswer":"$-25$ m","explanation":"Rising $20$ m: $-45 + 20 = -25$."}]}'::jsonb, 10, 1

FROM public.subtopics st

JOIN public.topics t ON t.id = st.topic_id

JOIN public.subjects s ON s.id = t.subject_id

JOIN public.curricula c ON c.id = s.curriculum_id

WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'integer_applications'

AND NOT EXISTS (

  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers in Kenyan Contexts'

);



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Which integer is greatest?', 'multiple_choice', '["$-4$","$-1$","$-9$","$-6$"]'::jsonb, '"$-1$"'::jsonb, 'easy', 'On the number line $-1$ is furthest right.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which integer is greatest?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Which is the smallest: $3, -2, 0, -5$?', 'multiple_choice', '["$3$","$-2$","$0$","$-5$"]'::jsonb, '"$-5$"'::jsonb, 'easy', '$-5$ is furthest left on the number line.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the smallest: $3, -2, 0, -5$?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-3) + (-5)$.', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Adding two negatives: add magnitudes, keep negative sign.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-3) + (-5)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $8 - 12$.', 'multiple_choice', '["$-4$","$4$","$20$","$-20$"]'::jsonb, '"$-4$"'::jsonb, 'easy', '$8 - 12 = -4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $8 - 12$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-4) \times 3$.', 'multiple_choice', '["$-12$","$12$","$-7$","$7$"]'::jsonb, '"$-12$"'::jsonb, 'easy', 'Different signs: negative result.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-4) \times 3$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $15 \div (-3)$.', 'multiple_choice', '["$-5$","$5$","$-12$","$12$"]'::jsonb, '"$-5$"'::jsonb, 'easy', 'Different signs give a negative quotient.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \div (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $10 - 3 \times 2$.', 'multiple_choice', '["$4$","$14$","$-4$","$16$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Multiply first: $3 \times 2 = 6$; $10 - 6 = 4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10 - 3 \times 2$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'A bank balance of $-500$ KES means:', 'multiple_choice', '["A debt of KES 500","A credit of KES 500","Zero balance","KES 1000 credit"]'::jsonb, '"A debt of KES 500"'::jsonb, 'easy', 'Negative balance represents money owed.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bank balance of $-500$ KES means:');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-7 - (-3)$.', 'multiple_choice', '["$-4$","$-10$","$4$","$10$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$-7 - (-3) = -7 + 3 = -4$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-7 - (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-6) \times 4 \div (-2)$.', 'multiple_choice', '["$12$","$-12$","$-48$","$48$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Left to right: $-24 \div -2 = 12$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-6) \times 4 \div (-2)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-2) + 5 - 8$.', 'multiple_choice', '["$-5$","$5$","$-15$","$15$"]'::jsonb, '"$-5$"'::jsonb, 'medium', 'Left to right: $3 - 8 = -5$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2) + 5 - 8$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $4 + 3 \times (-2)^2$.', 'multiple_choice', '["$16$","$-8$","$10$","$-32$"]'::jsonb, '"$16$"'::jsonb, 'medium', 'Power first: $(-2)^2=4$; $3 \times 4=12$; $4+12=16$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $4 + 3 \times (-2)^2$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(8 - 14) \div 3 + 5$.', 'multiple_choice', '["$3$","$-3$","$7$","$-7$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Brackets: $-6 \div 3 = -2$; $-2 + 5 = 3$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(8 - 14) \div 3 + 5$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-3 \times (4 - 7)$.', 'multiple_choice', '["$9$","$-9$","$-21$","$21$"]'::jsonb, '"$9$"'::jsonb, 'medium', 'Brackets: $4-7=-3$; $-3 \times -3 = 9$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-3 \times (4 - 7)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?', 'multiple_choice', '["$-5^{\\circ}\\text{C}$","$5^{\\circ}\\text{C}$","$11^{\\circ}\\text{C}$","$-11^{\\circ}\\text{C}$"]'::jsonb, '"$-5^{\\circ}\\text{C}$"'::jsonb, 'medium', '$3 + (-8) = -5$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Football: scored $4$, conceded $7$. Goal difference?', 'multiple_choice', '["$-3$","$3$","$11$","$-11$"]'::jsonb, '"$-3$"'::jsonb, 'medium', 'Difference: $4 - 7 = -3$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Football: scored $4$, conceded $7$. Goal difference?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-2)^3 + (-1)^4$.', 'multiple_choice', '["$-7$","$7$","$-9$","$9$"]'::jsonb, '"$-7$"'::jsonb, 'hard', '$(-2)^3=-8$; $(-1)^4=1$; $-8+1=-7$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2)^3 + (-1)^4$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $6 \div (-2) + 4 \times (-3)$.', 'multiple_choice', '["$-15$","$15$","$-9$","$9$"]'::jsonb, '"$-15$"'::jsonb, 'hard', '$-3 + (-12) = -15$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $6 \div (-2) + 4 \times (-3)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?', 'multiple_choice', '["$1^{\\circ}\\text{C}$","$-1^{\\circ}\\text{C}$","$9^{\\circ}\\text{C}$","$21^{\\circ}\\text{C}$"]'::jsonb, '"$1^{\\circ}\\text{C}$"'::jsonb, 'hard', '$-4+11=7$; $7-6=1$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?', 'multiple_choice', '["$-1$","$1$","$-5$","$5$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$0+12-18+5=-1$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.', 'multiple_choice', '["$24$","$-24$","$10$","$-10$"]'::jsonb, '"$24$"'::jsonb, 'hard', 'Four negatives: pairs give positives; product is $24$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.', 'multiple_choice', '["$-27$","$27$","$-23$","$23$"]'::jsonb, '"$-27$"'::jsonb, 'hard', '$(3-8)=-5$; $(-5)^2=25$; $-25+2(-1)=-27$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'How many integers lie strictly between $-3$ and $4$?', 'multiple_choice', '["$6$","$7$","$8$","$5$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Integers: $-2,-1,0,1,2,3$ — six values.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers lie strictly between $-3$ and $4$?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?', 'multiple_choice', '["KES $30$ profit","KES $30$ loss","KES $830$ profit","KES $830$ loss"]'::jsonb, '"KES $30$ profit"'::jsonb, 'hard', '$250-400+180=30$ net profit.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?');



INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)

SELECT t.id, st.id, 'If $a = -3$ and $b = -4$, evaluate $2a - b$.', 'multiple_choice', '["$-2$","$2$","$-10$","$10$"]'::jsonb, '"$-2$"'::jsonb, 'hard', '$2(-3)-(-4)=-6+4=-2$.'

FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id

JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'

WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'

AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = -3$ and $b = -4$, evaluate $2a - b$.');



-- ========== INTEGERS CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers on the Number Line', '{"blocks":[{"type":"heading","content":"Integers on the Number Line"},{"type":"paragraph","content":"Integers are whole numbers and their opposites: $\\ldots, -3, -2, -1, 0, 1, 2, 3, \\ldots$ Numbers greater than zero are positive; numbers less than zero are negative; zero is neither."},{"type":"math_block","latex":"\\ldots\\; -3 \\; -2 \\; -1 \\; 0 \\; 1 \\; 2 \\; 3 \\; \\ldots","caption":"A number line: values increase to the right."},{"type":"callout","variant":"key_point","content":"On a number line, a number to the right is always greater. So $-1 > -3$, even though 3 looks bigger than 1."},{"type":"paragraph","content":"We use integers every day: a temperature of $-4^{\\circ}\\text{C}$, a debt of KES 200 written as $-200$, or 50 m below sea level as $-50$."},{"type":"example","title":"Order these from smallest to largest: $2, -5, 0, -1, 3$","steps":["Place each on the number line in your mind: the further left, the smaller.","The most negative is $-5$, then $-1$, then $0$, then $2$, then $3$."],"answer":"$-5, -1, 0, 2, 3$"},{"type":"callout","variant":"warning","content":"A common mistake is thinking $-5 > -1$ because 5 > 1. With negatives it is the opposite: $-5 < -1$."},{"type":"question","questionText":"Which number is greater: $-7$ or $-2$?","questionType":"multiple_choice","options":["$-7$","$-2$","They are equal","Cannot tell"],"correctAnswer":"$-2$","explanation":"On the number line $-2$ is to the right of $-7$, so $-2 > -7$."}],"shortQuiz":{"questions":[{"questionText":"Which of these is the smallest integer?","options":["$-3$","$-10$","$0$","$4$"],"correctAnswer":"$-10$"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'number_line_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers on the Number Line');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Integers', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Integers"},{"type":"paragraph","content":"When adding integers with the same sign, add the magnitudes and keep the sign. When signs differ, subtract the smaller magnitude from the larger and keep the sign of the larger."},{"type":"callout","variant":"key_point","content":"Subtracting a number is the same as adding its opposite: $a - b = a + (-b)$."},{"type":"example","title":"Evaluate $(-8) + (-3)$","steps":["Both numbers are negative — add magnitudes: $8 + 3 = 11$.","Keep the negative sign: $(-8) + (-3) = -11$."],"answer":"$-11$"},{"type":"example","title":"Evaluate $7 - (-4)$","steps":["Subtracting $-4$ means adding $+4$.","$7 + 4 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"Do not write $7 - -4$ without brackets — use $7 - (-4)$ to avoid sign errors."},{"type":"question","questionText":"Evaluate $5 + (-9)$.","questionType":"multiple_choice","options":["$-4$","$4$","$-14$","$14$"],"correctAnswer":"$-4$","explanation":"Signs differ: $9 - 5 = 4$; the larger magnitude is negative, so $-4$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying and Dividing Integers', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Integers"},{"type":"paragraph","content":"Same signs give a positive result. Different signs give a negative result."},{"type":"math_block","latex":"(+) \\times (+) = (+) \\quad (-) \\times (-) = (+) \\quad (+) \\times (-) = (-)","caption":"Sign rules for multiplication (division follows the same rules)."},{"type":"example","title":"Evaluate $(-6) \\times 4$","steps":["Signs are different, so the answer is negative.","$(-6) \\times 4 = -24$."],"answer":"$-24$"},{"type":"example","title":"Evaluate $(-20) \\div (-5)$","steps":["Both negative — result is positive.","$(-20) \\div (-5) = 4$."],"answer":"$4$"},{"type":"question","questionText":"Evaluate $(-3) \\times (-7)$.","questionType":"multiple_choice","options":["$21$","$-21$","$-10$","$10$"],"correctAnswer":"$21$","explanation":"Negative times negative = positive: $3 \\times 7 = 21$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'operations_integers'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'BODMAS with Integers', '{"blocks":[{"type":"heading","content":"Order of Operations (BODMAS)"},{"type":"paragraph","content":"When an expression mixes operations, follow BODMAS: Brackets, Orders (powers), Division and Multiplication (left to right), Addition and Subtraction (left to right)."},{"type":"example","title":"Evaluate $3 + 4 \\times (-2)$","steps":["Multiplication before addition: $4 \\times (-2) = -8$.","$3 + (-8) = -5$."],"answer":"$-5$"},{"type":"example","title":"Evaluate $(6 - 10) \\div 2 + 3$","steps":["Brackets first: $6 - 10 = -4$.","Division: $(-4) \\div 2 = -2$.","Addition: $-2 + 3 = 1$."],"answer":"$1$"},{"type":"callout","variant":"warning","content":"A common mistake is working left to right and doing $3 + 4$ first in $3 + 4 \\times 2$."},{"type":"question","questionText":"Evaluate $2 \\times (5 - 8)^2$.","questionType":"multiple_choice","options":["$18$","$-18$","$36$","$-36$"],"correctAnswer":"$18$","explanation":"Brackets: $5-8=-3$; order: $(-3)^2=9$; $2 \\times 9 = 18$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'order_of_operations'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Integers');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Integers in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Integers in Real Life"},{"type":"paragraph","content":"Integers model gains and losses: profit/loss in KES, temperature changes, altitude above/below sea level, and football goal differences."},{"type":"example","title":"A trader makes a profit of KES 120, then a loss of KES 80. What is her net change?","steps":["Represent profit as $+120$ and loss as $-80$.","Net change: $120 + (-80) = 40$."],"answer":"Net gain of KES $40$"},{"type":"example","title":"The temperature at 6 a.m. was $-2^{\\circ}\\text{C}$. By noon it rose $9^{\\circ}\\text{C}$. What was the noon temperature?","steps":["Rise means add: $-2 + 9 = 7$."],"answer":"$7^{\\circ}\\text{C}$"},{"type":"callout","variant":"warning","content":"In word problems, decide whether each change is positive or negative before you calculate."},{"type":"question","questionText":"A submarine is at $-45$ m. It rises $20$ m. What is its new depth?","questionType":"multiple_choice","options":["$-25$ m","$-65$ m","$25$ m","$65$ m"],"correctAnswer":"$-25$ m","explanation":"Rising $20$ m: $-45 + 20 = -25$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'integers' AND st.code = 'integer_applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Integers in Kenyan Contexts');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which integer is greatest?', 'multiple_choice', '["$-4$","$-1$","$-9$","$-6$"]'::jsonb, '"$-1$"'::jsonb, 'easy', 'On the number line $-1$ is furthest right.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which integer is greatest?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is the smallest: $3, -2, 0, -5$?', 'multiple_choice', '["$3$","$-2$","$0$","$-5$"]'::jsonb, '"$-5$"'::jsonb, 'easy', '$-5$ is furthest left on the number line.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the smallest: $3, -2, 0, -5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-3) + (-5)$.', 'multiple_choice', '["$-8$","$8$","$-2$","$2$"]'::jsonb, '"$-8$"'::jsonb, 'easy', 'Adding two negatives: add magnitudes, keep negative sign.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-3) + (-5)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $8 - 12$.', 'multiple_choice', '["$-4$","$4$","$20$","$-20$"]'::jsonb, '"$-4$"'::jsonb, 'easy', '$8 - 12 = -4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $8 - 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-4) \times 3$.', 'multiple_choice', '["$-12$","$12$","$-7$","$7$"]'::jsonb, '"$-12$"'::jsonb, 'easy', 'Different signs: negative result.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-4) \times 3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $15 \div (-3)$.', 'multiple_choice', '["$-5$","$5$","$-12$","$12$"]'::jsonb, '"$-5$"'::jsonb, 'easy', 'Different signs give a negative quotient.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \div (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $10 - 3 \times 2$.', 'multiple_choice', '["$4$","$14$","$-4$","$16$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Multiply first: $3 \times 2 = 6$; $10 - 6 = 4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10 - 3 \times 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A bank balance of $-500$ KES means:', 'multiple_choice', '["A debt of KES 500","A credit of KES 500","Zero balance","KES 1000 credit"]'::jsonb, '"A debt of KES 500"'::jsonb, 'easy', 'Negative balance represents money owed.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bank balance of $-500$ KES means:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-7 - (-3)$.', 'multiple_choice', '["$-4$","$-10$","$4$","$10$"]'::jsonb, '"$-4$"'::jsonb, 'medium', '$-7 - (-3) = -7 + 3 = -4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-7 - (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-6) \times 4 \div (-2)$.', 'multiple_choice', '["$12$","$-12$","$-48$","$48$"]'::jsonb, '"$12$"'::jsonb, 'medium', 'Left to right: $-24 \div -2 = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-6) \times 4 \div (-2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-2) + 5 - 8$.', 'multiple_choice', '["$-5$","$5$","$-15$","$15$"]'::jsonb, '"$-5$"'::jsonb, 'medium', 'Left to right: $3 - 8 = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2) + 5 - 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $4 + 3 \times (-2)^2$.', 'multiple_choice', '["$16$","$-8$","$10$","$-32$"]'::jsonb, '"$16$"'::jsonb, 'medium', 'Power first: $(-2)^2=4$; $3 \times 4=12$; $4+12=16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $4 + 3 \times (-2)^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(8 - 14) \div 3 + 5$.', 'multiple_choice', '["$3$","$-3$","$7$","$-7$"]'::jsonb, '"$3$"'::jsonb, 'medium', 'Brackets: $-6 \div 3 = -2$; $-2 + 5 = 3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(8 - 14) \div 3 + 5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-3 \times (4 - 7)$.', 'multiple_choice', '["$9$","$-9$","$-21$","$21$"]'::jsonb, '"$9$"'::jsonb, 'medium', 'Brackets: $4-7=-3$; $-3 \times -3 = 9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-3 \times (4 - 7)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?', 'multiple_choice', '["$-5^{\\circ}\\text{C}$","$5^{\\circ}\\text{C}$","$11^{\\circ}\\text{C}$","$-11^{\\circ}\\text{C}$"]'::jsonb, '"$-5^{\\circ}\\text{C}$"'::jsonb, 'medium', '$3 + (-8) = -5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Morning temperature $3^{\circ}\text{C}$, dropped $8^{\circ}\text{C}$ by night. Night temperature?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Football: scored $4$, conceded $7$. Goal difference?', 'multiple_choice', '["$-3$","$3$","$11$","$-11$"]'::jsonb, '"$-3$"'::jsonb, 'medium', 'Difference: $4 - 7 = -3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Football: scored $4$, conceded $7$. Goal difference?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-2)^3 + (-1)^4$.', 'multiple_choice', '["$-7$","$7$","$-9$","$9$"]'::jsonb, '"$-7$"'::jsonb, 'hard', '$(-2)^3=-8$; $(-1)^4=1$; $-8+1=-7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-2)^3 + (-1)^4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $6 \div (-2) + 4 \times (-3)$.', 'multiple_choice', '["$-15$","$15$","$-9$","$9$"]'::jsonb, '"$-15$"'::jsonb, 'hard', '$-3 + (-12) = -15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $6 \div (-2) + 4 \times (-3)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?', 'multiple_choice', '["$1^{\\circ}\\text{C}$","$-1^{\\circ}\\text{C}$","$9^{\\circ}\\text{C}$","$21^{\\circ}\\text{C}$"]'::jsonb, '"$1^{\\circ}\\text{C}$"'::jsonb, 'hard', '$-4+11=7$; $7-6=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At dawn the temperature was $-4^{\circ}\text{C}$. By noon it rose $11^{\circ}\text{C}$, then fell $6^{\circ}\text{C}$ by evening. Evening temperature?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?', 'multiple_choice', '["$-1$","$1$","$-5$","$5$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$0+12-18+5=-1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A lift starts at ground ($0$), goes up $12$ floors, down $18$, then up $5$. Final floor?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.', 'multiple_choice', '["$24$","$-24$","$10$","$-10$"]'::jsonb, '"$24$"'::jsonb, 'hard', 'Four negatives: pairs give positives; product is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(-1) \times (-2) \times (-3) \times (-4)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.', 'multiple_choice', '["$-27$","$27$","$-23$","$23$"]'::jsonb, '"$-27$"'::jsonb, 'hard', '$(3-8)=-5$; $(-5)^2=25$; $-25+2(-1)=-27$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='order_of_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $-(3 - 8)^2 + 2 \times (-1)^3$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many integers lie strictly between $-3$ and $4$?', 'multiple_choice', '["$6$","$7$","$8$","$5$"]'::jsonb, '"$6$"'::jsonb, 'hard', 'Integers: $-2,-1,0,1,2,3$ — six values.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers lie strictly between $-3$ and $4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?', 'multiple_choice', '["KES $30$ profit","KES $30$ loss","KES $830$ profit","KES $830$ loss"]'::jsonb, '"KES $30$ profit"'::jsonb, 'hard', '$250-400+180=30$ net profit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='integer_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Trader: starts KES $0$, profit KES $250$, loss KES $400$, profit KES $180$. Final position?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a = -3$ and $b = -4$, evaluate $2a - b$.', 'multiple_choice', '["$-2$","$2$","$-10$","$10$"]'::jsonb, '"$-2$"'::jsonb, 'hard', '$2(-3)-(-4)=-6+4=-2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_integers'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='integers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = -3$ and $b = -4$, evaluate $2a - b$.');
-- ========== ALGEBRAIC EXPRESSIONS CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'From Words to Algebra', '{"blocks":[{"type":"heading","content":"Forming Algebraic Expressions"},{"type":"paragraph","content":"An algebraic expression uses letters (variables) to stand for unknown numbers. We translate word statements into symbols."},{"type":"callout","variant":"key_point","content":"Common phrases: ''sum of'' $\\rightarrow$ add; ''product of'' $\\rightarrow$ multiply; ''twice'' $\\rightarrow$ $2\\times$; ''more than'' $\\rightarrow$ add after the number."},{"type":"example","title":"Write an expression for: five more than a number $n$","steps":["''Five more than'' means add $5$ after the number.","Expression: $n + 5$."],"answer":"$n + 5$"},{"type":"example","title":"Write an expression for: the product of $3$ and a number $x$, decreased by $2$","steps":["Product of $3$ and $x$: $3x$.","Decreased by $2$: subtract $2$.","Expression: $3x - 2$."],"answer":"$3x - 2$"},{"type":"question","questionText":"Which expression means ''seven less than a number $y$''?","questionType":"multiple_choice","options":["$7 - y$","$y - 7$","$7y$","$y + 7$"],"correctAnswer":"$y - 7$","explanation":"''Less than $y$'' means start with $y$ and subtract $7$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'forming_expressions'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'From Words to Algebra');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expressions from Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Real-Life Expressions"},{"type":"example","title":"Matatu fare is KES $50$ plus KES $2$ per km. Write fare for $k$ km.","steps":["Fixed part: $50$.","Variable part: $2$ per km $\\rightarrow$ $2k$.","Total: $50 + 2k$."],"answer":"$50 + 2k$ KES"},{"type":"callout","variant":"warning","content":"Do not confuse ''KES $2$ per km'' ($2k$) with ''KES $2$ more than $k$'' ($k+2$)."},{"type":"question","questionText":"A shop sells $n$ notebooks at KES $80$ each. Write the total cost.","questionType":"multiple_choice","options":["$80n$","$n + 80$","$80 - n$","$n/80$"],"correctAnswer":"$80n$","explanation":"Total = price per item $\\times$ number of items."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'forming_expressions'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expressions from Kenyan Contexts');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Collecting Like Terms', '{"blocks":[{"type":"heading","content":"Simplifying by Collecting Like Terms"},{"type":"paragraph","content":"Like terms have the same variable part (e.g. $3x$ and $-5x$). Add or subtract their coefficients; constants stay separate."},{"type":"example","title":"Simplify $4x + 3 - 2x + 7$","steps":["Group $x$-terms: $4x - 2x = 2x$.","Group constants: $3 + 7 = 10$.","Result: $2x + 10$."],"answer":"$2x + 10$"},{"type":"example","title":"Simplify $5a - 3b + 2a + b$","steps":["$a$-terms: $5a + 2a = 7a$.","$b$-terms: $-3b + b = -2b$.","Result: $7a - 2b$."],"answer":"$7a - 2b$"},{"type":"callout","variant":"warning","content":"$3x$ and $3y$ are not like terms — do not combine them."},{"type":"question","questionText":"Simplify $6y - 4 + 2y + 1$.","questionType":"multiple_choice","options":["$8y - 3$","$8y + 5$","$4y - 3$","$4y + 5$"],"correctAnswer":"$8y - 3$","explanation":"$6y+2y=8y$; $-4+1=-3$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'simplification'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Collecting Like Terms');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Expanding Brackets', '{"blocks":[{"type":"heading","content":"Removing Brackets"},{"type":"paragraph","content":"Multiply each term inside the bracket by the term outside: $a(b + c) = ab + ac$."},{"type":"example","title":"Expand $3(x + 4)$","steps":["$3 \\times x = 3x$.","$3 \\times 4 = 12$.","Result: $3x + 12$."],"answer":"$3x + 12$"},{"type":"example","title":"Expand and simplify $2(3a - 1) + 4a$","steps":["Expand: $6a - 2$.","Add $4a$: $6a + 4a - 2 = 10a - 2$."],"answer":"$10a - 2$"},{"type":"question","questionText":"Expand $5(2m - 3)$.","questionType":"multiple_choice","options":["$10m - 15$","$10m - 3$","$7m - 15$","$2m - 15$"],"correctAnswer":"$10m - 15$","explanation":"$5 \\times 2m = 10m$; $5 \\times (-3) = -15$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'simplification'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Expanding Brackets');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Evaluating Expressions', '{"blocks":[{"type":"heading","content":"Substitution"},{"type":"paragraph","content":"To substitute, replace each variable with the given value, then calculate. Use brackets when substituting negatives."},{"type":"example","title":"If $x = 4$, find $3x + 5$.","steps":["Replace $x$ with $4$: $3(4) + 5$.","$12 + 5 = 17$."],"answer":"$17$"},{"type":"example","title":"If $a = -2$, find $a^2 - 3a + 1$.","steps":["$(-2)^2 = 4$.","$-3(-2) = 6$.","$4 + 6 + 1 = 11$."],"answer":"$11$"},{"type":"callout","variant":"warning","content":"When $x = -3$, write $2x$ as $2(-3)$, not $2-3$."},{"type":"question","questionText":"If $n = 5$, what is $2n - 7$?","questionType":"multiple_choice","options":["$3$","$17$","$-3$","$10$"],"correctAnswer":"$3$","explanation":"$2(5) - 7 = 10 - 7 = 3$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'algebraic_expressions' AND st.code = 'substitution'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Evaluating Expressions');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write ''a number $x$ increased by $9$'' as an expression.', 'multiple_choice', '["$x + 9$","$9x$","$x - 9$","$9 - x$"]'::jsonb, '"$x + 9$"'::jsonb, 'easy', '''Increased by'' means add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write ''a number $x$ increased by $9$'' as an expression.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which means ''double a number $n$''?', 'multiple_choice', '["$2n$","$n + 2$","$n^2$","$n/2$"]'::jsonb, '"$2n$"'::jsonb, 'easy', 'Double means multiply by $2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which means ''double a number $n$''?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cost is KES $100$ plus KES $5$ per item for $p$ items. Expression?', 'multiple_choice', '["$100 + 5p$","$105p$","$100p + 5$","$5 + 100p$"]'::jsonb, '"$100 + 5p$"'::jsonb, 'easy', 'Fixed $100$ plus $5$ per item.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cost is KES $100$ plus KES $5$ per item for $p$ items. Expression?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '''The sum of $a$ and $b$'' is:', 'multiple_choice', '["$a + b$","$ab$","$a - b$","$2ab$"]'::jsonb, '"$a + b$"'::jsonb, 'easy', 'Sum means add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='''The sum of $a$ and $b$'' is:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $5x + 2x$.', 'multiple_choice', '["$7x$","$10x$","$7x^2$","$3x$"]'::jsonb, '"$7x$"'::jsonb, 'easy', 'Add coefficients: $5+2=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $5x + 2x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $8 - 3 + 2$.', 'multiple_choice', '["$7$","$13$","$3$","$9$"]'::jsonb, '"$7$"'::jsonb, 'easy', 'Constants only: $8-3+2=7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $8 - 3 + 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $x = 3$, find $x + 4$.', 'multiple_choice', '["$7$","$12$","$1$","$34$"]'::jsonb, '"$7$"'::jsonb, 'easy', '$3 + 4 = 7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $x = 3$, find $x + 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $y = 10$, find $2y$.', 'multiple_choice', '["$20$","$12$","$5$","$100$"]'::jsonb, '"$20$"'::jsonb, 'easy', '$2 \times 10 = 20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $y = 10$, find $2y$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Perimeter of square of side $s$: which expression?', 'multiple_choice', '["$4s$","$s^4$","$s + 4$","$2s$"]'::jsonb, '"$4s$"'::jsonb, 'medium', 'Four equal sides: $s+s+s+s=4s$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Perimeter of square of side $s$: which expression?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '''$3$ less than twice $x$'' is:', 'multiple_choice', '["$2x - 3$","$3 - 2x$","$2x + 3$","$3x - 2$"]'::jsonb, '"$2x - 3$"'::jsonb, 'medium', 'Twice $x$ is $2x$; three less: $2x-3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='''$3$ less than twice $x$'' is:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tickets: adult KES $a$, child KES $c$. Cost of $2$ adults and $3$ children?', 'multiple_choice', '["$2a + 3c$","$5ac$","$a + c$","$6ac$"]'::jsonb, '"$2a + 3c$"'::jsonb, 'medium', 'Multiply each price by quantity and add.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tickets: adult KES $a$, child KES $c$. Cost of $2$ adults and $3$ children?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $4a + 3b - a + 2b$.', 'multiple_choice', '["$3a + 5b$","$5a + 5b$","$3a + b$","$5a + b$"]'::jsonb, '"$3a + 5b$"'::jsonb, 'medium', '$4a-a=3a$; $3b+2b=5b$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $4a + 3b - a + 2b$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expand $4(2x - 5)$.', 'multiple_choice', '["$8x - 20$","$8x - 5$","$6x - 20$","$2x - 20$"]'::jsonb, '"$8x - 20$"'::jsonb, 'medium', 'Distribute $4$ to both terms.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expand $4(2x - 5)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $3(x + 2) - 2x$.', 'multiple_choice', '["$x + 6$","$5x + 6$","$x + 2$","$5x + 2$"]'::jsonb, '"$x + 6$"'::jsonb, 'medium', 'Expand $3x+6$; subtract $2x$ $\rightarrow$ $x+6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $3(x + 2) - 2x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $p = -1$, find $p^2 + 2p$.', 'multiple_choice', '["$-1$","$1$","$-3$","$3$"]'::jsonb, '"$-1$"'::jsonb, 'medium', '$1 + (-2) = -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $p = -1$, find $p^2 + 2p$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a = 2$, $b = 3$, find $3a + 2b$.', 'multiple_choice', '["$12$","$13$","$10$","$18$"]'::jsonb, '"$12$"'::jsonb, 'medium', '$6 + 6 = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a = 2$, $b = 3$, find $3a + 2b$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $m = -4$, find $m^2 - 1$.', 'multiple_choice', '["$15$","$17$","$-17$","$-15$"]'::jsonb, '"$15$"'::jsonb, 'medium', '$(-4)^2=16$; $16-1=15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $m = -4$, find $m^2 - 1$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Age: Ali is $5$ years older than twice Grace''''s age $g$. Ali''''s age?', 'multiple_choice', '["$2g + 5$","$2(g+5)$","$g + 5$","$5g + 2$"]'::jsonb, '"$2g + 5$"'::jsonb, 'hard', 'Twice Grace''''s age plus $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Age: Ali is $5$ years older than twice Grace''''s age $g$. Ali''''s age?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $2(3x - 1) - 3(x + 2)$.', 'multiple_choice', '["$3x - 8$","$3x - 2$","$9x - 8$","$x - 8$"]'::jsonb, '"$3x - 8$"'::jsonb, 'hard', '$6x-2-3x-6=3x-8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $2(3x - 1) - 3(x + 2)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $5x - 2(3 - x) + 4$.', 'multiple_choice', '["$7x - 2$","$7x + 2$","$3x - 2$","$11x - 2$"]'::jsonb, '"$7x - 2$"'::jsonb, 'hard', '$5x-6+2x+4=7x-2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $5x - 2(3 - x) + 4$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $x = -3$, $y = 2$, find $x^2 + xy - y^2$.', 'multiple_choice', '["$-1$","$1$","$7$","$-7$"]'::jsonb, '"$-1$"'::jsonb, 'hard', '$9 + (-6) - 4 = -1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $x = -3$, $y = 2$, find $x^2 + xy - y^2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Rectangle: length $(2x+1)$ cm, width $x$ cm. Perimeter?', 'multiple_choice', '["$6x + 2$","$2x^2 + x$","$4x + 2$","$6x + 1$"]'::jsonb, '"$6x + 2$"'::jsonb, 'hard', '$2(2x+1+x)=2(3x+1)=6x+2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='forming_expressions'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Rectangle: length $(2x+1)$ cm, width $x$ cm. Perimeter?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Expression $3n^2 - 2n + 1$ when $n = -2$?', 'multiple_choice', '["$17$","$9$","$-3$","$13$"]'::jsonb, '"$17$"'::jsonb, 'hard', '$12+4+1=17$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Expression $3n^2 - 2n + 1$ when $n = -2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{6x}{2} + 4x$.', 'multiple_choice', '["$7x$","$3x + 4x$","$10x$","$5x$"]'::jsonb, '"$7x$"'::jsonb, 'hard', '$3x + 4x = 7x$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='simplification'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{6x}{2} + 4x$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $a + b = 7$ and $a = 3$, find $b$ then evaluate $2a + 3b$.', 'multiple_choice', '["$18$","$21$","$15$","$12$"]'::jsonb, '"$18$"'::jsonb, 'hard', '$b=4$; $2(3)+3(4)=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='substitution'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='algebraic_expressions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $a + b = 7$ and $a = 3$, find $b$ then evaluate $2a + 3b$.');
-- ========== RATES, RATIO & PROPORTION CONTENT ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Rates', '{"blocks":[{"type":"heading","content":"Rates"},{"type":"paragraph","content":"A rate compares two quantities with different units, e.g. km per hour, KES per kg, litres per minute."},{"type":"math_block","latex":"\\text{Rate} = \\frac{\\text{quantity}}{\\text{time (or unit)}}","caption":"Unit rate = amount per one unit."},{"type":"example","title":"A car travels $120$ km in $2$ hours. Find the speed.","steps":["Rate = distance $\\div$ time.","$120 \\div 2 = 60$ km/h."],"answer":"$60$ km/h"},{"type":"question","questionText":"$8$ books cost KES $400$. What is the cost per book?","questionType":"multiple_choice","options":["KES $50$","KES $32$","KES $408$","KES $392$"],"correctAnswer":"KES $50$","explanation":"$400 \\div 8 = 50$ KES per book."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'rates'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Rates');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Ratio and Sharing', '{"blocks":[{"type":"heading","content":"Ratio and Proportion"},{"type":"paragraph","content":"A ratio compares parts of the same whole, written $a : b$. To share KES $600$ in ratio $2:3$, total parts $= 5$, each part $= 600/5 = 120$."},{"type":"example","title":"Share KES $800$ in the ratio $3:5$","steps":["Total parts: $3 + 5 = 8$.","One part: $800 \\div 8 = 100$.","Shares: $3 \\times 100 = 300$, $5 \\times 100 = 500$."],"answer":"KES $300$ and KES $500$"},{"type":"callout","variant":"warning","content":"Simplify ratios like fractions: $12:8 = 3:2$."},{"type":"question","questionText":"Divide $24$ sweets in ratio $1:3$. How many does the smaller share get?","questionType":"multiple_choice","options":["$6$","$8$","$18$","$12$"],"correctAnswer":"$6$","explanation":"Parts $=4$; $24/4=6$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Ratio and Sharing');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Direct and Inverse Proportion', '{"blocks":[{"type":"heading","content":"Proportion"},{"type":"paragraph","content":"Direct proportion: as one quantity doubles, so does the other ($y = kx$). Inverse proportion: as one doubles, the other halves ($xy = k$)."},{"type":"example","title":"If $5$ workers take $12$ days, how long for $10$ workers? (same job)","steps":["More workers $\\rightarrow$ fewer days (inverse).","$5 \\times 12 = 60$ worker-days.","$60 \\div 10 = 6$ days."],"answer":"$6$ days"},{"type":"question","questionText":"If $3$ pens cost KES $150$, what do $8$ pens cost? (direct)","questionType":"multiple_choice","options":["KES $400$","KES $450$","KES $350$","KES $500$"],"correctAnswer":"KES $400$","explanation":"One pen KES $50$; $8 \\times 50 = 400$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Direct and Inverse Proportion');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Working with Percentages', '{"blocks":[{"type":"heading","content":"Percentage"},{"type":"paragraph","content":"Percent means ''per hundred''. $25\\% = \\frac{25}{100} = 0.25$."},{"type":"example","title":"Find $20\\%$ of KES $450$","steps":["Convert: $20\\% = 0.20$.","$0.20 \\times 450 = 90$."],"answer":"KES $90$"},{"type":"example","title":"A shirt was KES $800$, reduced by $15\\%$. Sale price?","steps":["Discount: $0.15 \\times 800 = 120$.","Sale price: $800 - 120 = 680$."],"answer":"KES $680$"},{"type":"question","questionText":"Express $0.35$ as a percentage.","questionType":"multiple_choice","options":["$35\\%$","$3.5\\%$","$350\\%$","$0.35\\%$"],"correctAnswer":"$35\\%$","explanation":"Multiply by $100$: $0.35 \\times 100 = 35\\%$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'percentage'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Working with Percentages');
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Profit, Loss and Discount', '{"blocks":[{"type":"heading","content":"Percentage Applications"},{"type":"paragraph","content":"Profit = selling price - cost price. Loss when cost > selling. Profit $\\% = \\frac{\\text{profit}}{\\text{CP}} \\times 100$."},{"type":"example","title":"Bought for KES $400$, sold for KES $500$. Profit and profit $\\%$?","steps":["Profit $= 500 - 400 = 100$.","Profit $\\% = \\frac{100}{400} \\times 100 = 25\\%$."],"answer":"KES $100$ profit, $25\\%$"},{"type":"example","title":"Item marked KES $1000$ with $10\\%$ discount. Customer pays?","steps":["Discount $= 0.10 \\times 1000 = 100$.","Pay $1000 - 100 = 900$."],"answer":"KES $900$"},{"type":"callout","variant":"warning","content":"Profit $\\%$ is on cost price, not selling price."},{"type":"question","questionText":"Cost KES $200$, sold at $10\\%$ loss. Selling price?","questionType":"multiple_choice","options":["KES $180$","KES $220$","KES $190$","KES $210$"],"correctAnswer":"KES $180$","explanation":"Loss $20$; $200 - 20 = 180$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'rates_ratio_proportion' AND st.code = 'percentage_applications'
AND NOT EXISTS (SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Profit, Loss and Discount');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A runner covers $5$ km in $25$ minutes. Speed in km/h?', 'multiple_choice', '["$12$ km/h","$10$ km/h","$15$ km/h","$20$ km/h"]'::jsonb, '"$12$ km/h"'::jsonb, 'easy', '$25$ min $= 5/12$ h; $5 \div (5/12) = 12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A runner covers $5$ km in $25$ minutes. Speed in km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$3$ kg of maize costs KES $180$. Price per kg?', 'multiple_choice', '["KES $60$","KES $54$","KES $90$","KES $183$"]'::jsonb, '"KES $60$"'::jsonb, 'easy', '$180 \div 3 = 60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$3$ kg of maize costs KES $180$. Price per kg?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pump fills $40$ litres in $8$ minutes. Rate per minute?', 'multiple_choice', '["$5$ L/min","$4$ L/min","$32$ L/min","$48$ L/min"]'::jsonb, '"$5$ L/min"'::jsonb, 'easy', '$40 \div 8 = 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pump fills $40$ litres in $8$ minutes. Rate per minute?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $72$ km in $1.5$ hours as a unit rate in km/h.', 'multiple_choice', '["$48$ km/h","$36$ km/h","$108$ km/h","$24$ km/h"]'::jsonb, '"$48$ km/h"'::jsonb, 'easy', '$72 \div 1.5 = 48$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $72$ km in $1.5$ hours as a unit rate in km/h.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify ratio $15:10$.', 'multiple_choice', '["$3:2$","$5:3$","$2:3$","$1:2$"]'::jsonb, '"$3:2$"'::jsonb, 'easy', 'Divide both by $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify ratio $15:10$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Share $20$ in ratio $1:4$. Larger share?', 'multiple_choice', '["$16$","$4$","$5$","$15$"]'::jsonb, '"$16$"'::jsonb, 'easy', 'Parts $5$; $20/5=4$; $4 \times 4 = 16$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Share $20$ in ratio $1:4$. Larger share?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is $50\%$ of $80$?', 'multiple_choice', '["$40$","$30$","$50$","$160$"]'::jsonb, '"$40$"'::jsonb, 'easy', 'Half of $80$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is $50\%$ of $80$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$\frac{3}{4}$ as a percentage?', 'multiple_choice', '["$75\\%$","$34\\%$","$43\\%$","$25\\%$"]'::jsonb, '"$75\\%$"'::jsonb, 'easy', '$0.75 \times 100 = 75\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$\frac{3}{4}$ as a percentage?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Buy KES $500$, sell KES $600$. Profit?', 'multiple_choice', '["KES $100$","KES $50$","KES $1100$","KES $400$"]'::jsonb, '"KES $100$"'::jsonb, 'easy', '$600 - 500 = 100$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Buy KES $500$, sell KES $600$. Profit?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Car at $80$ km/h for $2.5$ hours. Distance?', 'multiple_choice', '["$200$ km","$160$ km","$82.5$ km","$250$ km"]'::jsonb, '"$200$ km"'::jsonb, 'medium', '$80 \times 2.5 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Car at $80$ km/h for $2.5$ hours. Distance?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Worker earns KES $1200$ in $6$ days. Daily rate?', 'multiple_choice', '["KES $200$","KES $180$","KES $7200$","KES $240$"]'::jsonb, '"KES $200$"'::jsonb, 'medium', '$1200 \div 6 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Worker earns KES $1200$ in $6$ days. Daily rate?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Divide KES $700$ in ratio $2:5$. Smaller share?', 'multiple_choice', '["KES $200$","KES $500$","KES $350$","KES $140$"]'::jsonb, '"KES $200$"'::jsonb, 'medium', 'Parts $7$; $700/7=100$; $2 \times 100=200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Divide KES $700$ in ratio $2:5$. Smaller share?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'If $4$ machines make $48$ items in $3$ hours, $6$ machines in same time make?', 'multiple_choice', '["$72$ items","$48$ items","$64$ items","$96$ items"]'::jsonb, '"$72$ items"'::jsonb, 'medium', 'Direct: $48/4=12$ per machine; $6 \times 12=72$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='If $4$ machines make $48$ items in $3$ hours, $6$ machines in same time make?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$6$ workers finish a job in $10$ days. $5$ workers need?', 'multiple_choice', '["$12$ days","$8$ days","$15$ days","$11$ days"]'::jsonb, '"$12$ days"'::jsonb, 'medium', 'Inverse: $6 \times 10 = 60$; $60/5=12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$6$ workers finish a job in $10$ days. $5$ workers need?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Increase KES $400$ by $15\%$.', 'multiple_choice', '["KES $460$","KES $415$","KES $440$","KES $600$"]'::jsonb, '"KES $460$"'::jsonb, 'medium', '$60$ increase; $400+60=460$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Increase KES $400$ by $15\%$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, '$45$ is what $\%$ of $180$?', 'multiple_choice', '["$25\\%$","$20\\%$","$30\\%$","$40\\%$"]'::jsonb, '"$25\\%$"'::jsonb, 'medium', '$45/180 = 1/4 = 25\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='$45$ is what $\%$ of $180$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cost KES $800$, $25\%$ profit. Selling price?', 'multiple_choice', '["KES $1000$","KES $900$","KES $200$","KES $1025$"]'::jsonb, '"KES $1000$"'::jsonb, 'medium', 'Profit $200$; $800+200=1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cost KES $800$, $25\%$ profit. Selling price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Bought at $30\%$ below marked KES $1000$. Cost price?', 'multiple_choice', '["KES $700$","KES $300$","KES $1300$","KES $770$"]'::jsonb, '"KES $700$"'::jsonb, 'medium', '$30\%$ off: $1000-300=700$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Bought at $30\%$ below marked KES $1000$. Cost price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cyclist: $15$ km in $45$ min. Average speed km/h?', 'multiple_choice', '["$20$ km/h","$15$ km/h","$30$ km/h","$10$ km/h"]'::jsonb, '"$20$ km/h"'::jsonb, 'hard', '$45$ min $= 0.75$ h; $15/0.75=20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cyclist: $15$ km in $45$ min. Average speed km/h?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Map scale $1:50000$. $3$ cm on map represents?', 'multiple_choice', '["$1.5$ km","$150$ m","$15$ km","$1500$ m"]'::jsonb, '"$1.5$ km"'::jsonb, 'hard', '$3 \times 50000$ cm $= 150000$ cm $= 1.5$ km.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Map scale $1:50000$. $3$ cm on map represents?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Ages of Ann and Ben are $3:5$. Sum is $32$. Ben''''s age?', 'multiple_choice', '["$20$","$12$","$16$","$18$"]'::jsonb, '"$20$"'::jsonb, 'hard', 'Parts $8$; $32/8=4$; Ben $5 \times 4=20$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='ratio_proportion'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Ages of Ann and Ben are $3:5$. Sum is $32$. Ben''''s age?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Price drops from KES $500$ to KES $425$. Percentage decrease?', 'multiple_choice', '["$15\\%$","$25\\%$","$10\\%$","$75\\%$"]'::jsonb, '"$15\\%$"'::jsonb, 'hard', 'Decrease $75$; $75/500=15\%$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Price drops from KES $500$ to KES $425$. Percentage decrease?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Marked KES $2000$, $20\%$ discount then $5\%$ VAT on discounted price. Final price?', 'multiple_choice', '["KES $1680$","KES $1600$","KES $1760$","KES $2100$"]'::jsonb, '"KES $1680$"'::jsonb, 'hard', 'After discount $1600$; VAT $80$; total $1680$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Marked KES $2000$, $20\%$ discount then $5\%$ VAT on discounted price. Final price?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Agent earns $8\%$ commission on KES $12500$ sales. Commission?', 'multiple_choice', '["KES $1000$","KES $800$","KES $1250$","KES $960$"]'::jsonb, '"KES $1000$"'::jsonb, 'hard', '$0.08 \times 12500 = 1000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='percentage_applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Agent earns $8\%$ commission on KES $12500$ sales. Commission?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Pipe A fills tank in $6$ h, Pipe B in $3$ h. Together, time to fill?', 'multiple_choice', '["$2$ hours","$4.5$ hours","$3$ hours","$9$ hours"]'::jsonb, '"$2$ hours"'::jsonb, 'hard', 'Rates $1/6+1/3=1/2$ per h; time $2$ h.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='rates'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='rates_ratio_proportion'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Pipe A fills tank in $6$ h, Pipe B in $3$ h. Together, time to fill?');
-- ===== 3/3 Form 1 Batch 1 (fractions reinstate + natural_numbers, factors, divisibility_tests, decimals) =====
-- KCSE Form 1 Mathematics — Wave 1 Batch 1
-- Topics: fractions (re-instate + rebuild), natural_numbers, factors, divisibility_tests, decimals
-- Idempotent seed: subtopics, lessons, practice questions.
-- Authoring standard: docs/superpowers/plans/2026-06-25-kcse-math-CONTENT-GUIDE.md


-- ========== FRACTIONS (re-instate + rebuild) ==========

UPDATE public.topics t SET is_active = true
FROM public.subjects s, public.curricula c
WHERE t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';

UPDATE public.subtopics st SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.lessons l SET is_active=false
FROM public.subtopics st, public.topics t, public.subjects s, public.curricula c
WHERE l.subtopic_id=st.id AND st.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
  AND st.code IN ('simplifying','operations','word_problems');

UPDATE public.practice_questions pq SET is_active=false
FROM public.topics t, public.subjects s, public.curricula c
WHERE pq.topic_id=t.id AND t.subject_id=s.id AND s.curriculum_id=c.id
  AND c.code='KCSE' AND s.code='mathematics' AND t.code='fractions';

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_types', 'Types of Fractions', 'Proper, improper, mixed numbers, equivalence and simplification.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_operations', 'Fraction Operations', 'Add, subtract, multiply and divide fractions.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_bodmas', 'BODMAS with Fractions', 'Order of operations involving fractions.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'fraction_word_problems', 'Fraction Word Problems', 'Apply fractions in Kenyan contexts.', 4
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions'
ON CONFLICT (topic_id, code) DO NOTHING;
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Understanding Fractions', '{"blocks":[{"type":"heading","content":"Understanding Fractions"},{"type":"paragraph","content":"A fraction $\\frac{a}{b}$ shows $a$ equal parts taken from a whole divided into $b$ equal parts. The top number is the **numerator**; the bottom is the **denominator**."},{"type":"callout","variant":"key_point","content":"A **proper** fraction has numerator $<$ denominator (e.g. $\\frac{3}{5}$). An **improper** fraction has numerator $\\geq$ denominator (e.g. $\\frac{7}{4}$)."},{"type":"example","title":"Write $\\frac{11}{4}$ as a mixed number","steps":["Divide: $11 \\div 4 = 2$ remainder $3$.","Whole part $= 2$, fractional part $= \\frac{3}{4}$."],"answer":"$2\\frac{3}{4}$"},{"type":"callout","variant":"warning","content":"Do not confuse $\\frac{3}{4}$ with $3 \\div 4$ notation — they mean the same value, but in exams write fractions clearly."},{"type":"question","questionText":"Which is an improper fraction?","questionType":"multiple_choice","options":["$\\frac{2}{7}$","$\\frac{5}{5}$","$\\frac{3}{8}$","$\\frac{1}{6}$"],"correctAnswer":"$\\frac{5}{5}$","explanation":"Numerator equals denominator, so it is improper (equals $1$)."}],"shortQuiz":{"questions":[{"questionText":"In $\\frac{5}{9}$, what is the denominator?","options":["$5$","$9$","$14$","$4$"],"correctAnswer":"$9$"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_types'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Understanding Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Equivalent Fractions and Simplifying', '{"blocks":[{"type":"heading","content":"Equivalent Fractions and Simplifying"},{"type":"paragraph","content":"Equivalent fractions name the same amount. Multiply or divide numerator and denominator by the same non-zero number."},{"type":"math_block","latex":"\\frac{a}{b} = \\frac{a \\times k}{b \\times k} = \\frac{a \\div k}{b \\div k}","caption":"Scaling both parts equally keeps the value."},{"type":"example","title":"Simplify $\\frac{18}{24}$","steps":["Find HCF of $18$ and $24$: it is $6$.","Divide top and bottom by $6$: $\\frac{18 \\div 6}{24 \\div 6} = \\frac{3}{4}$."],"answer":"$\\frac{3}{4}$"},{"type":"example","title":"Find an equivalent fraction for $\\frac{2}{5}$ with denominator $20$","steps":["$5 \\times 4 = 20$, so multiply top by $4$.","$\\frac{2 \\times 4}{5 \\times 4} = \\frac{8}{20}$."],"answer":"$\\frac{8}{20}$"},{"type":"question","questionText":"Simplify $\\frac{15}{25}$","questionType":"multiple_choice","options":["$\\frac{3}{5}$","$\\frac{5}{3}$","$\\frac{15}{25}$","$\\frac{1}{5}$"],"correctAnswer":"$\\frac{3}{5}$","explanation":"Divide numerator and denominator by $5$."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_types'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Equivalent Fractions and Simplifying'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adding and Subtracting Fractions', '{"blocks":[{"type":"heading","content":"Adding and Subtracting Fractions"},{"type":"paragraph","content":"Same denominator: add/subtract numerators, keep denominator. Different denominators: find the LCM, convert to equivalent fractions, then add/subtract."},{"type":"example","title":"Evaluate $\\frac{2}{7} + \\frac{3}{7}$","steps":["Denominators match.","$\\frac{2+3}{7} = \\frac{5}{7}$."],"answer":"$\\frac{5}{7}$"},{"type":"example","title":"Evaluate $\\frac{3}{4} - \\frac{1}{6}$","steps":["LCM of $4$ and $6$ is $12$.","$\\frac{9}{12} - \\frac{2}{12} = \\frac{7}{12}$."],"answer":"$\\frac{7}{12}$"},{"type":"callout","variant":"warning","content":"A common mistake is adding denominators: $\\frac{1}{2} + \\frac{1}{3} \\neq \\frac{2}{5}$."},{"type":"question","questionText":"Evaluate $\\frac{1}{3} + \\frac{1}{3}$","questionType":"multiple_choice","options":["$\\frac{2}{3}$","$\\frac{2}{6}$","$\\frac{1}{3}$","$\\frac{2}{9}$"],"correctAnswer":"$\\frac{2}{3}$","explanation":"Same denominator: add numerators."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adding and Subtracting Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Multiplying and Dividing Fractions', '{"blocks":[{"type":"heading","content":"Multiplying and Dividing Fractions"},{"type":"callout","variant":"key_point","content":"Multiply: $\\frac{a}{b} \\times \\frac{c}{d} = \\frac{ac}{bd}$. Divide: multiply by the reciprocal: $\\frac{a}{b} \\div \\frac{c}{d} = \\frac{a}{b} \\times \\frac{d}{c}$."},{"type":"example","title":"Evaluate $\\frac{2}{3} \\times \\frac{5}{7}$","steps":["Multiply numerators: $2 \\times 5 = 10$.","Multiply denominators: $3 \\times 7 = 21$.","Simplify if possible: $\\frac{10}{21}$."],"answer":"$\\frac{10}{21}$"},{"type":"example","title":"Evaluate $\\frac{3}{4} \\div \\frac{2}{5}$","steps":["Multiply by reciprocal: $\\frac{3}{4} \\times \\frac{5}{2}$.","$= \\frac{15}{8} = 1\\frac{7}{8}$."],"answer":"$1\\frac{7}{8}$"},{"type":"question","questionText":"Evaluate $\\frac{1}{2} \\div \\frac{1}{4}$","questionType":"multiple_choice","options":["$2$","$\\frac{1}{8}$","$\\frac{1}{2}$","$4$"],"correctAnswer":"$2$","explanation":"$\\frac{1}{2} \\times \\frac{4}{1} = 2$."}]}'::jsonb, 12, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Multiplying and Dividing Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'BODMAS with Fractions', '{"blocks":[{"type":"heading","content":"Order of Operations with Fractions"},{"type":"paragraph","content":"Follow BODMAS: Brackets, Orders, Division/Multiplication (left to right), Addition/Subtraction (left to right)."},{"type":"example","title":"Evaluate $\\frac{1}{2} + \\frac{1}{3} \\times 3$","steps":["Multiply first: $\\frac{1}{3} \\times 3 = 1$.","Add: $\\frac{1}{2} + 1 = 1\\frac{1}{2}$."],"answer":"$1\\frac{1}{2}$"},{"type":"example","title":"Evaluate $\\left(\\frac{2}{3} + \\frac{1}{6}\\right) \\div \\frac{5}{2}$","steps":["Brackets: $\\frac{4}{6} + \\frac{1}{6} = \\frac{5}{6}$.","Divide: $\\frac{5}{6} \\times \\frac{2}{5} = \\frac{1}{3}$."],"answer":"$\\frac{1}{3}$"},{"type":"callout","variant":"warning","content":"Do not work left to right when multiplication is present."},{"type":"question","questionText":"Evaluate $2 \\times \\frac{3}{4} - \\frac{1}{2}$","questionType":"multiple_choice","options":["$1$","$\\frac{1}{2}$","$\\frac{5}{4}$","$2$"],"correctAnswer":"$1$","explanation":"$\\frac{3}{2} - \\frac{1}{2} = 1$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_bodmas'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'BODMAS with Fractions'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Fractions in Kenyan Contexts', '{"blocks":[{"type":"heading","content":"Fraction Word Problems"},{"type":"paragraph","content":"Fractions appear when sharing sukuma wiki at the market, mixing porridge, or finding what fraction of a class passed an exam."},{"type":"example","title":"Grace bought $\\frac{2}{5}$ kg of sugar and used $\\frac{1}{5}$ kg for tea. How much remains?","steps":["Same denominators: $\\frac{2}{5} - \\frac{1}{5} = \\frac{1}{5}$ kg."],"answer":"$\\frac{1}{5}$ kg"},{"type":"example","title":"A farmer planted maize on $\\frac{3}{8}$ of his $24$-acre shamba. How many acres?","steps":["$\\frac{3}{8} \\times 24 = 9$ acres."],"answer":"$9$ acres"},{"type":"callout","variant":"warning","content":"Of means multiply. Remaining often means subtract from the whole ($1$ or total)."},{"type":"question","questionText":"Peter ate $\\frac{1}{4}$ of a chapati. What fraction is left?","questionType":"multiple_choice","options":["$\\frac{3}{4}$","$\\frac{1}{4}$","$\\frac{1}{2}$","$\\frac{2}{4}$"],"correctAnswer":"$\\frac{3}{4}$","explanation":"$1 - \\frac{1}{4} = \\frac{3}{4}$."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'fractions' AND st.code = 'fraction_word_problems'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Fractions in Kenyan Contexts'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which fraction is proper?', 'multiple_choice', '["$\\frac{7}{9}$","$\\frac{9}{7}$","$\\frac{9}{9}$","$2\\frac{1}{3}$"]'::jsonb, '"$\\frac{7}{9}$"'::jsonb, 'easy', 'Numerator is less than denominator.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which fraction is proper?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Simplify $\frac{8}{12}$.', 'multiple_choice', '["$\\frac{2}{3}$","$\\frac{4}{6}$","$\\frac{3}{2}$","$\\frac{1}{4}$"]'::jsonb, '"$\\frac{2}{3}$"'::jsonb, 'easy', 'Divide top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Simplify $\frac{8}{12}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{9}{4}$ to a mixed number.', 'multiple_choice', '["$2\\frac{1}{4}$","$1\\frac{5}{4}$","$4\\frac{1}{9}$","$\\frac{13}{4}$"]'::jsonb, '"$2\\frac{1}{4}$"'::jsonb, 'easy', '$9 \div 4 = 2$ remainder $1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{9}{4}$ to a mixed number.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{5} + \frac{2}{5}$.', 'multiple_choice', '["$\\frac{3}{5}$","$\\frac{3}{10}$","$\\frac{2}{5}$","$\\frac{1}{5}$"]'::jsonb, '"$\\frac{3}{5}$"'::jsonb, 'easy', 'Add numerators when denominators match.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{5} + \frac{2}{5}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3}{4} - \frac{1}{4}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{2}{4}$","$\\frac{4}{4}$","$\\frac{2}{8}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'easy', '$\frac{3-1}{4} = \frac{2}{4} = \frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3}{4} - \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} \times \frac{2}{3}$.', 'multiple_choice', '["$\\frac{1}{3}$","$\\frac{2}{5}$","$\\frac{3}{4}$","$\\frac{2}{6}$"]'::jsonb, '"$\\frac{1}{3}$"'::jsonb, 'easy', '$\frac{2}{6} = \frac{1}{3}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} \times \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.', 'multiple_choice', '["$1\\frac{1}{2}$","$2$","$1$","$\\frac{3}{2}$"]'::jsonb, '"$1\\frac{1}{2}$"'::jsonb, 'easy', 'Multiply first: $1 + 1 = 1\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2} + \frac{1}{2} \times 2$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is equivalent to $\frac{3}{5}$?', 'multiple_choice', '["$\\frac{12}{20}$","$\\frac{5}{3}$","$\\frac{6}{15}$","$\\frac{9}{25}$"]'::jsonb, '"$\\frac{12}{20}$"'::jsonb, 'medium', 'Multiply top and bottom by $4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is equivalent to $\frac{3}{5}$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{2}{3} + \frac{1}{4}$.', 'multiple_choice', '["$\\frac{11}{12}$","$\\frac{3}{7}$","$\\frac{3}{12}$","$\\frac{8}{12}$"]'::jsonb, '"$\\frac{11}{12}$"'::jsonb, 'medium', 'LCM $12$: $\frac{8}{12}+\frac{3}{12}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{2}{3} + \frac{1}{4}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{5}{6} - \frac{1}{3}$.', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{4}{3}$","$\\frac{4}{6}$","$\\frac{1}{3}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', '$\frac{5}{6}-\frac{2}{6}=\frac{3}{6}=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{5}{6} - \frac{1}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{4}{5} \div \frac{2}{3}$.', 'multiple_choice', '["$1\\frac{1}{5}$","$\\frac{6}{20}$","$\\frac{8}{15}$","$\\frac{2}{5}$"]'::jsonb, '"$1\\frac{1}{5}$"'::jsonb, 'medium', '$\frac{4}{5}\times\frac{3}{2}=\frac{12}{10}=1\frac{1}{5}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{4}{5} \div \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\left(\frac{1}{2}+\frac{1}{3}\right) \times 6$.', 'multiple_choice', '["$5$","$3$","$4$","$6$"]'::jsonb, '"$5$"'::jsonb, 'medium', 'Brackets: $\frac{5}{6}\times 6 = 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\left(\frac{1}{2}+\frac{1}{3}\right) \times 6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $3 - \frac{2}{5} \times \frac{5}{2}$.', 'multiple_choice', '["$2$","$1$","$\\frac{11}{5}$","$3$"]'::jsonb, '"$2$"'::jsonb, 'medium', 'Multiply: $3-1=2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $3 - \frac{2}{5} \times \frac{5}{2}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A jug is $\frac{3}{4}$ full. $\frac{1}{4}$ is poured out. What fraction remains?', 'multiple_choice', '["$\\frac{1}{2}$","$\\frac{1}{4}$","$\\frac{2}{4}$","$\\frac{3}{4}$"]'::jsonb, '"$\\frac{1}{2}$"'::jsonb, 'medium', '$\frac{3}{4}-\frac{1}{4}=\frac{1}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A jug is $\frac{3}{4}$ full. $\frac{1}{4}$ is poured out. What fraction remains?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'At a kiosk, $\frac{2}{5}$ of KES $500$ was spent on bread. How much was spent?', 'multiple_choice', '["KES $200$","KES $250$","KES $300$","KES $125$"]'::jsonb, '"KES $200$"'::jsonb, 'hard', '$\frac{2}{5}\times 500 = 200$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='At a kiosk, $\frac{2}{5}$ of KES $500$ was spent on bread. How much was spent?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{2}{3} \div \left(\frac{1}{2} + \frac{1}{6}\right)$.', 'multiple_choice', '["$1$","$\\frac{4}{3}$","$\\frac{2}{3}$","$\\frac{1}{2}$"]'::jsonb, '"$1$"'::jsonb, 'hard', 'Bracket $=\frac{2}{3}$; $\frac{2}{3}\div\frac{2}{3}=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{2}{3} \div \left(\frac{1}{2} + \frac{1}{6}\right)$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1\frac{1}{3} - \frac{2}{5}$.', 'multiple_choice', '["$\\frac{14}{15}$","$\\frac{8}{15}$","$\\frac{11}{15}$","$\\frac{3}{8}$"]'::jsonb, '"$\\frac{14}{15}$"'::jsonb, 'hard', '$\frac{4}{3}-\frac{2}{5}=\frac{20-6}{15}=\frac{14}{15}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1\frac{1}{3} - \frac{2}{5}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{3}{4} \times \frac{8}{9} \div \frac{2}{3}$.', 'multiple_choice', '["$1$","$\\frac{2}{3}$","$\\frac{4}{3}$","$\\frac{1}{2}$"]'::jsonb, '"$1$"'::jsonb, 'hard', '$\frac{2}{3}\div\frac{2}{3}=1$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{3}{4} \times \frac{8}{9} \div \frac{2}{3}$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'In a class of $40$, $\frac{3}{8}$ are girls. How many boys are there?', 'multiple_choice', '["$25$","$15$","$24$","$16$"]'::jsonb, '"$25$"'::jsonb, 'hard', 'Girls $=15$; boys $=40-15=25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_word_problems'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='In a class of $40$, $\frac{3}{8}$ are girls. How many boys are there?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $3\frac{2}{5}$ as an improper fraction.', 'multiple_choice', '["$\\frac{17}{5}$","$\\frac{15}{5}$","$\\frac{13}{5}$","$\\frac{32}{5}$"]'::jsonb, '"$\\frac{17}{5}$"'::jsonb, 'hard', '$3\times 5 + 2 = 17$ over $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_types'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $3\frac{2}{5}$ as an improper fraction.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.', 'multiple_choice', '["$1\\frac{1}{2}$","$\\frac{3}{4}$","$2$","$1$"]'::jsonb, '"$1\\frac{1}{2}$"'::jsonb, 'hard', 'Bracket $=1$; $\frac{1}{2}\div\frac{1}{3}=\frac{3}{2}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='fraction_bodmas'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='fractions'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $\frac{1}{2}\left(\frac{3}{4}+\frac{1}{4}\right) \div \frac{1}{3}$.');

-- ========== NATURAL NUMBERS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Place Value and Reading Numbers', '{"blocks":[{"type":"heading","content":"Place Value"},{"type":"paragraph","content":"Each digit in a number has a place value: ones, tens, hundreds, thousands, and so on. In $4\\,582$, the $4$ is in the thousands place ($4\\,000$)."},{"type":"callout","variant":"key_point","content":"Moving one place left multiplies value by $10$. Moving right divides by $10$."},{"type":"example","title":"Write the value of $7$ in $37\\,205$","steps":["$7$ is in the thousands place.","Value $= 7\\,000$."],"answer":"$7\\,000$"},{"type":"question","questionText":"What is the place value of $5$ in $2\\,531$?","questionType":"multiple_choice","options":["$500$","$50$","$5$","$5\\,000$"],"correctAnswer":"$500$","explanation":"$5$ is in the hundreds place."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'place_values'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Place Value and Reading Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Rounding Off Numbers', '{"blocks":[{"type":"heading","content":"Rounding Off"},{"type":"paragraph","content":"To round to the nearest ten, hundred, or thousand, look at the digit to the right. If it is $5$ or more, round up; otherwise round down."},{"type":"example","title":"Round $4\\,678$ to the nearest hundred","steps":["Hundreds digit is $6$; tens digit is $7$ ($\\geq 5$).","Round up: $4\\,700$."],"answer":"$4\\,700$"},{"type":"callout","variant":"warning","content":"Rounding to nearest ten uses the ones digit; to nearest hundred uses the tens digit."},{"type":"question","questionText":"Round $12\\,350$ to the nearest thousand.","questionType":"multiple_choice","options":["$12\\,000$","$13\\,000$","$12\\,400$","$12\\,300$"],"correctAnswer":"$12\\,000$","explanation":"Hundreds digit $3 < 5$, round down."}]}'::jsonb, 10, 2
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'place_values'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Rounding Off Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations with Natural Numbers', '{"blocks":[{"type":"heading","content":"Operations with Natural Numbers"},{"type":"paragraph","content":"Natural numbers are counting numbers $1, 2, 3, \\ldots$ We add, subtract, multiply and divide them following place-value rules and BODMAS."},{"type":"example","title":"Evaluate $456 + 278$","steps":["Ones: $6+8=14$, carry $1$.","Tens: $5+7+1=13$, carry $1$.","Hundreds: $4+2+1=7$."],"answer":"$734$"},{"type":"example","title":"Evaluate $8\\,400 \\div 12$","steps":["$84 \\div 12 = 7$.","Bring down $0$: $70 \\times 12 = 840$."],"answer":"$700$"},{"type":"question","questionText":"Evaluate $25 \\times 16$.","questionType":"multiple_choice","options":["$400$","$350$","$410$","$390$"],"correctAnswer":"$400$","explanation":"$25 \\times 16 = 400$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'number_operations'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations with Natural Numbers'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'The Number Line', '{"blocks":[{"type":"heading","content":"Natural Numbers on the Number Line"},{"type":"paragraph","content":"A number line shows order. Numbers increase to the right. Natural numbers start at $1$."},{"type":"example","title":"Which is greater: $847$ or $874$?","steps":["Compare hundreds: both $8$.","Compare tens: $4 < 7$, so $847 < 874$."],"answer":"$874$ is greater"},{"type":"callout","variant":"warning","content":"When digits match from the left, the number with the larger next digit is greater."},{"type":"question","questionText":"On a number line, which is furthest right: $502$, $520$, or $250$?","questionType":"multiple_choice","options":["$520$","$502$","$250$","All equal"],"correctAnswer":"$520$","explanation":"$520$ is the greatest."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'natural_numbers' AND st.code = 'number_line'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'The Number Line'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is the value of $3$ in $13\,472$?', 'multiple_choice', '["$3\\,000$","$300$","$30$","$3$"]'::jsonb, '"$3\\,000$"'::jsonb, 'easy', '$3$ is in the thousands place.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is the value of $3$ in $13\,472$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $567$ to the nearest ten.', 'multiple_choice', '["$570$","$560$","$600$","$500$"]'::jsonb, '"$570$"'::jsonb, 'easy', 'Ones digit $7 \geq 5$, round up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $567$ to the nearest ten.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $125 + 75$.', 'multiple_choice', '["$200$","$190$","$210$","$195$"]'::jsonb, '"$200$"'::jsonb, 'easy', 'Direct addition.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $125 + 75$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $144 \div 12$.', 'multiple_choice', '["$12$","$11$","$13$","$14$"]'::jsonb, '"$12$"'::jsonb, 'easy', '$12 \times 12 = 144$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $144 \div 12$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is smallest: $305$, $350$, $503$?', 'multiple_choice', '["$305$","$350$","$503$","$530$"]'::jsonb, '"$305$"'::jsonb, 'easy', '$305$ has the smallest hundreds digit.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is smallest: $305$, $350$, $503$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $15 \times 8$.', 'multiple_choice', '["$120$","$115$","$125$","$80$"]'::jsonb, '"$120$"'::jsonb, 'easy', '$15 \times 8 = 120$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $15 \times 8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $9\,006$ in words.', 'multiple_choice', '["Nine thousand and six","Nine hundred and six","Ninety thousand six","Nine thousand sixty"]'::jsonb, '"Nine thousand and six"'::jsonb, 'easy', 'No hundreds or tens digits.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $9\,006$ in words.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $4\,950$ to the nearest hundred.', 'multiple_choice', '["$5\\,000$","$4\\,900$","$4\\,000$","$5\\,100$"]'::jsonb, '"$5\\,000$"'::jsonb, 'medium', 'Tens digit $5$, round hundreds up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $4\,950$ to the nearest hundred.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1\,024 - 378$.', 'multiple_choice', '["$646$","$656$","$636$","$746$"]'::jsonb, '"$646$"'::jsonb, 'medium', 'Column subtraction with borrowing.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1\,024 - 378$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $35 \times 24$.', 'multiple_choice', '["$840$","$800$","$850$","$740$"]'::jsonb, '"$840$"'::jsonb, 'medium', '$35 \times 24 = 840$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $35 \times 24$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Arrange $1\,204$, $1\,240$, $1\,042$ from smallest to largest.', 'multiple_choice', '["$1\\,042, 1\\,204, 1\\,240$","$1\\,240, 1\\,204, 1\\,042$","$1\\,204, 1\\,042, 1\\,240$","$1\\,042, 1\\,240, 1\\,204$"]'::jsonb, '"$1\\,042, 1\\,204, 1\\,240$"'::jsonb, 'medium', 'Compare place values left to right.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Arrange $1\,204$, $1\,240$, $1\,042$ from smallest to largest.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A shop sells $18$ eggs per tray. How many eggs in $45$ trays?', 'multiple_choice', '["$810$","$800$","$720$","$900$"]'::jsonb, '"$810$"'::jsonb, 'medium', '$18 \times 45 = 810$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A shop sells $18$ eggs per tray. How many eggs in $45$ trays?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $99\,499$ to the nearest thousand.', 'multiple_choice', '["$99\\,000$","$100\\,000$","$99\\,500$","$99\\,400$"]'::jsonb, '"$99\\,000$"'::jsonb, 'medium', 'Hundreds digit $4 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $99\,499$ to the nearest thousand.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $2\,500 \div 25$.', 'multiple_choice', '["$100$","$125$","$90$","$250$"]'::jsonb, '"$100$"'::jsonb, 'medium', '$25 \times 100 = 2\,500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $2\,500 \div 25$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A school has $1\,248$ pupils. Round to the nearest hundred for a report.', 'multiple_choice', '["$1\\,200$","$1\\,300$","$1\\,250$","$1\\,000$"]'::jsonb, '"$1\\,200$"'::jsonb, 'hard', 'Tens digit $4 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A school has $1\,248$ pupils. Round to the nearest hundred for a report.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A bus carries $62$ passengers per trip. How many passengers in $38$ full trips?', 'multiple_choice', '["$2\\,356$","$2\\,336$","$2\\,346$","$2\\,376$"]'::jsonb, '"$2\\,356$"'::jsonb, 'hard', '$62 \times 38 = 2\,356$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A bus carries $62$ passengers per trip. How many passengers in $38$ full trips?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Estimate which number is halfway between $400$ and $600$ on the number line.', 'multiple_choice', '["$500$","$550$","$450$","$520$"]'::jsonb, '"$500$"'::jsonb, 'hard', 'Midpoint of $400$ and $600$ is $500$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Estimate which number is halfway between $400$ and $600$ on the number line.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $10\,000 - 3\,456$.', 'multiple_choice', '["$6\\,544$","$6\\,554$","$6\\,444$","$7\\,544$"]'::jsonb, '"$6\\,544$"'::jsonb, 'hard', 'Borrow across zeros carefully.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $10\,000 - 3\,456$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'The digit $8$ appears twice in $18\,829$. What is the total value of both $8$s?', 'multiple_choice', '["$8\\,800$","$808$","$880$","$8\\,080$"]'::jsonb, '"$8\\,800$"'::jsonb, 'hard', '$8\,000 + 800 = 8\,800$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_values'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='The digit $8$ appears twice in $18\,829$. What is the total value of both $8$s?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A farmer packs $125$ oranges per crate. How many oranges in $64$ crates?', 'multiple_choice', '["$8\\,000$","$7\\,500$","$8\\,125$","$7\\,875$"]'::jsonb, '"$8\\,000$"'::jsonb, 'hard', '$125 \times 64 = 8\,000$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_operations'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A farmer packs $125$ oranges per crate. How many oranges in $64$ crates?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which inequality is correct?', 'multiple_choice', '["$2\\,305 < 2\\,350$","$2\\,305 > 2\\,350$","$2\\,305 = 2\\,350$","$2\\,350 < 2\\,305$"]'::jsonb, '"$2\\,305 < 2\\,350$"'::jsonb, 'hard', 'Compare tens: $0 < 5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='number_line'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='natural_numbers'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which inequality is correct?');

-- ========== FACTORS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Prime Numbers and Factorisation', '{"blocks":[{"type":"heading","content":"Prime Factorisation"},{"type":"paragraph","content":"A **prime** number has exactly two factors: $1$ and itself. To factorise a composite number, split it into prime factors using a factor tree or repeated division."},{"type":"example","title":"Write $72$ as a product of primes","steps":["$72 = 2 \\times 36 = 2 \\times 2 \\times 18$.","$= 2 \\times 2 \\times 2 \\times 9 = 2^3 \\times 3^2$."],"answer":"$2^3 \\times 3^2$"},{"type":"callout","variant":"key_point","content":"Every whole number greater than $1$ is either prime or a unique product of primes."},{"type":"question","questionText":"Which is prime?","questionType":"multiple_choice","options":["$17$","$21$","$27$","$33$"],"correctAnswer":"$17$","explanation":"$17$ has only factors $1$ and $17$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'prime_factors'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Prime Numbers and Factorisation'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Greatest Common Divisor (GCD/HCF)', '{"blocks":[{"type":"heading","content":"GCD / HCF"},{"type":"paragraph","content":"The GCD (or HCF) of two numbers is the largest number that divides both exactly. Use prime factorisation or listing factors."},{"type":"example","title":"Find the HCF of $48$ and $72$","steps":["$48 = 2^4 \\times 3$; $72 = 2^3 \\times 3^2$.","Common primes with lowest powers: $2^3 \\times 3 = 24$."],"answer":"$24$"},{"type":"callout","variant":"warning","content":"HCF uses the **lowest** power of each common prime; LCM uses the **highest**."},{"type":"question","questionText":"Find the HCF of $18$ and $24$.","questionType":"multiple_choice","options":["$6$","$12$","$3$","$72$"],"correctAnswer":"$6$","explanation":"Common factors: $1,2,3,6$; greatest is $6$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'gcd_hcf'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Greatest Common Divisor (GCD/HCF)'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Lowest Common Multiple (LCM)', '{"blocks":[{"type":"heading","content":"LCM"},{"type":"paragraph","content":"The LCM is the smallest positive number that is a multiple of both numbers. Useful for adding fractions and scheduling events."},{"type":"example","title":"Find the LCM of $12$ and $18$","steps":["$12 = 2^2 \\times 3$; $18 = 2 \\times 3^2$.","LCM $= 2^2 \\times 3^2 = 36$."],"answer":"$36$"},{"type":"example","title":"Buses leave a stage every $12$ min and $18$ min. When do they next leave together?","steps":["Need LCM of $12$ and $18$.","LCM $= 36$ minutes."],"answer":"After $36$ minutes"},{"type":"question","questionText":"Find the LCM of $8$ and $12$.","questionType":"multiple_choice","options":["$24$","$96$","$4$","$48$"],"correctAnswer":"$24$","explanation":"$24$ is the smallest common multiple."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'factors' AND st.code = 'lcm'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Lowest Common Multiple (LCM)'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a prime number?', 'multiple_choice', '["$29$","$39$","$49$","$51$"]'::jsonb, '"$29$"'::jsonb, 'easy', '$29$ has only two factors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a prime number?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many factors does $13$ have?', 'multiple_choice', '["$2$","$3$","$1$","$13$"]'::jsonb, '"$2$"'::jsonb, 'easy', 'Prime numbers have exactly two factors.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many factors does $13$ have?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $30$ as a product of primes.', 'multiple_choice', '["$2 \\times 3 \\times 5$","$5 \\times 6$","$2 \\times 15$","$3 \\times 10$"]'::jsonb, '"$2 \\times 3 \\times 5$"'::jsonb, 'easy', 'All factors are prime.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $30$ as a product of primes.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $12$ and $16$.', 'multiple_choice', '["$4$","$8$","$2$","$48$"]'::jsonb, '"$4$"'::jsonb, 'easy', 'Common factors: $1,2,4$; HCF $=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $12$ and $16$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $9$ and $15$.', 'multiple_choice', '["$3$","$5$","$45$","$6$"]'::jsonb, '"$3$"'::jsonb, 'easy', 'Both divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $9$ and $15$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $4$ and $6$.', 'multiple_choice', '["$12$","$24$","$2$","$10$"]'::jsonb, '"$12$"'::jsonb, 'easy', 'Multiples: $4,8,12$ and $6,12$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $4$ and $6$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $5$ and $7$.', 'multiple_choice', '["$35$","$12$","$1$","$70$"]'::jsonb, '"$35$"'::jsonb, 'easy', 'Coprime: product gives LCM.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $5$ and $7$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $60$ in prime factor form.', 'multiple_choice', '["$2^2 \\times 3 \\times 5$","$2 \\times 30$","$4 \\times 15$","$6 \\times 10$"]'::jsonb, '"$2^2 \\times 3 \\times 5$"'::jsonb, 'medium', 'Factor tree gives $2,2,3,5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $60$ in prime factor form.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $36$ and $54$.', 'multiple_choice', '["$18$","$9$","$6$","$108$"]'::jsonb, '"$18$"'::jsonb, 'medium', '$36=2^2\times3^2$; $54=2\times3^3$; HCF $=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $36$ and $54$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $15$ and $20$.', 'multiple_choice', '["$60$","$300$","$5$","$35$"]'::jsonb, '"$60$"'::jsonb, 'medium', '$15=3\times5$; $20=2^2\times5$; LCM $=60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $15$ and $20$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Tiles of size $12$ cm and $18$ cm — largest square tile dividing both?', 'multiple_choice', '["$6$ cm","$3$ cm","$12$ cm","$36$ cm"]'::jsonb, '"$6$ cm"'::jsonb, 'medium', 'HCF of $12$ and $18$ is $6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Tiles of size $12$ cm and $18$ cm — largest square tile dividing both?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Two bells ring every $8$ s and $12$ s. Together again after?', 'multiple_choice', '["$24$ s","$20$ s","$4$ s","$96$ s"]'::jsonb, '"$24$ s"'::jsonb, 'medium', 'LCM of $8$ and $12$ is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Two bells ring every $8$ s and $12$ s. Together again after?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is the prime factorisation of $84$?', 'multiple_choice', '["$2^2 \\times 3 \\times 7$","$2 \\times 42$","$4 \\times 21$","$6 \\times 14$"]'::jsonb, '"$2^2 \\times 3 \\times 7$"'::jsonb, 'medium', 'Divide by primes: $84=2\times2\times3\times7$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is the prime factorisation of $84$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $45$ and $75$.', 'multiple_choice', '["$15$","$5$","$3$","$225$"]'::jsonb, '"$15$"'::jsonb, 'medium', '$45=3^2\times5$; $75=3\times5^2$; HCF $=15$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $45$ and $75$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A number has prime factors $2^3 \times 5$. What is the number?', 'multiple_choice', '["$40$","$80$","$10$","$25$"]'::jsonb, '"$40$"'::jsonb, 'hard', '$8 \times 5 = 40$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A number has prime factors $2^3 \times 5$. What is the number?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the HCF of $84$ and $126$.', 'multiple_choice', '["$42$","$21$","$14$","$7$"]'::jsonb, '"$42$"'::jsonb, 'hard', 'Common: $2\times3\times7=42$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the HCF of $84$ and $126$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Find the LCM of $18$ and $24$.', 'multiple_choice', '["$72$","$432$","$6$","$48$"]'::jsonb, '"$72$"'::jsonb, 'hard', '$18=2\times3^2$; $24=2^3\times3$; LCM $=72$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Find the LCM of $18$ and $24$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Matatu A every $15$ min, B every $20$ min. Next together?', 'multiple_choice', '["$60$ min","$35$ min","$5$ min","$300$ min"]'::jsonb, '"$60$ min"'::jsonb, 'hard', 'LCM of $15$ and $20$ is $60$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Matatu A every $15$ min, B every $20$ min. Next together?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Cut ropes of $48$ m and $72$ m into equal pieces — longest piece?', 'multiple_choice', '["$24$ m","$12$ m","$6$ m","$48$ m"]'::jsonb, '"$24$ m"'::jsonb, 'hard', 'HCF of $48$ and $72$ is $24$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='gcd_hcf'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Cut ropes of $48$ m and $72$ m into equal pieces — longest piece?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many prime factors (with repetition) in $100$?', 'multiple_choice', '["$4$","$2$","$3$","$5$"]'::jsonb, '"$4$"'::jsonb, 'hard', '$100=2\times2\times5\times5$: four primes.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='prime_factors'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many prime factors (with repetition) in $100$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'LCM of $14$, $21$ and $6$?', 'multiple_choice', '["$42$","$84$","$126$","$7$"]'::jsonb, '"$42$"'::jsonb, 'hard', '$42$ is divisible by $14$, $21$ and $6$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='lcm'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='factors'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='LCM of $14$, $21$ and $6$?');

-- ========== DIVISIBILITY TESTS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Divisibility by 2, 3, 4 and 5', '{"blocks":[{"type":"heading","content":"Tests for 2, 3, 4 and 5"},{"type":"callout","variant":"key_point","content":"Divisible by $2$ or $5$: check the **last digit**. Divisible by $3$: sum of digits divisible by $3$. Divisible by $4$: last **two** digits form a number divisible by $4$."},{"type":"example","title":"Is $3\\,456$ divisible by $3$?","steps":["Sum of digits: $3+4+5+6=18$.","$18$ is divisible by $3$, so $3\\,456$ is divisible by $3$."],"answer":"Yes"},{"type":"example","title":"Is $7\\,128$ divisible by $4$?","steps":["Last two digits: $28$.","$28 \\div 4 = 7$, so divisible by $4$."],"answer":"Yes"},{"type":"question","questionText":"Which number is divisible by $5$?","questionType":"multiple_choice","options":["$1\\,235$","$1\\,234$","$1\\,236$","$1\\,233$"],"correctAnswer":"$1\\,235$","explanation":"Last digit must be $0$ or $5$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'tests_2_3_4_5'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Divisibility by 2, 3, 4 and 5'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Divisibility by 6, 8, 9, 10 and 11', '{"blocks":[{"type":"heading","content":"Tests for 6, 8, 9, 10 and 11"},{"type":"paragraph","content":"Divisible by $6$: divisible by both $2$ and $3$. Divisible by $8$: last three digits divisible by $8$. Divisible by $9$: digit sum divisible by $9$. Divisible by $10$: last digit $0$. Divisible by $11$: alternating sum of digits divisible by $11$."},{"type":"example","title":"Is $5\\,544$ divisible by $8$?","steps":["Last three digits: $544$.","$544 \\div 8 = 68$, so yes."],"answer":"Yes"},{"type":"callout","variant":"warning","content":"For $11$, subtract and add digits alternately from the right."},{"type":"question","questionText":"Which is divisible by $9$?","questionType":"multiple_choice","options":["$5\\,463$","$5\\,464$","$5\\,465$","$5\\,462$"],"correctAnswer":"$5\\,463$","explanation":"Digit sum $5+4+6+3=18$, divisible by $9$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'tests_6_8_9_10_11'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Divisibility by 6, 8, 9, 10 and 11'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Divisibility in Problems', '{"blocks":[{"type":"heading","content":"Applications of Divisibility"},{"type":"paragraph","content":"Divisibility tests speed up factorisation, simplifying fractions, and checking whether a number is prime or composite."},{"type":"example","title":"Is $2\\,731$ divisible by $11$?","steps":["Alternating sum: $1-3+7-2=3$.","$3$ is not divisible by $11$, so $2\\,731$ is not."],"answer":"No"},{"type":"example","title":"Find the missing digit so $4\\,5\\_2$ is divisible by $3$","steps":["Sum so far: $4+5+2=11$.","Try digit $1$: sum $12$, divisible by $3$."],"answer":"$1$"},{"type":"question","questionText":"A number ending in $0$ is always divisible by:","questionType":"multiple_choice","options":["$10$","$3$","$4$","$8$"],"correctAnswer":"$10$","explanation":"Last digit $0$ means divisible by $10$ (and $2$ and $5$)."}]}'::jsonb, 10, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'divisibility_tests' AND st.code = 'applications'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Divisibility in Problems'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $2$?', 'multiple_choice', '["$346$","$351$","$355$","$357$"]'::jsonb, '"$346$"'::jsonb, 'easy', 'Last digit must be even.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $2$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $5$?', 'multiple_choice', '["$2\\,450$","$2\\,451$","$2\\,452$","$2\\,453$"]'::jsonb, '"$2\\,450$"'::jsonb, 'easy', 'Last digit $0$ or $5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $123$ divisible by $3$?', 'multiple_choice', '["Yes","No","Cannot tell","Only by $1$"]'::jsonb, '"Yes"'::jsonb, 'easy', 'Digit sum $1+2+3=6$, divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $123$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $4$?', 'multiple_choice', '["$316$","$318$","$322$","$326$"]'::jsonb, '"$316$"'::jsonb, 'easy', 'Last two digits $16$; $16\div4=4$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $4$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $10$?', 'multiple_choice', '["$1\\,230$","$1\\,235$","$1\\,236$","$1\\,239$"]'::jsonb, '"$1\\,230$"'::jsonb, 'easy', 'Must end in $0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $10$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $9$?', 'multiple_choice', '["$729$","$728$","$730$","$731$"]'::jsonb, '"$729$"'::jsonb, 'easy', 'Digit sum $7+2+9=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $6$?', 'multiple_choice', '["$234$","$235$","$237$","$239$"]'::jsonb, '"$234$"'::jsonb, 'easy', 'Even and digit sum $9$ (div by $3$).'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $6$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Smallest digit to make $45\_8$ divisible by $3$?', 'multiple_choice', '["$1$","$2$","$0$","$4$"]'::jsonb, '"$1$"'::jsonb, 'medium', 'Sum $4+5+8=17$; add $1$ gives $18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Smallest digit to make $45\_8$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $8$?', 'multiple_choice', '["$5\\,024$","$5\\,026$","$5\\,028$","$5\\,030$"]'::jsonb, '"$5\\,024$"'::jsonb, 'medium', 'Last three digits $024=24$; $24\div8=3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is divisible by $11$?', 'multiple_choice', '["$1\\,221$","$1\\,222$","$1\\,223$","$1\\,224$"]'::jsonb, '"$1\\,221$"'::jsonb, 'medium', 'Alt sum $1-2+2-1=0$, divisible by $11$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is divisible by $11$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which number is divisible by both $2$ and $5$?', 'multiple_choice', '["$340$","$345$","$342$","$343$"]'::jsonb, '"$340$"'::jsonb, 'medium', 'Ends in $0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which number is divisible by both $2$ and $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'To check if $7\,848$ is divisible by $4$, you examine:', 'multiple_choice', '["Last two digits","Last digit only","First digit","Digit sum"]'::jsonb, '"Last two digits"'::jsonb, 'medium', 'Divisibility by $4$ uses last two digits.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='To check if $7\,848$ is divisible by $4$, you examine:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $5\,832$ divisible by $9$?', 'multiple_choice', '["Yes","No","Only by $3$","Cannot tell"]'::jsonb, '"Yes"'::jsonb, 'medium', 'Sum $5+8+3+2=18$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $5\,832$ divisible by $9$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A number divisible by $6$ must be:', 'multiple_choice', '["Even and sum of digits div by $3$","Odd only","Ending in $5$","Sum of digits div by $2$"]'::jsonb, '"Even and sum of digits div by $3$"'::jsonb, 'medium', 'Rule for $6$: both $2$ and $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A number divisible by $6$ must be:');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Largest 3-digit number divisible by $5$?', 'multiple_choice', '["$995$","$990$","$999$","$985$"]'::jsonb, '"$995$"'::jsonb, 'hard', 'Must end in $0$ or $5$; $995$ is largest.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Largest 3-digit number divisible by $5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $9\,072$ divisible by $8$?', 'multiple_choice', '["Yes","No","Only by $4$","Only by $2$"]'::jsonb, '"Yes"'::jsonb, 'hard', 'Last three digits $072=72$; $72\div8=9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $9\,072$ divisible by $8$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which digit makes $24\_6$ divisible by $3$?', 'multiple_choice', '["$0$","$1$","$2$","$4$"]'::jsonb, '"$0$"'::jsonb, 'hard', 'Sum $2+4+0+6=12$, divisible by $3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which digit makes $24\_6$ divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is NOT divisible by $11$?', 'multiple_choice', '["$1\\,234$","$1\\,221$","$1\\,331$","$1\\,111$"]'::jsonb, '"$1\\,234$"'::jsonb, 'hard', 'Alt sum $4-3+2-1=2$, not divisible by $11$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_6_8_9_10_11'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is NOT divisible by $11$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Is $84/126$ in lowest terms?', 'multiple_choice', '["No — HCF is $42$","Yes","No — HCF is $6$","No — HCF is $21$"]'::jsonb, '"No — HCF is $42$"'::jsonb, 'hard', 'HCF $42$; reduces to $2/3$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Is $84/126$ in lowest terms?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'How many integers from $100$ to $108$ inclusive are divisible by $3$?', 'multiple_choice', '["$3$","$4$","$2$","$5$"]'::jsonb, '"$3$"'::jsonb, 'hard', '$102$, $105$, $108$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='tests_2_3_4_5'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='How many integers from $100$ to $108$ inclusive are divisible by $3$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A 4-digit number ends in $20$ and digit sum is $18$. It is divisible by:', 'multiple_choice', '["$9$ and $10$","$8$ only","$11$ only","$4$ only"]'::jsonb, '"$9$ and $10$"'::jsonb, 'hard', 'Ends $20$ → div $10$; sum $18$ → div $9$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='applications'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='divisibility_tests'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A 4-digit number ends in $20$ and digit sum is $18$. It is divisible by:');

-- ========== DECIMALS ==========

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Decimal Place Value', '{"blocks":[{"type":"heading","content":"Decimal Place Value"},{"type":"paragraph","content":"Decimals extend place value to tenths, hundredths, thousandths. The decimal point separates whole and fractional parts."},{"type":"callout","variant":"key_point","content":"In $3.45$, the $4$ is in the tenths place ($0.4$) and $5$ in hundredths ($0.05$)."},{"type":"example","title":"Write the value of $7$ in $12.73$","steps":["$7$ is in the tenths place.","Value $= 0.7$."],"answer":"$0.7$"},{"type":"question","questionText":"Which is greater: $0.8$ or $0.75$?","questionType":"multiple_choice","options":["$0.8$","$0.75$","Equal","Cannot tell"],"correctAnswer":"$0.8$","explanation":"$0.8 = 0.80 > 0.75$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'place_value_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Decimal Place Value'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Operations with Decimals', '{"blocks":[{"type":"heading","content":"Operations with Decimals"},{"type":"paragraph","content":"Line up decimal points for addition and subtraction. For multiplication, count total decimal places. For division, shift decimals to make the divisor a whole number."},{"type":"example","title":"Evaluate $2.5 + 1.35$","steps":["Align decimals: $2.50 + 1.35$.","Sum $= 3.85$."],"answer":"$3.85$"},{"type":"example","title":"Evaluate $0.4 \\times 0.3$","steps":["$4 \\times 3 = 12$.","Two decimal places: $0.12$."],"answer":"$0.12$"},{"type":"callout","variant":"warning","content":"Do not line up digits without aligning the decimal point."},{"type":"question","questionText":"Evaluate $5.6 - 2.4$","questionType":"multiple_choice","options":["$3.2$","$3.0$","$2.2$","$4.0$"],"correctAnswer":"$3.2$","explanation":"Subtract tenths: $5.6 - 2.4 = 3.2$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'operations_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Operations with Decimals'
);
INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Recurring Decimals and Conversions', '{"blocks":[{"type":"heading","content":"Recurring Decimals"},{"type":"paragraph","content":"Some fractions produce decimals that repeat forever, e.g. $\\frac{1}{3} = 0.333\\ldots$ written $0.\\dot{3}$. Convert fractions to decimals by division."},{"type":"example","title":"Convert $\\frac{3}{8}$ to a decimal","steps":["$3 \\div 8 = 0.375$.","Terminating decimal."],"answer":"$0.375$"},{"type":"example","title":"Convert $0.25$ to a fraction","steps":["$0.25 = \\frac{25}{100}$.","Simplify: $\\frac{1}{4}$."],"answer":"$\\frac{1}{4}$"},{"type":"question","questionText":"Which fraction equals $0.5$?","questionType":"multiple_choice","options":["$\\frac{1}{2}$","$\\frac{1}{5}$","$\\frac{2}{5}$","$\\frac{1}{4}$"],"correctAnswer":"$\\frac{1}{2}$","explanation":"$0.5 = \\frac{5}{10} = \\frac{1}{2}$."}]}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'mathematics' AND t.code = 'decimals' AND st.code = 'recurring_decimals'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Recurring Decimals and Conversions'
);
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'What is the place value of $6$ in $4.62$?', 'multiple_choice', '["Tenths","Hundredths","Ones","Thousandths"]'::jsonb, '"Hundredths"'::jsonb, 'easy', '$6$ is in the hundredths place.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='What is the place value of $6$ in $4.62$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $0.7$ as a fraction.', 'multiple_choice', '["$\\frac{7}{10}$","$\\frac{7}{100}$","$\\frac{1}{7}$","$\\frac{70}{10}$"]'::jsonb, '"$\\frac{7}{10}$"'::jsonb, 'easy', 'One decimal place → tenths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $0.7$ as a fraction.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $1.2 + 0.5$.', 'multiple_choice', '["$1.7$","$1.5$","$0.7$","$2.0$"]'::jsonb, '"$1.7$"'::jsonb, 'easy', 'Add tenths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $1.2 + 0.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $3.0 - 1.8$.', 'multiple_choice', '["$1.2$","$1.8$","$2.2$","$4.8$"]'::jsonb, '"$1.2$"'::jsonb, 'easy', 'Column subtraction.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $3.0 - 1.8$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{1}{2}$ to a decimal.', 'multiple_choice', '["$0.5$","$0.2$","$0.25$","$0.12$"]'::jsonb, '"$0.5$"'::jsonb, 'easy', '$1 \div 2 = 0.5$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{1}{2}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is smallest: $0.4$, $0.35$, $0.5$?', 'multiple_choice', '["$0.35$","$0.4$","$0.5$","All equal"]'::jsonb, '"$0.35$"'::jsonb, 'easy', 'Compare hundredths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is smallest: $0.4$, $0.35$, $0.5$?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $0.2 \times 0.5$.', 'multiple_choice', '["$0.1$","$0.01$","$0.7$","$1.0$"]'::jsonb, '"$0.1$"'::jsonb, 'easy', '$2 \times 5 = 10$; two decimal places → $0.10$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $0.2 \times 0.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Round $3.456$ to 1 decimal place.', 'multiple_choice', '["$3.5$","$3.4$","$3.46$","$3.0$"]'::jsonb, '"$3.5$"'::jsonb, 'medium', 'Hundredths digit $5$, round up.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Round $3.456$ to 1 decimal place.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $2.4 \times 1.5$.', 'multiple_choice', '["$3.6$","$3.0$","$2.9$","$4.0$"]'::jsonb, '"$3.6$"'::jsonb, 'medium', '$24 \times 15 = 360$; two decimal places.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $2.4 \times 1.5$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $7.2 \div 0.9$.', 'multiple_choice', '["$8$","$0.8$","$6.3$","$80$"]'::jsonb, '"$8$"'::jsonb, 'medium', 'Multiply both by $10$: $72 \div 9 = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $7.2 \div 0.9$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{1}{4}$ to a decimal.', 'multiple_choice', '["$0.25$","$0.4$","$0.5$","$0.75$"]'::jsonb, '"$0.25$"'::jsonb, 'medium', '$1 \div 4 = 0.25$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{1}{4}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Express $0.75$ as a fraction in lowest terms.', 'multiple_choice', '["$\\frac{3}{4}$","$\\frac{75}{100}$","$\\frac{7}{5}$","$\\frac{1}{4}$"]'::jsonb, '"$\\frac{3}{4}$"'::jsonb, 'medium', '$\frac{75}{100} = \frac{3}{4}$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Express $0.75$ as a fraction in lowest terms.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Order $0.09$, $0.9$, $0.099$ from smallest.', 'multiple_choice', '["$0.09, 0.099, 0.9$","$0.9, 0.099, 0.09$","$0.099, 0.09, 0.9$","$0.09, 0.9, 0.099$"]'::jsonb, '"$0.09, 0.099, 0.9$"'::jsonb, 'medium', 'Compare place values carefully.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Order $0.09$, $0.9$, $0.099$ from smallest.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A book costs KES $45.50$. Pay with KES $50$. Change?', 'multiple_choice', '["KES $4.50$","KES $5.50$","KES $4.00$","KES $5.00$"]'::jsonb, '"KES $4.50$"'::jsonb, 'medium', '$50.00 - 45.50 = 4.50$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A book costs KES $45.50$. Pay with KES $50$. Change?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Write $2\,000 + 0.03$ as a decimal.', 'multiple_choice', '["$2\\,000.03$","$200.03$","$2\\,003$","$20.03$"]'::jsonb, '"$2\\,000.03$"'::jsonb, 'hard', 'Whole plus hundredths.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Write $2\,000 + 0.03$ as a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $(1.5 + 0.5) \times 2.0$.', 'multiple_choice', '["$4.0$","$3.0$","$2.5$","$5.0$"]'::jsonb, '"$4.0$"'::jsonb, 'hard', 'Brackets: $2.0 \times 2.0 = 4.0$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $(1.5 + 0.5) \times 2.0$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Which is a recurring decimal?', 'multiple_choice', '["$0.\\dot{3}$","$0.25$","$0.5$","$0.125$"]'::jsonb, '"$0.\\dot{3}$"'::jsonb, 'hard', '$\frac{1}{3}$ repeats; others terminate.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Which is a recurring decimal?');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $0.48 \div 0.06$.', 'multiple_choice', '["$8$","$0.8$","$80$","$6$"]'::jsonb, '"$8$"'::jsonb, 'hard', 'Scale: $48 \div 6 = 8$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $0.48 \div 0.06$.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Convert $\frac{5}{8}$ to a decimal.', 'multiple_choice', '["$0.625$","$0.58$","$0.85$","$0.125$"]'::jsonb, '"$0.625$"'::jsonb, 'hard', '$5 \div 8 = 0.625$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='recurring_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Convert $\frac{5}{8}$ to a decimal.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'A length is $3.05$ m. Express in cm.', 'multiple_choice', '["$305$ cm","$30.5$ cm","$350$ cm","$3\\,050$ cm"]'::jsonb, '"$305$ cm"'::jsonb, 'hard', 'Multiply by $100$: $305$ cm.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='place_value_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='A length is $3.05$ m. Express in cm.');
INSERT INTO public.practice_questions (topic_id, subtopic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, st.id, 'Evaluate $12.6 \div 0.3 + 1.2$.', 'multiple_choice', '["$43.2$","$42.0$","$4.2$","$13.8$"]'::jsonb, '"$43.2$"'::jsonb, 'hard', '$12.6 \div 0.3 = 42$; $42 + 1.2 = 43.2$.'
FROM public.topics t JOIN public.subjects s ON s.id=t.subject_id JOIN public.curricula c ON c.id=s.curriculum_id
JOIN public.subtopics st ON st.topic_id=t.id AND st.code='operations_decimals'
WHERE c.code='KCSE' AND s.code='mathematics' AND t.code='decimals'
AND NOT EXISTS (SELECT 1 FROM public.practice_questions pq WHERE pq.topic_id=t.id AND pq.question_text='Evaluate $12.6 \div 0.3 + 1.2$.');