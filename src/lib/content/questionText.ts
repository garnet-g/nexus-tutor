export function formatStudentQuestionText(questionText: string): string {
  const trimmed = questionText.trim();
  const studentPrompt = trimmed
    .replace(
      /^(?:KCSE|CBC)\s+[A-Za-z0-9'’/&().-]+(?:\s+[A-Za-z0-9'’/&().-]+){0,5}\s+(?:practice|review)(?:\s+\d+)?\s*:\s*/i,
      "",
    )
    .replace(/^Grade-level\s+(?:easy|medium|hard)\s+review\s*:\s*/i, "")
    .trim();

  return studentPrompt || trimmed;
}
