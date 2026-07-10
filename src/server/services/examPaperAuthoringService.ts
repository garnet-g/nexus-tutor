import "server-only";

import { mulberry32 } from "@/lib/examPapers/paramSampler";
import { instantiateTemplate, type ExamPaperTemplateBody } from "@/lib/examPapers/templateInstantiation";
import { validateTemplateBody, type TemplateValidationResult } from "@/lib/examPapers/templateValidation";
import { createAdminClient } from "@/lib/supabase/admin";

export interface ExamPaperTemplateInput {
  paper: 1 | 2;
  section: "I" | "II";
  formLevel: number;
  topicId: string;
  marks: number;
  difficulty: "easy" | "medium" | "hard";
  body: ExamPaperTemplateBody;
}

export interface ExamPaperTemplateSummary {
  id: string;
  paper: 1 | 2;
  section: "I" | "II";
  formLevel: number;
  topicId: string;
  marks: number;
  difficulty: string;
  reviewStatus: "draft" | "approved";
  isActive: boolean;
  createdAt: string;
}

export async function createExamPaperTemplate(
  input: ExamPaperTemplateInput,
): Promise<{ id: string; validation: TemplateValidationResult }> {
  const validation = validateTemplateBody(input.body);

  const admin = createAdminClient();
  const { data, error } = await admin
    .from("exam_paper_templates")
    .insert({
      paper: input.paper,
      section: input.section,
      form_level: input.formLevel,
      topic_id: input.topicId,
      marks: input.marks,
      difficulty: input.difficulty,
      review_status: "draft",
      is_active: true,
      body: input.body,
    })
    .select("id")
    .single();

  if (error || !data) {
    throw new Error(error?.message ?? "Could not create exam paper template");
  }

  return { id: data.id, validation };
}

export async function listExamPaperTemplates(filters?: {
  paper?: 1 | 2;
  reviewStatus?: "draft" | "approved";
}): Promise<ExamPaperTemplateSummary[]> {
  const admin = createAdminClient();
  let query = admin
    .from("exam_paper_templates")
    .select("id, paper, section, form_level, topic_id, marks, difficulty, review_status, is_active, created_at")
    .order("created_at", { ascending: false });

  if (filters?.paper) query = query.eq("paper", filters.paper);
  if (filters?.reviewStatus) query = query.eq("review_status", filters.reviewStatus);

  const { data } = await query;

  return (data ?? []).map((row: any) => ({
    id: row.id,
    paper: row.paper,
    section: row.section,
    formLevel: row.form_level,
    topicId: row.topic_id,
    marks: row.marks,
    difficulty: row.difficulty,
    reviewStatus: row.review_status,
    isActive: row.is_active,
    createdAt: row.created_at,
  }));
}

export async function approveExamPaperTemplate(templateId: string): Promise<void> {
  const admin = createAdminClient();

  const { data: template } = await admin
    .from("exam_paper_templates")
    .select("body")
    .eq("id", templateId)
    .maybeSingle();

  if (!template) throw new Error("NOT_FOUND");

  const validation = validateTemplateBody(template.body as ExamPaperTemplateBody);
  if (!validation.ok) {
    throw new Error(`VALIDATION_FAILED: ${validation.errors[0]}`);
  }

  const { error } = await admin
    .from("exam_paper_templates")
    .update({ review_status: "approved" })
    .eq("id", templateId);

  if (error) throw new Error(error.message);
}

export interface TemplatePreviewSample {
  renderedStem: string;
  parts: Array<{ label: string; prompt: string; computedAnswer: string }>;
}

export function previewTemplateSamples(body: ExamPaperTemplateBody, count = 3): TemplatePreviewSample[] {
  return Array.from({ length: count }, (_, index) => {
    const instantiated = instantiateTemplate(body, mulberry32(1000 + index));
    return {
      renderedStem: instantiated.renderedStem,
      parts: instantiated.parts.map((part) => ({
        label: part.label,
        prompt: part.prompt,
        computedAnswer: part.computedAnswer,
      })),
    };
  });
}
