# Nexus App Naming Guidelines

Version: 1.0
Product: Nexus
AI Teacher: Nex
Market: Kenya-first
Payments: M-Pesa first
SMS Provider: Celcom
Email Provider: Resend

---

# 1. Core Naming Rules

Use consistent naming across the whole app.

## General Rules

* Product name: `Nexus`
* AI tutor name: `Nex`
* Use `student`, not `learner`
* Use `parent`, not `guardian`
* Use `curriculum`, not `syllabus`
* Use `topic`, not `unit`
* Use `lesson`, not `class`
* Use `practice`, not `quiz`, unless it is a formal quiz
* Use `assessment`, not `test`, unless it is an exam-like activity
* Use `healthScore`, not `academicScore`
* Use `mastery`, not `proficiency`
* Use `studyPlan`, not `revisionPlan`, unless exam-focused

---

# 2. Code Case Conventions

## TypeScript / JavaScript

Variables and functions:

```ts
camelCase
```

Examples:

```ts
studentId
curriculumId
healthScore
createStudyPlan()
sendCelcomSms()
sendResendEmail()
initiateMpesaPayment()
```

Constants:

```ts
UPPER_SNAKE_CASE
```

Examples:

```ts
MPESA_PROVIDER
CELCOM_SMS_PROVIDER
RESEND_EMAIL_PROVIDER
DEFAULT_DAILY_STUDY_GOAL_MINUTES
```

Types and interfaces:

```ts
PascalCase
```

Examples:

```ts
StudentProfile
ParentProfile
StudyPlan
DiagnosticAssessment
MpesaPayment
```

Database tables:

```sql
snake_case_plural
```

Examples:

```sql
student_profiles
parent_profiles
study_plans
mpesa_payments
celcom_sms_logs
resend_email_logs
```

API routes:

```txt
kebab-case
```

Examples:

```txt
/api/student-profile
/api/nex-chat
/api/mpesa/initiate-payment
/api/celcom/send-sms
/api/resend/send-email
```

---

# 3. Product Entity Names

## Users

Use these names everywhere:

```ts
student
parent
super_admin
```

Avoid:

```ts
learner
guardian
userType
roleType
admin   // use super_admin for platform control panel
```

Preferred field:

```ts
userRole
```

Allowed values:

```ts
student
parent
super_admin
```

---

# 4. Curriculum Naming

Use:

```ts
curriculum
gradeLevel
subject
topic
subtopic
lesson
```

Examples:

```ts
curriculum: "CBC"
gradeLevel: "Grade 8"
subject: "Mathematics"
topic: "Algebra"
subtopic: "Linear Equations"
```

Database tables:

```sql
curricula
grade_levels
subjects
topics
subtopics
lessons
```

---

# 5. Nex AI Teacher Naming

The AI tutor must always be called:

```ts
Nex
```

In code, use:

```ts
nex
nexChat
nexSession
nexMessage
nexResponse
```

Examples:

```ts
createNexSession()
sendNexMessage()
generateNexResponse()
getNexStudyRecommendation()
```

Database tables:

```sql
nex_sessions
nex_messages
nex_recommendations
```

Avoid:

```ts
chatbot
aiBot
assistant
teacherBot
khanmigo
```

---

# 6. Academic Health Score Naming

Use:

```ts
healthScore
```

Full display name:

```txt
Academic Health Score
```

Database table:

```sql
academic_health_scores
```

Fields:

```ts
healthScore
subjectScore
topicScore
weakTopics
strongTopics
recommendedTopics
```

Avoid:

```ts
academicScore
performanceScore
studentScore
```

---

# 7. Diagnostic Assessment Naming

Use:

```ts
diagnosticAssessment
diagnosticResult
diagnosticQuestion
```

Database tables:

```sql
diagnostic_assessments
diagnostic_questions
diagnostic_attempts
diagnostic_results
```

Fields:

```ts
diagnosticAssessmentId
diagnosticAttemptId
diagnosticScore
diagnosticCompletedAt
```

---

# 8. Study Plan Naming

Use:

```ts
studyPlan
studyTask
dailyGoal
```

Database tables:

```sql
study_plans
study_tasks
daily_goals
```

Fields:

```ts
studyPlanId
studyTaskId
dailyGoalMinutes
targetCompletionDate
isCompleted
```

For exam-specific plans, use:

```ts
examStudyPlan
examCountdownDays
```

---

# 9. Practice Naming

Use:

```ts
practiceSession
practiceQuestion
practiceAttempt
practiceResult
```

Database tables:

```sql
practice_sessions
practice_questions
practice_attempts
practice_results
```

Fields:

```ts
practiceSessionId
practiceScore
correctAnswers
incorrectAnswers
timeSpentSeconds
```

Avoid:

```ts
quizSession
testAttempt
exerciseResult
```

unless the feature is specifically a quiz or formal test.

---

# 10. Progress Naming

Use:

```ts
progress
mastery
studyTime
streak
xp
level
badge
```

Database tables:

```sql
student_progress
topic_mastery
study_time_logs
student_streaks
student_xp
student_badges
```

Fields:

```ts
masteryPercentage
currentStreak
longestStreak
totalXp
currentLevel
```

---

# 11. Parent Dashboard Naming

Use:

```ts
parentDashboard
parentReport
weeklyReport
```

Database tables:

```sql
parent_profiles
student_parent_links
parent_reports
weekly_reports
```

Fields:

```ts
parentId
studentId
weeklyStudyMinutes
weeklyHealthScore
weeklyWeakTopics
```

---

# 12. M-Pesa Naming

Nexus is M-Pesa first.

Use:

```ts
mpesa
mpesaPayment
mpesaCheckout
mpesaStkPush
mpesaCallback
```

Database tables:

```sql
mpesa_payments
mpesa_callbacks
payment_transactions
subscriptions
invoices
```

Fields:

```ts
mpesaPaymentId
checkoutRequestId
merchantRequestId
mpesaReceiptNumber
phoneNumber
amountKes
paymentStatus
paidAt
```

Allowed payment statuses:

```ts
pending
processing
paid
failed
cancelled
expired
refunded
```

Functions:

```ts
initiateMpesaPayment()
handleMpesaCallback()
verifyMpesaPayment()
markMpesaPaymentAsPaid()
expireMpesaPayment()
```

Avoid:

```ts
mobileMoneyPayment
stkPayment
paymentRequest
```

unless wrapped under M-Pesa naming.

---

# 13. Celcom SMS Naming

Use Celcom for SMS.

Use:

```ts
celcom
celcomSms
celcomMessage
```

Database tables:

```sql
celcom_sms_logs
sms_templates
```

Fields:

```ts
celcomMessageId
phoneNumber
smsBody
smsStatus
sentAt
deliveredAt
```

Allowed SMS statuses:

```ts
queued
sent
delivered
failed
```

Functions:

```ts
sendCelcomSms()
sendCelcomOtp()
logCelcomSms()
handleCelcomDeliveryReport()
```

Avoid:

```ts
sendSms()
smsProvider()
twilioSms()
```

Generic SMS logic may exist, but provider-specific implementation must use Celcom naming.

---

# 14. Resend Email Naming

Use Resend for emails.

Use:

```ts
resend
resendEmail
emailTemplate
```

Database tables:

```sql
resend_email_logs
email_templates
```

Fields:

```ts
resendEmailId
recipientEmail
emailSubject
emailBody
emailStatus
sentAt
deliveredAt
openedAt
```

Allowed email statuses:

```ts
queued
sent
delivered
opened
failed
bounced
```

Functions:

```ts
sendResendEmail()
sendWelcomeEmail()
sendParentWeeklyReportEmail()
logResendEmail()
```

Avoid:

```ts
sendEmail()
mailgunEmail()
smtpEmail()
```

unless `sendEmail()` is only a provider-agnostic wrapper that calls `sendResendEmail()` internally.

---

# 15. Subscription Naming

Use:

```ts
subscription
subscriptionPlan
billingCycle
trial
```

Database tables:

```sql
subscription_plans
student_subscriptions
subscription_trials
billing_events
platform_settings
platform_settings_audit_log
super_admin_profiles
```

Fields:

```ts
subscriptionId
subscriptionPlanId
trialStartedAt
trialEndsAt
billingCycle
subscriptionStatus
```

Allowed subscription statuses:

```ts
trialing
active
past_due
cancelled
expired
```

Plans:

```ts
free
premium
family
school
```

---

# 16. Free Trial Naming

Use:

```ts
trial
freeTrial
trialEndsAt
isTrialActive
```

Functions:

```ts
startFreeTrial()
checkTrialStatus()
expireFreeTrial()
convertTrialToSubscription()
```

Avoid:

```ts
demo
sampleAccess
temporaryAccess
```

---

# 17. File and Folder Naming

Recommended structure:

```txt
src/
  app/
  components/
  features/
  lib/
  server/
  types/
  constants/
  schemas/
```

Feature folders:

```txt
features/auth
features/onboarding
features/student-dashboard
features/nex
features/learn
features/practice
features/progress
features/parent-dashboard
features/payments
features/notifications
features/subscriptions
```

Provider folders:

```txt
lib/mpesa
lib/celcom
lib/resend
```

---

# 18. Constants Naming

Use one constants file per domain.

Examples:

```txt
constants/curriculum.constants.ts
constants/payment.constants.ts
constants/subscription.constants.ts   # launch defaults only — runtime uses platform_settings
constants/platform.constants.ts
constants/nex.constants.ts
constants/notification.constants.ts
```

Examples:

```ts
export const DEFAULT_CURRICULUM = "CBC";
export const DEFAULT_COUNTRY_CODE = "+254";
export const DEFAULT_CURRENCY = "KES";
export const MPESA_PROVIDER = "mpesa";
export const SMS_PROVIDER = "celcom";
export const EMAIL_PROVIDER = "resend";
```

---

# 19. Environment Variable Naming

Use uppercase snake case.

```env
NEXT_PUBLIC_APP_NAME=Nexus
NEXT_PUBLIC_AI_TEACHER_NAME=Nex

MPESA_CONSUMER_KEY=
MPESA_CONSUMER_SECRET=
MPESA_SHORTCODE=
MPESA_PASSKEY=
MPESA_CALLBACK_URL=

CELCOM_API_KEY=
CELCOM_SENDER_ID=
CELCOM_CALLBACK_URL=

RESEND_API_KEY=
RESEND_FROM_EMAIL=

GEMINI_API_KEY=
OPENAI_API_KEY=
SUPABASE_URL=
SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
```

Never expose secret keys with `NEXT_PUBLIC_`.

---

# 20. API Route Naming

Use:

```txt
/api/nex/chat
/api/nex/recommendations

/api/mpesa/initiate
/api/mpesa/callback
/api/mpesa/verify

/api/celcom/send
/api/celcom/callback

/api/resend/send

/api/students
/api/parents
/api/study-plans
/api/practice-sessions
/api/progress
```

Avoid random route names like:

```txt
/api/chatbot
/api/pay
/api/sms
/api/mail
/api/results
```

---

# 21. Status Naming

Use consistent status fields.

```ts
status
paymentStatus
subscriptionStatus
smsStatus
emailStatus
assessmentStatus
```

Avoid:

```ts
state
currentState
progressStatus
```

unless already required by an external provider.

---

# 22. Date Field Naming

Use:

```ts
createdAt
updatedAt
deletedAt
completedAt
startedAt
expiresAt
paidAt
sentAt
deliveredAt
```

Avoid:

```ts
dateCreated
created_on
timeCreated
```

---

# 23. Boolean Naming

Use:

```ts
isActive
isCompleted
isTrialActive
isPaid
hasCompletedDiagnostic
hasParentAccess
canUseNex
```

Avoid:

```ts
active
completed
paid
trial
```

---

# 24. ID Naming

Use full entity names.

Good:

```ts
studentId
parentId
topicId
lessonId
practiceSessionId
mpesaPaymentId
subscriptionId
```

Avoid:

```ts
sid
pid
uid
tid
```

Exception:

```ts
userId
```

is allowed because it is standard.

---

# 25. Error Naming

Use:

```ts
NexusError
MpesaPaymentError
CelcomSmsError
ResendEmailError
NexResponseError
DiagnosticAssessmentError
```

Error codes:

```ts
MPESA_PAYMENT_FAILED
CELCOM_SMS_FAILED
RESEND_EMAIL_FAILED
NEX_RESPONSE_FAILED
DIAGNOSTIC_NOT_COMPLETED
SUBSCRIPTION_REQUIRED
TRIAL_EXPIRED
```

---

# 26. UI Component Naming

Use PascalCase.

Examples:

```tsx
StudentDashboardCard
AcademicHealthScoreCard
NexChatPanel
PracticeSessionCard
StudyPlanCard
ParentWeeklyReportCard
MpesaCheckoutModal
SubscriptionPlanCard
```

Avoid:

```tsx
Card1
ChatBox
PaymentModal
DashboardWidget
```

---

# 27. Page Naming

Use route-based names.

Examples:

```tsx
StudentDashboardPage
NexChatPage
PracticePage
ProgressPage
ParentDashboardPage
SubscriptionPage
MpesaCheckoutPage
```

---

# 28. Design Token Naming

Use semantic names.

```ts
nexusPrimary
nexusSecondary
nexusAccent
nexusBackground
nexusSurface
nexusTextPrimary
nexusTextSecondary
nexusSuccess
nexusWarning
nexusDanger
```

Avoid:

```ts
purple1
blue2
redColor
mainColor
```

---

# 29. Coding Agent Rules

Every coding agent must follow these rules:

1. Before creating a new variable, check this naming guide.
2. Before creating a new table, use `snake_case_plural`.
3. Before creating a new API route, use domain-based kebab-case.
4. Never rename `Nex` to chatbot, assistant, or bot.
5. Never rename `healthScore` to academic score.
6. Never use generic payment naming when the flow is M-Pesa-specific.
7. Never use Twilio, Mailgun, or SMTP naming.
8. All SMS provider-specific code must use Celcom naming.
9. All email provider-specific code must use Resend naming.
10. Boolean fields must start with `is`, `has`, or `can`.
11. Status values must be lowercase strings.
12. IDs must be descriptive.
13. Avoid abbreviations unless globally accepted.
14. Do not create duplicate concepts with different names.
15. If unsure, prefer the product language from this document.

---

# 30. Golden Naming Examples

Good:

```ts
const mpesaPayment = await initiateMpesaPayment({
  studentId,
  phoneNumber,
  amountKes,
  subscriptionPlanId,
});
```

Bad:

```ts
const payment = await pay({
  uid,
  phone,
  amount,
  plan,
});
```

Good:

```ts
await sendCelcomSms({
  phoneNumber,
  smsBody,
});
```

Bad:

```ts
await sendMessage({
  number,
  text,
});
```

Good:

```ts
await sendResendEmail({
  recipientEmail,
  emailSubject,
  emailBody,
});
```

Bad:

```ts
await mailUser({
  email,
  subject,
  html,
});
```

Good:

```ts
const nexResponse = await generateNexResponse({
  studentId,
  nexSessionId,
  studentMessage,
});
```

Bad:

```ts
const botReply = await askChatbot(message);
```

---

# 31. Final Rule

The app should feel consistent in code, database, API routes, UI, and product language.

When in doubt, use the names that match the user-facing Nexus product:

* Nexus
* Nex
* Student
* Parent
* Curriculum
* Academic Health Score
* Study Plan
* Practice
* Progress
* M-Pesa
* Celcom
* Resend
