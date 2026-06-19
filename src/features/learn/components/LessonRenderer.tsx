import type {
  CurriculumLesson,
  LessonContentBlock,
  LessonShortQuizQuestion,
} from "@/types/curriculum";

interface LessonRendererProps {
  lesson: CurriculumLesson;
}

function renderBlock(block: LessonContentBlock, index: number) {
  switch (block.type) {
    case "heading":
      return (
        <h2
          key={`heading-${index}`}
          className="text-xl font-semibold tracking-tight text-foreground"
        >
          {block.content}
        </h2>
      );
    case "paragraph":
      return (
        <p key={`paragraph-${index}`} className="leading-7 text-foreground/80">
          {block.content}
        </p>
      );
    case "example":
      return (
        <div
          key={`example-${index}`}
          className="rounded-xl border border-sky-100 bg-sky-50 p-5"
        >
          <h3 className="text-sm font-semibold uppercase tracking-wide text-sky-900">
            {block.title}
          </h3>
          <ol className="mt-3 list-decimal space-y-2 pl-5 text-sm text-sky-950">
            {block.steps.map((step, stepIndex) => (
              <li key={stepIndex}>{step}</li>
            ))}
          </ol>
          <p className="mt-4 text-sm font-medium text-sky-900">
            Answer: {block.answer}
          </p>
        </div>
      );
    case "tip":
      return (
        <div
          key={`tip-${index}`}
          className="rounded-xl border border-amber-100 bg-amber-50 px-4 py-3 text-sm text-amber-950"
        >
          <span className="font-semibold">Tip: </span>
          {block.content}
        </div>
      );
    default:
      return null;
  }
}

function ShortQuizSection({ questions }: { questions: LessonShortQuizQuestion[] }) {
  if (questions.length === 0) {
    return null;
  }

  return (
    <section className="space-y-4 rounded-2xl border border-border bg-muted/50 p-6">
      <h2 className="text-lg font-semibold text-foreground">Quick check</h2>
      <div className="space-y-4">
        {questions.map((question, index) => (
          <div key={index} className="rounded-xl bg-card p-4 shadow-sm">
            <p className="font-medium text-foreground">{question.questionText}</p>
            <ul className="mt-3 space-y-2">
              {question.options.map((option) => (
                <li
                  key={option}
                  className="rounded-lg border border-border px-3 py-2 text-sm text-foreground/80"
                >
                  {option}
                </li>
              ))}
            </ul>
          </div>
        ))}
      </div>
    </section>
  );
}

export function LessonRenderer({ lesson }: LessonRendererProps) {
  return (
    <article className="space-y-8">
      <header className="space-y-2">
        <p className="text-sm font-medium uppercase tracking-wide text-muted-foreground">
          {lesson.topicTitle} · {lesson.subtopicTitle}
        </p>
        <h1 className="text-3xl font-semibold tracking-tight text-foreground">
          {lesson.title}
        </h1>
        <p className="text-sm text-muted-foreground">
          {lesson.curriculumCode} · {lesson.estimatedMinutes} min read
        </p>
      </header>

      <div className="space-y-5">{lesson.content.blocks.map(renderBlock)}</div>

      {lesson.content.shortQuiz?.questions ? (
        <ShortQuizSection questions={lesson.content.shortQuiz.questions} />
      ) : null}
    </article>
  );
}
