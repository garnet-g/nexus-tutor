export const EXAM_PAPER_DURATION_MINUTES = 150;

export function calculateEndsAt(
  startedAt: Date,
  durationMinutes: number = EXAM_PAPER_DURATION_MINUTES,
): Date {
  return new Date(startedAt.getTime() + durationMinutes * 60_000);
}

export function remainingSeconds(endsAt: Date, now: Date = new Date()): number {
  return Math.max(0, Math.floor((endsAt.getTime() - now.getTime()) / 1000));
}

export function isSessionExpired(endsAt: Date, now: Date = new Date()): boolean {
  return now.getTime() >= endsAt.getTime();
}
