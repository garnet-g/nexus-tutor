---
milestone: v2-tier-2-kiswahili-chemistry
status: IMPLEMENTING
owner: garnet
created: 2026-06-22
---

# STATUS — Add Kiswahili + Standalone Chemistry (Tier 2)

**Plan:** [IMPLEMENTATION-PLAN.md](./IMPLEMENTATION-PLAN.md)
**KCSE Math + English skeleton:** [KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md](./KCSE-SYLLABUS-SKELETON-MATH-ENGLISH.md)

## Scope (locked)
- Add **Kiswahili** (CBC+KCSE) and a **standalone Chemistry** subject (KCSE only). Do not split the existing `science` subject.
- Content via the AI generate→review→publish→export loop.
- Additive lesson block types: `chemical_equation`, `comprehension_passage`.
- Full vertical: backend + seed + UI surfacing + Nex unblock. **Engine parity (diagnostics/mock-exams/revision) for new subjects is deferred to a future milestone.**

## Phase tracker
| Phase | Title | Status |
|-------|-------|--------|
| 0 | Generation-scope constant | COMPLETE |
| 1 | Subject + skeleton seed (Kiswahili, Chemistry, + KCSE Math/English fill-out) | COMPLETE |
| 2 | Generalize generation + admin-read services | COMPLETE |
| 3 | Additive lesson block types | COMPLETE |
| 4 | Generalize seed-export pipeline | COMPLETE |
| 5 | Unblock Nex tutor | COMPLETE |
| 6 | Surface subjects in student UI | COMPLETE |
| 6.5 | Empty-node gating (prod-ready visibility filter) | COMPLETE |
| 7 | Mass draft generation (Math + English low-risk) | IN PROGRESS — runner built; blocked on skeleton seeds on remote DB |
| 8 | Production-readiness QA gate | PENDING |

## Open gates
- [x] Garnet signs off Chemistry (KNEC) + Kiswahili (KICD) topic/subtopic skeleton — 2026-06-22
- [x] Garnet signs off KCSE Mathematics (121) + English (101) topic skeleton — 2026-06-22
- [x] English set-text titles supplied (KICD 2022–2026): Novel *Fathers of Nations* (Vitta); Play *The Samaritan* (Lara); Optional novel *An Artist of the Floating World* (Ishiguro); Optional play *A Parliament of Owls* (Sidang); Optional anthology *A Silent Song and Other Stories* (ed. Siundu). See skeleton doc §5. — 2026-06-22
- [ ] Decide set-text node structure: 3 nodes (compulsory + anthology) vs 5 nodes (add optional novel + optional play) before seeding titles
- [x] Math generic topics: deprecate algebra/geometry/trigonometry/statistics; official KCSE only — 2026-06-22
- [ ] Phase 7 mass draft generation — `scripts/generateDrafts.ts` ready; remote DB missing Phase 1 KCSE skeleton + English subjects (apply via `setup:local` or `scripts/applySkeletonSeeds.ts` with `DATABASE_URL`)

## Deferred (future milestone)
- Diagnostics, mock exams, and the revision hub generalized beyond Mathematics for Kiswahili + Chemistry.
