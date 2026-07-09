import type { NexMode } from "@/lib/nex/types";

export interface NexTeachingSection {
  label: string;
  content: string;
}

type NexVisibleMode = Exclude<NexMode, "assessment">;

const MODE_LABELS: Record<NexMode, string> = {
  explain: "Explain",
  practice: "Practice",
  homework: "Homework",
  revision: "Revision",
  assessment: "Assessment",
};

const MODE_HELPER_TEXT: Record<NexVisibleMode, string> = {
  explain: "Nex can teach directly, use examples, then check understanding.",
  practice: "Nex asks one question at a time and adapts after your answer.",
  homework: "Nex gives hints before answers so you learn the method.",
  revision: "Nex helps recap weak areas, plan study time, and drill exam-style questions.",
};

const FOLLOW_UP_PROMPTS: Record<NexVisibleMode, string[]> = {
  explain: ["Show another example", "Explain simpler", "Quiz me"],
  practice: ["Harder", "Easier", "Another question"],
  homework: ["Give me a hint", "Check my step", "What should I try next?"],
  revision: ["Make a plan", "Test weak topics", "Summarise this"],
};

const TOPIC_FOLLOW_UP_TEMPLATES: Record<NexVisibleMode, string> = {
  explain: "Quiz me on {topic}",
  practice: "Another {topic} question",
  homework: "Show me a similar {topic} problem",
  revision: "Test my weak spots in {topic}",
};

const STARTER_PROMPTS: Record<NexVisibleMode, string[]> = {
  explain: [
    "Explain {topic} simply",
    "Show me an example for {topic}",
    "Check if I understand {topic}",
  ],
  practice: [
    "Give me one {topic} question",
    "Quiz me on {topic}",
    "Start with an easier {topic} question",
  ],
  homework: [
    "I'm stuck on {topic} homework. Guide me.",
    "Check my {topic} working without giving the final answer",
    "What should I try first for this {topic} problem?",
  ],
  revision: [
    "Build a revision plan for {topic}",
    "Test my weak areas in {topic}",
    "Summarise what I should remember about {topic}",
  ],
};

const DEFAULT_STARTER_PROMPTS: Record<NexVisibleMode, string[]> = {
  explain: [
    "Explain fractions like I'm in Form 1",
    "What is the Pythagoras theorem?",
    "Help me understand linear equations",
  ],
  practice: [
    "Give me a medium algebra question",
    "Quiz me on geometry basics",
    "One practice question on percentages",
  ],
  homework: [
    "I'm stuck on a homework problem. Can you guide me?",
    "Check my working without giving the final answer",
    "What should I try first for this word problem?",
  ],
  revision: [
    "Build a 30-minute revision plan for tomorrow",
    "What should I revise before my mock exam?",
    "Summarise the key topics I should review",
  ],
};

const KNOWN_SECTION_LABELS = new Set([
  "CONCEPT",
  "EXAMPLE",
  "GUIDED CHECK",
  "PRACTICE QUESTION",
  "QUESTION",
  "FEEDBACK",
  "NEXT QUESTION",
  "REVISION PLAN",
  "DAILY PLAN",
  "SUMMARY",
  "HINT",
]);

export function getModeLabel(mode: NexMode): string {
  return MODE_LABELS[mode];
}

export function getModeHelperText(mode: NexVisibleMode): string {
  return MODE_HELPER_TEXT[mode];
}

export function getFollowUpPromptsForMode(
  mode: NexVisibleMode,
  topicTitle?: string | null,
): string[] {
  const base = FOLLOW_UP_PROMPTS[mode];
  const safeTopic = topicTitle?.trim();

  if (!safeTopic) {
    return base;
  }

  const topicPrompt = TOPIC_FOLLOW_UP_TEMPLATES[mode].replace("{topic}", () => safeTopic);
  return [base[0], base[1], topicPrompt];
}

export function getStarterPromptsForMode(
  mode: NexVisibleMode,
  topicTitle?: string | null,
): string[] {
  const safeTopic = topicTitle?.trim();
  if (!safeTopic) {
    return DEFAULT_STARTER_PROMPTS[mode];
  }

  return STARTER_PROMPTS[mode].map((prompt) =>
    prompt.replaceAll("{topic}", safeTopic),
  );
}

function nairobiDateKey(date: Date): string {
  return new Intl.DateTimeFormat("en-CA", {
    timeZone: "Africa/Nairobi",
    year: "numeric",
    month: "2-digit",
    day: "2-digit",
  }).format(date);
}

export function formatResumedSessionLabel(
  mode: NexMode,
  startedAt?: string | null,
  now = new Date(),
): string {
  const label = getModeLabel(mode);

  if (!startedAt) {
    return `Continuing your last ${label} chat`;
  }

  const startedDate = new Date(startedAt);
  if (Number.isNaN(startedDate.getTime())) {
    return `Continuing your last ${label} chat`;
  }

  if (nairobiDateKey(startedDate) === nairobiDateKey(now)) {
    return `Continuing your ${label} chat from today`;
  }

  const dateLabel = new Intl.DateTimeFormat("en-KE", {
    timeZone: "Africa/Nairobi",
    month: "short",
    day: "numeric",
  }).format(startedDate);

  return `Continuing your ${label} chat from ${dateLabel}`;
}

export function formatNexAllowanceSummary(
  dailyUsage: number,
  dailyLimit: number,
  compact: boolean,
): string {
  const remaining = Math.max(0, dailyLimit - dailyUsage);
  const unit = remaining === 1 ? "message" : "messages";

  if (compact) {
    return `${remaining} ${unit} left today`;
  }

  return `${remaining} of ${dailyLimit} free ${unit} left today`;
}

function toSectionLabel(value: string): string {
  return value
    .toLowerCase()
    .split(" ")
    .filter(Boolean)
    .map((part) => part[0].toUpperCase() + part.slice(1))
    .join(" ");
}

export function parseNexTeachingSections(content: string): NexTeachingSection[] {
  const sections: Array<{ label: string; lines: string[] }> = [];
  let current: { label: string; lines: string[] } | null = null;

  for (const line of content.split(/\r?\n/)) {
    const match = line.match(
      /^\s*(?:\d+\.\s*)?([A-Z][A-Z ]{2,})(?:\s*[:\-\u2013\u2014]\s*)?(.*)$/,
    );
    const rawLabel = match?.[1]?.trim() ?? "";

    if (KNOWN_SECTION_LABELS.has(rawLabel)) {
      if (current) {
        sections.push(current);
      }

      current = {
        label: toSectionLabel(rawLabel),
        lines: match?.[2] ? [match[2]] : [],
      };
      continue;
    }

    if (current) {
      current.lines.push(line);
    }
  }

  if (current) {
    sections.push(current);
  }

  return sections
    .map((section) => ({
      label: section.label,
      content: section.lines.join("\n").trim(),
    }))
    .filter((section) => section.content.length > 0);
}
