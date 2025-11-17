# Pwani Love 💙

A modern matchmaking app for people along the Kenyan coast and beyond.

## 🏗️ Architecture

- **Mobile App**: Flutter (Android & iOS) - `apps/mobile/`
- **Backend**: Supabase (Auth, Postgres, Realtime, Storage, RLS)
- **Admin Dashboard**: Next.js + TypeScript (Vercel) - `apps/admin-web/`
- **Future**: Python microservices for advanced matching algorithms

## 📁 Project Structure

```
.
├── apps/
│   ├── mobile/          # Flutter app
│   └── admin-web/       # Next.js admin dashboard
├── supabase/
│   └── migrations/      # SQL migrations
├── docs/                # Architecture & API docs
└── README.md
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (latest stable)
- Node.js 18+ and npm/yarn
- Supabase account and CLI
- Git

### Setup

1. **Clone and install dependencies:**

   ```bash
   # Flutter app
   cd apps/mobile
   flutter pub get

   # Admin dashboard
   cd apps/admin-web
   npm install
   ```

2. **Supabase setup:**

   ```bash
   # Install Supabase CLI
   npm install -g supabase

   # Link to your project
   supabase link --project-ref your-project-ref

   # Run migrations
   supabase db push
   ```

3. **Environment variables:**

   - Flutter: Create `apps/mobile/.env` with your Supabase URL and anon key
   - Admin: Create `apps/admin-web/.env.local` with Supabase credentials

4. **Run the apps:**

   ```bash
   # Flutter
   cd apps/mobile
   flutter run

   # Admin dashboard
   cd apps/admin-web
   npm run dev
   ```

## 📚 Documentation

See `docs/` for:
- Architecture overview
- API contracts
- Matching logic notes
- Deployment guides

## 🎨 Design Philosophy

- **Coastal, soft, modern**: Warm colors, smooth animations
- **Simple & intuitive**: Clean UI, minimal friction
- **Privacy-first**: RLS policies, secure by default

## 🔐 Security

- Row Level Security (RLS) enabled on all tables
- User authentication via Supabase Auth
- Secure file uploads to Supabase Storage

## 📝 License

Proprietary - All rights reserved

