import { instantiateTemplate, type ExamPaperTemplateBody } from "./templateInstantiation";
import { mulberry32 } from "./paramSampler";

export interface TemplateValidationResult {
  ok: boolean;
  errors: string[];
}

const FUZZ_SAMPLES = 100;

export function validateTemplateBody(body: ExamPaperTemplateBody): TemplateValidationResult {
  const errors: string[] = [];

  if (body.parts.length === 0) {
    errors.push("Template must have at least one part");
    return { ok: false, errors };
  }

  for (let seed = 1; seed <= FUZZ_SAMPLES; seed += 1) {
    try {
      const instantiated = instantiateTemplate(body, mulberry32(seed));
      for (const part of instantiated.parts) {
        if (part.answerType === "numeric" && !Number.isFinite(Number.parseFloat(part.computedAnswer))) {
          errors.push(`Seed ${seed}: part "${part.label}" produced a non-finite answer "${part.computedAnswer}"`);
          break;
        }
      }
    } catch (error) {
      errors.push(`Seed ${seed}: ${error instanceof Error ? error.message : String(error)}`);
      break;
    }
    if (errors.length > 0) break;
  }

  return { ok: errors.length === 0, errors };
}
