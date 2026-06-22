import {
  KCSE_SUBJECT_BLUEPRINTS,
  type KcseSubjectId,
} from "@/lib/assessment/kcseSubjectBlueprints";

export type KcseForm = 1 | 2 | 3 | 4;

export interface KcseTopicNode {
  id: string;
  subjectId: KcseSubjectId;
  form: KcseForm;
  title: string;
  strand: string;
  prerequisites: string[];
  skills: string[];
  commonMistakes: string[];
  examPatterns: string[];
}

export interface KcseSubjectTopicGraph {
  subjectId: KcseSubjectId;
  curriculum: "KCSE";
  sourcePolicy: "original_metadata_only";
  forms: Array<{ form: KcseForm; topicIds: string[] }>;
  topics: KcseTopicNode[];
}

export interface KcseSubjectGraphValidationReport {
  subjectId: KcseSubjectId;
  topicCount: number;
  formsCovered: KcseForm[];
  danglingPrerequisites: string[];
  nodesWithoutSkills: string[];
  nodesWithoutCommonMistakes: string[];
  nodesWithoutExamPatterns: string[];
}

interface TopicSeed {
  slug: string;
  title: string;
  strand: string;
  skills: string[];
  commonMistakes: string[];
  examPatterns: string[];
  prerequisiteSlugs?: string[];
}

type SubjectTopicSeeds = Record<KcseForm, TopicSeed[]>;

const SUBJECT_TOPIC_SEEDS: Record<KcseSubjectId, SubjectTopicSeeds> = {
  mathematics: {
    1: [
      topicSeed("integers-fractions-and-decimals", "Integers, fractions and decimals", "Number", [
        "Operate accurately with directed numbers.",
        "Convert between fractions, decimals, and percentages.",
      ], [
        "Dropping negative signs during multi-step simplification.",
      ], [
        "Short structured calculations with method marks for each operation.",
      ]),
      topicSeed("algebraic-expressions", "Algebraic expressions", "Algebra", [
        "Simplify like terms and substitute values.",
        "Expand and factorise simple expressions.",
      ], [
        "Treating unlike terms as if they can be combined.",
      ], [
        "Simplification, expansion, and substitution prompts in compact items.",
      ], ["integers-fractions-and-decimals"]),
    ],
    2: [
      topicSeed("linear-equations", "Linear equations", "Algebra", [
        "Solve one-variable linear equations.",
        "Translate simple word statements into equations.",
      ], [
        "Changing one side of an equation without applying the same operation to the other side.",
      ], [
        "Solve, hence, and find prompts with marks for clear balancing steps.",
      ], ["integers-fractions-and-decimals", "algebraic-expressions"]),
      topicSeed("geometry-and-scale-drawing", "Geometry and scale drawing", "Geometry", [
        "Construct angles and triangles accurately.",
        "Interpret scale drawings and bearings.",
      ], [
        "Measuring from the wrong baseline or using an inconsistent scale.",
      ], [
        "Diagram-based construction and measurement items.",
      ]),
    ],
    3: [
      topicSeed("quadratic-expressions", "Quadratic expressions", "Algebra", [
        "Factorise quadratic expressions.",
        "Solve quadratic equations by factorisation.",
      ], [
        "Forgetting that a product is zero only when one factor is zero.",
      ], [
        "Factorise, solve, and show prompts with staged method marks.",
      ], ["linear-equations"]),
      topicSeed("trigonometry", "Trigonometry", "Geometry", [
        "Apply sine, cosine, and tangent ratios.",
        "Use angle of elevation and depression contexts.",
      ], [
        "Choosing the wrong trigonometric ratio for the known sides.",
      ], [
        "Right-triangle applications and height-distance word problems.",
      ], ["geometry-and-scale-drawing"]),
    ],
    4: [
      topicSeed("calculus-and-area", "Calculus and area", "Calculus", [
        "Differentiate polynomial functions.",
        "Use integration for area under simple curves.",
      ], [
        "Confusing gradient at a point with average gradient over an interval.",
      ], [
        "Determine, hence, and evaluate prompts using graphs or functions.",
      ], ["quadratic-expressions"]),
      topicSeed("statistics-and-probability", "Statistics and probability", "Statistics", [
        "Interpret grouped data and measures of spread.",
        "Calculate probabilities from structured scenarios.",
      ], [
        "Using class limits where class midpoints are required.",
      ], [
        "Table, graph, and probability-tree interpretation.",
      ], ["integers-fractions-and-decimals"]),
    ],
  },
  english: subjectSeeds("english", [
    ["Grammar foundations", "Language use"],
    ["Functional writing", "Writing"],
    ["Comprehension skills", "Reading"],
    ["Oral skills", "Speaking and listening"],
    ["Literary appreciation", "Literature"],
    ["Summary and cloze", "Language use"],
    ["Set text essays", "Literature"],
    ["Imaginative composition", "Writing"],
  ]),
  kiswahili: subjectSeeds("kiswahili", [
    ["Sarufi foundations", "Lugha"],
    ["Insha ya kawaida", "Uandishi"],
    ["Ufahamu", "Kusoma"],
    ["Ufupisho", "Kusoma"],
    ["Fasihi simulizi", "Fasihi"],
    ["Matumizi ya lugha", "Lugha"],
    ["Fasihi andishi", "Fasihi"],
    ["Insha za mtihani", "Uandishi"],
  ]),
  biology: subjectSeeds("biology", [
    ["Introduction to biology", "Foundations"],
    ["Classification", "Diversity"],
    ["Cell physiology", "Cells"],
    ["Nutrition in plants", "Physiology"],
    ["Transport in organisms", "Physiology"],
    ["Respiration", "Physiology"],
    ["Genetics", "Continuity"],
    ["Ecology and practical skills", "Ecology"],
  ]),
  chemistry: subjectSeeds("chemistry", [
    ["Laboratory safety", "Foundations"],
    ["Simple classification of substances", "Matter"],
    ["Atomic structure", "Matter"],
    ["Chemical bonding", "Matter"],
    ["Mole concept", "Quantitative chemistry"],
    ["Organic chemistry foundations", "Organic chemistry"],
    ["Electrochemistry", "Physical chemistry"],
    ["Qualitative analysis", "Practical chemistry"],
  ]),
  physics: subjectSeeds("physics", [
    ["Measurement", "Foundations"],
    ["Force", "Mechanics"],
    ["Linear motion", "Mechanics"],
    ["Light and waves", "Waves"],
    ["Electricity", "Electricity"],
    ["Magnetism", "Electricity"],
    ["Electronics", "Modern physics"],
    ["Practical graph work", "Practical physics"],
  ]),
  history_government: subjectSeeds("history_government", [
    ["Early human history", "History"],
    ["Citizenship", "Government"],
    ["Trade and contacts", "History"],
    ["Development of government", "Government"],
    ["Nationalism", "History"],
    ["Constitution and democracy", "Government"],
    ["World wars", "World history"],
    ["International relations", "World history"],
  ]),
  geography: subjectSeeds("geography", [
    ["Map reading foundations", "Map work"],
    ["Weather", "Physical geography"],
    ["Internal land-forming processes", "Physical geography"],
    ["Fieldwork methods", "Fieldwork"],
    ["Climate and vegetation", "Physical geography"],
    ["Agriculture", "Human geography"],
    ["Industry and energy", "Human geography"],
    ["Population and settlement", "Human geography"],
  ]),
  cre: subjectSeeds("cre", [
    ["Creation and fall", "Old Testament"],
    ["Faith and promises", "Old Testament"],
    ["Moses and Exodus", "Old Testament"],
    ["Kingship in Israel", "Old Testament"],
    ["Life and ministry of Jesus", "New Testament"],
    ["The early church", "New Testament"],
    ["Christian ethics", "Contemporary issues"],
    ["Work, leisure, and wealth", "Contemporary issues"],
  ]),
  ire: subjectSeeds("ire", [
    ["Quran foundations", "Quran"],
    ["Hadith foundations", "Hadith"],
    ["Pillars of Islam", "Fiqh"],
    ["Taharah and prayer", "Fiqh"],
    ["Islamic history", "History"],
    ["Muamalat", "Social relations"],
    ["Family life", "Social relations"],
    ["Islamic morality", "Akhlaq"],
  ]),
  business_studies: subjectSeeds("business_studies", [
    ["Introduction to business", "Business foundations"],
    ["Business and its environment", "Business foundations"],
    ["Entrepreneurship", "Enterprise"],
    ["Office and communication", "Office practice"],
    ["Demand and supply", "Commerce"],
    ["Accounting foundations", "Accounting"],
    ["Business finance", "Finance"],
    ["International trade", "Commerce"],
  ]),
  agriculture: subjectSeeds("agriculture", [
    ["Introduction to agriculture", "Foundations"],
    ["Soil fertility", "Crop production"],
    ["Crop production practices", "Crop production"],
    ["Farm tools and machinery", "Farm power"],
    ["Livestock production", "Animal production"],
    ["Farm records", "Farm management"],
    ["Agricultural economics", "Farm management"],
    ["Agricultural project planning", "Project work"],
  ]),
  computer_studies: subjectSeeds("computer_studies", [
    ["Computer systems", "Foundations"],
    ["Operating systems", "Systems"],
    ["Word processing", "Applications"],
    ["Spreadsheets", "Applications"],
    ["Databases", "Applications"],
    ["Networking", "Systems"],
    ["Programming foundations", "Programming"],
    ["System development", "Programming"],
  ]),
};

const graphBySubject = new Map<KcseSubjectId, KcseSubjectTopicGraph>();

for (const blueprint of KCSE_SUBJECT_BLUEPRINTS) {
  graphBySubject.set(blueprint.id, buildGraph(blueprint.id, SUBJECT_TOPIC_SEEDS[blueprint.id]));
}

export function getKcseSubjectTopicGraph(
  subjectId: KcseSubjectId,
): KcseSubjectTopicGraph | null {
  return graphBySubject.get(subjectId) ?? null;
}

export function listKcseSubjectTopicNodes(subjectId: KcseSubjectId): KcseTopicNode[] {
  return getKcseSubjectTopicGraph(subjectId)?.topics ?? [];
}

export function getKcseTopicNode(
  subjectId: KcseSubjectId,
  topicId: string,
): KcseTopicNode | null {
  return listKcseSubjectTopicNodes(subjectId).find((node) => node.id === topicId) ?? null;
}

export function getKcsePrerequisiteChain(
  subjectId: KcseSubjectId,
  topicId: string,
): KcseTopicNode[] {
  const graph = getKcseSubjectTopicGraph(subjectId);
  const node = getKcseTopicNode(subjectId, topicId);
  if (!graph || !node) return [];

  const byId = new Map(graph.topics.map((entry) => [entry.id, entry]));
  return node.prerequisites
    .map((prerequisiteId) => byId.get(prerequisiteId))
    .filter((entry): entry is KcseTopicNode => Boolean(entry));
}

export function validateKcseSubjectGraph(
  subjectId: KcseSubjectId,
): KcseSubjectGraphValidationReport {
  const graph = getKcseSubjectTopicGraph(subjectId);
  if (!graph) {
    return {
      subjectId,
      topicCount: 0,
      formsCovered: [],
      danglingPrerequisites: [],
      nodesWithoutSkills: [],
      nodesWithoutCommonMistakes: [],
      nodesWithoutExamPatterns: [],
    };
  }

  const ids = new Set(graph.topics.map((node) => node.id));
  return {
    subjectId,
    topicCount: graph.topics.length,
    formsCovered: graph.forms
      .filter((form) => form.topicIds.length > 0)
      .map((form) => form.form),
    danglingPrerequisites: graph.topics.flatMap((node) =>
      node.prerequisites.filter((prerequisiteId) => !ids.has(prerequisiteId)),
    ),
    nodesWithoutSkills: graph.topics
      .filter((node) => node.skills.length === 0)
      .map((node) => node.id),
    nodesWithoutCommonMistakes: graph.topics
      .filter((node) => node.commonMistakes.length === 0)
      .map((node) => node.id),
    nodesWithoutExamPatterns: graph.topics
      .filter((node) => node.examPatterns.length === 0)
      .map((node) => node.id),
  };
}

function buildGraph(
  subjectId: KcseSubjectId,
  seeds: SubjectTopicSeeds,
): KcseSubjectTopicGraph {
  const topics = (Object.entries(seeds) as Array<[`${KcseForm}`, TopicSeed[]]>)
    .flatMap(([formValue, entries]) =>
      entries.map((entry) => makeNode(subjectId, Number(formValue) as KcseForm, entry)),
    );

  return {
    subjectId,
    curriculum: "KCSE",
    sourcePolicy: "original_metadata_only",
    forms: ([1, 2, 3, 4] as KcseForm[]).map((form) => ({
      form,
      topicIds: topics.filter((topic) => topic.form === form).map((topic) => topic.id),
    })),
    topics,
  };
}

function makeNode(
  subjectId: KcseSubjectId,
  form: KcseForm,
  seed: TopicSeed,
): KcseTopicNode {
  return {
    id: topicId(subjectId, form, seed.slug),
    subjectId,
    form,
    title: seed.title,
    strand: seed.strand,
    prerequisites: seed.prerequisiteSlugs?.map((slug) => resolvePrerequisiteId(subjectId, slug)) ?? [],
    skills: seed.skills,
    commonMistakes: seed.commonMistakes,
    examPatterns: seed.examPatterns,
  };
}

function resolvePrerequisiteId(subjectId: KcseSubjectId, slug: string): string {
  const seeds = SUBJECT_TOPIC_SEEDS[subjectId];
  for (const [formValue, entries] of Object.entries(seeds) as Array<[`${KcseForm}`, TopicSeed[]]>) {
    if (entries.some((entry) => entry.slug === slug)) {
      return topicId(subjectId, Number(formValue) as KcseForm, slug);
    }
  }
  return `${subjectId}:unknown:${slug}`;
}

function topicId(subjectId: KcseSubjectId, form: KcseForm, slug: string): string {
  return `${subjectId}:form${form}:${slug}`;
}

function topicSeed(
  slug: string,
  title: string,
  strand: string,
  skills: string[],
  commonMistakes: string[],
  examPatterns: string[],
  prerequisiteSlugs: string[] = [],
): TopicSeed {
  return { slug, title, strand, skills, commonMistakes, examPatterns, prerequisiteSlugs };
}

function subjectSeeds(
  subjectId: KcseSubjectId,
  entries: Array<[title: string, strand: string]>,
): SubjectTopicSeeds {
  const forms = [1, 1, 2, 2, 3, 3, 4, 4] as KcseForm[];
  const seeds = { 1: [], 2: [], 3: [], 4: [] } as SubjectTopicSeeds;

  entries.forEach(([title, strand], index) => {
    const form = forms[index];
    const slug = slugify(title);
    const prerequisiteSlugs = index > 1 ? [slugify(entries[index - 2][0])] : [];
    seeds[form].push(
      topicSeed(
        slug,
        title,
        strand,
        [
          `Explain core ${strand.toLowerCase()} ideas using correct terminology.`,
          `Apply ${title.toLowerCase()} to structured KCSE-style prompts.`,
        ],
        [
          `Mixing up closely related ${strand.toLowerCase()} terms under exam pressure.`,
        ],
        [
          `Short answer and structured explanation items testing ${title.toLowerCase()}.`,
        ],
        prerequisiteSlugs,
      ),
    );
  });

  return seeds;
}

function slugify(value: string): string {
  return value
    .toLowerCase()
    .replace(/&/g, "and")
    .replace(/[^a-z0-9]+/g, "-")
    .replace(/^-|-$/g, "");
}
