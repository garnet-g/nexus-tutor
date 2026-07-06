# Coding Standards

**Version:** 1.0

---

## 1. Language & Framework

- **TypeScript** strict mode enabled
- **Next.js 16** App Router
- **React 19** patterns (Server Components default)
- **Tailwind CSS** for styling — no CSS modules unless exception approved
- **shadcn/ui** for base components
- **Zod** for runtime validation

---

## 2. Naming

Follow [Naming Guidelines](../product-governance/naming-guidelines.md) entirely. Quick reference:

| Context | Convention |
|---------|------------|
| Variables/functions | camelCase |
| Types/interfaces | PascalCase |
| Constants | UPPER_SNAKE_CASE |
| Database | snake_case / snake_case_plural |
| API routes | kebab-case |
| Components | PascalCase |
| Files (components) | PascalCase.tsx |
| Files (utils) | camelCase.ts |

---

## 3. File Organization

- Feature code in `src/features/{domain}/`
- Shared UI in `src/components/`
- Server business logic in `src/server/services/`
- Types shared across features in `src/types/`
- Zod schemas in `src/schemas/`

---

## 4. TypeScript Rules

```ts
// Prefer explicit return types on exported functions
export async function getStudentProfile(studentId: string): Promise<StudentProfile> {}

// Prefer interfaces for object shapes
interface StudentProfile { ... }

// Avoid any — use unknown + Zod parse
const body = schema.parse(await request.json());

// Use satisfies for constants
const PLANS = { free: 'free', premium: 'premium' } as const;
```

---

## 5. React Patterns

```tsx
// Server Component (default) — data fetching
export default async function DashboardPage() {
  const profile = await getStudentProfile();
  return <StudentDashboard profile={profile} />;
}

// Client Component — interactivity only
'use client';
export function NexChatPanel() { ... }
```

- Minimize `'use client'` scope — push to leaf components
- No data fetching in useEffect when Server Component can fetch
- Props down, callbacks up

---

## 6. API & Server Actions

```ts
// Consistent response
return NextResponse.json({ success: true, data: result });

// Consistent error
return NextResponse.json(
  { success: false, error: { code: 'NOT_FOUND', message: '...' } },
  { status: 404 }
);
```

- Validate all inputs with Zod
- Auth check first line of every protected handler
- Business logic in `server/services/`, not in route handler body

---

## 7. Supabase Patterns

```ts
// Server — user context
const supabase = await createServerClient();
const { data: { user } } = await supabase.auth.getUser();

// Admin — webhooks only
const supabase = createAdminClient();
```

- Prefer RLS over application-level filtering
- Use `.single()` with error handling
- Select only needed columns

---

## 8. Error Handling

```ts
// Domain errors
throw new MpesaPaymentError('MPESA_PAYMENT_FAILED', 'STK push failed');

// Catch at boundary
catch (error) {
  if (error instanceof NexusError) {
    return error.toResponse();
  }
  logger.error('unexpected', error);
  return internalErrorResponse();
}
```

---

## 9. Comments

- Code should be self-explanatory
- Comment only non-obvious business rules
- No commented-out code in commits

---

## 10. Imports

```ts
// Order: external → internal absolute → relative
import { NextResponse } from 'next/server';
import { createServerClient } from '@/lib/supabase/server';
import { NexChatPanel } from '../components/NexChatPanel';
```

Use `@/` path alias for `src/`.

---

## 11. Git Conventions

- Atomic commits with clear messages
- No commits unless user requests
- No force push to main

---

## 12. Dependencies

- Do not add packages without justification
- Prefer existing stack (Supabase, shadcn, Zod)
- Security-check new dependencies before adding
