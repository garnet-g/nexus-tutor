import { describe, expect, it } from "vitest";

import {
  buildCameraStudentMessage,
  extractImageText,
  normalizeExtractedProblemText,
} from "@/lib/nex/extractImageText";
import { studentHasCameraAccess } from "@/schemas/cameraSchemas";

describe("extractImageText", () => {
  it("builds a camera student message prefix", () => {
    expect(buildCameraStudentMessage("Solve 2x + 1 = 9")).toBe(
      "Photo question:\nSolve 2x + 1 = 9",
    );
  });

  it("flags out-of-scope extraction", () => {
    expect(normalizeExtractedProblemText("OUT_OF_SCOPE").inCurriculumScope).toBe(
      false,
    );
  });

  it("returns mock extraction when NEX_MOCK_AI is enabled", async () => {
    const previous = process.env.NEX_MOCK_AI;
    process.env.NEX_MOCK_AI = "true";

    const result = await extractImageText({
      imageBytes: new Uint8Array([1, 2, 3]),
      mimeType: "image/jpeg",
    });

    expect(result.provider).toBe("mock");
    expect(result.inCurriculumScope).toBe(true);
    expect(result.extractedText.length).toBeGreaterThan(0);

    process.env.NEX_MOCK_AI = previous;
  });
});

describe("studentHasCameraAccess", () => {
  it("allows premium and family plans only", () => {
    expect(studentHasCameraAccess("premium")).toBe(true);
    expect(studentHasCameraAccess("family")).toBe(true);
    expect(studentHasCameraAccess("free")).toBe(false);
  });
});
