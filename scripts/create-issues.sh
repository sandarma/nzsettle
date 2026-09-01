#!/bin/bash

# NZSettle - Batch Create GitHub Issues
# Run this script to create all issues at once
# Prerequisites: GitHub CLI (brew install gh) and logged in (gh auth login)

echo "🚀 Creating NZSettle GitHub Issues..."
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
# PHASE 1: Foundation (Week 1-2)
# ============================================
echo "📦 Phase 1: Creating Foundation Issues..."

# Issue 1
gh issue create \
  --title "feat: Initialize Next.js 14 project with TypeScript and Tailwind" \
  --label "phase-1,setup" \
  --body "## Description
Create Next.js 14 App Router project with all required dependencies.

## Tasks
- [ ] Create Next.js 14 project with App Router
- [ ] Configure TypeScript
- [ ] Set up Tailwind CSS
- [ ] Add shadcn/ui components
- [ ] Configure ESLint and Prettier
- [ ] Create .env.example with required variables
- [ ] Create .gitignore

## Acceptance Criteria
- [ ] \`npm run dev\` starts successfully
- [ ] \`npm run build\` passes
- [ ] \`npm run lint\` passes
- [ ] TypeScript configured
- [ ] Tailwind working
- [ ] shadcn/ui installed"

echo "   ✅ Issue 1: Initialize Next.js"

# Issue 2
gh issue create \
  --title "feat: Set up Supabase client and environment variables" \
  --label "phase-1,setup,database" \
  --body "## Description
Connect to Supabase database and configure environment variables.

## Tasks
- [ ] Create Supabase project (if not done)
- [ ] Set up environment variables in .env.local
- [ ] Create Supabase client for browser (\`createBrowserClient\`)
- [ ] Create Supabase client for server (\`createServerClient\`)
- [ ] Test database connection
- [ ] Create initial migration files

## Acceptance Criteria
- [ ] Supabase client initialized
- [ ] Environment variables loaded
- [ ] Connection test successful
- [ ] Database tables created"

echo "   ✅ Issue 2: Supabase setup"

# Issue 3
gh issue create \
  --title "feat: Create initial database schema and migrations" \
  --label "phase-1,database" \
  --body "## Description
Create all database tables with proper schemas and RLS policies.

## Tables to Create
- [ ] users (extends auth.users)
- [ ] user_roles (enum: admin, registered, customer, home_owner, car_owner, viewing_helper)
- [ ] customer_profiles
- [ ] home_owner_profiles
- [ ] car_owner_profiles
- [ ] viewing_helper_profiles
- [ ] availability

## Acceptance Criteria
- [ ] All tables created
- [ ] RLS policies configured
- [ ] Migrations run successfully
- [ ] Test data insertable"

echo "   ✅ Issue 3: Database schema"

# Issue 4
gh issue create \
  --title "feat: Populate NZ regions and districts reference data" \
  --label "phase-1,database,setup" \
  --body "## Description
Create reference tables for NZ regions and districts.

## Tasks
- [ ] Create regions table (15 NZ regions)
- [ ] Create districts table (cascading from regions)
- [ ] Populate with real NZ data
- [ ] Create migration file

## NZ Regions
Auckland, Waikato, Bay of Plenty, Gisborne, Hawke's Bay, Taranaki, Manawatu-Wanganui, Wellington, Tasman, Nelson, Marlborough, West Coast, Canterbury, Otago, Southland

## Acceptance Criteria
- [ ] Regions table created
- [ ] Districts table created
- [ ] All 15 regions populated
- [ ] Districts linked to regions"

echo "   ✅ Issue 4: NZ regions data"

# Issue 5
gh issue create \
  --title "feat: Configure AWS S3 bucket for image uploads" \
  --label "phase-1,setup,storage" \
  --body "## Description
Set up AWS S3 for storing images (licenses, listing photos, car photos).

## Tasks
- [ ] Create S3 bucket (nzsettle-images)
- [ ] Configure bucket policy for public read
- [ ] Set up CORS for frontend access
- [ ] Create presigned URL generation function
- [ ] Create upload API route
- [ ] Test upload flow

## Image Types
- License photos (front + back) - car_owner only
- Listing photos (max 5 per listing) - home_owner
- Car photos (max 3) - car_owner

## Acceptance Criteria
- [ ] S3 bucket created
- [ ] Presigned URL generation working
- [ ] Upload API route created
- [ ] Image upload tested"

echo "   ✅ Issue 5: AWS S3 setup"

# Issue 6
gh issue create \
  --title "feat: Build login, register, and password reset pages" \
  --label "phase-1,auth,ui" \
  --body "## Description
Create authentication pages with Supabase Auth.

## Pages to Create
- [ ] Login page (\`/login\`)
- [ ] Register page (\`/register\`)
- [ ] Forgot password page (\`/forgot-password\`)
- [ ] Reset password page (\`/reset-password\`)

## Features
- Email + password authentication
- Email confirmation required
- Form validation with zod
- Error handling
- Redirect after login
- Mobile responsive

## Acceptance Criteria
- [ ] Login page working
- [ ] Registration page working
- [ ] Email confirmation sent
- [ ] Password reset flow working
- [ ] Form validation with zod
- [ ] Responsive design"

echo "   ✅ Issue 6: Auth pages"

# Issue 7
gh issue create \
  --title "feat: Implement authentication middleware and role-based access" \
  --label "phase-1,auth,security" \
  --body "## Description
Create Next.js middleware for authentication and role-based access control.

## Tasks
- [ ] Create middleware.ts for auth
- [ ] Protect dashboard routes
- [ ] Add role-based redirects
- [ ] Handle unauthenticated users
- [ ] Add origin checking for API routes
- [ ] Rate limiting implementation

## Security Features
- Origin checking (only frontend domain allowed)
- JWT verification
- Role-based access control
- Rate limiting (100 req/min)

## Acceptance Criteria
- [ ] Middleware protecting routes
- [ ] Unauthenticated users redirected to login
- [ ] Role-based access working
- [ ] Origin checking implemented"

echo "   ✅ Issue 7: Auth middleware"

# ============================================
# PHASE 2: Core Features (Week 3-5)
# ============================================
echo ""
echo "🎯 Phase 2: Creating Core Feature Issues..."

# Issue 8
gh issue create \
  --title "feat: Create landing page with hero, features, and testimonials" \
  --label "phase-2,ui,marketing" \
  --body "## Description
Build the public landing page for NZSettle.

## Sections
- [ ] Hero section with call-to-action
- [ ] Features section (for tenants, viewing helpers, home owners, car owners)
- [ ] Impact statistics
- [ ] Testimonials section (static images)
- [ ] Footer with links

## Impact Stats to Display
- 60+ rental services provided
- 20+ airport pickups
- 5+ viewing helpers earning income
- 5+ car owners earning income
- 5+ home owners earning income

## Acceptance Criteria
- [ ] Hero section with CTA
- [ ] Features section complete
- [ ] Impact stats displayed
- [ ] Testimonials section
- [ ] Mobile responsive
- [ ] Fast loading"

echo "   ✅ Issue 8: Landing page"

# Issue 9
gh issue create \
  --title "feat: Build role-based dashboard layout with sidebar navigation" \
  --label "phase-2,ui,dashboard" \
  --body "## Description
Create the dashboard layout with role-based navigation.

## Tasks
- [ ] Dashboard layout with sidebar
- [ ] Role-based navigation menus
- [ ] Header with user info and notifications
- [ ] Mobile responsive sidebar
- [ ] Role-based redirects on login

## Role-Based Menus
- **Customer:** Watchlist, Bookings, Profile
- **Home Owner:** My Listings, Add Listing, Profile
- **Car Owner:** My Vehicle, Availability, Pickups
- **Viewing Helper:** My Schedule, Assignments, Profile
- **Admin:** Users, Listings, Bookings, All Watchlists

## Acceptance Criteria
- [ ] Dashboard layout working
- [ ] Sidebar navigation complete
- [ ] Role-based menu items
- [ ] Mobile responsive
- [ ] Notifications bell icon"

echo "   ✅ Issue 9: Dashboard layout"

# Issue 10
gh issue create \
  --title "feat: Build room listings browse page with filters" \
  --label "phase-2,feature,listings" \
  --body "## Description
Create public page showing all active room listings.

## Filters
- [ ] Region (cascading dropdown - 15 NZ regions)
- [ ] District (based on selected region)
- [ ] Price range (min/max per week)
- [ ] Utilities (power included, water included, wifi type)
- [ ] Bathroom type (private/shared)
- [ ] Furnished/unfurnished
- [ ] Property type
- [ ] Available from date

## Features
- Listing cards with primary image
- Pagination
- Contact info hidden for guests
- Sort by price, date, etc.

## Acceptance Criteria
- [ ] Listings displayed correctly
- [ ] All filters working
- [ ] Cascading region/district dropdown
- [ ] Pagination working
- [ ] Contact hidden for guests
- [ ] Mobile responsive"

echo "   ✅ Issue 10: Room listings page"

# Issue 11
gh issue create \
  --title "feat: Build room listing detail page" \
  --label "phase-2,feature,listings" \
  --body "## Description
Create detailed view for individual room listings.

## Features
- [ ] Full listing details (40+ fields)
- [ ] Image gallery (up to 5 photos)
- [ ] Contact info (shown only to registered users)
- [ ] 'Register to contact' overlay for guests
- [ ] School zones displayed
- [ ] Availability information
- [ ] Share functionality
- [ ] WhatsApp contact button

## Acceptance Criteria
- [ ] All details displayed
- [ ] Image gallery working
- [ ] Contact hidden for guests
- [ ] Registration overlay for guests
- [ ] Mobile responsive"

echo "   ✅ Issue 11: Listing detail page"

# Issue 12
gh issue create \
  --title "feat: Build home owner dashboard for managing listings" \
  --label "phase-2,dashboard,feature" \
  --body "## Description
Create dashboard for home owners to manage their room listings.

## Features
- [ ] Dashboard showing own listings only (max 3)
- [ ] Create new listing form (40+ fields)
- [ ] Edit existing listing
- [ ] Delete listing (if no active bookings)
- [ ] Upload photos (max 5 per listing)
- [ ] View listing status (pending_review, active, rejected)

## Listing Fields
Location, Pricing, Utilities, Property Details, Bathroom, Flatmate Preferences, Shared Facilities, Availability, School Zones

## Acceptance Criteria
- [ ] Own listings displayed
- [ ] Create listing form working
- [ ] Edit listing working
- [ ] Delete listing working
- [ ] Photo upload working
- [ ] Status displayed correctly"

echo "   ✅ Issue 12: Home owner dashboard"

# Issue 13
gh issue create \
  --title "feat: Build car owner profile and vehicle registration" \
  --label "phase-2,feature,car-owner" \
  --body "## Description
Create car owner profile and vehicle registration system.

## Profile Fields
- [ ] Vehicle make, model, year
- [ ] Vehicle capacity
- [ ] Child seat availability
- [ ] Bio/description

## Verification
- [ ] License upload (front + back) - S3
- [ ] Car photos (max 3) - S3
- [ ] Verification status display

## Availability
- [ ] Mon-Sun × Morning/Afternoon/Evening picker
- [ ] Save availability to database

## Acceptance Criteria
- [ ] Profile form working
- [ ] Vehicle details saved
- [ ] License upload working
- [ ] Car photos upload working
- [ ] Availability settings saved
- [ ] Verification status displayed"

echo "   ✅ Issue 13: Car owner registration"

# Issue 14
gh issue create \
  --title "feat: Build viewing helper profile and availability" \
  --label "phase-2,feature,viewing-helper" \
  --body "## Description
Create viewing helper profile and availability system.

## Profile Fields
- [ ] Bio/experience
- [ ] Availability notes
- [ ] Hourly rate (optional)

## Availability
- [ ] Mon-Sun × Morning/Afternoon/Evening picker
- [ ] Save availability to database

## Assignment Handling
- [ ] View assigned viewings
- [ ] Accept/reject assignments
- [ ] Provide reason if rejected
- [ ] View schedule (accepted only)

## Acceptance Criteria
- [ ] Profile form working
- [ ] Availability settings saved
- [ ] Can accept/reject assignments
- [ ] Assigned viewings displayed
- [ ] Mobile responsive"

echo "   ✅ Issue 14: Viewing helper profile"

# Issue 15
gh issue create \
  --title "feat: Build consultation booking form for customers" \
  --label "phase-2,feature,booking" \
  --body "## Description
Create consultation booking form for customers.

## Form Fields
- [ ] Preferred date
- [ ] Preferred time
- [ ] Meeting link (Zoom/Meet)
- [ ] Notes/questions

## Features
- [ ] Confirmation page
- [ ] Admin notification (wa.me)
- [ ] Calendar event (.ics export)
- [ ] Status tracking (pending → confirmed → completed)

## Acceptance Criteria
- [ ] Booking form working
- [ ] Confirmation page displayed
- [ ] Admin notified via wa.me
- [ ] .ics file downloadable
- [ ] Form validation working"

echo "   ✅ Issue 15: Consultation booking"

# Issue 16
gh issue create \
  --title "feat: Build viewing booking form for customers" \
  --label "phase-2,feature,booking" \
  --body "## Description
Create viewing booking form for customers.

## Form Fields
- [ ] Select listing from watchlist
- [ ] Preferred date/time
- [ ] Questions for agent
- [ ] Additional notes

## Workflow
1. Customer requests viewing
2. Admin assigns viewing helper
3. Viewing helper notified (wa.me)
4. Viewing helper accepts/rejects
5. Status tracking (requested → assigned → accepted → completed)

## Acceptance Criteria
- [ ] Booking form working
- [ ] Admin can assign viewing helper
- [ ] Viewing helper notified
- [ ] Accept/reject working
- [ ] Status tracking working
- [ ] .ics file downloadable"

echo "   ✅ Issue 16: Viewing booking"

# Issue 17
gh issue create \
  --title "feat: Build airport pickup request form" \
  --label "phase-2,feature,pickup" \
  --body "## Description
Create airport pickup request form for customers.

## Form Fields
- [ ] Flight number
- [ ] Flight date/time
- [ ] Number of adults
- [ ] Number of children
- [ ] Child seats needed
- [ ] Luggage count
- [ ] Pickup location (airport)
- [ ] Dropoff address
- [ ] Special requests

## Features
- [ ] Price estimation (distance-based)
- [ ] Admin assigns car owner
- [ ] Car owner notified (wa.me)
- [ ] Car owner accepts/rejects
- [ ] Status tracking

## Acceptance Criteria
- [ ] Request form working
- [ ] Price estimation calculated
- [ ] Admin can assign car owner
- [ ] Car owner notified
- [ ] Accept/reject working
- [ ] Status tracking working"

echo "   ✅ Issue 17: Airport pickup"

# Issue 18
gh issue create \
  --title "feat: Build customer watchlist for property tracking" \
  --label "phase-2,feature,watchlist" \
  --body "## Description
Create customer watchlist for tracking properties.

## Form Fields
- [ ] Title, source URL
- [ ] Location (region, district, address)
- [ ] Pricing (rent, bond, advance)
- [ ] Utilities (power, water, wifi)
- [ ] Property details (beds, baths, living, parking, furnished)
- [ ] Availability
- [ ] Agent info (name, email, phone, agency)
- [ ] Notes

## Features
- [ ] Max 10 items per customer
- [ ] Status tracking (interested → viewing_booked → viewed → application_submitted → shortlisted/rejected)
- [ ] Create viewing booking from watchlist
- [ ] Edit/delete watchlist items
- [ ] Only customer + admin can see

## Acceptance Criteria
- [ ] Add watchlist item working
- [ ] Max 10 items enforced
- [ ] All fields saved
- [ ] Status tracking working
- [ ] Can create viewing from watchlist
- [ ] Edit/delete working
- [ ] Mobile responsive"

echo "   ✅ Issue 18: Customer watchlist"

# Issue 19
gh issue create \
  --title "feat: Build availability settings for viewing helpers and car owners" \
  --label "phase-2,feature,availability" \
  --body "## Description
Create availability picker component for viewing helpers and car owners.

## Availability Grid
- Days: Mon, Tue, Wed, Thu, Fri, Sat, Sun
- Times: Morning, Afternoon, Evening
- Toggle available/unavailable

## Features
- [ ] Save availability to database
- [ ] Display availability in profile
- [ ] Use for matching bookings
- [ ] Mobile responsive picker

## Acceptance Criteria
- [ ] Availability picker working
- [ ] All days/times selectable
- [ ] Save functionality working
- [ ] Display in profile working
- [ ] Mobile responsive"

echo "   ✅ Issue 19: Availability system"

# ============================================
# PHASE 3: Polish (Week 6-7)
# ============================================
echo ""
echo "✨ Phase 3: Creating Polish Issues..."

# Issue 20
gh issue create \
  --title "feat: Build in-app notification system" \
  --label "phase-3,feature,notifications" \
  --body "## Description
Create in-app notification system.

## Features
- [ ] Bell icon in header
- [ ] Unread count badge
- [ ] Notification list page
- [ ] Mark as read/unread
- [ ] Notification types:
  - Viewing assigned
  - Pickup assigned
  - Consultation confirmed
  - Booking status changes

## Acceptance Criteria
- [ ] Bell icon working
- [ ] Unread count displayed
- [ ] Notification list page
- [ ] Mark as read working
- [ ] All notification types implemented"

echo "   ✅ Issue 20: Notification system"

# Issue 21
gh issue create \
  --title "feat: Implement wa.me deep links for notifications" \
  --label "phase-3,feature,notifications" \
  --body "## Description
Implement WhatsApp notifications via wa.me deep links.

## Message Templates
- [ ] Viewing assignment → notify viewing helper
- [ ] Pickup assignment → notify car owner
- [ ] Consultation booked → notify admin
- [ ] Consultation confirmed → notify customer

## Features
- [ ] Generate wa.me deep links with pre-filled messages
- [ ] Open in WhatsApp on click
- [ ] Log notification sent

## Acceptance Criteria
- [ ] wa.me links generated correctly
- [ ] Pre-filled messages working
- [ ] Opens WhatsApp on click
- [ ] Notifications logged"

echo "   ✅ Issue 21: WhatsApp integration"

# Issue 22
gh issue create \
  --title "feat: Add iCal (.ics) file export for bookings" \
  --label "phase-3,feature,calendar" \
  --body "## Description
Add iCal file export for all bookings.

## Event Types
- [ ] Consultation bookings
- [ ] Viewing bookings
- [ ] Airport pickups

## Features
- [ ] Generate .ics files
- [ ] Include all event details
- [ ] Download button on booking pages
- [ ] Works with Google Calendar, Outlook, Apple Calendar

## Acceptance Criteria
- [ ] .ics files generated
- [ ] All event types covered
- [ ] Download working
- [ ] Calendar apps can open files"

echo "   ✅ Issue 22: iCal export"

# Issue 23
gh issue create \
  --title "feat: Build admin dashboard for managing platform" \
  --label "phase-3,dashboard,admin" \
  --body "## Description
Create admin dashboard for platform management.

## Features
- [ ] Overview stats (total users, listings, bookings)
- [ ] User management (view, approve, reject roles)
- [ ] Listing management (review, approve, reject)
- [ ] Booking management (assign viewing helpers, car owners)
- [ ] View all customer watchlists
- [ ] Content moderation (review uploaded images)

## Acceptance Criteria
- [ ] Stats displayed correctly
- [ ] User management working
- [ ] Listing approval working
- [ ] Booking assignment working
- [ ] Watchlist viewing working
- [ ] Image moderation working"

echo "   ✅ Issue 23: Admin dashboard"

# Issue 24
gh issue create \
  --title "feat: Build role request and approval system" \
  --label "phase-3,feature,auth" \
  --body "## Description
Create role request and approval system.

## Role Requests
- [ ] Request consultation → becomes customer
- [ ] Request viewing helper role
- [ ] Request home owner role
- [ ] Request car owner role

## Admin Actions
- [ ] View pending requests
- [ ] Approve/reject with reason
- [ ] Email notification on approval/rejection
- [ ] Status tracking (pending → approved/rejected)

## Acceptance Criteria
- [ ] Role request form working
- [ ] Admin can view requests
- [ ] Approve/reject working
- [ ] Notifications sent
- [ ] Status tracking working"

echo "   ✅ Issue 24: Role request system"

# Issue 25
gh issue create \
  --title "feat: Implement content moderation for listings and images" \
  --label "phase-3,feature,moderation" \
  --body "## Description
Implement content moderation system.

## Features
- [ ] All listings go through pending_review
- [ ] Admin reviews listing details
- [ ] Admin reviews uploaded images
- [ ] Approve/reject with feedback
- [ ] Rejected listings show reason
- [ ] Flag inappropriate content

## Acceptance Criteria
- [ ] Listings pending by default
- [ ] Admin review interface working
- [ ] Image review working
- [ ] Approval/rejection working
- [ ] Flag system working"

echo "   ✅ Issue 25: Content moderation"

# ============================================
# Summary
# ============================================
echo ""
echo "======================================"
echo "✅ All 25 issues created successfully!"
echo ""
echo "📊 Summary:"
echo "   Phase 1: 7 issues (Foundation)"
echo "   Phase 2: 12 issues (Core Features)"
echo "   Phase 3: 6 issues (Polish)"
echo ""
echo "Next steps:"
echo "   1. Go to https://github.com/sandarma/nzsettle/issues"
echo "   2. Create a Project Board (Projects tab → New project)"
echo "   3. Add issues to the board"
echo "   4. Start with Issue 1: Initialize Next.js"
echo ""
echo "🚀 Happy coding!"
