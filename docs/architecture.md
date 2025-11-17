# Pwani Love Architecture

## Overview

Pwani Love is a modern dating/matchmaking app built with a microservices-ready architecture. The system consists of:

- **Mobile App**: Flutter (iOS & Android)
- **Backend**: Supabase (Postgres, Auth, Realtime, Storage)
- **Admin Dashboard**: Next.js (Vercel)
- **Future**: Python microservices for advanced matching

## System Architecture

```
┌─────────────────┐
│  Flutter App    │
│  (iOS/Android)  │
└────────┬────────┘
         │
         │ HTTPS/REST
         │
┌────────▼─────────────────┐
│      Supabase             │
│  ┌─────────────────────┐  │
│  │  Postgres Database  │  │
│  │  (RLS Policies)     │  │
│  └─────────────────────┘  │
│  ┌─────────────────────┐  │
│  │  Authentication     │  │
│  └─────────────────────┘  │
│  ┌─────────────────────┐  │
│  │  Realtime           │  │
│  └─────────────────────┘  │
│  ┌─────────────────────┐  │
│  │  Storage            │  │
│  └─────────────────────┘  │
└────────┬──────────────────┘
         │
         │
┌────────▼────────┐
│  Next.js Admin  │
│  (Vercel)       │
└─────────────────┘
```

## Database Schema

### Core Tables

1. **profiles**: User profile information
   - Linked to `auth.users` via UUID
   - Contains: display name, age, gender, bio, interests, photos, location

2. **likes**: Swipe/like actions
   - Tracks one-way likes between users
   - Triggers match creation on mutual likes

3. **matches**: Mutual matches
   - Created automatically when two users like each other
   - Tracks last activity timestamp

4. **messages**: Chat messages
   - Linked to matches
   - Real-time updates via Supabase Realtime

## Security

### Row Level Security (RLS)

All tables have RLS enabled with policies:

- **Profiles**: Users can view/edit own profile, view discoverable profiles
- **Likes**: Users can view own likes, create likes from themselves
- **Matches**: Users can view matches they're part of
- **Messages**: Users can view/send messages in their matches

### Authentication

- Supabase Auth handles user authentication
- JWT tokens for API access
- Email/password authentication (can extend to OAuth)

## Data Flow

### User Registration Flow

1. User signs up via Flutter app
2. Supabase Auth creates user account
3. User completes profile (display name, age, etc.)
4. Profile stored in `profiles` table

### Matching Flow

1. User views discoverable profiles (filtered by preferences)
2. User swipes right (like) or left (pass)
3. Like stored in `likes` table
4. If mutual like exists, match created automatically via trigger
5. Both users notified of match

### Messaging Flow

1. User opens match from matches list
2. Messages loaded from `messages` table
3. Real-time subscription for new messages
4. Messages sent via Supabase client
5. Match activity timestamp updated

## Extension Points

### Future Python Microservices

The architecture is designed to support future Python microservices for:

1. **Advanced Matching Algorithm**
   - ML-based compatibility scoring
   - Interest-based recommendations
   - Location-based suggestions

2. **Analytics Service**
   - User behavior tracking
   - Match success metrics
   - A/B testing framework

3. **Notification Service**
   - Push notifications
   - Email notifications
   - SMS notifications (optional)

### Integration Points

- Supabase Edge Functions (serverless)
- Webhooks for external services
- REST API endpoints for microservices

## Scalability Considerations

- **Database**: Postgres with proper indexing
- **Storage**: Supabase Storage for images
- **Caching**: Can add Redis layer for frequently accessed data
- **CDN**: Vercel handles CDN for admin dashboard
- **Load Balancing**: Supabase handles backend scaling

## Monitoring & Analytics

- Supabase Dashboard for database metrics
- Vercel Analytics for admin dashboard
- Custom analytics in admin dashboard
- Future: Dedicated analytics service

