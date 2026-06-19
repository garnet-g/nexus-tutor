-- Student learning preferences (Track C: account customization)

ALTER TABLE public.student_profiles
  ADD COLUMN IF NOT EXISTS learning_preferences JSONB NOT NULL DEFAULT jsonb_build_object(
    'explanationDepth', 'standard',
    'sessionGoalMinutes', 20,
    'reminderChannel', 'off'
  );

COMMENT ON COLUMN public.student_profiles.learning_preferences IS
  'Student learning customization: explanationDepth, sessionGoalMinutes, reminderChannel, learningTone';

ALTER TABLE public.student_profiles
  ADD CONSTRAINT student_profiles_learning_preferences_shape
  CHECK (
    learning_preferences ? 'explanationDepth'
    AND learning_preferences ? 'sessionGoalMinutes'
    AND learning_preferences ? 'reminderChannel'
    AND (learning_preferences ->> 'explanationDepth') IN ('quick', 'standard', 'detailed')
    AND (learning_preferences ->> 'reminderChannel') IN ('sms', 'email', 'off')
    AND jsonb_typeof(learning_preferences -> 'sessionGoalMinutes') = 'number'
    AND ((learning_preferences ->> 'sessionGoalMinutes')::int BETWEEN 5 AND 120)
    AND (
      NOT (learning_preferences ? 'learningTone')
      OR (learning_preferences ->> 'learningTone') IN ('friendly', 'focused', 'encouraging')
    )
  );
