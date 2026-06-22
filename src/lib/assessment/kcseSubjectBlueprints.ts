export type KcseSubjectGroup =
  | "core"
  | "sciences"
  | "humanities"
  | "applied_elective";

export type KcseGradingMode = "exact" | "keyword" | "structured" | "rubric_band";

export type KcseSubjectId =
  | "mathematics"
  | "english"
  | "kiswahili"
  | "biology"
  | "chemistry"
  | "physics"
  | "history_government"
  | "geography"
  | "cre"
  | "ire"
  | "business_studies"
  | "agriculture"
  | "computer_studies";

export type KcsePaperFormat =
  | "structured_questions"
  | "objective_and_structured"
  | "essay_and_comprehension"
  | "oral_and_listening"
  | "practical_tasks"
  | "map_and_fieldwork"
  | "case_study";

export interface KcseObservedMarkAllocation {
  marks: number;
  observedCount: number;
}

export interface KcseObservedTopicSignal {
  tag: string;
  observedCount: number;
}

export interface KcsePaperCalibration {
  calibratedFrom: string[];
  evidenceType: "metadata_only";
  extractionStatus: "machine_readable" | "needs_ocr";
  commandVerbs: string[];
  markAllocation: KcseObservedMarkAllocation[];
  topicSignals: KcseObservedTopicSignal[];
  contentPolicy: "do_not_copy_or_redistribute_source_questions";
  notes: string[];
}

export interface KcsePaperStructure {
  paperNumber: number;
  title: string;
  format: KcsePaperFormat;
  marks: number;
  durationMinutes: number;
  sectionLabels: string[];
  calibration?: KcsePaperCalibration;
}

export interface KcseSubjectBlueprint {
  id: KcseSubjectId;
  displayName: string;
  curriculum: "KCSE";
  group: KcseSubjectGroup;
  aliases: string[];
  gradingMode: KcseGradingMode;
  defaultDurationMinutes: number;
  paperStructures: KcsePaperStructure[];
  patternTags: string[];
  sourcePolicy: "original_metadata_only";
}

function paper(
  paperNumber: number,
  title: string,
  format: KcsePaperFormat,
  marks: number,
  durationMinutes: number,
  sectionLabels: string[],
  calibration?: KcsePaperCalibration,
): KcsePaperStructure {
  return {
    paperNumber,
    title,
    format,
    marks,
    durationMinutes,
    sectionLabels,
    calibration,
  };
}

const sourceQuestionPolicy = "do_not_copy_or_redistribute_source_questions";

const mathPaper1Calibration: KcsePaperCalibration = {
  calibratedFrom: ["2024 KCSE Mathematics Paper 1"],
  evidenceType: "metadata_only",
  extractionStatus: "machine_readable",
  commandVerbs: [
    "determine",
    "calculate",
    "use",
    "find",
    "state",
    "write",
    "hence",
    "solve",
    "show",
    "draw",
    "simplify",
  ],
  markAllocation: [
    { marks: 3, observedCount: 20 },
    { marks: 2, observedCount: 13 },
    { marks: 1, observedCount: 9 },
    { marks: 4, observedCount: 7 },
    { marks: 6, observedCount: 1 },
  ],
  topicSignals: [
    { tag: "geometry", observedCount: 23 },
    { tag: "algebraic_reasoning", observedCount: 11 },
    { tag: "graph_work", observedCount: 10 },
    { tag: "statistics", observedCount: 6 },
    { tag: "mensuration", observedCount: 6 },
    { tag: "matrices", observedCount: 4 },
    { tag: "trigonometry", observedCount: 3 },
    { tag: "calculus", observedCount: 1 },
    { tag: "vectors", observedCount: 1 },
  ],
  contentPolicy: sourceQuestionPolicy,
  notes: [
    "Observed from structure-level extraction only; no source questions or answers are stored.",
    "Most observed item marks were 1-4, so generated practice should emphasize compact structured marking.",
  ],
};

const mathPaper2Calibration: KcsePaperCalibration = {
  calibratedFrom: ["2024 KCSE Mathematics Paper 2"],
  evidenceType: "metadata_only",
  extractionStatus: "machine_readable",
  commandVerbs: [
    "determine",
    "calculate",
    "draw",
    "find",
    "use",
    "express",
    "solve",
    "show",
    "write",
    "evaluate",
  ],
  markAllocation: [
    { marks: 3, observedCount: 21 },
    { marks: 2, observedCount: 16 },
    { marks: 1, observedCount: 14 },
    { marks: 4, observedCount: 4 },
    { marks: 5, observedCount: 1 },
  ],
  topicSignals: [
    { tag: "geometry", observedCount: 21 },
    { tag: "commercial_arithmetic", observedCount: 11 },
    { tag: "algebraic_reasoning", observedCount: 8 },
    { tag: "statistics", observedCount: 6 },
    { tag: "graph_work", observedCount: 5 },
    { tag: "matrices", observedCount: 3 },
    { tag: "mensuration", observedCount: 2 },
  ],
  contentPolicy: sourceQuestionPolicy,
  notes: [
    "Observed from structure-level extraction only; no source questions or answers are stored.",
    "Paper 2 calibration should bias original generation toward geometry, commercial arithmetic, and multi-step graph/statistics work.",
  ],
};

const english2024CalibrationNeedsOcr: KcsePaperCalibration = {
  calibratedFrom: ["2024 KCSE English Papers 1, 2, and 3 combined"],
  evidenceType: "metadata_only",
  extractionStatus: "needs_ocr",
  commandVerbs: [],
  markAllocation: [],
  topicSignals: [],
  contentPolicy: sourceQuestionPolicy,
  notes: [
    "The provided combined English PDF yielded limited machine-readable text, so an OCR or visual calibration pass is required before deriving reliable topic and command-verb weights.",
    "Until calibrated, English generation should use the canonical paper structure only and avoid claims based on the 2024 sample.",
  ],
};

export const KCSE_SUBJECT_BLUEPRINTS: KcseSubjectBlueprint[] = [
  {
    id: "mathematics",
    displayName: "Mathematics",
    curriculum: "KCSE",
    group: "core",
    aliases: ["math", "maths"],
    gradingMode: "structured",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "Mathematics Paper 1", "structured_questions", 100, 150, [
        "Short structured questions",
        "Long structured questions",
      ], mathPaper1Calibration),
      paper(2, "Mathematics Paper 2", "structured_questions", 100, 150, [
        "Algebra and geometry",
        "Statistics and trigonometry",
      ], mathPaper2Calibration),
    ],
    patternTags: [
      "algebraic_reasoning",
      "geometry",
      "graph_work",
      "statistics",
      "mensuration",
      "commercial_arithmetic",
    ],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "english",
    displayName: "English",
    curriculum: "KCSE",
    group: "core",
    aliases: ["english language"],
    gradingMode: "rubric_band",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "English Paper 1", "essay_and_comprehension", 60, 120, [
        "Functional writing",
        "Cloze test",
        "Oral skills",
      ], english2024CalibrationNeedsOcr),
      paper(2, "English Paper 2", "essay_and_comprehension", 80, 150, [
        "Comprehension",
        "Literary appreciation",
        "Grammar",
      ], english2024CalibrationNeedsOcr),
      paper(3, "English Paper 3", "essay_and_comprehension", 60, 150, [
        "Imaginative composition",
        "Set text essay",
      ], english2024CalibrationNeedsOcr),
    ],
    patternTags: ["language_use", "composition", "comprehension"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "kiswahili",
    displayName: "Kiswahili",
    curriculum: "KCSE",
    group: "core",
    aliases: ["swahili"],
    gradingMode: "rubric_band",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "Kiswahili Paper 1", "essay_and_comprehension", 60, 120, [
        "Insha",
        "Ufupisho",
      ]),
      paper(2, "Kiswahili Paper 2", "essay_and_comprehension", 80, 150, [
        "Ufasiri",
        "Lugha",
      ]),
      paper(3, "Kiswahili Paper 3", "essay_and_comprehension", 80, 150, [
        "Fasihi",
        "Uchambuzi",
      ]),
    ],
    patternTags: ["lugha", "insha", "fasihi"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "biology",
    displayName: "Biology",
    curriculum: "KCSE",
    group: "sciences",
    aliases: ["bio"],
    gradingMode: "keyword",
    defaultDurationMinutes: 120,
    paperStructures: [
      paper(1, "Biology Paper 1", "objective_and_structured", 80, 120, [
        "Short structured questions",
      ]),
      paper(2, "Biology Paper 2", "structured_questions", 80, 120, [
        "Structured explanations",
        "Data interpretation",
      ]),
      paper(3, "Biology Practical", "practical_tasks", 40, 105, [
        "Practical skills",
        "Observation and recording",
      ]),
    ],
    patternTags: ["classification", "physiology", "practical_skills"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "chemistry",
    displayName: "Chemistry",
    curriculum: "KCSE",
    group: "sciences",
    aliases: ["chem"],
    gradingMode: "structured",
    defaultDurationMinutes: 120,
    paperStructures: [
      paper(1, "Chemistry Paper 1", "objective_and_structured", 80, 120, [
        "Short structured questions",
      ]),
      paper(2, "Chemistry Paper 2", "structured_questions", 80, 120, [
        "Calculations",
        "Explanations",
      ]),
      paper(3, "Chemistry Practical", "practical_tasks", 40, 105, [
        "Experimental work",
      ]),
    ],
    patternTags: ["mole_concept", "organic_chemistry", "practical_skills"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "physics",
    displayName: "Physics",
    curriculum: "KCSE",
    group: "sciences",
    aliases: ["phy"],
    gradingMode: "structured",
    defaultDurationMinutes: 120,
    paperStructures: [
      paper(1, "Physics Paper 1", "structured_questions", 80, 120, [
        "Mechanics",
        "Measurement",
      ]),
      paper(2, "Physics Paper 2", "structured_questions", 80, 120, [
        "Electricity",
        "Waves and optics",
      ]),
      paper(3, "Physics Practical", "practical_tasks", 40, 105, [
        "Practical skills",
      ]),
    ],
    patternTags: ["mechanics", "electricity", "graph_work"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "history_government",
    displayName: "History and Government",
    curriculum: "KCSE",
    group: "humanities",
    aliases: ["history", "government"],
    gradingMode: "keyword",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "History and Government Paper 1", "structured_questions", 100, 150, [
        "Kenya history",
      ]),
      paper(2, "History and Government Paper 2", "structured_questions", 100, 150, [
        "World history",
      ]),
    ],
    patternTags: ["causes_effects", "governance", "chronology"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "geography",
    displayName: "Geography",
    curriculum: "KCSE",
    group: "humanities",
    aliases: ["geo"],
    gradingMode: "keyword",
    defaultDurationMinutes: 165,
    paperStructures: [
      paper(1, "Geography Paper 1", "structured_questions", 100, 165, [
        "Physical geography",
      ]),
      paper(2, "Geography Paper 2", "map_and_fieldwork", 100, 165, [
        "Human geography",
        "Map work",
      ]),
    ],
    patternTags: ["map_work", "fieldwork", "human_geography"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "cre",
    displayName: "Christian Religious Education",
    curriculum: "KCSE",
    group: "humanities",
    aliases: ["christian religious education"],
    gradingMode: "keyword",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "CRE Paper 1", "structured_questions", 100, 150, [
        "Old Testament",
      ]),
      paper(2, "CRE Paper 2", "structured_questions", 100, 150, [
        "New Testament",
        "Contemporary issues",
      ]),
    ],
    patternTags: ["text_reference", "application", "values"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "ire",
    displayName: "Islamic Religious Education",
    curriculum: "KCSE",
    group: "humanities",
    aliases: ["islamic religious education"],
    gradingMode: "keyword",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "IRE Paper 1", "structured_questions", 100, 150, [
        "Quran and Hadith",
      ]),
      paper(2, "IRE Paper 2", "structured_questions", 100, 150, [
        "Fiqh and history",
      ]),
    ],
    patternTags: ["text_reference", "application", "history"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "business_studies",
    displayName: "Business Studies",
    curriculum: "KCSE",
    group: "applied_elective",
    aliases: ["business"],
    gradingMode: "structured",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "Business Studies Paper 1", "structured_questions", 100, 150, [
        "Short structured questions",
      ]),
      paper(2, "Business Studies Paper 2", "case_study", 100, 150, [
        "Case applications",
      ]),
    ],
    patternTags: ["accounting", "commerce", "entrepreneurship"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "agriculture",
    displayName: "Agriculture",
    curriculum: "KCSE",
    group: "applied_elective",
    aliases: ["agric"],
    gradingMode: "keyword",
    defaultDurationMinutes: 120,
    paperStructures: [
      paper(1, "Agriculture Paper 1", "structured_questions", 90, 120, [
        "Crop production",
      ]),
      paper(2, "Agriculture Paper 2", "structured_questions", 90, 120, [
        "Animal production",
      ]),
      paper(3, "Agriculture Practical", "practical_tasks", 40, 90, [
        "Practical skills",
      ]),
    ],
    patternTags: ["crop_production", "animal_production", "farm_management"],
    sourcePolicy: "original_metadata_only",
  },
  {
    id: "computer_studies",
    displayName: "Computer Studies",
    curriculum: "KCSE",
    group: "applied_elective",
    aliases: ["computer", "ict"],
    gradingMode: "structured",
    defaultDurationMinutes: 150,
    paperStructures: [
      paper(1, "Computer Studies Paper 1", "structured_questions", 100, 150, [
        "Theory",
      ]),
      paper(2, "Computer Studies Practical", "practical_tasks", 100, 150, [
        "Practical tasks",
      ]),
    ],
    patternTags: ["systems", "programming", "practical_tasks"],
    sourcePolicy: "original_metadata_only",
  },
];

const blueprintByLookup = new Map<string, KcseSubjectBlueprint>();

for (const blueprint of KCSE_SUBJECT_BLUEPRINTS) {
  blueprintByLookup.set(blueprint.id, blueprint);
  blueprintByLookup.set(blueprint.displayName.toLowerCase(), blueprint);
  for (const alias of blueprint.aliases) {
    blueprintByLookup.set(alias.toLowerCase(), blueprint);
  }
}

export function getKcseSubjectBlueprint(
  subject: string,
): KcseSubjectBlueprint | null {
  return blueprintByLookup.get(subject.trim().toLowerCase()) ?? null;
}

export function getKcseSubjectBlueprintsByGroup(
  group: KcseSubjectGroup,
): KcseSubjectBlueprint[] {
  return KCSE_SUBJECT_BLUEPRINTS.filter((blueprint) => blueprint.group === group);
}
