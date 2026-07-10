import { evaluateExpression } from "./expressionEvaluator";
import { sampleParams, type TemplateParamDef } from "./paramSampler";

export type TemplateAnswerType = "numeric" | "short_answer";

export interface TemplatePart {
  label: string;
  prompt: string;
  marks: number;
  answerType: TemplateAnswerType;
  answerExpr?: string;
  answerText?: string;
  tolerance?: number;
}

export interface TemplateMarkSchemeStep {
  code: string;
  text: string;
}

export interface ExamPaperTemplateBody {
  params: TemplateParamDef[];
  stem: string;
  parts: TemplatePart[];
  markScheme: TemplateMarkSchemeStep[];
}

export interface InstantiatedPart {
  label: string;
  prompt: string;
  marks: number;
  answerType: TemplateAnswerType;
  computedAnswer: string;
  tolerance: number;
}

export interface InstantiatedTemplate {
  params: Record<string, number>;
  renderedStem: string;
  parts: InstantiatedPart[];
  markScheme: Array<{ code: string; text: string }>;
}

export function formatNumericAnswer(value: number): string {
  const rounded = Math.round(value * 10000) / 10000;
  return String(rounded);
}

function interpolate(text: string, values: Record<string, number>): string {
  return text.replace(/\{(\w+)\}/g, (_match, name: string) => {
    if (!(name in values)) {
      throw new Error(`Template references undefined value "{${name}}"`);
    }
    return formatNumericAnswer(values[name]);
  });
}

export function instantiateTemplate(
  body: ExamPaperTemplateBody,
  rng: () => number,
): InstantiatedTemplate {
  const params = sampleParams(body.params, rng);
  const values: Record<string, number> = { ...params };

  const parts: InstantiatedPart[] = body.parts.map((part) => {
    let computedAnswer: string;

    if (part.answerType === "numeric") {
      if (!part.answerExpr) {
        throw new Error(`Part "${part.label}" is numeric but has no answerExpr`);
      }
      const value = evaluateExpression(part.answerExpr, values);
      values[`answer_${part.label}`] = value;
      computedAnswer = formatNumericAnswer(value);
    } else {
      if (!part.answerText) {
        throw new Error(`Part "${part.label}" is short_answer but has no answerText`);
      }
      computedAnswer = part.answerText;
    }

    return {
      label: part.label,
      prompt: interpolate(part.prompt, values),
      marks: part.marks,
      answerType: part.answerType,
      computedAnswer,
      tolerance: part.tolerance ?? 0,
    };
  });

  return {
    params,
    renderedStem: interpolate(body.stem, values),
    parts,
    markScheme: body.markScheme.map((step) => ({
      code: step.code,
      text: interpolate(step.text, values),
    })),
  };
}
