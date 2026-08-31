# Testing Guidelines

## Testing Strategy

We use a multi-layered testing approach:

1. **Unit Tests** — Test individual functions and components
2. **Integration Tests** — Test component interactions
3. **E2E Tests** — Test complete user flows

## Testing Tools

- **Vitest** — Unit and integration testing
- **React Testing Library** — Component testing
- **Playwright** — E2E testing (future)
- **MSW** — Mock Service Worker for API mocking

## Test File Structure

```
src/
├── __tests__/           # Test files
│   ├── components/      # Component tests
│   ├── lib/             # Utility function tests
│   └── api/             # API route tests
├── components/
│   └── ui/
│       └── Button.tsx   # Component
│       └── Button.test.tsx  # Test file (co-located)
```

## Unit Testing

### Testing Utility Functions

```typescript
// src/lib/__tests__/utils.test.ts
import { describe, it, expect } from 'vitest'
import { formatCurrency, generateWaMeLink } from '../utils'

describe('formatCurrency', () => {
  it('formats NZD currency correctly', () => {
    expect(formatCurrency(150)).toBe('$150.00')
    expect(formatCurrency(0)).toBe('$0.00')
    expect(formatCurrency(1234.56)).toBe('$1,234.56')
  })

  it('handles negative values', () => {
    expect(formatCurrency(-50)).toBe('-$50.00')
  })
})

describe('generateWaMeLink', () => {
  it('generates correct wa.me link', () => {
    const link = generateWaMeLink('+6421234567', 'Hello!')
    expect(link).toBe('https://wa.me/6421234567?text=Hello!')
  })

  it('URL encodes message correctly', () => {
    const link = generateWaMeLink('+6421234567', 'Hello World!')
    expect(link).toContain('Hello%20World!')
  })
})
```

### Testing React Components

```typescript
// src/components/__tests__/Button.test.tsx
import { render, screen, fireEvent } from '@testing-library/react'
import { Button } from '../ui/Button'

describe('Button', () => {
  it('renders correctly', () => {
    render(<Button>Click me</Button>)
    expect(screen.getByRole('button', { name: /click me/i })).toBeInTheDocument()
  })

  it('calls onClick when clicked', () => {
    const handleClick = vi.fn()
    render(<Button onClick={handleClick}>Click me</Button>)
    
    fireEvent.click(screen.getByRole('button'))
    expect(handleClick).toHaveBeenCalledTimes(1)
  })

  it('is disabled when disabled prop is true', () => {
    render(<Button disabled>Click me</Button>)
    expect(screen.getByRole('button')).toBeDisabled()
  })

  it('applies variant classes correctly', () => {
    render(<Button variant="secondary">Click me</Button>)
    expect(screen.getByRole('button')).toHaveClass('bg-secondary')
  })
})
```

## Integration Testing

### Testing Form Submissions

```typescript
// src/components/__tests__/BookingForm.test.tsx
import { render, screen, waitFor } from '@testing-library/react'
import userEvent from '@testing-library/user-event'
import { BookingForm } from '../forms/BookingForm'

describe('BookingForm', () => {
  it('submits form with valid data', async () => {
    const onSubmit = vi.fn()
    render(<BookingForm onSubmit={onSubmit} />)
    
    const user = userEvent.setup()
    
    await user.type(screen.getByLabelText(/name/i), 'John Doe')
    await user.type(screen.getByLabelText(/email/i), 'john@example.com')
    await user.type(screen.getByLabelText(/whatsapp/i), '+6421234567')
    await user.click(screen.getByRole('button', { name: /submit/i }))
    
    await waitFor(() => {
      expect(onSubmit).toHaveBeenCalledWith({
        name: 'John Doe',
        email: 'john@example.com',
        whatsapp: '+6421234567',
      })
    })
  })

  it('shows validation errors for invalid data', async () => {
    render(<BookingForm onSubmit={vi.fn()} />)
    
    const user = userEvent.setup()
    await user.click(screen.getByRole('button', { name: /submit/i }))
    
    expect(screen.getByText(/name is required/i)).toBeInTheDocument()
    expect(screen.getByText(/email is required/i)).toBeInTheDocument()
  })
})
```

## Mocking

### Mocking Supabase

```typescript
// src/lib/__tests__/supabase-mock.ts
import { vi } from 'vitest'

export const mockSupabase = {
  from: vi.fn(() => ({
    select: vi.fn().mockReturnThis(),
    insert: vi.fn().mockReturnThis(),
    update: vi.fn().mockReturnThis(),
    delete: vi.fn().mockReturnThis(),
    eq: vi.fn().mockReturnThis(),
    single: vi.fn().mockResolvedValue({ data: null, error: null }),
  })),
}

vi.mock('@/lib/supabase/client', () => ({
  createClient: () => mockSupabase,
}))
```

### Mocking API Routes

```typescript
// src/api/__tests__/upload.test.ts
import { createMocks } from 'node-mocks-http'
import { POST } from '../upload/listing/route'

describe('/api/upload/listing', () => {
  it('uploads image successfully', async () => {
    const { req } = createMocks({
      method: 'POST',
      body: {
        listingId: 'test-listing-id',
        imageIndex: 0,
      },
    })

    // Mock S3 upload
    vi.mock('@/lib/s3', () => ({
      uploadImage: vi.fn().mockResolvedValue({
        url: 'https://s3.example.com/image.jpg',
      }),
    }))

    const response = await POST(req as any)
    const data = await response.json()

    expect(response.status).toBe(200)
    expect(data.url).toBeDefined()
  })
})
```

## Test Coverage

### Coverage Goals

- **Statements:** 80%+
- **Branches:** 75%+
- **Functions:** 85%+
- **Lines:** 80%+

### Running Coverage

```bash
npm run test:coverage
```

Coverage report will be generated in `coverage/` directory.

## E2E Testing (Future)

### Playwright Setup

```typescript
// tests/example.spec.ts
import { test, expect } from '@playwright/test'

test('homepage has correct title', async ({ page }) => {
  await page.goto('http://localhost:3000')
  await expect(page).toHaveTitle(/Rental Platform/)
})

test('user can browse room listings', async ({ page }) => {
  await page.goto('http://localhost:3000/rooms')
  await expect(page.locator('h1')).toContainText('Available Rooms')
})
```

## Best Practices

1. **Test behavior, not implementation** — Test what the component does, not how it does it
2. **Use accessible queries** — Prefer `getByRole`, `getByLabelText`, `getByText`
3. **Avoid testing implementation details** — Don't test state, test output
4. **Write independent tests** — Tests should not depend on each other
5. **Use meaningful test names** — Describe the expected behavior
6. **Mock external dependencies** — Supabase, S3, wa.me links
7. **Test edge cases** — Empty states, errors, loading states
8. **Keep tests fast** — Mock heavy operations

## Test Commands

```bash
# Run all tests
npm test

# Run tests in watch mode
npm run test:watch

# Run specific test file
npm run test -- Button.test.tsx

# Run tests with coverage
npm run test:coverage

# Run E2E tests (future)
npm run test:e2e
```

## When to Write Tests

1. **New components** — Always write tests for new components
2. **Bug fixes** — Write a test that reproduces the bug, then fix it
3. **Refactoring** — Ensure existing tests still pass
4. **Critical paths** — Focus on auth, booking, payment flows
5. **Complex logic** — Test utility functions with multiple branches
