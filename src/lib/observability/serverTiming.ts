import "server-only";

const budgets = new Map<string, number>();

export function recordServerTiming(label: string, durationMs: number): void {
  budgets.set(label, durationMs);
}

export function getServerTimingHeader(): string | null {
  if (budgets.size === 0) {
    return null;
  }

  return [...budgets.entries()]
    .map(([label, duration]) => `${label};dur=${duration.toFixed(1)}`)
    .join(", ");
}

export function clearServerTiming(): void {
  budgets.clear();
}

export const SERVER_TIMING_BUDGET_MS = 800;

export function isWithinServerTimingBudget(durationMs: number): boolean {
  return durationMs <= SERVER_TIMING_BUDGET_MS;
}

export async function measureServerPhase<T>(
  label: string,
  fn: () => Promise<T>,
): Promise<{ value: T; durationMs: number }> {
  const start = performance.now();
  const value = await fn();
  const durationMs = performance.now() - start;
  recordServerTiming(label, durationMs);
  return { value, durationMs };
}
