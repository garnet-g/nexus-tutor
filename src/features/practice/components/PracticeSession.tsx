"use client";

import { useEffect, useState } from "react";
import { useRouter, useSearchParams } from "next/navigation";

interface PracticeQuestion {
  practiceQuestionId: string;
  questionText: string;
  questionType: string;
  options: unknown;
  difficulty: string;
}

interface CompleteResult {
  practiceScore: number;
  correctAnswers: number;
  incorrectAnswers: number;
  healthScore: number;
  predictedGrade: string;
  currentStreak: number;
}

export function PracticeSession({
  topicId,
  topicTitle,
}: {
  topicId: string;
  topicTitle: string;
}) {
  const router = useRouter();
  const [sessionId, setSessionId] = useState<string | null>(null);
  const [questions, setQuestions] = useState<PracticeQuestion[]>([]);
  const [currentIndex, setCurrentIndex] = useState(0);
  const [answer, setAnswer] = useState("");
  const [feedback, setFeedback] = useState<string | null>(null);
  const [loading, setLoading] = useState(true);
  const [submitting, setSubmitting] = useState(false);
  const [result, setResult] = useState<CompleteResult | null>(null);
  const [startedAt] = useState(() => Date.now());

  useEffect(() => {
    async function startSession() {
      try {
        const response = await fetch("/api/practice-sessions", {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            topicId,
            difficulty: "medium",
            questionCount: 10,
          }),
        });
        const payload = await response.json();

        if (!response.ok || !payload.success) {
          throw new Error(payload.error?.message ?? "Could not start practice.");
        }

        setSessionId(payload.data.practiceSessionId);
        setQuestions(payload.data.questions);
      } catch (startError) {
        setFeedback(
          startError instanceof Error
            ? startError.message
            : "Could not start practice.",
        );
      } finally {
        setLoading(false);
      }
    }

    void startSession();
  }, [topicId]);

  const currentQuestion = questions[currentIndex];
  const options = Array.isArray(currentQuestion?.options)
    ? (currentQuestion.options as string[])
    : [];

  async function handleAnswerSubmit() {
    if (!sessionId || !currentQuestion) {
      return;
    }

    setSubmitting(true);

    try {
      const response = await fetch(
        `/api/practice-sessions/${sessionId}/answer`,
        {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({
            practiceQuestionId: currentQuestion.practiceQuestionId,
            studentAnswer: answer,
            timeSpentSeconds: 30,
          }),
        },
      );
      const payload = await response.json();

      if (!response.ok || !payload.success) {
        throw new Error(payload.error?.message ?? "Could not save answer.");
      }

      setFeedback(payload.data.isCorrect ? "Correct!" : "Not quite — keep going.");

      if (currentIndex < questions.length - 1) {
        setCurrentIndex((index) => index + 1);
        setAnswer("");
      } else {
        const completeResponse = await fetch(
          `/api/practice-sessions/${sessionId}/complete`,
          {
            method: "POST",
            headers: { "Content-Type": "application/json" },
            body: JSON.stringify({
              timeSpentSeconds: Math.round((Date.now() - startedAt) / 1000),
            }),
          },
        );
        const completePayload = await completeResponse.json();

        if (!completeResponse.ok || !completePayload.success) {
          throw new Error(
            completePayload.error?.message ?? "Could not complete session.",
          );
        }

        setResult(completePayload.data as CompleteResult);
      }
    } catch (submitError) {
      setFeedback(
        submitError instanceof Error
          ? submitError.message
          : "Could not submit answer.",
      );
    } finally {
      setSubmitting(false);
    }
  }

  if (loading) {
    return (
      <div className="rounded-2xl border border-border bg-card p-8 text-center text-muted-foreground">
        Starting practice on {topicTitle}...
      </div>
    );
  }

  if (result) {
    return (
      <div className="space-y-6">
        <section className="rounded-2xl border border-nexus-success/30 bg-nexus-success/10 p-6">
          <h2 className="text-2xl font-semibold text-emerald-950">Session complete</h2>
          <p className="mt-2 text-nexus-secondary">Score: {result.practiceScore}%</p>
          <p className="text-nexus-secondary">
            {result.correctAnswers} correct · {result.incorrectAnswers} incorrect
          </p>
          <p className="text-nexus-secondary">
            Health score: {result.healthScore}/100 · {result.predictedGrade}
          </p>
          <p className="text-nexus-secondary">Current streak: {result.currentStreak} days</p>
        </section>
        <button
          type="button"
          onClick={() => router.push("/practice")}
          className="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground"
        >
          Back to practice
        </button>
      </div>
    );
  }

  if (!currentQuestion) {
    return (
      <div className="rounded-2xl border border-border bg-card p-6 text-muted-foreground">
        {feedback ?? "No practice questions are available for this topic yet."}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <p className="text-sm text-muted-foreground">
        Question {currentIndex + 1} of {questions.length} · {topicTitle}
      </p>

      <section className="rounded-2xl border border-border bg-card p-6">
        <h2 className="text-xl font-medium text-foreground">
          {currentQuestion.questionText}
        </h2>

        <div className="mt-6 space-y-3">
          {currentQuestion.questionType === "multiple_choice" ? (
            options.map((option) => (
              <label
                key={option}
                className="flex cursor-pointer items-center gap-3 rounded-xl border border-border px-4 py-3"
              >
                <input
                  type="radio"
                  name={currentQuestion.practiceQuestionId}
                  value={option}
                  checked={answer === option}
                  onChange={(event) => setAnswer(event.target.value)}
                />
                <span>{option}</span>
              </label>
            ))
          ) : (
            <input
              type="text"
              value={answer}
              onChange={(event) => setAnswer(event.target.value)}
              className="w-full rounded-xl border border-border px-4 py-3"
              placeholder="Type your answer"
            />
          )}
        </div>
      </section>

      {feedback ? <p className="text-sm text-muted-foreground">{feedback}</p> : null}

      <button
        type="button"
        disabled={submitting || !answer}
        onClick={() => void handleAnswerSubmit()}
        className="rounded-lg bg-primary px-4 py-2 text-sm font-medium text-primary-foreground disabled:opacity-60"
      >
        {submitting ? "Saving..." : "Submit answer"}
      </button>
    </div>
  );
}

export function PracticeTopicPicker({
  topics,
}: {
  topics: Array<{ id: string; title: string; code: string }>;
}) {
  const router = useRouter();
  const searchParams = useSearchParams();
  const selectedTopicId = searchParams.get("topicId");
  const selectedTopic = topics.find((topic) => topic.id === selectedTopicId);

  if (selectedTopic) {
    return (
      <PracticeSession topicId={selectedTopic.id} topicTitle={selectedTopic.title} />
    );
  }

  return (
    <div className="grid gap-4 sm:grid-cols-2">
      {topics.map((topic) => (
        <button
          key={topic.id}
          type="button"
          onClick={() => router.push(`/practice?topicId=${topic.id}`)}
          className="rounded-2xl border border-border bg-card p-6 text-left hover:border-primary/40"
        >
          <h2 className="text-lg font-medium text-foreground">{topic.title}</h2>
          <p className="mt-2 text-sm text-muted-foreground">10 medium questions</p>
        </button>
      ))}
    </div>
  );
}
