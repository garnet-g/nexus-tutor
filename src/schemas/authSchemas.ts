import { z } from "zod";

export const userRoleSchema = z.enum(["student", "parent"]);

export const signupSchema = z.object({
  email: z.string().email("Enter a valid email address"),
  password: z
    .string()
    .min(8, "Password must be at least 8 characters"),
  fullName: z
    .string()
    .min(2, "Full name must be at least 2 characters")
    .max(120, "Full name is too long"),
  role: userRoleSchema,
  inviteCode: z.string().optional(),
});

export const loginSchema = z.object({
  email: z.string().email("Enter a valid email address"),
  password: z.string().min(1, "Password is required"),
});

export const onboardingSchema = z.object({
  curriculum: z.enum(["CBC", "KCSE"]),
  gradeLevel: z.string().min(1, "Select your grade level"),
  schoolName: z.string().max(200).optional().or(z.literal("")),
  targetGrade: z.string().min(1, "Select your target grade"),
});

export type SignupInput = z.infer<typeof signupSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type OnboardingInput = z.infer<typeof onboardingSchema>;
