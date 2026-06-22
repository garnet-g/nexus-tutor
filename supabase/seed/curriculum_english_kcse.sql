-- KCSE English skeleton seed — additive topics/subtopics only; lessons/questions via content pipeline
-- Existing topics reading_comprehension, grammar, writing_skills remain in curriculum_english.sql

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'pronunciation_articulation', 'Pronunciation & Articulation', 'KCSE English — Pronunciation & Articulation.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vowels_consonants', 'Vowels & Consonants', 'Vowels & Consonants', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'pronunciation_articulation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'minimal_pairs', 'Minimal Pairs', 'Minimal Pairs', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'pronunciation_articulation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'silent_letters', 'Silent Letters', 'Silent Letters', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'pronunciation_articulation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'stress_intonation', 'Stress & Intonation', 'KCSE English — Stress & Intonation.', 2, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'word_stress', 'Word Stress', 'Word Stress', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'stress_intonation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sentence_stress', 'Sentence Stress', 'Sentence Stress', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'stress_intonation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'intonation_patterns', 'Intonation Patterns', 'Intonation Patterns', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'stress_intonation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'listening_comprehension', 'Listening Comprehension', 'KCSE English — Listening Comprehension.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'listening_for_detail', 'Listening for Detail', 'Listening for Detail', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'listening_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'note_taking', 'Note Taking', 'Note Taking', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'listening_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'responding', 'Responding', 'Responding', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'listening_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'oral_etiquette_skills', 'Oral Etiquette & Communication Skills', 'KCSE English — Oral Etiquette & Communication Skills.', 4, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'turn_taking', 'Turn Taking', 'Turn Taking', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_etiquette_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'telephone_etiquette', 'Telephone Etiquette', 'Telephone Etiquette', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_etiquette_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'interviews_oral', 'Interviews', 'Interviews', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_etiquette_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'oral_literature', 'Oral Literature', 'KCSE English — Oral Literature.', 5, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'narratives_oral', 'Oral Narratives', 'Oral Narratives', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_literature'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'songs_proverbs', 'Songs & Proverbs', 'Songs & Proverbs', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_literature'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'riddles_tongue_twisters', 'Riddles & Tongue Twisters', 'Riddles & Tongue Twisters', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_literature'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'study_skills', 'Study & Reading Skills', 'KCSE English — Study & Reading Skills.', 6, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'skimming_scanning', 'Skimming & Scanning', 'Skimming & Scanning', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'study_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'note_making', 'Note Making', 'Note Making', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'study_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'summary_skills', 'Summary Skills', 'Summary Skills', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'study_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'intensive_reading', 'Intensive Reading', 'KCSE English — Intensive Reading.', 7, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'close_reading', 'Close Reading', 'Close Reading', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'intensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'interpretation', 'Interpretation', 'Interpretation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'intensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'evaluation', 'Evaluation', 'Evaluation', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'intensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'extensive_reading', 'Extensive Reading', 'KCSE English — Extensive Reading.', 8, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reading_for_pleasure', 'Reading for Pleasure', 'Reading for Pleasure', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'extensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'class_readers', 'Class Readers', 'Class Readers', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'extensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reviews', 'Book Reviews', 'Book Reviews', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'extensive_reading'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'nouns_pronouns', 'Nouns & Pronouns', 'KCSE English — Nouns & Pronouns.', 9, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'types_of_nouns', 'Types of Nouns', 'Types of Nouns', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'nouns_pronouns'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'number_gender', 'Number & Gender', 'Number & Gender', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'nouns_pronouns'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'pronoun_types', 'Pronoun Types', 'Pronoun Types', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'nouns_pronouns'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'verbs_tenses', 'Verbs & Tenses', 'KCSE English — Verbs & Tenses.', 10, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'verb_forms', 'Verb Forms', 'Verb Forms', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'verbs_tenses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tense_aspect', 'Tense & Aspect', 'Tense & Aspect', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'verbs_tenses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'subject_verb_agreement', 'Agreement', 'Agreement', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'verbs_tenses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'phrases_clauses', 'Phrases & Clauses', 'KCSE English — Phrases & Clauses.', 11, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'phrase_types', 'Phrase Types', 'Phrase Types', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'phrases_clauses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'clause_types', 'Clause Types', 'Clause Types', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'phrases_clauses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'complex_sentences', 'Complex Sentences', 'Complex Sentences', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'phrases_clauses'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'voice_speech', 'Active/Passive Voice & Reported Speech', 'KCSE English — Active/Passive Voice & Reported Speech.', 12, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'active_passive', 'Active & Passive', 'Active & Passive', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'voice_speech'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'direct_indirect', 'Direct & Indirect Speech', 'Direct & Indirect Speech', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'voice_speech'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'transformations_speech', 'Transformations', 'Transformations', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'voice_speech'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'prepositions_phrasal_verbs', 'Prepositions & Phrasal Verbs', 'KCSE English — Prepositions & Phrasal Verbs.', 13, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'prepositions', 'Prepositions', 'Prepositions', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'prepositions_phrasal_verbs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'phrasal_verbs', 'Phrasal Verbs', 'Phrasal Verbs', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'prepositions_phrasal_verbs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'collocations', 'Collocations', 'Collocations', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'prepositions_phrasal_verbs'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'question_tags_agreement', 'Question Tags & Concord', 'KCSE English — Question Tags & Concord.', 14, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'question_tags', 'Question Tags', 'Question Tags', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'question_tags_agreement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'concord', 'Concord', 'Concord', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'question_tags_agreement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'error_correction', 'Error Correction', 'Error Correction', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'question_tags_agreement'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'punctuation_mechanics', 'Punctuation & Mechanics', 'KCSE English — Punctuation & Mechanics.', 15, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'punctuation_marks', 'Punctuation Marks', 'Punctuation Marks', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'punctuation_mechanics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'capitalisation', 'Capitalisation', 'Capitalisation', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'punctuation_mechanics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'spelling', 'Spelling', 'Spelling', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'punctuation_mechanics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'word_formation', 'Word Formation & Vocabulary', 'KCSE English — Word Formation & Vocabulary.', 16, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'affixation', 'Affixation', 'Affixation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'word_formation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'synonyms_antonyms', 'Synonyms & Antonyms', 'Synonyms & Antonyms', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'word_formation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'idioms', 'Idiomatic Expressions', 'Idiomatic Expressions', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'word_formation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'functional_writing', 'Functional / Practical Writing', 'KCSE English — Functional / Practical Writing.', 17, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'personal_business_letters', 'Personal & Business Letters', 'Personal & Business Letters', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'functional_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'emails_memos', 'Emails & Memos', 'Emails & Memos', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'functional_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cv_application', 'CV & Application Letters', 'CV & Application Letters', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'functional_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'official_documents', 'Official Documents', 'KCSE English — Official Documents.', 18, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'minutes_agenda', 'Minutes & Agenda', 'Minutes & Agenda', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'official_documents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reports', 'Reports', 'Reports', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'official_documents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'speeches', 'Speeches', 'Speeches', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'official_documents'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'short_functional_texts', 'Short Functional Texts', 'KCSE English — Short Functional Texts.', 19, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'notices_fliers', 'Notices & Fliers', 'Notices & Fliers', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_functional_texts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'telephone_messages', 'Telephone Messages', 'Telephone Messages', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_functional_texts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'filling_forms', 'Filling Forms', 'Filling Forms', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_functional_texts'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'creative_composition', 'Creative Composition', 'KCSE English — Creative Composition.', 20, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'narrative_essay', 'Narrative Essay', 'Narrative Essay', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'creative_composition'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'descriptive_essay', 'Descriptive Essay', 'Descriptive Essay', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'creative_composition'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'expository_argumentative', 'Expository & Argumentative', 'Expository & Argumentative', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'creative_composition'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'essay_writing_skills', 'Essay Writing Skills', 'KCSE English — Essay Writing Skills.', 21, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'planning_outlining', 'Planning & Outlining', 'Planning & Outlining', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'essay_writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'coherence_cohesion', 'Coherence & Cohesion', 'Coherence & Cohesion', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'essay_writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'editing_revision', 'Editing & Revision', 'Editing & Revision', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'essay_writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'summary_writing', 'Summary Writing', 'KCSE English — Summary Writing.', 22, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'identifying_points', 'Identifying Points', 'Identifying Points', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'summary_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'paraphrasing', 'Paraphrasing', 'Paraphrasing', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'summary_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'word_limits', 'Working to Word Limits', 'Working to Word Limits', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'summary_writing'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'literary_appreciation', 'Literary Appreciation', 'KCSE English — Literary Appreciation.', 23, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'prose_appreciation', 'Prose Appreciation', 'Prose Appreciation', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'literary_appreciation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'figures_of_speech', 'Figures of Speech', 'Figures of Speech', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'literary_appreciation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'themes_style', 'Themes & Style', 'Themes & Style', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'literary_appreciation'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'poetry', 'Poetry', 'KCSE English — Poetry.', 24, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reading_poetry', 'Reading Poetry', 'Reading Poetry', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'poetry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'poetic_devices', 'Poetic Devices', 'Poetic Devices', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'poetry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'poetry_analysis', 'Analysis & Response', 'Analysis & Response', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'poetry'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'the_novel_set_text', '(placeholder for current texts)', 'KCSE English — Set text (placeholder).', 25, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'plot_structure', 'Plot & Structure', 'Plot & Structure', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_novel_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'characters_themes', 'Characters & Themes', 'Characters & Themes', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_novel_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'style_relevance', 'Style & Relevance', 'Style & Relevance', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_novel_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'the_play_set_text', '(placeholder for current texts)', 'KCSE English — Set text (placeholder).', 26, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'plot_dramatic', 'Plot & Dramatic Technique', 'Plot & Dramatic Technique', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_play_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'characters_conflict', 'Characters & Conflict', 'Characters & Conflict', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_play_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'themes_play', 'Themes', 'Themes', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'the_play_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'short_stories_set_text', '(placeholder for current texts)', 'KCSE English — Set text (placeholder).', 27, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'story_analysis', 'Story Analysis', 'Story Analysis', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_stories_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'comparative_themes', 'Comparative Themes', 'Comparative Themes', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_stories_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'essay_set_text', 'Essay Technique', 'Essay Technique', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'short_stories_set_text'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'oral_narrative_essay', 'Oral & Narrative Essay (Set-Text-Based)', 'KCSE English — Oral & Narrative Essay (Set-Text-Based).', 28, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'excerpt_questions', 'Excerpt Questions', 'Excerpt Questions', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_narrative_essay'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'essay_questions', 'Essay Questions', 'Essay Questions', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_narrative_essay'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'illustration_evidence', 'Illustration & Evidence', 'Illustration & Evidence', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'oral_narrative_essay'
ON CONFLICT (topic_id, code) DO NOTHING;
