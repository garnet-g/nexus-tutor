import fs from "fs";

const curricula = [
  {
    code: "CBC",
    topics: [
      {
        code: "fractions",
        title: "Fractions",
        desc: "Understand parts of a whole using Kenyan market examples.",
        subtopics: [
          { code: "intro", title: "Introduction to Fractions", desc: "What fractions represent." },
          { code: "equivalent", title: "Equivalent Fractions", desc: "Same value, different forms." },
          { code: "operations", title: "Fraction Operations", desc: "Add, subtract, multiply, and divide fractions." },
        ],
        lessons: [
          ["Understanding Fractions", "A fraction shows part of a whole. If Grace shares 3 of 8 mangoes, she has 3/8 of the mangoes.", "Grace has 8 mangoes and gives 3 to her friend. What fraction did she give away?", ["Identify the whole: 8 mangoes", "Count the part given: 3 mangoes", "Write as fraction: 3/8"], "3/8"],
          ["Finding Equivalent Fractions", "Equivalent fractions name the same amount. Multiply or divide numerator and denominator by the same number.", "Write an equivalent fraction for 2/5.", ["Multiply top and bottom by 2", "2×2 = 4 and 5×2 = 10", "Equivalent fraction is 4/10"], "4/10"],
          ["Adding Fractions with Same Denominator", "When denominators match, add the numerators and keep the denominator.", "Kamau ate 2/8 of a chapati and later 3/8. How much did he eat in total?", ["Denominators are both 8", "Add numerators: 2 + 3 = 5", "Answer: 5/8 of the chapati"], "5/8"],
        ],
      },
      {
        code: "algebra",
        title: "Algebra",
        desc: "Use letters to represent unknown values and solve simple equations.",
        subtopics: [
          { code: "expressions", title: "Algebraic Expressions", desc: "Combine numbers and variables." },
          { code: "simple_equations", title: "Simple Equations", desc: "One-step equations." },
          { code: "linear_equations", title: "Linear Equations", desc: "Two-step linear equations." },
        ],
        lessons: [
          ["Using Letters for Unknowns", "A variable stands for a number we do not know yet. In 2n, n is the number of notebooks.", "If each notebook costs n shillings, write the cost of 4 notebooks.", ["Use multiplication for repeated cost", "4 notebooks means 4 × n", "Expression: 4n shillings"], "4n"],
          ["Solving x + 5 = 12", "Undo addition by subtracting the same value from both sides.", "Solve x + 5 = 12.", ["Subtract 5 from both sides", "x + 5 - 5 = 12 - 5", "x = 7"], "x = 7"],
          ["Solving 3x = 18", "Undo multiplication by dividing both sides by the same number.", "Solve 3x = 18.", ["Divide both sides by 3", "3x ÷ 3 = 18 ÷ 3", "x = 6"], "x = 6"],
        ],
      },
      {
        code: "geometry",
        title: "Geometry Basics",
        desc: "Explore shapes, angles, and area in everyday Kenyan settings.",
        subtopics: [
          { code: "shapes", title: "Shapes", desc: "Identify 2D shapes and properties." },
          { code: "angles", title: "Angles", desc: "Measure and classify angles." },
          { code: "area_perimeter", title: "Area & Perimeter", desc: "Calculate around and inside shapes." },
        ],
        lessons: [
          ["Properties of Rectangles", "A rectangle has four right angles and opposite sides equal.", "A classroom door is a rectangle 2 m by 1 m. Name two equal sides.", ["Opposite sides are equal in a rectangle", "Two lengths are 2 m each", "Two widths are 1 m each"], "2 m and 1 m pairs"],
          ["Types of Angles", "Angles less than 90° are acute, exactly 90° are right, and greater than 90° are obtuse.", "Classify a 45° angle.", ["Compare 45° to 90°", "45° is less than 90°", "It is an acute angle"], "Acute angle"],
          ["Area of a Rectangle", "Area = length × width. Use consistent units such as cm or m.", "Find the area of a mat 3 m long and 2 m wide.", ["Use A = l × w", "A = 3 × 2", "Area = 6 m²"], "6 m²"],
        ],
      },
    ],
  },
  {
    code: "KCSE",
    topics: [
      {
        code: "algebra",
        title: "Algebra",
        desc: "Manipulate expressions and solve equations at secondary level.",
        subtopics: [
          { code: "linear_equations", title: "Linear Equations", desc: "Solve equations with one variable." },
          { code: "quadratic_expressions", title: "Quadratic Expressions", desc: "Expand and factor simple quadratics." },
          { code: "indices", title: "Indices", desc: "Apply laws of indices." },
        ],
        lessons: [
          ["Solving 2x - 4 = 10", "Isolate the variable using inverse operations in balance.", "Solve 2x - 4 = 10.", ["Add 4 to both sides: 2x = 14", "Divide both sides by 2", "x = 7"], "x = 7"],
          ["Expanding (x + 2)(x + 3)", "Use the distributive property or FOIL for binomials.", "Expand (x + 2)(x + 3).", ["x·x = x²", "x·3 + 2·x = 5x", "2·3 = 6, so x² + 5x + 6"], "x² + 5x + 6"],
          ["Law of Indices: a^m × a^n", "When bases match, add the powers.", "Simplify 2³ × 2².", ["Same base 2", "Add powers: 3 + 2 = 5", "Answer: 2⁵ = 32"], "2⁵ or 32"],
        ],
      },
      {
        code: "fractions",
        title: "Fractions",
        desc: "Work with rational numbers in exam-style problems.",
        subtopics: [
          { code: "simplifying", title: "Simplifying Fractions", desc: "Reduce to lowest terms." },
          { code: "operations", title: "Fraction Operations", desc: "All four operations with fractions." },
          { code: "word_problems", title: "Word Problems", desc: "Apply fractions in context." },
        ],
        lessons: [
          ["Simplifying 12/18", "Divide numerator and denominator by their HCF.", "Simplify 12/18.", ["HCF of 12 and 18 is 6", "12÷6 = 2 and 18÷6 = 3", "Simplest form: 2/3"], "2/3"],
          ["Dividing Fractions", "Multiply by the reciprocal of the divisor.", "Calculate 3/4 ÷ 2/5.", ["Keep 3/4, change ÷ to ×, flip 2/5 to 5/2", "3/4 × 5/2 = 15/8", "Answer: 15/8 or 1 7/8"], "15/8"],
          ["Fraction of an Amount", "Multiply the fraction by the whole amount.", "A school fund of KES 24,000 uses 5/8 for books. How much is that?", ["Multiply 5/8 × 24,000", "24,000 ÷ 8 = 3,000", "5 × 3,000 = KES 15,000"], "KES 15,000"],
        ],
      },
      {
        code: "geometry",
        title: "Geometry Basics",
        desc: "Coordinate geometry, circles, and transformations.",
        subtopics: [
          { code: "coordinate_geometry", title: "Coordinate Geometry", desc: "Plot points and find distance." },
          { code: "circles", title: "Circles", desc: "Circumference and area of circles." },
          { code: "transformations", title: "Transformations", desc: "Reflection, rotation, and translation." },
        ],
        lessons: [
          ["Distance Between Two Points", "Use distance formula or Pythagoras on coordinate grid.", "Find distance between (0,0) and (3,4).", ["Horizontal change = 3, vertical = 4", "Use 3² + 4² = 25", "Distance = √25 = 5 units"], "5 units"],
          ["Circumference of a Circle", "C = 2πr or C = πd where r is radius.", "Find circumference when r = 7 cm (use π = 22/7).", ["C = 2 × 22/7 × 7", "The 7 cancels", "C = 44 cm"], "44 cm"],
          ["Translation on a Grid", "A translation moves every point by the same vector.", "Translate point (2,3) by vector (4,-1).", ["Add 4 to x-coordinate: 2 + 4 = 6", "Add -1 to y-coordinate: 3 + (-1) = 2", "Image point: (6,2)"], "(6,2)"],
        ],
      },
      {
        code: "trigonometry",
        title: "Trigonometry",
        desc: "Work with sin, cos, tan and apply them to triangles and heights.",
        minGradeSortOrder: 2,
        subtopics: [
          { code: "ratios", title: "Sin, Cos & Tan", desc: "Trigonometric ratios in right-angled triangles." },
          { code: "identities", title: "Identities", desc: "Key identities and special angles." },
          { code: "applications", title: "Applications", desc: "Heights, distances, and bearings." },
        ],
        lessons: [
          ["Sine Ratio in Right Triangles", "In a right triangle, sin θ = opposite ÷ hypotenuse.", "Find sin θ when opposite = 3 and hypotenuse = 5.", ["Write sin θ = 3/5", "3 and 5 have no common factor", "sin θ = 3/5"], "3/5"],
          ["Cosine and Tangent Ratios", "cos θ = adjacent ÷ hypotenuse and tan θ = opposite ÷ adjacent.", "A triangle has adjacent 4 and hypotenuse 5. Find cos θ.", ["cos θ = 4/5", "Check the ratio uses adjacent over hypotenuse", "cos θ = 4/5"], "4/5"],
          ["Angle of Elevation", "Use tan to find heights when you know distance and angle.", "From 20 m away, the angle of elevation to a flagpole top is 45°. Find the height.", ["Use tan 45° = height ÷ 20", "tan 45° = 1", "Height = 20 m"], "20 m"],
        ],
      },
      {
        code: "statistics",
        title: "Statistics",
        desc: "Summarise data, calculate probability, and read charts.",
        minGradeSortOrder: 3,
        subtopics: [
          { code: "central_tendency", title: "Mean, Median & Mode", desc: "Describe data with one value." },
          { code: "probability", title: "Probability", desc: "Chance of events happening." },
          { code: "data_representation", title: "Data Representation", desc: "Tables, bar charts, and pie charts." },
        ],
        lessons: [
          ["Calculating the Mean", "Mean = sum of values ÷ number of values.", "Find the mean of 4, 6, and 8.", ["Sum = 4 + 6 + 8 = 18", "There are 3 values", "Mean = 18 ÷ 3 = 6"], "6"],
          ["Median and Mode", "Median is the middle value; mode is the most frequent value.", "Find the median of 2, 5, 7, 9, 11.", ["Order the values: 2, 5, 7, 9, 11", "The middle value is 7", "Median = 7"], "7"],
          ["Reading a Bar Chart", "Compare categories using bar heights on a chart.", "A bar chart shows sales: Mon 5, Tue 8, Wed 6. Which day had highest sales?", ["Compare bar heights", "Tuesday's bar is tallest at 8", "Tuesday had the highest sales"], "Tuesday"],
        ],
      },
    ],
  },
];

const curriculumTopicCodes = {
  CBC: ["fractions", "algebra", "geometry"],
  KCSE: ["algebra", "fractions", "geometry", "trigonometry", "statistics"],
};

function esc(value) {
  return value.replace(/'/g, "''");
}

function lessonJson(title, intro, exampleTitle, steps, answer) {
  return JSON.stringify({
    blocks: [
      { type: "heading", content: title },
      { type: "paragraph", content: intro },
      { type: "example", title: exampleTitle, steps, answer },
      { type: "tip", content: "Write each step clearly before moving to the next one." },
    ],
    shortQuiz: {
      questions: [
        {
          questionText: "Which step comes first in this lesson?",
          options: ["Guess the answer", "Read the problem carefully", "Skip working"],
          correctAnswer: "Read the problem carefully",
        },
      ],
    },
  }).replace(/'/g, "''");
}

const practiceTemplates = {
  fractions: [
    ["What is 1/4 + 1/4?", '["1/8","1/2","2/4","3/4"]', '"1/2"', "Add numerators when denominators match."],
    ["Simplify 6/9.", '["2/3","3/2","6/9","1/3"]', '"2/3"', "Divide numerator and denominator by 3."],
    ["Which fraction is equivalent to 3/5?", '["6/10","3/10","5/3","9/20"]', '"6/10"', "Multiply top and bottom by 2."],
  ],
  algebra: [
    ["Solve x + 3 = 9.", '["x=6","x=12","x=3","x=9"]', '"x=6"', "Subtract 3 from both sides."],
    ["Evaluate 2x when x = 5.", '["7","10","25","2/5"]', '"10"', "Substitute x = 5 into 2x."],
    ['Expand 2(x + 4).', '["2x+4","2x+8","x+8","4x+2"]', '"2x+8"', "Multiply 2 by each term in the bracket."],
  ],
  geometry: [
    ["How many sides does a triangle have?", '["2","3","4","5"]', '"3"', "Tri means three."],
    ["A right angle measures how many degrees?", '["45","90","180","360"]', '"90"', "A right angle is exactly 90°."],
    ["Area of a 4 cm by 5 cm rectangle?", '["9 cm²","18 cm²","20 cm²","25 cm²"]', '"20 cm²"', "Area = length × width."],
  ],
  trigonometry: [
    ["What is sin 30°?", '["0.5","1","0.866","0.707"]', '"0.5"', "sin 30° is a special angle value."],
    ["What is cos 60°?", '["0.5","0.866","1","0"]', '"0.5"', "cos 60° equals 0.5."],
    ["What is tan 45°?", '["0","0.5","1","2"]', '"1"', "tan 45° equals 1."],
  ],
  statistics: [
    ["What is the mean of 2, 4, and 6?", '["3","4","5","6"]', '"4"', "Sum is 12; divide by 3."],
    ["What is the median of 1, 3, and 9?", '["1","3","5","9"]', '"3"', "The middle value is 3."],
    ["Probability of heads on a fair coin?", '["0.25","0.5","0.75","1"]', '"0.5"', "Two equally likely outcomes."],
  ],
};

let sql = "-- Mathematics curriculum seed (CBC + KCSE)\n-- Nexus V1 Wave 2\n\n";

for (const curr of curricula) {
  sql += `-- ${curr.code} topics\n`;
  for (let topicIndex = 0; topicIndex < curr.topics.length; topicIndex += 1) {
    const topic = curr.topics[topicIndex];
    sql += `INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, '${topic.code}', '${esc(topic.title)}', '${esc(topic.desc)}', ${topicIndex + 1}, ${topic.minGradeSortOrder ?? 1}
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = 'mathematics'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

`;

    for (let subtopicIndex = 0; subtopicIndex < topic.subtopics.length; subtopicIndex += 1) {
      const subtopic = topic.subtopics[subtopicIndex];
      sql += `INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, '${subtopic.code}', '${esc(subtopic.title)}', '${esc(subtopic.desc)}', ${subtopicIndex + 1}
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = 'mathematics' AND t.code = '${topic.code}'
ON CONFLICT (topic_id, code) DO NOTHING;

`;

      const lesson = topic.lessons[subtopicIndex];
      const content = lessonJson(lesson[0], lesson[1], lesson[2], lesson[3], lesson[4]);
      sql += `INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, '${esc(lesson[0])}', '${content}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = 'mathematics' AND t.code = '${topic.code}' AND st.code = '${subtopic.code}'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = '${esc(lesson[0])}'
);

`;
    }
  }
}

sql += "-- Practice questions (21 per topic)\n";

for (const curr of curricula) {
  const topicCodes = curriculumTopicCodes[curr.code];
  for (const topicCode of topicCodes) {
    for (let questionNumber = 1; questionNumber <= 21; questionNumber += 1) {
      const difficulty =
        questionNumber <= 7 ? "easy" : questionNumber <= 14 ? "medium" : "hard";
      const templates = practiceTemplates[topicCode];
      const template = templates[(questionNumber - 1) % templates.length];
      const questionText = `${curr.code} ${topicCode} practice ${questionNumber}: ${template[0]}`;

      sql += `INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, '${esc(questionText)}', 'multiple_choice', '${template[1]}'::jsonb, '${template[2]}'::jsonb, '${difficulty}', '${esc(template[3])}'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = 'mathematics' AND t.code = '${topicCode}'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = '${esc(questionText)}'
);

`;
    }
  }
}

for (const curr of curricula) {
  sql += `INSERT INTO public.diagnostic_assessments (curriculum_id, subject_id, title, question_count)
SELECT c.id, s.id, '${curr.code} Mathematics Diagnostic', 20
FROM public.curricula c
JOIN public.subjects s ON s.curriculum_id = c.id AND s.code = 'mathematics'
WHERE c.code = '${curr.code}'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_assessments da
  WHERE da.curriculum_id = c.id AND da.subject_id = s.id
);

`;

  const topicCodes = curriculumTopicCodes[curr.code];
  for (let questionNumber = 1; questionNumber <= 20; questionNumber += 1) {
    const topicCode = topicCodes[(questionNumber - 1) % topicCodes.length];
    const difficulty =
      questionNumber <= 8 ? "easy" : questionNumber <= 16 ? "medium" : "hard";
    const templates = practiceTemplates[topicCode];
    const template = templates[(questionNumber - 1) % templates.length];
    const questionText = `${curr.code} diagnostic Q${questionNumber}: ${template[0]}`;

    sql += `INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, '${esc(questionText)}', 'multiple_choice', '${template[1]}'::jsonb, '${template[2]}'::jsonb, '${difficulty}', ${questionNumber}
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = '${topicCode}'
WHERE c.code = '${curr.code}' AND s.code = 'mathematics' AND da.title = '${curr.code} Mathematics Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = ${questionNumber}
);

`;
  }
}

fs.mkdirSync("supabase/seed", { recursive: true });
fs.writeFileSync("supabase/seed/curriculum_math.sql", sql);
console.log(`Wrote supabase/seed/curriculum_math.sql (${sql.length} bytes)`);

function buildSubjectSeed({
  subjectCode,
  header,
  curricula: subjectCurricula,
  curriculumTopicCodes: topicCodesByCurriculum,
  practiceTemplates: templates,
  includeDiagnostic = false,
  diagnosticLabel,
}) {
  let subjectSql = `${header}\n\n`;

  for (const curr of subjectCurricula) {
    subjectSql += `-- ${curr.code} topics\n`;
    for (let topicIndex = 0; topicIndex < curr.topics.length; topicIndex += 1) {
      const topic = curr.topics[topicIndex];
      subjectSql += `INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)
SELECT s.id, '${topic.code}', '${esc(topic.title)}', '${esc(topic.desc)}', ${topicIndex + 1}, ${topic.minGradeSortOrder ?? 1}
FROM public.subjects s
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = '${subjectCode}'
ON CONFLICT (subject_id, code) DO UPDATE
SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,
    sort_order = EXCLUDED.sort_order,
    title = EXCLUDED.title,
    description = EXCLUDED.description;

`;

      for (let subtopicIndex = 0; subtopicIndex < topic.subtopics.length; subtopicIndex += 1) {
        const subtopic = topic.subtopics[subtopicIndex];
        subjectSql += `INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)
SELECT t.id, '${subtopic.code}', '${esc(subtopic.title)}', '${esc(subtopic.desc)}', ${subtopicIndex + 1}
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = '${subjectCode}' AND t.code = '${topic.code}'
ON CONFLICT (topic_id, code) DO NOTHING;

`;

        const lesson = topic.lessons[subtopicIndex];
        const content = lessonJson(lesson[0], lesson[1], lesson[2], lesson[3], lesson[4]);
        subjectSql += `INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)
SELECT st.id, '${esc(lesson[0])}', '${content}'::jsonb, 12, 1
FROM public.subtopics st
JOIN public.topics t ON t.id = st.topic_id
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = '${subjectCode}' AND t.code = '${topic.code}' AND st.code = '${subtopic.code}'
AND NOT EXISTS (
  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = '${esc(lesson[0])}'
);

`;
      }
    }
  }

  subjectSql += "-- Practice questions (21 per topic)\n";

  for (const curr of subjectCurricula) {
    const topicCodes = topicCodesByCurriculum[curr.code];
    for (const topicCode of topicCodes) {
      for (let questionNumber = 1; questionNumber <= 21; questionNumber += 1) {
        const difficulty =
          questionNumber <= 7 ? "easy" : questionNumber <= 14 ? "medium" : "hard";
        const template = templates[topicCode][(questionNumber - 1) % templates[topicCode].length];
        const questionText = `${curr.code} ${topicCode} practice ${questionNumber}: ${template[0]}`;

        subjectSql += `INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)
SELECT t.id, '${esc(questionText)}', 'multiple_choice', '${template[1]}'::jsonb, '${template[2]}'::jsonb, '${difficulty}', '${esc(template[3])}'
FROM public.topics t
JOIN public.subjects s ON s.id = t.subject_id
JOIN public.curricula c ON c.id = s.curriculum_id
WHERE c.code = '${curr.code}' AND s.code = '${subjectCode}' AND t.code = '${topicCode}'
AND NOT EXISTS (
  SELECT 1 FROM public.practice_questions pq
  WHERE pq.topic_id = t.id AND pq.question_text = '${esc(questionText)}'
);

`;
      }
    }
  }

  if (includeDiagnostic) {
    for (const curr of subjectCurricula) {
      subjectSql += `INSERT INTO public.diagnostic_assessments (curriculum_id, subject_id, title, question_count)
SELECT c.id, s.id, '${curr.code} ${diagnosticLabel} Diagnostic', 20
FROM public.curricula c
JOIN public.subjects s ON s.curriculum_id = c.id AND s.code = '${subjectCode}'
WHERE c.code = '${curr.code}'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_assessments da
  WHERE da.curriculum_id = c.id AND da.subject_id = s.id
);

`;

      const topicCodes = topicCodesByCurriculum[curr.code];
      for (let questionNumber = 1; questionNumber <= 20; questionNumber += 1) {
        const topicCode = topicCodes[(questionNumber - 1) % topicCodes.length];
        const difficulty =
          questionNumber <= 8 ? "easy" : questionNumber <= 16 ? "medium" : "hard";
        const template = templates[topicCode][(questionNumber - 1) % templates[topicCode].length];
        const questionText = `${curr.code} diagnostic Q${questionNumber}: ${template[0]}`;

        subjectSql += `INSERT INTO public.diagnostic_questions (diagnostic_assessment_id, topic_id, question_text, question_type, options, correct_answer, difficulty, sort_order)
SELECT da.id, t.id, '${esc(questionText)}', 'multiple_choice', '${template[1]}'::jsonb, '${template[2]}'::jsonb, '${difficulty}', ${questionNumber}
FROM public.diagnostic_assessments da
JOIN public.curricula c ON c.id = da.curriculum_id
JOIN public.subjects s ON s.id = da.subject_id
JOIN public.topics t ON t.subject_id = s.id AND t.code = '${topicCode}'
WHERE c.code = '${curr.code}' AND s.code = '${subjectCode}' AND da.title = '${curr.code} ${diagnosticLabel} Diagnostic'
AND NOT EXISTS (
  SELECT 1 FROM public.diagnostic_questions dq
  WHERE dq.diagnostic_assessment_id = da.id AND dq.sort_order = ${questionNumber}
);

`;
      }
    }
  }

  return subjectSql;
}

const scienceCurricula = [
  {
    code: "CBC",
    topics: [
      {
        code: "living_things",
        title: "Living Things",
        desc: "Classify organisms and explore life processes in Kenyan ecosystems.",
        subtopics: [
          { code: "classification", title: "Classification", desc: "Group living things by shared features." },
          { code: "habitats", title: "Habitats", desc: "Where organisms live and why." },
          { code: "life_processes", title: "Life Processes", desc: "Nutrition, growth, and reproduction." },
        ],
        lessons: [
          ["Vertebrates and Invertebrates", "Animals with backbones are vertebrates; those without are invertebrates.", "A frog has a backbone. Is it a vertebrate or invertebrate?", ["Check if it has a backbone", "Frogs have a spine", "A frog is a vertebrate"], "Vertebrate"],
          ["Savanna Habitat", "A habitat provides food, water, and shelter for organisms.", "Why do zebras live on the savanna?", ["Savanna has grass for food", "Open space helps spot predators", "Water sources are available seasonally"], "Grass, safety, and water"],
          ["Photosynthesis Basics", "Green plants make food using sunlight, water, and carbon dioxide.", "What gas do plants release during photosynthesis?", ["Plants use CO₂ and release O₂", "Oxygen supports animal life", "The gas is oxygen"], "Oxygen"],
        ],
      },
      {
        code: "matter_energy",
        title: "Matter & Energy",
        desc: "Explore states of matter, simple machines, and energy in daily life.",
        subtopics: [
          { code: "states_of_matter", title: "States of Matter", desc: "Solid, liquid, and gas." },
          { code: "simple_machines", title: "Simple Machines", desc: "Levers, pulleys, and inclined planes." },
          { code: "energy_forms", title: "Energy Forms", desc: "Heat, light, and sound energy." },
        ],
        lessons: [
          ["States of Water", "Water can be ice (solid), liquid water, or steam (gas).", "What state is water at 100°C?", ["At boiling point water becomes gas", "Steam is water vapour", "The state is gas"], "Gas"],
          ["Levers at Home", "A lever helps lift loads with less effort using a fulcrum.", "A see-saw is which type of simple machine?", ["It pivots around a central point", "That pivot is a fulcrum", "A see-saw is a lever"], "Lever"],
          ["Sound Energy", "Sound travels as vibrations through air and other materials.", "How does a drum produce sound?", ["Hitting the drum makes it vibrate", "Vibrations move through air", "We hear the vibrations as sound"], "Vibration"],
        ],
      },
      {
        code: "earth_environment",
        title: "Earth & Environment",
        desc: "Study weather, soil, and conservation in Kenya.",
        subtopics: [
          { code: "weather", title: "Weather", desc: "Measure and describe daily weather." },
          { code: "soil", title: "Soil", desc: "Types of soil and their uses." },
          { code: "conservation", title: "Conservation", desc: "Protect natural resources." },
        ],
        lessons: [
          ["Reading a Thermometer", "Temperature tells how hot or cold the air is.", "If a thermometer reads 30°C, is it warm or cold?", ["30°C is above room temperature", "Kenyan afternoons can reach 30°C", "It is warm"], "Warm"],
          ["Sandy vs Clay Soil", "Sandy soil drains quickly; clay holds more water.", "Which soil type drains water faster?", ["Sand has larger gaps between particles", "Water passes through sand quickly", "Sandy soil drains faster"], "Sandy soil"],
          ["Tree Planting", "Trees reduce soil erosion and improve air quality.", "Name one benefit of planting trees in your community.", ["Tree roots hold soil", "Leaves provide shade and oxygen", "Any valid conservation benefit"], "Reduces erosion"],
        ],
      },
    ],
  },
  {
    code: "KCSE",
    topics: [
      {
        code: "biology_basics",
        title: "Biology Basics",
        desc: "Cells, nutrition, and respiration for secondary science.",
        subtopics: [
          { code: "cells", title: "Cells", desc: "Structure and function of cells." },
          { code: "nutrition", title: "Nutrition", desc: "Balanced diet and digestion." },
          { code: "respiration", title: "Respiration", desc: "How organisms release energy from food." },
        ],
        lessons: [
          ["Plant and Animal Cells", "Cells are the basic units of life with specialised parts.", "Name the part that controls cell activities.", ["The nucleus directs cell functions", "It is found in both plant and animal cells", "The nucleus controls activities"], "Nucleus"],
          ["Balanced Diet", "A balanced diet includes carbohydrates, proteins, fats, vitamins, and minerals.", "Which nutrient mainly builds body tissues?", ["Proteins repair and build tissues", "Carbohydrates mainly give energy", "Proteins build tissues"], "Proteins"],
          ["Aerobic Respiration", "Cells release energy from glucose using oxygen.", "What are the products of aerobic respiration?", ["Glucose + oxygen → CO₂ + water + energy", "Carbon dioxide and water are released", "CO₂, water, and energy"], "CO₂, water, energy"],
        ],
      },
      {
        code: "chemistry_basics",
        title: "Chemistry Basics",
        desc: "Elements, acids, bases, and simple reactions.",
        subtopics: [
          { code: "elements", title: "Elements", desc: "Symbols and the periodic table." },
          { code: "acids_bases", title: "Acids & Bases", desc: "Properties and indicators." },
          { code: "reactions", title: "Chemical Reactions", desc: "Signs that a reaction occurred." },
        ],
        lessons: [
          ["Element Symbols", "Each element has a chemical symbol such as O for oxygen.", "What is the symbol for sodium?", ["Sodium's symbol is Na", "It comes from the Latin name natrium", "Na"], "Na"],
          ["Acids and Bases", "Acids taste sour; bases feel slippery and taste bitter.", "What colour does litmus turn in an acid?", ["Acids turn blue litmus red", "Bases turn red litmus blue", "Acids turn litmus red"], "Red"],
          ["Signs of a Reaction", "A chemical reaction may produce gas, colour change, or heat.", "Rusting iron is an example of what?", ["Iron reacts with oxygen and water", "A new substance forms", "A chemical reaction"], "Chemical reaction"],
        ],
      },
      {
        code: "physics_basics",
        title: "Physics Basics",
        desc: "Forces, electricity, and waves.",
        subtopics: [
          { code: "forces", title: "Forces", desc: "Push, pull, and friction." },
          { code: "electricity", title: "Electricity", desc: "Current, voltage, and circuits." },
          { code: "waves", title: "Waves", desc: "Properties of waves and sound." },
        ],
        lessons: [
          ["Balanced Forces", "When forces are equal and opposite, an object stays still or moves steadily.", "A book on a table stays still because forces are what?", ["Weight pulls down, table pushes up", "Forces are equal and opposite", "Balanced"], "Balanced"],
          ["Series Circuits", "In a series circuit, current has one path to follow.", "If one bulb breaks in series, what happens?", ["Current path is broken", "Other bulbs go off", "All bulbs go off"], "All bulbs go off"],
          ["Wave Properties", "Waves have amplitude, wavelength, and frequency.", "What is the height of a wave from rest position called?", ["Amplitude measures wave height", "Wavelength is distance between peaks", "Amplitude"], "Amplitude"],
        ],
      },
    ],
  },
];

const scienceTopicCodes = {
  CBC: ["living_things", "matter_energy", "earth_environment"],
  KCSE: ["biology_basics", "chemistry_basics", "physics_basics"],
};

const sciencePracticeTemplates = {
  living_things: [
    ["Which group includes animals with backbones?", '["Invertebrates","Vertebrates","Fungi","Bacteria"]', '"Vertebrates"', "Vertebrates have a backbone."],
    ["Plants make food through which process?", '["Respiration","Photosynthesis","Digestion","Evaporation"]', '"Photosynthesis"', "Plants use sunlight to make food."],
    ["A habitat provides food, water, and what else?", '["Shelter","Money","Plastic","Electricity"]', '"Shelter"', "Organisms need shelter in a habitat."],
  ],
  matter_energy: [
    ["Ice is water in which state?", '["Solid","Liquid","Gas","Plasma"]', '"Solid"', "Ice is solid water."],
    ["A see-saw is an example of a what?", '["Pulley","Lever","Wedge","Screw"]', '"Lever"', "A see-saw pivots on a fulcrum."],
    ["Sound is produced by what?", '["Light","Vibrations","Gravity","Magnetism"]', '"Vibrations"', "Vibrations travel as sound waves."],
  ],
  earth_environment: [
    ["Which soil drains water fastest?", '["Clay","Sandy","Loam","Peat"]', '"Sandy"', "Sand has large spaces between particles."],
    ["Planting trees helps reduce what?", '["Rainfall","Soil erosion","Gravity","Sunlight"]', '"Soil erosion"', "Tree roots hold soil in place."],
    ["A thermometer measures what?", '["Wind speed","Temperature","Humidity","Pressure"]', '"Temperature"', "Thermometers measure heat level."],
  ],
  biology_basics: [
    ["Which organelle controls the cell?", '["Nucleus","Cell wall","Chloroplast","Ribosome"]', '"Nucleus"', "The nucleus controls cell activities."],
    ["Which nutrient builds body tissues?", '["Carbohydrates","Proteins","Fats","Water"]', '"Proteins"', "Proteins repair and build tissues."],
    ["Aerobic respiration needs which gas?", '["Nitrogen","Oxygen","Helium","Carbon monoxide"]', '"Oxygen"', "Cells use oxygen to release energy."],
  ],
  chemistry_basics: [
    ["What is the symbol for oxygen?", '["O","Ox","Og","Om"]', '"O"', "O is the symbol for oxygen."],
    ["Acids turn blue litmus what colour?", '["Green","Red","Purple","Yellow"]', '"Red"', "Acids turn blue litmus red."],
    ["Rusting is an example of a what?", '["Physical change","Chemical reaction","State change","Mixture"]', '"Chemical reaction"', "A new substance forms when iron rusts."],
  ],
  physics_basics: [
    ["Balanced forces mean an object is what?", '["Accelerating","Stationary or steady","Spinning","Floating"]', '"Stationary or steady"', "Equal forces cancel out."],
    ["In a series circuit, one broken bulb causes what?", '["Brighter bulbs","All bulbs off","No change","Only one off"]', '"All bulbs off"', "Series has one current path."],
    ["Wave height from rest is called what?", '["Frequency","Amplitude","Wavelength","Speed"]', '"Amplitude"', "Amplitude is wave height."],
  ],
};

const englishCurricula = [
  {
    code: "CBC",
    topics: [
      {
        code: "reading_comprehension",
        title: "Reading Comprehension",
        desc: "Find main ideas, make inferences, and learn vocabulary in context.",
        subtopics: [
          { code: "main_idea", title: "Main Idea", desc: "Identify what a passage is mostly about." },
          { code: "inference", title: "Inference", desc: "Read between the lines." },
          { code: "vocabulary", title: "Vocabulary in Context", desc: "Use clues to learn new words." },
        ],
        lessons: [
          ["Finding the Main Idea", "The main idea is the most important point the writer makes.", "A paragraph describes how bees pollinate crops. What is the main idea?", ["Ask what the paragraph is mostly about", "It focuses on bees helping crops", "Bees pollinate crops"], "Bees pollinate crops"],
          ["Making an Inference", "An inference uses evidence plus what you already know.", "Musa packed an umbrella and wore boots. What can you infer about the weather?", ["Umbrella and boots suggest rain", "He expects wet conditions", "Rainy weather is likely"], "Rain is likely"],
          ["Context Clues", "Nearby words can reveal the meaning of an unfamiliar word.", "The arid land had little rain. What does arid mean?", ["Little rain suggests dry conditions", "Arid means very dry", "Dry"], "Dry"],
        ],
      },
      {
        code: "grammar",
        title: "Grammar",
        desc: "Master parts of speech, sentence structure, and tenses.",
        subtopics: [
          { code: "parts_of_speech", title: "Parts of Speech", desc: "Nouns, verbs, adjectives, and more." },
          { code: "sentences", title: "Sentence Structure", desc: "Subjects, predicates, and clauses." },
          { code: "tenses", title: "Tenses", desc: "Past, present, and future." },
        ],
        lessons: [
          ["Nouns and Verbs", "A noun names a person, place, or thing. A verb shows action or state.", "In 'Amina runs daily', which word is the verb?", ["Find the action word", "Runs shows action", "runs"], "runs"],
          ["Complete Sentences", "A complete sentence has a subject and a predicate.", "Which is a complete sentence?", ["Under the tree", "The learners study", "Because it rained"], "The learners study"],
          ["Simple Past Tense", "Past tense describes actions that already happened.", "Change 'She walks' to past tense.", ["Walks becomes walked", "Add -ed for regular verbs", "She walked"], "She walked"],
        ],
      },
      {
        code: "writing_skills",
        title: "Writing Skills",
        desc: "Build paragraphs, use punctuation, and write summaries — not full essays for students.",
        subtopics: [
          { code: "paragraphs", title: "Paragraphs", desc: "Topic sentence and supporting details." },
          { code: "punctuation", title: "Punctuation", desc: "Commas, full stops, and question marks." },
          { code: "summaries", title: "Summaries", desc: "Shorten a passage in your own words." },
        ],
        lessons: [
          ["Topic Sentences", "A paragraph begins with a sentence that states the main point.", "Write a topic sentence for a paragraph about school gardens.", ["State the main idea clearly", "School gardens help learners grow food", "Our school garden teaches us to grow vegetables"], "School gardens teach learners to grow food"],
          ["Using Commas in Lists", "Use commas to separate items in a list.", "Punctuate: mangoes bananas oranges", ["List items need commas", "mangoes, bananas, oranges", "mangoes, bananas, and oranges"], "mangoes, bananas, oranges"],
          ["Writing a Summary", "A summary gives the key points in fewer words without copying.", "Summarise: 'The team trained every evening and won the county cup.'", ["Keep only key facts", "Training led to winning", "The team trained and won the county cup"], "The team trained and won the county cup"],
        ],
      },
    ],
  },
  {
    code: "KCSE",
    topics: [
      {
        code: "reading_comprehension",
        title: "Reading Comprehension",
        desc: "Analyse passages for KCSE-style comprehension.",
        subtopics: [
          { code: "main_idea", title: "Main Idea", desc: "Central argument or theme." },
          { code: "inference", title: "Inference", desc: "Implied meaning and tone." },
          { code: "vocabulary", title: "Vocabulary in Context", desc: "Advanced word meaning." },
        ],
        lessons: [
          ["Identifying Theme", "Theme is the underlying message of a text.", "A story shows honesty winning over cheating. What is the theme?", ["Ask what lesson the story teaches", "Honesty is rewarded", "Honesty is important"], "Honesty is important"],
          ["Tone and Mood", "Tone is the writer's attitude; mood is the feeling created.", "Words like 'gloomy' and 'silent' create what mood?", ["These words feel sad and heavy", "The mood is sombre", "Somber or sad mood"], "Somber mood"],
          ["Figurative Language", "Metaphors compare two things without using like or as.", "'Time is a thief' is an example of what?", ["It compares time to a thief directly", "No like/as is used", "Metaphor"], "Metaphor"],
        ],
      },
      {
        code: "grammar",
        title: "Grammar",
        desc: "Advanced sentence analysis for secondary English.",
        subtopics: [
          { code: "parts_of_speech", title: "Parts of Speech", desc: "Function words in complex sentences." },
          { code: "sentences", title: "Sentence Structure", desc: "Simple, compound, and complex sentences." },
          { code: "tenses", title: "Tenses", desc: "Perfect and continuous forms." },
        ],
        lessons: [
          ["Adjectives and Adverbs", "Adjectives describe nouns; adverbs modify verbs.", "In 'She sang beautifully', what part of speech is beautifully?", ["It describes how she sang", "It modifies the verb sang", "Adverb"], "Adverb"],
          ["Compound Sentences", "A compound sentence joins two independent clauses.", "Join: 'I studied. I passed.'", ["Use a conjunction", "I studied, and I passed", "I studied and passed"], "I studied, and I passed"],
          ["Present Perfect Tense", "Present perfect links past action to present result.", "Form present perfect of 'finish' for 'they'.", ["Use have/has + past participle", "They have finished", "They have finished"], "They have finished"],
        ],
      },
      {
        code: "writing_skills",
        title: "Writing Skills",
        desc: "Plan and edit writing — Nex guides structure, not ghostwritten essays.",
        subtopics: [
          { code: "paragraphs", title: "Paragraphs", desc: "Cohesion and transitions." },
          { code: "punctuation", title: "Punctuation", desc: "Apostrophes and speech marks." },
          { code: "summaries", title: "Summaries", desc: "Precis and note-making." },
        ],
        lessons: [
          ["Linking Ideas", "Transition words connect paragraphs smoothly.", "Choose a linker: However, Therefore, Meanwhile", ["However shows contrast", "Use when ideas oppose", "However"], "However"],
          ["Apostrophes for Possession", "Use apostrophe + s for singular possession.", "Rewrite: the book of John", ["John owns the book", "John's book", "John's book"], "John's book"],
          ["Precis Writing", "A precis is a short, accurate summary in your own words.", "What should you avoid in a precis?", ["Do not copy long phrases", "Avoid unnecessary detail", "Copying the whole passage"], "Copying the whole passage"],
        ],
      },
    ],
  },
];

const englishTopicCodes = {
  CBC: ["reading_comprehension", "grammar", "writing_skills"],
  KCSE: ["reading_comprehension", "grammar", "writing_skills"],
};

const englishPracticeTemplates = {
  reading_comprehension: [
    ["What is the main idea of a paragraph?", '["Smallest detail","Most important point","A random fact","The title only"]', '"Most important point"', "Main idea = central point."],
    ["An inference uses evidence and what else?", '["Luck","Prior knowledge","Pictures only","Nothing else"]', '"Prior knowledge"', "You combine clues with what you know."],
    ["Context clues help you find what?", '["Page number","Word meaning","Author age","Book price"]', '"Word meaning"', "Nearby words explain new vocabulary."],
  ],
  grammar: [
    ["Which word is usually a verb?", '["Table","Quickly","Jump","Blue"]', '"Jump"', "Verbs show action or state."],
    ["A complete sentence needs a subject and what?", '["Predicate","Picture","Chapter","Index"]', '"Predicate"', "Subject + predicate = complete sentence."],
    ["Past tense of walk is what?", '["Walks","Walking","Walked","Will walk"]', '"Walked"', "Regular past tense adds -ed."],
  ],
  writing_skills: [
    ["A topic sentence states the what?", '["Author birthday","Main point","Page count","Font size"]', '"Main point"', "Topic sentence = main point."],
    ["Commas separate items in a what?", '["List","Title","Cover","Spine"]', '"List"', "Use commas between list items."],
    ["A summary should be shorter than the what?", '["Original","Dictionary","Cover","Index"]', '"Original"', "Summaries are shorter than the source."],
  ],
};

const scienceSql = buildSubjectSeed({
  subjectCode: "science",
  header: "-- Science curriculum seed (CBC + KCSE)\n-- Nexus V2 Tier 1 Phase 2.4",
  curricula: scienceCurricula,
  curriculumTopicCodes: scienceTopicCodes,
  practiceTemplates: sciencePracticeTemplates,
});

const englishSql = buildSubjectSeed({
  subjectCode: "english",
  header: "-- English curriculum seed (CBC + KCSE)\n-- Nexus V2 Tier 1 Phase 2.4",
  curricula: englishCurricula,
  curriculumTopicCodes: englishTopicCodes,
  practiceTemplates: englishPracticeTemplates,
});

fs.writeFileSync("supabase/seed/curriculum_science.sql", scienceSql);
fs.writeFileSync("supabase/seed/curriculum_english.sql", englishSql);
console.log(`Wrote supabase/seed/curriculum_science.sql (${scienceSql.length} bytes)`);
console.log(`Wrote supabase/seed/curriculum_english.sql (${englishSql.length} bytes)`);
