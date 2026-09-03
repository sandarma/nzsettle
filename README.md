# NZSettle 🏠

An assistance platform for international newcomers to New Zealand — helping immigrant communities find accommodation, arrange property viewings, and organize airport pickups across NZ.

![ci](../../actions/workflows/ci.yml/badge.svg) ![security](../../actions/workflows/security.yml/badge.svg)

<!-- A screenshot or GIF of the app goes here — it's the best README section. -->

## 🎯 The Problem

Finding rental accommodation in New Zealand is challenging for newcomers:

- Can't register on NZ rental sites without a local mobile number
- No local references or proof of address
- Unfamiliar with NZ rental process and expectations
- Timezone differences delay communication
- No trusted network for viewings or pickups
- Feel isolated and overwhelmed in a new country

## 💡 The Solution

NZSettle digitizes the manual process I've been running for 2+ years in Auckland — and opens it up nationwide.

**For Newcomers:**

- Browse room listings from community members across NZ
- Book consultation to understand your needs
- Arrange property viewings with local viewing helpers
- Request airport pickups from verified car owners
- Track properties you're interested in

**For Community Members:**

- Earn income by helping newcomers — viewings, pickups
- Set your own availability and schedule
- Flexible work for students and part-timers
- Build your profile and reputation

**For Room Owners:**

- List available rooms to a trusted community
- Connect directly with potential flatmates
- Simple listing process with photos

## 🌏 Nationwide Reach

While starting in Auckland, NZSettle is designed for all of New Zealand:

| Region         | Coverage          |
| -------------- | ----------------- |
| Auckland       | ✅ Full coverage  |
| Wellington     | 🔄 Expanding      |
| Christchurch   | 🔄 Expanding      |
| Hamilton       | 🔄 Coming soon    |
| All NZ regions | 🎯 Long-term goal |

**Room listings** cover all regions. **Viewing helpers and car owners** can register from anywhere — we match based on location and availability.

## 👥 Creating Opportunities

NZSettle creates flexible earning opportunities for:

- **Students** — Earn between classes, set your own hours
- **Part-time workers** — Supplement income with viewing/pickup jobs
- **Community members** — Help newcomers while earning

**How it works:**

1. Register as a Viewer or Driver
2. Set your availability (days + times)
3. Get notified when jobs match your schedule
4. Accept or decline — you're in control
5. Complete the job and get rated

## 🛠️ Tech Stack

- **Frontend:** Next.js 14, TypeScript, Tailwind CSS, shadcn/ui
- **Database:** Supabase (PostgreSQL)
- **Auth:** Supabase Auth (email/password, JWT, RLS)
- **Image Storage:** AWS S3
- **Hosting:** Vercel
- **Notifications:** WhatsApp (wa.me deep links)
- **Calendar:** iCal (.ics) export

## 🚀 Getting Started

### Prerequisites

- Node.js 18+
- npm or yarn
- Supabase account (free tier)
- AWS account (free tier)

### Installation

```bash
# Clone the repo
git clone git@github.com:sandarma/nzsettle.git
cd nzsettle

# Install dependencies
npm install

# Copy environment variables
cp .env.example .env.local

# Fill in your Supabase and AWS credentials in .env.local

# Run development server
npm run dev
```

### Environment Variables

See `.env.example` for required variables:

| Variable                        | Description               |
| ------------------------------- | ------------------------- |
| `NEXT_PUBLIC_SUPABASE_URL`      | Your Supabase project URL |
| `NEXT_PUBLIC_SUPABASE_ANON_KEY` | Supabase anonymous key    |
| `SUPABASE_SERVICE_ROLE_KEY`     | Supabase service role key |
| `AWS_ACCESS_KEY_ID`             | AWS access key            |
| `AWS_SECRET_ACCESS_KEY`         | AWS secret key            |
| `S3_BUCKET_NAME`                | S3 bucket for images      |

## 📁 Project Structure

```
nzsettle/
├── src/
│   ├── app/              # Next.js pages (App Router)
│   │   ├── (auth)/       # Login, register pages
│   │   ├── dashboard/    # Role-based dashboards
│   │   ├── listings/     # Public listing pages
│   │   └── api/          # API routes
│   ├── components/       # Reusable React components
│   ├── lib/              # Utilities (S3, wa.me, iCal)
│   └── types/            # TypeScript types
├── supabase/
│   └── migrations/       # SQL migrations
└── public/               # Static assets
```

## 🎯 User Roles

| Role               | What They Do                                    |
| ------------------ | ----------------------------------------------- |
| **Customer**       | Browse listings, book viewings, request pickups |
| **Room Owner**     | List rooms, connect with potential flatmates    |
| **Viewing Helper** | View properties on behalf of customers          |
| **Car Owner**      | Provide airport pickups                         |
| **Admin**          | Manage platform, verify users, moderate content |

## 🌍 Impact

- **60+** rental services provided for newly arrived newcomers
- **20+** airport pickups for newly arrived newcomers
- **5+** viewing helpers earning flexible income
- **5+** car owners earning flexible income
- **5+** home owners earning flexible income
- Creating **flexible earning opportunities for students**

## Author

**Sandar Min Aye**

- GitHub: [@sandarma](https://github.com/sandarma)
- LinkedIn: [Sandar Min Aye](https://www.linkedin.com/in/sandar-min-aye/)

---

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

Built by [Sandar Min Aye](https://github.com/sandarma) for the Burmese community in Auckland — and now all newcomers to New Zealand.
