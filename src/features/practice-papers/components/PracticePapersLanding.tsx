"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { FileText } from "lucide-react";

import { SectionCard } from "@/components/ui/SectionCard";
import type { PastPaperSummary } from "@/server/services/pastPaperService";

interface PracticePapersLandingProps {
  papers: PastPaperSummary[];
}

export function PracticePapersLanding({ papers }: PracticePapersLandingProps) {
  const [subjectFilter, setSubjectFilter] = useState<string>("all");

  const subjects = useMemo(() => {
    const unique = new Map<string, string>();
    for (const paper of papers) {
      unique.set(paper.subjectId, paper.subjectName);
    }
    return Array.from(unique.entries());
  }, [papers]);

  const filteredPapers = useMemo(() => {
    if (subjectFilter === "all") {
      return papers;
    }
    return papers.filter((paper) => paper.subjectId === subjectFilter);
  }, [papers, subjectFilter]);

  if (papers.length === 0) {
    return (
      <SectionCard title="No practice papers yet">
        <p className="text-sm text-muted-foreground">
          Check back soon — new practice papers are added regularly.
        </p>
      </SectionCard>
    );
  }

  return (
    <div className="space-y-4">
      {subjects.length > 1 ? (
        <div className="flex flex-wrap gap-2">
          <button
            type="button"
            onClick={() => setSubjectFilter("all")}
            className={`rounded-full border px-3 py-1.5 text-sm ${
              subjectFilter === "all"
                ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse"
                : "border-nexus-border bg-nexus-surface text-foreground"
            }`}
          >
            All subjects
          </button>
          {subjects.map(([id, name]) => (
            <button
              key={id}
              type="button"
              onClick={() => setSubjectFilter(id)}
              className={`rounded-full border px-3 py-1.5 text-sm ${
                subjectFilter === id
                  ? "border-nexus-primary bg-nexus-primary text-nexus-text-inverse"
                  : "border-nexus-border bg-nexus-surface text-foreground"
              }`}
            >
              {name}
            </button>
          ))}
        </div>
      ) : null}

      <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
        {filteredPapers.map((paper) => (
          <Link
            key={paper.id}
            href={`/practice-papers/${paper.id}/attempt`}
            className="rounded-[18px] border border-nexus-border bg-nexus-surface p-5 shadow-card transition-colors hover:bg-nexus-sunken"
          >
            <FileText className="size-5 text-nexus-primary" />
            <h2 className="mt-3 font-heading text-lg font-semibold text-foreground">
              {paper.name}
            </h2>
            <p className="mt-1 text-sm text-muted-foreground">
              {paper.subjectName} · {paper.paperYear}
            </p>
            <p className="mt-2 text-xs text-muted-foreground">
              {paper.durationMinutes} min · {paper.totalMarks} marks
            </p>
          </Link>
        ))}
      </div>
    </div>
  );
}
