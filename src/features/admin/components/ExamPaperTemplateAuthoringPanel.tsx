"use client";

import { useState } from "react";

import { Field, Input, Select, Textarea } from "@/features/admin/components/adminForm";
import { PageHeader } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";

interface PreviewSample {
  renderedStem: string;
  parts: Array<{ label: string; prompt: string; computedAnswer: string }>;
}

interface TemplateSummary {
  id: string;
  paper: 1 | 2;
  section: "I" | "II";
  formLevel: number;
  marks: number;
  difficulty: string;
  reviewStatus: "draft" | "approved";
  createdAt: string;
}

const DEFAULT_BODY_JSON = JSON.stringify(
  {
    params: [{ name: "angle", min: 20, max: 70, step: 5 }],
    stem: "In triangle ABC, AB = AC and angle ABC = {angle} degrees.",
    parts: [
      {
        label: "a",
        prompt: "Calculate angle BAC.",
        marks: 3,
        answerType: "numeric",
        answerExpr: "180 - 2 * angle",
        tolerance: 0,
      },
    ],
    markScheme: [
      { code: "M1", text: "Base angles equal: {angle} degrees each" },
      { code: "A1", text: "180 - 2 x {angle} = {answer_a}" },
    ],
  },
  null,
  2,
);

export function ExamPaperTemplateAuthoringPanel({ templates }: { templates: TemplateSummary[] }) {
  const [paper, setPaper] = useState("1");
  const [section, setSection] = useState("I");
  const [formLevel, setFormLevel] = useState("1");
  const [topicId, setTopicId] = useState("");
  const [marks, setMarks] = useState("3");
  const [difficulty, setDifficulty] = useState("medium");
  const [bodyJson, setBodyJson] = useState(DEFAULT_BODY_JSON);
  const [samples, setSamples] = useState<PreviewSample[] | null>(null);
  const [validationErrors, setValidationErrors] = useState<string[]>([]);
  const [submitting, setSubmitting] = useState(false);

  function parseBody(): unknown | null {
    try {
      return JSON.parse(bodyJson);
    } catch {
      toastError("Invalid JSON", "Fix the template body JSON before continuing.");
      return null;
    }
  }

  async function handlePreview() {
    const body = parseBody();
    if (body === null) return;

    setSubmitting(true);
    try {
      const response = await fetch("/api/admin/exam-papers/templates/preview", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });
      const result = await response.json();
      if (!response.ok || !result.success) {
        throw new Error(result.error?.message ?? "Could not preview template.");
      }
      setValidationErrors(result.data.validation.errors);
      setSamples(result.data.samples);
      if (result.data.validation.ok) {
        toastSuccess("Preview ready", `${result.data.samples.length} sample(s) generated.`);
      } else {
        toastError("Validation failed", result.data.validation.errors[0]);
      }
    } catch (error) {
      toastError("Preview failed", error instanceof Error ? error.message : "Unexpected error.");
    } finally {
      setSubmitting(false);
    }
  }

  async function handleSubmit() {
    const body = parseBody();
    if (body === null) return;

    setSubmitting(true);
    try {
      const response = await fetch("/api/admin/exam-papers/templates", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          paper: Number(paper),
          section,
          formLevel: Number(formLevel),
          topicId,
          marks: Number(marks),
          difficulty,
          body,
        }),
      });
      const result = await response.json();
      if (!response.ok || !result.success) {
        throw new Error(result.error?.message ?? "Could not create template.");
      }
      toastSuccess("Template created", "Saved as draft. Approve it once you've reviewed the preview.");
      setSamples(null);
      setValidationErrors([]);
    } catch (error) {
      toastError("Create failed", error instanceof Error ? error.message : "Unexpected error.");
    } finally {
      setSubmitting(false);
    }
  }

  async function handleApprove(templateId: string) {
    try {
      const response = await fetch(`/api/admin/exam-papers/templates/${templateId}/approve`, {
        method: "POST",
      });
      const result = await response.json();
      if (!response.ok || !result.success) {
        throw new Error(result.error?.message ?? "Could not approve template.");
      }
      toastSuccess("Template approved", "It will now be eligible for paper assembly.");
    } catch (error) {
      toastError("Approve failed", error instanceof Error ? error.message : "Unexpected error.");
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Assessment"
        title="Exam paper templates"
        description="Author parameterized KCSE questions. Preview fuzz-validates 100 random samples before you save."
      />

      <div className="grid gap-4 sm:grid-cols-3">
        <Field label="Paper" htmlFor="paper">
          <Select id="paper" value={paper} onChange={(e) => setPaper(e.target.value)}>
            <option value="1">Paper 1</option>
            <option value="2">Paper 2</option>
          </Select>
        </Field>
        <Field label="Section" htmlFor="section">
          <Select id="section" value={section} onChange={(e) => setSection(e.target.value)}>
            <option value="I">Section I</option>
            <option value="II">Section II</option>
          </Select>
        </Field>
        <Field label="Form level" htmlFor="formLevel">
          <Select id="formLevel" value={formLevel} onChange={(e) => setFormLevel(e.target.value)}>
            <option value="1">Form 1</option>
            <option value="2">Form 2</option>
            <option value="3">Form 3</option>
            <option value="4">Form 4</option>
          </Select>
        </Field>
        <Field label="Topic ID" htmlFor="topicId" hint="UUID from the topics table">
          <Input id="topicId" value={topicId} onChange={(e) => setTopicId(e.target.value)} />
        </Field>
        <Field label="Marks" htmlFor="marks">
          <Input id="marks" type="number" value={marks} onChange={(e) => setMarks(e.target.value)} />
        </Field>
        <Field label="Difficulty" htmlFor="difficulty">
          <Select id="difficulty" value={difficulty} onChange={(e) => setDifficulty(e.target.value)}>
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </Select>
        </Field>
      </div>

      <Field label="Template body (JSON)" htmlFor="bodyJson">
        <Textarea id="bodyJson" rows={16} value={bodyJson} onChange={(e) => setBodyJson(e.target.value)} />
      </Field>

      <div className="flex gap-3">
        <button
          type="button"
          className="rounded-lg border border-nexus-border px-4 py-2 text-sm font-medium"
          onClick={() => void handlePreview()}
          disabled={submitting}
        >
          Preview (100-seed fuzz check)
        </button>
        <button
          type="button"
          className="rounded-lg bg-nexus-accent px-4 py-2 text-sm font-medium text-white"
          onClick={() => void handleSubmit()}
          disabled={submitting || validationErrors.length > 0}
        >
          Save as draft
        </button>
      </div>

      {samples ? (
        <div className="space-y-3 rounded-xl border border-nexus-border p-4">
          <p className="text-sm font-semibold text-foreground">Preview samples</p>
          {samples.map((sample, index) => (
            <div key={index} className="text-sm text-muted-foreground">
              <p>{sample.renderedStem}</p>
              {sample.parts.map((part) => (
                <p key={part.label}>
                  ({part.label}) {part.prompt} → {part.computedAnswer}
                </p>
              ))}
            </div>
          ))}
        </div>
      ) : null}

      <div className="space-y-2">
        <p className="text-sm font-semibold text-foreground">Existing templates</p>
        <table className="w-full text-sm">
          <thead>
            <tr className="text-left text-muted-foreground">
              <th className="py-1">Paper</th>
              <th>Section</th>
              <th>Form</th>
              <th>Marks</th>
              <th>Status</th>
              <th />
            </tr>
          </thead>
          <tbody>
            {templates.map((template) => (
              <tr key={template.id} className="border-t border-nexus-border">
                <td className="py-1">{template.paper}</td>
                <td>{template.section}</td>
                <td>{template.formLevel}</td>
                <td>{template.marks}</td>
                <td>{template.reviewStatus}</td>
                <td>
                  {template.reviewStatus === "draft" ? (
                    <button
                      type="button"
                      className="text-xs font-medium text-nexus-accent"
                      onClick={() => void handleApprove(template.id)}
                    >
                      Approve
                    </button>
                  ) : null}
                </td>
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}
