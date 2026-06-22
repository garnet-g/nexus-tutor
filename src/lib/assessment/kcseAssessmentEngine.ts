import {
  getKcseSubjectBlueprint,
  type KcseGradingMode,
  type KcsePaperStructure,
  type KcseSubjectBlueprint,
  type KcseSubjectId,
} from "@/lib/assessment/kcseSubjectBlueprints";

export type KcseAssessmentStyle =
  | "kcse_style"
  | "past_paper_style"
  | "timed_simulator"
  | "topic_pattern";

export interface KcseAssessmentQuestion {
  id: string;
  topicId: string;
  topicTitle: string;
  difficulty: "easy" | "medium" | "hard";
  patternTags: string[];
}

export interface KcsePaperTemplate {
  subjectId: KcseSubjectId;
  subjectDisplayName: string;
  paperNumber: number;
  title: string;
  style: KcseAssessmentStyle;
  durationMinutes: number;
  marks: number;
  format: KcsePaperStructure["format"];
  sections: string[];
  calibration?: KcsePaperStructure["calibration"];
  provenance: "original_kcse_style_metadata";
}

export interface KcsePaperMetadata extends KcsePaperTemplate {
  isPreview: boolean;
  questionTarget: number;
  gradingMode: KcseGradingMode;
  patternTags: string[];
  sourcePolicy: KcseSubjectBlueprint["sourcePolicy"];
  contentWarning: string;
}

export interface KcseMarkingFeedbackInput {
  gradingMode: KcseGradingMode;
  isCorrect: boolean;
  earnedMarks?: number;
  maxMarks?: number;
  missingKeywords?: string[];
  rubricBand?: string;
}

export interface KcseMarkingFeedback {
  summary: string;
  markLabel: string | null;
  nextStep: string;
}

export interface KcseTopicPatternSummary {
  topicId: string;
  topicTitle: string;
  selectedCount: number;
  missedCount: number;
  accuracyPercentage: number;
  dominantPatternTags: string[];
  needsRepair: boolean;
}

const PREVIEW_QUESTION_LIMIT = 5;
const FULL_QUESTION_TARGET = 20;

export function resolveKcseSubjectBlueprint(
  subject: string,
): KcseSubjectBlueprint | null {
  return getKcseSubjectBlueprint(subject);
}

export function resolveKcsePaperTemplate(input: {
  subject: string;
  style: KcseAssessmentStyle;
  paperNumber?: number;
}): KcsePaperTemplate | null {
  const blueprint = getKcseSubjectBlueprint(input.subject);
  if (!blueprint) return null;

  const structure =
    blueprint.paperStructures.find(
      (paper) => paper.paperNumber === (input.paperNumber ?? 1),
    ) ?? blueprint.paperStructures[0];

  return {
    subjectId: blueprint.id,
    subjectDisplayName: blueprint.displayName,
    paperNumber: structure.paperNumber,
    title: structure.title,
    style: input.style,
    durationMinutes: structure.durationMinutes,
    marks: structure.marks,
    format: structure.format,
    sections: structure.sectionLabels,
    calibration: structure.calibration,
    provenance: "original_kcse_style_metadata",
  };
}

export function buildKcsePaperMetadata(input: {
  subject: string;
  style: KcseAssessmentStyle;
  paperNumber?: number;
  isPreview: boolean;
}): KcsePaperMetadata {
  const blueprint = getKcseSubjectBlueprint(input.subject);
  const template = resolveKcsePaperTemplate(input);

  if (!blueprint || !template) {
    throw new Error("UNKNOWN_KCSE_SUBJECT");
  }

  return {
    ...template,
    isPreview: input.isPreview,
    questionTarget: input.isPreview ? PREVIEW_QUESTION_LIMIT : FULL_QUESTION_TARGET,
    gradingMode: blueprint.gradingMode,
    patternTags: blueprint.patternTags,
    sourcePolicy: blueprint.sourcePolicy,
    contentWarning: "No copied KNEC paper content is included.",
  };
}

export function buildKcseMarkingFeedback(
  input: KcseMarkingFeedbackInput,
): KcseMarkingFeedback {
  const maxMarks = input.maxMarks ?? 1;
  const earnedMarks = input.earnedMarks ?? (input.isCorrect ? maxMarks : 0);
  const markLabel = input.maxMarks ? `${earnedMarks}/${maxMarks}` : null;

  if (input.gradingMode === "exact") {
    return {
      summary: input.isCorrect
        ? "The answer matches the expected answer."
        : "The answer does not match the expected answer.",
      markLabel,
      nextStep: input.isCorrect
        ? "Move to a harder original question."
        : "Review the expected answer, then retry a similar item.",
    };
  }

  if (input.gradingMode === "keyword") {
    const missing = input.missingKeywords?.filter(Boolean) ?? [];
    return {
      summary: input.isCorrect
        ? "The response includes the expected marking keywords."
        : "The response is missing key marking points.",
      markLabel,
      nextStep:
        missing.length > 0
          ? `Repair the missing points: ${missing.join(", ")}.`
          : "Revise the core definitions and examples for this topic.",
    };
  }

  if (input.gradingMode === "rubric_band") {
    const band = input.rubricBand ?? (input.isCorrect ? "secure" : "developing");
    return {
      summary: `Rubric band: ${band}.`,
      markLabel,
      nextStep: input.isCorrect
        ? "Use a timed prompt to build exam fluency."
        : "Improve structure, examples, and language control before timing.",
    };
  }

  return {
    summary: input.isCorrect
      ? "The working earns the available method and answer marks."
      : "The answer needs stronger working to earn method marks.",
    markLabel,
    nextStep: input.isCorrect
      ? "Continue with mixed exam-style practice."
      : "Repair the working steps, then try a similar structured question.",
  };
}

export function buildTopicPatternSummaries(input: {
  selectedQuestions: KcseAssessmentQuestion[];
  missedQuestionIds: string[];
}): KcseTopicPatternSummary[] {
  const missed = new Set(input.missedQuestionIds);
  const byTopic = new Map<
    string,
    {
      topicTitle: string;
      selectedCount: number;
      missedCount: number;
      tagCounts: Map<string, number>;
    }
  >();

  for (const question of input.selectedQuestions) {
    const entry =
      byTopic.get(question.topicId) ??
      {
        topicTitle: question.topicTitle,
        selectedCount: 0,
        missedCount: 0,
        tagCounts: new Map<string, number>(),
      };

    entry.selectedCount += 1;
    if (missed.has(question.id)) {
      entry.missedCount += 1;
    }
    for (const tag of question.patternTags) {
      entry.tagCounts.set(tag, (entry.tagCounts.get(tag) ?? 0) + 1);
    }
    byTopic.set(question.topicId, entry);
  }

  return [...byTopic.entries()]
    .map(([topicId, entry]) => {
      const correct = entry.selectedCount - entry.missedCount;
      const accuracyPercentage =
        entry.selectedCount > 0
          ? Math.round((correct / entry.selectedCount) * 100)
          : 0;
      return {
        topicId,
        topicTitle: entry.topicTitle,
        selectedCount: entry.selectedCount,
        missedCount: entry.missedCount,
        accuracyPercentage,
        dominantPatternTags: [...entry.tagCounts.entries()]
          .sort((left, right) => right[1] - left[1])
          .map(([tag]) => tag),
        needsRepair: entry.missedCount > 0,
      };
    })
    .sort(
      (left, right) =>
        right.missedCount - left.missedCount ||
        right.selectedCount - left.selectedCount,
    );
}
