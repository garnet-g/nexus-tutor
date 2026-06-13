# Nexus Documentation

**Version:** 1.1  
**Mission:** Nexus becomes the most trusted academic companion a student has from Grade 4 to university admission.

**Backbone:** [Nex](./phase-2-product-systems/nex-socratic-tutor-engine.md) — the Socratic Tutor Engine drives every major product system.

---

## How to use these docs

| If you are… | Start here |
|-------------|------------|
| **Building Nex / AI** | [Socratic Engine](./phase-2-product-systems/nex-socratic-tutor-engine.md) → [Prompting Framework](./phase-2-product-systems/nex-prompting-framework.md) → [Nex AI Spec](./phase-2-product-systems/nex-ai-specification.md) |
| **Building features** | [MVP Scope Lock](./product-governance/mvp-feature-scope-lock.md) → [API Standards](./phase-1-foundation/api-standards.md) → [Database Schema](./phase-1-foundation/database-schema.md) |
| **Coding (human or agent)** | [Coding Agent Rules](./phase-5-engineering-governance/coding-agent-rules.md) → [Technical Architecture](./phase-1-foundation/technical-architecture.md) |
| **Product / scope** | [Product Principles](./product-governance/product-principles.md) → [PRD](./product-governance/prd.md) |

---

## Product Governance

| Document | Purpose |
|----------|---------|
| [Product Principles](./product-governance/product-principles.md) | Mission, Nex-first, authority stack |
| [PRD](./product-governance/prd.md) | Full product vision |
| [MVP](./product-governance/mvp.md) | Original MVP brief |
| [Naming Guidelines](./product-governance/naming-guidelines.md) | Code, DB, API naming |
| [MVP Feature Scope Lock](./product-governance/mvp-feature-scope-lock.md) | V1 in/out, launch defaults, acceptance criteria |

---

## Phase 1 — Foundation

| Document | Purpose |
|----------|---------|
| [Technical Architecture](./phase-1-foundation/technical-architecture.md) | Stack, Nex System pipeline, Supabase, auth |
| [Database Schema](./phase-1-foundation/database-schema.md) | Tables, RLS, indexes, migrations |
| [Entity Relationship Diagram](./phase-1-foundation/entity-relationship-diagram.md) | ERD |
| [API Standards](./phase-1-foundation/api-standards.md) | Routes, contracts, errors |

---

## Phase 2 — Product Systems (Nex-led)

| Document | Purpose |
|----------|---------|
| [Nex Socratic Tutor Engine](./phase-2-product-systems/nex-socratic-tutor-engine.md) | **Core pedagogical authority** |
| [Nex Prompting Framework](./phase-2-product-systems/nex-prompting-framework.md) | Exact system & mode prompts |
| [Nex AI Specification](./phase-2-product-systems/nex-ai-specification.md) | Product-level Nex behavior |
| [Academic Health Score Engine](./phase-2-product-systems/academic-health-score-engine.md) | healthScore calculation |
| [Diagnostic Assessment Engine](./phase-2-product-systems/diagnostic-assessment-engine.md) | Onboarding diagnostic |
| [Study Plan Engine](./phase-2-product-systems/study-plan-engine.md) | Daily & exam plans |
| [Mastery Tracking Engine](./phase-2-product-systems/mastery-tracking-engine.md) | Topic mastery |
| [Curriculum Content Model](./phase-2-product-systems/curriculum-content-model.md) | CBC/KCSE structure |

---

## Phase 3 — Business Systems

| Document | Purpose |
|----------|---------|
| [Subscription System](./phase-3-business-systems/subscription-system.md) | Plans, lifecycle |
| [M-Pesa Payment Flow](./phase-3-business-systems/mpesa-payment-flow.md) | STK push, callbacks |
| [Notification Spec](./phase-3-business-systems/notification-spec.md) | Celcom + Resend |
| [Free Trial System](./phase-3-business-systems/free-trial-system.md) | 7-day trial |
| [Platform Admin System](./phase-3-business-systems/platform-admin-system.md) | Super admin pricing, limits, promotions |

---

## Phase 4 — UX

| Document | Purpose |
|----------|---------|
| [Design System](./phase-4-ux/design-system.md) | Tokens, components |
| [Screen Inventory](./phase-4-ux/screen-inventory.md) | V1 screens |
| [User Flows](./phase-4-ux/user-flows.md) | Journeys |
| [Mobile Experience Rules](./phase-4-ux/mobile-experience-rules.md) | Mobile-first |

---

## Phase 5 — Engineering Governance

| Document | Purpose |
|----------|---------|
| [Coding Agent Rules](./phase-5-engineering-governance/coding-agent-rules.md) | Agent constraints |
| [Coding Standards](./phase-5-engineering-governance/coding-standards.md) | TypeScript patterns |
| [Testing Standards](./phase-5-engineering-governance/testing-standards.md) | Test priorities |
| [Security Standards](./phase-5-engineering-governance/security-standards.md) | Auth, secrets, RLS |
| [Deployment Standards](./phase-5-engineering-governance/deployment-standards.md) | Vercel, Supabase |

---

## Locked V1 decisions (summary)

| Topic | Decision |
|-------|----------|
| AI primary | **Gemini Flash** via `GEMINI_API_KEY` |
| AI fallback | **OpenAI** via `OPENAI_API_KEY` on primary failure |
| Model router | **Not real code in V1** — hardcoded primary/fallback in `lib/nex/` |
| Nex modes (V1 UI) | Explain, Practice, Homework, Revision |
| Assessment Mode | **Documented, ships V2** (prompts exist; no V1 UI/API) |
| Diagnostic | Math-only V1; schema may seed other subjects |
| Payments | **Freemium + M-Pesa** (799 / 2499) ships V1 |
| University / career | Vision only until V2+ |
| Hint / answer after | **3 attempts** → Level 4 hint or full solution (Homework) |
| Timezone | `Africa/Nairobi` |
| **Pricing** | Free forever · defaults Premium **799** · Family **2499** (editable by super_admin) |
| **Daily limits** | Free: 10 Nex / 3 practice · Premium: 75 Nex / 20 practice |

Full detail: [MVP Scope Lock](./product-governance/mvp-feature-scope-lock.md).

---

## Conflict rulings (resolved)

| Conflict | Ruling |
|----------|--------|
| GPT vs Gemini | Gemini Flash primary |
| Multi-subject diagnostic | Math-only V1 active; seed other subjects in schema |
| Four vs five Nex modes | Four active V1; Assessment Mode V2 |
| Socratic doc location | `phase-2-product-systems/nex-socratic-tutor-engine.md` |
| API keys | `GEMINI_API_KEY` primary; keep `OPENAI_API_KEY` for fallback |
| M-Pesa | Ships V1 |
| University vision | Vision only, V2+ |
