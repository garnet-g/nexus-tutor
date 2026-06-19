export const MAX_COMMON_ERRORS = 20;

export function mergeCommonErrors(
  existing: string[],
  addition: string,
): string[] {
  const normalized = addition.trim();
  if (!normalized) {
    return existing;
  }

  const merged = [...existing];
  const exists = merged.some(
    (entry) => entry.toLowerCase() === normalized.toLowerCase(),
  );

  if (!exists) {
    merged.push(normalized);
  }

  return merged.slice(-MAX_COMMON_ERRORS);
}

export function describeMisconception(errorCode: string): string {
  switch (errorCode) {
    case "fraction_addition_denominators":
      return "Adds fractions by combining numerators and denominators without finding a common denominator";
    default:
      return errorCode.replaceAll("_", " ");
  }
}
