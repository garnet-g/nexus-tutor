# How to Use the Student Pages

This guide explains what each student-facing page is meant to do so developers can extend the experience without changing the product intent.

## Core Flow

### `/dashboard` - Dashboard
The student's first landing page after login. It should summarize today's best next action, academic health, daily goal progress, streak, weak areas, saved work, mistakes to review, focus time, offline packs, and quick links into the rest of the student experience.

### `/diagnostic` - Diagnostic
The entry assessment for new students. It should establish the student's starting academic health, weak topics, and initial personalization data before they access the full study experience.

### `/onboarding` - Onboarding
The profile setup and first-run flow. It should collect or confirm details like curriculum, grade, school context, and learning preferences before routing the student into diagnostic or dashboard.

## Learning

### `/learn` - Learn
The main lesson browser. It should show curriculum-ready subjects, topics, lesson availability, and mastery context so students can choose what to study.

### `/learn/[topicId]` - Topic
The topic detail page. It should show lessons inside a topic, progress within that topic, and clear links into lesson reading or practice.

### `/learn/[topicId]/[lessonId]` - Lesson
The lesson reading page. It should display the lesson content, mark viewing/completion progress, award activity where appropriate, and lead naturally into practice.

### `/continue` - Continue Learning
A resume page for recent study activity. It should surface the best next lesson, recent lessons, recent practice sessions, and the next useful study step.

### `/library` - Concept Library
A quick reference page for formulas, definitions, and core ideas. It should help students refresh concepts without starting a full lesson flow.

### `/study-search` - Study Search
A student-friendly search and shortcut page. It should help students find lessons, topics, saved items, weak areas, and common study actions.

## Practice and Revision

### `/practice` - Practice
The main practice launcher and question flow. It should let students choose topics, difficulty, and sessions, then submit answers and update mastery.

### `/revision` - Revision
A review-focused page for returning to prior material. It should help students revise known topics, recent work, and areas that need reinforcement.

### `/weak-areas` - Weak Areas
A focused queue of low-mastery topics. It should sort weak topics by need and route students into practice or learning for each one.

### `/mistakes` - Mistake Journal
A review log for missed or confusing questions. It should let students revisit mistakes, read explanations, and mark items as retried or mastered.

### `/saved` - Saved Questions
A place for bookmarked questions, lessons, topics, and notes. It should support saving study items and returning to them later.

### `/tasks` - Tasks
The student's daily study task list. It should show today's study plan tasks, completion state, duration, topic context, and links into the right practice flow.

## Exams

### `/mock-exams` - Mock Exams
The mock exam generation and review area. It should help students create mock exams, complete them, and review results.

### `/readiness` - Exam Readiness
A practical exam status page. It should summarize mock results, predicted grade, academic health, and score-moving weak topics.

### `/exam-prep` - Exam Prep
A guided exam preparation page. It should help students build an exam-focused study path from their current performance and target timeline.

### `/exam-simulator` - Exam Simulator
The timed exam environment. It should run mock questions under time limits and save completed results for readiness and progress tracking.

## Nex and Personalization

### `/nex` - Ask Nex
The student AI tutor page. It should support asking questions, getting explanations, and moving between help and practice without losing context.

### `/nex-memory` - Learning Memory
A transparent view of the personalization data Nexus uses. It should show the student's profile, current focus, learning preferences, and relevant stored context in human-readable form.

### `/assignment-help` - Assignment Help
A support page for homework or assignment questions. It should help students get guided explanations without replacing their own work.

## Goals, Focus, and Progress

### `/study-plan` - Study Plan
The study plan management page. It should create and display daily or exam-focused plans, daily goals, and generated study tasks.

### `/weekly-goal` - Weekly Goal
A weekly target page. It should let students set target study minutes, task count, parent visibility, and notes for the current week.

### `/focus` - Focus Sessions
A timed study block page. It should let students start focus sessions, record completion, and contribute to study minutes.

### `/progress` - Progress
The long-term progress page. It should show academic health history, mastery, streaks, XP, badges, and weekly summaries.

### `/offline` - Offline Packs
A low-data preparation page. It should let students prepare lightweight packs for upcoming study when internet access may be unreliable.

## Account

### `/profile` - Profile
The student account and learning profile page. It should let students review or update personal, school, curriculum, and preference details.

### `/pricing` - Plans
The plan and upgrade page. It should explain what the current plan includes and route students or families toward premium access when needed.
