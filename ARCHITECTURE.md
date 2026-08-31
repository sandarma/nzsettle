# Rental Platform — Architecture & Build Plan

## Context

Sandar currently manages rental assistance for Auckland's Burmese community manually via text files, WhatsApp, and Facebook Messenger. This platform replaces that manual workflow with a digital system, and will eventually be published for community use. MVP covers: Auth & Roles, Consultation & Booking, Listings & Viewings, Airport Pickup — all features needed for daily use.

---

## 1. Users & Roles

### Role Model

One user table, multiple role profiles. Admin is a separate account (Sandar's).

| Role | Who | Can Do | Approval |
|------|-----|--------|----------|
| **guest** | Not logged in | Browse room listings & car listings, see testimonials, see property details (NO contact info), see general info | N/A |
| **admin** | Sandar | Everything — manage clients, assign viewings/pickups, manage listings, view dashboard, approve/verify users, see all customer watchlists | N/A |
| **customer** | International newcomers | Book consultation, create personal watchlist (max 10), book viewings from watchlist, request airport pickup, see contact info on bookings | ✅ Auto-approved (email verification only) |
| **room_owner** | Community members | List rooms (max 3 posts), upload photos (max 5 per listing), manage availability | ❌ Requires admin approval |
| **car_owner** | Community drivers | Set availability, accept/decline pickup requests, manage vehicle info, upload license + car photos | ❌ Requires admin approval + license |
| **viewer** | Classmates / helpers (occasional) | View assigned viewing requests, update status (completed/cancelled) | ❌ Requires admin approval |

### User Approval System

| Role | Auto-Approved? | Requires |
|------|----------------|----------|
| **customer** | ✅ Yes | Email verification only |
| **room_owner** | ❌ No | Admin approval + valid profile |
| **car_owner** | ❌ No | Admin approval + license upload + car photos |
| **viewer** | ❌ No | Admin approval (Sandar's classmates only) |

### Listing Approval System

| Step | Action | Who |
|------|--------|-----|
| 1 | User creates listing | Room owner / Admin |
| 2 | Listing status = `pending_review` | System |
| 3 | Admin reviews listing + photos | Sandar |
| 4 | Approved → status = `active` | Admin |
| 5 | Rejected → status = `rejected` + feedback | Admin |

### Listing Management Rules

**Room Owner / Car Owner can:**
- ✅ Edit their own listings (when status is `active` or `pending_review`)
- ✅ Delete their own listings (if no active bookings/assignments)
- ✅ Submit new listings (up to 3 active max)
- ✅ Re-submit rejected listings after fixing issues
- ✅ See only their own listings in dashboard
- ✅ See all listings on the public frontend

**Room Owner / Car Owner CANNOT:**
- ❌ Delete listings with active bookings (viewings scheduled, pickups assigned)
- ❌ Edit listings that are currently booked (admin override only)
- ❌ Delete other users' listings (admin only)
- ❌ See other owners' listings in their dashboard

**Deletion Restrictions:**

| Listing Type | Can Delete? | Condition |
|--------------|-------------|-----------|
| Room listing | ✅ Yes | No upcoming viewings scheduled |
| Room listing | ❌ No | Has pending/assigned viewings |
| Car profile | ✅ Yes | No active pickup assignments |
| Car profile | ❌ No | Has assigned/en_route pickups |

### Customer Watchlist

**What is it?**
A personal list of properties the customer is interested in (from TradeMe, Facebook, etc.). They manually add listing details to track what they're looking for. NOT published publicly.

**Rules:**
- Max 10 watchlist items per customer (configurable later)
- Only the customer (and admin) can see their watchlist
- No photos upload — just text fields (title, address, rent, link, notes)
- Can create viewing bookings FROM watchlist items
- Future: AI-powered comparison/analysis page

**Watchlist Schema:**

```
customer_watchlist
  id: uuid (PK)
  customer_id: uuid (FK → users) — only this customer can see it

  -- Property info
  title: text — listing title
  source_url: text — original listing URL (TradeMe, Facebook, etc.)
  address: text
  rent_per_week: numeric
  bedrooms: integer
  bathrooms: integer
  property_type: text
  available_from: date

  -- Property manager / agent info (optional, for follow-up)
  agent_name: text — property manager or agent name
  agent_email: text — agent contact email
  agent_phone: text — agent contact number
  agency_name: text — real estate agency name (if applicable)

  -- Additional details
  notes: text — customer's notes about the listing
  status: enum('interested', 'viewing_booked', 'viewed', 'shortlisted', 'rejected')
  created_at: timestamptz
```

**Visibility:**
- Customer sees: Only their own watchlist
- Admin sees: All customer watchlists (for managing bookings)
- Room/Car owners: Do NOT see watchlists

**Analysis Page Design (AI-Powered):**

Inspired by the Claude artifact comparison page. Key elements:

| Section | Description |
|---------|-------------|
| **Quick Picks** | Highlight cards: Most affordable, Nearest school, Shortest commute, Best value |
| **Comparison Grid** | Sortable table: Address, Rent/Wk, Beds/Bath, School zones, Commute times, Available date |
| **Property Details** | Each listing with: Title, Rent, Key features, Travel times, School info, Pros/Cons, Nearby shops |
| **Travel Times** | Visual bars showing commute to each school + work/university |
| **Local Area Guide** | Supermarkets, restaurants, shops, transport — applies to all listings in area |

**Client Types:**

| Type | Who | Bedrooms Needed | School Commute |
|------|-----|-----------------|----------------|
| Single | Student, solo worker | 1+ | Maybe (if studying) |
| Couple | No children | 1+ | No |
| Family | 1+ children | 2+ | Yes (per child) |

**Key Fields for Analysis:**
```
Customer profile:
├── Client type: single / couple / family
├── Family size (if family)
├── Children's school addresses (array — can be different schools)
├── Work/University address
├── Move-in date
├── Preferred locations
└── Budget range

Each watchlist item compared on:
├── Rent per week
├── Bedrooms / Bathrooms
├── Commute to each child's school (walking/driving)
├── Commute to work/university
├── School zones (primary, intermediate, secondary)
├── Nearby amenities (supermarkets, shops, transport)
├── Utilities included (power, water, wifi)
├── Parking availability
├── Move-in readiness
└── Bond + advance required
```

**Note:** AI analysis is a future feature. MVP watchlist is just manual entry + list view.

### Viewer Assignment Flow

```
Admin assigns viewer → Status: pending
                     → Viewer notified (wa.me + in-app)
                     → Viewer has 24 hours to respond

Viewer actions:
  → Accept → Status: accepted → Viewer sees full details
  → Reject → Status: rejected → Admin assigns another viewer
  → No response (24h) → Status: expired → Admin assigns another viewer
```

**Viewer can:**
- ✅ Accept assignment (sees viewing details, questions, client info)
- ✅ Reject assignment (provides reason, admin assigns another)
- ✅ View their schedule (accepted assignments only)
- ❌ Cannot edit or cancel after accepting (must contact admin)

### Content Moderation

| Layer | What | How |
|-------|------|-----|
| **File type** | Only images allowed | `.jpg`, `.jpeg`, `.png`, `.webp` |
| **File size** | Max 5MB per image | Client + server validation |
| **Image count** | Max 5 per listing, 3 per car | Database constraint |
| **Manual review** | All uploaded images | Admin reviews before listing goes live |
| **Report system** | Flag inappropriate content | Users can report, admin reviews |

### Guest vs Registered Access

| What | Guest | Customer | Room Owner | Car Owner |
|------|-------|----------|------------|-----------|
| Browse room listings | ✅ | ✅ | ✅ (see all) | ✅ (see all) |
| Browse car listings | ✅ | ✅ | ✅ (see all) | ✅ (see all) |
| Contact owner's WhatsApp | ❌ | ✅ After booking | ✅ | ✅ |
| Book consultation | ❌ | ✅ | ❌ | ❌ |
| Create watchlist | ❌ | ✅ (max 10) | ❌ | ❌ |
| Book viewing from watchlist | ❌ | ✅ | ❌ | ❌ |
| Request airport pickup | ❌ | ✅ | ❌ | ❌ |
| Add room listings | ❌ | ❌ | ✅ (own only in dashboard) | ❌ |
| Add car listing | ❌ | ❌ | ❌ | ✅ (own only in dashboard) |
| See own listings in dashboard | ❌ | ❌ | ✅ | ✅ |
| See own watchlist | ❌ | ✅ | ❌ | ❌ |
| See all watchlists | ❌ | ❌ | ❌ | ❌ (admin only) |

### Listing Limits

| Role | Limit | Details |
|------|-------|---------|
| **room_owner** | Max 3 active listings | Can delete old ones to post new ones |
| **room_owner photos** | Max 5 per listing | Room photos, property images |
| **car_owner photos** | Max 3 car photos | Vehicle exterior/interior |
| **car_owner license** | Front + back required | For verification, stored in S3 |

### User Table Schema (Supabase)

```
users (auth.users extension)
  id: uuid (FK → auth.users)
  email: text (unique)
  full_name: text
  whatsapp_number: text (with international code, e.g. +65xxxxxxxx)
  account_status: enum('pending', 'active', 'suspended', 'banned')
  approved_by: uuid (FK → users, nullable) — admin who approved
  approved_at: timestamptz
  rejection_reason: text (nullable)
  created_at: timestamptz

user_roles
  id: uuid
  user_id: uuid (FK → users)
  role: enum('admin', 'customer', 'room_owner', 'car_owner', 'viewer')
  role_status: enum('pending', 'active', 'rejected')
  created_at: timestamptz

customer_profiles
  user_id: uuid (FK → users, PK)
  client_type: enum('single', 'couple', 'family') — determines bedroom needs + school relevance
  budget_min: numeric
  budget_max: numeric
  preferred_locations: text[]
  family_size: integer
  visa_status: text
  move_in_date: date
  work_address: text — workplace or university address (for commute calc)
  notes: text

customer_children
  id: uuid (PK)
  customer_id: uuid (FK → users)
  child_name: text — first name only (privacy)
  school_name: text — e.g. 'Mt Eden Normal School'
  school_address: text — full address for commute calculation
  school_level: enum('primary', 'intermediate', 'secondary')
  created_at: timestamptz

room_owner_profiles
  user_id: uuid (FK → users, PK)
  bio: text
  verified: boolean (default false)

car_owner_profiles
  user_id: uuid (FK → users, PK)
  vehicle_make: text
  vehicle_model: text
  vehicle_year: integer
  capacity: integer
  has_child_seat: boolean
  license_number: text
  license_front_url: text    # S3 URL — license front photo
  license_back_url: text     # S3 URL — license back photo
  car_photos: text[]          # Array of S3 URLs (max 3)
  bio: text
  verified: boolean (default false)
  verification_status: enum('pending', 'approved', 'rejected')

viewer_profiles
  user_id: uuid (FK → users, PK)
  availability_notes: text
  bio: text
  hourly_rate: numeric

-- Availability table (shared by car_owner and viewer)
availability
  id: uuid (PK)
  user_id: uuid (FK → users)
  day_of_week: enum('mon', 'tue', 'wed', 'thu', 'fri', 'sat', 'sun')
  time_of_day: enum('morning', 'afternoon', 'evening')
  is_available: boolean (default true)
  created_at: timestamptz
  UNIQUE(user_id, day_of_week, time_of_day)
```

### Room Listings Schema (Supabase)

```
room_listings
  id: uuid (PK)
  owner_id: uuid (FK → users) — room_owner or admin
  title: text
  description: text

  -- Location (cascading dropdown)
  region: text — e.g. 'Auckland', 'Waikato', 'Canterbury'
  district: text — e.g. 'Auckland City', 'North Shore City', 'Manukau City'
  address: text — Street address (shown to registered users)

  -- Pricing
  rent_per_week: numeric — NZD per week
  bond_weeks: integer — x weeks' rent
  rent_advance_weeks: integer — x weeks' rent

  -- Utilities
  includes_power: boolean
  includes_water: boolean
  includes_wifi: boolean
  wifi_type: enum('unlimited', 'limited', 'none')

  -- Room details
  property_type: enum('room', 'studio', 'house', 'apartment', 'townhouse')
  bed_size: enum('single', 'double', 'queen', 'king', 'bunk')
  furnished: boolean
  bed_provided: boolean
  wardrobe_provided: boolean
  bed_sheet_pillow_provided: boolean
  study_table_provided: boolean
  car_parking: boolean

  -- Bathroom
  bathroom_type: enum('private', 'shared')
  bathroom_count: integer — total bathrooms in property
  shared_with_how_many: integer — if shared, how many people

  -- Flatmate preferences
  existing_flatmates: integer
  couples_ok: boolean
  family_ok: boolean
  prefer_single: boolean
  smokers_ok: boolean
  pets_ok: boolean

  -- Shared facilities
  has_washing_machine: boolean
  has_dryer: boolean
  has_kitchen: boolean
  has_fridge: boolean
  has_microwave: boolean
  has_dishwasher: boolean
  has_kitchenware: boolean — Pots, pans, knives, chopping board, plates

  -- Availability
  available_from: date
  available_now: boolean
  notice_required_weeks: integer

  -- School zones
  school_zones: text[] — Array of school names in zone

  -- Listing meta
  images: text[] — Array of S3 URLs (max 5 per listing)
  source_url: text — Original listing URL (for admin-aggregated listings)
  source: enum('owner_posted', 'admin_aggregated')
  status: enum('pending_review', 'active', 'rented', 'inactive', 'rejected')
  rejection_reason: text (nullable)
  reviewed_by: uuid (FK → users, nullable)
  reviewed_at: timestamptz
  created_at: timestamptz

room_listing_images
  id: uuid (PK)
  listing_id: uuid (FK → room_listings)
  image_url: text — S3 URL
  sort_order: integer
  is_primary: boolean
```

### NZ Regions & Districts (Reference Data)

```
regions
  id: uuid (PK)
  name: text (unique) — e.g. 'Auckland', 'Waikato'

districts
  id: uuid (PK)
  region_id: uuid (FK → regions)
  name: text — e.g. 'Auckland City', 'North Shore City'
  UNIQUE(region_id, name)
```

### Testimonials (Static Images)

No database — just static images in `public/testimonials/`:

```
public/
└── testimonials/
    ├── feedback-1.png    # Facebook screenshot
    ├── feedback-2.png
    ├── feedback-3.png
    └── ...
```

Displayed on landing page, before footer. Admin adds new screenshots by dropping files in the folder.

**Regions:** Northland, Auckland, Waikato, Bay of Plenty, Gisborne, Hawke's Bay, Taranaki, Manawatu/Whanganui, Wellington, Nelson/Tasman, Marlborough, West Coast, Canterbury, Otago, Southland

**Auckland Districts:** All of Auckland, Auckland City, Franklin, Hauraki Gulf Islands, Manukau City, North Shore City, Papakura, Rodney, Waiheke Island, Waitakere City

### Airport Pickup Schema (Supabase)

```
airport_pickups
  id: uuid (PK)
  customer_id: uuid (FK → users)
  driver_id: uuid (FK → users, nullable) — assigned later
  flight_number: text
  flight_date: date
  arrival_time: time
  adults: integer
  children: integer
  child_seats_needed: integer
  luggage_count: integer
  pickup_location: text — airport
  dropoff_address: text
  special_requests: text
  estimated_price: numeric — calculated by system
  status: enum('requested', 'assigned', 'confirmed', 'en_route', 'completed', 'cancelled')
  created_at: timestamptz

viewings
  id: uuid (PK)
  listing_id: uuid (FK → room_listings)
  customer_id: uuid (FK → users)
  viewer_id: uuid (FK → users, nullable) — assigned later
  viewing_date: date
  viewing_time: time
  questions_for_agent: text — what to ask property manager
  notes: text — additional notes
  status: enum('requested', 'assigned', 'pending_acceptance', 'accepted', 'rejected', 'expired', 'completed', 'cancelled')
  viewer_response: text — reason if rejected
  viewer_responded_at: timestamptz
  assigned_at: timestamptz
  assignment_expiry: timestamptz — 24h from assignment
  created_at: timestamptz

consultations
  id: uuid (PK)
  customer_id: uuid (FK → users)
  scheduled_date: date
  scheduled_time: time
  meeting_link: text — Zoom/Meet link (admin adds)
  status: enum('pending', 'confirmed', 'completed', 'cancelled', 'rescheduled')
  notes: text
  created_at: timestamptz
```

**Registration Flow:** Single sign-up → create user → select role(s) → fill role-specific profile. Admin accounts created manually in Supabase dashboard (no public admin signup).

---

## 2. Project Architecture

### Tech Stack

| Layer | Technology | Why |
|-------|-----------|-----|
| Frontend | Next.js 14 (App Router) | Modern, SSR/SSG, great for portfolio |
| Styling | Tailwind CSS + shadcn/ui | Clean, accessible, fast to build |
| Database | Supabase (PostgreSQL) | Free tier, real-time, auth built-in |
| Auth | Supabase Auth | Email/password, JWT, RLS policies |
| Image Storage | AWS S3 (Free Tier: 5GB/12mo) | License docs, listing photos, car photos |
| Hosting | Vercel | Free tier, deploys from GitHub |
| Calendar | iCal (.ics) export | Free, universal, works with any calendar |
| WhatsApp | wa.me deep links | Free, no API cost, pre-populated messages |

### Project Structure

```
nzsettle/
├── .env.local                    # Never committed
├── .env.example                  # Template with placeholder values
├── .gitignore                    # Includes .env.local
├── next.config.js
├── tailwind.config.js
├── package.json
├── README.md                     # Project overview + credits notice
├── supabase/
│   └── migrations/               # SQL migration files
│       ├── 001_users_and_roles.sql
│       ├── 002_customer_profiles.sql    # customer_profiles + customer_children
│       ├── 003_home_owner_profiles.sql
│       ├── 004_car_owner_profiles.sql
│       ├── 005_listings.sql
│       ├── 006_consultations.sql
│       ├── 007_viewings.sql
│       ├── 008_airport_pickups.sql
│       └── 009_notifications.sql
├── src/
│   ├── app/
│   │   ├── layout.tsx            # Root layout with nav
│   │   ├── page.tsx              # Landing page (guest-friendly, includes testimonials)
│   │   ├── (auth)/
│   │   │   ├── login/page.tsx
│   │   │   ├── register/page.tsx
│   │   │   └── register/role/page.tsx
│   │   ├── dashboard/
│   │   │   ├── layout.tsx        # Dashboard layout (sidebar nav)
│   │   │   ├── page.tsx          # Role-based redirect
│   │   │   ├── admin/            # Admin dashboard (sees all watchlists)
│   │   │   ├── customer/         # Customer dashboard
│   │   │   │   ├── page.tsx      # Customer overview
│   │   │   │   ├── watchlist/    # Personal watchlist (max 10)
│   │   │   │   └── bookings/     # Bookings from watchlist
│   │   │   ├── room-owner/       # Room owner dashboard (sees own listings only)
│   │   │   ├── car-owner/        # Car owner dashboard (sees own listing only)
│   │   │   └── viewer/           # Viewer/helper dashboard
│   │   ├── consultation/
│   │   │   ├── book/page.tsx     # Client booking form
│   │   │   └── [id]/page.tsx     # Booking confirmation
│   │   ├── rooms/
│   │   │   ├── page.tsx          # Browse all room listings (guests can view)
│   │   │   ├── [id]/page.tsx     # Room detail (contact hidden for guests)
│   │   │   └── new/page.tsx      # Add room listing (room_owner/admin)
│   │   ├── cars/
│   │   │   ├── page.tsx          # Browse car listings (guests can view)
│   │   │   └── [id]/page.tsx     # Car detail (contact hidden for guests)
│   │   ├── viewings/
│   │   │   ├── book/page.tsx     # Book a viewing
│   │   │   └── [id]/page.tsx     # Viewing detail/status
│   │   └── airport-pickup/
│   │       ├── request/page.tsx  # Request pickup
│   │       └── [id]/page.tsx     # Pickup detail
│   ├── components/
│   │   ├── ui/                   # shadcn/ui components
│   │   ├── layout/               # Header, Sidebar, Footer
│   │   ├── forms/                # Booking forms, intake forms
│   │   ├── calendar/             # Availability picker, schedule view
│   │   ├── listings/             # Listing cards, filters
│   │   ├── cars/                 # Car listing cards, filters
│   │   ├── upload/               # Image upload components (S3)
│   │   ├── guest-gate/           # "Register to contact" overlay
│   │   └── notifications/        # Notification bell, toast messages
│   ├── lib/
│   │   ├── supabase/
│   │   │   ├── client.ts         # Browser client
│   │   │   ├── server.ts         # Server client (for SSR/API routes)
│   │   │   └── middleware.ts     # Auth middleware
│   │   ├── s3.ts                 # AWS S3 upload/download helpers
│   │   ├── wa.ts                 # wa.me link generator
│   │   ├── ical.ts               # iCal .ics file generator
│   │   ├── nz-regions.ts         # NZ regions + districts data
│   │   └── utils.ts              # Shared helpers
│   ├── api/
│   │   ├── auth/
│   │   │   └── [...]/route.ts    # Auth callbacks
│   │   ├── upload/
│   │   │   ├── listing/route.ts  # Upload listing images (max 5) — room_owner, admin
│   │   │   ├── car/route.ts      # Upload car photos (max 3) — car_owner, admin
│   │   │   └── license/route.ts  # Upload license front/back — car_owner only
│   │   ├── listings/
│   │   │   └── route.ts          # CRUD listings — role-based
│   │   ├── viewings/
│   │   │   └── route.ts          # CRUD viewings — role-based
│   │   ├── pickups/
│   │   │   └── route.ts          # CRUD airport pickups — role-based
│   │   ├── consultations/
│   │   │   └── route.ts          # CRUD consultations — role-based
│   │   └── presign/
│   │       └── route.ts          # S3 presigned URL generator — authenticated only
│   ├── types/
│   │   └── database.ts           # Generated Supabase types
│   └── hooks/
│       ├── useAuth.ts            # Auth state hook
│       ├── useUpload.ts          # S3 upload hook
│       └── useNotifications.ts   # Real-time notifications
├── public/
│   └── images/
└── CLAUDE.md                     # Claude Code project instructions
```

---

## 3. Project Standards

### Skills Files (Claude Code)

Project skills are in `.claude/skills/`:

- `frontend.md` — Coding standards, component patterns, TypeScript conventions
- `git-workflow.md` — Branch strategy, commit messages, PR process
- `dev-setup.md` — Environment setup, Supabase, S3 configuration
- `testing.md` — Testing guidelines, patterns, coverage goals

### GitHub Templates

Project templates are in `.github/`:

- `ISSUE_TEMPLATE/bug.md` — Bug report template
- `ISSUE_TEMPLATE/task.md` — Feature/task request template
- `pull_request_template.md` — PR description template
- `CODEOWNERS` — Code ownership (Sandar as owner)
- `workflows/ci.yml` — CI/CD pipeline (lint, test, build)
- `workflows/security.yml` — Security scanning (dependencies, codeql, secrets)

### Task Management

All tasks are managed via **GitHub Issues** (not local files). Use the task template when creating issues.

---

## 4. Database Migrations (Supabase SQL)

All migrations go in `supabase/migrations/`. Run in order:

1. `001_users_and_roles.sql` — users, user_roles, role enum
2. `002_customer_profiles.sql` — customer_profiles, customer_children
3. `003_room_owner_profiles.sql` — room_owner_profiles
4. `004_car_owner_profiles.sql` — car_owner_profiles (includes license URLs, car_photos)
5. `005_viewer_profiles.sql` — viewer_profiles
6. `006_availability.sql` — availability (shared by car_owner and viewer)
7. `007_regions_and_districts.sql` — NZ regions + districts reference data
8. `008_room_listings.sql` — room_listings + room_listing_images (all detailed fields)
9. `009_consultations.sql` — consultations, availability_slots
10. `010_viewings.sql` — viewings (linked to listing + client + viewer)
11. `011_airport_pickups.sql` — airport_pickups (linked to client + driver)
12. `012_notifications.sql` — in-app notifications
13. `013_customer_watchlist.sql` — customer_watchlist (personal property tracking)

---

## 5. Hosting & Deployment

| Service | Tier | Purpose |
|---------|------|---------|
| **GitHub** | Public repo | Source control, portfolio visibility |
| **Vercel** | Free | Next.js hosting, auto-deploys from main branch |
| **Supabase** | Free (500MB DB, 1GB storage) | Database, auth, storage, real-time |
| **Cloudflare** (optional) | Free | Custom domain later |

### Environment Variables (never committed)

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...    # Server-side only

AWS_ACCESS_KEY_ID=...            # S3 image uploads
AWS_SECRET_ACCESS_KEY=...        # S3 image uploads
AWS_REGION=ap-southeast-2        # Sydney region (closest to NZ)
S3_BUCKET_NAME=...               # nzsettle-images
NEXT_PUBLIC_S3_BASE_URL=...      # Public S3 bucket URL for images
```

### .gitignore includes:
- `.env.local`
- `.env`
- `node_modules/`
- `.next/`

---

## 6. API Security

All API endpoints MUST implement:

1. **Authentication** — Verify user is logged in
2. **Authorization** — Check user role before allowing action
3. **Input Validation** — Use zod schema for all inputs
4. **Rate Limiting** — 100 requests/minute per user
5. **CSRF Protection** — Supabase RLS or CSRF tokens
6. **Error Handling** — Generic errors, don't expose internals
7. **Logging** — Log suspicious activity
8. **Data Ownership** — Users access only their own data (admin override)

### Role-Based Access Patterns

```typescript
// Admin only
if (role !== 'admin') return 403

// Owner or admin
if (resource.owner_id !== user.id && role !== 'admin') return 403

// Any authenticated user
if (!user) return 401

// Specific roles allowed
const allowedRoles = ['admin', 'room_owner', 'customer']
if (!allowedRoles.includes(role)) return 403
```

---

## 7. WhatsApp Integration (wa.me)

All WhatsApp messaging goes through **wa.me deep links** — zero API cost, works on any phone.

### How it works:
1. System generates a wa.me URL with pre-filled message
2. User clicks the link → opens WhatsApp on their phone
3. They review the pre-filled message → hit send

### wa.me Link Format:
```
https://wa.me/{phone_number}?text={encoded_message}
```

### Message Templates:

**Consultation booked (notify admin):**
```
📋 New Consultation Booking
Client: {name}
Date: {date} at {time}
Budget: ${min} - ${max}
Family: {size} members
Move-in: {date}
```

**Viewing assigned (notify viewer):**
```
🏠 Viewing Assignment
Property: {address}
Client: {client_name}
Date: {date} at {time}
Questions to ask: {questions}
```

**Pickup assigned (notify driver):**
```
🚗 Airport Pickup Assignment
Passenger: {name}
Flight: {flight_number}
Date: {date}
Passengers: {adults} adults, {children} children
Luggage: {luggage_count} bags
Pickup: {airport}
Drop-off: {address}
Estimated price: ${price}
```

**Consultation confirmed (notify client):**
```
✅ Consultation Confirmed
Date: {date} at {time}
Meeting link: {zoom_link}
Notes: {message}
```

---

## 8. Calendar (iCal)

Each booking generates an `.ics` file for download. Contains:
- Event title (e.g., "Consultation with [Client Name]")
- Date/time with timezone (Pacific/Auckland)
- Location or meeting link
- Description with full details

Users add it to their phone calendar (iPhone Calendar, Google Calendar, Outlook) by downloading the .ics file.

---

## 9. Build Order (Delegation Split)

### Phase 1 — Foundation (Week 1-2)
| Task | Agent | Depends On |
|------|-------|------------|
| Initialize Next.js + Tailwind + shadcn/ui | Claude | — |
| Set up Supabase project + migrations | Claude | — |
| Set up AWS S3 bucket + upload utility | Claude | — |
| Auth flow (register, login, middleware) | Claude | Supabase |
| Dashboard layout + role-based nav | Claude | Auth |
| Guest access — public listing pages | Claude | Auth |

### Phase 2 — Core Features (Week 3-5)
| Task | Agent | Depends On |
|------|-------|------------|
| Client intake form + admin management | Claude | Auth |
| Availability system + consultation booking | Claude | Auth |
| wa.me notification utility | Claude | — |
| iCal export utility | Claude | — |
| Listings CRUD + browse (guest accessible) | Claude | Auth, S3 |
| Car listings browse + detail (guest accessible) | Claude | Auth, S3 |
| Image upload components (listing, car, license) | Claude | S3 |
| Viewing request + assignment flow | Claude | Listings |
| Airport pickup request + assignment | Claude | Auth |

### Phase 3 — Polish (Week 6-7)
| Task | Agent | Depends On |
|------|-------|------------|
| Admin dashboard (overview, stats) | Claude | All features |
| In-app notifications | Claude | All features |
| Search, filters, UX polish | Claude | All features |
| README + portfolio documentation | Claude | All features |

---

## 10. Git Setup

```bash
# Initialize in the nzsettle folder
git init
git add .
git commit -m "Initial commit: project setup with Next.js + Supabase"
gh repo create nzsettle --public --source=. --push
```

### Branch Strategy:
- `main` — production (Vercel auto-deploys)
- `develop` — active development
- Feature branches: `feature/auth`, `feature/listings`, etc.

### README.md includes:
- Project description
- Tech stack
- How to run locally (with .env.example)
- Credits/copyright notice for forks
- Screenshots/demo link (later)

---

## 11. Future Phases (Not MVP)

- Community forum / chat
- Payment processing (consultation fees, pickup payments)
- Rating/review system
- WhatsApp Business API integration (automated messages)
- Mobile app (React Native)
- Listing scraping/automation (auto-pull from TradeMe)
- Admin analytics dashboard
- Multi-language support (Burmese, Mandarin, etc.)

---

## 12. Verification

After build, verify:
1. Register a test user → select customer role → fill profile
2. Book a consultation → check wa.me link generates correctly
3. Admin sees the booking → assigns a viewing → wa.me link works
4. Browse room listings as GUEST → see all details but contact info hidden
5. Register → browse room listings → see contact info after booking
6. Room owner creates listing → max 3 active listings enforced
7. Upload 5 photos to listing → max 5 enforced
8. Car owner uploads license front/back + 3 car photos → all stored in S3
9. Car owner sets availability (Mon-Fri, Morning/Afternoon)
10. Viewer sets availability (Wed-Sat, Afternoon/Evening)
11. Filter rooms by region → district cascading works
12. Filter rooms by price, utilities, bathroom type, furnished, etc.
13. Request airport pickup → see price estimate → admin assigns driver
14. Download .ics file → opens in calendar app
15. In-app notifications appear for all events
16. Role-based access: guest can't access admin, customer can't manage listings
