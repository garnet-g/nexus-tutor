export interface TemplateParamDef {
  name: string;
  min: number;
  max: number;
  step?: number;
}

export function mulberry32(seed: number): () => number {
  let state = seed;
  return function rng(): number {
    state |= 0;
    state = (state + 0x6d2b79f5) | 0;
    let t = Math.imul(state ^ (state >>> 15), 1 | state);
    t = (t + Math.imul(t ^ (t >>> 7), 61 | t)) ^ t;
    return ((t ^ (t >>> 14)) >>> 0) / 4294967296;
  };
}

export function sampleParams(
  defs: TemplateParamDef[],
  rng: () => number,
): Record<string, number> {
  const params: Record<string, number> = {};

  for (const def of defs) {
    const step = def.step ?? 1;
    if (step <= 0) {
      throw new Error(`Param "${def.name}" has a non-positive step`);
    }

    const stepsCount = Math.floor((def.max - def.min) / step) + 1;
    if (stepsCount <= 0) {
      throw new Error(`Param "${def.name}" has an empty range (min ${def.min}, max ${def.max})`);
    }

    const index = Math.min(Math.floor(rng() * stepsCount), stepsCount - 1);
    params[def.name] = def.min + index * step;
  }

  return params;
}
