import type { LearningPreferences } from "@/schemas/profileSchemas";

export type UserRole = "student" | "parent" | "super_admin" | "support";

export type Curriculum = "CBC" | "KCSE";

export interface StudentProfile {
  id: string;
  user_id: string;
  full_name: string;
  email: string | null;
  phone_number: string | null;
  curriculum: Curriculum;
  grade_level: string;
  school_name: string | null;
  target_grade: string | null;
  has_completed_diagnostic: boolean;
  metadata: Record<string, unknown>;
  learning_preferences: LearningPreferences | Record<string, unknown>;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface ParentProfile {
  id: string;
  user_id: string;
  full_name: string;
  email: string | null;
  phone_number: string | null;
  is_active: boolean;
  created_at: string;
  updated_at: string;
}

export interface SubscriptionPlan {
  id: string;
  plan_code: string;
  name: string;
  amount_kes: number;
  billing_cycle: string;
  is_active: boolean;
  promotion_label: string | null;
  updated_at: string;
  updated_by_user_id: string | null;
}

export interface PlatformSettingRow {
  id: string;
  setting_key: string;
  setting_value: unknown;
  updated_at: string;
  updated_by_user_id: string | null;
}

export interface SessionUser {
  id: string;
  email: string | null;
  role: UserRole;
  studentProfile: StudentProfile | null;
  parentProfile: ParentProfile | null;
}
