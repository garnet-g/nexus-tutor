// The student bottom navigation lives in StudentMobileNav, which renders the
// elevated Nex mark as the centre of the bar. This re-export exists only to
// avoid a duplicate implementation; prefer importing StudentMobileNav directly.
export { StudentMobileNav as BottomNav } from "@/features/student/components/StudentNav";
