# KCSE Math Mastery — Reuse Contracts

This milestone is math-only, but intentionally defines reusable contracts for future subject expansion.

## Reuse contracts

- **Job-based student IA:** mobile and desktop should preserve the same three-job frame (Learn, Help/Nex, Exam Prep) while subject content swaps behind it.
- **Exam loop contract:** `mock submit -> mastery update -> health score -> predicted grade -> next study task` stays stable regardless of subject.
- **Predicted grade authority:** student-facing grade direction should source from rolling health (`academic_health_scores`) and never from one-off exam percentage alone.
- **Nex assessment contract:** assessment mode must be user-selectable, update session metadata, and feed remediation/planning hooks.
- **Honest exam copy:** use subject-specific "exam-style" language unless licensed past papers exist.

## Subject onboarding checklist (future)

1. Seed subject curriculum + question banks.
2. Wire subject topic resolution in Nex context loading.
3. Enable exam-prep subject selector for the subject.
4. Add subject-specific health-score rows and parent surface labels.
5. Reuse existing e2e scaffolding from `e2e/kcse-math-mastery.spec.ts` with subject assertions updated.
