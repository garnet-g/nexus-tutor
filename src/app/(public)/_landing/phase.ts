/**
 * Map scene progress (0..1) onto a local window so per-element timing reads
 * as one expression: phase(p, 0.2, 0.5) is 0 before 20% of the scene, 1
 * after 50%, and linear in between.
 */
export function phase(p: number, start: number, end: number): number {
  if (end <= start) return p >= end ? 1 : 0;
  return Math.min(1, Math.max(0, (p - start) / (end - start)));
}
