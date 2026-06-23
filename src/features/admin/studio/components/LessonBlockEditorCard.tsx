"use client";

import type { LessonContentBlock } from "@/types/curriculum";

import { Field, Input, Select, Textarea } from "@/features/admin/components/adminForm";
import { RichTextBlockEditor } from "@/features/admin/studio/components/RichTextBlockEditor";
import { uploadStudioMedia } from "@/features/admin/studio/lib/studioApi";
import { Button } from "@/components/ui/Button";
import { toastError, toastSuccess } from "@/features/admin/components/toast";

interface LessonBlockEditorCardProps {
  block: LessonContentBlock;
  index: number;
  onChange: (block: LessonContentBlock) => void;
}

function updateTableRow(
  rows: string[][],
  rowIndex: number,
  colIndex: number,
  value: string,
): string[][] {
  return rows.map((row, currentRowIndex) =>
    currentRowIndex === rowIndex
      ? row.map((cell, currentColIndex) => (currentColIndex === colIndex ? value : cell))
      : row,
  );
}

export function LessonBlockEditorCard({ block, index, onChange }: LessonBlockEditorCardProps) {
  async function handleImageUpload(file: File) {
    try {
      const uploaded = await uploadStudioMedia(file);
      if (block.type !== "image") {
        return;
      }
      onChange({ ...block, url: uploaded.publicUrl, alt: block.alt || uploaded.fileName });
      toastSuccess("Image uploaded");
    } catch (error) {
      toastError("Upload failed", error instanceof Error ? error.message : undefined);
    }
  }

  switch (block.type) {
    case "heading":
    case "paragraph":
    case "tip":
      return (
        <Textarea
          value={block.content}
          onChange={(event) => onChange({ ...block, content: event.target.value })}
          rows={block.type === "heading" ? 2 : 4}
        />
      );
    case "rich_text":
      return (
        <RichTextBlockEditor
          markdown={block.markdown}
          onChange={(markdown) => onChange({ ...block, markdown })}
        />
      );
    case "example":
      return (
        <div className="space-y-3">
          <Field label="Title">
            <Input
              value={block.title}
              onChange={(event) => onChange({ ...block, title: event.target.value })}
            />
          </Field>
          <Field label="Steps (one per line)">
            <Textarea
              value={block.steps.join("\n")}
              onChange={(event) =>
                onChange({
                  ...block,
                  steps: event.target.value
                    .split("\n")
                    .map((step) => step.trim())
                    .filter(Boolean),
                })
              }
              rows={5}
            />
          </Field>
          <Field label="Answer">
            <Input
              value={block.answer}
              onChange={(event) => onChange({ ...block, answer: event.target.value })}
            />
          </Field>
        </div>
      );
    case "callout":
      return (
        <div className="space-y-3">
          <Field label="Variant">
            <Select
              value={block.variant}
              onChange={(event) =>
                onChange({
                  ...block,
                  variant: event.target.value as typeof block.variant,
                })
              }
            >
              <option value="info">Info</option>
              <option value="warning">Warning</option>
              <option value="key_point">Key point</option>
            </Select>
          </Field>
          <Textarea
            value={block.content}
            onChange={(event) => onChange({ ...block, content: event.target.value })}
            rows={4}
          />
        </div>
      );
    case "image":
      return (
        <div className="space-y-3">
          <Field label="Image URL">
            <Input
              value={block.url}
              onChange={(event) => onChange({ ...block, url: event.target.value })}
            />
          </Field>
          <Field label="Alt text">
            <Input
              value={block.alt}
              onChange={(event) => onChange({ ...block, alt: event.target.value })}
            />
          </Field>
          <Field label="Caption (optional)">
            <Input
              value={block.caption ?? ""}
              onChange={(event) =>
                onChange({ ...block, caption: event.target.value || undefined })
              }
            />
          </Field>
          <div>
            <input
              type="file"
              accept="image/jpeg,image/png,image/webp,image/gif"
              onChange={(event) => {
                const file = event.target.files?.[0];
                if (file) {
                  void handleImageUpload(file);
                }
              }}
            />
          </div>
        </div>
      );
    case "table":
      return (
        <div className="space-y-3">
          {block.rows.map((row, rowIndex) => (
            <div key={`row-${index}-${rowIndex}`} className="grid gap-2 sm:grid-cols-2">
              {row.map((cell, colIndex) => (
                <Input
                  key={`cell-${rowIndex}-${colIndex}`}
                  value={cell}
                  onChange={(event) =>
                    onChange({
                      ...block,
                      rows: updateTableRow(block.rows, rowIndex, colIndex, event.target.value),
                    })
                  }
                  placeholder={`R${rowIndex + 1}C${colIndex + 1}`}
                />
              ))}
            </div>
          ))}
          <div className="flex flex-wrap gap-2">
            <Button
              type="button"
              size="sm"
              variant="outline"
              onClick={() =>
                onChange({
                  ...block,
                  rows: [...block.rows, Array(block.rows[0]?.length ?? 2).fill("")],
                })
              }
            >
              Add row
            </Button>
            <Button
              type="button"
              size="sm"
              variant="outline"
              onClick={() =>
                onChange({
                  ...block,
                  rows: block.rows.map((row) => [...row, ""]),
                })
              }
            >
              Add column
            </Button>
          </div>
          <Field label="Caption (optional)">
            <Input
              value={block.caption ?? ""}
              onChange={(event) =>
                onChange({ ...block, caption: event.target.value || undefined })
              }
            />
          </Field>
        </div>
      );
    case "math_block":
      return (
        <div className="space-y-3">
          <Field label="LaTeX">
            <Textarea
              value={block.latex}
              onChange={(event) => onChange({ ...block, latex: event.target.value })}
              rows={3}
            />
          </Field>
          <Field label="Caption (optional)">
            <Input
              value={block.caption ?? ""}
              onChange={(event) =>
                onChange({ ...block, caption: event.target.value || undefined })
              }
            />
          </Field>
        </div>
      );
    case "chemical_equation":
      return (
        <div className="space-y-3">
          <Field label="Equation (LaTeX)">
            <Textarea
              value={block.equation}
              onChange={(event) => onChange({ ...block, equation: event.target.value })}
              rows={3}
            />
          </Field>
          <Field label="Caption (optional)">
            <Input
              value={block.caption ?? ""}
              onChange={(event) =>
                onChange({ ...block, caption: event.target.value || undefined })
              }
            />
          </Field>
        </div>
      );
    case "comprehension_passage":
      return (
        <div className="space-y-3">
          <Field label="Title (optional)">
            <Input
              value={block.title ?? ""}
              onChange={(event) =>
                onChange({ ...block, title: event.target.value || undefined })
              }
            />
          </Field>
          <Field label="Passage">
            <Textarea
              value={block.passage}
              onChange={(event) => onChange({ ...block, passage: event.target.value })}
              rows={8}
            />
          </Field>
        </div>
      );
    case "video_embed":
      return (
        <div className="space-y-3">
          <Field label="Provider">
            <Select
              value={block.provider}
              onChange={(event) => onChange({ ...block, provider: event.target.value })}
            >
              <option value="youtube">YouTube</option>
              <option value="vimeo">Vimeo</option>
              <option value="other">Other</option>
            </Select>
          </Field>
          <Field label="URL">
            <Input
              value={block.url}
              onChange={(event) => onChange({ ...block, url: event.target.value })}
            />
          </Field>
          <Field label="Title (optional)">
            <Input
              value={block.title ?? ""}
              onChange={(event) =>
                onChange({ ...block, title: event.target.value || undefined })
              }
            />
          </Field>
        </div>
      );
    case "question":
      return (
        <div className="space-y-3">
          <Field label="Question">
            <Textarea
              value={block.questionText}
              onChange={(event) => onChange({ ...block, questionText: event.target.value })}
              rows={3}
            />
          </Field>
          <Field label="Type">
            <Select
              value={block.questionType}
              onChange={(event) =>
                onChange({
                  ...block,
                  questionType: event.target.value as typeof block.questionType,
                  options: event.target.value === "short_answer" ? undefined : block.options,
                })
              }
            >
              <option value="multiple_choice">Multiple choice</option>
              <option value="short_answer">Short answer</option>
            </Select>
          </Field>
          {block.questionType === "multiple_choice" ? (
            <Field label="Options (one per line)">
              <Textarea
                value={(block.options ?? []).join("\n")}
                onChange={(event) =>
                  onChange({
                    ...block,
                    options: event.target.value
                      .split("\n")
                      .map((option) => option.trim())
                      .filter(Boolean),
                  })
                }
                rows={4}
              />
            </Field>
          ) : null}
          <Field label="Correct answer">
            <Input
              value={block.correctAnswer}
              onChange={(event) => onChange({ ...block, correctAnswer: event.target.value })}
            />
          </Field>
          <Field label="Explanation (optional)">
            <Textarea
              value={block.explanation ?? ""}
              onChange={(event) =>
                onChange({ ...block, explanation: event.target.value || undefined })
              }
              rows={3}
            />
          </Field>
        </div>
      );
    case "file_attachment":
      return (
        <div className="space-y-3">
          <Field label="File URL">
            <Input
              value={block.url}
              onChange={(event) => onChange({ ...block, url: event.target.value })}
            />
          </Field>
          <Field label="Display name">
            <Input
              value={block.name}
              onChange={(event) => onChange({ ...block, name: event.target.value })}
            />
          </Field>
        </div>
      );
    case "divider":
      return <p className="text-sm text-muted-foreground">Horizontal divider — no fields.</p>;
    default: {
      const _exhaustive: never = block;
      return _exhaustive;
    }
  }
}
