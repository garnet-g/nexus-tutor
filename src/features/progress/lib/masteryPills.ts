export type MasteryPillStatus = "needs_work" | "developing" | "mastered";

export interface MasteryPill {
  status: MasteryPillStatus;
  label: string;
}

export function getMasteryPill(masteryPercentage: number): MasteryPill {
  if (masteryPercentage >= 70) {
    return { status: "mastered", label: "Mastered" };
  }

  if (masteryPercentage >= 40) {
    return { status: "developing", label: "Developing" };
  }

  return { status: "needs_work", label: "Needs work" };
}

export const masteryPillClass: Record<MasteryPillStatus, string> = {
  needs_work:
    "border-nexus-danger/30 bg-nexus-danger-soft text-nexus-danger",
  developing:
    "border-nexus-warning/30 bg-nexus-accent-soft text-nexus-warning",
  mastered:
    "border-nexus-success/30 bg-nexus-success-soft text-nexus-success",
};
