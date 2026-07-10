export type PartAnswerType = "numeric" | "short_answer";

export interface AnswerKeyPart {
  sessionQuestionId: string;
  partLabel: string;
  topicId: string;
  marks: number;
  answerType: PartAnswerType;
  computedAnswer: string;
  tolerance: number;
}

export interface StudentPartAnswer {
  sessionQuestionId: string;
  partLabel: string;
  studentAnswer: string;
}

export interface AutoMarkedPart {
  sessionQuestionId: string;
  partLabel: string;
  topicId: string;
  marks: number;
  isCorrect: boolean;
  autoMarks: number;
}

function normalizeShortAnswer(value: string): string {
  return value.trim().toLowerCase().replace(/\s+/g, " ");
}

function partKey(sessionQuestionId: string, partLabel: string): string {
  return `${sessionQuestionId}::${partLabel}`;
}

export function autoMarkExamPaperAnswers(
  answerKey: AnswerKeyPart[],
  studentAnswers: StudentPartAnswer[],
): AutoMarkedPart[] {
  const answersByKey = new Map(
    studentAnswers.map((answer) => [partKey(answer.sessionQuestionId, answer.partLabel), answer.studentAnswer]),
  );

  return answerKey.map((part) => {
    const studentAnswer = answersByKey.get(partKey(part.sessionQuestionId, part.partLabel));
    let isCorrect = false;

    if (studentAnswer !== undefined && studentAnswer.trim().length > 0) {
      if (part.answerType === "numeric") {
        const studentValue = Number.parseFloat(studentAnswer);
        const correctValue = Number.parseFloat(part.computedAnswer);
        isCorrect =
          Number.isFinite(studentValue) && Math.abs(studentValue - correctValue) <= part.tolerance;
      } else {
        isCorrect = normalizeShortAnswer(studentAnswer) === normalizeShortAnswer(part.computedAnswer);
      }
    }

    return {
      sessionQuestionId: part.sessionQuestionId,
      partLabel: part.partLabel,
      topicId: part.topicId,
      marks: part.marks,
      isCorrect,
      autoMarks: isCorrect ? part.marks : 0,
    };
  });
}

export interface SelfMarkClaim {
  sessionQuestionId: string;
  partLabel: string;
  claimedMethodMarks: number;
}

export interface MarkedPart extends AutoMarkedPart {
  selfAwardedMethodMarks: number;
  totalMarks: number;
}

export function applySelfMarkedMethodMarks(
  autoMarked: AutoMarkedPart[],
  claims: SelfMarkClaim[],
): MarkedPart[] {
  const claimsByKey = new Map(
    claims.map((claim) => [partKey(claim.sessionQuestionId, claim.partLabel), claim.claimedMethodMarks]),
  );

  return autoMarked.map((part) => {
    const cap = part.marks - part.autoMarks;
    const claimed = claimsByKey.get(partKey(part.sessionQuestionId, part.partLabel)) ?? 0;
    const selfAwardedMethodMarks = Math.max(0, Math.min(claimed, cap));

    return {
      ...part,
      selfAwardedMethodMarks,
      totalMarks: part.autoMarks + selfAwardedMethodMarks,
    };
  });
}

export interface ExamPaperScoreSummary {
  totalPossibleMarks: number;
  verifiedMarks: number;
  selfAwardedMarks: number;
  combinedMarks: number;
  percentage: number;
}

export function composeExamPaperScore(parts: MarkedPart[]): ExamPaperScoreSummary {
  const totalPossibleMarks = parts.reduce((sum, part) => sum + part.marks, 0);
  const verifiedMarks = parts.reduce((sum, part) => sum + part.autoMarks, 0);
  const selfAwardedMarks = parts.reduce((sum, part) => sum + part.selfAwardedMethodMarks, 0);
  const combinedMarks = verifiedMarks + selfAwardedMarks;

  return {
    totalPossibleMarks,
    verifiedMarks,
    selfAwardedMarks,
    combinedMarks,
    percentage: totalPossibleMarks > 0 ? Math.round((combinedMarks / totalPossibleMarks) * 100) : 0,
  };
}

export interface TopicVerifiedResult {
  topicId: string;
  correct: number;
  total: number;
}

export function buildVerifiedTopicResults(autoMarked: AutoMarkedPart[]): TopicVerifiedResult[] {
  const byTopic = new Map<string, { correct: number; total: number }>();

  for (const part of autoMarked) {
    const entry = byTopic.get(part.topicId) ?? { correct: 0, total: 0 };
    entry.total += 1;
    if (part.isCorrect) entry.correct += 1;
    byTopic.set(part.topicId, entry);
  }

  return [...byTopic.entries()].map(([topicId, { correct, total }]) => ({ topicId, correct, total }));
}
