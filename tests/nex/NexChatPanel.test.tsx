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
});
