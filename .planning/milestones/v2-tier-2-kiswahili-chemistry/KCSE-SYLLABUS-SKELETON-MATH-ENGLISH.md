---
milestone: v2-tier-2-kiswahili-chemistry
phase: 1-companion
agent: architect
version: 1
status: DRAFT — REQUIRES OWNER SIGN-OFF
source: KNEC 8-4-4 secondary syllabus (Mathematics 121; English 101). Canonical topic strands.
---

# KCSE Syllabus Skeleton — Mathematics & English (proper KCSE seeding)

> **Why this exists.** The current KCSE seeds are placeholders: Mathematics has only 5 topics
> (`algebra`, `fractions`, `geometry`, `trigonometry`, `statistics`) and English only 3
> (`reading_comprehension`, `grammar`, `writing_skills`). The real KNEC KCSE Mathematics syllabus is
> ~44 topics across Form 1–4; English is structured around three papers (101/1, 101/2, 101/3) and
> five skill domains. This document is the **authoritative, additive skeleton** to bring both subjects
> to full KCSE coverage. It is the Phase-1 input for Math/English, parallel to the Kiswahili/Chemistry
> skeleton in `IMPLEMENTATION-PLAN.md §4`.

> **HALLUCINATION GUARD (same rule as the main plan).** Agents MUST NOT invent or reorder syllabus
> topics. This list is transcribed from the canonical KNEC 8-4-4 Mathematics (121) and English (101)
> syllabus strands. **Garnet must confirm against the official KNEC syllabus PDF before Phase 1 is
> committed.** Set-text titles (English Paper 3) rotate per exam cycle and are deliberately left as
> placeholders — do not hardcode a title; the owner supplies the current cycle's texts.

---

## 1. Non-negotiable reconciliation rules (read before touching seeds)

1. **Never rename or delete an existing topic/subtopic `code`.** Codes are foreign-key-by-value across
   lessons/questions and are referenced by the export script. The 5 existing Math topics and 3 English
   topics (and their subtopics, listed in §4) **stay exactly as they are**. We only ADD.
2. **Additive only.** New topics/subtopics are inserted with the same `ON CONFLICT (...) DO NOTHING` /
   `DO UPDATE` pattern already used in `supabase/seed/curriculum_science.sql`. No `DROP`/`DELETE`/rename.
3. **Existing generic topics are retained as-is.** Where a current generic topic overlaps a finer
   syllabus topic (e.g. existing `statistics` vs syllabus `statistics_i`/`statistics_ii`), keep the
   existing one AND add the granular ones. Optional later cleanup (a separate future task) may set the
   generic duplicates to `is_active=false` — that is **non-destructive deprecation**, not part of this
   milestone. Do not do it now.
4. **`min_grade_sort_order`** uses KCSE `grade_levels.sort_order`: `form_1=1, form_2=2, form_3=3,
   form_4=4`. A topic taught in Form 3 gets `3`. This drives grade-gated visibility
   (`isTopicVisibleForGrade`, ±1 tolerance).
5. **`sort_order`** is the display order within the subject; number topics sequentially by form then
   syllabus order (Form 1 topics 1..n, Form 2 continues, etc.).
6. **Skeleton only.** These seed entries contain topics + subtopics. **No lessons, no questions** —
   those are produced by the AI generate→review→publish→export loop (D2 in the main plan).

---

## 2. Where this plugs into the main plan

This is an **addition to `IMPLEMENTATION-PLAN.md` Phase 1**. Concretely:

- New skeleton seed files (skeleton = topics+subtopics only), loaded AFTER the existing curriculum
  seeds so the `ON CONFLICT` upserts layer on top:
  - `supabase/seed/curriculum_math_kcse.sql` — adds the full KCSE Mathematics Form 1–4 topics/subtopics.
  - `supabase/seed/curriculum_english_kcse.sql` — adds the full KCSE English topics/subtopics.
- Register both in `supabase/config.toml` `[db.seed] sql_paths` AFTER `curriculum_math.sql` /
  `curriculum_english.sql` respectively (order matters so existing rows exist first):
  ```toml
  sql_paths = [
    "./seed.sql",
    "./seed/curriculum_math.sql", "./seed/curriculum_math_kcse.sql",
    "./seed/curriculum_science.sql",
    "./seed/curriculum_english.sql", "./seed/curriculum_english_kcse.sql",
    "./seed/curriculum_chemistry.sql", "./seed/curriculum_kiswahili.sql"
  ]
  ```
- Add both new files to `scripts/scope-check.ts` `seedPaths` so they are scanned.
- **Export-pipeline note (important):** once these skeleton topics exist in the DB, running
  `npm run content:export` (after Phase 4 generalization) will fold them into the regenerated
  `curriculum_math.sql` / `curriculum_english.sql` along with any published lessons/questions. At that
  point the `_kcse.sql` skeleton files become redundant for those subjects and SHOULD be removed from
  `sql_paths` to avoid double-seeding (harmless due to `ON CONFLICT`, but keep it clean). Document this
  handoff in the seed file headers. **Until export has run with real content, keep the skeleton files.**

> Rationale for separate `_kcse.sql` files rather than editing `curriculum_math.sql`: it honors the
> "do not modify existing seed files" rule during the skeleton phase and keeps the diff reviewable.
> The export script is the long-term single source of truth.

---

## 3. KCSE MATHEMATICS (121) — full Form 1–4 skeleton

Format per row: `code` · Title · `min_grade_sort_order` · subtopics (`code` → Title).
**Existing topics are marked [KEEP] — do not duplicate or rename; their current subtopics (§4) remain.**

### Form 1 (min_grade_sort_order = 1)

| `code` | Title | Subtopics (`code` → Title) |
|--------|-------|----------------------------|
| `natural_numbers` | Natural Numbers | `place_values`→Place Values & Rounding; `number_operations`→Operations & Order; `number_line`→Number Line |
| `factors` | Factors | `prime_factors`→Prime Factorisation; `gcd_hcf`→GCD/HCF; `lcm`→LCM |
| `divisibility_tests` | Divisibility Tests | `tests_2_3_4_5`→Tests for 2,3,4,5; `tests_6_8_9_10_11`→Tests for 6,8,9,10,11; `applications`→Applications |
| `integers` | Integers | `number_line_integers`→Integers on the Number Line; `operations_integers`→Operations with Integers; `order_of_operations`→Order of Operations |
| `fractions` **[KEEP]** | Fractions | (existing: `simplifying`, `operations`, `word_problems`) |
| `decimals` | Decimals | `place_value_decimals`→Decimal Place Value; `operations_decimals`→Operations; `recurring_decimals`→Recurring Decimals |
| `squares_square_roots` | Squares and Square Roots | `squares`→Squares; `square_roots_factor`→Roots by Factorisation; `square_roots_tables`→Roots by Tables |
| `algebraic_expressions` | Algebraic Expressions | `forming_expressions`→Forming Expressions; `simplification`→Simplification; `substitution`→Substitution |
| `rates_ratio_proportion` | Rates, Ratio, Percentage & Proportion | `rates`→Rates; `ratio_proportion`→Ratio & Proportion; `percentage`→Percentage |
| `length` | Length | `units_length`→Units & Conversion; `perimeter`→Perimeter; `circumference`→Circumference |
| `area` | Area | `area_plane_figures`→Area of Plane Figures; `area_circle`→Area of a Circle; `area_combined`→Combined Shapes |
| `volume_capacity` | Volume and Capacity | `volume_prisms`→Volume of Prisms; `capacity_units`→Capacity & Units; `applications_volume`→Applications |
| `mass_weight_density` | Mass, Weight and Density | `mass_weight`→Mass & Weight; `density`→Density; `applications_density`→Applications |
| `time` | Time | `units_time`→Units of Time; `timetables`→Timetables; `speed_time`→Time & Speed Basics |
| `linear_equations` | Linear Equations | `solving_linear`→Solving Linear Equations; `forming_linear`→Forming Equations; `applications_linear`→Word Problems |
| `commercial_arithmetic_i` | Commercial Arithmetic I | `profit_loss`→Profit & Loss; `discount_commission`→Discount & Commission; `simple_interest`→Simple Interest |
| `coordinates_graphs` | Coordinates and Graphs | `cartesian_plane`→Cartesian Plane; `plotting_points`→Plotting Points; `linear_graphs`→Linear Graphs |
| `angles_plane_figures` | Angles and Plane Figures | `types_of_angles`→Types of Angles; `angles_straight_lines`→Angles on Lines; `polygons`→Polygons |
| `geometric_constructions` | Geometric Constructions | `construct_angles`→Constructing Angles; `construct_triangles`→Constructing Triangles; `bisectors`→Bisectors |
| `scale_drawing` | Scale Drawing | `scales`→Scales; `bearings_intro`→Bearings (intro); `representation`→Representation |
| `common_solids` | Common Solids | `nets`→Nets; `properties_solids`→Properties; `surface_models`→Surface Models |

### Form 2 (min_grade_sort_order = 2)

| `code` | Title | Subtopics |
|--------|-------|-----------|
| `cubes_cube_roots` | Cubes and Cube Roots | `cubes`→Cubes; `cube_roots_factor`→Roots by Factorisation; `cube_roots_tables`→Roots by Tables |
| `reciprocals` | Reciprocals | `reciprocals_tables`→Reciprocals by Tables; `operations_reciprocals`→Operations; `applications`→Applications |
| `indices_logarithms` | Indices and Logarithms | `laws_of_indices`→Laws of Indices; `standard_form`→Standard Form; `logarithms`→Logarithms |
| `gradient_straight_lines` | Gradient and Equations of Straight Lines | `gradient`→Gradient; `equation_of_line`→Equation of a Line; `parallel_perpendicular`→Parallel & Perpendicular |
| `reflection_congruence` | Reflection and Congruence | `reflection`→Reflection; `congruence`→Congruence; `symmetry`→Symmetry |
| `rotation` | Rotation | `rotation_basics`→Rotation Basics; `centre_angle`→Centre & Angle; `rotational_symmetry`→Rotational Symmetry |
| `similarity_enlargement` | Similarity and Enlargement | `similarity`→Similarity; `enlargement`→Enlargement; `scale_factor`→Scale Factor |
| `pythagoras_theorem` | Pythagoras' Theorem | `theorem`→The Theorem; `applications_pythagoras`→Applications; `3d_problems`→3-D Problems |
| `trigonometry_i` | Trigonometry I | `sine_cosine_tangent`→Sine, Cosine, Tangent; `trig_tables`→Trig Tables; `right_angled_problems`→Right-Angled Problems |
| `area_triangle` | Area of a Triangle | `half_base_height`→½ × base × height; `half_ab_sinc`→½ ab sin C; `heros_formula`→Hero's Formula |
| `area_quadrilaterals_polygons` | Area of Quadrilaterals & Other Polygons | `quadrilaterals`→Quadrilaterals; `regular_polygons`→Regular Polygons; `composite`→Composite Figures |
| `area_part_circle` | Area of Part of a Circle | `sector`→Sector; `segment`→Segment; `combined`→Combined Areas |
| `surface_area_solids` | Surface Area of Solids | `prisms_cylinders`→Prisms & Cylinders; `pyramids_cones`→Pyramids & Cones; `spheres`→Spheres |
| `volume_solids` | Volume of Solids | `prisms_cylinders_vol`→Prisms & Cylinders; `pyramids_cones_vol`→Pyramids & Cones; `spheres_vol`→Spheres |
| `quadratic_expressions_equations` | Quadratic Expressions and Equations | `expansion`→Expansion; `factorisation`→Factorisation; `solving_quadratics`→Solving by Factorisation |
| `linear_inequalities` | Linear Inequalities | `solving_inequalities`→Solving Inequalities; `number_line_ineq`→Number Line; `graphical_region`→Graphical Region |
| `linear_motion` | Linear Motion | `distance_time`→Distance–Time; `velocity_time`→Velocity–Time; `acceleration`→Acceleration |
| `statistics_i` | Statistics I | `data_collection`→Data Collection; `frequency_tables`→Frequency Tables; `mean_median_mode`→Mean, Median, Mode |
| `angle_properties_circle` | Angle Properties of a Circle | `angles_centre_circumference`→Centre & Circumference; `cyclic_quadrilaterals`→Cyclic Quadrilaterals; `tangent_angles`→Tangent Angles |
| `vectors_i` | Vectors I | `vector_notation`→Notation; `addition_subtraction`→Addition & Subtraction; `column_vectors`→Column Vectors |

### Form 3 (min_grade_sort_order = 3)

| `code` | Title | Subtopics |
|--------|-------|-----------|
| `quadratic_equations_ii` | Quadratic Expressions and Equations II | `completing_square`→Completing the Square; `quadratic_formula`→Quadratic Formula; `graphs_quadratics`→Quadratic Graphs |
| `approximations_errors` | Approximations and Errors | `rounding_estimation`→Rounding & Estimation; `absolute_relative_error`→Absolute & Relative Error; `propagation`→Error Propagation |
| `trigonometry_ii` | Trigonometry II | `unit_circle`→Unit Circle; `trig_graphs`→Trig Graphs; `sine_cosine_rules`→Sine & Cosine Rules |
| `surds` | Surds | `simplifying_surds`→Simplifying Surds; `operations_surds`→Operations; `rationalising`→Rationalising the Denominator |
| `further_logarithms` | Further Logarithms | `laws_logarithms`→Laws of Logarithms; `logarithmic_equations`→Logarithmic Equations; `applications_logs`→Applications |
| `commercial_arithmetic_ii` | Commercial Arithmetic II | `compound_interest`→Compound Interest; `appreciation_depreciation`→Appreciation & Depreciation; `hire_purchase`→Hire Purchase & Taxes |
| `circles_chords_tangents` | Circles: Chords and Tangents | `chord_properties`→Chord Properties; `tangent_properties`→Tangent Properties; `intersecting_chords`→Intersecting Chords |
| `matrices` | Matrices | `matrix_operations`→Operations; `determinant_inverse`→Determinant & Inverse; `simultaneous_matrices`→Simultaneous Equations |
| `formulae_variations` | Formulae and Variations | `subject_of_formula`→Change of Subject; `direct_inverse_variation`→Direct & Inverse Variation; `joint_partial`→Joint & Partial Variation |
| `sequences_series` | Sequences and Series | `arithmetic_progression`→Arithmetic Progression; `geometric_progression`→Geometric Progression; `series_sums`→Series & Sums |
| `vectors_ii` | Vectors II | `position_vectors`→Position Vectors; `ratio_theorem`→Ratio Theorem; `vector_geometry`→Vector Geometry |
| `binomial_expansion` | Binomial Expansion | `pascals_triangle`→Pascal's Triangle; `expansion_binomial`→Expansion; `approximations_binomial`→Approximations |
| `probability` | Probability | `experimental_theoretical`→Experimental & Theoretical; `combined_events`→Combined Events; `tree_diagrams`→Tree Diagrams |
| `compound_proportions_rates_work` | Compound Proportions and Rates of Work | `compound_proportion`→Compound Proportion; `mixtures`→Mixtures; `rates_of_work`→Rates of Work |
| `graphical_methods` | Graphical Methods | `tables_graphs`→Tables & Graphs; `linear_laws`→Linear Laws; `graphical_solutions`→Graphical Solutions |

### Form 4 (min_grade_sort_order = 4)

| `code` | Title | Subtopics |
|--------|-------|-----------|
| `matrices_transformations` | Matrices and Transformations | `transformation_matrices`→Transformation Matrices; `successive_transformations`→Successive Transformations; `area_scale_factor`→Area Scale Factor |
| `statistics_ii` | Statistics II | `grouped_data`→Grouped Data; `mean_grouped`→Mean of Grouped Data; `quartiles_deviation`→Quartiles & Standard Deviation |
| `loci` | Loci | `locus_points`→Locus of Points; `constructed_loci`→Constructed Loci; `intersecting_loci`→Intersecting Loci |
| `trigonometry_iii` | Trigonometry III | `trig_ratios_general`→General Angles; `trig_equations`→Trigonometric Equations; `amplitude_period`→Amplitude & Period |
| `three_dimensional_geometry` | Three Dimensional Geometry | `geometric_properties_3d`→Properties of Solids; `angles_3d`→Angles in 3-D; `distances_3d`→Distances in 3-D |
| `longitudes_latitudes` | Longitudes and Latitudes | `position_earth`→Position on the Earth; `distances_great_circles`→Distances & Great Circles; `time_longitude`→Time & Longitude |
| `linear_programming` | Linear Programming | `forming_inequalities`→Forming Inequalities; `graphical_region_lp`→Feasible Region; `optimisation`→Optimisation |
| `differentiation` | Differentiation | `gradient_function`→Gradient Function; `derivatives`→Derivatives; `applications_differentiation`→Rates, Maxima & Minima |
| `area_approximation` | Area Approximation | `trapezium_rule`→Trapezium Rule; `mid_ordinate_rule`→Mid-Ordinate Rule; `comparisons`→Comparisons |
| `integration` | Integration | `indefinite_integrals`→Indefinite Integrals; `definite_integrals`→Definite Integrals; `area_under_curve`→Area Under a Curve |

**Existing generic topics retained [KEEP]:** `algebra`, `geometry`, `trigonometry`, `statistics`
(plus `fractions`, already mapped in Form 1). Keep them and their current subtopics (§4). They overlap
the granular Form-2/3/4 topics above; that overlap is acceptable for now. Do not rename. Optional future
deprecation only (§1.3).

---

## 4. Existing codes to preserve verbatim (do NOT recreate or rename)

These already exist in `curriculum_math.sql` / `curriculum_english.sql` (KCSE). They must remain.

- **Math topics:** `fractions` (subs: `simplifying`, `operations`, `word_problems`); `algebra`
  (`linear_equations`, `quadratic_expressions`, `indices`); `geometry` (`coordinate_geometry`,
  `circles`, `transformations`); `trigonometry` (`ratios`, `identities`, `applications`); `statistics`
  (`central_tendency`, `probability`, `data_representation`).
- **English topics:** `reading_comprehension` (`main_idea`, `inference`, `vocabulary`); `grammar`
  (`parts_of_speech`, `sentences`, `tenses`); `writing_skills` (`paragraphs`, `punctuation`,
  `summaries`).

> Note: some existing subtopic codes (e.g. Math `algebra→linear_equations`) collide by *name* with a
> new Form-1 topic `linear_equations`. That is fine — subtopic codes are unique per `topic_id`, topic
> codes are unique per `subject_id`; they live in different scopes. Keep both.

---

## 5. KCSE ENGLISH (101) — full skeleton

KCSE English is examined in three papers: **101/1 Functional Skills**, **101/2 Comprehension,
Literary Appreciation & Grammar**, **101/3 Creative Composition & Essays on Set Texts**. The syllabus
spans five integrated skill domains. Organise topics by domain (domain is conveyed via topic grouping;
forms indicate when each is emphasised). `min_grade_sort_order` per row.

### Domain A — Listening & Speaking / Oral Skills (Paper 102/1 oral component)

| `code` | Title | min | Subtopics |
|--------|-------|-----|-----------|
| `pronunciation_articulation` | Pronunciation & Articulation | 1 | `vowels_consonants`→Vowels & Consonants; `minimal_pairs`→Minimal Pairs; `silent_letters`→Silent Letters |
| `stress_intonation` | Stress & Intonation | 2 | `word_stress`→Word Stress; `sentence_stress`→Sentence Stress; `intonation_patterns`→Intonation Patterns |
| `listening_comprehension` | Listening Comprehension | 1 | `listening_for_detail`→Listening for Detail; `note_taking`→Note Taking; `responding`→Responding |
| `oral_etiquette_skills` | Oral Etiquette & Communication Skills | 3 | `turn_taking`→Turn Taking; `telephone_etiquette`→Telephone Etiquette; `interviews_oral`→Interviews |
| `oral_literature` | Oral Literature | 2 | `narratives_oral`→Oral Narratives; `songs_proverbs`→Songs & Proverbs; `riddles_tongue_twisters`→Riddles & Tongue Twisters |

### Domain B — Reading (Paper 102/2 comprehension)

| `code` | Title | min | Subtopics |
|--------|-------|-----|-----------|
| `reading_comprehension` **[KEEP]** | Reading Comprehension | 1 | (existing: `main_idea`, `inference`, `vocabulary`) |
| `study_skills` | Study & Reading Skills | 1 | `skimming_scanning`→Skimming & Scanning; `note_making`→Note Making; `summary_skills`→Summary Skills |
| `intensive_reading` | Intensive Reading | 3 | `close_reading`→Close Reading; `interpretation`→Interpretation; `evaluation`→Evaluation |
| `extensive_reading` | Extensive Reading | 2 | `reading_for_pleasure`→Reading for Pleasure; `class_readers`→Class Readers; `reviews`→Book Reviews |

### Domain C — Grammar / Language Structures (Paper 102/2 grammar)

| `code` | Title | min | Subtopics |
|--------|-------|-----|-----------|
| `grammar` **[KEEP]** | Grammar | 1 | (existing: `parts_of_speech`, `sentences`, `tenses`) |
| `nouns_pronouns` | Nouns & Pronouns | 1 | `types_of_nouns`→Types of Nouns; `number_gender`→Number & Gender; `pronoun_types`→Pronoun Types |
| `verbs_tenses` | Verbs & Tenses | 1 | `verb_forms`→Verb Forms; `tense_aspect`→Tense & Aspect; `subject_verb_agreement`→Agreement |
| `phrases_clauses` | Phrases & Clauses | 2 | `phrase_types`→Phrase Types; `clause_types`→Clause Types; `complex_sentences`→Complex Sentences |
| `voice_speech` | Active/Passive Voice & Reported Speech | 3 | `active_passive`→Active & Passive; `direct_indirect`→Direct & Indirect Speech; `transformations_speech`→Transformations |
| `prepositions_phrasal_verbs` | Prepositions & Phrasal Verbs | 2 | `prepositions`→Prepositions; `phrasal_verbs`→Phrasal Verbs; `collocations`→Collocations |
| `question_tags_agreement` | Question Tags & Concord | 2 | `question_tags`→Question Tags; `concord`→Concord; `error_correction`→Error Correction |
| `punctuation_mechanics` | Punctuation & Mechanics | 1 | `punctuation_marks`→Punctuation Marks; `capitalisation`→Capitalisation; `spelling`→Spelling |
| `word_formation` | Word Formation & Vocabulary | 2 | `affixation`→Affixation; `synonyms_antonyms`→Synonyms & Antonyms; `idioms`→Idiomatic Expressions |

### Domain D — Writing (Papers 102/1 functional & 102/3 creative)

| `code` | Title | min | Subtopics |
|--------|-------|-----|-----------|
| `writing_skills` **[KEEP]** | Writing Skills | 1 | (existing: `paragraphs`, `punctuation`, `summaries`) |
| `functional_writing` | Functional / Practical Writing | 2 | `personal_business_letters`→Personal & Business Letters; `emails_memos`→Emails & Memos; `cv_application`→CV & Application Letters |
| `official_documents` | Official Documents | 3 | `minutes_agenda`→Minutes & Agenda; `reports`→Reports; `speeches`→Speeches |
| `short_functional_texts` | Short Functional Texts | 1 | `notices_fliers`→Notices & Fliers; `telephone_messages`→Telephone Messages; `filling_forms`→Filling Forms |
| `creative_composition` | Creative Composition | 2 | `narrative_essay`→Narrative Essay; `descriptive_essay`→Descriptive Essay; `expository_argumentative`→Expository & Argumentative |
| `essay_writing_skills` | Essay Writing Skills | 3 | `planning_outlining`→Planning & Outlining; `coherence_cohesion`→Coherence & Cohesion; `editing_revision`→Editing & Revision |
| `summary_writing` | Summary Writing | 2 | `identifying_points`→Identifying Points; `paraphrasing`→Paraphrasing; `word_limits`→Working to Word Limits |

### Domain E — Literature (Paper 102/2 appreciation & 102/3 set texts)

| `code` | Title | min | Subtopics |
|--------|-------|-----|-----------|
| `literary_appreciation` | Literary Appreciation | 2 | `prose_appreciation`→Prose Appreciation; `figures_of_speech`→Figures of Speech; `themes_style`→Themes & Style |
| `poetry` | Poetry | 2 | `reading_poetry`→Reading Poetry; `poetic_devices`→Poetic Devices; `poetry_analysis`→Analysis & Response |
| `the_novel_set_text` | The Novel (Set Text) | 3 | `plot_structure`→Plot & Structure; `characters_themes`→Characters & Themes; `style_relevance`→Style & Relevance |
| `the_play_set_text` | The Play / Drama (Set Text) | 3 | `plot_dramatic`→Plot & Dramatic Technique; `characters_conflict`→Characters & Conflict; `themes_play`→Themes |
| `short_stories_set_text` | Short Stories (Anthology) | 4 | `story_analysis`→Story Analysis; `comparative_themes`→Comparative Themes; `essay_set_text`→Essay Technique |
| `oral_narrative_essay` | Oral & Narrative Essay (Set-Text-Based) | 4 | `excerpt_questions`→Excerpt Questions; `essay_questions`→Essay Questions; `illustration_evidence`→Illustration & Evidence |

> **SET TEXTS ROTATE — codes are stable, titles are configured per cycle.** `the_novel_set_text`,
> `the_play_set_text`, `short_stories_set_text` are stable topic *codes*; the **title shown to students**
> changes each KCSE cycle and is configured, not guessed.

**Current cycle — KICD set books, 2022–2026 (supplied by owner, confirmed):**

| Topic node | Text | Author/Editor | Type |
|------------|------|---------------|------|
| `the_novel_set_text` | *Fathers of Nations* | Paul B. Vitta | Compulsory novel |
| `the_play_set_text` | *The Samaritan* | John Lara | Compulsory play |
| `short_stories_set_text` | *A Silent Song and Other Stories* | ed. Godwin Siundu | Optional anthology |
| `optional_novel_set_text` *(new node, see below)* | *An Artist of the Floating World* | Kazuo Ishiguro | Optional novel |
| `optional_play_set_text` *(new node, see below)* | *A Parliament of Owls* | Adipo Sidang | Optional play |

> **Structure decision needed.** KCSE requires the two compulsory texts PLUS **one** optional (novel,
> play, or anthology chosen by the school). The skeleton originally had 3 set-text nodes; the optional
> texts add up to 5 distinct books. Recommended: keep the 3 compulsory/anthology nodes above and ADD
> two optional nodes (`optional_novel_set_text`, `optional_play_set_text`) so all five examinable texts
> have a home. Confirm before seeding. Update the topic `title` of each set-text node to the text name
> above (additive `ON CONFLICT DO UPDATE SET title = ...` — non-destructive).

---

## 6. Seeding tasks (additive — extends IMPLEMENTATION-PLAN Phase 1)

1. Create `supabase/seed/curriculum_math_kcse.sql`: for every NEW Math topic in §3 (skip the
   `[KEEP]` ones), one `INSERT INTO public.topics ... WHERE c.code='KCSE' AND s.code='mathematics'
   ON CONFLICT (subject_id, code) DO UPDATE SET ...` plus one `INSERT INTO public.subtopics ...
   ON CONFLICT (topic_id, code) DO NOTHING` per subtopic. Mirror `curriculum_science.sql` exactly.
2. Create `supabase/seed/curriculum_english_kcse.sql`: same for every NEW English topic in §5
   (skip `[KEEP]`), `s.code='english'`.
3. Update `supabase/config.toml` `sql_paths` per §2 (after the existing math/english seeds).
4. Add both files to `scripts/scope-check.ts` `seedPaths`.
5. **Do not author lessons or questions here.** After the skeleton lands, content is produced via the
   `/admin/content` generate→review→publish loop and `npm run content:export` (which then regenerates
   `curriculum_math.sql` / `curriculum_english.sql` with the full topic set + published content).

**Verification**
- `npm run test:scope-check` passes and scans the two new files.
- `supabase db reset` → SQL check: KCSE `mathematics` has the existing 5 topics **plus** the ~39 new
  ones (no topic lost); KCSE `english` has the existing 3 **plus** the new domain topics; CBC subjects
  unchanged; all subtopic counts ≥ 3 per topic.
- Existing `curriculum_math.sql` / `curriculum_english.sql` files remain byte-unchanged in this phase
  (the skeleton lives in the new `_kcse.sql` files).
- Standard green gate: `npm run lint && npm run typecheck && npm test && npm run test:scope-check && npm run build`.

---

## 7. Owner sign-off gate (before Phase 1 commit)

- [ ] Garnet confirms the **Mathematics** topic list (§3) against the official KNEC 121 syllabus.
- [ ] Garnet confirms the **English** topic/domain list (§5) against the official KNEC 101 syllabus.
- [ ] Garnet supplies the **current KCSE set-text titles** (novel, play, short-story anthology) for
      `the_novel_set_text` / `the_play_set_text` / `short_stories_set_text`.
- [ ] Confirm decision on existing generic Math topics (`algebra`/`geometry`/`trigonometry`/`statistics`):
      retain as-is (default) vs deprecate to `is_active=false` later.

Once signed off, this becomes part of `IMPLEMENTATION-PLAN.md` Phase 1 and follows the same
generate→review→publish→export loop for content.

---

## 8. Definition of "prod-ready" per topic + empty-node gating (applies to ALL subjects)

> The skeleton creates topic *nodes*. A node with no content is a broken experience. This section
> defines (a) the **objective bar** a topic must pass to be considered production-ready, and (b) the
> **enforcement mechanism** that hides not-ready topics from students automatically — so an empty or
> shallow node can never reach a learner even if a reviewer forgets. This applies to Mathematics,
> English, Kiswahili, and Chemistry alike.

### 8.1 The bar (objective, tied to existing repo constants)

All thresholds reuse constants already in the codebase — do not invent new numbers:
`MIN_LESSONS_PER_TOPIC = 3`, `MIN_PRACTICE_QUESTIONS_PER_TOPIC = 21` (`src/lib/curriculum/contentModel.ts`);
`TOPIC_QUESTION_COVERAGE_TARGET = 20` per difficulty, `MIN_QUESTIONS_TO_START_PRACTICE = 5`
(`src/lib/curriculum/practiceCoverage.ts`).

A topic is **PROD-READY** only when every box is true:

| # | Criterion | Threshold |
|---|-----------|-----------|
| C1 | Published lessons exist | ≥ `MIN_LESSONS_PER_TOPIC` (3) published lessons across the topic's subtopics, and **every subtopic has ≥1 published lesson** (no empty subtopic). |
| C2 | Published question bank exists | ≥ `MIN_PRACTICE_QUESTIONS_PER_TOPIC` (21) published questions, with **≥ `MIN_QUESTIONS_TO_START_PRACTICE` (5) in each difficulty** (easy/medium/hard). Target: 20/difficulty. |
| C3 | Expert-reviewed | Every published lesson AND question approved by a subject expert (KCSE-level difficulty, factually correct, Kenyan context, no hallucination). Provenance (`generated_by`/`published_by`) recorded. |
| C4 | Grade-mapped | `min_grade_sort_order` set to the correct form. |
| C5 | Renders cleanly | Lesson blocks (including new block types) render in `LessonReader` with no shape errors. |

A topic is **LEARN-READY** if C1+C3+C5 hold; **PRACTICE-READY** if C2+C3 hold. PROD-READY = both.

### 8.2 Enforcement — pillar-specific visibility gate (no empty nodes can render)

Visibility is **derived from published-content counts**, not a manual flag. This is additive (read-layer
only), needs no schema change, and self-heals (a topic appears the moment it crosses the bar, disappears
if content is unpublished).

- **Learn pillar** lists only topics that are **LEARN-READY** (≥3 published lessons, every subtopic
  covered). A topic with zero/short lessons is simply not returned by the query.
- **Practice pillar** lists only topics that are **PRACTICE-READY** (≥5 published questions in the
  chosen difficulty). Reuses the existing `isDifficultyPracticeReady` logic in `practiceCoverage.ts`.
- **Subject-level:** a subject appears in a pillar only if it has ≥1 topic ready for that pillar.
  Consequence: a brand-new subject that has only the skeleton (no published content) does **not** show
  an empty shell to students — exactly the outcome we want for Kiswahili/Chemistry on day one.
- **Generation is unaffected:** skeleton topics/subtopics stay `is_active=true` so the admin pipeline
  can target them. Student visibility is a separate, derived concept — do NOT use `is_active=false` to
  hide unready topics (that would block generation, per `contentGenerationService` requiring
  `is_active=true`).

### 8.3 Implementation (this is a new phase in IMPLEMENTATION-PLAN — "Phase 6.5: Empty-node gating")

Add additive read-layer helpers and apply them in the student-facing reads. Exact touch points:

1. `src/lib/curriculum/contentModel.ts` — add pure predicates:
   ```ts
   export function isTopicLearnReady(publishedLessonCount: number, subtopicCount: number,
     subtopicsWithLesson: number): boolean {
     return publishedLessonCount >= MIN_LESSONS_PER_TOPIC && subtopicCount > 0 &&
       subtopicsWithLesson === subtopicCount;
   }
   export function isTopicPracticeReady(counts: { easy: number; medium: number; hard: number }): boolean {
     return counts.easy + counts.medium + counts.hard > 0 &&
       (counts.easy >= MIN_QUESTIONS_TO_START_PRACTICE ||
        counts.medium >= MIN_QUESTIONS_TO_START_PRACTICE ||
        counts.hard >= MIN_QUESTIONS_TO_START_PRACTICE);
   }
   ```
   (Import `MIN_QUESTIONS_TO_START_PRACTICE` from `practiceCoverage.ts`.)
2. `src/server/services/curriculumService.ts` — in the student subject/topic reads, count **published**
   lessons (`is_active=true AND review_status='published'`) per topic and per subtopic, and published
   questions per topic per difficulty; filter the Learn topic list by `isTopicLearnReady` and exclude
   subjects with no learn-ready topics. (The query already filters `is_active`; ADD the published-count
   filter — do not remove existing filters.)
3. `src/features/practice/**` read path — filter the Practice topic list by `isTopicPracticeReady`
   (reuse existing `practiceCoverage` helpers; many practice reads already check question counts —
   grep first and extend, don't duplicate).
4. `src/features/admin/components/ContentPipelinePanel.tsx` + `contentAdminReadService.ts` — surface a
   per-topic **readiness badge** (PROD-READY / LEARN-READY / PRACTICE-READY / NOT READY) using the same
   predicates, so reviewers see exactly which nodes are short and on what (lessons vs questions vs
   difficulty gap). This is how the team drives every topic to green.

**Verification for the gate**
- Unit tests for `isTopicLearnReady`/`isTopicPracticeReady` boundary cases (2 vs 3 lessons; 4 vs 5
  questions in a difficulty; a subtopic with no lesson blocks the topic).
- Integration: a skeleton-only Kiswahili/Chemistry subject returns ZERO student-visible topics (no empty
  shell); after publishing 3 lessons + 21 questions to one topic, that topic — and only that topic —
  appears in Learn/Practice.
- Existing Math topics that already have published lessons remain visible (no regression); any existing
  topic that is actually empty becomes hidden until filled (intended).

### 8.4 Operational consequence

Phase 7 (content generation) is not "done" per subject until **every listed topic is PROD-READY** or is
deliberately deferred. Track readiness per topic in `STATUS.md`. Because of the gate, partial progress is
safe to ship continuously: only topics that cross the bar light up for students; the rest stay invisible
until they're genuinely ready. **No empty nodes, ever.**
