export interface LevelInfo {
  level: number;
  intoLevel: number;
  levelSize: number;
  progress: number; // 0..1 toward next level
}

const LEVEL_SIZE = 100;

/** Simple, predictable XP curve: one level per 100 XP. */
export function levelFromXp(totalXp: number): LevelInfo {
  const safeXp = Math.max(0, Math.floor(totalXp));
  const level = Math.floor(safeXp / LEVEL_SIZE) + 1;
  const intoLevel = safeXp % LEVEL_SIZE;
  return {
    level,
    intoLevel,
    levelSize: LEVEL_SIZE,
    progress: intoLevel / LEVEL_SIZE,
  };
}

/**
 * Represent a streak as the most recent N active days across a 5-week grid.
 * Uses data we actually have (the current streak) rather than fabricating a
 * full history. Returns 35 booleans, oldest first.
 */
export function streakToGrid(currentStreak: number, weeks = 5): boolean[] {
  const total = weeks * 7;
  const active = Math.min(Math.max(0, currentStreak), total);
  return Array.from({ length: total }, (_, index) => index >= total - active);
}
