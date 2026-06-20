"use client";

// DEP-FLAG: katex + react-markdown stack — math tutor must render LaTeX correctly.
// Security: react-markdown does not emit raw HTML; remark-math/rehype-katex only
// transform explicit math delimiters ($...$, $$...$$).

import ReactMarkdown from "react-markdown";
import remarkGfm from "remark-gfm";
import remarkMath from "remark-math";
import rehypeKatex from "rehype-katex";
import type { Components } from "react-markdown";

import { cn } from "@/lib/utils";

import "katex/dist/katex.min.css";

interface NexMessageContentProps {
  content: string;
  variant?: "nex" | "student";
  isStreaming?: boolean;
}

const baseComponents: Components = {
  p: ({ children }) => <p className="mb-3 last:mb-0">{children}</p>,
  ul: ({ children }) => (
    <ul className="mb-3 list-disc space-y-1 pl-5 last:mb-0">{children}</ul>
  ),
  ol: ({ children }) => (
    <ol className="mb-3 list-decimal space-y-1 pl-5 last:mb-0">{children}</ol>
  ),
  li: ({ children }) => <li>{children}</li>,
  blockquote: ({ children }) => (
    <blockquote className="mb-3 border-l-2 border-nexus-primary/40 pl-3 italic text-muted-foreground last:mb-0">
      {children}
    </blockquote>
  ),
  strong: ({ children }) => <strong className="font-semibold">{children}</strong>,
  pre: ({ children }) => (
    <pre className="mb-3 overflow-x-auto rounded-xl bg-nexus-sunken p-3 last:mb-0">
      {children}
    </pre>
  ),
  code: ({ className, children, ...props }) => {
    const isBlock = Boolean(className?.includes("language-"));
    if (isBlock) {
      return (
        <code
          className={cn("font-mono text-xs text-foreground", className)}
          {...props}
        >
          {children}
        </code>
      );
    }

    return (
      <code
        className="rounded-md bg-nexus-sunken px-1.5 py-0.5 font-mono text-xs"
        {...props}
      >
        {children}
      </code>
    );
  },
};

export function NexMessageContent({
  content,
  variant = "nex",
  isStreaming = false,
}: NexMessageContentProps) {
  const studentComponents: Components =
    variant === "student"
      ? {
          ...baseComponents,
          blockquote: ({ children }) => (
            <blockquote className="mb-3 border-l-2 border-nexus-text-inverse/40 pl-3 italic opacity-90 last:mb-0">
              {children}
            </blockquote>
          ),
          code: ({ className, children, ...props }) => {
            const isBlock = Boolean(className?.includes("language-"));
            if (isBlock) {
              return (
                <code
                  className={cn("font-mono text-xs", className)}
                  {...props}
                >
                  {children}
                </code>
              );
            }

            return (
              <code
                className="rounded-md bg-nexus-primary-dark/30 px-1.5 py-0.5 font-mono text-xs"
                {...props}
              >
                {children}
              </code>
            );
          },
          pre: ({ children }) => (
            <pre className="mb-3 overflow-x-auto rounded-xl bg-nexus-primary-dark/30 p-3 last:mb-0">
              {children}
            </pre>
          ),
        }
      : baseComponents;

  const remarkPlugins = isStreaming ? [remarkGfm] : [remarkGfm, remarkMath];
  const rehypePlugins = isStreaming ? [] : [rehypeKatex];

  return (
    <div
      className={cn(
        "nex-message-content max-w-none break-words",
        variant === "student" && "text-nexus-text-inverse",
      )}
    >
      <ReactMarkdown
        remarkPlugins={remarkPlugins}
        rehypePlugins={rehypePlugins}
        components={studentComponents}
      >
        {content}
      </ReactMarkdown>
    </div>
  );
}
