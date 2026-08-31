# Frontend Coding Standards

## Project Stack

- **Framework:** Next.js 14 (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS + shadcn/ui
- **State:** React hooks + Supabase real-time

## File Naming Conventions

```
components/
├── ui/                    # shadcn/ui components (Button, Card, Input)
├── layout/                # Header, Sidebar, Footer, Navigation
├── forms/                 # Form components (BookingForm, IntakeForm)
├── listings/              # Room listing components (ListingCard, ListingGrid)
├── cars/                  # Car listing components (CarCard, CarGrid)
├── calendar/              # Availability picker, schedule view
├── upload/                # Image upload components
├── guest-gate/            # "Register to contact" overlay
└── notifications/         # Notification bell, toast messages
```

## Component Pattern

```typescript
// src/components/ui/Button.tsx
import { forwardRef } from 'react'
import { cn } from '@/lib/utils'

interface ButtonProps extends React.ButtonHTMLAttributes<HTMLButtonElement> {
  variant?: 'primary' | 'secondary' | 'ghost'
  size?: 'sm' | 'md' | 'lg'
}

const Button = forwardRef<HTMLButtonElement, ButtonProps>(
  ({ className, variant = 'primary', size = 'md', ...props }, ref) => {
    return (
      <button
        className={cn(
          'inline-flex items-center justify-center rounded-md font-medium',
          'transition-colors focus-visible:outline-none focus-visible:ring-2',
          'disabled:pointer-events-none disabled:opacity-50',
          {
            'bg-primary text-primary-foreground hover:bg-primary/90': variant === 'primary',
            'bg-secondary text-secondary-foreground hover:bg-secondary/80': variant === 'secondary',
            'hover:bg-accent hover:text-accent-foreground': variant === 'ghost',
          },
          {
            'h-9 px-4 text-sm': size === 'sm',
            'h-10 px-5 text-sm': size === 'md',
            'h-12 px-6 text-base': size === 'lg',
          },
          className
        )}
        ref={ref}
        {...props}
      />
    )
  }
)

Button.displayName = 'Button'

export { Button }
export type { ButtonProps }
```

## Page Component Pattern

```typescript
// src/app/rooms/page.tsx
import { Suspense } from 'react'
import { createServerClient } from '@/lib/supabase/server'
import { RoomGrid } from '@/components/listings/RoomGrid'
import { RoomFilters } from '@/components/listings/RoomFilters'
import { Loading } from '@/components/ui/Loading'

export const metadata = {
  title: 'Room Listings | Rental Platform',
  description: 'Browse available rooms in Auckland',
}

export default async function RoomsPage() {
  const supabase = createServerClient()
  const { data: rooms } = await supabase
    .from('room_listings')
    .select('*')
    .eq('status', 'active')
    .order('created_at', { ascending: false })

  return (
    <div className="container mx-auto px-4 py-8">
      <h1 className="text-3xl font-bold mb-8">Available Rooms</h1>
      <RoomFilters />
      <Suspense fallback={<Loading />}>
        <RoomGrid rooms={rooms || []} />
      </Suspense>
    </div>
  )
}
```

## CSS/Tailwind Rules

1. **Use Tailwind classes** — avoid custom CSS unless absolutely necessary
2. **Mobile-first** — always start with mobile, add `md:` and `lg:` breakpoints
3. **Use design tokens** — `text-primary`, `bg-secondary`, etc. from shadcn/ui
4. **Consistent spacing** — use Tailwind spacing scale (p-1, p-2, p-4, etc.)
5. **Dark mode ready** — use `dark:` prefix for dark mode styles

## Form Patterns

```typescript
// Use react-hook-form + zod for validation
import { useForm } from 'react-hook-form'
import { zodResolver } from '@hookform/resolvers/zod'
import { z } from 'zod'

const schema = z.object({
  name: z.string().min(1, 'Name is required'),
  email: z.string().email('Invalid email'),
  whatsapp: z.string().regex(/^\+?[1-9]\d{1,14}$/, 'Invalid WhatsApp number'),
})

type FormData = z.infer<typeof schema>

export function ContactForm() {
  const { register, handleSubmit, formState: { errors } } = useForm<FormData>({
    resolver: zodResolver(schema),
  })

  return (
    <form onSubmit={handleSubmit(onSubmit)}>
      {/* Form fields */}
    </form>
  )
}
```

## Image Handling

```typescript
// Always use Next.js Image component
import Image from 'next/image'

<Image
  src={imageUrl}
  alt="Room photo"
  width={400}
  height={300}
  className="object-cover rounded-lg"
  placeholder="blur"
  blurDataURL={blurDataURL}
/>

// For S3 images
const imageUrl = `${process.env.NEXT_PUBLIC_S3_BASE_URL}/${imageKey}`
```

## Error Handling

```typescript
// Use error boundaries for route segments
// src/app/rooms/[id]/error.tsx
'use client'

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string }
  reset: () => void
}) {
  return (
    <div className="text-center py-12">
      <h2 className="text-2xl font-bold mb-4">Something went wrong</h2>
      <p className="text-muted-foreground mb-6">{error.message}</p>
      <button onClick={reset} className="btn-primary">
        Try again
      </button>
    </div>
  )
}
```

## Accessibility

1. **Use semantic HTML** — `<button>`, `<nav>`, `<main>`, `<article>`
2. **Add aria labels** — for interactive elements without visible text
3. **Keyboard navigation** — ensure all interactive elements are focusable
4. **Color contrast** — use Tailwind's contrast utilities
5. **Screen reader text** — use `sr-only` class for screen reader content

## Performance

1. **Use Server Components** — default to server, add `'use client'` only when needed
2. **Lazy load images** — always use Next.js Image component
3. **Code split** — use dynamic imports for heavy components
4. **Memoize** — use `React.memo` for expensive computations
5. **Avoid inline styles** — use Tailwind classes instead

## API Security Checklist

When building any API endpoint:

- [ ] **Authentication** — Check user is logged in (`supabase.auth.getUser()`)
- [ ] **Authorization** — Verify user has correct role for this action
- [ ] **Input validation** — Use zod schema to validate all inputs
- [ ] **Rate limiting** — Implement rate limits (100 req/min per user)
- [ ] **CSRF protection** — Use Supabase RLS or CSRF tokens
- [ ] **Error handling** — Return generic errors, don't expose internals
- [ ] **Logging** — Log security events for audit trail
- [ ] **Data ownership** — Users can only access their own data (except admin)

### Role-Based Access Patterns

```typescript
// Admin only
if (role !== 'admin') return 403

// Owner or admin
if (listing.owner_id !== user.id && role !== 'admin') return 403

// Any authenticated user
if (!user) return 401

// Specific roles allowed
const allowedRoles = ['admin', 'home_owner', 'customer']
if (!allowedRoles.includes(role)) return 403
```
