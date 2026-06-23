"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import ReactMarkdown from "react-markdown";
import rehypeKatex from "rehype-katex";
import remarkGfm from "remark-gfm";
import remarkMath from "remark-math";
import { Download, ExternalLink, MessageCircle } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { SectionCard } from "@/components/ui/SectionCard";
import type { LessonContentBlock, LessonInlineQuestionBlock } from "@/types/curriculum";
import { cn } from "@/lib/utils";

import "katex/dist/katex.min.css";

const markdownPlugins = [remarkGfm, remarkMath];
const markdownRehypePlugins = [rehypeKatex];

interface LessonContentBlocksProps {
  blocks: LessonContentBlock[];
  topicId: string;
}

function blockKey(block: LessonContentBlock, index: number) {
  return block.id ?? `${block.type}-${index}`;
}

function AskNexLink({ topicId, label }: { topicId: string; label: string }) {
  return (
    <Link
      href={`/nex?topicId=${topicId}&mode=explain`}
      className="inline-flex min-h-11 items-center gap-1 text-sm font-medium text-nexus-primary opacity-0 transition group-hover:opacity-100 focus-visible:opacity-100"
    >
      <MessageCircle className="size-4" />
      {label}
    </Link>
  );
}

function MarkdownContent({ children }: { children: string }) {
  return (
    <div className="prose-nexus leading-8 text-foreground/90 [&_table]:w-full [&_td]:border [&_td]:border-nexus-border [&_td]:px-3 [&_td]:py-2 [&_th]:border [&_th]:border-nexus-border [&_th]:bg-nexus-sunken [&_th]:px-3 [&_th]:py-2">
      <ReactMarkdown
        remarkPlugins={markdownPlugins}
        rehypePlugins={markdownRehypePlugins}
      >
        {children}
      </ReactMarkdown>
    </div>
  );
}

function ChemicalEquationBlock({
  block,
  topicId,
}: {
  block: Extract<LessonContentBlock, { type: "chemical_equation" }>;
  topicId: string;
}) {
  const markdown = `$$\n${block.equation}\n$$`;

  return (
    <SectionCard className="bg-nexus-sunken/50">
      <div className="flex items-start justify-between gap-3">
        <p className="text-sm font-semibold uppercase tracking-wide text-nexus-primary">
          Chemical equation
        </p>
        <Link
          href={`/nex?topicId=${topicId}&mode=explain`}
          className="inline-flex min-h-11 shrink-0 items-center gap-1 text-sm font-medium text-nexus-primary hover:bg-nexus-primary-soft"
        >
          <MessageCircle className="size-4" />
          Ask Nex
        </Link>
      </div>
      <div className="mt-4 overflow-x-auto text-foreground">
        <ReactMarkdown remarkPlugins={[remarkMath]} rehypePlugins={[rehypeKatex]}>
          {markdown}
        </ReactMarkdown>
      </div>
      {block.caption ? (
        <p className="mt-3 text-sm leading-7 text-muted-foreground">{block.caption}</p>
      ) : null}
    </SectionCard>
  );
}

function MathBlock({
  block,
  topicId,
}: {
  block: Extract<LessonContentBlock, { type: "math_block" }>;
  topicId: string;
}) {
  const markdown = `$$\n${block.latex}\n$$`;

  return (
    <SectionCard className="bg-nexus-sunken/50">
      <div className="flex items-start justify-between gap-3">
        <p className="text-sm font-semibold uppercase tracking-wide text-nexus-primary">
          Formula
        </p>
        <Link
          href={`/nex?topicId=${topicId}&mode=explain`}
          className="inline-flex min-h-11 shrink-0 items-center gap-1 text-sm font-medium text-nexus-primary hover:bg-nexus-primary-soft"
        >
          <MessageCircle className="size-4" />
          Ask Nex
        </Link>
      </div>
      <div className="mt-4 overflow-x-auto text-foreground">
        <ReactMarkdown remarkPlugins={[remarkMath]} rehypePlugins={[rehypeKatex]}>
          {markdown}
        </ReactMarkdown>
      </div>
      {block.caption ? (
        <p className="mt-3 text-sm leading-7 text-muted-foreground">{block.caption}</p>
      ) : null}
    </SectionCard>
  );
}

function ComprehensionPassageBlock({
  block,
  topicId,
}: {
  block: Extract<LessonContentBlock, { type: "comprehension_passage" }>;
  topicId: string;
}) {
  return (
    <div className="group space-y-3 rounded-[18px] border border-nexus-border bg-card px-5 py-4">
      {block.title ? (
        <h3 className="font-heading text-lg font-semibold text-foreground">{block.title}</h3>
      ) : null}
      <p className="whitespace-pre-wrap leading-8 text-foreground/90">{block.passage}</p>
      <AskNexLink topicId={topicId} label="Ask Nex about this passage" />
    </div>
  );
}

function WorkedExampleBlock({
  block,
  topicId,
}: {
  block: Extract<LessonContentBlock, { type: "example" }>;
  topicId: string;
}) {
  const [visibleSteps, setVisibleSteps] = useState(1);

  return (
    <SectionCard className="bg-nexus-sunken/50">
      <div className="flex items-start justify-between gap-3">
        <h3 className="text-sm font-semibold uppercase tracking-wide text-nexus-primary">
          {block.title}
        </h3>
        <Link
          href={`/nex?topicId=${topicId}&mode=explain`}
          className="inline-flex min-h-11 items-center gap-1.5 rounded-lg px-2 text-sm font-medium text-nexus-primary hover:bg-nexus-primary-soft"
        >
          <MessageCircle className="size-4" />
          Ask Nex
        </Link>
      </div>
      <ol className="mt-4 space-y-3">
        {block.steps.slice(0, visibleSteps).map((step, stepIndex) => (
          <li
            key={stepIndex}
            className="rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3 text-sm leading-7 text-foreground"
          >
            <span className="mr-2 font-semibold text-nexus-primary">
              Step {stepIndex + 1}.
            </span>
            {step}
          </li>
        ))}
      </ol>
      {visibleSteps < block.steps.length ? (
        <Button
          type="button"
          variant="outline"
          className="mt-4 min-h-11"
          onClick={() => setVisibleSteps((count) => count + 1)}
        >
          Show next step
        </Button>
      ) : (
        <p className="mt-4 text-sm font-medium text-foreground">
          Answer: {block.answer}
        </p>
      )}
    </SectionCard>
  );
}

function CalloutBlock({
  block,
}: {
  block: Extract<LessonContentBlock, { type: "callout" }>;
}) {
  const styles = {
    info: "border-nexus-primary/30 bg-nexus-primary-soft",
    warning: "border-nexus-warning/30 bg-nexus-warning-soft",
    key_point: "border-nexus-accent/30 bg-nexus-accent-soft",
  } as const;

  const labels = {
    info: "Note",
    warning: "Warning",
    key_point: "Key point",
  } as const;

  return (
    <div
      className={cn(
        "rounded-[18px] border px-5 py-4 text-sm leading-7 text-foreground",
        styles[block.variant],
      )}
    >
      <p className="font-semibold text-foreground">{labels[block.variant]}</p>
      <p className="mt-2 whitespace-pre-wrap">{block.content}</p>
    </div>
  );
}

function ImageBlock({
  block,
}: {
  block: Extract<LessonContentBlock, { type: "image" }>;
}) {
  return (
    <figure className="space-y-2">
      {/* eslint-disable-next-line @next/next/no-img-element */}
      <img
        src={block.url}
        alt={block.alt}
        className="max-w-full rounded-[18px] border border-nexus-border"
      />
      {block.caption ? (
        <figcaption className="text-sm text-muted-foreground">{block.caption}</figcaption>
      ) : null}
    </figure>
  );
}

function TableBlock({
  block,
}: {
  block: Extract<LessonContentBlock, { type: "table" }>;
}) {
  const useHeader = block.rows.length > 1;
  const headerRow = useHeader ? block.rows[0] : null;
  const bodyRows = useHeader ? block.rows.slice(1) : block.rows;

  return (
    <figure className="space-y-2 overflow-x-auto">
      <table className="w-full min-w-[280px] border-collapse text-sm">
        {headerRow ? (
          <thead>
            <tr>
              {headerRow.map((cell, cellIndex) => (
                <th
                  key={cellIndex}
                  className="border border-nexus-border bg-nexus-sunken px-3 py-2 text-left font-semibold text-foreground"
                >
                  {cell}
                </th>
              ))}
            </tr>
          </thead>
        ) : null}
        <tbody>
          {bodyRows.map((row, rowIndex) => (
            <tr key={rowIndex}>
              {row.map((cell, cellIndex) => (
                <td
                  key={cellIndex}
                  className="border border-nexus-border px-3 py-2 text-foreground/90"
                >
                  {cell}
                </td>
              ))}
            </tr>
          ))}
        </tbody>
      </table>
      {block.caption ? (
        <figcaption className="text-sm text-muted-foreground">{block.caption}</figcaption>
      ) : null}
    </figure>
  );
}

function getVideoEmbedUrl(provider: string, url: string): string | null {
  const normalized = provider.toLowerCase();

  if (normalized === "youtube") {
    const match = url.match(
      /(?:youtube\.com\/(?:watch\?v=|embed\/)|youtu\.be\/)([A-Za-z0-9_-]{6,})/,
    );
    return match ? `https://www.youtube.com/embed/${match[1]}` : null;
  }

  if (normalized === "vimeo") {
    const match = url.match(/vimeo\.com\/(\d+)/);
    return match ? `https://player.vimeo.com/video/${match[1]}` : null;
  }

  return null;
}

function VideoEmbedBlock({
  block,
}: {
  block: Extract<LessonContentBlock, { type: "video_embed" }>;
}) {
  const embedUrl = useMemo(
    () => getVideoEmbedUrl(block.provider, block.url),
    [block.provider, block.url],
  );

  if (embedUrl) {
    return (
      <div className="space-y-2">
        {block.title ? (
          <p className="text-sm font-medium text-foreground">{block.title}</p>
        ) : null}
        <div className="aspect-video overflow-hidden rounded-[18px] border border-nexus-border bg-nexus-sunken">
          <iframe
            src={embedUrl}
            title={block.title ?? "Lesson video"}
            className="size-full"
            allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture"
            allowFullScreen
          />
        </div>
      </div>
    );
  }

  return (
    <a
      href={block.url}
      target="_blank"
      rel="noopener noreferrer"
      className="inline-flex min-h-11 items-center gap-2 rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3 text-sm font-medium text-nexus-primary hover:bg-nexus-sunken"
    >
      <ExternalLink className="size-4" />
      {block.title ?? "Open video"}
    </a>
  );
}

function FileAttachmentBlock({
  block,
}: {
  block: Extract<LessonContentBlock, { type: "file_attachment" }>;
}) {
  return (
    <a
      href={block.url}
      target="_blank"
      rel="noopener noreferrer"
      download
      className="inline-flex min-h-11 items-center gap-2 rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3 text-sm font-medium text-nexus-primary hover:bg-nexus-sunken"
    >
      <Download className="size-4" />
      {block.name}
    </a>
  );
}

function InlineQuestionBlock({ block }: { block: LessonInlineQuestionBlock }) {
  const [selectedAnswer, setSelectedAnswer] = useState<string | null>(null);
  const [shortAnswer, setShortAnswer] = useState("");
  const [submitted, setSubmitted] = useState(false);

  const isMcq = block.questionType === "multiple_choice";
  const normalizedCorrect = block.correctAnswer.trim().toLowerCase();
  const isCorrect = submitted
    ? isMcq
      ? selectedAnswer?.trim().toLowerCase() === normalizedCorrect
      : shortAnswer.trim().toLowerCase() === normalizedCorrect
    : false;

  return (
    <SectionCard title="Self-check" description="Pause and test your understanding.">
      <p className="font-medium text-foreground">{block.questionText}</p>

      {isMcq ? (
        <div className="mt-3 grid gap-2">
          {(block.options ?? []).map((option) => {
            const selected = selectedAnswer === option;
            const optionCorrect = submitted && option.trim().toLowerCase() === normalizedCorrect;
            const optionWrong =
              submitted && selected && option.trim().toLowerCase() !== normalizedCorrect;

            return (
              <button
                key={option}
                type="button"
                disabled={submitted}
                onClick={() => setSelectedAnswer(option)}
                className={cn(
                  "min-h-12 rounded-xl border px-4 py-3 text-left text-sm transition-colors",
                  selected && !submitted && "border-nexus-primary bg-nexus-primary-soft",
                  optionCorrect && "border-nexus-success bg-nexus-success-soft",
                  optionWrong && "border-nexus-danger bg-nexus-danger-soft",
                  !selected && !submitted && "border-nexus-border hover:bg-nexus-sunken",
                )}
              >
                {option}
              </button>
            );
          })}
        </div>
      ) : (
        <input
          type="text"
          value={shortAnswer}
          disabled={submitted}
          onChange={(event) => setShortAnswer(event.target.value)}
          placeholder="Type your answer"
          className="mt-3 w-full min-h-12 rounded-xl border border-nexus-border bg-nexus-surface px-4 text-sm text-foreground"
        />
      )}

      {!submitted ? (
        <Button
          type="button"
          className="mt-4 min-h-12"
          disabled={isMcq ? !selectedAnswer : shortAnswer.trim().length === 0}
          onClick={() => setSubmitted(true)}
        >
          Check answer
        </Button>
      ) : (
        <div className="mt-4 space-y-2">
          <p
            className={cn(
              "text-sm font-medium",
              isCorrect ? "text-nexus-success" : "text-nexus-danger",
            )}
          >
            {isCorrect ? "Correct!" : `Not quite — the answer is ${block.correctAnswer}.`}
          </p>
          {block.explanation ? (
            <p className="text-sm leading-7 text-muted-foreground">{block.explanation}</p>
          ) : null}
        </div>
      )}
    </SectionCard>
  );
}

export function LessonContentBlocks({ blocks, topicId }: LessonContentBlocksProps) {
  return (
    <>
      {blocks.map((block, index) => {
        switch (block.type) {
          case "heading":
            return (
              <div key={blockKey(block, index)} className="space-y-2">
                <div className="flex items-start justify-between gap-3">
                  <h2 className="font-heading text-xl font-semibold tracking-tight text-foreground">
                    {block.content}
                  </h2>
                  <Link
                    href={`/nex?topicId=${topicId}&mode=explain`}
                    className="inline-flex min-h-11 shrink-0 items-center gap-1 rounded-lg px-2 text-sm font-medium text-nexus-primary hover:bg-nexus-primary-soft"
                  >
                    <MessageCircle className="size-4" />
                    Ask Nex
                  </Link>
                </div>
              </div>
            );
          case "paragraph":
            return (
              <div key={blockKey(block, index)} className="group space-y-2">
                <p className="leading-8 text-foreground/90">{block.content}</p>
                <AskNexLink topicId={topicId} label="Ask Nex about this" />
              </div>
            );
          case "rich_text":
            return (
              <div key={blockKey(block, index)} className="group space-y-2">
                <MarkdownContent>{block.markdown}</MarkdownContent>
                <AskNexLink topicId={topicId} label="Ask Nex about this" />
              </div>
            );
          case "example":
            return (
              <WorkedExampleBlock
                key={blockKey(block, index)}
                block={block}
                topicId={topicId}
              />
            );
          case "tip":
            return (
              <div
                key={blockKey(block, index)}
                className="rounded-[18px] border border-nexus-accent/30 bg-nexus-accent-soft px-5 py-4 text-sm leading-7 text-foreground"
              >
                <p className="font-semibold text-nexus-warning">Key idea</p>
                <p className="mt-2">{block.content}</p>
              </div>
            );
          case "callout":
            return <CalloutBlock key={blockKey(block, index)} block={block} />;
          case "chemical_equation":
            return (
              <ChemicalEquationBlock
                key={blockKey(block, index)}
                block={block}
                topicId={topicId}
              />
            );
          case "math_block":
            return (
              <MathBlock key={blockKey(block, index)} block={block} topicId={topicId} />
            );
          case "comprehension_passage":
            return (
              <ComprehensionPassageBlock
                key={blockKey(block, index)}
                block={block}
                topicId={topicId}
              />
            );
          case "image":
            return <ImageBlock key={blockKey(block, index)} block={block} />;
          case "table":
            return <TableBlock key={blockKey(block, index)} block={block} />;
          case "video_embed":
            return <VideoEmbedBlock key={blockKey(block, index)} block={block} />;
          case "divider":
            return (
              <hr
                key={blockKey(block, index)}
                className="border-0 border-t border-nexus-border"
                aria-hidden
              />
            );
          case "question":
            return <InlineQuestionBlock key={blockKey(block, index)} block={block} />;
          case "file_attachment":
            return <FileAttachmentBlock key={blockKey(block, index)} block={block} />;
          default: {
            const _exhaustive: never = block;
            return _exhaustive;
          }
        }
      })}
    </>
  );
}
