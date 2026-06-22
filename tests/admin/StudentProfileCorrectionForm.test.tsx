import { fireEvent, render, screen } from "@testing-library/react";
import { describe, expect, it, vi } from "vitest";

import { StudentProfileCorrectionForm } from "@/features/admin/components/StudentProfileCorrectionForm";

vi.mock("next/navigation", () => ({
  useRouter: () => ({ refresh: vi.fn() }),
}));

const detail = {
  id: "student-1",
  fullName: "Amina Otieno",
  email: "amina@example.test",
  phoneNumber: "+254712345678",
  curriculum: "KCSE",
  gradeLevel: "Form 3",
  schoolName: "Nairobi School",
  targetGrade: "A-",
  isActive: true,
};

describe("StudentProfileCorrectionForm", () => {
  it("renders current student profile values for super-admin correction", () => {
    render(<StudentProfileCorrectionForm detail={detail} />);

    expect((screen.getByLabelText("Full name") as HTMLInputElement).value).toBe(
      "Amina Otieno",
    );
    expect(
      (screen.getByLabelText("Curriculum") as HTMLSelectElement).value,
    ).toBe("KCSE");
    expect(
      (screen.getByLabelText("Grade level") as HTMLSelectElement).value,
    ).toBe("Form 3");
    expect(screen.getByLabelText("Change reason").hasAttribute("required")).toBe(
      true,
    );
  });

  it("switches grade choices when curriculum changes", () => {
    render(<StudentProfileCorrectionForm detail={detail} />);

    fireEvent.change(screen.getByLabelText("Curriculum"), {
      target: { value: "CBC" },
    });

    expect(
      (screen.getByLabelText("Grade level") as HTMLSelectElement).value,
    ).toBe("Grade 4");
    expect(screen.queryByRole("option", { name: "Form 3" })).toBeNull();
  });
});
