import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { AsyncActionButton } from "@/components/ui/async-action-button";
import { FieldError } from "@/components/ui/field-error";

describe("FieldError", () => {
  it("renders nothing when message is empty", () => {
    const { container } = render(<FieldError id="err" message={null} />);
    expect(container.firstChild).toBeNull();
  });

  it("exposes alert semantics and aria-live for screen readers", () => {
    render(<FieldError id="email-error" message="Email is required" />);
    const alert = screen.getByRole("alert");
    expect(alert.getAttribute("id")).toBe("email-error");
    expect(alert.getAttribute("aria-live")).toBe("assertive");
    expect(alert.textContent).toBe("Email is required");
  });
});

describe("AsyncActionButton", () => {
  it("shows pending label and aria-busy when isPending", () => {
    render(
      <AsyncActionButton idleLabel="Save" pendingLabel="Saving..." isPending />,
    );
    const button = screen.getByRole("button", { name: /saving/i });
    expect(button.hasAttribute("disabled")).toBe(true);
    expect(button.getAttribute("aria-busy")).toBe("true");
  });

  it("calls onClick when idle", () => {
    const onClick = vi.fn();
    render(
      <AsyncActionButton idleLabel="Submit" onClick={onClick} type="button" />,
    );
    fireEvent.click(screen.getByRole("button", { name: /submit/i }));
    expect(onClick).toHaveBeenCalledOnce();
  });
});
