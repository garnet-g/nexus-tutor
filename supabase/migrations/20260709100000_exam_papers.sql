-- Exam Papers: KCSE Paper 1/2 simulator (generated from parameterized templates).
-- Distinct from and unrelated to past_papers (real uploaded KNEC papers, AI-vision marking).

CREATE TABLE public.exam_paper_templates (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  paper INTEGER NOT NULL CHECK (paper IN (1, 2)),
  section TEXT NOT NULL CHECK (section IN ('I', 'II')),
  form_level INTEGER NOT NULL CHECK (form_level BETWEEN 1 AND 4),
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  marks INTEGER NOT NULL CHECK (marks > 0),
  difficulty TEXT NOT NULL CHECK (difficulty IN ('easy', 'medium', 'hard')),
  review_status TEXT NOT NULL DEFAULT 'draft' CHECK (review_status IN ('draft', 'approved')),
  is_active BOOLEAN NOT NULL DEFAULT true,
  body JSONB NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exam_paper_templates_assembly
  ON public.exam_paper_templates(paper, section, form_level, marks)
  WHERE review_status = 'approved' AND is_active = true;

CREATE TRIGGER trg_exam_paper_templates_updated_at
  BEFORE UPDATE ON public.exam_paper_templates
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

-- No student-facing policy: templates are never read by anon/authenticated roles,
-- only by the service-role admin client (generation + authoring tool).
ALTER TABLE public.exam_paper_templates ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.exam_paper_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  paper INTEGER NOT NULL CHECK (paper IN (1, 2)),
  form_scope INTEGER NOT NULL CHECK (form_scope BETWEEN 1 AND 4),
  status TEXT NOT NULL DEFAULT 'in_progress'
    CHECK (status IN ('in_progress', 'submitted', 'self_marked', 'expired')),
  total_marks INTEGER NOT NULL,
  verified_marks INTEGER,
  self_awarded_marks INTEGER,
  started_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  ends_at TIMESTAMPTZ NOT NULL,
  submitted_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_exam_paper_sessions_student
  ON public.exam_paper_sessions(student_id, created_at DESC);

ALTER TABLE public.exam_paper_sessions ENABLE ROW LEVEL SECURITY;

CREATE POLICY exam_paper_sessions_student ON public.exam_paper_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE TABLE public.exam_paper_session_questions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_id UUID NOT NULL REFERENCES public.exam_paper_sessions(id) ON DELETE CASCADE,
  template_id UUID NOT NULL REFERENCES public.exam_paper_templates(id) ON DELETE RESTRICT,
  question_number INTEGER NOT NULL,
  section TEXT NOT NULL CHECK (section IN ('I', 'II')),
  topic_id UUID NOT NULL REFERENCES public.topics(id) ON DELETE CASCADE,
  params JSONB NOT NULL,
  rendered_stem TEXT NOT NULL,
  rendered_parts JSONB NOT NULL, -- [{label, prompt, marks, answerType}] -- never includes computed answers
  chosen BOOLEAN NOT NULL DEFAULT false, -- Section I rows set true at insert; Section II starts false (5-of-8 choice)
  sort_order INTEGER NOT NULL,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (session_id, question_number)
);

CREATE INDEX idx_exam_paper_session_questions_session
  ON public.exam_paper_session_questions(session_id, sort_order);

ALTER TABLE public.exam_paper_session_questions ENABLE ROW LEVEL SECURITY;

CREATE POLICY exam_paper_session_questions_student ON public.exam_paper_session_questions FOR SELECT
  USING (
    session_id IN (
      SELECT id FROM public.exam_paper_sessions WHERE student_id = public.auth_student_id()
    )
  );
-- Read-only for students. Inserts/updates (generation, Section II choice) go through the
-- service-role admin client only.

-- Computed answers and mark schemes. RLS enabled with ZERO policies: default-deny for
-- anon/authenticated roles. Only the service-role admin client (which bypasses RLS) may
-- read or write this table. This is the enforced boundary for "answers never reach the
-- client mid-exam" -- a database-level guarantee, not just application discipline.
CREATE TABLE public.exam_paper_session_answer_keys (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_question_id UUID NOT NULL UNIQUE
    REFERENCES public.exam_paper_session_questions(id) ON DELETE CASCADE,
  answer_key JSONB NOT NULL, -- [{label, computedAnswer, tolerance, marks}]
  mark_scheme JSONB NOT NULL, -- [{code, text}]
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

ALTER TABLE public.exam_paper_session_answer_keys ENABLE ROW LEVEL SECURITY;

CREATE TABLE public.exam_paper_answers (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  session_question_id UUID NOT NULL
    REFERENCES public.exam_paper_session_questions(id) ON DELETE CASCADE,
  part_label TEXT NOT NULL,
  student_answer TEXT,
  is_correct BOOLEAN,
  auto_marks INTEGER,
  self_awarded_method_marks INTEGER,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (session_question_id, part_label)
);

CREATE INDEX idx_exam_paper_answers_question
  ON public.exam_paper_answers(session_question_id);

CREATE TRIGGER trg_exam_paper_answers_updated_at
  BEFORE UPDATE ON public.exam_paper_answers
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.exam_paper_answers ENABLE ROW LEVEL SECURITY;

CREATE POLICY exam_paper_answers_student ON public.exam_paper_answers FOR ALL
  USING (
    session_question_id IN (
      SELECT sq.id FROM public.exam_paper_session_questions sq
      JOIN public.exam_paper_sessions s ON s.id = sq.session_id
      WHERE s.student_id = public.auth_student_id()
    )
  )
  WITH CHECK (
    session_question_id IN (
      SELECT sq.id FROM public.exam_paper_session_questions sq
      JOIN public.exam_paper_sessions s ON s.id = sq.session_id
      WHERE s.student_id = public.auth_student_id()
    )
  );
