import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { afterEach, describe, expect, it, vi } from "vitest";

import { AssessmentCalibrationPanel } from "@/features/admin/components/AssessmentCalibrationPanel";

describe("AssessmentCalibrationPanel", () => {
  afterEach(() => {
    vi.unstubAllGlobals();
  });

  it("renders the metadata-only calibration workspace and policy", () => {
    render(<AssessmentCalibrationPanel />);

    expect(screen.getByRole("heading", { name: /assessment calibration/i })).toBeTruthy();
    expect(screen.getByText(/do_not_copy_or_redistribute_source_questions/i)).toBeTruthy();
    expect(screen.getAllByText(/English/i).length).toBeGreaterThan(0);
    expect(screen.getAllByText(/needs OCR/i).length).toBeGreaterThan(0);
    expect(screen.queryByLabelText(/question text/i)).toBeNull();
    expect(screen.queryByLabelText(/marking scheme/i)).toBeNull();
  });

  it("posts only calibration metadata to the admin calibration route", async () => {
    const fetchMock = vi.fn(async () =>
      Response.json({
        success: true,
        data: { id: "calibration-1" },
      }),
    );
    vi.stubGlobal("fetch", fetchMock);

    render(<AssessmentCalibrationPanel />);

    fireEvent.change(screen.getByLabelText(/subject/i), {
      target: { value: "mathematics" },
    });
    fireEvent.change(screen.getByLabelText(/paper/i), {
      target: { value: "1" },
    });
    fireEvent.change(screen.getByLabelText(/source label/i), {
      target: { value: "2024 KCSE Mathematics Paper 1" },
    });
    fireEvent.change(screen.getByLabelText(/command verbs/i), {
      target: { value: "solve, simplify" },
    });
    fireEvent.change(screen.getByLabelText(/mark allocation/i), {
      target: { value: "3:20,2:13" },
    });
    fireEvent.change(screen.getByLabelText(/topic signals/i), {
      target: { value: "algebra:8,geometry:5" },
    });
    fireEvent.change(screen.getByLabelText(/operator notes/i), {
      target: { value: "Teacher copy reviewed for metadata only" },
    });

    fireEvent.click(screen.getByRole("button", { name: /save calibration/i }));

    await waitFor(() => {
      expect(fetchMock).toHaveBeenCalledWith(
        "/api/admin/assessment/calibrations",
        expect.objectContaining({ method: "POST" }),
      );
    });

    const [, request] = fetchMock.mock.calls[0] as unknown as [
      string,
      RequestInit,
    ];
    const payload = JSON.parse(String(request.body)) as Record<string, unknown>;

    expect(payload).toMatchObject({
      subjectCode: "mathematics",
      paperNumber: 1,
      sourceLabel: "2024 KCSE Mathematics Paper 1",
      sourcePolicy: "do_not_copy_or_redistribute_source_questions",
    });
    expect(payload).not.toHaveProperty("questionText");
    expect(payload).not.toHaveProperty("markingSchemeText");
    expect(payload.commandVerbs).toEqual(["solve", "simplify"]);
    expect(payload.markAllocation).toEqual([
      { marks: 3, observedCount: 20 },
      { marks: 2, observedCount: 13 },
    ]);
    expect(payload.topicSignals).toEqual([
      { tag: "algebra", observedCount: 8 },
      { tag: "geometry", observedCount: 5 },
    ]);
  });
});
