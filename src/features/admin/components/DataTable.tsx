"use client";

import { useMemo, useState, type ReactNode } from "react";

import { cn } from "@/lib/utils";

import { SearchInput } from "./adminUi";

export interface Column<T> {
  key: string;
  header: ReactNode;
  align?: "left" | "right";
  /** Cell renderer. */
  render: (row: T) => ReactNode;
  /** Enables click-to-sort on this column header. */
  sortable?: boolean;
  /** Comparable value for sorting (defaults to text from `searchValue`). */
  sortValue?: (row: T) => string | number;
  /** Text contributed to the client-side search filter. */
  searchValue?: (row: T) => string;
  /** Value written to CSV for this column (defaults to `searchValue`). */
  exportValue?: (row: T) => string | number;
  className?: string;
  thClassName?: string;
}

interface DataTableProps<T> {
  columns: Column<T>[];
  rows: T[];
  getRowKey: (row: T) => string;
  emptyMessage?: ReactNode;
  /** Show a client-side search box filtering across columns' `searchValue`. */
  searchable?: boolean;
  searchPlaceholder?: string;
  /** When set, renders a CSV export button using this base filename. */
  exportFilename?: string;
  /** Extra controls rendered in the toolbar (right side). */
  toolbar?: ReactNode;
  rowClassName?: string;
}

type SortDir = "asc" | "desc";

function downloadCsv<T>(filename: string, columns: Column<T>[], rows: T[]) {
  const headerCells = columns.map((c) =>
    typeof c.header === "string" ? c.header : c.key,
  );
  const escape = (value: string | number) => {
    const s = String(value ?? "");
    return /[",\n]/.test(s) ? `"${s.replace(/"/g, '""')}"` : s;
  };
  const lines = [
    headerCells.map(escape).join(","),
    ...rows.map((row) =>
      columns
        .map((c) => {
          const val = c.exportValue
            ? c.exportValue(row)
            : c.searchValue
              ? c.searchValue(row)
              : "";
          return escape(val);
        })
        .join(","),
    ),
  ];
  const blob = new Blob([lines.join("\n")], { type: "text/csv;charset=utf-8;" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = `${filename}.csv`;
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
  URL.revokeObjectURL(url);
}

/**
 * Generic admin table with optional client-side search, sort, and CSV export.
 * Operates purely on the already-fetched `rows` — no server round-trips.
 */
export function DataTable<T>({
  columns,
  rows,
  getRowKey,
  emptyMessage = "No records found.",
  searchable = false,
  searchPlaceholder = "Search…",
  exportFilename,
  toolbar,
  rowClassName,
}: DataTableProps<T>) {
  const [query, setQuery] = useState("");
  const [sortKey, setSortKey] = useState<string | null>(null);
  const [sortDir, setSortDir] = useState<SortDir>("asc");

  const filtered = useMemo(() => {
    const q = query.trim().toLowerCase();
    if (!q) {
      return rows;
    }
    const searchCols = columns.filter((c) => c.searchValue);
    return rows.filter((row) =>
      searchCols.some((c) => c.searchValue!(row).toLowerCase().includes(q)),
    );
  }, [rows, query, columns]);

  const sorted = useMemo(() => {
    if (!sortKey) {
      return filtered;
    }
    const col = columns.find((c) => c.key === sortKey);
    if (!col) {
      return filtered;
    }
    const value = (row: T): string | number =>
      col.sortValue
        ? col.sortValue(row)
        : col.searchValue
          ? col.searchValue(row)
          : "";
    const dir = sortDir === "asc" ? 1 : -1;
    return [...filtered].sort((a, b) => {
      const va = value(a);
      const vb = value(b);
      if (typeof va === "number" && typeof vb === "number") {
        return (va - vb) * dir;
      }
      return String(va).localeCompare(String(vb)) * dir;
    });
  }, [filtered, sortKey, sortDir, columns]);

  function toggleSort(key: string) {
    if (sortKey === key) {
      setSortDir((d) => (d === "asc" ? "desc" : "asc"));
    } else {
      setSortKey(key);
      setSortDir("asc");
    }
  }

  const showToolbar = searchable || exportFilename || toolbar;

  return (
    <div>
      {showToolbar ? (
        <div className="flex flex-wrap items-center justify-between gap-3 px-5 py-3">
          <div className="flex items-center gap-3">
            {searchable ? (
              <SearchInput
                value={query}
                onChange={setQuery}
                placeholder={searchPlaceholder}
              />
            ) : null}
            <span className="text-xs text-muted-foreground">
              {sorted.length} {sorted.length === 1 ? "row" : "rows"}
            </span>
          </div>
          <div className="flex items-center gap-2">
            {toolbar}
            {exportFilename ? (
              <button
                type="button"
                onClick={() => downloadCsv(exportFilename, columns, sorted)}
                disabled={sorted.length === 0}
                className="inline-flex items-center gap-1.5 rounded-lg border border-nexus-border bg-nexus-sunken px-3 py-1.5 text-xs font-medium text-muted-foreground transition-colors hover:text-foreground disabled:opacity-50"
              >
                <svg viewBox="0 0 24 24" width="14" height="14" fill="none" stroke="currentColor" strokeWidth="1.8" strokeLinecap="round" strokeLinejoin="round" aria-hidden>
                  <path d="M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" />
                  <path d="M7 10l5 5 5-5" />
                  <path d="M12 15V3" />
                </svg>
                Export CSV
              </button>
            ) : null}
          </div>
        </div>
      ) : null}
      <div className="overflow-x-auto">
        <table className="w-full text-sm">
          <thead>
            <tr className="border-b border-nexus-border text-left text-xs uppercase tracking-wide text-muted-foreground">
              {columns.map((col) => {
                const active = sortKey === col.key;
                return (
                  <th
                    key={col.key}
                    className={cn(
                      "px-5 py-3 font-medium",
                      col.align === "right" && "text-right",
                      col.thClassName,
                    )}
                  >
                    {col.sortable ? (
                      <button
                        type="button"
                        onClick={() => toggleSort(col.key)}
                        className={cn(
                          "inline-flex items-center gap-1 uppercase tracking-wide transition-colors hover:text-foreground",
                          active && "text-foreground",
                        )}
                      >
                        {col.header}
                        <span className="text-[0.65rem]">
                          {active ? (sortDir === "asc" ? "▲" : "▼") : "↕"}
                        </span>
                      </button>
                    ) : (
                      col.header
                    )}
                  </th>
                );
              })}
            </tr>
          </thead>
          <tbody>
            {sorted.length === 0 ? (
              <tr>
                <td
                  colSpan={columns.length}
                  className="px-5 py-10 text-center text-muted-foreground"
                >
                  {emptyMessage}
                </td>
              </tr>
            ) : (
              sorted.map((row) => (
                <tr
                  key={getRowKey(row)}
                  className={cn(
                    "border-b border-nexus-border last:border-0 hover:bg-nexus-sunken/60",
                    rowClassName,
                  )}
                >
                  {columns.map((col) => (
                    <td
                      key={col.key}
                      className={cn(
                        "px-5 py-3",
                        col.align === "right" && "text-right",
                        col.className,
                      )}
                    >
                      {col.render(row)}
                    </td>
                  ))}
                </tr>
              ))
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
}
