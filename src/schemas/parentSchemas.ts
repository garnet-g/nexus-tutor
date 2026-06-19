import { z } from "zod";

export const parentLinkSchema = z.object({
  inviteCode: z
    .string()
    .min(6, "Enter a valid invite code")
    .max(20, "Invite code is too long")
    .transform((value) => value.trim().toUpperCase()),
});

export type ParentLinkInput = z.infer<typeof parentLinkSchema>;
