"use client";

import { useMemo, useState } from "react";
import Link from "next/link";
import { useRouter } from "next/navigation";
import { BookOpen, ClipboardList, Loader2, Sparkles } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { EmptyState } from "@/components/ui/EmptyState";
import { Input } from "@/components/ui/Input";
import { Label } from "@/components/ui/label";
import { SectionCard } from "@/components/ui/SectionCard";
import { PageHeader } from "@/features/admin/components/adminUi";
import { useConfirm } from "@/features/admin/components/ConfirmDialog";
import { toastError, toastInfo, toastSuccess } from "@/features/admin/components/toast";
import { BarMeter } from "@/components/widgets/Charts";
import { LessonRenderer } from "@/features/learn/components/LessonRenderer";
import type { ContentCoverageSubject } from "@/server/services/contentAdminReadService";
import {
  QUESTION_COVERAGE_TARGET,
  SUBTOPIC_QUESTION_COVERAGE_TARGET,
  type ContentCoverageCurriculum,
  type ContentDraftQueueItem,
  type DraftQuestionQueueItem,
} from "@/types/contentAdmin";
import type { Curriculum } from "@/types/database";
import type { CurriculumLesson, LessonContent, LessonContentBlock } from "@/types/curriculum";
import { cn } from "@/lib/utils";

interface ContentPipelinePanelProps {
  adminUserId: string;
  initialSubjects: ContentCoverageSubject[];
  initialDrafts: ContentDraftQueueItem[];
}

type PendingGenerate =
  | {
      type: "lesson";
      subtopicId: string;
      subtopicTitle: string;
      curriculum: Curriculum;
      gradeLevel: string;
    }
  | {
      type: "questions";
      topicId: string;
      topicTitle: string;
      curriculum: Curriculum;
      gradeLevel: string;
      difficulty: "easy" | "medium" | "hard";
      count: number;
    };

interface DraftLessonDetail {
  id: string;
  title: string;
  content: LessonContent;
  estimatedMinutes: number;
  sortOrder: number;
  subtopicId: string;
  subtopicTitle: string;
  topicId: string;
  topicTitle: string;
  subjectId: string;
  curriculumCode: Curriculum;
}

function mapGenerateError(code?: string, fallback?: string) {
  switch (code) {
    case "SCOPE_VIOLATION":
      return "Content generation is not enabled for this subject.";
    case "GENERATION_INVALID_OUTPUT":
      return "The model returned invalid JSON. No draft was saved.";
    case "GENERATION_DEDUPED":
      return "All generated questions matched existing items.";
    case "CURRICULUM_MISMATCH":
      return "This item does not belong to the selected curriculum.";
    default:
      return fallback ?? "Something went wrong.";
  }
}

function ContentPipelinePanelInner({
  initialSubjects,
  initialDrafts,
}: ContentPipelinePanelProps) {
  const router = useRouter();
  const { confirm, dialog } = useConfirm();
  const [activeTab, setActiveTab] = useState<"coverage" | "review">("coverage");
  const [subjects, setSubjects] = useState(initialSubjects);
  const [selectedSubjectCode, setSelectedSubjectCode] = useState(
    initialSubjects[0]?.code ?? "mathematics",
  );
  const coverage = useMemo(
    () => subjects.find((subject) => subject.code === selectedSubjectCode)?.curricula ?? [],
    [subjects, selectedSubjectCode],
  );
  const selectedSubjectName =
    subjects.find((subject) => subject.code === selectedSubjectCode)?.name ?? "Subject";
  const [drafts, setDrafts] = useState(initialDrafts);
  const [pendingGenerate, setPendingGenerate] = useState<PendingGenerate | null>(null);
  const [isGenerating, setIsGenerating] = useState(false);
  const [selectedDraftId, setSelectedDraftId] = useState<string | null>(
    initialDrafts[0]?.id ?? null,
  );
  const [lessonDetail, setLessonDetail] = useState<DraftLessonDetail | null>(null);
  const [isLoadingLesson, setIsLoadingLesson] = useState(false);
  const [isSaving, setIsSaving] = useState(false);
  const [isPublishing, setIsPublishing] = useState(false);

  const selectedDraft = useMemo(
    () => drafts.find((item) => item.id === selectedDraftId) ?? null,
    [drafts, selectedDraftId],
  );

  const lessonPreview = useMemo<CurriculumLesson | null>(() => {
    if (!lessonDetail) {
      return null;
    }

    return {
      id: lessonDetail.id,
      title: lessonDetail.title,
      content: lessonDetail.content,
      estimatedMinutes: lessonDetail.estimatedMinutes,
      sortOrder: lessonDetail.sortOrder,
      subtopicId: lessonDetail.subtopicId,
      subtopicTitle: lessonDetail.subtopicTitle,
      topicId: lessonDetail.topicId,
      topicTitle: lessonDetail.topicTitle,
      subjectId: lessonDetail.subjectId,
      curriculumCode: lessonDetail.curriculumCode,
    };
  }, [lessonDetail]);

  async function refreshData() {
    const [coverageResponse, draftsResponse] = await Promise.all([
      fetch("/api/admin/content/coverage?all=true"),
      fetch("/api/admin/content/drafts"),
    ]);

    const coveragePayload = (await coverageResponse.json()) as {
      success: boolean;
      data?:
        | ContentCoverageCurriculum[]
        | { subjects: ContentCoverageSubject[] };
    };
    const draftsPayload = (await draftsResponse.json()) as {
      success: boolean;
      data?: ContentDraftQueueItem[];
    };

    if (coveragePayload.success && coveragePayload.data) {
      if (Array.isArray(coveragePayload.data)) {
        setSubjects((current) =>
          current.map((subject) =>
            subject.code === selectedSubjectCode
              ? { ...subject, curricula: coveragePayload.data as ContentCoverageCurriculum[] }
              : subject,
          ),
        );
      } else if ("subjects" in coveragePayload.data) {
        setSubjects(coveragePayload.data.subjects);
      }
    }

    if (draftsPayload.success && draftsPayload.data) {
      setDrafts(draftsPayload.data);
    }

    router.refresh();
  }

  async function loadLessonDraft(lessonId: string) {
    setIsLoadingLesson(true);
    try {
      const response = await fetch(`/api/admin/content/drafts/lesson/${lessonId}`);
      const payload = (await response.json()) as {
        success: boolean;
        data?: DraftLessonDetail;
        error?: { message: string };
      };

      if (!response.ok || !payload.success || !payload.data) {
        toastError("Could not load lesson draft", payload.error?.message ?? "Try again.");
        return;
      }

      setLessonDetail(payload.data);
    } finally {
      setIsLoadingLesson(false);
    }
  }

  async function handleSelectDraft(item: ContentDraftQueueItem) {
    setSelectedDraftId(item.id);
    if (item.kind === "lesson") {
      await loadLessonDraft(item.id);
      return;
    }

    setLessonDetail(null);
  }

  async function handleGenerateConfirm() {
    if (!pendingGenerate) {
      return;
    }

    setIsGenerating(true);
    try {
      const body =
        pendingGenerate.type === "lesson"
          ? {
              type: "lesson" as const,
              subtopicId: pendingGenerate.subtopicId,
              curriculum: pendingGenerate.curriculum,
              gradeLevel: pendingGenerate.gradeLevel,
            }
          : {
              type: "questions" as const,
              topicId: pendingGenerate.topicId,
              curriculum: pendingGenerate.curriculum,
              gradeLevel: pendingGenerate.gradeLevel,
              difficulty: pendingGenerate.difficulty,
              count: pendingGenerate.count,
            };

      const response = await fetch("/api/admin/content/generate", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify(body),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { lessonId?: string; questionIds?: string[] };
        error?: { code?: string; message?: string };
      };

      if (!response.ok || !payload.success) {
        toastError(
          "Generation failed",
          mapGenerateError(payload.error?.code, payload.error?.message),
        );
        return;
      }

      toastSuccess(
        "Draft created",
        pendingGenerate.type === "lesson"
          ? "Review the new lesson in the queue before publishing."
          : `${payload.data?.questionIds?.length ?? 0} question drafts added.`,
      );

      setPendingGenerate(null);
      setActiveTab("review");
      await refreshData();

      if (pendingGenerate.type === "lesson" && payload.data?.lessonId) {
        setSelectedDraftId(payload.data.lessonId);
        await loadLessonDraft(payload.data.lessonId);
      }
    } finally {
      setIsGenerating(false);
    }
  }

  async function handlePublish(kind: "lesson" | "question", id: string) {
    const ok = await confirm({
      title: `Publish this ${kind}?`,
      description: "Students will see it on the next refresh once readiness thresholds are met.",
      confirmLabel: "Publish",
    });
    if (!ok) {
      return;
    }

    setIsPublishing(true);
    try {
      const response = await fetch("/api/admin/content/publish", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ kind, id }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        toastError("Publish failed", payload.error?.message ?? "Try again.");
        return;
      }

      toastSuccess("Published", "Students can see this after refresh.");
      setLessonDetail(null);
      setSelectedDraftId(null);
      await refreshData();
    } finally {
      setIsPublishing(false);
    }
  }

  async function handleDiscard(kind: "lesson" | "question", id: string) {
    const ok = await confirm({
      title: `Discard this ${kind} draft?`,
      description: "This permanently removes the draft. It cannot be recovered.",
      confirmLabel: "Discard",
      destructive: true,
    });
    if (!ok) {
      return;
    }

    setIsPublishing(true);
    try {
      const response = await fetch("/api/admin/content/discard", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ kind, id }),
      });
      const payload = (await response.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        toastError("Discard failed", payload.error?.message ?? "Try again.");
        return;
      }

      toastInfo("Draft discarded");
      setLessonDetail(null);
      setSelectedDraftId(null);
      await refreshData();
    } finally {
      setIsPublishing(false);
    }
  }

  async function handleSaveLessonDraft() {
    if (!lessonDetail) {
      return;
    }

    setIsSaving(true);
    try {
      const response = await fetch("/api/admin/content/drafts/lesson", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id: lessonDetail.id,
          title: lessonDetail.title,
          estimatedMinutes: lessonDetail.estimatedMinutes,
          blocks: lessonDetail.content.blocks,
          shortQuiz: lessonDetail.content.shortQuiz,
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        toastError("Save failed", payload.error?.message ?? "Check block fields and try again.");
        return;
      }

      toastSuccess("Draft saved");
      await refreshData();
    } finally {
      setIsSaving(false);
    }
  }

  async function handleSaveQuestionDraft(question: DraftQuestionQueueItem) {
    setIsSaving(true);
    try {
      const response = await fetch("/api/admin/content/drafts/question", {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          id: question.id,
          questionText: question.questionText,
          questionType: question.questionType,
          options: question.options ?? [],
          correctAnswer: question.correctAnswer,
          difficulty: question.difficulty,
          explanation: question.explanation ?? "",
        }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        toastError("Save failed", payload.error?.message ?? "Check fields and try again.");
        return;
      }

      toastSuccess("Question draft saved");
      await refreshData();
    } finally {
      setIsSaving(false);
    }
  }

  function updateLessonBlock(index: number, block: LessonContentBlock) {
    if (!lessonDetail) {
      return;
    }

    const blocks = [...lessonDetail.content.blocks];
    blocks[index] = block;
    setLessonDetail({
      ...lessonDetail,
      content: { ...lessonDetail.content, blocks },
    });
  }

  return (
    <div className="space-y-6">
      {dialog}
      <PageHeader
        eyebrow="Content"
        title="Content pipeline"
        description="Generate lesson and question drafts by subject, review them here, then publish. Students only see published content on topics that meet readiness thresholds."
      />

      <div className="flex flex-wrap items-center gap-2">
        <Label htmlFor="content-subject" className="sr-only">
          Subject
        </Label>
        <select
          id="content-subject"
          className="min-h-11 rounded-xl border border-nexus-border bg-background px-3 text-sm"
          value={selectedSubjectCode}
          onChange={(event) => setSelectedSubjectCode(event.target.value)}
        >
          {subjects.map((subject) => (
            <option key={subject.code} value={subject.code}>
              {subject.name}
            </option>
          ))}
        </select>
      </div>

      <div className="flex flex-wrap gap-2" role="tablist" aria-label="Content pipeline sections">
        <Button
          type="button"
          role="tab"
          aria-selected={activeTab === "coverage"}
          variant={activeTab === "coverage" ? "default" : "outline"}
          className="min-h-11"
          onClick={() => setActiveTab("coverage")}
        >
          <BookOpen className="size-4" />
          Coverage
        </Button>
        <Button
          type="button"
          role="tab"
          aria-selected={activeTab === "review"}
          variant={activeTab === "review" ? "default" : "outline"}
          className="min-h-11"
          onClick={() => setActiveTab("review")}
        >
          <ClipboardList className="size-4" />
          Review queue ({drafts.length})
        </Button>
      </div>

      {pendingGenerate ? (
        <SectionCard
          title="Confirm generation"
          description="Generation uses the LLM and always creates drafts. Nothing goes live until you publish."
        >
          <p className="text-sm text-foreground">
            {pendingGenerate.type === "lesson"
              ? `Generate a lesson draft for “${pendingGenerate.subtopicTitle}” (${pendingGenerate.curriculum}, ${pendingGenerate.gradeLevel})?`
              : `Generate ${pendingGenerate.count} ${pendingGenerate.difficulty} questions for “${pendingGenerate.topicTitle}” (${pendingGenerate.curriculum}, ${pendingGenerate.gradeLevel})?`}
          </p>
          <div className="mt-4 flex flex-wrap gap-2">
            <Button
              type="button"
              className="min-h-11"
              disabled={isGenerating}
              onClick={handleGenerateConfirm}
            >
              {isGenerating ? <Loader2 className="size-4 animate-spin" /> : <Sparkles className="size-4" />}
              Confirm generate
            </Button>
            <Button
              type="button"
              variant="outline"
              className="min-h-11"
              disabled={isGenerating}
              onClick={() => setPendingGenerate(null)}
            >
              Cancel
            </Button>
          </div>
        </SectionCard>
      ) : null}

      {activeTab === "coverage" ? (
        <CoverageBrowser
          coverage={coverage}
          subjectName={selectedSubjectName}
          onGenerateLesson={(input) => setPendingGenerate(input)}
          onGenerateQuestions={(input) => setPendingGenerate(input)}
        />
      ) : (
        <ReviewQueue
          drafts={drafts}
          selectedDraft={selectedDraft}
          lessonDetail={lessonDetail}
          lessonPreview={lessonPreview}
          isLoadingLesson={isLoadingLesson}
          isSaving={isSaving}
          isPublishing={isPublishing}
          onOpenCoverage={() => setActiveTab("coverage")}
          onSelectDraft={handleSelectDraft}
          onPublish={handlePublish}
          onDiscard={handleDiscard}
          onSaveLesson={handleSaveLessonDraft}
          onSaveQuestion={handleSaveQuestionDraft}
          onUpdateLessonDetail={setLessonDetail}
          onUpdateBlock={updateLessonBlock}
          onUpdateDraftQuestion={(id, patch) => {
            setDrafts((current) =>
              current.map((item) =>
                item.id === id && item.kind === "question"
                  ? { ...item, ...patch }
                  : item,
              ),
            );
          }}
        />
      )}
    </div>
  );
}

function CoverageBrowser({
  coverage,
  subjectName,
  onGenerateLesson,
  onGenerateQuestions,
}: {
  coverage: ContentCoverageCurriculum[];
  subjectName: string;
  onGenerateLesson: (input: Extract<PendingGenerate, { type: "lesson" }>) => void;
  onGenerateQuestions: (input: Extract<PendingGenerate, { type: "questions" }>) => void;
}) {
  if (!coverage.length) {
    return (
      <EmptyState
        title={`No ${subjectName} coverage found`}
        description={`Seed ${subjectName} topics before generating content.`}
      />
    );
  }

  return (
    <div className="space-y-6">
      {coverage.map((curriculum) => (
        <SectionCard
          key={curriculum.code}
          title={`${curriculum.code} ${subjectName}`}
          description={`Published vs draft lessons and question bank coverage per difficulty (topic target ≥${QUESTION_COVERAGE_TARGET}, subtopic preferred ≥${SUBTOPIC_QUESTION_COVERAGE_TARGET}).`}
        >
          <div className="space-y-4">
            {curriculum.topics.map((topic) => (
              <div
                key={topic.id}
                className="rounded-2xl border border-nexus-border bg-nexus-sunken/40 p-4"
              >
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <div className="flex flex-wrap items-center gap-2">
                      <h3 className="font-heading text-base font-semibold">{topic.title}</h3>
                      <span className="rounded-full bg-nexus-sunken px-2.5 py-1 text-xs font-medium text-muted-foreground">
                        {topic.readinessLabel.replace("_", "-")}
                      </span>
                    </div>
                    <p className="mt-1 text-sm text-muted-foreground">
                      Lessons: {topic.publishedLessonCount} published · {topic.draftLessonCount} draft
                    </p>
                  </div>
                  <TopicQuestionGenerator
                    curriculum={curriculum.code}
                    topicId={topic.id}
                    topicTitle={topic.title}
                    gradeLevels={curriculum.gradeLevels}
                    onGenerate={onGenerateQuestions}
                  />
                </div>

                <div className="mt-4 grid gap-3 sm:grid-cols-3">
                  {(["easy", "medium", "hard"] as const).map((difficulty) => (
                    <BarMeter
                      key={difficulty}
                      value={topic.questionCounts[difficulty]}
                      max={QUESTION_COVERAGE_TARGET}
                      label={`${difficulty} questions`}
                      showValue
                    />
                  ))}
                </div>

                <ul className="mt-4 space-y-3">
                  {topic.subtopics.map((subtopic) => (
                    <li
                      key={subtopic.id}
                      className="rounded-xl border border-nexus-border bg-nexus-surface px-4 py-3"
                    >
                      <div className="flex flex-wrap items-center justify-between gap-3">
                        <div>
                          <p className="font-medium text-foreground">{subtopic.title}</p>
                          <p className="text-sm text-muted-foreground">
                            {subtopic.publishedLessonCount} published ·{" "}
                            {subtopic.draftLessonCount} draft lessons
                          </p>
                        </div>
                        <SubtopicLessonGenerator
                          curriculum={curriculum.code}
                          subtopicId={subtopic.id}
                          subtopicTitle={subtopic.title}
                          gradeLevels={curriculum.gradeLevels}
                          onGenerate={onGenerateLesson}
                        />
                      </div>
                      <div className="mt-3 grid gap-2 sm:grid-cols-3">
                        {(["easy", "medium", "hard"] as const).map((difficulty) => (
                          <BarMeter
                            key={difficulty}
                            value={subtopic.questionCounts[difficulty]}
                            max={SUBTOPIC_QUESTION_COVERAGE_TARGET}
                            label={`${difficulty} (subtopic)`}
                            showValue
                          />
                        ))}
                      </div>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </SectionCard>
      ))}
    </div>
  );
}

function SubtopicLessonGenerator({
  curriculum,
  subtopicId,
  subtopicTitle,
  gradeLevels,
  onGenerate,
}: {
  curriculum: Curriculum;
  subtopicId: string;
  subtopicTitle: string;
  gradeLevels: string[];
  onGenerate: (input: Extract<PendingGenerate, { type: "lesson" }>) => void;
}) {
  const [gradeLevel, setGradeLevel] = useState(gradeLevels[1] ?? gradeLevels[0]);

  return (
    <div className="flex flex-wrap items-end gap-2">
      <div className="space-y-1">
        <Label htmlFor={`grade-${subtopicId}`}>Grade</Label>
        <select
          id={`grade-${subtopicId}`}
          className="min-h-11 rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm"
          value={gradeLevel}
          onChange={(event) => setGradeLevel(event.target.value)}
        >
          {gradeLevels.map((level) => (
            <option key={level} value={level}>
              {level}
            </option>
          ))}
        </select>
      </div>
      <Button
        type="button"
        variant="outline"
        className="min-h-11"
        onClick={() =>
          onGenerate({
            type: "lesson",
            subtopicId,
            subtopicTitle,
            curriculum,
            gradeLevel,
          })
        }
      >
        Generate lesson
      </Button>
    </div>
  );
}

function TopicQuestionGenerator({
  curriculum,
  topicId,
  topicTitle,
  gradeLevels,
  onGenerate,
}: {
  curriculum: Curriculum;
  topicId: string;
  topicTitle: string;
  gradeLevels: string[];
  onGenerate: (input: Extract<PendingGenerate, { type: "questions" }>) => void;
}) {
  const [gradeLevel, setGradeLevel] = useState(gradeLevels[1] ?? gradeLevels[0]);
  const [difficulty, setDifficulty] = useState<"easy" | "medium" | "hard">("medium");
  const [count, setCount] = useState(5);

  return (
    <div className="flex flex-wrap items-end gap-2">
      <div className="space-y-1">
        <Label htmlFor={`q-grade-${topicId}`}>Grade</Label>
        <select
          id={`q-grade-${topicId}`}
          className="min-h-11 rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm"
          value={gradeLevel}
          onChange={(event) => setGradeLevel(event.target.value)}
        >
          {gradeLevels.map((level) => (
            <option key={level} value={level}>
              {level}
            </option>
          ))}
        </select>
      </div>
      <div className="space-y-1">
        <Label htmlFor={`q-diff-${topicId}`}>Difficulty</Label>
        <select
          id={`q-diff-${topicId}`}
          className="min-h-11 rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm"
          value={difficulty}
          onChange={(event) =>
            setDifficulty(event.target.value as "easy" | "medium" | "hard")
          }
        >
          <option value="easy">Easy</option>
          <option value="medium">Medium</option>
          <option value="hard">Hard</option>
        </select>
      </div>
      <div className="space-y-1">
        <Label htmlFor={`q-count-${topicId}`}>Count</Label>
        <Input
          id={`q-count-${topicId}`}
          type="number"
          min={1}
          max={20}
          value={count}
          onChange={(event) => setCount(Number(event.target.value))}
          className="w-24"
        />
      </div>
      <Button
        type="button"
        className="min-h-11"
        onClick={() =>
          onGenerate({
            type: "questions",
            topicId,
            topicTitle,
            curriculum,
            gradeLevel,
            difficulty,
            count,
          })
        }
      >
        Generate questions
      </Button>
    </div>
  );
}

function ReviewQueue(props: {
  drafts: ContentDraftQueueItem[];
  selectedDraft: ContentDraftQueueItem | null;
  lessonDetail: DraftLessonDetail | null;
  lessonPreview: CurriculumLesson | null;
  isLoadingLesson: boolean;
  isSaving: boolean;
  isPublishing: boolean;
  onOpenCoverage: () => void;
  onSelectDraft: (item: ContentDraftQueueItem) => void;
  onPublish: (kind: "lesson" | "question", id: string) => void;
  onDiscard: (kind: "lesson" | "question", id: string) => void;
  onSaveLesson: () => void;
  onSaveQuestion: (question: DraftQuestionQueueItem) => void;
  onUpdateLessonDetail: (detail: DraftLessonDetail) => void;
  onUpdateBlock: (index: number, block: LessonContentBlock) => void;
  onUpdateDraftQuestion: (id: string, patch: Partial<DraftQuestionQueueItem>) => void;
}) {
  const {
    drafts,
    selectedDraft,
    lessonDetail,
    lessonPreview,
    isLoadingLesson,
    isSaving,
    isPublishing,
    onOpenCoverage,
    onSelectDraft,
    onPublish,
    onDiscard,
    onSaveLesson,
    onSaveQuestion,
    onUpdateLessonDetail,
    onUpdateBlock,
    onUpdateDraftQuestion,
  } = props;

  if (!drafts.length) {
    return (
      <EmptyState
        title="No drafts in the queue"
        description="Generate a lesson or question bank from the Coverage tab. Drafts stay invisible to students until you publish."
        primaryAction={{ label: "Open coverage", onClick: onOpenCoverage }}
      />
    );
  }

  return (
    <div className="grid gap-6 lg:grid-cols-[minmax(0,320px)_1fr]">
      <SectionCard title="Draft queue" description="Select an item to review.">
        <ul className="space-y-2">
          {drafts.map((item) => (
            <li key={item.id}>
              <button
                type="button"
                className={cn(
                  "w-full rounded-xl border px-3 py-3 text-left transition-colors",
                  selectedDraft?.id === item.id
                    ? "border-nexus-primary bg-nexus-primary-soft"
                    : "border-nexus-border bg-nexus-surface hover:bg-nexus-sunken/50",
                )}
                onClick={() => onSelectDraft(item)}
              >
                <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                  {item.kind === "lesson" ? "Lesson" : "Question"} · {item.curriculumCode}
                </p>
                <p className="mt-1 text-sm font-medium text-foreground">
                  {item.kind === "lesson" ? item.title : item.questionText}
                </p>
                <p className="mt-1 text-xs text-muted-foreground">
                  {item.topicTitle}
                  {item.kind === "lesson" ? ` · ${item.subtopicTitle}` : ` · ${item.difficulty}`}
                </p>
              </button>
            </li>
          ))}
        </ul>
      </SectionCard>

      <div className="space-y-4">
        {!selectedDraft ? (
          <EmptyState
            title="Select a draft"
            description="Choose a lesson or question from the queue to preview and edit."
          />
        ) : selectedDraft.kind === "lesson" ? (
          <>
            {isLoadingLesson || !lessonDetail ? (
              <SectionCard title="Loading lesson draft">
                <p className="text-sm text-muted-foreground">Fetching draft content…</p>
              </SectionCard>
            ) : (
              <>
                <SectionCard title="Edit lesson draft">
                  <div className="space-y-4">
                    <div className="space-y-1">
                      <Label htmlFor="lesson-title">Title</Label>
                      <Input
                        id="lesson-title"
                        value={lessonDetail.title}
                        onChange={(event) =>
                          onUpdateLessonDetail({ ...lessonDetail, title: event.target.value })
                        }
                      />
                    </div>
                    <div className="space-y-1">
                      <Label htmlFor="lesson-minutes">Estimated minutes</Label>
                      <Input
                        id="lesson-minutes"
                        type="number"
                        min={5}
                        max={60}
                        value={lessonDetail.estimatedMinutes}
                        onChange={(event) =>
                          onUpdateLessonDetail({
                            ...lessonDetail,
                            estimatedMinutes: Number(event.target.value),
                          })
                        }
                      />
                    </div>

                    <div className="space-y-3">
                      {lessonDetail.content.blocks.map((block, index) => (
                        <div
                          key={`${block.type}-${index}`}
                          className="rounded-xl border border-nexus-border bg-nexus-sunken/40 p-3"
                        >
                          <p className="mb-2 text-xs font-semibold uppercase tracking-wide text-nexus-primary">
                            {block.type}
                          </p>
                          {block.type === "example" ? (
                            <div className="space-y-2">
                              <Input
                                value={block.title}
                                onChange={(event) =>
                                  onUpdateBlock(index, { ...block, title: event.target.value })
                                }
                                placeholder="Example title"
                              />
                              <textarea
                                className="min-h-24 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
                                value={block.steps.join("\n")}
                                onChange={(event) =>
                                  onUpdateBlock(index, {
                                    ...block,
                                    steps: event.target.value
                                      .split("\n")
                                      .map((step) => step.trim())
                                      .filter(Boolean),
                                  })
                                }
                                placeholder="One step per line"
                              />
                              <Input
                                value={block.answer}
                                onChange={(event) =>
                                  onUpdateBlock(index, { ...block, answer: event.target.value })
                                }
                                placeholder="Answer"
                              />
                            </div>
                          ) : block.type === "chemical_equation" ? (
                            <div className="space-y-2">
                              <textarea
                                className="min-h-20 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
                                value={block.equation}
                                onChange={(event) =>
                                  onUpdateBlock(index, { ...block, equation: event.target.value })
                                }
                                placeholder="Equation (KaTeX)"
                              />
                              <Input
                                value={block.caption ?? ""}
                                onChange={(event) =>
                                  onUpdateBlock(index, {
                                    ...block,
                                    caption: event.target.value || undefined,
                                  })
                                }
                                placeholder="Caption (optional)"
                              />
                            </div>
                          ) : block.type === "comprehension_passage" ? (
                            <div className="space-y-2">
                              <Input
                                value={block.title ?? ""}
                                onChange={(event) =>
                                  onUpdateBlock(index, {
                                    ...block,
                                    title: event.target.value || undefined,
                                  })
                                }
                                placeholder="Passage title (optional)"
                              />
                              <textarea
                                className="min-h-28 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
                                value={block.passage}
                                onChange={(event) =>
                                  onUpdateBlock(index, { ...block, passage: event.target.value })
                                }
                                placeholder="Passage text"
                              />
                            </div>
                          ) : block.type === "heading" ||
                            block.type === "paragraph" ||
                            block.type === "tip" ? (
                            <textarea
                              className="min-h-20 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
                              value={block.content}
                              onChange={(event) =>
                                onUpdateBlock(index, { ...block, content: event.target.value })
                              }
                            />
                          ) : (
                            <p className="text-sm text-muted-foreground">
                              This block type is read-only in the legacy editor until Authoring
                              Studio ships.
                            </p>
                          )}
                        </div>
                      ))}
                    </div>

                    <div className="flex flex-wrap gap-2">
                      <Button
                        type="button"
                        variant="outline"
                        className="min-h-11"
                        render={<Link href={`/admin/studio/${lessonDetail.id}`} />}
                      >
                        Open in Studio
                      </Button>
                      <Button
                        type="button"
                        className="min-h-11"
                        disabled={isSaving}
                        onClick={onSaveLesson}
                      >
                        Save draft
                      </Button>
                      <Button
                        type="button"
                        variant="default"
                        className="min-h-11"
                        disabled={isPublishing}
                        onClick={() => onPublish("lesson", lessonDetail.id)}
                      >
                        Publish
                      </Button>
                      <Button
                        type="button"
                        variant="outline"
                        className="min-h-11"
                        disabled={isPublishing}
                        onClick={() => onDiscard("lesson", lessonDetail.id)}
                      >
                        Discard
                      </Button>
                    </div>
                  </div>
                </SectionCard>

                {lessonPreview ? (
                  <SectionCard
                    title="Student preview"
                    description="Rendered with the same LessonRenderer students will see after publish."
                  >
                    <LessonRenderer
                      lesson={lessonPreview}
                      orderedLessonIds={[lessonPreview.id]}
                      initialProgress={{
                        status: null,
                        completedAt: null,
                        lastViewedAt: null,
                      }}
                    />
                  </SectionCard>
                ) : null}
              </>
            )}
          </>
        ) : (
          <QuestionDraftEditor
            question={selectedDraft}
            isSaving={isSaving}
            isPublishing={isPublishing}
            onChange={(patch) => onUpdateDraftQuestion(selectedDraft.id, patch)}
            onSave={() => onSaveQuestion(selectedDraft)}
            onPublish={() => onPublish("question", selectedDraft.id)}
            onDiscard={() => onDiscard("question", selectedDraft.id)}
          />
        )}
      </div>
    </div>
  );
}

function QuestionDraftEditor({
  question,
  isSaving,
  isPublishing,
  onChange,
  onSave,
  onPublish,
  onDiscard,
}: {
  question: DraftQuestionQueueItem;
  isSaving: boolean;
  isPublishing: boolean;
  onChange: (patch: Partial<DraftQuestionQueueItem>) => void;
  onSave: () => void;
  onPublish: () => void;
  onDiscard: () => void;
}) {
  return (
    <SectionCard title="Edit question draft">
      <div className="space-y-4">
        <div className="space-y-1">
          <Label htmlFor="question-text">Question</Label>
          <textarea
            id="question-text"
            className="min-h-24 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
            value={question.questionText}
            onChange={(event) => onChange({ questionText: event.target.value })}
          />
        </div>
        <div className="grid gap-4 sm:grid-cols-2">
          <div className="space-y-1">
            <Label htmlFor="question-type">Type</Label>
            <select
              id="question-type"
              className="min-h-11 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm"
              value={question.questionType}
              onChange={(event) =>
                onChange({
                  questionType: event.target.value as DraftQuestionQueueItem["questionType"],
                })
              }
            >
              <option value="multiple_choice">Multiple choice</option>
              <option value="short_answer">Short answer</option>
            </select>
          </div>
          <div className="space-y-1">
            <Label htmlFor="question-difficulty">Difficulty</Label>
            <select
              id="question-difficulty"
              className="min-h-11 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm"
              value={question.difficulty}
              onChange={(event) =>
                onChange({
                  difficulty: event.target.value as DraftQuestionQueueItem["difficulty"],
                })
              }
            >
              <option value="easy">Easy</option>
              <option value="medium">Medium</option>
              <option value="hard">Hard</option>
            </select>
          </div>
        </div>
        {question.questionType === "multiple_choice" ? (
          <div className="space-y-1">
            <Label htmlFor="question-options">Options (one per line)</Label>
            <textarea
              id="question-options"
              className="min-h-24 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
              value={(question.options ?? []).join("\n")}
              onChange={(event) =>
                onChange({
                  options: event.target.value
                    .split("\n")
                    .map((option) => option.trim())
                    .filter(Boolean),
                })
              }
            />
          </div>
        ) : null}
        <div className="space-y-1">
          <Label htmlFor="question-answer">Correct answer</Label>
          <Input
            id="question-answer"
            value={question.correctAnswer}
            onChange={(event) => onChange({ correctAnswer: event.target.value })}
          />
        </div>
        <div className="space-y-1">
          <Label htmlFor="question-explanation">Explanation</Label>
          <textarea
            id="question-explanation"
            className="min-h-20 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm"
            value={question.explanation ?? ""}
            onChange={(event) => onChange({ explanation: event.target.value })}
          />
        </div>
        <div className="flex flex-wrap gap-2">
          <Button type="button" className="min-h-11" disabled={isSaving} onClick={onSave}>
            Save draft
          </Button>
          <Button type="button" className="min-h-11" disabled={isPublishing} onClick={onPublish}>
            Publish
          </Button>
          <Button type="button" variant="outline" className="min-h-11" disabled={isPublishing} onClick={onDiscard}>
            Discard
          </Button>
        </div>
      </div>
    </SectionCard>
  );
}

export function ContentPipelinePanel(props: ContentPipelinePanelProps) {
  return <ContentPipelinePanelInner {...props} />;
}
