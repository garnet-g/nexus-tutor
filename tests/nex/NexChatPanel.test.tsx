import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it } from "vitest";

import { NexChatPanel } from "@/features/nex/components/NexChatPanel";

describe("NexChatPanel", () => {
  it("hydrates existing messages and exposes a new chat action", () => {
    render(
      <NexChatPanel
        initialSessionId="00000000-0000-4000-8000-000000000001"
        initialMessages={[
          {
            id: "message-1",
            role: "student",
            content: "Explain fractions",
          },
        ]}
        initialMode="explain"
        topicId={null}
        dailyUsage={0}
        dailyLimit={10}
        retryAfterSeconds={3600}
        planCode="free"
      />,
    );

    expect(screen.getByText("Explain fractions")).toBeTruthy();
    fireEvent.click(screen.getByRole("button", { name: /new chat/i }));

    expect(screen.queryByText("Explain fractions")).toBeNull();
  });

  it("surfaces the improved tutor workspace context for an active session", () => {
    render(
      <NexChatPanel
        initialSessionId="00000000-0000-4000-8000-000000000001"
        initialSessionStartedAt="2026-06-21T06:00:00.000Z"
        initialMessages={[
          {
            id: "student-1",
            role: "student",
            content: "Quiz me on fractions",
          },
          {
            id: "nex-1",
            role: "nex",
            content: "QUESTION\nWhat is 1/2 + 1/4?",
          },
        ]}
        initialMode="practice"
        topicId={null}
        dailyUsage={7}
        dailyLimit={10}
        retryAfterSeconds={3600}
        planCode="free"
      />,
    );

    expect(screen.getByText(/Continuing your Practice chat/i)).toBeTruthy();
    expect(screen.getByText("3 messages left today")).toBeTruthy();
    expect(screen.getByText(/one question at a time/i)).toBeTruthy();
    expect(screen.getByRole("button", { name: "Harder" })).toBeTruthy();
    expect(screen.getByRole("button", { name: "Easier" })).toBeTruthy();

    fireEvent.click(screen.getByRole("button", { name: /scratchpad/i }));

    expect(
      screen.getByRole("button", { name: /send working to nex/i }),
    ).toBeTruthy();
  });
});
