import {
  isAnswerShortcutRequest,
  isLikelyMisconception,
  isStudentAttempt,
} from "./detectNexMode";
import {
  DEFAULT_ASSESSMENT_QUESTION_COUNT,
  DEFAULT_NEX_SESSION_METADATA,
  type HintLevel,
  type NexSessionMetadata,
} from "./types";

const MAX_HINTS_BEFORE_LEVEL_4 = 3;

export function parseSessionMetadata(
  metadata: Record<string, unknown> | null | undefined,
): NexSessionMetadata {
  if (!metadata || typeof metadata !== "object") {
    return { ...DEFAULT_NEX_SESSION_METADATA };
  }

  const hintLevel = metadata.hintLevel;
  const hintCount = metadata.hintCount;
  const attemptCount = metadata.attemptCount;

  return {
    hintLevel: isHintLevel(hintLevel) ? hintLevel : 1,
    hintCount: typeof hintCount === "number" ? hintCount : 0,
    attemptCount: typeof attemptCount === "number" ? attemptCount : 0,
    misconceptionDetected: Boolean(metadata.misconceptionDetected),
    difficulty:
      metadata.difficulty === "easy" ||
      metadata.difficulty === "medium" ||
      metadata.difficulty === "hard"
        ? metadata.difficulty
        : "medium",
    consecutiveCorrect:
      typeof metadata.consecutiveCorrect === "number"
        ? metadata.consecutiveCorrect
        : 0,
    consecutiveIncorrect:
      typeof metadata.consecutiveIncorrect === "number"
        ? metadata.consecutiveIncorrect
        : 0,
    examCountdownDays:
      typeof metadata.examCountdownDays === "number"
        ? metadata.examCountdownDays
        : undefined,
    dailyGoalMinutes:
      typeof metadata.dailyGoalMinutes === "number"
        ? metadata.dailyGoalMinutes
        : undefined,
    questionIndex:
      typeof metadata.questionIndex === "number" ? metadata.questionIndex : 0,
    correctCount:
      typeof metadata.correctCount === "number" ? metadata.correctCount : 0,
    assessmentStatus:
      metadata.assessmentStatus === "completed" ||
      metadata.assessmentStatus === "in_progress"
        ? metadata.assessmentStatus
        : undefined,
    assessmentQuestionCount:
      typeof metadata.assessmentQuestionCount === "number"
        ? metadata.assessmentQuestionCount
        : DEFAULT_ASSESSMENT_QUESTION_COUNT,
  };
}

function isHintLevel(value: unknown): value is HintLevel {
  return value === 1 || value === 2 || value === 3 || value === 4;
}

export function updateAssessmentState(
  metadata: NexSessionMetadata,
  studentMessage: string,
): NexSessionMetadata {
  const next: NexSessionMetadata = {
    ...metadata,
    assessmentStatus: metadata.assessmentStatus ?? "in_progress",
    questionIndex: metadata.questionIndex ?? 0,
    correctCount: metadata.correctCount ?? 0,
    assessmentQuestionCount:
      metadata.assessmentQuestionCount ?? DEFAULT_ASSESSMENT_QUESTION_COUNT,
  };

  if (next.assessmentStatus === "completed") {
    return next;
  }

  if (isStudentAttempt(studentMessage)) {
    if (!isLikelyMisconception(studentMessage)) {
      next.correctCount = (next.correctCount ?? 0) + 1;
    }

    const answeredCount = (next.questionIndex ?? 0) + 1;
    next.questionIndex = answeredCount;

    if (answeredCount >= (next.assessmentQuestionCount ?? DEFAULT_ASSESSMENT_QUESTION_COUNT)) {
      next.assessmentStatus = "completed";
    }
  }

  return next;
}

export function updateSocraticState(
  metadata: NexSessionMetadata,
  studentMessage: string,
  sessionMode: string,
): NexSessionMetadata {
  let next: NexSessionMetadata = { ...metadata };

  if (sessionMode === "homework" || sessionMode === "assessment") {
    if (isLikelyMisconception(studentMessage)) {
      next.misconceptionDetected = true;
    }
  }

  if (sessionMode === "assessment") {
    return updateAssessmentState(next, studentMessage);
  }

  if (sessionMode === "practice") {
    if (!isStudentAttempt(studentMessage)) {
      return next;
    }

    if (isLikelyMisconception(studentMessage)) {
      next.consecutiveIncorrect = (next.consecutiveIncorrect ?? 0) + 1;
      next.consecutiveCorrect = 0;
      if ((next.consecutiveIncorrect ?? 0) >= 2) {
        next.difficulty = "easy";
      }
      return next;
    }

    next.consecutiveCorrect = (next.consecutiveCorrect ?? 0) + 1;
    next.consecutiveIncorrect = 0;
    if ((next.consecutiveCorrect ?? 0) >= 2) {
      next.difficulty = next.difficulty === "easy" ? "medium" : "hard";
    }
    return next;
  }

  if (sessionMode !== "homework") {
    return next;
  }

  if (isStudentAttempt(studentMessage)) {
    next.attemptCount += 1;
  }

  if (
    isAnswerShortcutRequest(studentMessage) ||
    /\b(hint|help|stuck|don't know|dont know)\b/i.test(studentMessage)
  ) {
    next = escalateHintLevel(next);
  }

  if (next.attemptCount === 0 && isAnswerShortcutRequest(studentMessage)) {
    next.hintLevel = 1;
  }

  return next;
}

export function escalateHintLevel(
  metadata: NexSessionMetadata,
): NexSessionMetadata {
  const next = { ...metadata };

  if (next.hintCount >= MAX_HINTS_BEFORE_LEVEL_4 && next.attemptCount >= 3) {
    next.hintLevel = 4;
    return next;
  }

  if (next.hintLevel < 3) {
    next.hintLevel = (next.hintLevel + 1) as HintLevel;
  } else if (next.attemptCount >= 3) {
    next.hintLevel = 4;
  }

  next.hintCount = Math.min(next.hintCount + 1, MAX_HINTS_BEFORE_LEVEL_4);

  return next;
}

export function recordHintDelivered(
  metadata: NexSessionMetadata,
): NexSessionMetadata {
  return {
    ...metadata,
    hintCount: Math.min(metadata.hintCount + 1, MAX_HINTS_BEFORE_LEVEL_4),
  };
}

export function canRevealFullSolution(metadata: NexSessionMetadata): boolean {
  return (
    metadata.attemptCount >= 3 &&
    metadata.hintCount >= MAX_HINTS_BEFORE_LEVEL_4 &&
    metadata.hintLevel >= 3
  );
}

export function getHintEscalationOverlay(hintLevel: HintLevel): string {
  return [
    "HINT ESCALATION — Current Level: {hintLevel} of 4",
    "",
    "Reveal ONLY the current hint level. Do not skip levels. Do not combine levels in one message.",
    "",
    "Level 1 — Very subtle:",
    '- Nudge thinking direction only',
    '- Example: "Think about what operation is happening first."',
    "- Do NOT mention specific steps or numbers yet",
    "",
    "Level 2 — Moderate guidance:",
    "- Point toward the next strategic move without solving",
    '- Example: "What would happen if we subtracted five from both sides?"',
    "- Do NOT state the result of that operation",
    "",
    "Level 3 — Strong guidance:",
    "- Show a partial step, stop before the final answer",
    '- Example: "Subtracting five from both sides gives: 3x = 15. What should happen next?"',
    "- Do NOT state the final answer",
    "",
    "Level 4 — Full solution:",
    "- Only when hintLevel = 4 AND attemptCount >= 3",
    "- Provide complete step-by-step solution",
    '- End with: "Can you explain why this works in your own words?" (confirm mastery)',
    "",
    "If the student has not attempted the problem, reset to Level 1 regardless of request.",
  ]
    .join("\n")
    .replaceAll("{hintLevel}", String(hintLevel));
}

export function getMisconceptionOverlay(commonErrors: string[]): string {
  const errorsLine =
    commonErrors.length > 0
      ? `Reference known repeated errors from student memory when available: ${commonErrors.join(", ")}`
      : "";

  return [
    "MISCONCEPTION DETECTED — Apply this framework:",
    "",
    'Do NOT say "Wrong." or "Incorrect." as your opening.',
    "",
    "Step 1 — Acknowledge thinking:",
    '"I see your thinking." / "That\'s a common approach."',
    "",
    "Step 2 — Name the misconception pattern (internally) and test it with the student:",
    "- Knowledge gap: missing prerequisite concept",
    "- Procedural gap: knows concept but wrong steps",
    "- Conceptual misunderstanding: consistent wrong mental model",
    "",
    "Step 3 — Test the idea with a simpler case:",
    '"If [simpler parallel example], what answer would your method give? Does that seem correct?"',
    "",
    "Step 4 — Guide toward correction using questions — not lecture",
    "",
    errorsLine,
    "",
    "Step 5 — After correction, confirm mastery:",
    "Ask the student to solve a similar problem independently.",
  ]
    .filter(Boolean)
    .join("\n");
}

export function buildSocraticOverlays(input: {
  sessionMode: string;
  metadata: NexSessionMetadata;
  misconceptionDetected: boolean;
  commonErrors?: string[];
}): string[] {
  const overlays: string[] = [];

  if (input.sessionMode === "homework") {
    overlays.push(getHintEscalationOverlay(input.metadata.hintLevel));

    if (!canRevealFullSolution(input.metadata)) {
      overlays.push(
        "IMPORTANT: Do NOT provide the final answer yet. The student has not earned Level 4 guidance.",
      );
    }
  }

  if (input.sessionMode === "assessment") {
    overlays.push(
      "ASSESSMENT STATE:",
      `- Question index: ${input.metadata.questionIndex ?? 0}`,
      `- Correct count: ${input.metadata.correctCount ?? 0}`,
      `- Status: ${input.metadata.assessmentStatus ?? "in_progress"}`,
      "",
      "Ask one focused question at a time. Do NOT reveal full solutions before the student attempts.",
    );

    if (input.metadata.assessmentStatus === "completed") {
      overlays.push(
        "Assessment complete — summarize strengths, gaps, and one recommended next step.",
      );
    }
  }

  if (input.misconceptionDetected) {
    overlays.push(getMisconceptionOverlay(input.commonErrors ?? []));
  }

  return overlays;
}
