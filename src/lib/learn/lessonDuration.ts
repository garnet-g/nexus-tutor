/** Cap client-reported lesson time using estimated minutes (max 2× estimate, floor 60s). */
export function resolveLessonStudyDurationSeconds(
  clientSeconds: number | undefined,
  estimatedMinutes: number,
): number {
  const estimatedSeconds = Math.max(60, estimatedMinutes * 60);
  const cap = estimatedSeconds * 2;
  const raw =
    clientSeconds !== undefined && clientSeconds > 0
      ? clientSeconds
      : estimatedSeconds;

  return Math.min(Math.max(0, raw), cap);
}
