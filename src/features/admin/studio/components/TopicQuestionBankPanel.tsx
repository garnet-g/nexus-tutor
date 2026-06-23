"use client";

import { useEffect, useMemo, useRef, useState } from "react";

import { DataTable, type Column } from "@/features/admin/components/DataTable";
import { Field, Input, Select, Textarea } from "@/features/admin/components/adminForm";
import { EmptyState, Panel, StatusBadge } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { assistGenerateQuestions } from "@/features/admin/studio/lib/studioAssistApi";
import {
  bulkSaveTopicQuestions,
  createBlankQuestionRow,
  editableRowsToCsv,
  fetchTopicQuestions,
  parseQuestionCsv,
  toEditableQuestionRow,
  type EditableQuestionRow,
  type TopicQuestionsResponse,
} from "@/features/admin/studio/lib/studioWorkspaceApi";
import type { StudioReviewStatus } from "@/types/contentStudio";
import { GRADE_LEVELS_BY_CURRICULUM } from "@/types/contentAdmin";
import type { Curriculum } from "@/types/database";
import { Button } from "@/components/ui/Button";

interface TopicQuestionBankPanelProps {
  topicId: string;
  topicTitle: string;
}

function reviewTone(status: StudioReviewStatus) {
  switch (status) {
    case "published":
      return "success" as const;
    case "draft":
      return "warning" as const;
    default:
      return "neutral" as const;
  }
}

function isRowEditable(row: EditableQuestionRow) {
  return row.isNew || row.reviewStatus === "draft";
}

export function TopicQuestionBankPanel({ topicId, topicTitle }: TopicQuestionBankPanelProps) {
  const [data, setData] = useState<TopicQuestionsResponse | null>(null);
  const [rows, setRows] = useState<EditableQuestionRow[]>([]);
  const [isLoading, setIsLoading] = useState(true);
  const [isSaving, setIsSaving] = useState(false);
  const [isGenerating, setIsGenerating] = useState(false);
  const [assistGrade, setAssistGrade] = useState("Form 1");
  const [assistDifficulty, setAssistDifficulty] = useState<"easy" | "medium" | "hard">("medium");
  const [assistCount, setAssistCount] = useState(3);
  const fileInputRef = useRef<HTMLInputElement>(null);

  useEffect(() => {
    let active = true;

    fetchTopicQuestions(topicId)
      .then((response) => {
        if (!active) {
          return;
        }
        setData(response);
        setRows(response.questions.map(toEditableQuestionRow));
        const grades = GRADE_LEVELS_BY_CURRICULUM[response.context.curriculumCode as Curriculum];
        if (grades?.[0]) {
          setAssistGrade(grades[0]);
        }
      })
      .catch((error: unknown) => {
        if (!active) {
          return;
        }
        toastError(
          "Could not load questions",
          error instanceof Error ? error.message : undefined,
        );
      })
      .finally(() => {
        if (active) {
          setIsLoading(false);
        }
      });

    return () => {
      active = false;
    };
  }, [topicId]);

  async function handleGenerateQuestions() {
    if (!data) {
      return;
    }

    setIsGenerating(true);
    try {
      const generated = await assistGenerateQuestions({
        topicId,
        curriculum: data.context.curriculumCode as Curriculum,
        gradeLevel: assistGrade,
        difficulty: assistDifficulty,
        count: assistCount,
      });

      const newRows = generated.questions.map((question) => ({
        ...createBlankQuestionRow(topicId),
        questionText: question.questionText,
        questionType: question.questionType,
        options: question.options,
        correctAnswer: question.correctAnswer,
        difficulty: question.difficulty,
        explanation: question.explanation,
      }));

      setRows((current) => [...current, ...newRows]);
      toastSuccess("Questions generated", "Review draft rows and save all when ready.");
    } catch (error) {
      toastError(
        "Could not generate questions",
        error instanceof Error ? error.message : undefined,
      );
    } finally {
      setIsGenerating(false);
    }
  }

  async function reloadQuestions() {
    const response = await fetchTopicQuestions(topicId);
    setData(response);
    setRows(response.questions.map(toEditableQuestionRow));
  }

  function updateRow(clientKey: string, patch: Partial<EditableQuestionRow>) {
    setRows((current) =>
      current.map((row) => (row.clientKey === clientKey ? { ...row, ...patch } : row)),
    );
  }

  async function handleSave() {
    setIsSaving(true);
    try {
      const result = await bulkSaveTopicQuestions(topicId, rows);
      if (result.errors.length > 0) {
        toastError(
          "Some rows failed validation",
          result.errors
            .slice(0, 3)
            .map((error) => `Row ${error.index + 1}: ${error.message}`)
            .join(" · "),
        );
      } else {
        toastSuccess("Question bank saved");
      }
      await reloadQuestions();
    } catch (error) {
      toastError("Bulk save failed", error instanceof Error ? error.message : undefined);
    } finally {
      setIsSaving(false);
    }
  }

  function handleExport() {
    const csv = editableRowsToCsv(rows);
    const blob = new Blob([csv], { type: "text/csv;charset=utf-8;" });
    const url = URL.createObjectURL(blob);
    const link = document.createElement("a");
    link.href = url;
    link.download = `${topicTitle.replace(/\s+/g, "-").toLowerCase()}-questions.csv`;
    document.body.appendChild(link);
    link.click();
    document.body.removeChild(link);
    URL.revokeObjectURL(url);
  }

  async function handleImport(file: File) {
    const text = await file.text();
    const parsed = parseQuestionCsv(text, topicId);
    if (!parsed.ok) {
      toastError(
        "CSV import failed",
        parsed.errors
          .slice(0, 3)
          .map((error) => `Row ${error.row}: ${error.message}`)
          .join(" · "),
      );
      return;
    }

    setRows((current) => [...current, ...parsed.rows]);
    toastSuccess("CSV imported", "Review rows and click Save all to persist.");
  }

  const visibleRows = useMemo(
    () => rows.filter((row) => !row.markDelete),
    [rows],
  );

  const columns: Column<EditableQuestionRow>[] = [
    {
      key: "questionText",
      header: "Question",
      searchValue: (row) => row.questionText,
      render: (row) =>
        isRowEditable(row) ? (
          <Textarea
            value={row.questionText}
            onChange={(event) => updateRow(row.clientKey, { questionText: event.target.value })}
            rows={3}
          />
        ) : (
          <p className="text-sm text-foreground">{row.questionText}</p>
        ),
      exportValue: (row) => row.questionText,
    },
    {
      key: "questionType",
      header: "Type",
      render: (row) =>
        isRowEditable(row) ? (
          <Select
            value={row.questionType}
            onChange={(event) =>
              updateRow(row.clientKey, {
                questionType: event.target.value as EditableQuestionRow["questionType"],
                options:
                  event.target.value === "multiple_choice" ? row.options : [],
              })
            }
          >
            <option value="multiple_choice">Multiple choice</option>
            <option value="short_answer">Short answer</option>
          </Select>
        ) : (
          row.questionType
        ),
      exportValue: (row) => row.questionType,
    },
    {
      key: "options",
      header: "Options",
      render: (row) =>
        row.questionType === "multiple_choice" && isRowEditable(row) ? (
          <Textarea
            value={row.options.join("\n")}
            onChange={(event) =>
              updateRow(row.clientKey, {
                options: event.target.value
                  .split("\n")
                  .map((option) => option.trim())
                  .filter(Boolean),
              })
            }
            rows={3}
            placeholder="One option per line"
          />
        ) : (
          <span className="text-sm text-muted-foreground">
            {row.questionType === "multiple_choice" ? row.options.join(" | ") : "—"}
          </span>
        ),
      exportValue: (row) => row.options.join("|"),
    },
    {
      key: "correctAnswer",
      header: "Answer",
      render: (row) =>
        isRowEditable(row) ? (
          <Input
            value={row.correctAnswer}
            onChange={(event) => updateRow(row.clientKey, { correctAnswer: event.target.value })}
          />
        ) : (
          row.correctAnswer
        ),
      exportValue: (row) => row.correctAnswer,
    },
    {
      key: "difficulty",
      header: "Difficulty",
      render: (row) =>
        isRowEditable(row) ? (
          <Select
            value={row.difficulty}
            onChange={(event) =>
              updateRow(row.clientKey, {
                difficulty: event.target.value as EditableQuestionRow["difficulty"],
              })
            }
          >
            <option value="easy">Easy</option>
            <option value="medium">Medium</option>
            <option value="hard">Hard</option>
          </Select>
        ) : (
          row.difficulty
        ),
      exportValue: (row) => row.difficulty,
    },
    {
      key: "explanation",
      header: "Explanation",
      render: (row) =>
        isRowEditable(row) ? (
          <Textarea
            value={row.explanation ?? ""}
            onChange={(event) => updateRow(row.clientKey, { explanation: event.target.value })}
            rows={2}
          />
        ) : (
          <span className="text-sm text-muted-foreground">{row.explanation ?? "—"}</span>
        ),
      exportValue: (row) => row.explanation ?? "",
    },
    {
      key: "status",
      header: "Status",
      render: (row) => (
        <StatusBadge tone={reviewTone(row.reviewStatus)}>{row.reviewStatus}</StatusBadge>
      ),
      exportValue: (row) => row.reviewStatus,
    },
    {
      key: "actions",
      header: "",
      render: (row) =>
        isRowEditable(row) ? (
          <Button
            type="button"
            size="sm"
            variant="destructive"
            onClick={() => updateRow(row.clientKey, { markDelete: true })}
          >
            Remove
          </Button>
        ) : null,
    },
  ];

  return (
    <Panel
      title={`${topicTitle} question bank`}
      description={
        data
          ? `${data.context.curriculumCode} · ${data.context.subjectCode} · edit draft rows inline, then save all.`
          : "Loading topic context…"
      }
      action={
        <div className="flex flex-wrap gap-2">
          <Button type="button" size="sm" variant="outline" onClick={() => setRows((current) => [...current, createBlankQuestionRow(topicId)])}>
            Add row
          </Button>
          <Button type="button" size="sm" variant="outline" onClick={handleExport}>
            Export CSV
          </Button>
          <Button type="button" size="sm" variant="outline" onClick={() => fileInputRef.current?.click()}>
            Import CSV
          </Button>
          <Button type="button" size="sm" disabled={isSaving} onClick={() => void handleSave()}>
            {isSaving ? "Saving…" : "Save all"}
          </Button>
        </div>
      }
    >
      <input
        ref={fileInputRef}
        type="file"
        accept=".csv,text/csv"
        className="hidden"
        onChange={(event) => {
          const file = event.target.files?.[0];
          if (file) {
            void handleImport(file);
          }
          event.target.value = "";
        }}
      />

      <Field
        label="CSV format"
        hint="Columns: questionText, questionType, options (pipe-separated), correctAnswer, difficulty, explanation, subtopicId (optional)."
      >
        <span className="sr-only">CSV format hint</span>
      </Field>

      {data ? (
        <div className="mb-5 grid gap-3 rounded-2xl border border-nexus-border bg-nexus-sunken/30 p-4 sm:grid-cols-4">
          <Field label="AI grade">
            <Select value={assistGrade} onChange={(event) => setAssistGrade(event.target.value)}>
              {GRADE_LEVELS_BY_CURRICULUM[data.context.curriculumCode as Curriculum].map((grade) => (
                <option key={grade} value={grade}>
                  {grade}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Difficulty">
            <Select
              value={assistDifficulty}
              onChange={(event) =>
                setAssistDifficulty(event.target.value as "easy" | "medium" | "hard")
              }
            >
              <option value="easy">Easy</option>
              <option value="medium">Medium</option>
              <option value="hard">Hard</option>
            </Select>
          </Field>
          <Field label="Count">
            <Input
              type="number"
              min={1}
              max={10}
              value={assistCount}
              onChange={(event) => setAssistCount(Number(event.target.value))}
            />
          </Field>
          <div className="flex items-end">
            <Button type="button" disabled={isGenerating} onClick={() => void handleGenerateQuestions()}>
              {isGenerating ? "Generating…" : "AI generate questions"}
            </Button>
          </div>
        </div>
      ) : null}

      {isLoading ? (
        <p className="text-sm text-muted-foreground">Loading questions…</p>
      ) : visibleRows.length === 0 ? (
        <EmptyState
          title="No questions yet"
          description="Add rows manually or import a CSV, then save all."
          action={
            <Button
              type="button"
              onClick={() => setRows([createBlankQuestionRow(topicId)])}
            >
              Add first question
            </Button>
          }
        />
      ) : (
        <DataTable
          columns={columns}
          rows={visibleRows}
          getRowKey={(row) => row.clientKey}
          searchable
          searchPlaceholder="Search questions…"
          exportFilename={`${topicTitle}-questions`}
        />
      )}
    </Panel>
  );
}
