-- Diagnostic, practice, progress, Nex, study plans

CREATE TABLE public.diagnostic_assessments (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  curriculum_id UUID NOT NULL REFERENCES public.curricula(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  question_count INTEGER NOT NULL DEFAULT 20,
  is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE public.diagnostic_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagnostic_assessment_id UUID NOT NULL REFERENCES public.diagnostic_assessments(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  subtopic_id UUID REFERENCES public.subtopics(id) ON DELETE SET NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL CHECK (question_type IN ('multiple_choice', 'numeric', 'short_answer')),
  options JSONB,
  correct_answer JSONB NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE public.diagnostic_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  diagnostic_assessment_id UUID NOT NULL REFERENCES public.diagnostic_assessments(id) ON DELETE CASCADE,
  assessment_status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (assessment_status IN ('in_progress', 'completed', 'abandoned')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE UNIQUE INDEX idx_diagnostic_one_completed
  ON public.diagnostic_attempts (student_id, diagnostic_assessment_id)
  WHERE assessment_status = 'completed';

CREATE TABLE public.diagnostic_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  diagnostic_attempt_id UUID NOT NULL UNIQUE REFERENCES public.diagnostic_attempts(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  diagnostic_score NUMERIC(5,2) NOT NULL,
  health_score NUMERIC(5,2) NOT NULL,
  strong_topics JSONB NOT NULL DEFAULT '[]',
  weak_topics JSONB NOT NULL DEFAULT '[]',
  recommended_topics JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.academic_health_scores (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  health_score NUMERIC(5,2) NOT NULL,
  topic_scores JSONB NOT NULL DEFAULT '{}',
  predicted_grade TEXT,
  calculated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_academic_health_student_calc ON public.academic_health_scores(student_id, calculated_at DESC);

CREATE TABLE public.practice_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  subtopic_id UUID REFERENCES public.subtopics(id) ON DELETE SET NULL,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL,
  options JSONB,
  correct_answer JSONB NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  explanation TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true
);

CREATE TABLE public.practice_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  difficulty TEXT NOT NULL,
  question_count INTEGER NOT NULL DEFAULT 10,
  session_status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (session_status IN ('in_progress', 'completed', 'abandoned')),
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

CREATE INDEX idx_practice_sessions_student ON public.practice_sessions(student_id, started_at DESC);

CREATE TABLE public.practice_attempts (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  practice_session_id UUID NOT NULL REFERENCES public.practice_sessions(id) ON DELETE CASCADE,
  practice_question_id UUID NOT NULL REFERENCES public.practice_questions(id) ON DELETE CASCADE,
  student_answer JSONB,
  is_correct BOOLEAN,
  time_spent_seconds INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.practice_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  practice_session_id UUID NOT NULL UNIQUE REFERENCES public.practice_sessions(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  practice_score NUMERIC(5,2) NOT NULL,
  correct_answers INTEGER NOT NULL DEFAULT 0,
  incorrect_answers INTEGER NOT NULL DEFAULT 0,
  time_spent_seconds INTEGER NOT NULL DEFAULT 0,
  weak_topics JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.student_progress (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subject_id UUID NOT NULL REFERENCES public.subjects(id) ON DELETE CASCADE,
  total_study_time_seconds INTEGER NOT NULL DEFAULT 0,
  lessons_completed INTEGER NOT NULL DEFAULT 0,
  practice_sessions_completed INTEGER NOT NULL DEFAULT 0,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, subject_id)
);

CREATE TABLE public.topic_mastery (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  mastery_percentage NUMERIC(5,2) NOT NULL DEFAULT 0,
  last_practiced_at TIMESTAMPTZ,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, topic_id)
);

CREATE TABLE public.study_time_logs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  activity_type TEXT NOT NULL CHECK (activity_type IN ('lesson', 'practice', 'nex', 'diagnostic')),
  activity_id UUID,
  duration_seconds INTEGER NOT NULL,
  logged_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_study_time_logs_student ON public.study_time_logs(student_id, logged_at DESC);

CREATE TABLE public.student_streaks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL UNIQUE REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  current_streak INTEGER NOT NULL DEFAULT 0,
  longest_streak INTEGER NOT NULL DEFAULT 0,
  last_activity_date DATE,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.student_xp (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL UNIQUE REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  total_xp INTEGER NOT NULL DEFAULT 0,
  current_level INTEGER NOT NULL DEFAULT 1,
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.student_badges (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  badge_code TEXT NOT NULL,
  earned_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, badge_code)
);

CREATE TABLE public.study_plans (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  title TEXT NOT NULL,
  plan_type TEXT NOT NULL CHECK (plan_type IN ('daily', 'exam')),
  exam_countdown_days INTEGER,
  target_completion_date DATE,
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.study_tasks (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  study_plan_id UUID NOT NULL REFERENCES public.study_plans(id) ON DELETE CASCADE,
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  task_title TEXT NOT NULL,
  task_type TEXT NOT NULL CHECK (task_type IN ('lesson', 'practice', 'revision')),
  scheduled_date DATE NOT NULL,
  daily_goal_minutes INTEGER NOT NULL DEFAULT 20,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  completed_at TIMESTAMPTZ
);

CREATE TABLE public.daily_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  goal_date DATE NOT NULL,
  daily_goal_minutes INTEGER NOT NULL DEFAULT 20,
  minutes_completed INTEGER NOT NULL DEFAULT 0,
  is_completed BOOLEAN NOT NULL DEFAULT false,
  UNIQUE (student_id, goal_date)
);

CREATE TABLE public.nex_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  session_mode TEXT NOT NULL CHECK (session_mode IN ('explain', 'practice', 'homework', 'revision', 'assessment')),
  metadata JSONB NOT NULL DEFAULT '{}',
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  is_active BOOLEAN NOT NULL DEFAULT true,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ended_at TIMESTAMPTZ
);

CREATE TABLE public.nex_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  nex_session_id UUID NOT NULL REFERENCES public.nex_sessions(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  role TEXT NOT NULL CHECK (role IN ('student', 'nex')),
  message_content TEXT NOT NULL,
  metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_nex_messages_session ON public.nex_messages(nex_session_id, created_at);

CREATE TABLE public.nex_recommendations (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  recommendation_type TEXT NOT NULL CHECK (recommendation_type IN ('topic', 'practice', 'study_plan')),
  recommendation_payload JSONB NOT NULL DEFAULT '{}',
  is_dismissed BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.nex_daily_usage (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  usage_date DATE NOT NULL DEFAULT (CURRENT_DATE AT TIME ZONE 'Africa/Nairobi')::DATE,
  nex_message_count INTEGER NOT NULL DEFAULT 0,
  practice_session_count INTEGER NOT NULL DEFAULT 0,
  UNIQUE (student_id, usage_date)
);
