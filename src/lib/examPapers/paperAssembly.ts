export interface TemplateRecord {
  id: string;
  paper: 1 | 2;
  section: "I" | "II";
  formLevel: number;
  topicId: string;
  marks: number;
  body: unknown;
}

export interface AssembledPaper {
  sectionOne: TemplateRecord[];
  sectionTwo: TemplateRecord[];
}

const SECTION_ONE_TARGET_MARKS = 50;
const SECTION_ONE_COUNT = 16;
const SECTION_TWO_COUNT = 8;
const SECTION_TWO_MARKS_EACH = 10;
const MAX_FOURS_TRIED = 9; // a - b = 2, b >= 0, a + b <= 16 => a <= 9

function eligible(
  templates: TemplateRecord[],
  section: "I" | "II",
  formLevel: number,
  excludedIds: Set<string>,
): TemplateRecord[] {
  return templates.filter(
    (t) => t.section === section && t.formLevel <= formLevel && !excludedIds.has(t.id),
  );
}

function shuffle<T>(items: T[], rng: () => number): T[] {
  const copy = [...items];
  for (let i = copy.length - 1; i > 0; i -= 1) {
    const j = Math.floor(rng() * (i + 1));
    [copy[i], copy[j]] = [copy[j], copy[i]];
  }
  return copy;
}

function assembleSectionOne(pool: TemplateRecord[], rng: () => number): TemplateRecord[] | null {
  for (let fours = 2; fours <= MAX_FOURS_TRIED; fours += 1) {
    const twos = fours - 2;
    const threes = SECTION_ONE_COUNT - fours - twos;
    if (threes < 0) continue;

    const marksSum = fours * 4 + twos * 2 + threes * 3;
    if (marksSum !== SECTION_ONE_TARGET_MARKS) continue; // defensive; always true by construction

    const fourPool = pool.filter((t) => t.marks === 4);
    const twoPool = pool.filter((t) => t.marks === 2);
    const threePool = pool.filter((t) => t.marks === 3);

    if (fourPool.length < fours || twoPool.length < twos || threePool.length < threes) {
      continue;
    }

    const chosenFours = shuffle(fourPool, rng).slice(0, fours);
    const chosenTwos = shuffle(twoPool, rng).slice(0, twos);
    const chosenThrees = shuffle(threePool, rng).slice(0, threes);

    return shuffle([...chosenFours, ...chosenTwos, ...chosenThrees], rng);
  }

  return null;
}

function pickDistinctTopics(
  pool: TemplateRecord[],
  count: number,
  rng: () => number,
): TemplateRecord[] | null {
  const shuffled = shuffle(pool, rng);
  const selected: TemplateRecord[] = [];
  const usedTopics = new Set<string>();

  for (const template of shuffled) {
    if (selected.length >= count) break;
    if (usedTopics.has(template.topicId)) continue;
    selected.push(template);
    usedTopics.add(template.topicId);
  }

  if (selected.length < count) {
    for (const template of shuffled) {
      if (selected.length >= count) break;
      if (selected.includes(template)) continue;
      selected.push(template);
    }
  }

  return selected.length === count ? selected : null;
}

export function hasSufficientTemplateBank(
  templates: TemplateRecord[],
  paper: 1 | 2,
  formLevel: number,
): boolean {
  const excluded = new Set<string>();
  const paperTemplates = templates.filter((t) => t.paper === paper);
  const sectionOnePool = eligible(paperTemplates, "I", formLevel, excluded);
  const sectionTwoPool = eligible(paperTemplates, "II", formLevel, excluded);

  const feasibleSectionOne = assembleSectionOne(sectionOnePool, () => 0.5) !== null;
  const feasibleSectionTwo =
    sectionTwoPool.length >= SECTION_TWO_COUNT &&
    sectionTwoPool.every((t) => t.marks === SECTION_TWO_MARKS_EACH);

  return feasibleSectionOne && feasibleSectionTwo;
}

export function assembleExamPaper(input: {
  templates: TemplateRecord[];
  paper: 1 | 2;
  formLevel: number;
  excludedTemplateIds: string[];
  rng: () => number;
}): AssembledPaper {
  const excluded = new Set(input.excludedTemplateIds);
  const paperTemplates = input.templates.filter((t) => t.paper === input.paper);

  const sectionOnePool = eligible(paperTemplates, "I", input.formLevel, excluded);
  const sectionOne = assembleSectionOne(sectionOnePool, input.rng);
  if (!sectionOne) {
    throw new Error("INSUFFICIENT_TEMPLATE_BANK");
  }

  const sectionTwoPool = eligible(paperTemplates, "II", input.formLevel, excluded);
  if (sectionTwoPool.some((t) => t.marks !== SECTION_TWO_MARKS_EACH)) {
    throw new Error("SECTION_II_TEMPLATE_MARKS_MISMATCH");
  }

  const sectionTwo = pickDistinctTopics(sectionTwoPool, SECTION_TWO_COUNT, input.rng);
  if (!sectionTwo) {
    throw new Error("INSUFFICIENT_TEMPLATE_BANK");
  }

  return { sectionOne, sectionTwo };
}
