"use client";

import Link from "next/link";
import { useMemo, useState } from "react";
import { Library, Search } from "lucide-react";

import type { ConceptReferenceHit } from "@/server/services/conceptLibraryService";

export function ConceptLibraryBrowser({
  references,
  curriculum,
}: {
  references: ConceptReferenceHit[];
  curriculum: string;
}) {
  const [query, setQuery] = useState("");

  const filtered = useMemo(() => {
    const needle = query.trim().toLowerCase();
    if (needle.length < 2) {
      return references;
    }

    return references.filter(
      (reference) =>
        reference.title.toLowerCase().includes(needle) ||
        reference.body.toLowerCase().includes(needle) ||
        (reference.topicTitle?.toLowerCase().includes(needle) ?? false),
    );
  }, [query, references]);

  return (
    <div className="space-y-4">
      <label className="block rounded-2xl border border-nexus-border bg-nexus-surface p-4 text-sm font-medium text-foreground">
        Search concepts
        <div className="mt-2 flex items-center gap-3 rounded-xl bg-nexus-sunken px-3 py-3 text-muted-foreground">
          <Search className="size-5" />
          <input
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder="Search formulas, definitions, key points…"
            className="w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
          />
        </div>
      </label>

      {filtered.length > 0 ? (
        <section className="grid gap-4 lg:grid-cols-2">
          {filtered.map((reference) => (
            <article
              key={reference.id}
              className="rounded-2xl border border-nexus-border bg-nexus-surface p-4"
            >
              <div className="flex items-start gap-3">
                <span className="flex size-10 flex-none items-center justify-center rounded-xl bg-nexus-sunken text-nexus-primary">
                  <Library className="size-5" />
                </span>
                <div className="min-w-0 flex-1">
                  <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                    {reference.category}
                    {reference.topicTitle ? ` · ${reference.topicTitle}` : ` · ${curriculum}`}
                  </p>
                  <h2 className="mt-1 font-semibold text-foreground">{reference.title}</h2>
                  {reference.summary ? (
                    <p className="mt-1 text-sm text-muted-foreground">{reference.summary}</p>
                  ) : null}
                  <p className="mt-3 whitespace-pre-wrap text-sm text-foreground">{reference.body}</p>
                  {reference.lessonHref ? (
                    <Link
                      href={reference.lessonHref}
                      className="mt-3 inline-block text-sm font-medium text-nexus-primary"
                    >
                      Open source lesson
                    </Link>
                  ) : null}
                </div>
              </div>
            </article>
          ))}
        </section>
      ) : (
        <p className="text-sm text-muted-foreground">
          No published concept references match yet. Complete lessons to surface formulas and key
          points from your curriculum.
        </p>
      )}
    </div>
  );
}
