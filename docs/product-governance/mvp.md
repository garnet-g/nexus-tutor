NEXUS MVP V1
Goal

Validate:

Will students and parents use an AI-powered study companion for CBC and KCSE?

Not:

Can we build Khan Academy?

Core User Journey

Student signs up.

↓

Selects curriculum.

↓

Completes diagnostic test.

↓

Receives Academic Health Score.

↓

Gets personalized study plan.

↓

Uses Nex AI Tutor.

↓

Completes practice questions.

↓

Tracks progress.

That's the entire MVP.

MVP Modules
Module 1: Authentication
Student Registration

Fields:

Name
Email
Password

or

Google Login
Onboarding

Questions:

Curriculum
CBC
KCSE
Grade/Form
School
Target Grade

Example:

Math → A

Science → B+

Module 2: Diagnostic Assessment

First-time users must complete this.

Mathematics Diagnostic

20 questions

Difficulty:

Easy
Medium
Hard

Topics:

CBC:

Fractions
Algebra
Geometry

KCSE:

Algebra
Trigonometry
Statistics
Output

Academic Health Score

Example:

Overall: 67%

Math: 61%

Strong:
✓ Geometry

Weak:
✗ Algebra
✗ Fractions
Module 3: Dashboard

This becomes home.

Cards

Academic Health Score

Daily Goal

Current Streak

Recommended Topic

Predicted Grade

Example:

Good Morning Garnet

Academic Health Score:
67%

Predicted KCSE Grade:
B-

Today's Goal:
20 Minutes

Continue:
Linear Equations
Module 4: Learn

Content Library

Structure

Mathematics

→ Topic

→ Subtopic

Example

Mathematics

→ Algebra

→ Linear Equations

Each topic contains:

Notes
Examples
Short Quiz

No videos initially.

Module 5: Practice

Question engine.

Student selects:

Topic
Difficulty

System generates:

10 questions.

After completion:

Shows:

Score
Weak areas
Recommendation
Module 6: Nex AI Teacher

The killer feature.

Chat

Student asks:

Explain fractions.

Nex responds.

Homework Help

Student pastes question.

Nex guides.

Practice Mode

Student says:

Quiz me on algebra.

Nex generates questions.

Revision Mode

Student says:

I have exams in 14 days.

Nex creates plan.

Module 7: Progress

Tracks:

Study time
XP
Mastery

Example

Algebra:
72%

Fractions:
43%

Geometry:
81%
Module 8: Streaks & Gamification

Minimal version.

XP

Levels

Badges

Streaks

Badges:

7 Day Streak
Algebra Master
First Diagnostic Complete
Module 9: Parent Dashboard

Extremely lightweight.

Parents see:

Study Time

Current Score

Weak Topics

Recent Activity

Example:

This Week

Study Time:
3h 12m

Weak Area:
Fractions

Predicted Grade:
B
Features Removed From MVP

Do NOT build:

❌ AI Voice

❌ Camera Scanning

❌ Study Groups

❌ School Portals

❌ Teacher Dashboard

❌ University Planner

❌ Career Guidance

❌ Leaderboards

❌ Payments beyond basic subscription

❌ AI Mock Exams

❌ Exam Simulator

These are all V2.

Database Schema
users
id
name
email
curriculum
grade
target_grade
created_at
diagnostic_results
id
user_id
score
health_score
created_at
subjects
id
name
topics
id
subject_id
title
description
lessons
id
topic_id
content
practice_attempts
id
user_id
topic_id
score
completed_at
progress
id
user_id
topic_id
mastery_percentage
ai_conversations
id
user_id
message
response
created_at
streaks
id
user_id
current_streak
longest_streak
Tech Stack
Frontend

Next.js 16.2.9

TypeScript

Tailwind

shadcn/ui

Backend

Supabase

AI

Gemini Flash (primary) + OpenAI (fallback)

Auth

Supabase Auth

Google Login

Hosting

Vercel

Screens Needed
Public
Landing Page
Pricing
About
Login
Signup
Student
Dashboard
Learn
Topic Detail
Practice
Nex AI Chat
Progress
Profile
Parent
Parent Dashboard

Total:

13 screens.