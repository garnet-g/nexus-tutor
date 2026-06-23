"use client";

import Link from "@tiptap/extension-link";
import Placeholder from "@tiptap/extension-placeholder";
import Underline from "@tiptap/extension-underline";
import { Markdown } from "@tiptap/markdown";
import { EditorContent, useEditor } from "@tiptap/react";
import StarterKit from "@tiptap/starter-kit";
import { useEffect } from "react";

import { Button } from "@/components/ui/Button";
import { cn } from "@/lib/utils";

interface RichTextBlockEditorProps {
  markdown: string;
  onChange: (markdown: string) => void;
  className?: string;
}

export function RichTextBlockEditor({
  markdown,
  onChange,
  className,
}: RichTextBlockEditorProps) {
  const editor = useEditor({
    extensions: [
      StarterKit.configure({
        heading: { levels: [2, 3] },
      }),
      Link.configure({
        openOnClick: false,
        HTMLAttributes: { class: "text-nexus-primary underline" },
      }),
      Underline,
      Placeholder.configure({
        placeholder: "Write lesson content… Type / for blocks in the margin.",
      }),
      Markdown,
    ],
    content: markdown,
    contentType: "markdown",
    immediatelyRender: false,
    editorProps: {
      attributes: {
        class:
          "min-h-[120px] rounded-xl border border-nexus-border bg-nexus-sunken px-3 py-2 text-sm leading-7 text-foreground outline-none focus:border-primary focus:ring-2 focus:ring-primary/20",
      },
    },
    onUpdate: ({ editor: currentEditor }) => {
      onChange(currentEditor.getMarkdown());
    },
  });

  useEffect(() => {
    if (!editor) {
      return;
    }

    const current = editor.getMarkdown();
    if (current !== markdown) {
      editor.commands.setContent(markdown, { contentType: "markdown" });
    }
  }, [editor, markdown]);

  if (!editor) {
    return null;
  }

  return (
    <div className={cn("space-y-2", className)}>
      <div className="flex flex-wrap gap-1">
        <Button
          type="button"
          size="sm"
          variant={editor.isActive("bold") ? "default" : "outline"}
          onClick={() => editor.chain().focus().toggleBold().run()}
        >
          Bold
        </Button>
        <Button
          type="button"
          size="sm"
          variant={editor.isActive("italic") ? "default" : "outline"}
          onClick={() => editor.chain().focus().toggleItalic().run()}
        >
          Italic
        </Button>
        <Button
          type="button"
          size="sm"
          variant={editor.isActive("underline") ? "default" : "outline"}
          onClick={() => editor.chain().focus().toggleUnderline().run()}
        >
          Underline
        </Button>
        <Button
          type="button"
          size="sm"
          variant={editor.isActive("bulletList") ? "default" : "outline"}
          onClick={() => editor.chain().focus().toggleBulletList().run()}
        >
          List
        </Button>
        <Button
          type="button"
          size="sm"
          variant={editor.isActive("orderedList") ? "default" : "outline"}
          onClick={() => editor.chain().focus().toggleOrderedList().run()}
        >
          Numbered
        </Button>
        <Button
          type="button"
          size="sm"
          variant="outline"
          onClick={() => {
            const previous = editor.getAttributes("link").href as string | undefined;
            const url = window.prompt("Link URL", previous ?? "https://");
            if (url === null) {
              return;
            }
            if (url === "") {
              editor.chain().focus().extendMarkRange("link").unsetLink().run();
              return;
            }
            editor.chain().focus().extendMarkRange("link").setLink({ href: url }).run();
          }}
        >
          Link
        </Button>
        <Button
          type="button"
          size="sm"
          variant="outline"
          onClick={() => {
            const formula = window.prompt("Inline math (LaTeX)", "x^2");
            if (!formula) {
              return;
            }
            editor.chain().focus().insertContent(`$${formula}$`).run();
          }}
        >
          Math
        </Button>
      </div>
      <EditorContent editor={editor} />
    </div>
  );
}
