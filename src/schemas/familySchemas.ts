import { z } from "zod";

export const familyJoinSchema = z.object({
  inviteCode: z.string().min(6, "Invite code is required"),
});
