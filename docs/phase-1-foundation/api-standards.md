# API Standards & Contract

**Version:** 1.0  
**Base URL:** `https://nexus.app/api` (production) · `http://localhost:3000/api` (dev)

---

## 1. Global Conventions

### 1.1 Request Headers

```
Content-Type: application/json
Authorization: Bearer <supabase_access_token>   # Authenticated routes
X-Request-Id: <uuid>                            # Optional, for tracing
```

Webhook routes use provider-specific validation — no Bearer token.

### 1.2 Response Envelope

**Success:**
```json
{
  "success": true,
  "data": { }
}
```

**Error:**
```json
{
  "success": false,
  "error": {
    "code": "SUBSCRIPTION_REQUIRED",
    "message": "Premium subscription required for this feature.",
    "details": {}
  }
}
```

### 1.3 Error Codes

| Code | HTTP | Description |
|------|------|-------------|
| `VALIDATION_ERROR` | 400 | Invalid request body or params |
| `UNAUTHORIZED` | 401 | Missing or invalid session |
| `FORBIDDEN` | 403 | Valid session, insufficient permission |
| `NOT_FOUND` | 404 | Resource not found |
| `CONFLICT` | 409 | Duplicate or invalid state transition |
| `RATE_LIMITED` | 429 | Free tier Nex limit exceeded |
| `DIAGNOSTIC_NOT_COMPLETED` | 403 | Onboarding gate |
| `SUBSCRIPTION_REQUIRED` | 403 | Premium feature on free plan |
| `TRIAL_EXPIRED` | 403 | Trial ended |
| `MPESA_PAYMENT_FAILED` | 402 | STK push or payment failed |
| `MPESA_CALLBACK_INVALID` | 400 | Invalid callback payload |
| `CELCOM_SMS_FAILED` | 502 | SMS send failed |
| `RESEND_EMAIL_FAILED` | 502 | Email send failed |
| `NEX_RESPONSE_FAILED` | 502 | AI generation failed |
| `INTERNAL_ERROR` | 500 | Unexpected server error |

---

## 2. Auth Routes

Handled primarily by Supabase Auth client SDK. No custom REST wrappers unless needed.

| Action | Method | Client |
|--------|--------|--------|
| Sign up (email) | — | Supabase `signUp` |
| Sign in (email) | — | Supabase `signInWithPassword` |
| Google OAuth | — | Supabase `signInWithOAuth` |
| Sign out | — | Supabase `signOut` |
| Session refresh | — | `@supabase/ssr` middleware |

### POST `/api/auth/complete-profile`

**Auth:** Required (new user)  
**Purpose:** Create `student_profiles` or `parent_profiles` after auth signup

**Request:**
```json
{
  "userRole": "student",
  "fullName": "Garnet Mwangi",
  "curriculum": "KCSE",
  "gradeLevel": "Form 3",
  "schoolName": "Alliance High School",
  "targetGrade": "A"
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "studentId": "uuid",
    "hasCompletedDiagnostic": false
  }
}
```

---

## 3. Student Routes

### GET `/api/students/me`

**Auth:** Student  
**Response `200`:**
```json
{
  "success": true,
  "data": {
    "studentId": "uuid",
    "fullName": "Garnet Mwangi",
    "curriculum": "KCSE",
    "gradeLevel": "Form 3",
    "targetGrade": "A",
    "hasCompletedDiagnostic": true,
    "subscriptionStatus": "trialing",
    "canUseNex": true
  }
}
```

### PATCH `/api/students/me`

**Auth:** Student  
**Request:** Partial profile fields (`targetGrade`, `schoolName`, `gradeLevel`)

---

## 4. Parent Routes

### GET `/api/parents/me`

**Auth:** Parent

### GET `/api/parents/linked-students`

**Auth:** Parent  
**Response:** Array of linked students with summary stats

### POST `/api/parents/link-student`

**Auth:** Parent  
**Request:**
```json
{
  "inviteCode": "NEXUS-XXXX"
}
```

---

## 5. Diagnostic Assessment Routes

### GET `/api/diagnostic-assessments/current`

**Auth:** Student  
**Query:** `curriculum=KCSE`  
**Response:** Assessment metadata + question count (not answers)

### POST `/api/diagnostic-assessments/start`

**Auth:** Student  
**Response `201`:**
```json
{
  "success": true,
  "data": {
    "diagnosticAttemptId": "uuid",
    "assessmentStatus": "in_progress",
    "questions": [
      {
        "diagnosticQuestionId": "uuid",
        "questionText": "...",
        "questionType": "multiple_choice",
        "options": ["A", "B", "C", "D"],
        "difficulty": "medium"
      }
    ]
  }
}
```

**Error `409`:** Already completed (`CONFLICT`)

### POST `/api/diagnostic-assessments/submit`

**Auth:** Student  
**Request:**
```json
{
  "diagnosticAttemptId": "uuid",
  "answers": [
    {
      "diagnosticQuestionId": "uuid",
      "studentAnswer": "B"
    }
  ]
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "diagnosticScore": 67,
    "healthScore": 67,
    "strongTopics": ["Geometry"],
    "weakTopics": ["Algebra", "Fractions"],
    "recommendedTopics": ["Linear Equations"],
    "predictedGrade": "B-"
  }
}
```

---

## 6. Learn Routes

### GET `/api/learn/subjects`

**Auth:** Student  
**Query:** `curriculum=KCSE`  
**Response:** Mathematics subject with topic tree

### GET `/api/learn/topics/:topicId`

**Auth:** Student  
**Response:** Topic detail, subtopics, lesson list

### GET `/api/learn/lessons/:lessonId`

**Auth:** Student  
**Response:** Lesson content (notes, examples)

### POST `/api/learn/lessons/:lessonId/complete`

**Auth:** Student  
**Response:** Updated progress, XP earned

---

## 7. Practice Routes

### POST `/api/practice-sessions/start`

**Auth:** Student  
**Request:**
```json
{
  "topicId": "uuid",
  "difficulty": "medium",
  "questionCount": 10
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "practiceSessionId": "uuid",
    "questions": [ ]
  }
}
```

### POST `/api/practice-sessions/submit`

**Auth:** Student  
**Request:**
```json
{
  "practiceSessionId": "uuid",
  "answers": [
    {
      "practiceQuestionId": "uuid",
      "studentAnswer": "42",
      "timeSpentSeconds": 45
    }
  ]
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "practiceScore": 70,
    "correctAnswers": 7,
    "incorrectAnswers": 3,
    "weakTopics": ["Fractions"],
    "masteryUpdates": [
      { "topicId": "uuid", "masteryPercentage": 72 }
    ]
  }
}
```

---

## 8. Progress Routes

### GET `/api/progress/summary`

**Auth:** Student  
**Response:**
```json
{
  "success": true,
  "data": {
    "healthScore": 67,
    "predictedGrade": "B-",
    "topicMastery": [
      { "topicId": "uuid", "title": "Algebra", "masteryPercentage": 72 }
    ],
    "currentStreak": 5,
    "totalXp": 340,
    "currentLevel": 3,
    "badges": ["seven_day_streak"]
  }
}
```

### GET `/api/progress/study-time`

**Auth:** Student  
**Query:** `period=week`

---

## 9. Study Plan Routes

### GET `/api/study-plans/active`

**Auth:** Student

### POST `/api/study-plans/generate`

**Auth:** Student · **Requires:** Premium or trial  
**Request:**
```json
{
  "planType": "exam",
  "examCountdownDays": 14,
  "dailyGoalMinutes": 20
}
```

### PATCH `/api/study-plans/tasks/:taskId/complete`

**Auth:** Student

---

## 10. Nex AI Routes

### POST `/api/nex/sessions`

**Auth:** Student · **Requires:** `canUseNex`  
**Request:**
```json
{
  "sessionMode": "explain",
  "topicId": "uuid"
}
```

**Response `201`:**
```json
{
  "success": true,
  "data": {
    "nexSessionId": "uuid",
    "sessionMode": "explain"
  }
}
```

### POST `/api/nex/chat`

**Auth:** Student · **Requires:** `canUseNex`  
**Request:**
```json
{
  "nexSessionId": "uuid",
  "studentMessage": "Explain fractions."
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "nexMessageId": "uuid",
    "nexResponse": "Fractions represent parts of a whole...",
    "sessionMode": "explain"
  }
}
```

**Error `429`:** `RATE_LIMITED` — free tier daily limit

### GET `/api/nex/recommendations`

**Auth:** Student  
**Response:** Active recommendations for dashboard

---

## 11. Subscription Routes

### GET `/api/subscriptions/plans`

**Auth:** Optional (public pricing page may use unauthenticated)

### GET `/api/subscriptions/current`

**Auth:** Student  
**Response:**
```json
{
  "success": true,
  "data": {
    "subscriptionPlanId": "uuid",
    "planCode": "premium",
    "subscriptionStatus": "active",
    "isTrialActive": false,
    "trialEndsAt": null,
    "currentPeriodEnd": "2025-07-13T00:00:00Z"
  }
}
```

### POST `/api/subscriptions/start-trial`

**Auth:** Student  
**Response:** Trial dates (one trial per student)

---

## 12. M-Pesa Routes

### POST `/api/mpesa/initiate`

**Auth:** Student or Parent  
**Request:**
```json
{
  "subscriptionPlanId": "uuid",
  "phoneNumber": "+254712345678",
  "studentId": "uuid"
}
```

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "mpesaPaymentId": "uuid",
    "checkoutRequestId": "ws_CO_...",
    "paymentStatus": "pending",
    "amountKes": 799,
    "expiresAt": "2025-06-13T12:05:00Z"
  }
}
```

**Error `402`:** `MPESA_PAYMENT_FAILED`

### POST `/api/mpesa/callback`

**Auth:** Webhook (Daraja) — **no session**  
**Request:** Daraja STK callback JSON (raw)  
**Response:** `{ "ResultCode": 0, "ResultDesc": "Accepted" }` per Safaricom spec

**Behavior:**
1. Log raw payload to `mpesa_callbacks`
2. Idempotent process by `checkoutRequestId`
3. Update `mpesa_payments.payment_status`
4. Activate subscription on `paid`

### GET `/api/mpesa/verify`

**Auth:** Student  
**Query:** `mpesaPaymentId=uuid`  
**Response:** Current payment status (polling fallback)

---

## 13. Notification Routes (Internal / Admin)

These are **server-triggered**, not typically called from client UI.

### POST `/api/celcom/send`

**Auth:** Server/internal only  
**Request:**
```json
{
  "phoneNumber": "+254712345678",
  "templateCode": "payment_success",
  "templateVariables": {
    "studentName": "Garnet",
    "amountKes": "799"
  }
}
```

### POST `/api/celcom/callback`

**Auth:** Celcom delivery webhook

### POST `/api/resend/send`

**Auth:** Server/internal only  
**Request:**
```json
{
  "recipientEmail": "parent@example.com",
  "templateCode": "parent_weekly_report",
  "templateVariables": { }
}
```

---

## 14. Parent Dashboard Routes

### GET `/api/parents/dashboard/:studentId`

**Auth:** Parent (linked)  
**Response:**
```json
{
  "success": true,
  "data": {
    "weeklyStudyMinutes": 192,
    "healthScore": 67,
    "weeklyWeakTopics": ["Fractions"],
    "predictedGrade": "B",
    "recentActivity": [ ]
  }
}
```

### GET `/api/parents/reports/weekly`

**Auth:** Parent  
**Query:** `studentId=uuid`

---

## 15. Rate Limits (V1)

Freemium model: free forever with daily caps; Premium (799) and Family (2499, 4 seats) raise limits.

| Route | Free (daily) | Premium / Family (daily) |
|-------|--------------|--------------------------|
| `POST /api/nex/chat` | 10 | 75 |
| `POST /api/practice-sessions/start` | 3 | 20 |
| `POST /api/mpesa/initiate` | 5/hour | 5/hour |

Enforced server-side; return `429 RATE_LIMITED` with `retryAfterSeconds` (resets midnight Africa/Nairobi).

---

## 16. Validation

All POST/PATCH bodies validated with Zod schemas in `src/schemas/`.  
Schemas mirror database column names in camelCase at API boundary.

---

## 17. Versioning

**V1:** No URL versioning (`/api/v1/`). Breaking changes require migration plan before V2 API prefix.

---

## 18. Routes Explicitly Banned in V1

Do not implement these until the matching V2 phase unlocks:

```
/api/nex/voice
/api/mock-exams/*
/api/exam-simulator/*
/api/study-groups/*
/api/schools/*
/api/teachers/*
/api/career/*
/api/university/*
/api/leaderboards/*
```

### V2 Phase 2.2 — Camera (implemented)

`POST /api/nex/camera` — authenticated multipart image upload (max 5MB, jpeg/png/webp). Premium/trial gating. Vision extraction feeds `generateNexResponse` for Homework and Explain modes only. Storage bucket `nex-uploads` with student-scoped RLS.

### V2 Phase 2.5 — Voice (implemented)

`POST /api/nex/voice` — authenticated multipart audio upload (max 2MB, max 30s, webm/opus preferred). Premium/family gating. Server-side STT → `generateNexResponse` → TTS. Returns `audioBase64` plus text logged in `nex_messages` with `metadata.inputType: "voice"`. Counts against daily Nex limits.

---

## 19. Admin Routes (`super_admin`)

**Auth:** `app_metadata.userRole === 'super_admin'` on all routes below.

### GET `/api/admin/platform-settings`

**Response `200`:**
```json
{
  "success": true,
  "data": {
    "limits": {
      "freeDailyNexMessageLimit": 10,
      "freeDailyPracticeSessionLimit": 3,
      "premiumDailyNexMessageLimit": 75,
      "premiumDailyPracticeSessionLimit": 20,
      "familyMaxStudents": 4
    },
    "promotion": {
      "promotionIsActive": false,
      "promotionTitle": null,
      "promotionEndsAt": null,
      "promotionPremiumAmountKes": null
    }
  }
}
```

### PATCH `/api/admin/platform-settings`

**Request:**
```json
{
  "freeDailyNexMessageLimit": 15,
  "premiumDailyNexMessageLimit": 100,
  "promotionIsActive": true,
  "promotionTitle": "Exam Season — Premium KES 699",
  "promotionPremiumAmountKes": 699,
  "promotionEndsAt": "2026-08-31T23:59:59Z",
  "changeReason": "August exam promo"
}
```

**Response `200`:** Updated settings + cache purge triggered.

**Validation:** Limits 1–500; prices 1–100000 KES.

### GET `/api/admin/subscription-plans`

**Response:** All plans with current `amount_kes`, `is_active`, `promotion_label`.

### PATCH `/api/admin/subscription-plans/:planCode`

**Request:**
```json
{
  "amountKes": 799,
  "isActive": true,
  "promotionLabel": null,
  "changeReason": "Revert to standard pricing"
}
```

**Allowed `planCode`:** `premium`, `family` (not `free` amount).

### GET `/api/admin/platform-settings/audit-log`

**Query:** `limit=50`, `offset=0`

**Response:** Append-only audit entries.

### GET `/api/subscriptions/plans` (public)

Returns **effective** pricing (includes active promotion override). Used by pricing page and checkout — not hardcoded constants.
