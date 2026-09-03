import type { Metadata } from "next";
import localFont from "next/font/local";
import "./globals.css";
import { cn } from "@/lib/utils";

const geistSans = localFont({
  src: "./fonts/GeistVF.woff",
  variable: "--font-geist-sans",
  weight: "100 900",
});
const geistMono = localFont({
  src: "./fonts/GeistMonoVF.woff",
  variable: "--font-geist-mono",
  weight: "100 900",
});

export const metadata: Metadata = {
  title: "NZSettle - Newcomers Assistance Platform",
  description: "Helping international newcomers to New Zealand find accommodation, arrange property viewings, and coordinate airport pickups.",
  keywords: ["New Zealand", "newcomers", "accommodation", "rental", "airport pickup", "property viewing"],
  authors: [{ name: "Sandar Min Aye" }],
  openGraph: {
    title: "NZSettle - Newcomers Assistance Platform",
    description: "Helping international newcomers to New Zealand find accommodation, arrange property viewings, and coordinate airport pickups.",
    type: "website",
    locale: "en_NZ",
    siteName: "NZSettle",
  },
};

export default function RootLayout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <html lang="en" className={cn("font-sans")}>
      <body
        className={`${geistSans.variable} ${geistMono.variable} antialiased`}
      >
        {children}
      </body>
    </html>
  );
}
