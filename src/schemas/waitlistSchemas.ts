import { z } from "zod";

export const teacherWaitlistSchema = z.object({
  email: z.string().email("Enter a valid email address."),
  fullName: z.string().min(2, "Name must be at least 2 characters."),
  schoolName: z.string().min(2, "School name must be at least 2 characters."),
  curriculum: z.enum(["CBC", "KCSE"]).optional(),
});

export type TeacherWaitlistInput = z.infer<typeof teacherWaitlistSchema>;
