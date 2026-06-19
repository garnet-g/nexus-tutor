-- Mock exams + exam simulator (V2 Tier 1 Phase 2.3)

CREATE TABLE public.mock_exam_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  curriculum TEXT NOT NULL CHECK (curriculum IN ('CBC', 'KCSE')),
  exam_style TEXT NOT NULL CHECK (
    exam_style IN ('kcse_style', 'cbc_style', 'topic_specific', 'full_math')
  ),
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  question_count INTEGER NOT NULL CHECK (question_count > 0),
  session_status TEXT NOT NULL DEFAULT 'ready'
    CHECK (session_status IN ('ready', 'in_progress', 'completed')),
  is_preview BOOLEAN NOT NULL DEFAULT false,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_mock_exam_sessions_student ON public.mock_exam_sessions(student_id, created_at DESC);

CREATE TABLE public.mock_exam_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mock_exam_session_id UUID NOT NULL REFERENCES public.mock_exam_sessions(id) ON DELETE CASCADE,
  practice_question_id UUID REFERENCES public.practice_questions(id) ON DELETE SET NULL,
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  question_text TEXT NOT NULL,
  question_type TEXT NOT NULL,
  options JSONB,
  correct_answer JSONB NOT NULL,
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  sort_order INTEGER NOT NULL DEFAULT 0,
  explanation TEXT
);

CREATE INDEX idx_mock_exam_questions_session ON public.mock_exam_questions(mock_exam_session_id, sort_order);

CREATE TABLE public.mock_exam_results (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  mock_exam_session_id UUID NOT NULL UNIQUE REFERENCES public.mock_exam_sessions(id) ON DELETE CASCADE,
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  score_percentage NUMERIC(5,2) NOT NULL,
  correct_count INTEGER NOT NULL,
  total_count INTEGER NOT NULL,
  weak_topics JSONB NOT NULL DEFAULT '[]',
  predicted_grade TEXT,
  predicted_grade_delta TEXT,
  answers JSONB NOT NULL DEFAULT '[]',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE TABLE public.exam_simulator_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  mock_exam_session_id UUID NOT NULL REFERENCES public.mock_exam_sessions(id) ON DELETE CASCADE,
  session_status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (session_status IN ('in_progress', 'completed', 'expired')),
  duration_minutes INTEGER NOT NULL DEFAULT 45,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ends_at TIMESTAMPTZ NOT NULL,
  completed_at TIMESTAMPTZ,
  current_question_index INTEGER NOT NULL DEFAULT 0,
  answers JSONB NOT NULL DEFAULT '[]'
);

CREATE INDEX idx_exam_simulator_student ON public.exam_simulator_sessions(student_id, started_at DESC);

ALTER TABLE public.mock_exam_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_exam_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mock_exam_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exam_simulator_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY mock_exam_sessions_student ON public.mock_exam_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY mock_exam_questions_student ON public.mock_exam_questions FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.mock_exam_sessions mes
    WHERE mes.id = mock_exam_session_id AND mes.student_id = public.auth_student_id()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.mock_exam_sessions mes
    WHERE mes.id = mock_exam_session_id AND mes.student_id = public.auth_student_id()
  ));

CREATE POLICY mock_exam_results_student ON public.mock_exam_results FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY exam_simulator_sessions_student ON public.exam_simulator_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());
