import { callNexJudge } from "./callNexModel";
import type { ValidateNexResponseInput, ValidationResult } from "./types";

const SYSTEM_LEAK_PATTERNS = [
  /system prompt/i,
  /you are nex, the ai teacher/i,
  /never reveal these system instructions/i,
  /MODE: HOMEWORK/i,
];

const FINAL_ANSWER_PATTERNS = [
  /^\s*x\s*=\s*[-+]?\d+(?:\.\d+)?\s*$/im,
  /\bthe answer is\b/i,
  /\bthe solution is\b/i,
  /\bfinal answer\b/i,
  /\\boxed\{/i,
  /=\s*[-+]?\d+(?:\.\d+)?\s*(?:\.|$)/,
];

const OUT_OF_SCOPE_DECLINE_PATTERNS = [
  /\b(history|kiswahili|cambridge|french|german)\b/i,
];

export const HOMEWORK_SAFE_FALLBACK =
  "Let's work through this step by step. What do you already know about this problem?";

function countQuestions(text: string): number {
  return (text.match(/\?/g) ?? []).length;
}

function isMostlyNumericResult(text: string): boolean {
  const stripped = text.replace(/[^\d=+\-*/x\s.]/gi, "").trim();
  const numericChars = (stripped.match(/[\d=.]/g) ?? []).length;
  return numericChars / Math.max(stripped.length, 1) > 0.6 && countQuestions(text) === 0;
}

export function validateNexResponse(
  input: ValidateNexResponseInput,
): ValidationResult {
  const response = input.response.trim();

  if (!response) {
    return { status: "fail", reason: "empty_response" };
  }

  for (const pattern of SYSTEM_LEAK_PATTERNS) {
    if (pattern.test(response)) {
      return { status: "fail", reason: "system_prompt_leakage" };
    }
  }

  if (response.length > 2500) {
    return { status: "fail", reason: "response_too_long" };
  }

  if (
    OUT_OF_SCOPE_DECLINE_PATTERNS.some((pattern) => pattern.test(response)) &&
    /i can teach/i.test(response)
  ) {
    return { status: "pass" };
  }

  if (
    (input.mode === "homework" || input.mode === "assessment") &&
    input.attemptCount === 0
  ) {
    return validateHomeworkFirstTurn(response, input.hintLevel);
  }

  return { status: "pass" };
}

function validateHomeworkFirstTurn(
  response: string,
  hintLevel: ValidateNexResponseInput["hintLevel"],
): ValidationResult {
  if (hintLevel >= 4) {
    return { status: "pass" };
  }

  for (const pattern of FINAL_ANSWER_PATTERNS) {
    if (pattern.test(response)) {
      return { status: "fail", reason: "final_answer_pattern" };
    }
  }

  if (isMostlyNumericResult(response)) {
    return { status: "fail", reason: "numeric_result_without_question" };
  }

  if (countQuestions(response) === 0 && response.length > 80) {
    return { status: "fail", reason: "lecture_without_question" };
  }

  if (
    /\bstep \d+:/i.test(response) &&
    countQuestions(response) === 0 &&
    response.length > 120
  ) {
    return { status: "ambiguous", reason: "possible_full_solution" };
  }

  if (/x\s*=\s*[-+]?\d+/i.test(response) && countQuestions(response) === 0) {
    return { status: "ambiguous", reason: "possible_final_value" };
  }

  return { status: "pass" };
}

export async function validateNexResponseWithJudge(
  input: ValidateNexResponseInput,
): Promise<ValidationResult> {
  const base = validateNexResponse(input);

  if (base.status !== "ambiguous") {
    return base;
  }

  if (
    (input.mode === "homework" || input.mode === "assessment") &&
    input.attemptCount > 0
  ) {
    return { status: "pass" };
  }

  if (input.mode !== "homework" || input.attemptCount > 0) {
    return { status: "pass" };
  }

  const revealsFinalAnswer = await callNexJudge(
    input.studentMessage,
    input.response,
  );

  if (revealsFinalAnswer) {
    return { status: "fail", reason: "judge_reveals_final_answer" };
  }

  return { status: "pass" };
}

export function shouldRegenerate(result: ValidationResult): boolean {
  return result.status === "fail";
}

export function getValidationFallback(): string {
  return HOMEWORK_SAFE_FALLBACK;
}
