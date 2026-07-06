# User Flows

**Version:** 1.0

---

## 1. Core Student Journey (MVP)

```
Landing → Signup → Onboarding → Diagnostic → Health Score → Dashboard
    → Learn / Practice / Nex → Progress
```

---

## 2. Student Registration Flow

```mermaid
flowchart TD
    A[Landing Page] --> B{Has account?}
    B -->|No| C[Signup]
    B -->|Yes| D[Login]
    C --> E{Auth method}
    E -->|Email| F[Email + Password]
    E -->|Google| G[Google OAuth]
    F --> H[Create student_profile]
    G --> H
    D --> I{Profile complete?}
    H --> J[Onboarding Form]
    I -->|No| J
    I -->|Yes| K{Diagnostic done?}
    J --> L[Select Curriculum CBC/KCSE]
    L --> M[Grade/Form + School + Target Grade]
    M --> N[Diagnostic Assessment]
    K -->|No| N
    K -->|Yes| O[Dashboard]
    N --> P[Health Score Results]
    P --> O
```

### Onboarding Fields

- Curriculum: CBC | KCSE
- Grade/Form
- School name
- Target grade (e.g., Math → A)

---

## 3. Diagnostic Flow

```mermaid
flowchart TD
    A[Start Diagnostic] --> B[20 Questions]
    B --> C{Answer all?}
    C -->|No| B
    C -->|Yes| D[Submit]
    D --> E[Calculate healthScore]
    E --> F[Show Results Screen]
    F --> G[Strong / Weak Topics]
    G --> H[Redirect to Dashboard]
    H --> I[Award XP + Badge]
```

---

## 4. Daily Learning Flow

```mermaid
flowchart TD
    A[Dashboard] --> B{Today's Goal}
    B --> C[Continue Topic Card]
    C --> D{Activity Type}
    D -->|Learn| E[Lesson Detail]
    D -->|Practice| F[Practice Session]
    D -->|Nex| G[Nex Chat]
    E --> H[Complete Lesson]
    F --> I[10 Questions]
    I --> J[Results + Mastery Update]
    G --> K[Nex Session]
    H --> L[Update Progress + Streak]
    J --> L
    K --> L
    L --> A
```

---

## 5. Nex Chat Flow

```mermaid
flowchart TD
    A[Open Nex] --> B[Select or Auto-detect Mode]
    B --> C{Mode}
    C -->|Explain| D[Student asks concept]
    C -->|Practice| E[Student requests quiz]
    C -->|Homework| F[Student pastes question]
    C -->|Revision| G[Student gives exam date]
    D --> H[Nex teaches + checks understanding]
    E --> I[Nex asks questions one-by-one]
    F --> J[Nex guides Socratically]
    G --> K[Nex generates study plan]
    H --> L[Log nex_messages]
    I --> L
    J --> L
    K --> M[Persist study_plan]
    M --> L
```

### Free Tier Gate

```
Send message → Check daily limit → If exceeded → Upgrade modal
```

---

## 6. Practice Flow

```
Select Topic → Select Difficulty → Start Session (10 Q)
    → Answer each → Submit
    → Score + Weak Areas + Mastery Update
    → Recommendation (Nex or next topic)
```

---

## 7. Subscription / M-Pesa Flow

```mermaid
flowchart TD
    A[Subscription Page] --> B[Select Plan]
    B --> C{Has trial?}
    C -->|Available| D[Start Free Trial]
    C -->|Used| E[Pay with M-Pesa]
    D --> F[Premium Access 7 days]
    E --> G[Enter Phone Number]
    G --> H[STK Push]
    H --> I{Customer Action}
    I -->|PIN OK| J[Callback → paid]
    I -->|Cancel/Fail| K[Show Error]
    J --> L[Activate Subscription]
    L --> M[SMS + Email Receipt]
    F --> N{Trial ends}
    N --> E
```

---

## 8. Parent Flow

```mermaid
flowchart TD
    A[Parent Signup] --> B[Parent Profile]
    B --> C[Enter Student Invite Code]
    C --> D[Link Created]
    D --> E[Parent Dashboard]
    E --> F[View Linked Student]
    F --> G[Study Time / Health Score / Weak Topics]
    G --> H[Weekly Email Report - Premium]
```

---

## 9. Error / Edge Flows

| Scenario | Flow |
|----------|------|
| Session expired | Redirect to `/login` with return URL |
| Diagnostic incomplete | Redirect to `/onboarding/diagnostic` |
| Nex rate limited | Show upgrade CTA, preserve message draft |
| M-Pesa timeout | Poll verify endpoint, show retry |
| Trial expired | Premium features blocked, upgrade prompt |
| No phone on file | SMS skipped, email fallback |

---

## 10. Student utility flows (post-MVP utilities)

| Utility | Route | Purpose |
|---------|-------|---------|
| Exam prep | `/exam-prep` | Generate KCSE-style mock practice materials |
| Mock exams | `/mock-exams` | Build and run generated mock exams |
| Exam simulator | `/exam-simulator` | Timed simulator sessions |
| Study search | `/study-search` | Search lessons and practice content |
| Mistake journal | `/mistakes` | Review missed questions |
| Focus mode | `/focus` | Timed study sessions |
| Weak areas | `/weak-areas` | Target low-mastery topics |
| Assignment help | `/assignment-help` | Nex-guided homework help |

---

## 11. Admin operational flows

| Workflow | Route | Purpose |
|----------|-------|---------|
| Reports export | `/admin/reports` | CSV export with audit trail |
| Communications | `/admin/communications` | Template library + operational send |
| Approvals / bulk actions | `/admin/approvals`, `/admin/bulk-actions` | Four-eyes bulk execution |
| Content review | `/admin/studio/review` | Publish gate for lessons/questions |
| Payments ops | `/admin/payments` | Ledger + operator tools |
| Platform settings | `/admin/platform-settings` | Live pricing/limits (60s cache) |

---

## 12. Acceptance Criteria (Flow-Level)

- [ ] New student completes full journey in <15 minutes
- [ ] Diagnostic blocks dashboard until complete
- [ ] M-Pesa payment activates premium without page refresh (polling)
- [ ] Parent sees linked student data within 1 minute of linking
- [ ] All flows work on 375px mobile viewport
