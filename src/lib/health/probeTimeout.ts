export const DEFAULT_PROBE_TIMEOUT_MS = 2_500;

export async function runProbeWithTimeout<T>(
  label: string,
  timeoutMs: number,
  probe: () => Promise<T>,
): Promise<{ ok: true; value: T } | { ok: false; error: string }> {
  try {
    const value = await Promise.race([
      probe(),
      new Promise<never>((_, reject) => {
        setTimeout(() => reject(new Error(`${label} timed out after ${timeoutMs}ms`)), timeoutMs);
      }),
    ]);
    return { ok: true, value };
  } catch (error) {
    return {
      ok: false,
      error: error instanceof Error ? error.message : `${label} failed`,
    };
  }
}
