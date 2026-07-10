export function parseFormLevel(gradeLevel: string): number {
  const match = gradeLevel.match(/form\s*([1-4])/i);
  if (!match) {
    throw new Error(`Cannot parse form level from grade "${gradeLevel}"`);
  }
  return Number.parseInt(match[1], 10);
}
