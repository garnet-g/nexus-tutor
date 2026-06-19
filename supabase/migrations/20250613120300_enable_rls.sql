-- Row Level Security policies

ALTER TABLE public.student_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.super_admin_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_parent_links ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.curricula ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.grade_levels ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subjects ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.topics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subtopics ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.lessons ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.platform_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.platform_settings_audit_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscription_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnostic_assessments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnostic_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnostic_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.diagnostic_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.academic_health_scores ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_questions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_attempts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.practice_results ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.topic_mastery ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_time_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_streaks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_xp ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_plans ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.study_tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_goals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nex_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nex_messages ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nex_recommendations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.nex_daily_usage ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.student_subscriptions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.subscription_trials ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mpesa_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.mpesa_callbacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.payment_transactions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.billing_events ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.invoices ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.sms_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.celcom_sms_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.email_templates ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.resend_email_logs ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.parent_reports ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.weekly_reports ENABLE ROW LEVEL SECURITY;

-- Student profiles
CREATE POLICY student_profiles_select_own ON public.student_profiles FOR SELECT
  USING (user_id = auth.uid());
CREATE POLICY student_profiles_insert_own ON public.student_profiles FOR INSERT
  WITH CHECK (user_id = auth.uid());
CREATE POLICY student_profiles_update_own ON public.student_profiles FOR UPDATE
  USING (user_id = auth.uid());

-- Parent profiles
CREATE POLICY parent_profiles_select_own ON public.parent_profiles FOR SELECT
  USING (user_id = auth.uid());
CREATE POLICY parent_profiles_insert_own ON public.parent_profiles FOR INSERT
  WITH CHECK (user_id = auth.uid());
CREATE POLICY parent_profiles_update_own ON public.parent_profiles FOR UPDATE
  USING (user_id = auth.uid());

-- Super admin profiles
CREATE POLICY super_admin_profiles_select_own ON public.super_admin_profiles FOR SELECT
  USING (user_id = auth.uid() AND public.is_super_admin());

-- Curriculum read-only for authenticated
CREATE POLICY curricula_read ON public.curricula FOR SELECT TO authenticated USING (true);
CREATE POLICY grade_levels_read ON public.grade_levels FOR SELECT TO authenticated USING (true);
CREATE POLICY subjects_read ON public.subjects FOR SELECT TO authenticated USING (true);
CREATE POLICY topics_read ON public.topics FOR SELECT TO authenticated USING (true);
CREATE POLICY subtopics_read ON public.subtopics FOR SELECT TO authenticated USING (true);
CREATE POLICY lessons_read ON public.lessons FOR SELECT TO authenticated USING (true);
CREATE POLICY diagnostic_assessments_read ON public.diagnostic_assessments FOR SELECT TO authenticated USING (true);
CREATE POLICY diagnostic_questions_read ON public.diagnostic_questions FOR SELECT TO authenticated USING (true);
CREATE POLICY practice_questions_read ON public.practice_questions FOR SELECT TO authenticated USING (true);
CREATE POLICY subscription_plans_read ON public.subscription_plans FOR SELECT TO authenticated USING (is_active = true);

-- Platform settings: no direct student/parent access (server uses service role)
CREATE POLICY platform_settings_no_public ON public.platform_settings FOR SELECT TO authenticated USING (false);

-- Student-owned learning data
CREATE POLICY diagnostic_attempts_student ON public.diagnostic_attempts FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY diagnostic_results_student ON public.diagnostic_results FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY academic_health_student ON public.academic_health_scores FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY practice_sessions_student ON public.practice_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY practice_attempts_student ON public.practice_attempts FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.practice_sessions ps
    WHERE ps.id = practice_session_id AND ps.student_id = public.auth_student_id()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.practice_sessions ps
    WHERE ps.id = practice_session_id AND ps.student_id = public.auth_student_id()
  ));

CREATE POLICY practice_results_student ON public.practice_results FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY student_progress_student ON public.student_progress FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY topic_mastery_student ON public.topic_mastery FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY study_time_logs_student ON public.study_time_logs FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY student_streaks_student ON public.student_streaks FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY student_xp_student ON public.student_xp FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY student_badges_student ON public.student_badges FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY study_plans_student ON public.study_plans FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY study_tasks_student ON public.study_tasks FOR ALL
  USING (EXISTS (
    SELECT 1 FROM public.study_plans sp
    WHERE sp.id = study_plan_id AND sp.student_id = public.auth_student_id()
  ))
  WITH CHECK (EXISTS (
    SELECT 1 FROM public.study_plans sp
    WHERE sp.id = study_plan_id AND sp.student_id = public.auth_student_id()
  ));

CREATE POLICY daily_goals_student ON public.daily_goals FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY nex_sessions_student ON public.nex_sessions FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY nex_messages_student ON public.nex_messages FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY nex_recommendations_student ON public.nex_recommendations FOR ALL
  USING (student_id = public.auth_student_id())
  WITH CHECK (student_id = public.auth_student_id());

CREATE POLICY nex_daily_usage_student ON public.nex_daily_usage FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY student_subscriptions_student ON public.student_subscriptions FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY subscription_trials_student ON public.subscription_trials FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY mpesa_payments_student ON public.mpesa_payments FOR SELECT
  USING (student_id = public.auth_student_id());

CREATE POLICY invoices_student ON public.invoices FOR SELECT
  USING (student_id = public.auth_student_id());

-- Parent read linked student data
CREATE POLICY student_parent_links_parent ON public.student_parent_links FOR SELECT
  USING (parent_id = public.auth_parent_id());

CREATE POLICY student_profiles_parent_linked ON public.student_profiles FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.student_parent_links spl
    WHERE spl.student_id = student_profiles.id
      AND spl.parent_id = public.auth_parent_id()
      AND spl.link_status = 'active'
  ));

CREATE POLICY academic_health_parent ON public.academic_health_scores FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.student_parent_links spl
    WHERE spl.student_id = academic_health_scores.student_id
      AND spl.parent_id = public.auth_parent_id()
      AND spl.link_status = 'active'
  ));

CREATE POLICY topic_mastery_parent ON public.topic_mastery FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.student_parent_links spl
    WHERE spl.student_id = topic_mastery.student_id
      AND spl.parent_id = public.auth_parent_id()
      AND spl.link_status = 'active'
  ));

CREATE POLICY parent_reports_parent ON public.parent_reports FOR SELECT
  USING (parent_id = public.auth_parent_id());

CREATE POLICY weekly_reports_parent ON public.weekly_reports FOR SELECT
  USING (EXISTS (
    SELECT 1 FROM public.parent_reports pr
    WHERE pr.id = weekly_reports.parent_report_id
      AND pr.parent_id = public.auth_parent_id()
  ));

-- Parents cannot mutate student data (no INSERT/UPDATE on student tables for parents)
