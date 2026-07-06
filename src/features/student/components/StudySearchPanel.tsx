"use client";

import Link from "next/link";
import { useEffect, useState } from "react";
import { Search } from "lucide-react";

type SearchHit = {
  id: string;
  kind: "lesson" | "question";
  title: string;
  excerpt: string;
  href: string;
  topicTitle: string | null;
};

export function StudySearchPanel() {
  const [query, setQuery] = useState("");
  const [hits, setHits] = useState<SearchHit[]>([]);
  const [loading, setLoading] = useState(false);

  useEffect(() => {
    if (query.trim().length < 2) {
      return;
    }

    const handle = window.setTimeout(async () => {
      setLoading(true);
      try {
        const response = await fetch(
          `/api/students/search?q=${encodeURIComponent(query.trim())}`,
        );
        const body = await response.json();
        setHits(response.ok && body.success ? body.data.hits : []);
      } catch {
        setHits([]);
      } finally {
        setLoading(false);
      }
    }, 250);

    return () => window.clearTimeout(handle);
  }, [query]);

  const visibleHits = query.trim().length < 2 ? [] : hits;

  return (
    <div className="space-y-4 rounded-2xl border border-nexus-border bg-nexus-surface p-4">
      <label className="block text-sm font-medium text-foreground">
        Search lessons and practice questions
        <div className="mt-2 flex items-center gap-3 rounded-xl bg-nexus-sunken px-3 py-3 text-muted-foreground">
          <Search className="size-5" />
          <input
            value={query}
            onChange={(event) => setQuery(event.target.value)}
            placeholder="Try algebra, fractions, photosynthesis…"
            className="w-full bg-transparent text-sm text-foreground outline-none placeholder:text-muted-foreground"
          />
        </div>
      </label>

      {loading ? <p className="text-sm text-muted-foreground">Searching…</p> : null}

      {visibleHits.length > 0 ? (
        <ul className="space-y-2">
          {visibleHits.map((hit) => (
            <li key={`${hit.kind}-${hit.id}`}>
              <Link
                href={hit.href}
                className="block rounded-xl border border-nexus-border bg-nexus-background px-4 py-3 transition-colors hover:bg-nexus-sunken"
              >
                <p className="text-xs font-semibold uppercase tracking-wide text-muted-foreground">
                  {hit.kind === "lesson" ? "Lesson" : "Question"}
                  {hit.topicTitle ? ` · ${hit.topicTitle}` : ""}
                </p>
                <p className="mt-1 font-medium text-foreground">{hit.title}</p>
                <p className="text-sm text-muted-foreground">{hit.excerpt}</p>
              </Link>
            </li>
          ))}
        </ul>
      ) : null}

      {query.trim().length >= 2 && !loading && hits.length === 0 ? (
        <p className="text-sm text-muted-foreground">No published matches yet.</p>
      ) : null}
    </div>
  );
}
