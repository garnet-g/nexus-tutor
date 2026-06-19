-- Science curriculum seed (CBC + KCSE)
-- Nexus V2 Tier 1 Phase 2.4

-- CBC topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'living_things', 'Living Things', 'Classify organisms and explore life processes in Kenyan ecosystems.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'classification', 'Classification', 'Group living things by shared features.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Vertebrates and Invertebrates', '{"blocks":[{"type":"heading","content":"Vertebrates and Invertebrates"},{"type":"paragraph","content":"Animals with backbones are vertebrates; those without are invertebrates."},{"type":"example","title":"A frog has a backbone. Is it a vertebrate or invertebrate?","steps":["Check if it has a backbone","Frogs have a spine","A frog is a vertebrate"],"answer":"Vertebrate"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things' AND st.code = 'classification'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Vertebrates and Invertebrates'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'habitats', 'Habitats', 'Where organisms live and why.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Savanna Habitat', '{"blocks":[{"type":"heading","content":"Savanna Habitat"},{"type":"paragraph","content":"A habitat provides food, water, and shelter for organisms."},{"type":"example","title":"Why do zebras live on the savanna?","steps":["Savanna has grass for food","Open space helps spot predators","Water sources are available seasonally"],"answer":"Grass, safety, and water"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things' AND st.code = 'habitats'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Savanna Habitat'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'life_processes', 'Life Processes', 'Nutrition, growth, and reproduction.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Photosynthesis Basics', '{"blocks":[{"type":"heading","content":"Photosynthesis Basics"},{"type":"paragraph","content":"Green plants make food using sunlight, water, and carbon dioxide."},{"type":"example","title":"What gas do plants release during photosynthesis?","steps":["Plants use CO₂ and release O₂","Oxygen supports animal life","The gas is oxygen"],"answer":"Oxygen"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things' AND st.code = 'life_processes'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Photosynthesis Basics'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'matter_energy', 'Matter & Energy', 'Explore states of matter, simple machines, and energy in daily life.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'states_of_matter', 'States of Matter', 'Solid, liquid, and gas.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'States of Water', '{"blocks":[{"type":"heading","content":"States of Water"},{"type":"paragraph","content":"Water can be ice (solid), liquid water, or steam (gas)."},{"type":"example","title":"What state is water at 100°C?","steps":["At boiling point water becomes gas","Steam is water vapour","The state is gas"],"answer":"Gas"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy' AND st.code = 'states_of_matter'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'States of Water'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'simple_machines', 'Simple Machines', 'Levers, pulleys, and inclined planes.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Levers at Home', '{"blocks":[{"type":"heading","content":"Levers at Home"},{"type":"paragraph","content":"A lever helps lift loads with less effort using a fulcrum."},{"type":"example","title":"A see-saw is which type of simple machine?","steps":["It pivots around a central point","That pivot is a fulcrum","A see-saw is a lever"],"answer":"Lever"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy' AND st.code = 'simple_machines'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Levers at Home'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'energy_forms', 'Energy Forms', 'Heat, light, and sound energy.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sound Energy', '{"blocks":[{"type":"heading","content":"Sound Energy"},{"type":"paragraph","content":"Sound travels as vibrations through air and other materials."},{"type":"example","title":"How does a drum produce sound?","steps":["Hitting the drum makes it vibrate","Vibrations move through air","We hear the vibrations as sound"],"answer":"Vibration"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy' AND st.code = 'energy_forms'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sound Energy'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'earth_environment', 'Earth & Environment', 'Study weather, soil, and conservation in Kenya.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'weather', 'Weather', 'Measure and describe daily weather.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Reading a Thermometer', '{"blocks":[{"type":"heading","content":"Reading a Thermometer"},{"type":"paragraph","content":"Temperature tells how hot or cold the air is."},{"type":"example","title":"If a thermometer reads 30°C, is it warm or cold?","steps":["30°C is above room temperature","Kenyan afternoons can reach 30°C","It is warm"],"answer":"Warm"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment' AND st.code = 'weather'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Reading a Thermometer'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'soil', 'Soil', 'Types of soil and their uses.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Sandy vs Clay Soil', '{"blocks":[{"type":"heading","content":"Sandy vs Clay Soil"},{"type":"paragraph","content":"Sandy soil drains quickly; clay holds more water."},{"type":"example","title":"Which soil type drains water faster?","steps":["Sand has larger gaps between particles","Water passes through sand quickly","Sandy soil drains faster"],"answer":"Sandy soil"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment' AND st.code = 'soil'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Sandy vs Clay Soil'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'conservation', 'Conservation', 'Protect natural resources.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Tree Planting', '{"blocks":[{"type":"heading","content":"Tree Planting"},{"type":"paragraph","content":"Trees reduce soil erosion and improve air quality."},{"type":"example","title":"Name one benefit of planting trees in your community.","steps":["Tree roots hold soil","Leaves provide shade and oxygen","Any valid conservation benefit"],"answer":"Reduces erosion"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment' AND st.code = 'conservation'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Tree Planting'
);

-- KCSE topics
INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'biology_basics', 'Biology Basics', 'Cells, nutrition, and respiration for secondary science.', 1, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'cells', 'Cells', 'Structure and function of cells.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Plant and Animal Cells', '{"blocks":[{"type":"heading","content":"Plant and Animal Cells"},{"type":"paragraph","content":"Cells are the basic units of life with specialised parts."},{"type":"example","title":"Name the part that controls cell activities.","steps":["The nucleus directs cell functions","It is found in both plant and animal cells","The nucleus controls activities"],"answer":"Nucleus"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics' AND st.code = 'cells'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Plant and Animal Cells'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'nutrition', 'Nutrition', 'Balanced diet and digestion.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Balanced Diet', '{"blocks":[{"type":"heading","content":"Balanced Diet"},{"type":"paragraph","content":"A balanced diet includes carbohydrates, proteins, fats, vitamins, and minerals."},{"type":"example","title":"Which nutrient mainly builds body tissues?","steps":["Proteins repair and build tissues","Carbohydrates mainly give energy","Proteins build tissues"],"answer":"Proteins"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics' AND st.code = 'nutrition'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Balanced Diet'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'respiration', 'Respiration', 'How organisms release energy from food.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Aerobic Respiration', '{"blocks":[{"type":"heading","content":"Aerobic Respiration"},{"type":"paragraph","content":"Cells release energy from glucose using oxygen."},{"type":"example","title":"What are the products of aerobic respiration?","steps":["Glucose + oxygen → CO₂ + water + energy","Carbon dioxide and water are released","CO₂, water, and energy"],"answer":"CO₂, water, energy"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics' AND st.code = 'respiration'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Aerobic Respiration'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'chemistry_basics', 'Chemistry Basics', 'Elements, acids, bases, and simple reactions.', 2, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'elements', 'Elements', 'Symbols and the periodic table.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Element Symbols', '{"blocks":[{"type":"heading","content":"Element Symbols"},{"type":"paragraph","content":"Each element has a chemical symbol such as O for oxygen."},{"type":"example","title":"What is the symbol for sodium?","steps":["Sodium''s symbol is Na","It comes from the Latin name natrium","Na"],"answer":"Na"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics' AND st.code = 'elements'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Element Symbols'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'acids_bases', 'Acids & Bases', 'Properties and indicators.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Acids and Bases', '{"blocks":[{"type":"heading","content":"Acids and Bases"},{"type":"paragraph","content":"Acids taste sour; bases feel slippery and taste bitter."},{"type":"example","title":"What colour does litmus turn in an acid?","steps":["Acids turn blue litmus red","Bases turn red litmus blue","Acids turn litmus red"],"answer":"Red"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics' AND st.code = 'acids_bases'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Acids and Bases'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'reactions', 'Chemical Reactions', 'Signs that a reaction occurred.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Signs of a Reaction', '{"blocks":[{"type":"heading","content":"Signs of a Reaction"},{"type":"paragraph","content":"A chemical reaction may produce gas, colour change, or heat."},{"type":"example","title":"Rusting iron is an example of what?","steps":["Iron reacts with oxygen and water","A new substance forms","A chemical reaction"],"answer":"Chemical reaction"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics' AND st.code = 'reactions'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Signs of a Reaction'
);

INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, 'physics_basics', 'Physics Basics', 'Forces, electricity, and waves.', 3, 1
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'forces', 'Forces', 'Push, pull, and friction.', 1
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Balanced Forces', '{"blocks":[{"type":"heading","content":"Balanced Forces"},{"type":"paragraph","content":"When forces are equal and opposite, an object stays still or moves steadily."},{"type":"example","title":"A book on a table stays still because forces are what?","steps":["Weight pulls down, table pushes up","Forces are equal and opposite","Balanced"],"answer":"Balanced"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics' AND st.code = 'forces'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Balanced Forces'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'electricity', 'Electricity', 'Current, voltage, and circuits.', 2
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Series Circuits', '{"blocks":[{"type":"heading","content":"Series Circuits"},{"type":"paragraph","content":"In a series circuit, current has one path to follow."},{"type":"example","title":"If one bulb breaks in series, what happens?","steps":["Current path is broken","Other bulbs go off","All bulbs go off"],"answer":"All bulbs go off"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics' AND st.code = 'electricity'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Series Circuits'
);

INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, 'waves', 'Waves', 'Properties of waves and sound.', 3
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
ON CONFLICT (topic_id, code) DO NOTHING;

INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, 'Wave Properties', '{"blocks":[{"type":"heading","content":"Wave Properties"},{"type":"paragraph","content":"Waves have amplitude, wavelength, and frequency."},{"type":"example","title":"What is the height of a wave from rest position called?","steps":["Amplitude measures wave height","Wavelength is distance between peaks","Amplitude"],"answer":"Amplitude"},{"type":"tip","content":"Write each step clearly before moving to the next one."}],"shortQuiz":{"questions":[{"questionText":"Which step comes first in this lesson?","options":["Guess the answer","Read the problem carefully","Skip working"],"correctAnswer":"Read the problem carefully"}]}}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics' AND st.code = 'waves'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = 'Wave Properties'
);

-- Practice questions (21 per topic)
INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 1: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'easy', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 1: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 2: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'easy', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 2: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 3: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'easy', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 3: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 4: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'easy', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 4: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 5: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'easy', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 5: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 6: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'easy', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 6: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 7: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'easy', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 7: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 8: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'medium', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 8: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 9: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'medium', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 9: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 10: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'medium', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 10: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 11: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'medium', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 11: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 12: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'medium', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 12: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 13: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'medium', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 13: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 14: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'medium', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 14: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 15: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'hard', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 15: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 16: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'hard', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 16: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 17: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'hard', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 17: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 18: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'hard', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 18: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 19: Which group includes animals with backbones?', 'multiple_choice', '["Invertebrates","Vertebrates","Fungi","Bacteria"]'::jsonb, '"Vertebrates"'::jsonb, 'hard', 'Vertebrates have a backbone.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 19: Which group includes animals with backbones?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 20: Plants make food through which process?', 'multiple_choice', '["Respiration","Photosynthesis","Digestion","Evaporation"]'::jsonb, '"Photosynthesis"'::jsonb, 'hard', 'Plants use sunlight to make food.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 20: Plants make food through which process?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC living_things practice 21: A habitat provides food, water, and what else?', 'multiple_choice', '["Shelter","Money","Plastic","Electricity"]'::jsonb, '"Shelter"'::jsonb, 'hard', 'Organisms need shelter in a habitat.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'living_things'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC living_things practice 21: A habitat provides food, water, and what else?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 1: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'easy', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 1: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 2: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'easy', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 2: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 3: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'easy', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 3: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 4: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'easy', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 4: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 5: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'easy', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 5: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 6: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'easy', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 6: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 7: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'easy', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 7: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 8: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'medium', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 8: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 9: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'medium', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 9: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 10: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'medium', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 10: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 11: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'medium', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 11: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 12: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'medium', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 12: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 13: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'medium', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 13: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 14: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'medium', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 14: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 15: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'hard', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 15: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 16: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'hard', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 16: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 17: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'hard', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 17: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 18: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'hard', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 18: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 19: Ice is water in which state?', 'multiple_choice', '["Solid","Liquid","Gas","Plasma"]'::jsonb, '"Solid"'::jsonb, 'hard', 'Ice is solid water.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 19: Ice is water in which state?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 20: A see-saw is an example of a what?', 'multiple_choice', '["Pulley","Lever","Wedge","Screw"]'::jsonb, '"Lever"'::jsonb, 'hard', 'A see-saw pivots on a fulcrum.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 20: A see-saw is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC matter_energy practice 21: Sound is produced by what?', 'multiple_choice', '["Light","Vibrations","Gravity","Magnetism"]'::jsonb, '"Vibrations"'::jsonb, 'hard', 'Vibrations travel as sound waves.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'matter_energy'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC matter_energy practice 21: Sound is produced by what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 1: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'easy', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 1: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 2: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'easy', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 2: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 3: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'easy', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 3: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 4: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'easy', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 4: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 5: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'easy', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 5: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 6: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'easy', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 6: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 7: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'easy', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 7: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 8: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'medium', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 8: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 9: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'medium', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 9: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 10: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'medium', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 10: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 11: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'medium', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 11: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 12: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'medium', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 12: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 13: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'medium', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 13: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 14: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'medium', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 14: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 15: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'hard', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 15: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 16: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'hard', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 16: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 17: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'hard', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 17: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 18: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'hard', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 18: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 19: Which soil drains water fastest?', 'multiple_choice', '["Clay","Sandy","Loam","Peat"]'::jsonb, '"Sandy"'::jsonb, 'hard', 'Sand has large spaces between particles.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 19: Which soil drains water fastest?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 20: Planting trees helps reduce what?', 'multiple_choice', '["Rainfall","Soil erosion","Gravity","Sunlight"]'::jsonb, '"Soil erosion"'::jsonb, 'hard', 'Tree roots hold soil in place.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 20: Planting trees helps reduce what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'CBC earth_environment practice 21: A thermometer measures what?', 'multiple_choice', '["Wind speed","Temperature","Humidity","Pressure"]'::jsonb, '"Temperature"'::jsonb, 'hard', 'Thermometers measure heat level.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'CBC' AND s.code = 'science' AND t.code = 'earth_environment'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'CBC earth_environment practice 21: A thermometer measures what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 1: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'easy', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 1: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 2: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'easy', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 2: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 3: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'easy', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 3: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 4: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'easy', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 4: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 5: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'easy', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 5: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 6: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'easy', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 6: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 7: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'easy', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 7: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 8: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'medium', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 8: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 9: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'medium', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 9: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 10: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'medium', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 10: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 11: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'medium', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 11: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 12: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'medium', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 12: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 13: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'medium', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 13: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 14: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'medium', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 14: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 15: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'hard', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 15: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 16: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'hard', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 16: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 17: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'hard', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 17: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 18: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'hard', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 18: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 19: Which organelle controls the cell?', 'multiple_choice', '["Nucleus","Cell wall","Chloroplast","Ribosome"]'::jsonb, '"Nucleus"'::jsonb, 'hard', 'The nucleus controls cell activities.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 19: Which organelle controls the cell?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 20: Which nutrient builds body tissues?', 'multiple_choice', '["Carbohydrates","Proteins","Fats","Water"]'::jsonb, '"Proteins"'::jsonb, 'hard', 'Proteins repair and build tissues.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 20: Which nutrient builds body tissues?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE biology_basics practice 21: Aerobic respiration needs which gas?', 'multiple_choice', '["Nitrogen","Oxygen","Helium","Carbon monoxide"]'::jsonb, '"Oxygen"'::jsonb, 'hard', 'Cells use oxygen to release energy.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'biology_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE biology_basics practice 21: Aerobic respiration needs which gas?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 1: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'easy', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 1: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 2: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'easy', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 2: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 3: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'easy', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 3: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 4: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'easy', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 4: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 5: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'easy', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 5: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 6: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'easy', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 6: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 7: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'easy', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 7: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 8: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'medium', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 8: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 9: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'medium', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 9: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 10: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'medium', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 10: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 11: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'medium', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 11: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 12: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'medium', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 12: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 13: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'medium', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 13: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 14: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'medium', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 14: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 15: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'hard', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 15: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 16: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'hard', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 16: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 17: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'hard', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 17: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 18: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'hard', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 18: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 19: What is the symbol for oxygen?', 'multiple_choice', '["O","Ox","Og","Om"]'::jsonb, '"O"'::jsonb, 'hard', 'O is the symbol for oxygen.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 19: What is the symbol for oxygen?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 20: Acids turn blue litmus what colour?', 'multiple_choice', '["Green","Red","Purple","Yellow"]'::jsonb, '"Red"'::jsonb, 'hard', 'Acids turn blue litmus red.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 20: Acids turn blue litmus what colour?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE chemistry_basics practice 21: Rusting is an example of a what?', 'multiple_choice', '["Physical change","Chemical reaction","State change","Mixture"]'::jsonb, '"Chemical reaction"'::jsonb, 'hard', 'A new substance forms when iron rusts.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'chemistry_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE chemistry_basics practice 21: Rusting is an example of a what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 1: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'easy', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 1: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 2: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'easy', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 2: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 3: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'easy', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 3: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 4: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'easy', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 4: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 5: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'easy', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 5: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 6: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'easy', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 6: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 7: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'easy', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 7: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 8: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'medium', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 8: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 9: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'medium', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 9: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 10: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'medium', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 10: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 11: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'medium', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 11: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 12: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'medium', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 12: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 13: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'medium', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 13: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 14: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'medium', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 14: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 15: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'hard', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 15: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 16: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'hard', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 16: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 17: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'hard', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 17: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 18: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'hard', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 18: Wave height from rest is called what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 19: Balanced forces mean an object is what?', 'multiple_choice', '["Accelerating","Stationary or steady","Spinning","Floating"]'::jsonb, '"Stationary or steady"'::jsonb, 'hard', 'Equal forces cancel out.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 19: Balanced forces mean an object is what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 20: In a series circuit, one broken bulb causes what?', 'multiple_choice', '["Brighter bulbs","All bulbs off","No change","Only one off"]'::jsonb, '"All bulbs off"'::jsonb, 'hard', 'Series has one current path.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 20: In a series circuit, one broken bulb causes what?'
);

INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, 'KCSE physics_basics practice 21: Wave height from rest is called what?', 'multiple_choice', '["Frequency","Amplitude","Wavelength","Speed"]'::jsonb, '"Amplitude"'::jsonb, 'hard', 'Amplitude is wave height.'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = 'KCSE' AND s.code = 'science' AND t.code = 'physics_basics'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = 'KCSE physics_basics practice 21: Wave height from rest is called what?'
);

