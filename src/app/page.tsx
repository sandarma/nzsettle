"use client";

import { useState } from "react";
import { Button } from "@/components/ui/button";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { HomeIcon, Car, Users, Calendar, MessageCircle, Shield, ArrowRight, Sparkles, TrendingUp, Heart, Menu, X } from "lucide-react";

export default function HomePage() {
  const [mobileMenuOpen, setMobileMenuOpen] = useState(false);

  const navLinks = [
    { label: "Features", href: "#features" },
    { label: "Community", href: "#community" },
    { label: "About", href: "#about" },
  ];

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-background to-muted/30">
      {/* Navbar */}
      <nav className="sticky top-0 z-50 bg-background/80 backdrop-blur-lg border-b">
        <div className="container mx-auto px-4">
          <div className="flex items-center justify-between h-16">
            {/* Logo */}
            <div className="flex items-center gap-2">
              <div className="w-10 h-10 bg-primary rounded-xl flex items-center justify-center">
                <HomeIcon className="w-6 h-6 text-primary-foreground" />
              </div>
              <span className="text-xl font-bold">NZSettle</span>
            </div>

            {/* Desktop Navigation */}
            <div className="hidden md:flex items-center gap-8">
              {navLinks.map((link) => (
                <a
                  key={link.label}
                  href={link.href}
                  className="text-muted-foreground hover:text-foreground transition-colors font-medium"
                >
                  {link.label}
                </a>
              ))}
            </div>

            {/* Desktop CTA */}
            <div className="hidden md:flex items-center gap-3">
              <Button variant="ghost" className="font-medium">
                Log in
              </Button>
              <Button className="font-medium">
                Sign up
              </Button>
            </div>

            {/* Mobile Menu Button */}
            <button
              className="md:hidden p-2 hover:bg-muted rounded-lg transition-colors"
              onClick={() => setMobileMenuOpen(!mobileMenuOpen)}
            >
              {mobileMenuOpen ? (
                <X className="w-6 h-6" />
              ) : (
                <Menu className="w-6 h-6" />
              )}
            </button>
          </div>

          {/* Mobile Menu */}
          {mobileMenuOpen && (
            <div className="md:hidden py-4 border-t">
              <div className="flex flex-col gap-4">
                {navLinks.map((link) => (
                  <a
                    key={link.label}
                    href={link.href}
                    className="text-muted-foreground hover:text-foreground transition-colors font-medium py-2"
                    onClick={() => setMobileMenuOpen(false)}
                  >
                    {link.label}
                  </a>
                ))}
                <div className="flex flex-col gap-2 pt-4 border-t">
                  <Button variant="ghost" className="justify-start font-medium">
                    Log in
                  </Button>
                  <Button className="font-medium">
                    Sign up
                  </Button>
                </div>
              </div>
            </div>
          )}
        </div>
      </nav>

      {/* Hero Section */}
      <section className="relative overflow-hidden">
        {/* Background decoration */}
        <div className="absolute inset-0 bg-gradient-to-r from-primary/5 via-transparent to-primary/5" />
        <div className="absolute top-20 left-10 w-72 h-72 bg-primary/10 rounded-full blur-3xl" />
        <div className="absolute bottom-20 right-10 w-96 h-96 bg-primary/5 rounded-full blur-3xl" />

        <div className="container relative mx-auto px-4 py-24 md:py-32">
          <div className="text-center max-w-4xl mx-auto">
            <Badge
              variant="secondary"
              className="mb-6 px-4 py-2 text-sm font-medium bg-primary/10 text-primary hover:bg-primary/20 transition-colors cursor-default"
            >
              <Sparkles className="w-4 h-4 mr-2" />
              New Zealand&apos;s Newcomers Platform
            </Badge>

            <h1 className="text-4xl md:text-6xl lg:text-7xl font-bold mb-6 tracking-tight">
              Welcome to{" "}
              <span className="bg-gradient-to-r from-primary via-primary/80 to-primary bg-clip-text text-transparent">
                NZSettle
              </span>
            </h1>

            <p className="text-lg md:text-xl text-muted-foreground mb-10 max-w-2xl mx-auto leading-relaxed">
              Helping international newcomers to New Zealand find accommodation, arrange property viewings, and coordinate airport pickups.
            </p>

            <div className="flex gap-4 justify-center flex-wrap">
              <Button
                size="lg"
                className="bg-primary hover:bg-primary/90 text-primary-foreground px-8 py-6 text-lg font-medium shadow-lg shadow-primary/25 hover:shadow-xl hover:shadow-primary/30 transition-all duration-300 hover:-translate-y-0.5"
              >
                Get Started
                <ArrowRight className="ml-2 h-5 w-5" />
              </Button>
              <Button
                size="lg"
                variant="outline"
                className="px-8 py-6 text-lg font-medium border-2 hover:bg-muted/50 transition-all duration-300"
              >
                Learn More
              </Button>
            </div>
          </div>
        </div>
      </section>

      {/* Stats Section */}
      <section className="container mx-auto px-4 py-16">
        <div className="grid grid-cols-2 md:grid-cols-4 gap-6">
          {[
            { number: "60+", label: "Rental Services", icon: TrendingUp, color: "text-emerald-500" },
            { number: "20+", label: "Airport Pickups", icon: Car, color: "text-blue-500" },
            { number: "5+", label: "Viewing Helpers", icon: Users, color: "text-purple-500" },
            { number: "5+", label: "Home Owners", icon: HomeIcon, color: "text-orange-500" },
          ].map((stat, index) => (
            <Card
              key={index}
              className="text-center p-6 hover:shadow-lg hover:-translate-y-1 transition-all duration-300 border-2 hover:border-primary/20"
            >
              <CardContent className="p-0">
                <stat.icon className={`w-8 h-8 mx-auto mb-3 ${stat.color}`} />
                <div className="text-3xl md:text-4xl font-bold text-primary mb-1">
                  {stat.number}
                </div>
                <div className="text-sm text-muted-foreground font-medium">
                  {stat.label}
                </div>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* Features Section */}
      <section id="features" className="container mx-auto px-4 py-20">
        <div className="text-center mb-16">
          <Badge variant="outline" className="mb-4">
            How It Works
          </Badge>
          <h2 className="text-3xl md:text-4xl font-bold mb-4">
            Everything you need to settle in
          </h2>
          <p className="text-muted-foreground max-w-2xl mx-auto">
            From finding your perfect room to arranging airport pickup, we&apos;ve got you covered.
          </p>
        </div>

        <div className="grid md:grid-cols-3 gap-8">
          {[
            {
              icon: HomeIcon,
              title: "Find Rooms",
              description: "Browse verified room listings from community members across New Zealand",
              features: ["Detailed property information", "School zone availability", "Utility details included"],
              color: "bg-emerald-500/10 text-emerald-600",
              hoverBorder: "hover:border-emerald-500/30",
            },
            {
              icon: Users,
              title: "Arrange Viewings",
              description: "Get local viewing helpers to check properties on your behalf",
              features: ["Trusted community helpers", "Flexible scheduling", "Real-time updates"],
              color: "bg-blue-500/10 text-blue-600",
              hoverBorder: "hover:border-blue-500/30",
            },
            {
              icon: Car,
              title: "Airport Pickup",
              description: "Arrange airport pickups from verified car owners in your community",
              features: ["Child seats available", "Flexible pickup times", "Reasonable pricing"],
              color: "bg-purple-500/10 text-purple-600",
              hoverBorder: "hover:border-purple-500/30",
            },
          ].map((feature, index) => (
            <Card
              key={index}
              className={`group relative overflow-hidden transition-all duration-300 hover:shadow-xl hover:-translate-y-2 border-2 ${feature.hoverBorder}`}
            >
              <CardHeader className="p-8 pb-4">
                <div className={`w-14 h-14 rounded-xl ${feature.color} flex items-center justify-center mb-5 mx-auto group-hover:scale-110 transition-transform duration-300`}>
                  <feature.icon className="w-7 h-7" />
                </div>
                <CardTitle className="text-xl mb-2">{feature.title}</CardTitle>
                <CardDescription className="text-base leading-relaxed">
                  {feature.description}
                </CardDescription>
              </CardHeader>
              <CardContent className="px-8 pb-8">
                <ul className="space-y-3">
                  {feature.features.map((item, i) => (
                    <li key={i} className="flex items-center text-sm text-muted-foreground">
                      <div className="w-1.5 h-1.5 rounded-full bg-primary mr-3 flex-shrink-0" />
                      {item}
                    </li>
                  ))}
                </ul>
              </CardContent>
            </Card>
          ))}
        </div>
      </section>

      {/* For Community Section */}
      <section id="community" className="relative overflow-hidden bg-gradient-to-br from-primary/5 via-muted/50 to-primary/5">
        <div className="absolute top-0 left-1/2 -translate-x-1/2 w-full h-px bg-gradient-to-r from-transparent via-primary/20 to-transparent" />

        <div className="container mx-auto px-4 py-20">
          <div className="text-center mb-16">
            <Badge variant="outline" className="mb-4">
              <Heart className="w-3 h-3 mr-1" />
              For Community
            </Badge>
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Earn flexible income
            </h2>
            <p className="text-muted-foreground max-w-2xl mx-auto">
              Help newcomers settle in New Zealand while earning on your own schedule.
            </p>
          </div>

          <div className="grid md:grid-cols-3 gap-8">
            {[
              {
                icon: Calendar,
                title: "Set Your Schedule",
                description: "Choose when you're available — mornings, afternoons, or evenings",
              },
              {
                icon: MessageCircle,
                title: "Get Notified",
                description: "Receive WhatsApp notifications when jobs match your availability",
              },
              {
                icon: Shield,
                title: "Verified Profile",
                description: "Build trust with a verified profile and community ratings",
              },
            ].map((item, index) => (
              <Card
                key={index}
                className="text-center p-10 bg-background/50 backdrop-blur-sm hover:shadow-lg hover:-translate-y-1 transition-all duration-300 border-2 hover:border-primary/20"
              >
                <CardContent className="p-0">
                  <div className="w-16 h-16 rounded-2xl bg-primary/10 flex items-center justify-center mx-auto mb-6 group-hover:scale-110 transition-transform">
                    <item.icon className="w-8 h-8 text-primary" />
                  </div>
                  <h3 className="text-xl font-semibold mb-3">{item.title}</h3>
                  <p className="text-muted-foreground leading-relaxed">
                    {item.description}
                  </p>
                </CardContent>
              </Card>
            ))}
          </div>
        </div>
      </section>

      {/* CTA Section */}
      <section id="about" className="container mx-auto px-4 py-20">
        <Card className="relative overflow-hidden border-2 bg-gradient-to-br from-primary to-primary/80 text-primary-foreground">
          <div className="absolute inset-0 bg-[url('/grid.svg')] opacity-10" />
          <CardContent className="relative p-12 md:p-16 text-center">
            <h2 className="text-3xl md:text-4xl font-bold mb-4">
              Ready to get started?
            </h2>
            <p className="text-primary-foreground/80 mb-8 max-w-xl mx-auto text-lg">
              Join our community and start finding your perfect room in New Zealand today.
            </p>
            <Button
              size="lg"
              variant="secondary"
              className="bg-white text-primary hover:bg-white/90 px-8 py-6 text-lg font-medium shadow-lg transition-all duration-300 hover:-translate-y-0.5"
            >
              Create Free Account
              <ArrowRight className="ml-2 h-5 w-5" />
            </Button>
          </CardContent>
        </Card>
      </section>

      {/* Footer */}
      <footer className="border-t bg-muted/30">
        <div className="container mx-auto px-4 py-12">
          <div className="flex flex-col md:flex-row justify-between items-center gap-6">
            <div className="text-center md:text-left">
              <p className="text-muted-foreground text-sm">
                Built by{" "}
                <a
                  href="https://github.com/sandarma"
                  className="text-primary hover:underline font-medium"
                >
                  Sandar Min Aye
                </a>{" "}
                for the Burmese community in Auckland
              </p>
            </div>
            <div className="text-sm text-muted-foreground">
              © {new Date().getFullYear()} NZSettle. All rights reserved.
            </div>
          </div>
        </div>
      </footer>
    </div>
  );
}
