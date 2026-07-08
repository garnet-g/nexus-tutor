# Implementation Plan: Kenya Market Readiness & Subscription Expansion

This plan outlines the technical implementation steps to introduce a Term Bundle, Daily/Weekly billing options, manual M-Pesa reconciliation fallbacks, Celcom WhatsApp notifications, and a full Past Papers Repository with AI step-by-step marking.

---

## User Review Required

> [!IMPORTANT]
> **Celcom WhatsApp API Credentials**
> We assume Celcom WhatsApp calls use the same `CELCOM_API_KEY` and `CELCOM_PARTNER_ID` as SMS. We will need to verify if Celcom requires a separate Sender ID (e.g. WhatsApp Business Number) and if we need to declare template namespaces for WhatsApp.
> **Past Paper Storage**
> We will need a new Supabase storage bucket `past-papers-pdf` with RLS policies allowing public/student read access to PDF files.

---

## Proposed Changes

### 1. Database Migrations

#### [NEW] [20260708203000_market_readiness_billing_and_past_papers.sql](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/supabase/migrations/20260708203000_market_readiness_billing_and_past_papers.sql)
Create a new migration file covering:
*   Seeding of new subscription plans:
    *   `premium_daily` (KES 20, billing cycle `daily`)
    *   `premium_weekly` (KES 150, billing cycle `weekly`)
    *   `premium_termly` (KES 1,800, billing cycle `termly`)
*   Creation of `mpesa_manual_verifications` table to track manual Paybill reconciliation attempts.
*   Creation of `celcom_whatsapp_logs` table.
*   Creation of past papers schema:
    *   `past_papers` (curriculum, subject, year, name, pdf_url)
    *   `past_paper_questions` (question number, question text, marks, marking scheme)
    *   `past_paper_attempts` (student_id, past_paper_id, score, status, timing)
    *   `past_paper_answers` (attempt_id, question_id, student_answer, ocr_image_url, score, feedback)

---

### 2. Core Subscription & Limits Logic

#### [MODIFY] [getPlatformSettings.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/lib/platform/getPlatformSettings.ts)
*   Refactor `getNexDailyLimit` and `getPracticeDailyLimit` to return premium limits for any non-free plan code (e.g. using `planCode !== 'free'`).
*   Ensure that all premium billing options (`premium`, `premium_daily`, `premium_weekly`, `premium_termly`) resolve to premium daily limits.

#### [MODIFY] [subscriptionService.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/server/services/subscriptionService.ts)
*   Update `canAccessExamStudyPlan` to check `planCode !== 'free'`.
*   Refactor `resolvePlanAmountKes` to lookup the plan directly from the database `subscription_plans` table to support new plans dynamically instead of hardcoding.

#### [MODIFY] [process_verified_mpesa_payment function](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/supabase/migrations/20260701091000_phase03_payment_security_repair.sql)
*   Replace hardcoded 30-day period interval calculations. Use a CASE statement checking the plan's `billing_cycle`:
    *   `daily` -> `INTERVAL '1 day'`
    *   `weekly` -> `INTERVAL '7 days'`
    *   `termly` -> `INTERVAL '120 days'`
    *   `monthly` (default) -> `INTERVAL '30 days'`
*   Change the payable plan check from `v_plan_code NOT IN ('premium', 'family')` to `v_plan_code <> 'free'` to allow all newly created paid plans.

---

### 3. Payment Fallback & Manual M-Pesa Verification

#### [NEW] [reconcileService.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/server/services/reconcileService.ts)
*   Implement `verifyManualMpesaCode` service that:
    *   Checks if the M-Pesa receipt number has already been used in `mpesa_payments` (deduplication check).
    *   In sandbox mode: auto-approves code. In production: queries Safaricom Daraja Transaction Status API.
    *   Upgrades the student subscription status to `active` based on the selected plan.

#### [NEW] [route.ts (manual verification API)](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/app/api/mpesa/reconcile-manual/route.ts)
*   API endpoint accepting `{ mpesaCode, subscriptionPlanId }` for authenticated students. Calls `verifyManualMpesaCode`.

#### [MODIFY] [PricingCheckout.tsx](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/features/pricing/components/PricingCheckout.tsx)
*   Include pricing calculations dynamically using plans data.
*   Add a helper mapping `planCode` to billing cycles (`/day`, `/week`, `/term`, `/mo`).
*   When a payment fails or is in a pending state, display the **Lipa na M-Pesa manual payment instruction card**.
*   Render a transaction code submission form and link it to the manual reconciliation API.

---

### 4. Celcom WhatsApp Notification Integration

#### [MODIFY] [celcomClient.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/lib/notifications/celcomClient.ts)
*   Implement `sendCelcomWhatsApp` function. Connect to `https://api.celcomafrica.com/whatsapp/send` (or mock equivalent).
*   Add log inserts to `celcom_whatsapp_logs`.

#### [MODIFY] [notificationService.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/server/services/notificationService.ts)
*   Add `sendParentWeeklyWhatsAppReport` service that builds a visually engaging progress message for the parent's linked student and sends it via WhatsApp.

#### [MODIFY] [weekly-reports route.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/app/api/cron/weekly-reports/route.ts)
*   Update the weekly report cron routine to dispatch the summary via both Email (Resend) and WhatsApp (Celcom) for premium linked students.

---

### 5. Past Paper Repository & AI Marking

#### [NEW] [pastPaperService.ts](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/server/services/pastPaperService.ts)
*   Implement database helpers:
    *   `listPastPapers(curriculum, subject, year)`
    *   `startPastPaperAttempt(studentId, pastPaperId)`
    *   `submitPastPaperAttempt(attemptId, answers)`
    *   `markAttemptQuestionWithAI(attemptId, questionId, studentAnswer, imageUrl)`: Uses Gemini Vision/Flash to compare the student's solution or written math worksheet step-by-step with the marking scheme, assigns marks, and flags specific misconceptions.

#### [NEW] [Past Paper Routes](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/app/api/past-papers/)
*   `GET /api/past-papers/route.ts` - lists catalog.
*   `POST /api/past-papers/[id]/start/route.ts` - starts a timed paper attempt.
*   `POST /api/past-papers/attempts/[attemptId]/submit/route.ts` - submits the full exam paper.
*   `POST /api/past-papers/attempts/[attemptId]/mark/route.ts` - submits a question photo for OCR step-by-step grading.

#### [NEW] [Past Papers UI Screens](file:///c:/Users/gar/Desktop/Garnet%20Labs/nexus/src/app/(student)/past-papers/)
*   `/past-papers/page.tsx`: Catalog interface matching standard page grid.
*   `/past-papers/[id]/attempt/page.tsx`:Timed fullscreen simulator supporting text answer submissions and upload selectors for uploading photos of handwritten working.
*   `/past-papers/attempts/[attemptId]/results/page.tsx`: Exam analytics review displaying question lists, marking scheme guidelines, student answers, and AI-marked step-by-step scoring.

---

## Verification Plan

### Automated Tests
We will add unit and integration tests covering the new billing, webhook, and past paper modules:
*   `tests/billing/newIntervals.test.ts`: Asserts database function `process_verified_mpesa_payment` correctly calculates 1, 7, and 120-day period endpoints for daily, weekly, and termly plan codes.
*   `tests/billing/manualReconciliation.test.ts`: Asserts transaction codes verify securely and update subscription states idempotently.
*   `tests/notifications/whatsappClient.test.ts`: Asserts WhatsApp logging and API payloads.
*   `tests/pastPapers/aiMarkingEngine.test.ts`: Asserts Gemini prompt assembly and step-by-step grading score logic on mock marking guidelines.

### Manual Verification
1.  **Checkout Flow Test:** Login as student -> navigate to `/pricing` -> select "Premium Weekly" -> trigger STK Push. Fail the push -> verify the manual reconciliation card shows up -> enter a mock code -> verify subscription unlocks.
2.  **WhatsApp Cron Test:** Run the weekly reports endpoint locally and inspect terminal outputs/mock logs to ensure parent messages format and trigger correctly.
3.  **Past Papers OCR Test:** Navigate to past papers -> select a KCSE math paper -> start simulator -> upload a test photo of handwritten arithmetic work -> submit and verify AI marking and grade feedback displays.
