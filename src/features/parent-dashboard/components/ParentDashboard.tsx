"use client";

import { useState } from "react";

import type { LinkedStudentOverview } from "@/server/services/parentLinkService";

interface ParentDashboardProps {
  linkedStudents: LinkedStudentOverview[];
}

export function ParentDashboard({ linkedStudents }: ParentDashboardProps) {
  const [inviteCode, setInviteCode] = useState("");
  const [isLinking, setIsLinking] = useState(false);
  const [linkError, setLinkError] = useState<string | null>(null);
  const [linkSuccess, setLinkSuccess] = useState<string | null>(null);

  async function handleLinkStudent(event: React.FormEvent<HTMLFormElement>) {
    event.preventDefault();
    setIsLinking(true);
    setLinkError(null);
    setLinkSuccess(null);

    try {
      const response = await fetch("/api/parents/link", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ inviteCode }),
      });

      const payload = (await response.json()) as {
        success: boolean;
        data?: { studentName: string };
        error?: { message: string };
      };

      if (!response.ok || !payload.success) {
        setLinkError(payload.error?.message ?? "Could not link student.");
        return;
      }

      setLinkSuccess(
        `Linked to ${payload.data?.studentName ?? "student"} successfully.`,
      );
      setInviteCode("");
      window.location.reload();
    } catch {
      setLinkError("Network error. Please try again.");
    } finally {
      setIsLinking(false);
    }
  }

  return (
    <div className="space-y-6">
      <section className="rounded-2xl border border-border bg-card p-6">
        <h2 className="text-lg font-medium text-foreground">Link a student</h2>
        <p className="mt-2 text-sm text-muted-foreground">
          Ask your child for their Nexus invite code from their account settings.
        </p>
        <form onSubmit={handleLinkStudent} className="mt-4 flex flex-col gap-3 sm:flex-row">
          <input
            type="text"
            value={inviteCode}
            onChange={(event) => setInviteCode(event.target.value)}
            placeholder="NEXUS-ABC123"
            className="h-10 flex-1 rounded-lg border border-border px-3 text-sm uppercase text-foreground"
            required
          />
          <button
            type="submit"
            disabled={isLinking}
            className="h-10 rounded-lg bg-primary px-4 text-sm font-medium text-primary-foreground hover:bg-primary/90 disabled:opacity-60"
          >
            {isLinking ? "Linking..." : "Link student"}
          </button>
        </form>
        {linkError ? (
          <p className="mt-2 text-sm text-red-600">{linkError}</p>
        ) : null}
        {linkSuccess ? (
          <p className="mt-2 text-sm text-nexus-success">{linkSuccess}</p>
        ) : null}
      </section>

      <section className="space-y-4">
        <h2 className="text-lg font-medium text-foreground">Linked students</h2>
        {linkedStudents.length === 0 ? (
          <div className="rounded-2xl border border-border bg-card p-6">
            <p className="text-sm text-muted-foreground">
              No students linked yet. Enter an invite code above to get started.
            </p>
          </div>
        ) : (
          linkedStudents.map((student) => (
            <article
              key={student.studentId}
              className="rounded-2xl border border-border bg-card p-6"
            >
              <div className="flex flex-wrap items-start justify-between gap-2">
                <div>
                  <h3 className="text-lg font-medium text-foreground">
                    {student.fullName}
                  </h3>
                  <p className="text-sm text-muted-foreground">
                    {student.curriculum} · {student.gradeLevel}
                  </p>
                </div>
                <div className="flex flex-col items-end gap-2">
                  {student.linkedAt ? (
                    <p className="text-xs text-muted-foreground">
                      Linked {new Date(student.linkedAt).toLocaleDateString()}
                    </p>
                  ) : null}
                  <button
                    type="button"
                    className="rounded-lg border border-destructive/40 px-3 py-1.5 text-xs font-medium text-destructive transition-colors hover:bg-destructive/10"
                    onClick={() => {
                      if (
                        !window.confirm(
                          `Unlink ${student.fullName}? You will lose access to their progress immediately.`,
                        )
                      ) {
                        return;
                      }

                      void (async () => {
                        const response = await fetch(
                          `/api/parents/linked-students/${student.studentId}`,
                          { method: "DELETE" },
                        );
                        if (!response.ok) {
                          window.alert("Could not unlink this student.");
                          return;
                        }

                        window.location.reload();
                      })();
                    }}
                  >
                    Unlink student
                  </button>
                </div>
              </div>

              <dl className="mt-4 grid gap-4 sm:grid-cols-3">
                <div>
                  <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    Study time (7 days)
                  </dt>
                  <dd className="mt-1 text-2xl font-semibold text-foreground">
                    {student.weeklyStudyMinutes}
                    <span className="text-base font-normal text-muted-foreground"> min</span>
                  </dd>
                </div>
                <div>
                  <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    Health score
                  </dt>
                  <dd className="mt-1 text-2xl font-semibold text-foreground">
                    {student.healthScore !== null
                      ? `${student.healthScore.toFixed(0)}%`
                      : "—"}
                  </dd>
                </div>
                <div>
                  <dt className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    Weak topics
                  </dt>
                  <dd className="mt-1 text-sm text-foreground/80">
                    {student.weakTopics.length > 0
                      ? student.weakTopics.join(", ")
                      : "None identified yet"}
                  </dd>
                </div>
              </dl>

              {student.weeklyGoal ? (
                <div className="mt-4 rounded-xl border border-border bg-muted/30 p-4">
                  <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                    Weekly goal (shared by student)
                  </p>
                  <p className="mt-1 text-sm text-foreground">
                    {student.weeklyGoal.targetMinutes} study minutes and{" "}
                    {student.weeklyGoal.targetTasks} tasks this week.
                  </p>
                  {student.weeklyGoal.note ? (
                    <p className="mt-2 text-sm text-muted-foreground">{student.weeklyGoal.note}</p>
                  ) : null}
                  <p className="mt-2 text-xs text-muted-foreground">
                    Logged study so far: {student.weeklyStudyMinutes} min
                  </p>
                </div>
              ) : null}

              <div className="mt-4 rounded-xl border border-border bg-muted/40 p-4">
                <div className="flex flex-wrap items-start justify-between gap-3">
                  <div>
                    <p className="text-xs font-medium uppercase tracking-wide text-muted-foreground">
                      KCSE maths revision
                    </p>
                    <p className="mt-1 text-sm text-foreground/80">
                      {student.nextMathRepairTopic
                        ? `Next repair topic: ${student.nextMathRepairTopic}`
                        : "Next repair topic appears after maths practice."}
                    </p>
                  </div>
                  <div className="text-right">
                    <p className="text-2xl font-semibold text-foreground">
                      {student.mathReadinessScore !== null
                        ? `${student.mathReadinessScore}%`
                        : "-"}
                    </p>
                    <p className="text-xs font-medium text-muted-foreground">
                      {student.mathReadinessLabel ?? "No readiness yet"}
                    </p>
                  </div>
                </div>
                <p className="mt-3 text-xs leading-5 text-muted-foreground">
                  {student.revisionPrivacyNote}
                </p>
              </div>
            </article>
          ))
        )}
      </section>
    </div>
  );
}
