# Rental Platform — Project Context

## What This Is

A rental assistance platform for international newcomers to Auckland, NZ. Currently Sandar manages everything manually (WhatsApp, text files, calendar). This platform automates and scales it, and will eventually be published for community use.

**Owner:** Sandar (AUT master's student, Myanmar/Singapore origin, helping Burmese community in Auckland)

## Tech Stack

- **Frontend:** Next.js 14 (App Router) + TypeScript + Tailwind CSS + shadcn/ui
- **Database:** Supabase (PostgreSQL) — free tier
- **Auth:** Supabase Auth — email/password, JWT, RLS
- **Image Storage:** AWS S3 — free tier (5GB/12mo)
- **Hosting:** Vercel — free tier
- **Calendar:** iCal (.ics) export
- **WhatsApp:** wa.me deep links (free, no API cost)
- **Git:** Public GitHub repo (portfolio visibility)

## User Roles

| Role | Who | Can Do |
|------|-----|--------|
| guest | Not logged in | Browse room + car listings (NO contact info) |
| admin | Sandar | Everything |
| registered | Anyone | Browse with contact info, request roles |
| customer | Your clients | Book consultation, viewings, airport pickup |
| home_owner | Community members | List rooms (max 3), upload photos (max 5) |
| car_owner | Community members | Set availability, accept pickups, upload license |
| viewing_helper | Community members | View assigned viewing requests |

**Multi-role:** One user table, separate role profiles. Admin is separate. Others can combine.

## Key Features

1. **Room Listings** — Detailed fields: region/district, rent/week, utilities, bathroom, flatmate prefs, facilities, school zones
2. **Car Listings** — Vehicle info, capacity, child seat, license verification
3. **Consultation Booking** — Client intake → book consultation → then viewings unlock
4. **Viewing Assignment** — Admin assigns viewing_helper, wa.me notification with pre-filled details
5. **Airport Pickup** — Client requests → admin assigns car_owner, price estimate
6. **Availability System** — viewing_helper + car_owner set day/time slots (Mon-Sun × Morning/Afternoon/Evening)
7. **Guest Access** — Public can browse listings, contact info hidden until registered
8. **iCal Export** — .ics files for all bookings
9. **In-app Notifications** — Bell icon, unread count

## WhatsApp Integration (wa.me)

All notifications use wa.me deep links (free, no API). System generates pre-filled messages:
- Consultation booked → notify admin
- Viewing assigned → notify viewing_helper with property details
- Pickup assigned → notify car_owner with passenger details
- Consultation confirmed → notify client with meeting link

## Room Listing Fields

**Location:** Region → District (cascading dropdown, 15 NZ regions)
**Pricing:** Rent/week, bond (x weeks), rent advance (x weeks)
**Utilities:** Power included? Water included? WiFi (unlimited/limited/none)?
**Room:** Property type, bed size, furnished, car parking
**Bathroom:** Private/shared, count, shared with how many
**Preferences:** Couples ok? Family ok? Prefer single? Smokers ok? Pets ok?
**Facilities:** Washing machine, dryer, kitchen, fridge, microwave, dishwasher, kitchenware
**Availability:** Available from/now, notice required (x weeks)
**School Zones:** Array of school names in zone

## Image Storage (AWS S3)

- Room photos: max 5 per listing
- Car photos: max 3
- License: front + back (required for car owners)
- Bucket: `nzsettle-images` (ap-southeast-2)
- Presigned URLs for direct browser upload

## Environment Variables (never committed)

```
NEXT_PUBLIC_SUPABASE_URL=...
NEXT_PUBLIC_SUPABASE_ANON_KEY=...
SUPABASE_SERVICE_ROLE_KEY=...
AWS_ACCESS_KEY_ID=...
AWS_SECRET_ACCESS_KEY=...
AWS_REGION=ap-southeast-2
S3_BUCKET_NAME=nzsettle-images
NEXT_PUBLIC_S3_BASE_URL=...
```

## Project Structure

```
nzsettle/
├── supabase/migrations/     # SQL migrations (run in order)
├── src/app/                 # Next.js pages (App Router)
├── src/components/          # React components
├── src/lib/                 # Utilities (S3, wa.me, iCal, NZ regions)
├── src/api/                 # API routes (upload, presign)
├── src/types/               # TypeScript types
└── src/hooks/               # React hooks
```

## Rules for Claude

1. **Always explain** architectural decisions before implementing
2. **Ask for input** on key choices — Sandar is learning while building
3. **Check memory files** before starting work — they contain project context
4. **No PRs needed** — just Sandar and Claude working together
5. **Careful before production** — test thoroughly, explain risks
6. **Use free tiers** — budget is minimal
7. **Portfolio quality** — this is for NZ job applications

## API Security Requirements

When building API endpoints, ALWAYS implement:

1. **Role-Based Access Control (RBAC)** — Check user role before allowing action
2. **Authentication** — Verify user is logged in (Supabase auth)
3. **Authorization** — User can only access their own data + admin override
4. **Rate Limiting** — Prevent abuse (e.g., 100 requests/minute per user)
5. **Input Validation** — Validate and sanitize all inputs (zod schema)
6. **CSRF Protection** — Use Supabase RLS or CSRF tokens
7. **Error Handling** — Don't expose internal errors to client
8. **Logging** — Log suspicious activity for security review

## Content Moderation

To prevent abuse:

1. **User Approval** — home_owner, car_owner, viewing_helper require admin approval
2. **Listing Approval** — All listings go through `pending_review` before going live
3. **Image Validation** — Only `.jpg`, `.jpeg`, `.png`, `.webp` allowed, max 5MB
4. **Manual Review** — Admin reviews all uploaded images before listing approval
5. **Report System** — Users can flag inappropriate content for admin review
6. **Account Suspension** — Admin can suspend/ban accounts for violations

### Example API Route Pattern

```typescript
// src/api/listings/route.ts
import { createServerClient } from '@/lib/supabase/server'
import { NextResponse } from 'next/server'
import { z } from 'zod'

const createListingSchema = z.object({
  title: z.string().min(1).max(100),
  rent_per_week: z.number().positive(),
  // ... other fields
})

export async function POST(request: Request) {
  const supabase = createServerClient()
  
  // 1. Check authentication
  const { data: { user }, error: authError } = await supabase.auth.getUser()
  if (authError || !user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }
  
  // 2. Check role authorization
  const { data: role } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', user.id)
    .single()
  
  if (!role || !['admin', 'home_owner'].includes(role.role)) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 })
  }
  
  // 3. Validate input
  const body = await request.json()
  const validatedData = createListingSchema.parse(body)
  
  // 4. Check business rules (e.g., max 3 listings per owner)
  const { count } = await supabase
    .from('room_listings')
    .select('*', { count: 'exact', head: true })
    .eq('owner_id', user.id)
    .eq('status', 'active')
  
  if (count && count >= 3) {
    return NextResponse.json({ error: 'Maximum 3 active listings' }, { status: 400 })
  }
  
  // 5. Create listing
  const { data, error } = await supabase
    .from('room_listings')
    .insert({ ...validatedData, owner_id: user.id })
    .select()
    .single()
  
  if (error) {
    return NextResponse.json({ error: 'Failed to create listing' }, { status: 500 })
  }
  
  return NextResponse.json(data, { status: 201 })
}
```
