# Nexus Product Principles

**Version:** 1.0  
**Status:** Product Governance — applies to all docs, design, and code

---

## Mission

**Nexus becomes the most trusted academic companion a student has from Grade 4 to university admission.**

This is the long-term product mission. V1 launches a focused slice of this vision (CBC/KCSE, Mathematics, Nex-led learning). University admission features are **vision only until V2+**.

---

## Nex as Backbone

Nex is not a feature bolted onto a content app. **Nex is the backbone of the whole product.**

Every major system exists to feed or serve Nex:

| System | Serves Nex by… |
|--------|----------------|
| Diagnostic Assessment | Establishing baseline for personalized teaching |
| Academic Health Score | Telling Nex where the student stands |
| Curriculum Content | Grounding Nex in approved material |
| Practice | Reinforcing what Nex teaches |
| Study Plans | Executing Nex revision recommendations |
| Progress / Mastery | Updating what Nex knows about the student |
| Parent Corner | Making Nex's impact visible to parents |

**Rule:** If a V1 feature does not connect to Nex or student learning outcomes, it does not ship.

---

## Core Principles

Every document, screen, and API must support:

| Principle | Meaning |
|-----------|---------|
| **Nex-first** | Nex Socratic Tutor Engine governs all teaching behavior |
| **Mobile-first** | Design and build at 375px first |
| **Kenya-first** | KES, +254, M-Pesa, Celcom, local context |
| **CBC-first** | CBC and KCSE are equal citizens; CBC is not an afterthought |
| **M-Pesa-first** | Subscription payments via STK push (799 individual · 2499 family) |
| **Freemium forever** | Free plan never expires — daily usage caps, not paywalls on core learning |
| **AI-assisted, not AI-dependent** | Nex guides; curriculum and practice stand on their own |
| **Student-first** | Student outcomes over feature count |
| **Parent-visible outcomes** | Parents see progress, not chat logs |
| **Trust through teaching** | Launch-ready trust = Socratic integrity, curriculum grounding, honest uncertainty, academic integrity — not marketing language |
| **Simplicity over feature count** | Ship less, ship well |
| **Personalization over content volume** | Memory and adaptation beat content library size |
| **Lifelong companion (vision)** | Architecture supports years of student history; V1 seeds the foundation |
| **Build for a 2–5 developer team** | Pragmatic scope, clear docs, no over-engineering |

---

## Teaching Principles (from Socratic Engine)

1. Understanding > correct answers  
2. Guidance > solution delivery  
3. Confidence building > error detection  
4. Learning process > task completion  
5. Adaptive teaching  

See [Nex Socratic Tutor Engine](../phase-2-product-systems/nex-socratic-tutor-engine.md).

---

## Authority Stack

When documents conflict, resolve in this order:

1. [Product Principles](./product-principles.md) (this file)  
2. [Nex Socratic Tutor Engine](../phase-2-product-systems/nex-socratic-tutor-engine.md)  
3. [MVP Feature Scope Lock](./mvp-feature-scope-lock.md)  
4. [PRD](./prd.md)  
5. [Naming Guidelines](./naming-guidelines.md)  

Implementation details (API shapes, schema) follow Phase 1 Foundation docs.

---

## Related Documents

- [PRD](./prd.md)
- [MVP Scope Lock](./mvp-feature-scope-lock.md)
- [Nex AI Specification](../phase-2-product-systems/nex-ai-specification.md)
- [Technical Architecture — Nex System](../phase-1-foundation/technical-architecture.md#13-nex-system)
