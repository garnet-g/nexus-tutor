"use client";

import { useMemo, useState, type FormEvent } from "react";
import { useRouter } from "next/navigation";
import { Save } from "lucide-react";

import { Button } from "@/components/ui/Button";
import { Input } from "@/components/ui/Input";
import { Panel } from "@/features/admin/components/adminUi";
import { toastError, toastSuccess } from "@/features/admin/components/toast";
import { GRADE_LEVELS_BY_CURRICULUM } from "@/types/contentAdmin";
import type { Curriculum } from "@/types/database";

type StudentProfileCorrectionDetail = {
  id: string;
  fullName: string;
  email: string | null;
  phoneNumber: string | null;
  curriculum: string | null;
  gradeLevel: string | null;
  schoolName: string | null;
  targetGrade: string | null;
  isActive: boolean;
};

type ProfilePatchResponse = {
  success: boolean;
  data?: { changedFields: string[] };
  error?: { message?: string };
};

const curriculumOptions: Curriculum[] = ["CBC", "KCSE"];

function normalizeCurriculum(value: string | null): Curriculum {
  return value === "KCSE" ? "KCSE" : "CBC";
}

export function StudentProfileCorrectionForm({
  detail,
}: {
  detail: StudentProfileCorrectionDetail;
}) {
  const router = useRouter();
  const [fullName, setFullName] = useState(detail.fullName);
  const [email, setEmail] = useState(detail.email ?? "");
  const [phoneNumber, setPhoneNumber] = useState(detail.phoneNumber ?? "");
  const [curriculum, setCurriculum] = useState<Curriculum>(
    normalizeCurriculum(detail.curriculum),
  );
  const gradeOptions = useMemo(
    () => GRADE_LEVELS_BY_CURRICULUM[curriculum],
    [curriculum],
  );
  const [gradeLevel, setGradeLevel] = useState(
    detail.gradeLevel && gradeOptions.includes(detail.gradeLevel)
      ? detail.gradeLevel
      : gradeOptions[0],
  );
  const [schoolName, setSchoolName] = useState(detail.schoolName ?? "");
  const [targetGrade, setTargetGrade] = useState(detail.targetGrade ?? "");
  const [isActive, setIsActive] = useState(detail.isActive);
  const [changeReason, setChangeReason] = useState("");
  const [isSubmitting, setIsSubmitting] = useState(false);

  function handleCurriculumChange(nextCurriculum: Curriculum) {
    setCurriculum(nextCurriculum);
    setGradeLevel(GRADE_LEVELS_BY_CURRICULUM[nextCurriculum][0]);
  }

  async function handleSubmit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsSubmitting(true);

    try {
      const response = await fetch(`/api/admin/users/${detail.id}/profile`, {
        method: "PATCH",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          fullName,
          email: email || null,
          phoneNumber: phoneNumber || null,
          curriculum,
          gradeLevel,
          schoolName: schoolName || null,
          targetGrade: targetGrade || null,
          isActive,
          changeReason,
        }),
      });
      const payload = (await response.json()) as ProfilePatchResponse;

      if (!response.ok || !payload.success) {
        toastError("Could not update this profile", payload.error?.message);
        return;
      }

      const count = payload.data?.changedFields.length ?? 0;
      toastSuccess(count === 0 ? "No profile fields changed" : "Profile updated");
      setChangeReason("");
      router.refresh();
    } catch {
      toastError("Network error", "Please try again.");
    } finally {
      setIsSubmitting(false);
    }
  }

  return (
    <Panel
      title="Profile correction"
      description="Fix class, curriculum, contact, and account status when onboarding data is wrong."
    >
      <form onSubmit={handleSubmit} className="space-y-4">
        <div className="grid gap-4 sm:grid-cols-2">
          <label className="block space-y-1.5 text-sm" htmlFor="admin-full-name">
            <span className="text-muted-foreground">Full name</span>
            <Input
              id="admin-full-name"
              value={fullName}
              minLength={2}
              maxLength={120}
              required
              onChange={(event) => setFullName(event.target.value)}
            />
          </label>

          <label className="block space-y-1.5 text-sm" htmlFor="admin-email">
            <span className="text-muted-foreground">Email</span>
            <Input
              id="admin-email"
              type="email"
              value={email}
              onChange={(event) => setEmail(event.target.value)}
            />
          </label>
        </div>

        <div className="grid gap-4 sm:grid-cols-2">
          <label className="block space-y-1.5 text-sm" htmlFor="admin-phone">
            <span className="text-muted-foreground">Phone</span>
            <Input
              id="admin-phone"
              value={phoneNumber}
              placeholder="+254712345678"
              pattern="^(\\+254\\d{9})?$"
              onChange={(event) => setPhoneNumber(event.target.value)}
            />
          </label>

          <label className="block space-y-1.5 text-sm" htmlFor="admin-school">
            <span className="text-muted-foreground">School</span>
            <Input
              id="admin-school"
              value={schoolName}
              maxLength={200}
              onChange={(event) => setSchoolName(event.target.value)}
            />
          </label>
        </div>

        <div className="grid gap-4 sm:grid-cols-3">
          <label
            className="block space-y-1.5 text-sm"
            htmlFor="admin-curriculum"
          >
            <span className="text-muted-foreground">Curriculum</span>
            <select
              id="admin-curriculum"
              value={curriculum}
              onChange={(event) =>
                handleCurriculumChange(event.target.value as Curriculum)
              }
              className="min-h-11 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            >
              {curriculumOptions.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
          </label>

          <label className="block space-y-1.5 text-sm" htmlFor="admin-grade">
            <span className="text-muted-foreground">Grade level</span>
            <select
              id="admin-grade"
              value={gradeLevel}
              onChange={(event) => setGradeLevel(event.target.value)}
              className="min-h-11 w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
            >
              {gradeOptions.map((option) => (
                <option key={option} value={option}>
                  {option}
                </option>
              ))}
            </select>
          </label>

          <label className="block space-y-1.5 text-sm" htmlFor="admin-target">
            <span className="text-muted-foreground">Target grade</span>
            <Input
              id="admin-target"
              value={targetGrade}
              maxLength={20}
              onChange={(event) => setTargetGrade(event.target.value)}
            />
          </label>
        </div>

        <label className="flex items-center gap-3 rounded-xl border border-nexus-border bg-nexus-sunken/40 px-3 py-3 text-sm">
          <input
            type="checkbox"
            checked={isActive}
            onChange={(event) => setIsActive(event.target.checked)}
            className="size-4 rounded border-nexus-border"
          />
          <span className="font-medium text-foreground">Account is active</span>
        </label>

        <label className="block space-y-1.5 text-sm" htmlFor="admin-reason">
          <span className="text-muted-foreground">Change reason</span>
          <textarea
            id="admin-reason"
            value={changeReason}
            minLength={3}
            maxLength={500}
            required
            rows={3}
            placeholder="Example: Student selected the wrong class during onboarding."
            onChange={(event) => setChangeReason(event.target.value)}
            className="w-full rounded-xl border border-nexus-border bg-nexus-surface px-3 py-2 text-sm outline-none focus:border-primary focus:ring-2 focus:ring-primary/20"
          />
        </label>

        <Button type="submit" disabled={isSubmitting} variant="primary">
          <Save className="size-4" />
          {isSubmitting ? "Saving..." : "Save profile correction"}
        </Button>
      </form>
    </Panel>
  );
}
