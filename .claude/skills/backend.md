# Backend Development Skills

## API Security Requirements

Every API endpoint MUST implement these security measures in order:

### 1. Origin Check (Critical)
```typescript
// Block requests not from your frontend
const allowedOrigins = [
  process.env.NEXT_PUBLIC_APP_URL,  // https://nzsettle.vercel.app
  'http://localhost:3000'           // Development only
];

const origin = request.headers.get('origin');
if (!allowedOrigins.includes(origin)) {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
}
```

### 2. Authentication
```typescript
// Verify user is logged in
const { data: { user }, error } = await supabase.auth.getUser();
if (error || !user) {
  return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
}
```

### 3. Authorization (Role-Based)
```typescript
// Check user role
const { data: role } = await supabase
  .from('user_roles')
  .select('role')
  .eq('user_id', user.id)
  .single();

// Admin only
if (role?.role !== 'admin') {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
}

// Owner or admin
if (resource.owner_id !== user.id && role?.role !== 'admin') {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
}

// Specific roles allowed
const allowedRoles = ['admin', 'room_owner', 'customer'];
if (!allowedRoles.includes(role?.role)) {
  return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
}
```

### 4. Input Validation
```typescript
// Use zod for all inputs
import { z } from 'zod';

const schema = z.object({
  title: z.string().min(1).max(100),
  rent_per_week: z.number().positive(),
  bedrooms: z.number().int().min(1).max(20),
});

const body = await request.json();
const result = schema.safeParse(body);

if (!result.success) {
  return NextResponse.json({ error: result.error.issues }, { status: 400 });
}
```

### 5. Rate Limiting
```typescript
// Simple in-memory rate limiter
const rateLimit = new Map<string, { count: number; reset: number }>();

function checkRateLimit(userId: string): boolean {
  const now = Date.now();
  const limit = rateLimit.get(userId);
  
  if (!limit || now > limit.reset) {
    rateLimit.set(userId, { count: 1, reset: now + 60000 }); // 1 minute
    return true;
  }
  
  if (limit.count >= 100) return false; // 100 requests/minute
  
  limit.count++;
  return true;
}
```

### 6. Error Handling
```typescript
// Never expose internal errors
try {
  // Your logic here
} catch (error) {
  console.error('API Error:', error); // Log for debugging
  return NextResponse.json(
    { error: 'Internal server error' }, // Generic message
    { status: 500 }
  );
}
```

## Role-Based Access Patterns

| Pattern | Code |
|---------|------|
| Admin only | `if (role !== 'admin') return 403` |
| Owner or admin | `if (owner_id !== user.id && role !== 'admin') return 403` |
| Any authenticated | `if (!user) return 401` |
| Specific roles | `if (!['admin', 'customer'].includes(role)) return 403` |

## API Route Template

```typescript
// src/app/api/example/route.ts
import { createClient } from '@/lib/supabase/server';
import { NextResponse } from 'next/server';
import { z } from 'zod';

// 1. Origin check
const allowedOrigins = [
  process.env.NEXT_PUBLIC_APP_URL,
  'http://localhost:3000'
];

// 2. Input validation schema
const schema = z.object({
  // ... your fields
});

export async function POST(request: Request) {
  // Origin check
  const origin = request.headers.get('origin');
  if (!allowedOrigins.includes(origin || '')) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }

  const supabase = createClient();

  // 3. Authentication
  const { data: { user }, error: authError } = await supabase.auth.getUser();
  if (authError || !user) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 });
  }

  // 4. Authorization
  const { data: role } = await supabase
    .from('user_roles')
    .select('role')
    .eq('user_id', user.id)
    .single();

  const allowedRoles = ['admin', 'room_owner'];
  if (!allowedRoles.includes(role?.role)) {
    return NextResponse.json({ error: 'Forbidden' }, { status: 403 });
  }

  // 5. Rate limiting
  if (!checkRateLimit(user.id)) {
    return NextResponse.json({ error: 'Too many requests' }, { status: 429 });
  }

  // 6. Input validation
  const body = await request.json();
  const result = schema.safeParse(body);
  if (!result.success) {
    return NextResponse.json({ error: result.error.issues }, { status: 400 });
  }

  // 7. Your business logic here
  // ...

  // 8. Return response (never expose internals)
  return NextResponse.json({ success: true }, { status: 200 });
}
```

## Environment Variables

All secrets MUST come from `.env.local` (never hardcoded):

```typescript
const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;
const supabaseKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
const serviceRoleKey = process.env.SUPABASE_SERVICE_ROLE_KEY; // Server only
```

## What NEVER Goes in Code

- ❌ Admin email/password
- ❌ API keys
- ❌ Database passwords
- ❌ Service role keys
- ❌ Hardcoded secrets

## What's Safe to Commit

- ✅ Table schemas (in migrations)
- ✅ RLS policies
- ✅ Indexes
- ✅ Default values
- ✅ Public API URLs
