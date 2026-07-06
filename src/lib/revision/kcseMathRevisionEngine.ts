export type KcseFormLevel = "Form 1" | "Form 2" | "Form 3" | "Form 4";

export type RevisionTopicStatus = "not_started" | "repair" | "building" | "ready";

export interface KcseMathRevisionTopicInput {
  id: string;
  code: string;
  title: string;
  formLevel?: KcseFormLevel;
  sortOrder: number;
}

export interface KcseMathTopicMasteryInput {
  topicId: string;
  masteryPercentage: number;
}

export interface KcseMathStudyPlanTaskInput {
  id: string;
  topicId: string | null;
  topicTitle: string | null;
  taskTitle: string;
  taskType: string;
  dailyGoalMinutes: number;
  isCompleted: boolean;
}

export interface KcseMathActiveStudyPlanInput {
  title: string;
  dailyGoalMinutes: number | null;
  tasks: KcseMathStudyPlanTaskInput[];
}

export interface BuildKcseMathRevisionHubInput {
  studentName: string;
  curriculum: string;
  gradeLevel: string;
  healthScore: number;
  predictedGrade: string | null;
  topics: KcseMathRevisionTopicInput[];
  topicMastery: KcseMathTopicMasteryInput[];
  activeStudyPlan: KcseMathActiveStudyPlanInput | null;
}

export interface KcseMathSyllabusTopic {
  id: string;
  code: string;
  title: string;
  formLevel: KcseFormLevel;
  masteryPercentage: number;
  status: RevisionTopicStatus;
  lessonHref: string;
  practiceHref: string;
  nexHref: string;
}

export interface KcseMathRevisionHubModel {
  studentName: string;
  curriculum: string;
  gradeLevel: string;
  readiness: {
    score: number;
    label: "Needs repair" | "Building" | "Exam ready";
    description: string;
    predictedGrade: string | null;
  };
  syllabusMap: KcseMathSyllabusTopic[];
  dailyPlan: {
    title: string;
    dailyGoalMinutes: number;
    items: Array<{
      id: string;
      title: string;
      topicTitle: string | null;
      minutes: number;
      isCompleted: boolean;
      href: string;
    }>;
    planHref: string;
  };
  practiceLinks: {
    kcseStyle: {
      label: string;
      href: string;
    };
    topicDrill: {
      label: string;
      href: string;
    };
  };
  weakTopicRepair: Array<{
    id: string;
    title: string;
    masteryPercentage: number;
    repairFocus: string;
    nexHref: string;
    practiceHref: string;
  }>;
  trustSummary: {
    schoolReadySignal: string;
    parentPricingSignal: string;
    chatPrivacy: string;
  };
  lowDataMode: {
    tips: string[];
  };
}

const STATUS_REPAIR_MAX = 49;
const STATUS_READY_MIN = 75;

function clampScore(value: number): number {
  if (!Number.isFinite(value)) return 0;
  return Math.min(100, Math.max(0, Math.round(value)));
}

function statusFromMastery(masteryPercentage: number): RevisionTopicStatus {
  if (masteryPercentage <= 0) return "not_started";
  if (masteryPercentage <= STATUS_REPAIR_MAX) return "repair";
  if (masteryPercentage < STATUS_READY_MIN) return "building";
  return "ready";
}

function labelFromReadiness(score: number): KcseMathRevisionHubModel["readiness"]["label"] {
  if (score < 50) return "Needs repair";
  if (score < 75) return "Building";
  return "Exam ready";
}

function descriptionFromReadiness(
  label: KcseMathRevisionHubModel["readiness"]["label"],
): string {
  if (label === "Needs repair") {
    return "Focus on weak-topic repair before timed KCSE practice.";
  }
  if (label === "Exam ready") {
    return "You are ready for timed KCSE-style practice and exam-style pacing.";
  }
  return "You are building toward exam-ready work.";
}

function formLevelFromTopic(topic: KcseMathRevisionTopicInput): KcseFormLevel {
  if (topic.formLevel) return topic.formLevel;

  if (topic.code.includes("statistics") || topic.code.includes("probability")) {
    return "Form 3";
  }
  if (topic.code.includes("trigonometry")) {
    return "Form 2";
  }
  if (topic.code.includes("vectors") || topic.code.includes("calculus")) {
    return "Form 4";
  }
  return "Form 1";
}

function buildNexHref(topicId: string): string {
  return `/nex?mode=revision&topicId=${topicId}`;
}

function repairFocusForStatus(status: RevisionTopicStatus): string {
  if (status === "not_started") {
    return "Start with the core idea, then try two untimed examples.";
  }
  if (status === "repair") {
    return "Rebuild the core method before doing timed questions.";
  }
  if (status === "building") {
    return "Do guided examples, then switch to mixed practice.";
  }
  return "Move into timed KCSE-style questions to protect speed.";
}

function averageMastery(topics: KcseMathSyllabusTopic[]): number {
  if (topics.length === 0) return 0;
  const total = topics.reduce((sum, topic) => sum + topic.masteryPercentage, 0);
  return Math.round(total / topics.length);
}

function formRank(formLevel: KcseFormLevel): number {
  return Number(formLevel.replace("Form ", ""));
}

function gradeRank(gradeLevel: string): number {
  const match = gradeLevel.match(/form[_\s-]?([1-4])/i);
  if (!match) return 4;
  return Number(match[1]);
}

function fallbackDailyItems(topics: KcseMathSyllabusTopic[]) {
  return topics.slice(0, 2).map((topic) => ({
    id: `repair-${topic.id}`,
    title: `Repair ${topic.title}`,
    topicTitle: topic.title,
    minutes: 20,
    isCompleted: false,
    href: topic.nexHref,
  }));
}

export function buildKcseMathRevisionHub(
  input: BuildKcseMathRevisionHubInput,
): KcseMathRevisionHubModel {
  const masteryByTopicId = new Map(
    input.topicMastery.map((entry) => [
      entry.topicId,
      clampScore(entry.masteryPercentage),
    ]),
  );

  const syllabusMap = input.topics
    .slice()
    .sort((left, right) => left.sortOrder - right.sortOrder)
    .map((topic) => {
      const masteryPercentage = masteryByTopicId.get(topic.id) ?? 0;
      return {
        id: topic.id,
        code: topic.code,
        title: topic.title,
        formLevel: formLevelFromTopic(topic),
        masteryPercentage,
        status: statusFromMastery(masteryPercentage),
        lessonHref: `/learn/${topic.id}`,
        practiceHref: `/practice?topicId=${topic.id}`,
        nexHref: buildNexHref(topic.id),
      };
    });

  const learnerFormRank = gradeRank(input.gradeLevel);
  const assessedTopics = syllabusMap.filter(
    (topic) => formRank(topic.formLevel) <= learnerFormRank,
  );
  const repairCandidates = assessedTopics.length > 0 ? assessedTopics : syllabusMap;

  const weakTopicRepair = repairCandidates
    .slice()
    .sort((left, right) => left.masteryPercentage - right.masteryPercentage)
    .slice(0, 3)
    .map((topic) => ({
      id: topic.id,
      title: topic.title,
      masteryPercentage: topic.masteryPercentage,
      repairFocus: repairFocusForStatus(topic.status),
      nexHref: topic.nexHref,
      practiceHref: topic.practiceHref,
    }));

  const masteryAverage = averageMastery(
    assessedTopics.length > 0 ? assessedTopics : syllabusMap,
  );
  const readinessScore = clampScore(input.healthScore * 0.6 + masteryAverage * 0.4);
  const readinessLabel = labelFromReadiness(readinessScore);
  const activePlan = input.activeStudyPlan;
  const dailyItems =
    activePlan && activePlan.tasks.length > 0
      ? activePlan.tasks.map((task) => ({
          id: task.id,
          title: task.taskTitle,
          topicTitle: task.topicTitle,
          minutes: task.dailyGoalMinutes,
          isCompleted: task.isCompleted,
          href: task.topicId ? buildNexHref(task.topicId) : "/study-plan",
        }))
      : fallbackDailyItems(syllabusMap);

  return {
    studentName: input.studentName,
    curriculum: input.curriculum,
    gradeLevel: input.gradeLevel,
    readiness: {
      score: readinessScore,
      label: readinessLabel,
      description: descriptionFromReadiness(readinessLabel),
      predictedGrade: input.predictedGrade,
    },
    syllabusMap,
    dailyPlan: {
      title: activePlan?.title ?? "Today's KCSE maths repair",
      dailyGoalMinutes: activePlan?.dailyGoalMinutes ?? 25,
      items: dailyItems,
      planHref: "/study-plan",
    },
    practiceLinks: {
      kcseStyle: {
        label: "Start KCSE-style maths practice",
        href: "/exam-prep?subject=mathematics&style=kcse_style",
      },
      topicDrill: {
        label: "Drill weak maths topics",
        href: "/practice",
      },
    },
    weakTopicRepair,
    trustSummary: {
      schoolReadySignal: `KCSE maths readiness: ${readinessLabel} at ${readinessScore}%.`,
      parentPricingSignal: "Free daily text revision works before paid add-ons.",
      chatPrivacy: "Tutor chat text stays private; parents see progress signals only.",
    },
    lowDataMode: {
      tips: [
        "Keep revision text-first and avoid video-heavy flows.",
        "Use compact practice and return to the same weak topic later.",
        "Resume from saved plans instead of restarting the session after refresh.",
      ],
    },
  };
}
