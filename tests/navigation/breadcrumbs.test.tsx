import { render, screen, within } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { Breadcrumbs } from "@/components/layout/breadcrumbs";

vi.mock("next/link", () => ({
  default: ({
    children,
    href,
    ...props
  }: {
    children: React.ReactNode;
    href: string;
  }) => (
    <a href={href} {...props}>
      {children}
    </a>
  ),
}));

describe("Breadcrumbs", () => {
  it("renders ancestor links and marks the last item as the current page", () => {
    render(
      <Breadcrumbs
        items={[
          { label: "Learn", href: "/learn" },
          { label: "Algebra", href: "/learn/algebra" },
          { label: "Linear equations" },
        ]}
      />,
    );

    const nav = screen.getByRole("navigation", { name: "Breadcrumb" });
    const list = within(nav).getByRole("list");
    const items = within(list).getAllByRole("listitem");

    expect(items).toHaveLength(3);

    const learnLink = within(items[0]!).getByRole("link", { name: "Learn" });
    expect(learnLink.getAttribute("href")).toBe("/learn");

    const algebraLink = within(items[1]!).getByRole("link", { name: "Algebra" });
    expect(algebraLink.getAttribute("href")).toBe("/learn/algebra");

    const currentPage = within(items[2]!).getByText("Linear equations");
    expect(currentPage.tagName).toBe("SPAN");
    expect(currentPage.getAttribute("aria-current")).toBe("page");
    expect(within(items[2]!).queryByRole("link")).toBeNull();
  });

  it("renders exam prep simulator hierarchy with a current-page span", () => {
    render(
      <Breadcrumbs
        items={[
          { label: "Exam Prep", href: "/exam-prep" },
          { label: "Exam Simulator" },
        ]}
      />,
    );

    const nav = screen.getByRole("navigation", { name: "Breadcrumb" });
    const examPrepLink = within(nav).getByRole("link", { name: "Exam Prep" });
    expect(examPrepLink.getAttribute("href")).toBe("/exam-prep");

    const currentPage = screen.getByText("Exam Simulator");
    expect(currentPage.tagName).toBe("SPAN");
    expect(currentPage.getAttribute("aria-current")).toBe("page");
  });

  it("returns null when there are no items", () => {
    render(<Breadcrumbs items={[]} />);
    expect(screen.queryByRole("navigation", { name: "Breadcrumb" })).toBeNull();
  });
});
