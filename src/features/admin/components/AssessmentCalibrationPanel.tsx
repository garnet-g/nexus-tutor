"use client";

import { useMemo, useState } from "react";

import { Button } from "@/components/ui/Button";
import { FormStatus } from "@/components/ui/form-status";
import { PageHeader } from "@/features/admin/components/adminUi";
import { KCSE_SUBJECT_BLUEPRINTS } from "@/lib/assessment/kcseSubjectBlueprints";
import { kcseCalibrationSourcePolicy } from "@/schemas/kcseCalibrationSchemas";

const fieldClass =
  "w-full rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-2 outline-none focus:border-primary focus:ring-2 focus:ring-primary/20";

type ExtractionStatus = "machine_readable" | "needs_ocr";

interface CalibrationFormState {
  subjectCode: string;
  paperNumber: string;
  sourceLabel: string;
  extractionStatus: ExtractionStatus;
  commandVerbs: string;
  markAllocation: string;
  topicSignals: string;
  notes: string;
}

const initialForm: CalibrationFormState = {
  subjectCode: "mathematics",
  paperNumber: "1",
  sourceLabel: "",
  extractionStatus: "machine_readable",
  commandVerbs: "",
  markAllocation: "",
  topicSignals: "",
  notes: "",
};

function splitList(value: string): string[] {
  return value
    .split(/[,\n]/)
    .map((entry) => entry.trim())
    .filter(Boolean);
}

function parseMarkAllocation(
  value: string,
): Array<{ marks: number; observedCount: number }> {
  return splitList(value).map((entry) => {
    const [rawKey, rawCount] = entry.split(":").map((part) => part?.trim());
    const observedCount = Number(rawCount);

    if (!rawKey || !Number.isInteger(observedCount) || observedCount <= 0) {
      throw new Error("Use count pairs like 3:20 or algebra:8.");
    }

    const marks = Number(rawKey);
    if (!Number.isInteger(marks) || marks <= 0) {
      throw new Error("Mark allocation marks must be positive whole numbers.");
    }

    return { marks, observedCount };
  });
}

function parseTopicSignals(
  value: string,
): Array<{ tag: string; observedCount: number }> {
  return splitList(value).map((entry) => {
    const [tag, rawCount] = entry.split(":").map((part) => part?.trim());
    const observedCount = Number(rawCount);

    if (!tag || !Number.isInteger(observedCount) || observedCount <= 0) {
      throw new Error("Use topic signal pairs like algebra:8.");
    }

    return { tag, observedCount };
  });
}

export function AssessmentCalibrationPanel() {
  const [form, setForm] = useState(initialForm);
  const [isSaving, setIsSaving] = useState(false);
  const [status, setStatus] = useState<{
    tone: "error" | "success" | "info";
    message: string;
  } | null>(null);

  const readinessSummary = useMemo(
    () =>
      KCSE_SUBJECT_BLUEPRINTS.map((subject) => {
        const papers = subject.paperStructures;
        const calibrated = papers.filter((paper) => paper.calibration).length;
        const needsOcr = papers.some(
          (paper) => paper.calibration?.extractionStatus === "needs_ocr",
        );

        return {
          id: subject.id,
          displayName: subject.displayName,
          group: subject.group,
          calibrated,
          total: papers.length,
          needsOcr,
        };
      }),
    [],
  );

  function updateForm<Key extends keyof CalibrationFormState>(
    key: Key,
    value: CalibrationFormState[Key],
  ) {
    setForm((current) => ({ ...current, [key]: value }));
  }

  async function handleSubmit(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSaving(true);
    setStatus(null);

    try {
      const payload = {
        subjectCode: form.subjectCode,
        paperNumber: Number(form.paperNumber),
        sourceLabel: form.sourceLabel,
        extractionStatus: form.extractionStatus,
        commandVerbs: splitList(form.commandVerbs),
        markAllocation: parseMarkAllocation(form.markAllocation),
        topicSignals: parseTopicSignals(form.topicSignals),
        notes: splitList(form.notes),
        sourcePolicy: kcseCalibrationSourcePolicy,
      };

      const response = await fetch("/api/admin/assessment/calibrations", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(payload),
      });
      const result = (await response.json()) as {
        success: boolean;
        error?: { message?: string };
      };

      if (!response.ok || !result.success) {
        throw new Error(result.error?.message ?? "Could not save calibration.");
      }

      setStatus({
        tone: "success",
        message: "Calibration metadata saved.",
      });
      setForm((current) => ({
        ...current,
        sourceLabel: "",
        commandVerbs: "",
        markAllocation: "",
        topicSignals: "",
        notes: "",
      }));
    } catch (error) {
      setStatus({
        tone: "error",
        message:
          error instanceof Error ? error.message : "Could not save calibration.",
      });
    } finally {
      setIsSaving(false);
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="KCSE engine"
        title="Assessment calibration"
        description="Manage metadata signals that guide original KCSE-style assessment generation. Source questions, passages, answers, and marking schemes are not collected here."
        actions={
          <span className="rounded-full border border-nexus-border bg-nexus-sunken px-3 py-1 text-xs font-medium text-muted-foreground">
            {kcseCalibrationSourcePolicy}
          </span>
        }
      />

      <section className="grid gap-3 sm:grid-cols-2 lg:grid-cols-4">
        {readinessSummary.map((subject) => {
          const complete = subject.calibrated === subject.total;
          return (
            <article
              key={subject.id}
              className="rounded-2xl border border-nexus-border bg-nexus-surface p-4 transition-colors hover:border-nexus-border-strong"
            >
              <div className="flex items-start justify-between gap-3">
                <h2 className="text-sm font-semibold text-foreground">
                  {subject.displayName}
                </h2>
                <span className="rounded-full bg-nexus-sunken px-2 py-1 text-[11px] font-medium text-muted-foreground">
                  {subject.group.replace("_", " ")}
                </span>
              </div>
              <p
                className={
                  "mt-3 font-heading text-2xl font-semibold tabular-nums " +
                  (complete ? "text-primary" : "text-foreground")
                }
              >
                {subject.calibrated}/{subject.total}
              </p>
              <p className="mt-1 text-xs text-muted-foreground">
                {subject.needsOcr ? (
                  <span className="text-nexus-warning">needs OCR</span>
                ) : (
                  "metadata ready"
                )}
              </p>
            </article>
          );
        })}
      </section>

      <form
        onSubmit={handleSubmit}
        className="grid gap-6 rounded-2xl border border-nexus-border bg-nexus-surface p-5 lg:grid-cols-[minmax(0,1fr)_minmax(280px,360px)]"
      >
        <div className="grid gap-4 sm:grid-cols-2">
          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Subject</span>
            <select
              value={form.subjectCode}
              onChange={(event) => updateForm("subjectCode", event.target.value)}
              className={fieldClass}
            >
              {KCSE_SUBJECT_BLUEPRINTS.map((subject) => (
                <option key={subject.id} value={subject.id}>
                  {subject.displayName}
                </option>
              ))}
            </select>
          </label>

          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Paper</span>
            <input
              type="number"
              min={1}
              max={3}
              value={form.paperNumber}
              onChange={(event) => updateForm("paperNumber", event.target.value)}
              className={fieldClass}
            />
          </label>

          <label className="space-y-1 text-sm sm:col-span-2">
            <span className="text-muted-foreground">Source label</span>
            <input
              value={form.sourceLabel}
              onChange={(event) => updateForm("sourceLabel", event.target.value)}
              placeholder="2024 KCSE Mathematics Paper 1"
              className={fieldClass}
            />
          </label>

          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Extraction status</span>
            <select
              value={form.extractionStatus}
              onChange={(event) =>
                updateForm(
                  "extractionStatus",
                  event.target.value as ExtractionStatus,
                )
              }
              className={fieldClass}
            >
              <option value="machine_readable">Machine readable</option>
              <option value="needs_ocr">Needs OCR</option>
            </select>
          </label>

          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Command verbs</span>
            <input
              value={form.commandVerbs}
              onChange={(event) => updateForm("commandVerbs", event.target.value)}
              placeholder="solve, simplify, calculate"
              className={fieldClass}
            />
          </label>

          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Mark allocation</span>
            <input
              value={form.markAllocation}
              onChange={(event) =>
                updateForm("markAllocation", event.target.value)
              }
              placeholder="3:20,2:13"
              className={fieldClass}
            />
          </label>

          <label className="space-y-1 text-sm">
            <span className="text-muted-foreground">Topic signals</span>
            <input
              value={form.topicSignals}
              onChange={(event) => updateForm("topicSignals", event.target.value)}
              placeholder="algebra:8,geometry:5"
              className={fieldClass}
            />
          </label>

          <label className="space-y-1 text-sm sm:col-span-2">
            <span className="text-muted-foreground">Operator notes</span>
            <textarea
              value={form.notes}
              onChange={(event) => updateForm("notes", event.target.value)}
              rows={4}
              placeholder="Metadata-only observation notes"
              className={fieldClass}
            />
          </label>
        </div>

        <aside className="space-y-4 rounded-xl border border-nexus-border bg-nexus-sunken p-4">
          <div>
            <h2 className="text-sm font-semibold">Intake rules</h2>
            <ul className="mt-3 space-y-2 text-sm text-muted-foreground">
              <li>Use original metadata only.</li>
              <li>Record counts, tags, command verbs, and OCR state.</li>
              <li>Do not paste source questions, answers, or passages.</li>
            </ul>
          </div>

          <FormStatus
            tone={status?.tone}
            message={status?.message}
            className="w-full"
          />

          <Button type="submit" fullWidth disabled={isSaving}>
            {isSaving ? "Saving..." : "Save calibration"}
          </Button>
        </aside>
      </form>
    </div>
  );
}
