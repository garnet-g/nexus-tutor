# Screen Inventory

**Version:** 1.0  
**Total V1 Screens:** 13 (per MVP)

---

## Public Screens (5)

| # | Screen | Route | Auth |
|---|--------|-------|------|
| 1 | Landing Page | `/` | Public |
| 2 | Pricing | `/pricing` | Public |
| 3 | About | `/about` | Public |
| 4 | Login | `/login` | Public |
| 5 | Signup | `/signup` | Public |

---

## Student Screens (7)

| # | Screen | Route | Auth | Gate |
|---|--------|-------|------|------|
| 6 | Onboarding | `/onboarding` | Student | Post-signup |
| 7 | Diagnostic | `/onboarding/diagnostic` | Student | Pre-dashboard |
| 8 | Dashboard | `/dashboard` | Student | Diagnostic complete |
| 9 | Learn | `/learn` | Student | Diagnostic complete |
| 10 | Topic Detail | `/learn/topics/[topicId]` | Student | Diagnostic complete |
| 11 | Lesson Detail | `/learn/lessons/[lessonId]` | Student | Diagnostic complete |
| 12 | Practice | `/practice` | Student | Diagnostic complete |
| 13 | Nex AI Chat | `/nex` | Student | Diagnostic complete |
| 14 | Progress | `/progress` | Student | Diagnostic complete |
| 15 | Profile | `/profile` | Student | Diagnostic complete |
| 16 | Subscription | `/subscription` | Student | Optional gate |

**Note:** Lesson Detail added as sub-route of Topic Detail (implicit in MVP tree).

---

## Super Admin Screens (internal)

| # | Screen | Route | Auth |
|---|--------|-------|------|
| 18 | Platform Settings | `/admin/platform-settings` | super_admin |
| 19 | Subscription Plans | `/admin/subscription-plans` | super_admin |
| 20 | Settings Audit Log | `/admin/platform-settings/audit` | super_admin |

Pricing page (`/pricing`) reads **live** values from `GET /api/subscriptions/plans` — never hardcoded amounts in UI.

---

## Parent Screens (1)

| # | Screen | Route | Auth |
|---|--------|-------|------|
| 17 | Parent Dashboard | `/parent` | Parent |

---

## Component Map

| Screen | Key Components |
|--------|----------------|
| Dashboard | `AcademicHealthScoreCard`, `StudyPlanCard`, streak widget |
| Learn | Topic list, subject header |
| Topic Detail | Subtopic list, lesson cards |
| Lesson Detail | Lesson content renderer, short quiz |
| Practice | `PracticeSessionCard`, question UI, results |
| Nex Chat | `NexChatPanel`, `NexMessageBubble`, mode selector |
| Progress | Mastery bars, XP, badges |
| Parent Dashboard | `ParentWeeklyReportCard`, linked student selector |
| Subscription | `SubscriptionPlanCard`, `MpesaCheckoutModal` (amounts from API) |
| Platform Settings | `PlatformSettingsForm`, `PromotionConfigCard`, `UsageLimitsForm` |

---

## Screens Banned in V1

| Screen | Phase |
|--------|-------|
| Voice Tutor | V2 |
| Camera / Ask Nex | V2 |
| Mock Exam | V2 |
| Exam Simulator | V2 |
| Study Groups | V2 |
| Teacher Dashboard | V2 |
| School Portal | V2 |
| Career Guidance | V2 |
| University Planner | V2 |
| Leaderboards | V2 |

---

## Navigation Structure

```
Public
  / → /pricing, /about, /login, /signup

Student (authenticated)
  /dashboard (home)
  /learn → /learn/topics/[id] → /learn/lessons/[id]
  /practice
  /nex
  /progress
  /profile
  /subscription

Parent (authenticated)
  /parent

Super Admin (internal)
  /admin/platform-settings
  /admin/subscription-plans
  /admin/platform-settings/audit
```
