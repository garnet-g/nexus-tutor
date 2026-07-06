# Screen Inventory

**Version:** 2.0 (production reconciliation)  
**Total screens:** 71 (verified by `npm run test:route-reconciliation`)

Reconciliation command: glob `src/app/**/page.tsx` and compare against this total.

---

## Public screens

| Route | Screen |
|-------|--------|
| `/` | Landing |
| `/pricing` | Pricing |
| `/about` | About |
| `/login` | Login |
| `/signup` | Signup |
| `/waitlist/teacher` | Teacher waitlist |
| `/e2e-force-error` | E2E error-boundary probe (test harness) |

---

## Student screens

| Route | Screen |
|-------|--------|
| `/onboarding` | Onboarding |
| `/diagnostic` | Diagnostic |
| `/dashboard` | Dashboard |
| `/learn` | Learn library |
| `/learn/[topicId]` | Topic detail |
| `/learn/[topicId]/[lessonId]` | Lesson detail |
| `/practice` | Practice |
| `/nex` | Nex chat |
| `/progress` | Progress |
| `/profile` | Profile |
| `/study-plan` | Study plan |
| `/exam-prep` | Exam prep wizard |
| `/mock-exams` | Mock exams |
| `/exam-simulator` | Exam simulator |
| `/readiness` | Readiness |
| `/revision` | Revision |
| `/weak-areas` | Weak areas |
| `/weekly-goal` | Weekly goal |
| `/focus` | Focus mode |
| `/tasks` | Tasks |
| `/library` | Library |
| `/saved` | Saved items |
| `/study-search` | Study search |
| `/mistakes` | Mistake journal |
| `/assignment-help` | Assignment help |
| `/continue` | Continue learning |
| `/offline` | Offline |
| `/nex-memory` | Nex memory |

---

## Parent screens

| Route | Screen |
|-------|--------|
| `/parent` | Parent dashboard |
| `/parent/settings` | Parent settings |

---

## Super-admin screens

| Route | Screen |
|-------|--------|
| `/admin` | Command center |
| `/admin/platform-settings` | Platform settings |
| `/admin/subscription-plans` | Subscription plans |
| `/admin/users` | User directory |
| `/admin/users/[id]` | User 360 |
| `/admin/users/[id]/view` | View-as student |
| `/admin/payments` | Payments ops |
| `/admin/support` | Support cases |
| `/admin/content` | Content admin |
| `/admin/studio` | Content studio |
| `/admin/studio/new` | New lesson |
| `/admin/studio/[lessonId]` | Lesson editor |
| `/admin/studio/review` | Review queue |
| `/admin/reports` | Reports |
| `/admin/communications` | Communications |
| `/admin/experiments` | Experiments |
| `/admin/approvals` | Approvals |
| `/admin/bulk-actions` | Bulk actions |
| `/admin/saved-views` | Saved views |
| `/admin/search` | Admin search |
| `/admin/content-calendar` | Content calendar |
| `/admin/audit-log` | Audit log |
| `/admin/alerts` | Alerts |
| `/admin/roles` | Roles |
| `/admin/rollouts` | Feature rollouts |
| `/admin/beta-invites` | Beta invites |
| `/admin/campaigns` | Campaigns |
| `/admin/health` | System health |
| `/admin/inbox` | Task inbox |
| `/admin/nex-ops` | Nex ops |
| `/admin/ai-quality` | AI quality |
| `/admin/assessment` | Assessment ops |
| `/admin/outcomes` | Outcomes |
| `/admin/revenue-ops` | Revenue ops |
| `/admin/usage-stats` | Usage stats |

---

## Reconciliation

Run:

```bash
npm run test:route-reconciliation
```

The script fails when the filesystem page count diverges from **Total screens** above.
