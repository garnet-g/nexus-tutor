#!/usr/bin/env tsx
/**
 * Estimate draft-generation scope from seed files (no DB required).
 * Mirrors generateDrafts.ts filters for Math (all) + English low-risk only.
 */
import { readFileSync } from "fs";
import { join } from "path";

const ROOT = join(import.meta.dirname, "..");
const SEED = join(ROOT, "supabase", "seed");

const DEPRECATED_MATH = new Set(["algebra", "geometry", "trigonometry", "statistics"]);

function countMatches(file: string, pattern: RegExp): number {
  const text = readFileSync(file, "utf-8");
  return (text.match(pattern) ?? []).length;
}

function estimateFromSeeds() {
  const mathCbcSubtopics = countMatches(
    join(SEED, "curriculum_math.sql"),
    /WHERE c\.code = 'CBC' AND s\.code = 'mathematics'/g,
  );
  const mathKcseSubtopics = countMatches(
    join(SEED, "curriculum_math_kcse.sql"),
    /INSERT INTO public\.subtopics/g,
  );
  const mathLegacyKcseSubtopics = countMatches(
    join(SEED, "curriculum_math.sql"),
    /WHERE c\.code = 'KCSE' AND s\.code = 'mathematics'/g,
  );

  const mathKcseTopics = countMatches(
    join(SEED, "curriculum_math_kcse.sql"),
    /INSERT INTO public\.topics/g,
  );
  const mathLegacyKcseTopics = 5;
  const mathCbcTopics = 3;

  const engCbcSubtopics = countMatches(
    join(SEED, "curriculum_english.sql"),
    /WHERE c\.code = 'CBC' AND s\.code = 'english'/g,
  );
  const engKcseSubtopics = countMatches(
    join(SEED, "curriculum_english_kcse.sql"),
    /INSERT INTO public\.subtopics/g,
  );
  const engKcseTopics = countMatches(
    join(SEED, "curriculum_english_kcse.sql"),
    /INSERT INTO public\.topics/g,
  );
  const engLegacyTopics = 3;

  const lowRiskEngKcseTopics = engKcseTopics;
  const lowRiskEngCbcTopics = engLegacyTopics;

  const activeMathKcseTopics = mathKcseTopics + mathLegacyKcseTopics - DEPRECATED_MATH.size;
  const activeMathCbcTopics = mathCbcTopics;

  const lessonJobs =
    mathCbcSubtopics +
    mathKcseSubtopics +
    mathLegacyKcseSubtopics +
    engCbcSubtopics +
    engKcseSubtopics;

  const questionJobs =
    (activeMathCbcTopics + activeMathKcseTopics + lowRiskEngCbcTopics + lowRiskEngKcseTopics) *
    3;

  const totalCalls = lessonJobs + questionJobs;
  const costLow = Number((totalCalls * 0.002).toFixed(2));
  const costHigh = Number((totalCalls * 0.006).toFixed(2));

  console.log("=== Estimated scope (fresh db:reset with Phase 1 seeds) ===\n");
  console.log("Mathematics CBC: ~3 topics, ~9 subtopics (legacy seeded lessons → 0 lesson jobs if idempotent)");
  console.log(`Mathematics KCSE: ~${activeMathKcseTopics} active topics, ~${mathKcseSubtopics + mathLegacyKcseSubtopics} subtopics`);
  console.log(`English CBC low-risk: ~${lowRiskEngCbcTopics} topics, ~${engCbcSubtopics} subtopics`);
  console.log(`English KCSE low-risk: ~${lowRiskEngKcseTopics} topics, ~${engKcseSubtopics} subtopics`);
  console.log("\nIf NO prior lessons/questions (skeleton-only KCSE expansion):");
  console.log(`  Lesson jobs: ~${lessonJobs} (minus legacy CBC/KCSE math+english already in curriculum_math/english.sql)`);
  console.log(`  Question jobs: ~${questionJobs} (topics × 3 difficulties)`);
  console.log(`  Model calls: ~${totalCalls}`);
  console.log(`  Rough cost: $${costLow} – $${costHigh} USD`);
  console.log("\nIdempotent re-run skips subtopics with lessons and topic×difficulty at ≥7 questions.");
}

estimateFromSeeds();
