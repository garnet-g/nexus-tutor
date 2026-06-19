import type { NexMode } from "./types";

const EXPLAIN_PATTERNS = [
  /\bexplain\b/i,
  /\bwhat is\b/i,
  /\bwhat are\b/i,
  /\bteach me\b/i,
  /\bhow does\b/i,
  /\bhow do\b/i,
  /\bdefine\b/i,
  /\btell me about\b/i,
];

const PRACTICE_PATTERNS = [
  /\btest me\b/i,
  /\bquiz me\b/i,
  /\bpractice\b/i,
  /\bgive me (?:a )?question/i,
  /\bask me (?:a )?question/i,
];

const REVISION_PATTERNS = [
  /\brevision plan\b/i,
  /\brevise\b/i,
  /\bexam in \d+/i,
  /\bexam is in \d+/i,
  /\bexams in \d+/i,
  /\bexams are in \d+/i,
  /\bstudy plan\b/i,
  /\bprepare for exam\b/i,
  /\bprepare for my exam\b/i,
];

const HOMEWORK_PATTERNS = [
  /\bhelp with this\b/i,
  /\bsolve\b/i,
  /\bfind x\b/i,
  /\bcalculate\b/i,
  /\bwork out\b/i,
  /\b\d+\s*[x×]\s*[\+\-\*\/]/i,
  /\b\d+\s*[+\-]\s*\d+/,
  /= \d+/,
];

export const ASSESSMENT_PATTERNS = [
  /\bassess me\b/i,
  /\btest my understanding\b/i,
  /\bcheck my understanding\b/i,
  /\bquick check\b/i,
  /\bmini assessment\b/i,
  /\bmicro assessment\b/i,
  /\bassessment mode\b/i,
  /\bhow well do i know\b/i,
];

export function isAssessmentRequest(message: string): boolean {
  const trimmed = message.trim();
  return ASSESSMENT_PATTERNS.some((pattern) => pattern.test(trimmed));
}

export function detectNexMode(
  message: string,
  currentMode?: NexMode,
): NexMode {
  const trimmed = message.trim();
  if (!trimmed) {
    return currentMode ?? "homework";
  }

  const scores: Record<NexMode, number> = {
    explain: 0,
    practice: 0,
    homework: 0,
    revision: 0,
    assessment: 0,
  };

  for (const pattern of EXPLAIN_PATTERNS) {
    if (pattern.test(trimmed)) {
      scores.explain += 2;
    }
  }

  for (const pattern of PRACTICE_PATTERNS) {
    if (pattern.test(trimmed)) {
      scores.practice += 2;
    }
  }

  for (const pattern of REVISION_PATTERNS) {
    if (pattern.test(trimmed)) {
      scores.revision += 2;
    }
  }

  for (const pattern of HOMEWORK_PATTERNS) {
    if (pattern.test(trimmed)) {
      scores.homework += 2;
    }
  }

  for (const pattern of ASSESSMENT_PATTERNS) {
    if (pattern.test(trimmed)) {
      scores.assessment += 3;
    }
  }

  if (trimmed.length > 120 && /[=+\-*/^]/.test(trimmed)) {
    scores.homework += 3;
  }

  if (currentMode === "assessment") {
    scores.assessment += 1;
  }

  const ranked = (Object.entries(scores) as [NexMode, number][]).sort(
    (a, b) => b[1] - a[1],
  );

  const [topMode, topScore] = ranked[0];

  if (topScore === 0) {
    return currentMode ?? "homework";
  }

  const [, secondScore] = ranked[1];
  if (topScore === secondScore && currentMode) {
    return currentMode;
  }

  return topMode;
}

export function isLikelyHomeworkProblem(message: string): boolean {
  return (
    detectNexMode(message) === "homework" &&
    HOMEWORK_PATTERNS.some((p) => p.test(message))
  );
}

export function isAnswerShortcutRequest(message: string): boolean {
  return /\b(just give me|give me) the answer\b/i.test(message);
}

// Patterns for common Kenyan curriculum math misconceptions
const MISCONCEPTION_PATTERNS: Array<{ pattern: RegExp; code: string }> = [
  // Classic 1/2 + 1/3 = 2/5 (specific case first for precedence)
  {
    pattern: /\b1\/2\s*\+\s*1\/3\s*=\s*2\/5\b/i,
    code: "fraction_addition_denominators",
  },
  // General fraction add/subtract with naive numerator+denominator operation
  {
    pattern: /\b\d+\s*\/\s*\d+\s*[+\-]\s*\d+\s*\/\s*\d+\s*=\s*\d+\s*\/\s*\d+/i,
    code: "fraction_addition_denominators",
  },
  // Negative × negative = negative error: -3 × -3 = -9 or -3 * -3 = -9
  {
    pattern: /-\s*\d+\s*[×x*]\s*-\s*\d+\s*=\s*-\s*\d+/i,
    code: "negative_multiplication",
  },
  // Squaring a binomial naively: (a+b)² = a²+b² (missing 2ab)
  {
    pattern: /\(\s*\w+\s*[+\-]\s*\w+\s*\)\s*[\^²]\s*2?\s*=\s*\w+\s*[\^²]\s*2?\s*[+\-]\s*\w+\s*[\^²]\s*2?/i,
    code: "binomial_square_expansion",
  },
  // Percentage unit confusion: 10% of 50 = 5% (writing % in the answer instead of value)
  {
    pattern: /\d+\s*%\s*of\s*\d+\s*=\s*\d+\s*%/i,
    code: "percentage_unit_confusion",
  },
  // Multiplying both sides of a fraction incorrectly: cross-multiplying to add
  {
    pattern: /\b\d+\s*\/\s*\d+\s*\+\s*\d+\s*\/\s*\d+\s*=\s*\d+\s*\/\s*\d+\b/i,
    code: "fraction_addition_denominators",
  },
];

export function isLikelyMisconception(message: string): boolean {
  return MISCONCEPTION_PATTERNS.some(({ pattern }) => pattern.test(message));
}

export function misconceptionCodeFromMessage(message: string): string | null {
  for (const { pattern, code } of MISCONCEPTION_PATTERNS) {
    if (pattern.test(message)) {
      return code;
    }
  }
  return null;
}

export function isStudentAttempt(message: string): boolean {
  const trimmed = message.trim();
  if (!trimmed || isAnswerShortcutRequest(trimmed)) {
    return false;
  }

  if (
    /\b(hint|help|stuck|don't know|dont know|not sure)\b/i.test(trimmed) &&
    !/^x\s*=\s*[-+]?\d+/i.test(trimmed) &&
    !/^[-+]?\d+(\.\d+)?$/.test(trimmed)
  ) {
    return false;
  }

  return (
    /^x\s*=\s*[-+]?\d+/i.test(trimmed) ||
    /^[-+]?\d+(\.\d+)?$/.test(trimmed) ||
    /\bbecause\b/i.test(trimmed) ||
    /\bi think\b/i.test(trimmed) ||
    /\bmy answer\b/i.test(trimmed) ||
    trimmed.length >= 8
  );
}
