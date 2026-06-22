-- Chemistry curriculum seed (KCSE) — skeleton only; lessons/questions via content pipeline

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'introduction_to_chemistry', 'Introduction to Chemistry', 'KCSE Chemistry — Introduction to Chemistry.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'laboratory_apparatus', 'Laboratory Apparatus', 'Laboratory Apparatus', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'introduction_to_chemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'safety_rules', 'Laboratory Safety Rules', 'Laboratory Safety Rules', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'introduction_to_chemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'scientific_method', 'The Scientific Method', 'The Scientific Method', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'introduction_to_chemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'simple_classification_of_substances', 'Simple Classification of Substances', 'KCSE Chemistry — Simple Classification of Substances.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'elements_compounds_mixtures', 'Elements, Compounds and Mixtures', 'Elements, Compounds and Mixtures', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'simple_classification_of_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'physical_chemical_changes', 'Physical and Chemical Changes', 'Physical and Chemical Changes', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'simple_classification_of_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'separation_techniques', 'Separation Techniques', 'Separation Techniques', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'simple_classification_of_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'acids_bases_indicators', 'Acids, Bases and Indicators', 'KCSE Chemistry — Acids, Bases and Indicators.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'properties_acids_bases', 'Properties of Acids and Bases', 'Properties of Acids and Bases', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_indicators'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ph_scale', 'The pH Scale', 'The pH Scale', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_indicators'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'natural_indicators', 'Natural Indicators', 'Natural Indicators', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_indicators'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'air_and_combustion', 'Air and Combustion', 'KCSE Chemistry — Air and Combustion.', 4, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'composition_of_air', 'Composition of Air', 'Composition of Air', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'air_and_combustion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'rusting', 'Rusting', 'Rusting', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'air_and_combustion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'burning_fuels', 'Burning and Fuels', 'Burning and Fuels', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'air_and_combustion'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'water_and_hydrogen', 'Water and Hydrogen', 'KCSE Chemistry — Water and Hydrogen.', 5, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'properties_of_water', 'Properties of Water', 'Properties of Water', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'water_and_hydrogen'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'water_treatment', 'Water Treatment', 'Water Treatment', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'water_and_hydrogen'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hydrogen_preparation', 'Preparation and Uses of Hydrogen', 'Preparation and Uses of Hydrogen', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'water_and_hydrogen'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'structure_of_the_atom_periodic_table', 'Structure of the Atom and the Periodic Table', 'KCSE Chemistry — Structure of the Atom and the Periodic Table.', 6, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'atomic_structure', 'Atomic Structure', 'Atomic Structure', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_of_the_atom_periodic_table'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'periodic_trends', 'Periodic Trends', 'Periodic Trends', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_of_the_atom_periodic_table'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'electronic_configuration', 'Electronic Configuration', 'Electronic Configuration', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_of_the_atom_periodic_table'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'chemical_families', 'Chemical Families', 'KCSE Chemistry — Chemical Families.', 7, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'alkali_metals', 'Alkali Metals', 'Alkali Metals', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chemical_families'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'halogens', 'Halogens', 'Halogens', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chemical_families'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'noble_gases', 'Noble Gases', 'Noble Gases', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chemical_families'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'structure_and_bonding', 'Structure and Bonding', 'KCSE Chemistry — Structure and Bonding.', 8, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ionic_bonding', 'Ionic Bonding', 'Ionic Bonding', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_and_bonding'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'covalent_bonding', 'Covalent Bonding', 'Covalent Bonding', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_and_bonding'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'metallic_bonding', 'Metallic Bonding', 'Metallic Bonding', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'structure_and_bonding'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'salts', 'Salts', 'KCSE Chemistry — Salts.', 9, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'preparation_of_salts', 'Preparation of Salts', 'Preparation of Salts', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'solubility_rules', 'Solubility Rules', 'Solubility Rules', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'uses_of_salts', 'Uses of Salts', 'Uses of Salts', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'effect_of_electric_current_on_substances', 'Effect of Electric Current on Substances', 'KCSE Chemistry — Effect of Electric Current on Substances.', 10, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'electrolysis', 'Electrolysis', 'Electrolysis', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'effect_of_electric_current_on_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'electroplating', 'Electroplating', 'Electroplating', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'effect_of_electric_current_on_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'faraday_laws', 'Faraday''s Laws', 'Faraday''s Laws', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'effect_of_electric_current_on_substances'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'carbon_and_its_compounds', 'Carbon and Its Compounds', 'KCSE Chemistry — Carbon and Its Compounds.', 11, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'allotropes_of_carbon', 'Allotropes of Carbon', 'Allotropes of Carbon', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'carbon_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hydrocarbons', 'Hydrocarbons', 'Hydrocarbons', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'carbon_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'carbon_cycle', 'The Carbon Cycle', 'The Carbon Cycle', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'carbon_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'nitrogen_and_its_compounds', 'Nitrogen and Its Compounds', 'KCSE Chemistry — Nitrogen and Its Compounds.', 12, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nitrogen_cycle', 'The Nitrogen Cycle', 'The Nitrogen Cycle', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'nitrogen_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ammonia', 'Ammonia', 'Ammonia', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'nitrogen_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nitrates', 'Nitrates and Fertilisers', 'Nitrates and Fertilisers', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'nitrogen_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'sulphur_and_its_compounds', 'Sulphur and Its Compounds', 'KCSE Chemistry — Sulphur and Its Compounds.', 13, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'allotropes_of_sulphur', 'Allotropes of Sulphur', 'Allotropes of Sulphur', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'sulphur_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sulphur_dioxide', 'Sulphur Dioxide', 'Sulphur Dioxide', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'sulphur_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sulphuric_acid', 'Sulphuric Acid', 'Sulphuric Acid', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'sulphur_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'chlorine_and_its_compounds', 'Chlorine and Its Compounds', 'KCSE Chemistry — Chlorine and Its Compounds.', 14, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'preparation_of_chlorine', 'Preparation of Chlorine', 'Preparation of Chlorine', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chlorine_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'bleaching', 'Bleaching Action', 'Bleaching Action', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chlorine_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hydrochloric_acid', 'Hydrochloric Acid', 'Hydrochloric Acid', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'chlorine_and_its_compounds'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'the_mole', 'The Mole', 'KCSE Chemistry — The Mole.', 15, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'molar_mass', 'Molar Mass', 'Molar Mass', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'the_mole'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mole_calculations', 'Mole Calculations', 'Mole Calculations', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'the_mole'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'empirical_molecular_formulae', 'Empirical and Molecular Formulae', 'Empirical and Molecular Formulae', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'the_mole'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'organic_chemistry_i', 'Organic Chemistry I', 'KCSE Chemistry — Organic Chemistry I.', 16, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'homologous_series', 'Homologous Series', 'Homologous Series', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'organic_chemistry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'alkanes_and_alkenes', 'Alkanes and Alkenes', 'Alkanes and Alkenes', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'organic_chemistry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'functional_groups', 'Functional Groups', 'Functional Groups', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'organic_chemistry_i'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'metals', 'Metals', 'KCSE Chemistry — Metals.', 17, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reactivity_series', 'Reactivity Series', 'Reactivity Series', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'metals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'extraction_of_metals', 'Extraction of Metals', 'Extraction of Metals', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'metals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'alloys', 'Alloys', 'Alloys', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'metals'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'acids_bases_and_salts', 'Acids, Bases and Salts', 'KCSE Chemistry — Acids, Bases and Salts.', 18, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'neutralisation', 'Neutralisation', 'Neutralisation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_and_salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'titration', 'Titration', 'Titration', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_and_salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'buffer_solutions', 'Buffer Solutions', 'Buffer Solutions', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'acids_bases_and_salts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'energy_changes_in_chemical_reactions', 'Energy Changes in Chemical Reactions', 'KCSE Chemistry — Energy Changes in Chemical Reactions.', 19, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'exothermic_endothermic', 'Exothermic and Endothermic Reactions', 'Exothermic and Endothermic Reactions', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'energy_changes_in_chemical_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'enthalpy', 'Enthalpy Changes', 'Enthalpy Changes', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'energy_changes_in_chemical_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hess_law', 'Hess''s Law', 'Hess''s Law', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'energy_changes_in_chemical_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'reaction_rates_and_reversible_reactions', 'Reaction Rates and Reversible Reactions', 'KCSE Chemistry — Reaction Rates and Reversible Reactions.', 20, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'factors_affecting_rate', 'Factors Affecting Rate', 'Factors Affecting Rate', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'reaction_rates_and_reversible_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'equilibrium', 'Chemical Equilibrium', 'Chemical Equilibrium', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'reaction_rates_and_reversible_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'catalysts', 'Catalysts', 'Catalysts', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'reaction_rates_and_reversible_reactions'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'electrochemistry', 'Electrochemistry', 'KCSE Chemistry — Electrochemistry.', 21, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cells_and_electrodes', 'Cells and Electrodes', 'Cells and Electrodes', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'electrochemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'standard_electrode_potential', 'Standard Electrode Potential', 'Standard Electrode Potential', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'electrochemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'corrosion', 'Corrosion', 'Corrosion', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'electrochemistry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'radioactivity', 'Radioactivity', 'KCSE Chemistry — Radioactivity.', 22, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'types_of_radiation', 'Types of Radiation', 'Types of Radiation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'radioactivity'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nuclear_reactions', 'Nuclear Reactions', 'Nuclear Reactions', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'radioactivity'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'applications_of_radioactivity', 'Applications of Radioactivity', 'Applications of Radioactivity', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'chemistry' AND t.code = 'radioactivity'
ON CONFLICT (topic_id, code) DO NOTHING;
