const FORMULA_INJECTION_PATTERN = /^[=+\-@\t\r]/;

export function escapeCsvCell(value: string | number | null | undefined): string {
  let text = String(value ?? "");

  if (FORMULA_INJECTION_PATTERN.test(text)) {
    text = `'${text}`;
  }

  if (/[",\n\r]/.test(text)) {
    return `"${text.replace(/"/g, '""')}"`;
  }

  return text;
}

export function buildCsv(headers: string[], rows: Array<Array<string | number>>): string {
  const lines = [
    headers.map((header) => escapeCsvCell(header)).join(","),
    ...rows.map((row) => row.map((cell) => escapeCsvCell(cell)).join(",")),
  ];

  return `${lines.join("\n")}\n`;
}
