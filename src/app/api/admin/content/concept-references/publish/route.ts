import "server-only";

import { NextResponse } from "next/server";
import { z } from "zod";

import { publishConceptFromLessonBlock } from "@/server/services/conceptLibraryService";
import { requireContentAuthorApi } from "@/server/services/contentAuthorGuard";

const publishSchema = z.object({
  lessonId: z.string().uuid(),
  blockIndex: z.number().int().min(0),
  category: z
    .enum(["formula", "definition", "theorem", "example", "tip"])
    .optional(),
});

export async function POST(request: Request) {
  const auth = await requireContentAuthorApi(request);
  if (!auth.ok) {
    return auth.response;
  }

  const parsed = publishSchema.safeParse(await request.json().catch(() => ({})));
  if (!parsed.success) {
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "VALIDATION_ERROR",
          message: "Invalid concept publish payload.",
          details: parsed.error.flatten(),
        },
      },
      { status: 400 },
    );
  }

  try {
    const reference = await publishConceptFromLessonBlock({
      ...parsed.data,
      authorId: auth.userId,
    });

    return NextResponse.json({ success: true, data: { reference } }, { status: 201 });
  } catch (error) {
    console.error("CONCEPT_REFERENCE_PUBLISH_FAILED", error);
    return NextResponse.json(
      {
        success: false,
        error: {
          code: "INTERNAL_ERROR",
          message:
            error instanceof Error
              ? error.message
              : "Could not publish concept reference.",
        },
      },
      { status: 500 },
    );
  }
}
