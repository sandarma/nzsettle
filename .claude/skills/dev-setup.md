# Development Environment Setup

## Prerequisites

- **Node.js:** 18.x or higher
- **npm:** 9.x or higher
- **Git:** Latest version
- **VS Code:** Recommended editor
- **GitHub account:** For repository access

## Initial Setup

### 1. Clone Repository

```bash
git clone https://github.com/sandarma/nzsettle.git
cd nzsettle
```

### 2. Install Dependencies

```bash
npm install
```

### 3. Environment Variables

Copy the example environment file:

```bash
cp .env.example .env.local
```

Fill in the values (ask Sandar for actual values):

```env
# Supabase
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key

# AWS S3
AWS_ACCESS_KEY_ID=your_aws_access_key
AWS_SECRET_ACCESS_KEY=your_aws_secret_key
AWS_REGION=ap-southeast-2
S3_BUCKET_NAME=nzsettle-images
NEXT_PUBLIC_S3_BASE_URL=nzsettle-images.s3.ap-southeast-2.amazonaws.com
```

### 4. Start Development Server

```bash
npm run dev
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

## Supabase Setup

### Local Development

1. Install Supabase CLI:
   ```bash
   npm install -g supabase
   ```

2. Link to project:
   ```bash
   supabase link --project-ref your-project-ref
   ```

3. Pull database schema:
   ```bash
   supabase db pull
   ```

4. Run migrations:
   ```bash
   supabase db push
   ```

### Database Tables

Key tables in the database:

- `users` — User accounts (extends Supabase auth.users)
- `user_roles` — Role assignments (admin, customer, home_owner, car_owner, viewing_helper)
- `room_listings` — Room rental listings with detailed fields
- `car_listings` — Car/driver listings
- `availability` — Day/time availability for viewers and car owners
- `consultations` — Consultation bookings
- `viewings` — Property viewing appointments
- `airport_pickups` — Airport pickup requests

## AWS S3 Setup

### Bucket Structure

```
nzsettle-images/
├── rooms/
│   └── {listing_id}/
│       ├── image-1.jpg
│       ├── image-2.jpg
│       └── ...
├── cars/
│   └── {car_owner_id}/
│       ├── car-1.jpg
│       └── ...
└── licenses/
    └── {user_id}/
        ├── front.jpg
        └── back.jpg
```

### Permissions

Bucket policy should allow:
- Public read access for listing images
- Authenticated write access for uploads
- Server-side delete for cleanup

## VS Code Extensions

Recommended extensions:

- **ES7+ React/Redux/React-Native snippets** — React code snippets
- **Tailwind CSS IntelliSense** — Tailwind autocomplete
- **Prettier** — Code formatting
- **ESLint** — JavaScript linting
- **GitLens** — Git integration
- **Error Lens** — Inline error display

## Common Commands

```bash
# Development
npm run dev          # Start dev server
npm run build        # Build for production
npm run start        # Start production server
npm run lint         # Run ESLint
npm run type-check   # Run TypeScript checker

# Database
supabase db push     # Push migrations
supabase db pull     # Pull schema
supabase reset       # Reset local database

# Testing
npm test             # Run tests
npm run test:watch   # Run tests in watch mode
npm run test:coverage # Run tests with coverage
```

## Troubleshooting

### Port Already in Use

```bash
# Kill process on port 3000
lsof -ti:3000 | xargs kill -9
```

### Environment Variables Not Loading

1. Ensure `.env.local` exists (not `.env`)
2. Restart dev server after changes
3. Check variable names match exactly (case-sensitive)

### Supabase Connection Issues

1. Verify URL and keys in `.env.local`
2. Check Supabase dashboard for project status
3. Ensure IP is not blocked in Supabase settings

### S3 Upload Fails

1. Verify AWS credentials in `.env.local`
2. Check bucket permissions
3. Ensure region matches (`ap-southeast-2`)
4. Check browser console for CORS errors

## Getting Help

1. Check this document first
2. Search existing issues on GitHub
3. Ask Sandar for access credentials or configuration help
4. Create a new issue with detailed error description
