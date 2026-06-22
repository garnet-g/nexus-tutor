#!/usr/bin/env tsx
/**
 * Scope-check: banned V2 routes, client service role, hardcoded pricing in API handlers.
 */
import { readFileSync, readdirSync, statSync } from 'fs';
import { join, extname } from 'path';

const ROOT = join(import.meta.dirname, '..');
const SRC = join(ROOT, 'src');

const BANNED_ROUTE_PATTERNS = [
  /\/api\/v2\//,
  /\/api\/assessment-mode/,
  /\/api\/model-router/,
];

const BANNED_V2_ROUTE_PATTERNS = [
  /\/api\/nex\/voice/,
  /\/api\/mock-exams/,
  /\/api\/exam-simulator/,
  /\/api\/study-groups/,
  /\/api\/schools/,
  /\/api\/teachers/,
  /\/api\/career/,
  /\/api\/university/,
  /\/api\/leaderboards/,
];

const ALLOWED_V2_ROUTE_PATTERNS = [
  /\/api\/nex\/camera/,
  /\/api\/nex\/voice/,
  /\/api\/mock-exams/,
  /\/api\/exam-simulator/,
];

const BANNED_CLIENT_PATTERNS = [
  /SUPABASE_SERVICE_ROLE/,
  /service_role/i,
];

const HARDCODED_PRICING_PATTERNS = [
  /\b799\b.*(?:amount|price|kes)/i,
  /\b2499\b.*(?:amount|price|kes)/i,
];

const BANNED_SUBJECT_CODES = [
  /['"]cambridge['"]/,
];

const errors: string[] = [];

function walk(dir: string, files: string[] = []): string[] {
  for (const entry of readdirSync(dir)) {
    const full = join(dir, entry);
    if (statSync(full).isDirectory()) {
      if (entry === 'node_modules' || entry === '.next') continue;
      walk(full, files);
    } else if (['.ts', '.tsx'].includes(extname(entry))) {
      files.push(full);
    }
  }
  return files;
}

function isClientFile(path: string, content: string): boolean {
  return path.includes('components') || content.includes("'use client'") || content.includes('"use client"');
}

function isApiHandler(path: string): boolean {
  return path.includes(join('app', 'api'));
}

const files = walk(SRC);

for (const file of files) {
  const content = readFileSync(file, 'utf-8');
  const rel = file.replace(ROOT + '\\', '').replace(ROOT + '/', '');

  for (const pattern of BANNED_ROUTE_PATTERNS) {
    if (pattern.test(content)) {
      errors.push(`${rel}: banned route pattern ${pattern}`);
    }
  }

  for (const pattern of BANNED_V2_ROUTE_PATTERNS) {
    if (pattern.test(content) && !ALLOWED_V2_ROUTE_PATTERNS.some((allowed) => allowed.test(content))) {
      errors.push(`${rel}: banned V2 route pattern ${pattern}`);
    }
  }

  if (isClientFile(file, content)) {
    for (const pattern of BANNED_CLIENT_PATTERNS) {
      if (pattern.test(content) && !content.includes('Never import')) {
        errors.push(`${rel}: service role reference in client code`);
      }
    }
  }

  if (isApiHandler(file)) {
    for (const pattern of HARDCODED_PRICING_PATTERNS) {
      if (pattern.test(content)) {
        errors.push(`${rel}: hardcoded pricing in API handler`);
      }
    }
  }
}

const seedPaths = [
  join(ROOT, 'supabase/seed.sql'),
  join(ROOT, 'supabase/seed/curriculum_math.sql'),
  join(ROOT, 'supabase/seed/curriculum_math_kcse.sql'),
  join(ROOT, 'supabase/seed/curriculum_science.sql'),
  join(ROOT, 'supabase/seed/curriculum_english.sql'),
  join(ROOT, 'supabase/seed/curriculum_english_kcse.sql'),
  join(ROOT, 'supabase/seed/curriculum_chemistry.sql'),
  join(ROOT, 'supabase/seed/curriculum_kiswahili.sql'),
];

for (const seedPath of seedPaths) {
  const content = readFileSync(seedPath, 'utf-8');
  const rel = seedPath.replace(ROOT + '\\', '').replace(ROOT + '/', '');

  for (const pattern of BANNED_SUBJECT_CODES) {
    if (pattern.test(content) && /INSERT INTO public\.subjects/.test(content)) {
      errors.push(`${rel}: banned Tier 2+ subject activation (${pattern})`);
    }
  }
}

if (errors.length > 0) {
  console.error('Scope check FAILED:\n' + errors.join('\n'));
  process.exit(1);
}

console.log('Scope check passed.');
