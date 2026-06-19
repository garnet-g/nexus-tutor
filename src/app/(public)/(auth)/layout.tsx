export default function PublicAuthLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <div className="nexus-hero-glow flex flex-1 items-center justify-center px-4 py-10 sm:px-6 sm:py-16">
      <div className="w-full max-w-md">{children}</div>
    </div>
  );
}
