-- Durable student experience tools: saved items, mistakes, goals, focus, and offline packs.

CREATE TABLE public.student_saved_items (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  item_type TEXT NOT NULL DEFAULT 'question' CHECK (item_type IN ('question', 'lesson', 'topic', 'note')),
  item_id UUID,
  title TEXT NOT NULL,
  description TEXT,
  href TEXT NOT NULL,
  metadata JSONB NOT NULL DEFAULT '{}',
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_student_saved_items_student_created
  ON public.student_saved_items(student_id, created_at DESC);
CREATE INDEX idx_student_saved_items_student_type
  ON public.student_saved_items(student_id, item_type);

CREATE TRIGGER trg_student_saved_items_updated_at
  BEFORE UPDATE ON public.student_saved_items
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.student_mistake_journal (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  question_id UUID REFERENCES public.practice_questions(id) ON DELETE SET NULL,
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  question_text TEXT NOT NULL,
  chosen_answer TEXT,
  correct_answer TEXT,
  explanation TEXT,
  source TEXT NOT NULL DEFAULT 'practice' CHECK (source IN ('practice', 'mock_exam', 'manual')),
  status TEXT NOT NULL DEFAULT 'open' CHECK (status IN ('open', 'retried', 'mastered')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_student_mistake_journal_student_status
  ON public.student_mistake_journal(student_id, status, created_at DESC);
CREATE INDEX idx_student_mistake_journal_student_topic
  ON public.student_mistake_journal(student_id, topic_id);

CREATE TRIGGER trg_student_mistake_journal_updated_at
  BEFORE UPDATE ON public.student_mistake_journal
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.student_weekly_goals (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  week_start_date DATE NOT NULL,
  target_minutes INTEGER NOT NULL DEFAULT 120 CHECK (target_minutes BETWEEN 15 AND 3000),
  target_tasks INTEGER NOT NULL DEFAULT 5 CHECK (target_tasks BETWEEN 1 AND 200),
  parent_visible BOOLEAN NOT NULL DEFAULT true,
  note TEXT,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, week_start_date)
);

CREATE INDEX idx_student_weekly_goals_student_week
  ON public.student_weekly_goals(student_id, week_start_date DESC);

CREATE TRIGGER trg_student_weekly_goals_updated_at
  BEFORE UPDATE ON public.student_weekly_goals
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.student_focus_sessions (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  subject TEXT,
  topic_id UUID REFERENCES public.topics(id) ON DELETE SET NULL,
  duration_minutes INTEGER NOT NULL DEFAULT 25 CHECK (duration_minutes BETWEEN 5 AND 240),
  status TEXT NOT NULL DEFAULT 'planned' CHECK (status IN ('planned', 'in_progress', 'completed', 'cancelled')),
  started_at TIMESTAMPTZ,
  completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW()
);

CREATE INDEX idx_student_focus_sessions_student_created
  ON public.student_focus_sessions(student_id, created_at DESC);
CREATE INDEX idx_student_focus_sessions_student_status
  ON public.student_focus_sessions(student_id, status);

CREATE TRIGGER trg_student_focus_sessions_updated_at
  BEFORE UPDATE ON public.student_focus_sessions
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

CREATE TABLE public.student_offline_packs (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  student_id UUID NOT NULL REFERENCES public.student_profiles(id) ON DELETE CASCADE,
  pack_key TEXT NOT NULL,
  title TEXT NOT NULL,
  description TEXT,
  status TEXT NOT NULL DEFAULT 'ready' CHECK (status IN ('ready', 'downloaded', 'expired')),
  size_kb INTEGER NOT NULL DEFAULT 0 CHECK (size_kb >= 0),
  cached_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT NOW(),
  UNIQUE (student_id, pack_key)
);

CREATE INDEX idx_student_offline_packs_student_status
  ON public.student_offline_packs(student_id, status, created_at DESC);

CREATE TRIGGER trg_student_offline_packs_updated_at
  BEFORE UPDATE ON public.student_offline_packs
  FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();

ALTER TABLE public.student_saved_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_mistake_journal ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_weekly_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_focus_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_offline_packs ENABLE ROW LEVEL SECURITY;

CREATE POLICY student_saved_items_student ON public.student_saved_items FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY student_mistake_journal_student ON public.student_mistake_journal FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY student_weekly_goals_student ON public.student_weekly_goals FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY student_focus_sessions_student ON public.student_focus_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY student_offline_packs_student ON public.student_offline_packs FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY student_weekly_goals_parent_linked ON public.student_weekly_goals FOR SELECT
  USING (
    parent_visible = true
    AND EXISTS (
      SELECT 1 FROM public.student_parent_links spl
      WHERE spl.student_id = student_weekly_goals.student_id
        AND spl.parent_id = public.auth_parent_id()
        AND spl.link_status = 'active'
    )
  );
