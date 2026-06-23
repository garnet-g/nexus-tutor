import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { afterEach, beforeEach, describe, expect, it, vi } from "vitest";

import { ExamSimulatorShell } from "@/features/mockExams/components/ExamSimulatorShell";

const pushMock = vi.fn();

vi.mock("next/navigation", () => ({
  useRouter: () => ({ push: pushMock }),
}));

const questions = [
  {
    id: "q1",
    question_text: "What is 2 + 2?",
    question_type: "multiple_choice",
    options: ["3", "4", "5"],
    difficulty: "easy",
    sort_order: 0,
  },
  {
    id: "q2",
    question_text: "What is the capital of Kenya?",
    question_type: "short_answer",
    options: null,
    difficulty: "easy",
    sort_order: 1,
  },
];

const examMeta = {
  curriculum: "KCSE",
  gradeLevel: "Form 4",
  examStyle: "kcse_style",
  questionCount: 2,
};

const submitData = {
  analysis: {
    scorePercentage: 50,
    weakTopics: ["Geography"],
    predictedGrade: "B",
    predictedGradeDelta: "unchanged",
    summary: "Good start — revise Geography next.",
  },
  review: [
    {
      questionId: "q1",
      sortOrder: 0,
      questionText: "What is 2 + 2?",
      questionType: "multiple_choice",
      options: ["3", "4", "5"],
      difficulty: "easy",
      topicTitle: "Arithmetic",
      correctAnswer: "4",
      yourAnswer: "4",
      isCorrect: true,
      explanation: null,
    },
    {
      questionId: "q2",
      sortOrder: 1,
      questionText: "What is the capital of Kenya?",
      questionType: "short_answer",
      options: null,
      difficulty: "easy",
      topicTitle: "Geography",
      correctAnswer: "Nairobi",
      yourAnswer: "Mombasa",
      isCorrect: false,
      explanation: "Nairobi is the capital city of Kenya.",
    },
  ],
  correctCount: 1,
  totalCount: 2,
};

function futureEndsAt(): string {
  return new Date(Date.now() + 60 * 60 * 1000).toISOString();
}

let fetchMock: ReturnType<typeof vi.fn>;

beforeEach(() => {
  pushMock.mockReset();
  fetchMock = vi.fn().mockResolvedValue({
    ok: true,
    json: async () => ({ success: true, data: submitData }),
  });
  vi.stubGlobal("fetch", fetchMock);
});

afterEach(() => {
  vi.unstubAllGlobals();
});

describe("ExamSimulatorShell", () => {
  it("renders multiple-choice questions as selectable options, not a text box", () => {
    render(
      <ExamSimulatorShell
        simulatorSessionId="sim-1"
        endsAt={futureEndsAt()}
        questions={questions}
        examMeta={examMeta}
      />,
    );

    const radios = screen.getAllByRole("radio");
    expect(radios).toHaveLength(3);

    const optionFour = screen.getByRole("radio", { name: /4/ });
    expect(optionFour.getAttribute("aria-checked")).toBe("false");
    fireEvent.click(optionFour);
    expect(optionFour.getAttribute("aria-checked")).toBe("true");
  });

  it("renders a text input for short-answer questions", () => {
    render(
      <ExamSimulatorShell
        simulatorSessionId="sim-1"
        endsAt={futureEndsAt()}
        questions={questions}
        examMeta={examMeta}
      />,
    );

    expect(screen.getByLabelText("Answer for question 2")).toBeTruthy();
  });

  it("warns before submitting when questions are unanswered", () => {
    render(
      <ExamSimulatorShell
        simulatorSessionId="sim-1"
        endsAt={futureEndsAt()}
        questions={questions}
        examMeta={examMeta}
      />,
    );

    fireEvent.click(screen.getAllByRole("button", { name: /submit paper/i })[0]);

    expect(screen.getByRole("alertdialog")).toBeTruthy();
    expect(fetchMock).not.toHaveBeenCalled();
  });

  it("submits all answers and renders the marked paper with score and corrections", async () => {
    render(
      <ExamSimulatorShell
        simulatorSessionId="sim-1"
        endsAt={futureEndsAt()}
        questions={questions}
        examMeta={examMeta}
      />,
    );

    fireEvent.click(screen.getByRole("radio", { name: /4/ }));
    fireEvent.change(screen.getByLabelText("Answer for question 2"), {
      target: { value: "Mombasa" },
    });

    fireEvent.click(screen.getAllByRole("button", { name: /submit paper/i })[0]);

    expect(await screen.findByText("50%")).toBeTruthy();
    expect(screen.getByText("Correct")).toBeTruthy();
    expect(screen.getByText("Incorrect")).toBeTruthy();
    // Correct answer for the missed short-answer question is revealed
    // (also appears in the explanation, hence getAllByText).
    expect(screen.getAllByText(/Nairobi/).length).toBeGreaterThan(0);
    // Weak-topic chip surfaces.
    expect(screen.getAllByText("Geography").length).toBeGreaterThan(0);

    await waitFor(() => {
      expect(fetchMock).toHaveBeenCalledWith(
        "/api/exam-simulator/sim-1/submit",
        expect.objectContaining({ method: "POST" }),
      );
    });
  });

  it("routes to progress from the results screen", async () => {
    render(
      <ExamSimulatorShell
        simulatorSessionId="sim-1"
        endsAt={futureEndsAt()}
        questions={questions}
        examMeta={examMeta}
      />,
    );

    fireEvent.click(screen.getByRole("radio", { name: /4/ }));
    fireEvent.change(screen.getByLabelText("Answer for question 2"), {
      target: { value: "Mombasa" },
    });
    fireEvent.click(screen.getAllByRole("button", { name: /submit paper/i })[0]);

    const viewProgress = await screen.findByRole("button", { name: /view progress/i });
    fireEvent.click(viewProgress);
    expect(pushMock).toHaveBeenCalledWith("/progress");
  });
});
