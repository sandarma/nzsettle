#!/bin/bash

# NZSettle - Create GitHub Labels
# Run this script first before create-issues.sh
# Prerequisites: GitHub CLI (brew install gh) and logged in (gh auth login)

echo "🏷️  Creating NZSettle GitHub Labels..."
echo "======================================"

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI not found. Install it first:"
    echo "   brew install gh"
    exit 1
fi

# Check if logged in
if ! gh auth status &> /dev/null; then
    echo "❌ Not logged in. Run: gh auth login"
    exit 1
fi

# Check if we're in a git repo
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository. Run this script from the project root."
    exit 1
fi

# Get the repo name (owner/repo format)
REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner' 2>/dev/null)
if [ -z "$REPO" ]; then
    echo "❌ Could not determine repository. Make sure you're in the project directory."
    exit 1
fi

echo "✅ GitHub CLI ready"
echo "📁 Repository: $REPO"
echo ""

# ============================================
# Phase Labels
# ============================================
echo "📦 Creating Phase Labels..."

gh label create "phase-1" --color "0E8A16" --description "Foundation - Week 1-2" --repo "$REPO" 2>/dev/null || echo "   ⚠️  phase-1 already exists"
echo "   ✅ phase-1"

gh label create "phase-2" --color "1D76DB" --description "Core Features - Week 3-5" --repo "$REPO" 2>/dev/null || echo "   ⚠️  phase-2 already exists"
echo "   ✅ phase-2"

gh label create "phase-3" --color "D93F0B" --description "Polish - Week 6-7" --repo "$REPO" 2>/dev/null || echo "   ⚠️  phase-3 already exists"
echo "   ✅ phase-3"

echo ""

# ============================================
# Feature Type Labels
# ============================================
echo "🎯 Creating Feature Type Labels..."

gh label create "setup" --color "C2E0C6" --description "Project setup and configuration" --repo "$REPO" 2>/dev/null || echo "   ⚠️  setup already exists"
echo "   ✅ setup"

gh label create "database" --color "D4C5F9" --description "Database schema and migrations" --repo "$REPO" 2>/dev/null || echo "   ⚠️  database already exists"
echo "   ✅ database"

gh label create "auth" --color "F9D0C4" --description "Authentication and authorization" --repo "$REPO" 2>/dev/null || echo "   ⚠️  auth already exists"
echo "   ✅ auth"

gh label create "ui" --color "C5DEF5" --description "User interface components" --repo "$REPO" 2>/dev/null || echo "   ⚠️  ui already exists"
echo "   ✅ ui"

gh label create "feature" --color "0075CA" --description "New feature implementation" --repo "$REPO" 2>/dev/null || echo "   ⚠️  feature already exists"
echo "   ✅ feature"

gh label create "dashboard" --color "FBCA04" --description "Dashboard and admin panels" --repo "$REPO" 2>/dev/null || echo "   ⚠️  dashboard already exists"
echo "   ✅ dashboard"

gh label create "security" --color "B60205" --description "Security and access control" --repo "$REPO" 2>/dev/null || echo "   ⚠️  security already exists"
echo "   ✅ security"

gh label create "storage" --color "0E8A16" --description "File storage (S3)" --repo "$REPO" 2>/dev/null || echo "   ⚠️  storage already exists"
echo "   ✅ storage"

echo ""

# ============================================
# Role Labels
# ============================================
echo "👤 Creating Role Labels..."

gh label create "customer" --color "0075CA" --description "Customer-related features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  customer already exists"
echo "   ✅ customer"

gh label create "home-owner" --color "0E8A16" --description "Home owner features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  home-owner already exists"
echo "   ✅ home-owner"

gh label create "car-owner" --color "1D76DB" --description "Car owner features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  car-owner already exists"
echo "   ✅ car-owner"

gh label create "viewing-helper" --color "D93F0B" --description "Viewing helper features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  viewing-helper already exists"
echo "   ✅ viewing-helper"

gh label create "admin" --color "B60205" --description "Admin features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  admin already exists"
echo "   ✅ admin"

echo ""

# ============================================
# Feature-Specific Labels
# ============================================
echo "✨ Creating Feature-Specific Labels..."

gh label create "listings" --color "0075CA" --description "Room listing features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  listings already exists"
echo "   ✅ listings"

gh label create "booking" --color "1D76DB" --description "Booking and scheduling" --repo "$REPO" 2>/dev/null || echo "   ⚠️  booking already exists"
echo "   ✅ booking"

gh label create "pickup" --color "D93F0B" --description "Airport pickup features" --repo "$REPO" 2>/dev/null || echo "   ⚠️  pickup already exists"
echo "   ✅ pickup"

gh label create "watchlist" --color "FBCA04" --description "Property watchlist" --repo "$REPO" 2>/dev/null || echo "   ⚠️  watchlist already exists"
echo "   ✅ watchlist"

gh label create "availability" --color "0E8A16" --description "Availability scheduling" --repo "$REPO" 2>/dev/null || echo "   ⚠️  availability already exists"
echo "   ✅ availability"

gh label create "notifications" --color "F9D0C4" --description "In-app notifications" --repo "$REPO" 2>/dev/null || echo "   ⚠️  notifications already exists"
echo "   ✅ notifications"

gh label create "calendar" --color "D4C5F9" --description "iCal export" --repo "$REPO" 2>/dev/null || echo "   ⚠️  calendar already exists"
echo "   ✅ calendar"

gh label create "moderation" --color "B60205" --description "Content moderation" --repo "$REPO" 2>/dev/null || echo "   ⚠️  moderation already exists"
echo "   ✅ moderation"

gh label create "marketing" --color "C5DEF5" --description "Marketing and landing page" --repo "$REPO" 2>/dev/null || echo "   ⚠️  marketing already exists"
echo "   ✅ marketing"

echo ""

# ============================================
# Summary
# ============================================
echo "======================================"
echo "✅ All labels created successfully!"
echo ""
echo "📊 Labels Created:"
echo "   Phase Labels: 3 (phase-1, phase-2, phase-3)"
echo "   Feature Types: 9 (setup, database, auth, ui, feature, dashboard, security, storage)"
echo "   Role Labels: 5 (customer, home-owner, car-owner, viewing-helper, admin)"
echo "   Feature-Specific: 9 (listings, booking, pickup, watchlist, availability, notifications, calendar, moderation, marketing)"
echo ""
echo "Total: 26 labels"
echo ""
echo "Next steps:"
echo "   1. Run ./scripts/create-issues.sh to create all issues"
echo "   2. Go to https://github.com/sandarma/nzsettle/labels to see all labels"
echo ""
echo "🚀 Ready to create issues!"
