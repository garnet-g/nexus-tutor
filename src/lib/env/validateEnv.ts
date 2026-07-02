import { formatEnvValidationErrors, parseEnvSchema } from "./envSchema";
import { resetEnvCacheForTests } from "./providerModes";

export interface EnvValidationResult {
  ok: boolean;
  errors: string[];
}

export function validateEnvironment(
  source: Record<string, string | undefined> = process.env,
): EnvValidationResult {
  resetEnvCacheForTests();

  try {
    parseEnvSchema(source);
    return { ok: true, errors: [] };
  } catch (error) {
    return {
      ok: false,
      errors: formatEnvValidationErrors(error),
    };
  }
}

export function assertEnvironmentValid(
  source: Record<string, string | undefined> = process.env,
): void {
  const result = validateEnvironment(source);
  if (!result.ok) {
    throw new Error(result.errors.join("; "));
  }
}
