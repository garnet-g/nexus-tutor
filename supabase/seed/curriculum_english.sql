-- English curriculum seed (CBC + KCSE)
-- Nexus V2 Tier 1 Phase 2.4

-- CBC topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'reading_comprehension', 'Reading Comprehension', 'Find main ideas, make inferences, and learn vocabulary in context.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'main_idea', 'Main Idea', 'Identify what a passage is mostly about.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Finding the Main Idea', '{"blocks":[{"type":"heading","content":"Finding the Main Idea"},{"type":"paragraph","content":"The main idea is the most important point the writer makes."},{"type":"example","title":"A paragraph describes how bees pollinate crops. What is the main idea?","steps":["Ask what the paragraph is mostly about","It focuses on bees helping crops","Bees pollinate crops"],"answer":"Bees pollinate crops"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'main_idea'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Finding the Main Idea'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'inference', 'Inference', 'Read between the lines.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Making an Inference', '{"blocks":[{"type":"heading","content":"Making an Inference"},{"type":"paragraph","content":"An inference uses evidence plus what you already know."},{"type":"example","title":"Musa packed an umbrella and wore boots. What can you infer about the weather?","steps":["Umbrella and boots suggest rain","He expects wet conditions","Rainy weather is likely"],"answer":"Rain is likely"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'inference'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Making an Inference'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vocabulary', 'Vocabulary in Context', 'Use clues to learn new words.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Context Clues', '{"blocks":[{"type":"heading","content":"Context Clues"},{"type":"paragraph","content":"Nearby words can reveal the meaning of an unfamiliar word."},{"type":"example","title":"The arid land had little rain. What does arid mean?","steps":["Little rain suggests dry conditions","Arid means very dry","Dry"],"answer":"Dry"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'vocabulary'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Context Clues'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'grammar', 'Grammar', 'Master parts of speech, sentence structure, and tenses.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'parts_of_speech', 'Parts of Speech', 'Nouns, verbs, adjectives, and more.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Nouns and Verbs', '{"blocks":[{"type":"heading","content":"Nouns and Verbs"},{"type":"paragraph","content":"A noun names a person, place, or thing. A verb shows action or state."},{"type":"example","title":"In ''Amina runs daily'', which word is the verb?","steps":["Find the action word","Runs shows action","runs"],"answer":"runs"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'parts_of_speech'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Nouns and Verbs'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sentences', 'Sentence Structure', 'Subjects, predicates, and clauses.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Complete Sentences', '{"blocks":[{"type":"heading","content":"Complete Sentences"},{"type":"paragraph","content":"A complete sentence has a subject and a predicate."},{"type":"example","title":"Which is a complete sentence?","steps":["Under the tree","The learners study","Because it rained"],"answer":"The learners study"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'sentences'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Complete Sentences'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tenses', 'Tenses', 'Past, present, and future.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Simple Past Tense', '{"blocks":[{"type":"heading","content":"Simple Past Tense"},{"type":"paragraph","content":"Past tense describes actions that already happened."},{"type":"example","title":"Change ''She walks'' to past tense.","steps":["Walks becomes walked","Add -ed for regular verbs","She walked"],"answer":"She walked"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'tenses'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Simple Past Tense'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'writing_skills', 'Writing Skills', 'Build paragraphs, use punctuation, and write summaries — not full essays for students.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'paragraphs', 'Paragraphs', 'Topic sentence and supporting details.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Topic Sentences', '{"blocks":[{"type":"heading","content":"Topic Sentences"},{"type":"paragraph","content":"A paragraph begins with a sentence that states the main point."},{"type":"example","title":"Write a topic sentence for a paragraph about school gardens.","steps":["State the main idea clearly","School gardens help learners grow food","Our school garden teaches us to grow vegetables"],"answer":"School gardens teach learners to grow food"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'paragraphs'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Topic Sentences'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'punctuation', 'Punctuation', 'Commas, full stops, and question marks.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Using Commas in Lists', '{"blocks":[{"type":"heading","content":"Using Commas in Lists"},{"type":"paragraph","content":"Use commas to separate items in a list."},{"type":"example","title":"Punctuate: mangoes bananas oranges","steps":["List items need commas","mangoes, bananas, oranges","mangoes, bananas, and oranges"],"answer":"mangoes, bananas, oranges"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'punctuation'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Using Commas in Lists'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'summaries', 'Summaries', 'Shorten a passage in your own words.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Writing a Summary', '{"blocks":[{"type":"heading","content":"Writing a Summary"},{"type":"paragraph","content":"A summary gives the key points in fewer words without copying."},{"type":"example","title":"Summarise: ''The team trained every evening and won the county cup.''","steps":["Keep only key facts","Training led to winning","The team trained and won the county cup"],"answer":"The team trained and won the county cup"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'summaries'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Writing a Summary'
);

-- KCSE topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'reading_comprehension', 'Reading Comprehension', 'Analyse passages for KCSE-style comprehension.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'main_idea', 'Main Idea', 'Central argument or theme.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Identifying Theme', '{"blocks":[{"type":"heading","content":"Identifying Theme"},{"type":"paragraph","content":"Theme is the underlying message of a text."},{"type":"example","title":"A story shows honesty winning over cheating. What is the theme?","steps":["Ask what lesson the story teaches","Honesty is rewarded","Honesty is important"],"answer":"Honesty is important"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'main_idea'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Identifying Theme'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'inference', 'Inference', 'Implied meaning and tone.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tone and Mood', '{"blocks":[{"type":"heading","content":"Tone and Mood"},{"type":"paragraph","content":"Tone is the writer''s attitude; mood is the feeling created."},{"type":"example","title":"Words like ''gloomy'' and ''silent'' create what mood?","steps":["These words feel sad and heavy","The mood is sombre","Somber or sad mood"],"answer":"Somber mood"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'inference'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tone and Mood'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'vocabulary', 'Vocabulary in Context', 'Advanced word meaning.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Figurative Language', '{"blocks":[{"type":"heading","content":"Figurative Language"},{"type":"paragraph","content":"Metaphors compare two things without using like or as."},{"type":"example","title":"''Time is a thief'' is an example of what?","steps":["It compares time to a thief directly","No like/as is used","Metaphor"],"answer":"Metaphor"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension' AND st.code = 'vocabulary'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Figurative Language'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'grammar', 'Grammar', 'Advanced sentence analysis for secondary English.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'parts_of_speech', 'Parts of Speech', 'Function words in complex sentences.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Adjectives and Adverbs', '{"blocks":[{"type":"heading","content":"Adjectives and Adverbs"},{"type":"paragraph","content":"Adjectives describe nouns; adverbs modify verbs."},{"type":"example","title":"In ''She sang beautifully'', what part of speech is beautifully?","steps":["It describes how she sang","It modifies the verb sang","Adverb"],"answer":"Adverb"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'parts_of_speech'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Adjectives and Adverbs'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'sentences', 'Sentence Structure', 'Simple, compound, and complex sentences.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Compound Sentences', '{"blocks":[{"type":"heading","content":"Compound Sentences"},{"type":"paragraph","content":"A compound sentence joins two independent clauses."},{"type":"example","title":"Join: ''I studied. I passed.''","steps":["Use a conjunction","I studied, and I passed","I studied and passed"],"answer":"I studied, and I passed"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'sentences'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Compound Sentences'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'tenses', 'Tenses', 'Perfect and continuous forms.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Present Perfect Tense', '{"blocks":[{"type":"heading","content":"Present Perfect Tense"},{"type":"paragraph","content":"Present perfect links past action to present result."},{"type":"example","title":"Form present perfect of ''finish'' for ''they''.","steps":["Use have/has + past participle","They have finished","They have finished"],"answer":"They have finished"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar' AND st.code = 'tenses'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Present Perfect Tense'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'writing_skills', 'Writing Skills', 'Plan and edit writing — Nex guides structure, not ghostwritten essays.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'paragraphs', 'Paragraphs', 'Cohesion and transitions.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Linking Ideas', '{"blocks":[{"type":"heading","content":"Linking Ideas"},{"type":"paragraph","content":"Transition words connect paragraphs smoothly."},{"type":"example","title":"Choose a linker: However, Therefore, Meanwhile","steps":["However shows contrast","Use when ideas oppose","However"],"answer":"However"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'paragraphs'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Linking Ideas'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'punctuation', 'Punctuation', 'Apostrophes and speech marks.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Apostrophes for Possession', '{"blocks":[{"type":"heading","content":"Apostrophes for Possession"},{"type":"paragraph","content":"Use apostrophe + s for singular possession."},{"type":"example","title":"Rewrite: the book of John","steps":["John owns the book","John''s book","John''s book"],"answer":"John''s book"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'punctuation'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Apostrophes for Possession'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'summaries', 'Summaries', 'Precis and note-making.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Precis Writing', '{"blocks":[{"type":"heading","content":"Precis Writing"},{"type":"paragraph","content":"A precis is a short, accurate summary in your own words."},{"type":"example","title":"What should you avoid in a precis?","steps":["Do not copy long phrases","Avoid unnecessary detail","Copying the whole passage"],"answer":"Copying the whole passage"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills' AND st.code = 'summaries'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Precis Writing'
);

-- Practice questions (21 per topic)
INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 1: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 1: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 2: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'easy', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 2: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 3: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'easy', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 3: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 4: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 4: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 5: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'easy', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 5: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 6: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'easy', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 6: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 7: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 7: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 8: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 8: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 9: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'medium', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 9: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 10: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'medium', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 10: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 11: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 11: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 12: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'medium', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 12: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 13: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'medium', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 13: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 14: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 14: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 15: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 15: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 16: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'hard', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 16: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 17: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'hard', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 17: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 18: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 18: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 19: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'hard', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 19: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 20: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'hard', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 20: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC reading_comprehension practice 21: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC reading_comprehension practice 21: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 1: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 1: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 2: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'easy', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 2: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 3: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'easy', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 3: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 4: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 4: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 5: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'easy', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 5: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 6: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'easy', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 6: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 7: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 7: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 8: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 8: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 9: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'medium', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 9: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 10: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'medium', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 10: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 11: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 11: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 12: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'medium', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 12: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 13: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'medium', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 13: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 14: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 14: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 15: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 15: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 16: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'hard', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 16: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 17: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'hard', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 17: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 18: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 18: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 19: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'hard', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 19: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 20: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'hard', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 20: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC grammar practice 21: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC grammar practice 21: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 1: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 1: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 2: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'easy', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 2: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 3: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'easy', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 3: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 4: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 4: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 5: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'easy', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 5: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 6: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'easy', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 6: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 7: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 7: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 8: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 8: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 9: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'medium', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 9: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 10: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'medium', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 10: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 11: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 11: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 12: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'medium', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 12: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 13: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'medium', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 13: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 14: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 14: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 15: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 15: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 16: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'hard', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 16: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 17: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'hard', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 17: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 18: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 18: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 19: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'hard', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 19: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 20: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'hard', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 20: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC writing_skills practice 21: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC writing_skills practice 21: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 1: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 1: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 2: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'easy', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 2: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 3: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'easy', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 3: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 4: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 4: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 5: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'easy', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 5: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 6: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'easy', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 6: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 7: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'easy', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 7: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 8: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 8: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 9: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'medium', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 9: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 10: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'medium', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 10: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 11: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 11: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 12: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'medium', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 12: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 13: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'medium', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 13: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 14: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'medium', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 14: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 15: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 15: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 16: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'hard', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 16: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 17: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'hard', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 17: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 18: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 18: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 19: What is the main idea of a paragraph?', 'multiple_choice', '["Smallest detail","Most important point","A random fact","The title only"]'::jsonb, '"Most important point"'::jsonb, 'hard', 'Main idea = central point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 19: What is the main idea of a paragraph?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 20: An inference uses evidence and what else?', 'multiple_choice', '["Luck","Prior knowledge","Pictures only","Nothing else"]'::jsonb, '"Prior knowledge"'::jsonb, 'hard', 'You combine clues with what you know.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 20: An inference uses evidence and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE reading_comprehension practice 21: Context clues help you find what?', 'multiple_choice', '["Page number","Word meaning","Author age","Book price"]'::jsonb, '"Word meaning"'::jsonb, 'hard', 'Nearby words explain new vocabulary.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'reading_comprehension'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE reading_comprehension practice 21: Context clues help you find what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 1: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 1: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 2: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'easy', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 2: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 3: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'easy', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 3: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 4: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 4: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 5: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'easy', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 5: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 6: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'easy', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 6: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 7: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'easy', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 7: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 8: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 8: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 9: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'medium', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 9: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 10: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'medium', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 10: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 11: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 11: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 12: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'medium', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 12: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 13: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'medium', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 13: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 14: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'medium', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 14: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 15: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 15: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 16: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'hard', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 16: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 17: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'hard', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 17: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 18: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 18: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 19: Which word is usually a verb?', 'multiple_choice', '["Table","Quickly","Jump","Blue"]'::jsonb, '"Jump"'::jsonb, 'hard', 'Verbs show action or state.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 19: Which word is usually a verb?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 20: A complete sentence needs a subject and what?', 'multiple_choice', '["Predicate","Picture","Chapter","Index"]'::jsonb, '"Predicate"'::jsonb, 'hard', 'Subject + predicate = complete sentence.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 20: A complete sentence needs a subject and what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE grammar practice 21: Past tense of walk is what?', 'multiple_choice', '["Walks","Walking","Walked","Will walk"]'::jsonb, '"Walked"'::jsonb, 'hard', 'Regular past tense adds -ed.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'grammar'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE grammar practice 21: Past tense of walk is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 1: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 1: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 2: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'easy', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 2: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 3: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'easy', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 3: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 4: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 4: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 5: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'easy', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 5: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 6: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'easy', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 6: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 7: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'easy', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 7: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 8: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 8: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 9: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'medium', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 9: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 10: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'medium', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 10: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 11: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 11: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 12: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'medium', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 12: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 13: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'medium', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 13: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 14: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'medium', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 14: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 15: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 15: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 16: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'hard', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 16: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 17: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'hard', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 17: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 18: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 18: A summary should be shorter than the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 19: A topic sentence states the what?', 'multiple_choice', '["Author birthday","Main point","Page count","Font size"]'::jsonb, '"Main point"'::jsonb, 'hard', 'Topic sentence = main point.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 19: A topic sentence states the what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 20: Commas separate items in a what?', 'multiple_choice', '["List","Title","Cover","Spine"]'::jsonb, '"List"'::jsonb, 'hard', 'Use commas between list items.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 20: Commas separate items in a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE writing_skills practice 21: A summary should be shorter than the what?', 'multiple_choice', '["Original","Dictionary","Cover","Index"]'::jsonb, '"Original"'::jsonb, 'hard', 'Summaries are shorter than the source.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'english' AND t.code = 'writing_skills'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE writing_skills practice 21: A summary should be shorter than the what?'
);

