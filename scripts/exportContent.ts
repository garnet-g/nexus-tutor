#!/usr/bin/env tsx
/**
 * Export published Mathematics curriculum content to supabase/seed/curriculum_math.sql
 *
 * Reproducible content loop:
 *   1. Generate drafts in /admin/content
 *   2. Review and Publish in-app
 *   3. npm run content:export
 *   4. Commit the updated seed file
 *   5. npm run db:reset reproduces the same published content in any environment
 */
import { existsSync, readFileSync, writeFileSync } from "fs";
import { join } from "path";

import { createClient } from "@supabase/supabase-js";

const ROOT = join(import.meta.dirname, "..");
const MATHEMATICS_CODE = "mathematics";

type CurriculumCode = "CBC" | "KCSE";

const EXPORT_TARGETS: Array<{
  subjectCode: string;
  outputFile: string;
  curricula: CurriculumCode[];
  headerComment: string;
}> = [
  {
    subjectCode: "mathematics",
    outputFile: "curriculum_math.sql",
    curricula: ["CBC", "KCSE"],
    headerComment: "-- Mathematics curriculum seed (CBC + KCSE)",
  },
  {
    subjectCode: "kiswahili",
    outputFile: "curriculum_kiswahili.sql",
    curricula: ["CBC", "KCSE"],
    headerComment:
      "-- Kiswahili curriculum seed (CBC + KCSE) — skeleton + published content via export",
  },
  {
    subjectCode: "chemistry",
    outputFile: "curriculum_chemistry.sql",
    curricula: ["KCSE"],
    headerComment: "-- Chemistry curriculum seed (KCSE) — skeleton + published content via export",
  },
];

interface TopicRow {
  id: string;
  code: string;
  title: string;
  description: string | null;
  sort_order: number;
  min_grade_sort_order: number;
}

interface SubtopicRow {
  id: string;
  topic_id: string;
  code: string;
  title: string;
  description: string | null;
  sort_order: number;
}

interface LessonRow {
  subtopic_id: string;
  title: string;
  content: unknown;
  estimated_minutes: number;
  sort_order: number;
}

interface QuestionRow {
  topic_id: string;
  question_text: string;
  question_type: string;
  options: unknown;
  correct_answer: unknown;
  difficulty: string;
  explanation: string | null;
}

export function sqlLiteral(value: string): string {
  return `'${value.replace(/'/g, "''")}'`;
}

export function sqlJsonb(value: unknown): string {
  return `${sqlLiteral(JSON.stringify(value))}::jsonb`;
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
    const value = trimmed.slice(separator + 1).trim().replace(/^"|"$/g, "");
    if (!process.env[key]) {
      process.env[key] = value;
    }
  }
}

function createExportClient() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY;

  if (!url || !serviceRoleKey) {
    throw new Error("Missing NEXT_PUBLIC_SUPABASE_URL or SUPABASE_SERVICE_ROLE_KEY");
  }

  return createClient(url, serviceRoleKey, {
    auth: { autoRefreshToken: false, persistSession: false },
  });
}

function renderTopicInsert(
  curriculum: CurriculumCode,
  subjectCode: string,
  topic: TopicRow,
): string {
  const descriptionSql = topic.description
    ? sqlLiteral(topic.description)
    : "NULL";

  return [
    `INSERT INTO public.topics (subject_id, code, title, description, sort_order, min_grade_sort_order)`,
    `SELECT s.id, ${sqlLiteral(topic.code)}, ${sqlLiteral(topic.title)}, ${descriptionSql}, ${topic.sort_order}, ${topic.min_grade_sort_order}`,
    `FROM public.subjects s`,
    `JOIN public.curricula c ON c.id = s.curriculum_id`,
    `WHERE c.code = ${sqlLiteral(curriculum)} AND s.code = ${sqlLiteral(subjectCode)}`,
    `ON CONFLICT (subject_id, code) DO UPDATE`,
    `SET min_grade_sort_order = EXCLUDED.min_grade_sort_order,`,
    `    sort_order = EXCLUDED.sort_order,`,
    `    title = EXCLUDED.title,`,
    `    description = EXCLUDED.description;`,
  ].join("\n");
}

function renderSubtopicInsert(
  curriculum: CurriculumCode,
  subjectCode: string,
  topicCode: string,
  subtopic: SubtopicRow,
): string {
  const descriptionSql = subtopic.description
    ? sqlLiteral(subtopic.description)
    : "NULL";

  return [
    `INSERT INTO public.subtopics (topic_id, code, title, description, sort_order)`,
    `SELECT t.id, ${sqlLiteral(subtopic.code)}, ${sqlLiteral(subtopic.title)}, ${descriptionSql}, ${subtopic.sort_order}`,
    `FROM public.topics t`,
    `JOIN public.subjects s ON s.id = t.subject_id`,
    `JOIN public.curricula c ON c.id = s.curriculum_id`,
    `WHERE c.code = ${sqlLiteral(curriculum)} AND s.code = ${sqlLiteral(MATHEMATICS_CODE)} AND t.code = ${sqlLiteral(topicCode)}`,
    `ON CONFLICT (topic_id, code) DO NOTHING;`,
  ].join("\n");
}

function renderLessonInsert(
  curriculum: CurriculumCode,
  subjectCode: string,
  topicCode: string,
  subtopicCode: string,
  lesson: LessonRow,
): string {
  return [
    `INSERT INTO public.lessons (subtopic_id, title, content, estimated_minutes, sort_order)`,
    `SELECT st.id, ${sqlLiteral(lesson.title)}, ${sqlJsonb(lesson.content)}, ${lesson.estimated_minutes}, ${lesson.sort_order}`,
    `FROM public.subtopics st`,
    `JOIN public.topics t ON t.id = st.topic_id`,
    `JOIN public.subjects s ON s.id = t.subject_id`,
    `JOIN public.curricula c ON c.id = s.curriculum_id`,
    `WHERE c.code = ${sqlLiteral(curriculum)} AND s.code = ${sqlLiteral(MATHEMATICS_CODE)} AND t.code = ${sqlLiteral(topicCode)} AND st.code = ${sqlLiteral(subtopicCode)}`,
    `AND NOT EXISTS (`,
    `  SELECT 1 FROM public.lessons l WHERE l.subtopic_id = st.id AND l.title = ${sqlLiteral(lesson.title)}`,
    `);`,
  ].join("\n");
}

function renderQuestionInsert(
  curriculum: CurriculumCode,
  subjectCode: string,
  topicCode: string,
  question: QuestionRow,
): string {
  const optionsSql =
    question.options === null || question.options === undefined
      ? "NULL"
      : sqlJsonb(question.options);

  return [
    `INSERT INTO public.practice_questions (topic_id, question_text, question_type, options, correct_answer, difficulty, explanation)`,
    `SELECT t.id, ${sqlLiteral(question.question_text)}, ${sqlLiteral(question.question_type)}, ${optionsSql}, ${sqlJsonb(question.correct_answer)}, ${sqlLiteral(question.difficulty)}, ${question.explanation ? sqlLiteral(question.explanation) : "NULL"}`,
    `FROM public.topics t`,
    `JOIN public.subjects s ON s.id = t.subject_id`,
    `JOIN public.curricula c ON c.id = s.curriculum_id`,
    `WHERE c.code = ${sqlLiteral(curriculum)} AND s.code = ${sqlLiteral(MATHEMATICS_CODE)} AND t.code = ${sqlLiteral(topicCode)}`,
    `AND NOT EXISTS (`,
    `  SELECT 1 FROM public.practice_questions pq`,
    `  WHERE pq.topic_id = t.id AND pq.question_text = ${sqlLiteral(question.question_text)}`,
    `);`,
  ].join("\n");
}

async function exportSubject(
  subjectCode: string,
  curricula: CurriculumCode[],
  headerComment: string,
): Promise<string> {
  const admin = createExportClient();
  const lines: string[] = [
    headerComment,
    "-- Generated by scripts/exportContent.ts — published content only",
    "-- Loop: generate → review/publish in /admin/content → npm run content:export → commit → npm run db:reset",
    "",
  ];

  const allQuestions: Array<{ curriculum: CurriculumCode; topicCode: string; question: QuestionRow }> =
    [];

  for (const curriculum of curricula) {
    const { data: curriculumRow } = await admin
      .from("curricula")
      .select("id")
      .eq("code", curriculum)
      .eq("is_active", true)
      .maybeSingle();

    if (!curriculumRow) {
      continue;
    }

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

    lines.push(`-- ${curriculum} topics`);
    const { data: topics } = await admin
      .from("topics")
      .select("id, code, title, description, sort_order, min_grade_sort_order")
      .eq("subject_id", subject.id)
      .eq("is_active", true)
      .order("sort_order", { ascending: true });

    for (const topic of (topics ?? []) as TopicRow[]) {
      lines.push("", renderTopicInsert(curriculum, subjectCode, topic));

      const { data: subtopics } = await admin
        .from("subtopics")
        .select("id, topic_id, code, title, description, sort_order")
        .eq("topic_id", topic.id)
        .eq("is_active", true)
        .order("sort_order", { ascending: true });

      for (const subtopic of (subtopics ?? []) as SubtopicRow[]) {
        lines.push("", renderSubtopicInsert(curriculum, subjectCode, topic.code, subtopic));

        const { data: lessons } = await admin
          .from("lessons")
          .select("subtopic_id, title, content, estimated_minutes, sort_order")
          .eq("subtopic_id", subtopic.id)
          .eq("is_active", true)
          .eq("review_status", "published")
          .order("sort_order", { ascending: true });

        for (const lesson of (lessons ?? []) as LessonRow[]) {
          lines.push(
            "",
            renderLessonInsert(
              curriculum,
              subjectCode,
              topic.code,
              subtopic.code,
              lesson,
            ),
          );
        }
      }

      const { data: questions } = await admin
        .from("practice_questions")
        .select(
          "topic_id, question_text, question_type, options, correct_answer, difficulty, explanation",
        )
        .eq("topic_id", topic.id)
        .eq("is_active", true)
        .eq("review_status", "published")
        .order("question_text", { ascending: true });

      for (const question of (questions ?? []) as QuestionRow[]) {
        allQuestions.push({ curriculum, topicCode: topic.code, question });
      }
    }
  }

  lines.push("", "-- Practice questions (published only)");
  allQuestions.sort((left, right) => {
    const curriculumCompare = left.curriculum.localeCompare(right.curriculum);
    if (curriculumCompare !== 0) {
      return curriculumCompare;
    }

    const topicCompare = left.topicCode.localeCompare(right.topicCode);
    if (topicCompare !== 0) {
      return topicCompare;
    }

    return left.question.question_text.localeCompare(right.question.question_text);
  });

  for (const entry of allQuestions) {
    lines.push("", renderQuestionInsert(entry.curriculum, subjectCode, entry.topicCode, entry.question));
  }

  lines.push("");
  return lines.join("\n");
}

export async function exportCurriculumMath(): Promise<string> {
  const mathTarget = EXPORT_TARGETS.find((target) => target.subjectCode === MATHEMATICS_CODE);
  if (!mathTarget) {
    throw new Error("Mathematics export target missing");
  }
  return exportSubject(
    mathTarget.subjectCode,
    mathTarget.curricula,
    mathTarget.headerComment,
  );
}

async function main() {
  loadEnvLocal();

  for (const target of EXPORT_TARGETS) {
    const outputPath = join(ROOT, "supabase", "seed", target.outputFile);
    const sql = await exportSubject(
      target.subjectCode,
      target.curricula,
      target.headerComment,
    );
    writeFileSync(outputPath, sql, "utf-8");
    console.log(`Exported published ${target.subjectCode} content to ${outputPath}`);
  }
}

const isDirectRun = process.argv[1]?.endsWith("exportContent.ts");

if (isDirectRun) {
  main().catch((error) => {
    console.error(error instanceof Error ? error.message : error);
    process.exit(1);
  });
}
