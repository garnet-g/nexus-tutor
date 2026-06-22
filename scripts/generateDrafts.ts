#!/usr/bin/env tsx
/**
 * Batch draft generator — reuses contentGenerationService (drafts only, never publish).
 *
 * Usage:
 *   npm run content:generate-drafts -- --dry-run
 *   npm run content:generate-drafts -- --subjects=mathematics --curricula=KCSE --min-grade-sort-order=1 --max-grade-sort-order=1
 */
import { existsSync, readFileSync } from "fs";
import { join } from "path";

import { createClient, type SupabaseClient } from "@supabase/supabase-js";

import {
  generateLessonDraft,
  generateQuestionBankDraft,
} from "@/server/services/contentGenerationService";

const ROOT = join(import.meta.dirname, "..");

type CurriculumCode = "CBC" | "KCSE";
type SubjectCode = "mathematics" | "english";
type Difficulty = "easy" | "medium" | "hard";

const DIFFICULTIES: Difficulty[] = ["easy", "medium", "hard"];

const ENGLISH_LOW_RISK_TOPIC_CODES = new Set([
  "reading_comprehension",
  "study_skills",
  "grammar",
  "nouns_pronouns",
  "verbs_tenses",
  "phrases_clauses",
  "voice_speech",
  "prepositions_phrasal_verbs",
  "question_tags_agreement",
  "punctuation_mechanics",
  "word_formation",
  "writing_skills",
  "functional_writing",
  "official_documents",
  "short_functional_texts",
  "summary_writing",
]);

const HELD_ENGLISH_TOPIC_CODES = new Set([
  "creative_composition",
  "essay_writing_skills",
  "literary_appreciation",
  "poetry",
  "the_novel_set_text",
  "the_play_set_text",
  "short_stories_set_text",
  "oral_narrative_essay",
  "pronunciation_articulation",
  "stress_intonation",
  "listening_comprehension",
  "oral_etiquette_skills",
  "oral_literature",
  "intensive_reading",
  "extensive_reading",
]);

interface CliArgs {
  subjects: SubjectCode[];
  curricula: CurriculumCode[];
  topicCodes: Set<string> | "all";
  lessonsPerSubtopic: number;
  questionsPerDifficulty: number;
  limit: number | null;
  dryRun: boolean;
  minGradeSortOrder: number | null;
  maxGradeSortOrder: number | null;
  throttleMs: number;
}

interface WorkSubtopic {
  subtopicId: string;
  subtopicCode: string;
  subtopicTitle: string;
  topicId: string;
  topicCode: string;
  topicTitle: string;
  subjectCode: SubjectCode;
  curriculum: CurriculumCode;
  gradeLevel: string;
  minGradeSortOrder: number;
  existingLessonCount: number;
}

interface WorkQuestionBatch {
  topicId: string;
  topicCode: string;
  topicTitle: string;
  subjectCode: SubjectCode;
  curriculum: CurriculumCode;
  gradeLevel: string;
  minGradeSortOrder: number;
  difficulty: Difficulty;
  existingCount: number;
  neededCount: number;
}

interface SubjectReport {
  subjectCode: SubjectCode;
  curriculum: CurriculumCode;
  topicsProcessed: Set<string>;
  lessonsDrafted: number;
  questionsDrafted: number;
  lessonsSkipped: number;
  questionsSkipped: number;
  failures: Array<{ kind: "lesson" | "questions"; ref: string; reason: string }>;
}

function loadEnvLocal() {
  const envPath = join(ROOT, ".env.local");
  if (!existsSync(envPath)) {
    return;
  }

  for (const line of readFileSync(envPath, "utf-8").split("\n")) {
    const trimmed = line.trim();
    if (!trimmed || trimmed.startsWith("#")) {
      continue;
    }

    const separator = trimmed.indexOf("=");
    if (separator === -1) {
      continue;
    }

    const key = trimmed.slice(0, separator).trim();
    let value = trimmed.slice(separator + 1).trim();
    if (
      (value.startsWith('"') && value.endsWith('"')) ||
      (value.startsWith("'") && value.endsWith("'"))
    ) {
      value = value.slice(1, -1);
    }

    if (!process.env[key]) {
      process.env[key] = value;
    }
  }
}

function parseCliArgs(argv: string[]): CliArgs {
  const args: CliArgs = {
    subjects: ["mathematics", "english"],
    curricula: ["CBC", "KCSE"],
    topicCodes: "all",
    lessonsPerSubtopic: 1,
    questionsPerDifficulty: 7,
    limit: null,
    dryRun: false,
    minGradeSortOrder: null,
    maxGradeSortOrder: null,
    throttleMs: 1500,
  };

  for (const raw of argv) {
    if (raw === "--dry-run") {
      args.dryRun = true;
      continue;
    }

    const [key, value] = raw.split("=", 2);
    if (!value) {
      continue;
    }

    switch (key) {
      case "--subjects":
        args.subjects = value.split(",").map((item) => item.trim()) as SubjectCode[];
        break;
      case "--curricula":
        args.curricula = value.split(",").map((item) => item.trim()) as CurriculumCode[];
        break;
      case "--topics":
        args.topicCodes =
          value === "all" ? "all" : new Set(value.split(",").map((item) => item.trim()));
        break;
      case "--lessons-per-subtopic":
        args.lessonsPerSubtopic = Number(value);
        break;
      case "--questions-per-difficulty":
        args.questionsPerDifficulty = Number(value);
        break;
      case "--limit":
        args.limit = Number(value);
        break;
      case "--min-grade-sort-order":
        args.minGradeSortOrder = Number(value);
        break;
      case "--max-grade-sort-order":
        args.maxGradeSortOrder = Number(value);
        break;
      case "--throttle-ms":
        args.throttleMs = Number(value);
        break;
      default:
        break;
    }
  }

  return args;
}

function isNexModelMockMode(): boolean {
  return !process.env.GEMINI_API_KEY && !process.env.OPENAI_API_KEY;
}

function createAdminClient(): SupabaseClient {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey || serviceRoleKey.includes("your-")) {
    throw new Error(
      "Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY in .env.local",
    );
  }

  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

async function verifySupabaseReachable(admin: SupabaseClient): Promise<void> {
  const { error } = await admin.from("curricula").select("id").limit(1);
  if (error) {
    throw new Error(`Supabase unreachable: ${error.message}`);
  }
}

async function isSkeletonLoaded(
  admin: SupabaseClient,
  args: CliArgs,
): Promise<{ ok: boolean; reason?: string }> {
  if (args.subjects.includes("mathematics")) {
    const { data: kcseMathTopic } = await admin
      .from("topics")
      .select("id, subjects!inner(code, curricula!inner(code))")
      .eq("code", "natural_numbers")
      .eq("subjects.code", "mathematics")
      .eq("subjects.curricula.code", "KCSE")
      .eq("is_active", true)
      .limit(1)
      .maybeSingle();

    if (!kcseMathTopic) {
      return {
        ok: false,
        reason:
          "Phase 1 KCSE skeleton not loaded (missing topic natural_numbers). " +
          "Run: npm run setup:local (Docker required) OR DATABASE_URL=... npx tsx scripts/applySkeletonSeeds.ts",
      };
    }
  }

  if (args.subjects.includes("english")) {
    const { data: englishSubject } = await admin
      .from("subjects")
      .select("id, curricula!inner(code)")
      .eq("code", "english")
      .eq("curricula.code", "KCSE")
      .eq("is_active", true)
      .limit(1)
      .maybeSingle();

    if (!englishSubject) {
      return {
        ok: false,
        reason:
          "English subject missing on KCSE curriculum. Apply migration 20250615150000_science_english_subjects.sql " +
          "and seed files, or run npm run setup:local.",
      };
    }
  }

  return { ok: true };
}

function printFileBasedEstimate(): void {
  console.log("\n=== File-based estimate (after full db:reset / skeleton apply) ===");
  console.log("Mathematics: all active topics/subtopics, CBC + KCSE (~100 KCSE subtopics + legacy)");
  console.log("English low-risk: 16 topic codes × CBC + KCSE (~28 KCSE + 3 CBC topics)");
  console.log("Lesson jobs (KCSE expansion only, idempotent): ~350–450");
  console.log("Question jobs (topics × easy/medium/hard): ~250–300");
  console.log("Estimated model calls: ~600–750");
  console.log("Rough cost (USD): $1.20 – $4.50");
  console.log("Run: npx tsx scripts/estimateDraftScope.ts for seed-file counts.");
}

async function resolveAdminUserId(admin: SupabaseClient): Promise<string> {
  const fromEnv = process.env.ADMIN_USER_ID?.trim();
  if (fromEnv) {
    return fromEnv;
  }

  const { data, error } = await admin
    .from("super_admin_profiles")
    .select("user_id")
    .limit(1)
    .maybeSingle();

  if (error || !data?.user_id) {
    throw new Error(
      "No ADMIN_USER_ID in env and no super_admin_profiles row found. Run npm run db:seed-dev-users.",
    );
  }

  return data.user_id;
}

function topicAllowed(subjectCode: SubjectCode, topicCode: string): boolean {
  if (subjectCode === "mathematics") {
    return true;
  }

  if (HELD_ENGLISH_TOPIC_CODES.has(topicCode)) {
    return false;
  }

  return ENGLISH_LOW_RISK_TOPIC_CODES.has(topicCode);
}

function gradeInRange(
  minGradeSortOrder: number,
  args: CliArgs,
): boolean {
  if (args.minGradeSortOrder !== null && minGradeSortOrder < args.minGradeSortOrder) {
    return false;
  }
  if (args.maxGradeSortOrder !== null && minGradeSortOrder > args.maxGradeSortOrder) {
    return false;
  }
  return true;
}

async function loadGradeLevelMap(
  admin: SupabaseClient,
  curriculum: CurriculumCode,
): Promise<Map<number, string>> {
  const { data: curriculumRow } = await admin
    .from("curricula")
    .select("id")
    .eq("code", curriculum)
    .eq("is_active", true)
    .maybeSingle();

  if (!curriculumRow) {
    return new Map();
  }

  const { data: grades } = await admin
    .from("grade_levels")
    .select("sort_order, display_name")
    .eq("curriculum_id", curriculumRow.id)
    .eq("is_active", true);

  return new Map((grades ?? []).map((grade) => [grade.sort_order, grade.display_name]));
}

async function buildWorkQueue(
  admin: SupabaseClient,
  args: CliArgs,
): Promise<{
  lessonJobs: WorkSubtopic[];
  questionJobs: WorkQuestionBatch[];
  inventory: {
    subjectsFound: number;
    topicsActive: number;
    subtopicsTotal: number;
    subtopicsWithLessons: number;
    topicsEnglishHeld: number;
  };
}> {
  const lessonJobs: WorkSubtopic[] = [];
  const questionJobs: WorkQuestionBatch[] = [];
  const inventory = {
    subjectsFound: 0,
    topicsActive: 0,
    subtopicsTotal: 0,
    subtopicsWithLessons: 0,
    topicsEnglishHeld: 0,
  };

  for (const curriculum of args.curricula) {
    const gradeLevelBySort = await loadGradeLevelMap(admin, curriculum);

    const { data: curriculumRow } = await admin
      .from("curricula")
      .select("id")
      .eq("code", curriculum)
      .eq("is_active", true)
      .maybeSingle();

    if (!curriculumRow) {
      continue;
    }

    for (const subjectCode of args.subjects) {
      const { data: subject } = await admin
        .from("subjects")
        .select("id")
        .eq("curriculum_id", curriculumRow.id)
        .eq("code", subjectCode)
        .eq("is_active", true)
        .maybeSingle();

      if (!subject) {
        continue;
      }

      inventory.subjectsFound += 1;

      const { data: topics } = await admin
        .from("topics")
        .select("id, code, title, min_grade_sort_order")
        .eq("subject_id", subject.id)
        .eq("is_active", true)
        .order("sort_order", { ascending: true });

      const filteredTopics = (topics ?? []).filter((topic) => {
        if (args.topicCodes !== "all" && !args.topicCodes.has(topic.code)) {
          return false;
        }
        if (!topicAllowed(subjectCode, topic.code)) {
          if (subjectCode === "english") {
            inventory.topicsEnglishHeld += 1;
          }
          return false;
        }
        const minGrade = topic.min_grade_sort_order ?? 1;
        return gradeInRange(minGrade, args);
      });

      inventory.topicsActive += filteredTopics.length;

      if (!filteredTopics.length) {
        continue;
      }

      const topicIds = filteredTopics.map((topic) => topic.id);
      const { data: subtopics } = await admin
        .from("subtopics")
        .select("id, code, title, topic_id")
        .in("topic_id", topicIds)
        .eq("is_active", true);

      const subtopicIds = (subtopics ?? []).map((subtopic) => subtopic.id);
      const { data: lessons } = subtopicIds.length
        ? await admin
            .from("lessons")
            .select("subtopic_id")
            .in("subtopic_id", subtopicIds)
        : { data: [] };

      const lessonCountBySubtopic = new Map<string, number>();
      for (const lesson of lessons ?? []) {
        lessonCountBySubtopic.set(
          lesson.subtopic_id,
          (lessonCountBySubtopic.get(lesson.subtopic_id) ?? 0) + 1,
        );
      }

      const { data: questions } = await admin
        .from("practice_questions")
        .select("topic_id, difficulty")
        .in("topic_id", topicIds);

      const questionCountByTopicDifficulty = new Map<string, number>();
      for (const question of questions ?? []) {
        const key = `${question.topic_id}:${question.difficulty}`;
        questionCountByTopicDifficulty.set(key, (questionCountByTopicDifficulty.get(key) ?? 0) + 1);
      }

      const topicById = new Map(filteredTopics.map((topic) => [topic.id, topic]));

      for (const subtopic of subtopics ?? []) {
        inventory.subtopicsTotal += 1;
        const topic = topicById.get(subtopic.topic_id);
        if (!topic) {
          continue;
        }

        const minGrade = topic.min_grade_sort_order ?? 1;
        const gradeLevel = gradeLevelBySort.get(minGrade);
        if (!gradeLevel) {
          continue;
        }

        const existingLessonCount = lessonCountBySubtopic.get(subtopic.id) ?? 0;
        if (existingLessonCount > 0) {
          inventory.subtopicsWithLessons += 1;
        }
        if (existingLessonCount >= args.lessonsPerSubtopic) {
          continue;
        }

        lessonJobs.push({
          subtopicId: subtopic.id,
          subtopicCode: subtopic.code,
          subtopicTitle: subtopic.title,
          topicId: topic.id,
          topicCode: topic.code,
          topicTitle: topic.title,
          subjectCode,
          curriculum,
          gradeLevel,
          minGradeSortOrder: minGrade,
          existingLessonCount,
        });
      }

      for (const topic of filteredTopics) {
        const minGrade = topic.min_grade_sort_order ?? 1;
        const gradeLevel = gradeLevelBySort.get(minGrade);
        if (!gradeLevel) {
          continue;
        }

        for (const difficulty of DIFFICULTIES) {
          const key = `${topic.id}:${difficulty}`;
          const existingCount = questionCountByTopicDifficulty.get(key) ?? 0;
          if (existingCount >= args.questionsPerDifficulty) {
            continue;
          }

          questionJobs.push({
            topicId: topic.id,
            topicCode: topic.code,
            topicTitle: topic.title,
            subjectCode,
            curriculum,
            gradeLevel,
            minGradeSortOrder: minGrade,
            difficulty,
            existingCount,
            neededCount: args.questionsPerDifficulty - existingCount,
          });
        }
      }
    }
  }

  lessonJobs.sort((left, right) => {
    const curriculumCompare = left.curriculum.localeCompare(right.curriculum);
    if (curriculumCompare !== 0) {
      return curriculumCompare;
    }
    if (left.minGradeSortOrder !== right.minGradeSortOrder) {
      return left.minGradeSortOrder - right.minGradeSortOrder;
    }
    return left.topicCode.localeCompare(right.topicCode);
  });

  questionJobs.sort((left, right) => {
    const curriculumCompare = left.curriculum.localeCompare(right.curriculum);
    if (curriculumCompare !== 0) {
      return curriculumCompare;
    }
    if (left.minGradeSortOrder !== right.minGradeSortOrder) {
      return left.minGradeSortOrder - right.minGradeSortOrder;
    }
    const topicCompare = left.topicCode.localeCompare(right.topicCode);
    if (topicCompare !== 0) {
      return topicCompare;
    }
    return left.difficulty.localeCompare(right.difficulty);
  });

  return { lessonJobs, questionJobs, inventory };
}

function estimateCostUsd(modelCalls: number): { low: number; high: number } {
  // Rough Gemini flash batch estimate: ~3k input + 1.5k output tokens per call
  const lowPerCall = 0.002;
  const highPerCall = 0.006;
  return {
    low: Number((modelCalls * lowPerCall).toFixed(2)),
    high: Number((modelCalls * highPerCall).toFixed(2)),
  };
}

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

function reportKey(subjectCode: SubjectCode, curriculum: CurriculumCode): string {
  return `${subjectCode}:${curriculum}`;
}

function getReport(
  reports: Map<string, SubjectReport>,
  subjectCode: SubjectCode,
  curriculum: CurriculumCode,
): SubjectReport {
  const key = reportKey(subjectCode, curriculum);
  const existing = reports.get(key);
  if (existing) {
    return existing;
  }

  const created: SubjectReport = {
    subjectCode,
    curriculum,
    topicsProcessed: new Set(),
    lessonsDrafted: 0,
    questionsDrafted: 0,
    lessonsSkipped: 0,
    questionsSkipped: 0,
    failures: [],
  };
  reports.set(key, created);
  return created;
}

async function runBatch(args: CliArgs): Promise<void> {
  loadEnvLocal();

  if (isNexModelMockMode()) {
    throw new Error(
      "Aborting: GEMINI_API_KEY and OPENAI_API_KEY are both unset — callNexModel would use mock mode.",
    );
  }

  const admin = createAdminClient();
  await verifySupabaseReachable(admin);

  const skeleton = await isSkeletonLoaded(admin, args);
  if (!skeleton.ok) {
    if (args.dryRun) {
      console.warn(`\n⚠ ${skeleton.reason}`);
      printFileBasedEstimate();
      return;
    }
    throw new Error(skeleton.reason);
  }

  const adminId = await resolveAdminUserId(admin);

  const { lessonJobs, questionJobs, inventory } = await buildWorkQueue(admin, args);
  const totalCalls = lessonJobs.length + questionJobs.length;
  const cost = estimateCostUsd(totalCalls);

  console.log("\n=== Draft generation plan ===");
  console.log(`Subjects: ${args.subjects.join(", ")}`);
  console.log(`Curricula: ${args.curricula.join(", ")}`);
  console.log(
    `Grade filter: ${args.minGradeSortOrder ?? "any"} – ${args.maxGradeSortOrder ?? "any"}`,
  );
  console.log(`DB inventory: ${inventory.subjectsFound} subject rows, ${inventory.topicsActive} active topics in scope, ${inventory.subtopicsTotal} subtopics`);
  console.log(`  Subtopics already with ≥1 lesson: ${inventory.subtopicsWithLessons}`);
  console.log(`  English topics held (excluded): ${inventory.topicsEnglishHeld}`);
  console.log(`Lesson jobs (subtopics needing drafts): ${lessonJobs.length}`);
  console.log(`Question jobs (topic×difficulty batches): ${questionJobs.length}`);
  console.log(`Estimated model calls: ${totalCalls}`);
  console.log(`Rough cost estimate (USD): $${cost.low} – $${cost.high}`);
  console.log(`Admin ID: ${adminId}`);
  console.log(`Mode: ${args.dryRun ? "DRY RUN" : "LIVE (drafts only)"}`);

  if (args.dryRun) {
    const byWave = new Map<string, number>();
    for (const job of lessonJobs) {
      const wave = `${job.subjectCode} ${job.curriculum} grade-sort ${job.minGradeSortOrder}`;
      byWave.set(wave, (byWave.get(wave) ?? 0) + 1);
    }
    console.log("\nLesson jobs by wave slice:");
    for (const [wave, count] of [...byWave.entries()].sort()) {
      console.log(`  ${wave}: ${count}`);
    }
    return;
  }

  const reports = new Map<string, SubjectReport>();
  let processed = 0;

  for (const job of lessonJobs) {
    if (args.limit !== null && processed >= args.limit) {
      break;
    }

    const report = getReport(reports, job.subjectCode, job.curriculum);
    report.topicsProcessed.add(job.topicCode);

    try {
      await generateLessonDraft({
        subtopicId: job.subtopicId,
        curriculum: job.curriculum,
        gradeLevel: job.gradeLevel,
        adminId,
      });
      report.lessonsDrafted += 1;
      processed += 1;
      console.log(
        `[lesson] ${job.subjectCode}/${job.curriculum} ${job.topicCode}/${job.subtopicCode} (${job.gradeLevel})`,
      );
    } catch (error) {
      const reason = error instanceof Error ? error.message : String(error);
      report.failures.push({
        kind: "lesson",
        ref: `${job.topicCode}/${job.subtopicCode}`,
        reason,
      });
      console.error(`[lesson FAIL] ${job.topicCode}/${job.subtopicCode}: ${reason}`);
    }

    await sleep(args.throttleMs);
  }

  for (const job of questionJobs) {
    if (args.limit !== null && processed >= args.limit) {
      break;
    }

    const report = getReport(reports, job.subjectCode, job.curriculum);
    report.topicsProcessed.add(job.topicCode);

    try {
      const result = await generateQuestionBankDraft({
        topicId: job.topicId,
        difficulty: job.difficulty,
        count: Math.min(job.neededCount, 20),
        curriculum: job.curriculum,
        gradeLevel: job.gradeLevel,
        adminId,
      });
      report.questionsDrafted += result.count;
      processed += 1;
      console.log(
        `[questions] ${job.subjectCode}/${job.curriculum} ${job.topicCode} ${job.difficulty} +${result.count}`,
      );
    } catch (error) {
      const reason = error instanceof Error ? error.message : String(error);
      report.failures.push({
        kind: "questions",
        ref: `${job.topicCode}/${job.difficulty}`,
        reason,
      });
      console.error(`[questions FAIL] ${job.topicCode}/${job.difficulty}: ${reason}`);
    }

    await sleep(args.throttleMs);
  }

  console.log("\n=== Final report (drafts only — not published) ===");
  console.log(
    "| Subject | Curriculum | Topics | Lessons drafted | Questions drafted | Failures |",
  );
  console.log("|---------|------------|--------|-----------------|-------------------|----------|");

  for (const report of [...reports.values()].sort((left, right) =>
    reportKey(left.subjectCode, left.curriculum).localeCompare(
      reportKey(right.subjectCode, right.curriculum),
    ),
  )) {
    console.log(
      `| ${report.subjectCode} | ${report.curriculum} | ${report.topicsProcessed.size} | ${report.lessonsDrafted} | ${report.questionsDrafted} | ${report.failures.length} |`,
    );
    for (const failure of report.failures) {
      console.log(`  - ${failure.kind} ${failure.ref}: ${failure.reason}`);
    }
  }

  console.log(
    "\nAll drafts are in /admin/content review queue (is_active=false, review_status=draft).",
  );
  console.log("Nothing is student-visible until you review, publish, and topics cross the prod-ready bar.");
}

const isDirectRun = process.argv[1]?.replace(/\\/g, "/").endsWith("generateDrafts.ts");

if (isDirectRun) {
  const args = parseCliArgs(process.argv.slice(2));
  runBatch(args).catch((error) => {
    console.error(error instanceof Error ? error.message : error);
    process.exit(1);
  });
}

export {
  buildWorkQueue,
  ENGLISH_LOW_RISK_TOPIC_CODES,
  estimateCostUsd,
  isNexModelMockMode,
  parseCliArgs,
};
