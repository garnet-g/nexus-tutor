import type { Curriculum } from "@/types/database";

export type StudyTaskType = "lesson" | "practice" | "revision";

export interface StudyPlanTopicInput {
  topicId: string;
  title: string;
  masteryPercentage: number;
}

export interface StudyPlanEngineInput {
  studentId: string;
  curriculum: Curriculum;
  gradeLevel: string;
  healthScore: number;
  weakTopics: StudyPlanTopicInput[];
  topicMastery: Record<string, number>;
  examCountdownDays?: number;
  dailyGoalMinutes?: number;
  targetCompletionDate?: string;
}

export interface GeneratedStudyTask {
  topicId: string | null;
  taskTitle: string;
  taskType: StudyTaskType;
  scheduledDate: string;
  dailyGoalMinutes: number;
  estimatedMinutes: number;
}

export interface GeneratedStudyPlan {
  title: string;
  planType: "daily" | "exam";
  examCountdownDays?: number;
  targetCompletionDate?: string;
  tasks: GeneratedStudyTask[];
}

const KCSE_EXAM_WEIGHTS: Record<string, number> = {
  algebra: 0.35,
  trigonometry: 0.25,
  statistics: 0.2,
  geometry: 0.2,
};

function getNairobiDateString(date = new Date()): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
  }).format(date);
}

function addDays(dateString: string, days: number): string {
  const date = new Date(`${dateString}T12:00:00`);
  date.setDate(date.getDate() + days);
  return getNairobiDateString(date);
}

function sortWeakTopics(topics: StudyPlanTopicInput[]): StudyPlanTopicInput[] {
  return [...topics].sort(
    (left, right) => left.masteryPercentage - right.masteryPercentage,
  );
}

function allocateDailyTasks(
  topics: StudyPlanTopicInput[],
  scheduledDate: string,
  dailyGoalMinutes: number,
): GeneratedStudyTask[] {
  const prioritized = sortWeakTopics(topics).slice(0, 2);
  const tasks: GeneratedStudyTask[] = [];
  let remainingMinutes = dailyGoalMinutes;

  for (const topic of prioritized) {
    if (remainingMinutes <= 0) {
      break;
    }

    const lessonMinutes = Math.min(10, remainingMinutes);
    tasks.push({
      topicId: topic.topicId,
      taskTitle: `Complete a lesson on ${topic.title}`,
      taskType: "lesson",
      scheduledDate,
      dailyGoalMinutes,
      estimatedMinutes: lessonMinutes,
    });
    remainingMinutes -= lessonMinutes;

    if (remainingMinutes <= 0) {
      break;
    }

    const practiceMinutes = Math.min(10, remainingMinutes);
    tasks.push({
      topicId: topic.topicId,
      taskTitle: `Practice 10 questions on ${topic.title}`,
      taskType: "practice",
      scheduledDate,
      dailyGoalMinutes,
      estimatedMinutes: practiceMinutes,
    });
    remainingMinutes -= practiceMinutes;
  }

  if (tasks.length === 0 && topics[0]) {
    tasks.push({
      topicId: topics[0].topicId,
      taskTitle: `Review ${topics[0].title} with Nex`,
      taskType: "revision",
      scheduledDate,
      dailyGoalMinutes,
      estimatedMinutes: dailyGoalMinutes,
    });
  }

  return tasks;
}

export function generateDailyStudyPlan(
  input: StudyPlanEngineInput,
): GeneratedStudyPlan {
  const today = getNairobiDateString();
  const dailyGoalMinutes = input.dailyGoalMinutes ?? 20;
  const weakTopics =
    input.weakTopics.length > 0
      ? input.weakTopics
      : Object.entries(input.topicMastery).map(([topicId, masteryPercentage]) => ({
          topicId,
          title: topicId,
          masteryPercentage,
        }));

  return {
    title: "Today's study plan",
    planType: "daily",
    tasks: allocateDailyTasks(weakTopics, today, dailyGoalMinutes),
  };
}

export function generateExamStudyPlan(
  input: StudyPlanEngineInput,
): GeneratedStudyPlan {
  const examCountdownDays = input.examCountdownDays ?? 14;
  const dailyGoalMinutes = input.dailyGoalMinutes ?? 20;
  const startDate = getNairobiDateString();
  const targetCompletionDate =
    input.targetCompletionDate ?? addDays(startDate, examCountdownDays - 1);

  const rankedTopics = sortWeakTopics(input.weakTopics).map((topic) => {
    const code = topic.title.toLowerCase();
    const examWeight =
      input.curriculum === "KCSE"
        ? KCSE_EXAM_WEIGHTS[code] ?? 0.15
        : 0.25;

    return {
      ...topic,
      priority: (1 - topic.masteryPercentage / 100) * examWeight,
    };
  });

  rankedTopics.sort((left, right) => right.priority - left.priority);

  const frontLoadDays = Math.max(1, Math.floor(examCountdownDays * 0.6));
  const revisionDays = Math.max(1, Math.floor(examCountdownDays * 0.2));
  const tasks: GeneratedStudyTask[] = [];

  for (let day = 0; day < examCountdownDays; day += 1) {
    const scheduledDate = addDays(startDate, day);
    const isRevisionWindow = day >= examCountdownDays - revisionDays;

    if (isRevisionWindow) {
      tasks.push({
        topicId: null,
        taskTitle: "Mixed revision practice",
        taskType: "revision",
        scheduledDate,
        dailyGoalMinutes,
        estimatedMinutes: dailyGoalMinutes,
      });
      continue;
    }

    const topic =
      rankedTopics[day % Math.max(rankedTopics.length, 1)] ??
      input.weakTopics[0];

    if (!topic) {
      continue;
    }

    const taskType: StudyTaskType =
      day < frontLoadDays ? "practice" : "lesson";

    tasks.push({
      topicId: topic.topicId,
      taskTitle:
        taskType === "practice"
          ? `Exam prep practice: ${topic.title}`
          : `Review lesson: ${topic.title}`,
      taskType,
      scheduledDate,
      dailyGoalMinutes,
      estimatedMinutes: dailyGoalMinutes,
    });
  }

  return {
    title: `${examCountdownDays}-day exam study plan`,
    planType: "exam",
    examCountdownDays,
    targetCompletionDate,
    tasks,
  };
}

export function generateStudyPlan(
  input: StudyPlanEngineInput,
): GeneratedStudyPlan {
  if (input.examCountdownDays && input.examCountdownDays > 0) {
    return generateExamStudyPlan(input);
  }

  return generateDailyStudyPlan(input);
}
