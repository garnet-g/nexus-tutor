import * as React from "react"
import { Input as InputPrimitive } from "@base-ui/react/input"
import { cva } from "class-variance-authority"

import { cn } from "@/lib/utils"

export const inputVariants = cva(
  "w-full min-w-0 rounded-xl border border-input bg-card px-3 py-2 text-base text-foreground transition-colors outline-none placeholder:text-muted-foreground focus-visible:border-ring focus-visible:ring-3 focus-visible:ring-ring/50 disabled:pointer-events-none disabled:cursor-not-allowed disabled:opacity-50 aria-invalid:border-destructive aria-invalid:ring-3 aria-invalid:ring-destructive/20 md:text-sm dark:aria-invalid:border-destructive/50 dark:aria-invalid:ring-destructive/40",
)

function Input({ className, type, ...props }: React.ComponentProps<"input">) {
  return (
    <InputPrimitive
      type={type}
      data-slot="input"
      className={cn(inputVariants(), "min-h-11", className)}
      {...props}
    />
  )
}

export { Input }
