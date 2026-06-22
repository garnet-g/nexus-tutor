-- Kiswahili curriculum seed (CBC + KCSE) — skeleton only; lessons/questions via content pipeline

-- CBC topics

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'kusoma', 'Kusoma', 'CBC Kiswahili — kusoma kwa ufasaha na uelewa.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kusoma_kwa_kuelewa', 'Kusoma kwa Kuelewa', 'Kusoma kwa Kuelewa', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusoma'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kusoma_kwa_makini', 'Kusoma kwa Makini', 'Kusoma kwa Makini', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusoma'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kusoma_kwa_mapana', 'Kusoma kwa Mapana', 'Kusoma kwa Mapana', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusoma'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'kuandika', 'Kuandika', 'CBC Kiswahili — uandishi sahihi na ubunifu.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'uandishi_sahihi', 'Uandishi Sahihi', 'Uandishi Sahihi', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kuandika'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'muundo_wa_insha', 'Muundo wa Insha', 'Muundo wa Insha', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kuandika'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'maandishi_ya_kazi', 'Maandishi ya Kazi', 'Maandishi ya Kazi', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kuandika'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'kusikiliza_na_kuzungumza', 'Kusikiliza na Kuzungumza', 'CBC Kiswahili — mawasiliano ya mdomo.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mazungumzo', 'Mazungumzo', 'Mazungumzo', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusikiliza_na_kuzungumza'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kusikiliza_kwa_kusikika', 'Kusikiliza kwa Kusikika', 'Kusikiliza kwa Kusikika', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusikiliza_na_kuzungumza'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hotuba', 'Hotuba', 'Hotuba', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'kusikiliza_na_kuzungumza'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'sarufi', 'Sarufi', 'CBC Kiswahili — kanuni za sarufi.', 4, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'aina_za_maneno', 'Aina za Maneno', 'Aina za Maneno', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'sarufi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'uundaji_wa_sentensi', 'Uundaji wa Sentensi', 'Uundaji wa Sentensi', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'sarufi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'matumizi_ya_sarufi', 'Matumizi ya Sarufi', 'Matumizi ya Sarufi', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'sarufi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'msamiati', 'Msamiati', 'CBC Kiswahili — kujenga msamiati.', 5, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kujenga_msamiati', 'Kujenga Msamiati', 'Kujenga Msamiati', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'msamiati'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'maneno_mapya', 'Maneno Mapya', 'Maneno Mapya', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'msamiati'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'matumizi_msamiati', 'Matumizi ya Msamiati', 'Matumizi ya Msamiati', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'kiswahili' AND t.code = 'msamiati'
ON CONFLICT (topic_id, code) DO NOTHING;


-- KCSE topics

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'methali_na_misemo', 'Methali na Misemo', 'KCSE Kiswahili — methali na misemo.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'methali', 'Methali', 'Methali', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'methali_na_misemo'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'misemo', 'Misemo', 'Misemo', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'methali_na_misemo'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tafsiri_methali', 'Tafsiri ya Methali', 'Tafsiri ya Methali', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'methali_na_misemo'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'sarufi_na_matumizi_ya_lugha', 'Sarufi na Matumizi ya Lugha', 'KCSE Kiswahili Karatasi 102/1 — sarufi.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'aina_za_maneno_kcse', 'Aina za Maneno', 'Aina za Maneno', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'sarufi_na_matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'uundaji_sentensi_kcse', 'Uundaji wa Sentensi', 'Uundaji wa Sentensi', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'sarufi_na_matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'matumizi_lugha', 'Matumizi ya Lugha', 'Matumizi ya Lugha', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'sarufi_na_matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'insha', 'Insha', 'KCSE Kiswahili Karatasi 102/1 — insha.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'insha_za_fasihi', 'Insha za Fasihi', 'Insha za Fasihi', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'insha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'insha_za_kiundishi', 'Insha za Kiundishi', 'Insha za Kiundishi', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'insha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'uhariri', 'Uhariri', 'Uhariri', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'insha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'ufahamu', 'Ufahamu', 'KCSE Kiswahili Karatasi 102/2 — ufahamu.', 4, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kuelewa_mada', 'Kuelewa Mada', 'Kuelewa Mada', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufahamu'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mawazo_makuu', 'Mawazo Makuu', 'Mawazo Makuu', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufahamu'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'lugha_figurative', 'Lugha ya Picha', 'Lugha ya Picha', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufahamu'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'ufupisho', 'Ufupisho', 'KCSE Kiswahili Karatasi 102/2 — ufupisho.', 5, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kuchagua_pointi', 'Kuchagua Pointi', 'Kuchagua Pointi', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufupisho'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kuandika_ufupisho', 'Kuandika Ufupisho', 'Kuandika Ufupisho', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufupisho'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'kuiga_lugha', 'Kuiga Lugha', 'Kuiga Lugha', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ufupisho'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'matumizi_ya_lugha', 'Matumizi ya Lugha', 'KCSE Kiswahili Karatasi 102/2 — matumizi ya lugha.', 6, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ibada_ya_lugha', 'Ibada ya Lugha', 'Ibada ya Lugha', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'semi', 'Semi', 'Semi', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nahau', 'Nahau', 'Nahau', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'matumizi_ya_lugha'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'isimu_jamii', 'Isimu Jamii', 'KCSE Kiswahili Karatasi 102/2 — isimu jamii.', 7, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'lugha_na_jamii', 'Lugha na Jamii', 'Lugha na Jamii', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'isimu_jamii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'msamiati_maalum', 'Msamiati Maalum', 'Msamiati Maalum', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'isimu_jamii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mitindo_ya_lugha', 'Mitindo ya Lugha', 'Mitindo ya Lugha', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'isimu_jamii'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'fasihi_simulizi', 'Fasihi Simulizi', 'KCSE Kiswahili Karatasi 102/3 — fasihi simulizi.', 8, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'hadithi_za_mitholojia', 'Hadithi za Mitholojia', 'Hadithi za Mitholojia', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'fasihi_simulizi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nyimbo_za_jadi', 'Nyimbo za Jadi', 'Nyimbo za Jadi', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'fasihi_simulizi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'methali_fasihi', 'Methali', 'Methali', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'fasihi_simulizi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'ushairi', 'Ushairi', 'KCSE Kiswahili Karatasi 102/3 — ushairi.', 9, 2
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vipengele_vya_ushairi', 'Vipengele vya Ushairi', 'Vipengele vya Ushairi', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ushairi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ufuatiliaji_wa_lugha', 'Ufuatiliaji wa Lugha', 'Ufuatiliaji wa Lugha', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ushairi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ufasiri_wa_mashairi', 'Ufasiri wa Mashairi', 'Ufasiri wa Mashairi', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'ushairi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'riwaya', 'Riwaya (Set Text)', 'KCSE Kiswahili Karatasi 102/3 — riwaya.', 10, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mandhari', 'Mandhari', 'Mandhari', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'riwaya'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'wahusika', 'Wahusika', 'Wahusika', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'riwaya'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'dhamira', 'Dhamira', 'Dhamira', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'riwaya'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'tamthilia', 'Tamthilia (Set Text)', 'KCSE Kiswahili Karatasi 102/3 — tamthilia.', 11, 3
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tamthilia_migogo', 'Tamthilia Migogo', 'Tamthilia Migogo', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'tamthilia'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'wahusika_tamthilia', 'Wahusika', 'Wahusika', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'tamthilia'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'ujumbe', 'Ujumbe', 'Ujumbe', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'tamthilia'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'hadithi_fupi', 'Hadithi Fupi (Set Text)', 'KCSE Kiswahili Karatasi 102/3 — hadithi fupi.', 12, 4
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'muundo_hadithi', 'Muundo wa Hadithi', 'Muundo wa Hadithi', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'hadithi_fupi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'maudhui', 'Maudhui', 'Maudhui', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'hadithi_fupi'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'mbinu', 'Mbinu', 'Mbinu', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'kiswahili' AND t.code = 'hadithi_fupi'
ON CONFLICT (topic_id, code) DO NOTHING;
