# Science Content Manifest — V2 Tier 1

**Version:** 1.0  
**Scope:** Minimum Science topics for CBC and KCSE  
**Subject code:** `science`

---

## Summary

| Curriculum | Topics | Lessons | Practice Questions |
|------------|--------|---------|-------------------|
| CBC | 3 | 9 (3 per topic) | 63 (21 per topic) |
| KCSE | 3 | 9 (3 per topic) | 63 (21 per topic) |

CBC covers **Living Things**, **Matter & Energy**, and **Earth & Environment**.  
KCSE covers **Biology Basics**, **Chemistry Basics**, and **Physics Basics**.

Diagnostic assessments remain **math-only** (V1 unchanged).

---

## CBC Science

**Curriculum code:** `CBC`  
**Applicable grades:** Grade 4–9

| Topic | Code | Subtopics | Lessons | Practice Questions | Difficulty Split |
|-------|------|-----------|---------|-------------------|------------------|
| Living Things | `living_things` | Classification, Habitats, Life Processes | 3 | 21 | 7 easy, 7 medium, 7 hard |
| Matter & Energy | `matter_energy` | States of Matter, Simple Machines, Energy Forms | 3 | 21 | 7 easy, 7 medium, 7 hard |
| Earth & Environment | `earth_environment` | Weather, Soil, Conservation | 3 | 21 | 7 easy, 7 medium, 7 hard |

---

## KCSE Science

**Curriculum code:** `KCSE`  
**Applicable forms:** Form 1–4

| Topic | Code | Subtopics | Lessons | Practice Questions | Min Form | Difficulty Split |
|-------|------|-----------|---------|-------------------|----------|------------------|
| Biology Basics | `biology_basics` | Cells, Nutrition, Respiration | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |
| Chemistry Basics | `chemistry_basics` | Elements, Acids & Bases, Reactions | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |
| Physics Basics | `physics_basics` | Forces, Electricity, Waves | 3 | 21 | Form 1 | 7 easy, 7 medium, 7 hard |

---

## Seed Location

| File | Purpose |
|------|---------|
| `scripts/generate-curriculum-seed.mjs` | Generator for science curriculum seed |
| `supabase/seed/curriculum_science.sql` | Topics, subtopics, lessons, practice questions |

---

## Acceptance Criteria

- [x] Three topics per curriculum (CBC + KCSE)
- [x] At least 3 lessons per topic
- [x] At least 21 practice questions per topic across difficulties
- [x] Student UI filters by curriculum and grade level
- [x] Nex tutors science with curriculum-grounded context
