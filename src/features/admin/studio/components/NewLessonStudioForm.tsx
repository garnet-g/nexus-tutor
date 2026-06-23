"use client";

import { useRouter } from "next/navigation";
import { useState } from "react";

import type { ContentCoverageSubject } from "@/types/contentAdmin";
import type { Curriculum } from "@/types/database";

import { Field, Input, Select } from "@/features/admin/components/adminForm";
import { PageHeader, Panel } from "@/features/admin/components/adminUi";
import { toastError } from "@/features/admin/components/toast";
import { createStudioLesson } from "@/features/admin/studio/lib/studioApi";
import { Button } from "@/components/ui/Button";

type Placement = {
  subjectCode: string;
  curriculumCode: Curriculum;
  topicId: string;
  subtopicId: string;
};

function findInitialPlacement(
  subjects: ContentCoverageSubject[],
  initialSubtopicId?: string,
): Placement | null {
  if (!initialSubtopicId) {
    return null;
  }

  for (const subject of subjects) {
    for (const curriculum of subject.curricula) {
      for (const topic of curriculum.topics) {
        const match = topic.subtopics.find((subtopic) => subtopic.id === initialSubtopicId);
        if (match) {
          return {
            subjectCode: subject.code,
            curriculumCode: curriculum.code,
            topicId: topic.id,
            subtopicId: match.id,
          };
        }
      }
    }
  }

  return null;
}

interface NewLessonStudioFormProps {
  subjects: ContentCoverageSubject[];
  initialSubtopicId?: string;
}

export function NewLessonStudioForm({ subjects, initialSubtopicId }: NewLessonStudioFormProps) {
  const router = useRouter();
  const initialPlacement = findInitialPlacement(subjects, initialSubtopicId);
  const [subjectCode, setSubjectCode] = useState(
    initialPlacement?.subjectCode ?? subjects[0]?.code ?? "",
  );
  const [curriculumCode, setCurriculumCode] = useState<Curriculum>(
    initialPlacement?.curriculumCode ?? subjects[0]?.curricula[0]?.code ?? "CBC",
  );
  const [topicId, setTopicId] = useState(initialPlacement?.topicId ?? "");
  const [subtopicId, setSubtopicId] = useState(initialPlacement?.subtopicId ?? "");
  const [title, setTitle] = useState("");
  const [estimatedMinutes, setEstimatedMinutes] = useState(10);
  const [isCreating, setIsCreating] = useState(false);

  const selectedSubject = subjects.find((subject) => subject.code === subjectCode);
  const curricula = selectedSubject?.curricula ?? [];
  const selectedCurriculum = curricula.find((curriculum) => curriculum.code === curriculumCode);
  const topics = selectedCurriculum?.topics ?? [];
  const selectedTopic = topics.find((topic) => topic.id === topicId);
  const subtopics = selectedTopic?.subtopics ?? [];

  async function handleCreate() {
    if (!subtopicId) {
      toastError("Choose a subtopic", "Select where this lesson belongs in the curriculum.");
      return;
    }

    setIsCreating(true);
    try {
      const created = await createStudioLesson({
        subtopicId,
        title: title.trim() || undefined,
        estimatedMinutes,
      });
      router.push(`/admin/studio/${created.lessonId}`);
    } catch (error) {
      toastError(
        "Could not create lesson",
        error instanceof Error ? error.message : undefined,
      );
      setIsCreating(false);
    }
  }

  return (
    <div className="space-y-6">
      <PageHeader
        eyebrow="Authoring Studio"
        title="New lesson"
        description="Create a manual draft lesson for a subtopic. No AI is used in this flow."
      />

      <Panel title="Placement">
        <div className="grid gap-4 sm:grid-cols-2">
          <Field label="Subject">
            <Select
              value={subjectCode}
              onChange={(event) => {
                setSubjectCode(event.target.value);
                setTopicId("");
                setSubtopicId("");
              }}
            >
              {subjects.map((subject) => (
                <option key={subject.code} value={subject.code}>
                  {subject.name}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Curriculum">
            <Select
              value={curriculumCode}
              onChange={(event) => {
                setCurriculumCode(event.target.value as Curriculum);
                setTopicId("");
                setSubtopicId("");
              }}
            >
              {curricula.map((curriculum) => (
                <option key={curriculum.code} value={curriculum.code}>
                  {curriculum.code}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Topic">
            <Select
              value={topicId}
              onChange={(event) => {
                setTopicId(event.target.value);
                setSubtopicId("");
              }}
            >
              <option value="">Select topic</option>
              {topics.map((topic) => (
                <option key={topic.id} value={topic.id}>
                  {topic.title}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Subtopic">
            <Select value={subtopicId} onChange={(event) => setSubtopicId(event.target.value)}>
              <option value="">Select subtopic</option>
              {subtopics.map((subtopic) => (
                <option key={subtopic.id} value={subtopic.id}>
                  {subtopic.title}
                </option>
              ))}
            </Select>
          </Field>
          <Field label="Lesson title (optional)">
            <Input
              value={title}
              onChange={(event) => setTitle(event.target.value)}
              placeholder="Untitled lesson"
            />
          </Field>
          <Field label="Estimated minutes">
            <Input
              type="number"
              min={5}
              max={60}
              value={estimatedMinutes}
              onChange={(event) => setEstimatedMinutes(Number(event.target.value))}
            />
          </Field>
        </div>

        <Button
          type="button"
          className="mt-5 min-h-11"
          disabled={isCreating || !subtopicId}
          onClick={() => void handleCreate()}
        >
          {isCreating ? "Creating…" : "Create draft lesson"}
        </Button>
      </Panel>
    </div>
  );
}
