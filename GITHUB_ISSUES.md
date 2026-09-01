# GitHub Issues for NZSettle

---

## Phase 1: Foundation (Week 1-2)

### Issue 1: Initialize Next.js 14 Project

**Title:** `feat: Initialize Next.js 14 project with TypeScript and Tailwind`
**Labels:** `phase-1`, `setup`
**Description:**

- Create Next.js 14 App Router project
- Configure TypeScript
- Set up Tailwind CSS
- Add shadcn/ui components
- Configure ESLint and Prettier
- Create .env.example with required variables

**Acceptance Criteria:**

- [ ] `npm run dev` starts successfully
- [ ] `npm run build` passes
- [ ] `npm run lint` passes
- [ ] TypeScript configured
- [ ] Tailwind working
- [ ] shadcn/ui installed

---

### Issue 2: Set Up Supabase Connection

**Title:** `feat: Set up Supabase client and environment variables`
**Labels:** `phase-1`, `setup`, `database`
**Description:**

- Create Supabase project (if not done)
- Set up environment variables
- Create Supabase client for browser and server
- Test connection
- Create initial tables (users, roles)

**Acceptance Criteria:**

- [ ] Supabase client created
- [ ] Environment variables working
- [ ] Database connection tested
- [ ] Auth initialized

**Acceptance Criteria:**

- [ ] Supabase client initialized
- [ ] Environment variables loaded
- [ ] Connection test successful
- [ ] Database tables created

---

### Issue 3: Create Database Migrations

**Title:** `feat: Create initial database schema and migrations`
**Labels:** `phase-1`, `database`
**Description:**

- Create migration files for:
  - users table
  - user_roles table (enum: admin, registered, customer, home_owner, car_owner, viewing_helper)
  - customer_profiles table
  - home_owner_profiles table
  - car_owner_profiles table
  - viewing_helper_profiles table
- Set up Row Level Security (RLS) policies

**Acceptance Criteria:**

- [ ] All tables created
- [ ] RLS policies configured
- [ ] Migrations run successfully
- [ ] Test data insertable

---

### Issue 4: Set Up AWS S3 for Image Storage

**Title:** `feat: Configure AWS S3 bucket for image uploads`
**Labels:** `phase-1`, `setup`, `storage`
**Description:**

- Create S3 bucket (nzsettle-images)
- Set up presigned URLs for direct browser upload
- Create API routes for image upload
- Configure CORS for frontend access
- Test upload flow

**Acceptance Criteria:**

- [ ] S3 bucket created
- [ ] Presigned URL generation working
- [ ] Upload API route created
- [ ] Image upload tested

---

### Issue 5: Create Authentication Pages

**Title:** `feat: Build login, register, and password reset pages`
**Labels:** `phase-1`, `auth`, `ui`
**Description:**

- Create login page with email/password
- Create registration page with:
  - Email + password + full name
  - WhatsApp number (optional)
- Create forgot password page
- Create reset password page
- Add email confirmation flow
- Style with shadcn/ui components

**Acceptance Criteria:**

- [ ] Login page working
- [ ] Registration page working
- [ ] Email confirmation sent
- [ ] Password reset flow working
- [ ] Form validation with zod
- [ ] Responsive design

---

### Issue 6: Create Auth Middleware

**Title:** `feat: Implement authentication middleware and role-based access`
**Labels:** `phase-1`, `auth`, `security`
**Description:**

- Create Next.js middleware for auth
- Protect dashboard routes
- Add role-based redirects
- Handle unauthenticated users
- Add origin checking for API routes

**Acceptance Criteria:**

- [ ] Middleware protecting routes
- [ ] Unauthenticated users redirected to login
- [ ] Role-based access working
- [ ] Origin checking implemented

---

## Phase 2: Core Features (Week 3-5)

### Issue 7: Build Landing Page

**Title:** `feat: Create landing page with hero, features, and testimonials`
**Labels:** `phase-2`, `ui`, `marketing`
**Description:**

- Hero section with call-to-action
- Features section (for tenants, viewing helpers, home owners, car owners)
- Impact statistics (60+ services, 20+ pickups, 5+ helpers, 5+ car owners, 5+ home owners)
- Testimonials section (static images)
- Footer with links
- Mobile responsive

**Acceptance Criteria:**

- [ ] Hero section with CTA
- [ ] Features section complete
- [ ] Impact stats displayed
- [ ] Testimonials section
- [ ] Mobile responsive
- [ ] Fast loading

---

### Issue 8: Create Dashboard Layout

**Title:** `feat: Build role-based dashboard layout with sidebar navigation`
**Labels:** `phase-2`, `ui`, `dashboard`
**Description:**

- Dashboard layout with sidebar
- Role-based navigation (different menus per role)
- Header with user info and notifications
- Mobile responsive sidebar
- Role-based redirects on login

**Acceptance Criteria:**

- [ ] Dashboard layout working
- [ ] Sidebar navigation complete
- [ ] Role-based menu items
- [ ] Mobile responsive
- [ ] Notifications bell icon

---

### Issue 9: Room Listings Page

**Title:** `feat: Build room listings browse page with filters`
**Labels:** `phase-2`, `feature`, `listings`
**Description:**

- Public page showing all active listings
- Filter by region (cascading dropdown)
- Filter by district (based on selected region)
- Filter by price range
- Filter by utilities (power, water, wifi)
- Filter by bathroom type
- Filter by furnished/unfurnished
- Listing cards with primary image
- Pagination
- Contact info hidden for guests

**Acceptance Criteria:**

- [ ] Listings displayed correctly
- [ ] All filters working
- [ ] Cascading region/district dropdown
- [ ] Pagination working
- [ ] Contact hidden for guests
- [ ] Mobile responsive

---

### Issue 10: Room Listing Detail Page

**Title:** `feat: Build room listing detail page`
**Labels:** `phase-2`, `feature`, `listings`
**Description:**

- Full listing details
- Image gallery (up to 5 photos)
- All property information displayed
- Contact info (shown only to registered users)
- "Register to contact" overlay for guests
- School zones displayed
- Availability information
- Share functionality

**Acceptance Criteria:**

- [ ] All details displayed
- [ ] Image gallery working
- [ ] Contact hidden for guests
- [ ] Registration overlay for guests
- [ ] Mobile responsive

---

### Issue 11: Home Owner Dashboard

**Title:** `feat: Build home owner dashboard for managing listings`
**Labels:** `phase-2`, `dashboard`, `feature`
**Description:**

- Dashboard showing own listings only (max 3)
- Create new listing form (40+ fields)
- Edit existing listing
- Delete listing (if no active bookings)
- Upload photos (max 5)
- View listing status (pending_review, active, rejected)

**Acceptance Criteria:**

- [ ] Own listings displayed
- [ ] Create listing form working
- [ ] Edit listing working
- [ ] Delete listing working
- [ ] Photo upload working
- [ ] Status displayed correctly

---

### Issue 12: Car Owner Registration

**Title:** `feat: Build car owner profile and vehicle registration`
**Labels:** `phase-2`, `feature`, `car-owner`
**Description:**

- Car owner profile form
- Vehicle details (make, model, year, capacity)
- Child seat availability
- License upload (front + back, S3)
- Car photos (max 3, S3)
- Availability settings (Mon-Sun × Morning/Afternoon/Evening)
- Verification status display

**Acceptance Criteria:**

- [ ] Profile form working
- [ ] Vehicle details saved
- [ ] License upload working
- [ ] Car photos upload working
- [ ] Availability settings saved
- [ ] Verification status displayed

---

### Issue 13: Viewing Helper Profile

**Title:** `feat: Build viewing helper profile and availability`
**Labels:** `phase-2`, `feature`, `viewing-helper`
**Description:**

- Viewing helper profile form
- Bio and experience
- Availability settings (Mon-Sun × Morning/Afternoon/Evening)
- Hourly rate (optional)
- Accept/reject viewing assignments
- View assigned viewings

**Acceptance Criteria:**

- [ ] Profile form working
- [ ] Availability settings saved
- [ ] Can accept/reject assignments
- [ ] Assigned viewings displayed
- [ ] Mobile responsive

---

### Issue 14: Consultation Booking Form

**Title:** `feat: Build consultation booking form for customers`
**Labels:** `phase-2`, `feature`, `booking`
**Description:**

- Customer requests consultation
- Form fields:
  - Preferred date/time
  - Meeting link (Zoom/Meet)
  - Notes/questions
- Confirmation page
- Admin notification (wa.me)
- Calendar event (.ics export)

**Acceptance Criteria:**

- [ ] Booking form working
- [ ] Confirmation page displayed
- [ ] Admin notified via wa.me
- [ ] .ics file downloadable
- [ ] Form validation working

---

### Issue 15: Viewing Booking Form

**Title:** `feat: Build viewing booking form for customers`
**Labels:** `phase-2`, `feature`, `booking`
**Description:**

- Customer requests viewing from watchlist
- Form fields:
  - Select listing from watchlist
  - Preferred date/time
  - Questions for agent
  - Notes
- Admin assigns viewing helper
- Viewing helper notified (wa.me)
- Viewing helper accepts/rejects
- Status tracking (requested → assigned → accepted → completed)

**Acceptance Criteria:**

- [ ] Booking form working
- [ ] Admin can assign viewing helper
- [ ] Viewing helper notified
- [ ] Accept/reject working
- [ ] Status tracking working
- [ ] .ics file downloadable

---

### Issue 16: Airport Pickup Request

**Title:** `feat: Build airport pickup request form`
**Labels:** `phase-2`, `feature`, `pickup`
**Description:**

- Customer requests airport pickup
- Form fields:
  - Flight number
  - Flight date/time
  - Number of adults/children
  - Child seats needed
  - Luggage count
  - Pickup location (airport)
  - Dropoff address
  - Special requests
- Price estimation
- Admin assigns car owner
- Car owner notified (wa.me)
- Car owner accepts/rejects

**Acceptance Criteria:**

- [ ] Request form working
- [ ] Price estimation calculated
- [ ] Admin can assign car owner
- [ ] Car owner notified
- [ ] Accept/reject working
- [ ] Status tracking working

---

### Issue 17: Customer Watchlist

**Title:** `feat: Build customer watchlist for property tracking`
**Labels:** `phase-2`, `feature`, `watchlist`
**Description:**

- Customer can add properties to watchlist (max 10)
- Form fields:
  - Title, source URL
  - Location (region, district, address)
  - Pricing (rent, bond, advance)
  - Utilities (power, water, wifi)
  - Property details (beds, baths, living, parking, furnished)
  - Availability
  - Agent info (name, email, phone, agency)
  - Notes
- Status tracking (interested → viewing_booked → viewed → application_submitted → shortlisted/rejected)
- Create viewing booking from watchlist
- Edit/delete watchlist items

**Acceptance Criteria:**

- [ ] Add watchlist item working
- [ ] Max 10 items enforced
- [ ] All fields saved
- [ ] Status tracking working
- [ ] Can create viewing from watchlist
- [ ] Edit/delete working
- [ ] Mobile responsive

---

### Issue 18: Availability System

**Title:** `feat: Build availability settings for viewing helpers and car owners`
**Labels:** `phase-2`, `feature`, `availability`
**Description:**

- Availability picker component
- Days: Mon, Tue, Wed, Thu, Fri, Sat, Sun
- Times: Morning, Afternoon, Evening
- Toggle available/unavailable
- Save availability to database
- Display availability in profile

**Acceptance Criteria:**

- [ ] Availability picker working
- [ ] All days/times selectable
- [ ] Save functionality working
- [ ] Display in profile working
- [ ] Mobile responsive

---

## Phase 3: Polish (Week 6-7)

### Issue 19: Notification System

**Title:** `feat: Build in-app notification system`
**Labels:** `phase-3`, `feature`, `notifications`
**Description:**

- Bell icon in header
- Unread count badge
- Notification list page
- Mark as read/unread
- Notification types:
  - Viewing assigned
  - Pickup assigned
  - Consultation confirmed
  - Booking status changes

**Acceptance Criteria:**

- [ ] Bell icon working
- [ ] Unread count displayed
- [ ] Notification list page
- [ ] Mark as read working
- [ ] All notification types implemented

---

### Issue 20: WhatsApp Integration

**Title:** `feat: Implement wa.me deep links for notifications`
**Labels:** `phase-3`, `feature`, `notifications`
**Description:**

- Generate wa.me deep links with pre-filled messages
- Message templates:
  - Viewing assignment → notify viewing helper
  - Pickup assignment → notify car owner
  - Consultation booked → notify admin
  - Consultation confirmed → notify customer
- Open in WhatsApp on click
- Log notification sent

**Acceptance Criteria:**

- [ ] wa.me links generated correctly
- [ ] Pre-filled messages working
- [ ] Opens WhatsApp on click
- [ ] Notifications logged

---

### Issue 21: iCal Export

**Title:** `feat: Add iCal (.ics) file export for bookings`
**Labels:** `phase-3`, `feature`, `calendar`
**Description:**

- Generate .ics files for:
  - Consultation bookings
  - Viewing bookings
  - Airport pickups
- Include all event details
- Download button on booking pages
- Works with Google Calendar, Outlook, Apple Calendar

**Acceptance Criteria:**

- [ ] .ics files generated
- [ ] All event types covered
- [ ] Download working
- [ ] Calendar apps can open files

---

### Issue 22: Admin Dashboard

**Title:** `feat: Build admin dashboard for managing platform`
**Labels:** `phase-3`, `dashboard`, `admin`
**Description:**

- Overview stats (total users, listings, bookings)
- User management (view, approve, reject roles)
- Listing management (review, approve, reject)
- Booking management (assign viewing helpers, car owners)
- View all customer watchlists
- Content moderation (review uploaded images)

**Acceptance Criteria:**

- [ ] Stats displayed correctly
- [ ] User management working
- [ ] Listing approval working
- [ ] Booking assignment working
- [ ] Watchlist viewing working
- [ ] Image moderation working

---

### Issue 23: Role Request System

**Title:** `feat: Build role request and approval system`
**Labels:** `phase-3`, `feature`, `auth`
**Description:**

- Registered users can request roles:
  - Request consultation → becomes customer
  - Request viewing helper role
  - Request home owner role
  - Request car owner role
- Admin reviews requests
- Approve/reject with reason
- Email notification on approval/rejection
- Status tracking (pending → approved/rejected)

**Acceptance Criteria:**

- [ ] Role request form working
- [ ] Admin can view requests
- [ ] Approve/reject working
- [ ] Notifications sent
- [ ] Status tracking working

---

### Issue 24: Content Moderation

**Title:** `feat: Implement content moderation for listings and images`
**Labels:** `phase-3`, `feature`, `moderation`
**Description:**

- All listings go through pending_review
- Admin reviews listing details
- Admin reviews uploaded images
- Approve/reject with feedback
- Rejected listings show reason
- Flag inappropriate content

**Acceptance Criteria:**

- [ ] Listings pending by default
- [ ] Admin review interface working
- [ ] Image review working
- [ ] Approval/rejection working
- [ ] Flag system working

---

### Issue 25: NZ Regions and Districts Data

**Title:** `feat: Populate NZ regions and districts reference data`
**Labels:** `phase-1`, `database`, `setup`
**Description:**

- Create regions table (15 NZ regions)
- Create districts table (cascading from regions)
- Populate with real NZ data
- Use for cascading dropdowns

**Acceptance Criteria:**

- [ ] Regions table created
- [ ] Districts table created
- [ ] All 15 regions populated
- [ ] Districts linked to regions
- [ ] Cascading dropdown working

---

## Labels to Create

| Label                   | Color                 | Description                      |
| ----------------------- | --------------------- | -------------------------------- |
| `phase-1`               | #0E8A16               | Foundation tasks (Week 1-2)      |
| `phase-2`               | #1D76DB               | Core features (Week 3-5)         |
| `phase-3`               | #D93F0B               | Polish tasks (Week 6-7)          |
| `setup`                 | #FBCA04               | Project setup and configuration  |
| `auth`                  | #D73A4A               | Authentication and authorization |
| `database`              | #5C54FF               | Database and migrations          |
| `ui`                    | #0075CA               | User interface components        |
| `feature`               | #A2EEEF               | New features                     |
| `security`              | #EE0701               | Security-related tasks           |
| `bug`                   | #D73A4A               | Bug fixes                        |
| `documentation` #0075CA | Documentation updates |

---

## Bulk Labels Create (Script)

Run Bulk Script for creating labels, `.scripts/create-labels.sh`

Labels Created (26 total)

- Phase Labels: phase-1, phase-2, phase-3
- Feature Types: setup, database, auth, ui, feature, dashboard, security, storage
- Role Labels: customer, home-owner, car-owner, viewing-helper, admin
- Feature-Specific: listings, booking, pickup, watchlist, availability, notifications, calendar, moderation, marketing

---

## How to Create These Issues

### Option 1: Manual (GitHub Website)

1. Go to your repo: https://github.com/sandarma/nzsettle
2. Click **Issues** tab
3. Click **New issue**
4. Copy title and description from above
5. Add labels
6. Click **Submit new issue**

### Option 2: GitHub CLI (Faster)

```bash
# Install GitHub CLI (if not installed)
brew install gh

# Login
gh auth login

# Create issue
gh issue create --title "feat: Initialize Next.js 14 project" --label "phase-1,setup" --body "Description here..."
```

### Option 3: Bulk Issues Create (Script)

Run Bulk Script for creating issues, `.scripts/create-issues.sh`

---

## After Creating Issues

1. **Create a Project Board**

   - Go to **Projects** tab
   - Click **New project**
   - Choose **Board** view
   - Create columns: Todo, In Progress, Review, Done

2. **Add Issues to Project**

   - Drag issues to appropriate columns
   - Start with Phase 1 issues

3. **Start Building!**
   - Begin with Issue 1: Initialize Next.js
   - Work through Phase 1 first
   - Move to Phase 2 after foundation is ready
