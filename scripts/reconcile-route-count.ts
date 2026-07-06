#!/usr/bin/env tsx
/**
 * PR-052: reconcile documented screen counts against app page.tsx files.
 */
import { readFileSync, readdirSync, statSync } from "node:fs";
import { join, extname } from "node:path";

const ROOT = join(import.meta.dirname, "..");
const APP_DIR = join(ROOT, "src", "app");

function walkPages(dir: string, files: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      walkPages(full, files);
    } else if (entry === "page.tsx") {
      files.push(full);
    }
  }
  return files;
}

const pages = walkPages(APP_DIR);
const inventoryPath = join(ROOT, "docs", "phase-4-ux", "screen-inventory.md");
const inventory = readFileSync(inventoryPath, "utf8");
const documentedTotalMatch = inventory.match(/Total screens:\*\* (\d+)/i);

console.log(`Discovered page routes: ${pages.length}`);
for (const page of pages.sort()) {
  console.log(`- ${page.replace(/\\/g, "/").replace(`${ROOT.replace(/\\/g, "/")}/`, "")}`);
}

if (!documentedTotalMatch) {
  console.error("Could not find documented total in screen-inventory.md");
  process.exit(1);
}

const documentedTotal = Number(documentedTotalMatch[1]);
if (documentedTotal !== pages.length) {
  console.error(
    `Screen inventory mismatch: docs claim ${documentedTotal}, filesystem has ${pages.length}.`,
  );
  process.exit(1);
}

console.log("Route-count reconciliation passed.");
