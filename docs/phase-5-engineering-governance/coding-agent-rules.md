# Coding Agent Rules



**Version:** 1.1  

**Audience:** AI coding agents (Cursor, Claude Code, etc.)



---



## 1. Read Before Editing



Before writing or modifying any code:



1. Read [Product Principles](../product-governance/product-principles.md) — Nex is the backbone

2. Read [PRD](../product-governance/prd.md) for product intent

3. Read [Naming Guidelines](../product-governance/naming-guidelines.md)

4. Read [MVP Scope Lock](../product-governance/mvp-feature-scope-lock.md) for V1 boundaries

5. Read [Nex Socratic Tutor Engine](../phase-2-product-systems/nex-socratic-tutor-engine.md) if touching Nex

6. Read existing files in the target feature folder — match patterns



**Do not start coding from assumptions.**



---



## 2. Nex Rule #1



**Do not allow Nex to become a generic chatbot.**



Any change affecting:



- tutoring behavior

- prompting

- teaching flow

- hint generation

- assessment logic

- misconception detection



must comply with:



[`phase-2-product-systems/nex-socratic-tutor-engine.md`](../phase-2-product-systems/nex-socratic-tutor-engine.md)



Prompt templates must match [`phase-2-product-systems/nex-prompting-framework.md`](../phase-2-product-systems/nex-prompting-framework.md).



Do not bypass the Nex pipeline (Mode Detection → Socratic Engine → Gemini Flash → Validator → fallback OpenAI).

**Do not hardcode** subscription prices or daily limits in UI or route handlers — use `getEffectiveSubscriptionConfig()`. Curriculum Context and Student Memory stages may be skipped when empty.



**V1 models:** Gemini Flash primary (`GEMINI_API_KEY`), OpenAI fallback (`OPENAI_API_KEY`). No abstract Model Router.



---



## 3. No Hallucinated Files



| Rule | Detail |

|------|--------|

| Verify existence | Use file search before importing or referencing paths |

| No phantom utilities | Do not create `lib/helpers.ts` if project uses feature-scoped utils |

| No duplicate abstractions | Check if function/table/route already exists |

| Match stack | Next.js 15 App Router, Supabase, shadcn — not Pages Router, not Prisma unless added |



If a file does not exist and is needed, create it in the location defined in [Technical Architecture](../phase-1-foundation/technical-architecture.md).



---



## 4. Verify Routes



Before creating or modifying API routes:



1. Check [API Standards](../phase-1-foundation/api-standards.md) for canonical route path

2. Grep codebase for existing route handlers

3. Use kebab-case domain paths: `/api/nex/chat`, not `/api/chatbot`

4. Do not create V2 banned routes (voice, camera, mock-exams, etc.)



---



## 5. Verify Schema



Before creating or modifying database tables:



1. Check [Database Schema](../phase-1-foundation/database-schema.md)

2. Use `snake_case_plural` tables, `snake_case` columns

3. Create migration via `supabase migration new <name>`

4. Enable RLS in same or follow-up migration



---



## 6. Test After Changes



Never claim "done" without verification. Run `npm run lint`, typecheck, and test Nex happy path for AI changes.



---



## 7. No Duplicate Systems



One auth, one M-Pesa flow, one Nex pipeline (`lib/nex/generateNexResponse.ts`). No parallel chat systems.



---



## 8. Naming Compliance



Follow [Naming Guidelines](../product-governance/naming-guidelines.md). AI tutor = **Nex**. Score = **healthScore**.



---



## 9. Scope Compliance



Do not implement V2 features unless scope lock amended. **Nex Assessment Mode UI = V2** (docs/prompts exist; onboarding diagnostic is V1).



---



## 10. Security Rules



Never expose `SUPABASE_SERVICE_ROLE_KEY`, `GEMINI_API_KEY`, or `OPENAI_API_KEY` to the client.



---



## 11. Pre-Submit Checklist



```

[ ] Product principles + Nex backbone respected

[ ] Nex changes comply with nex-socratic-tutor-engine.md

[ ] Prompt changes match nex-prompting-framework.md

[ ] Route matches api-standards.md

[ ] Table/column matches database-schema.md

[ ] No V2 features introduced

[ ] Nex pipeline not bypassed

[ ] Lint/typecheck passes

```


