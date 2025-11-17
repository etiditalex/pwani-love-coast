# Deployment Guide

## Prerequisites

- Supabase account and project
- Flutter SDK installed
- Node.js 18+ installed
- Vercel account (for admin dashboard)
- Git repository

## Supabase Setup

### 1. Create Supabase Project

1. Go to [supabase.com](https://supabase.com)
2. Create new project
3. Note your project URL and anon key

### 2. Run Migrations

```bash
# Install Supabase CLI
npm install -g supabase

# Link to your project
supabase link --project-ref your-project-ref

# Run migrations
supabase db push
```

### 3. Set Up Storage Buckets

Create storage buckets in Supabase Dashboard:

1. **avatars** bucket
   - Public: Yes
   - File size limit: 5MB
   - Allowed MIME types: image/*

2. **photos** bucket
   - Public: Yes
   - File size limit: 10MB
   - Allowed MIME types: image/*

### 4. Configure RLS Policies

RLS policies are already defined in migrations. Verify in Supabase Dashboard:

- Settings → Authentication → Policies

## Flutter App Deployment

### 1. Environment Setup

Create `apps/mobile/.env`:

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

Update `apps/mobile/lib/main.dart` with your Supabase credentials.

### 2. Build for Android

```bash
cd apps/mobile
flutter build apk --release
# or
flutter build appbundle --release
```

### 3. Build for iOS

```bash
cd apps/mobile
flutter build ios --release
```

### 4. App Store Deployment

- **Android**: Upload APK/AAB to Google Play Console
- **iOS**: Upload via Xcode or App Store Connect

## Admin Dashboard Deployment (Vercel)

### 1. Prepare Environment Variables

Create `apps/admin-web/.env.local`:

```env
NEXT_PUBLIC_SUPABASE_URL=your_supabase_url
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_supabase_anon_key
```

### 2. Deploy to Vercel

**Option A: Via CLI**

```bash
cd apps/admin-web
npm install -g vercel
vercel
```

**Option B: Via GitHub**

1. Push code to GitHub
2. Go to [vercel.com](https://vercel.com)
3. Import project from GitHub
4. Add environment variables
5. Deploy

### 3. Configure Vercel

- Framework Preset: Next.js
- Root Directory: `apps/admin-web`
- Build Command: `npm run build`
- Output Directory: `.next`

## Post-Deployment Checklist

### Supabase

- [ ] Verify RLS policies are active
- [ ] Test authentication flow
- [ ] Verify storage buckets are accessible
- [ ] Check database indexes are created
- [ ] Test realtime subscriptions

### Flutter App

- [ ] Test sign up flow
- [ ] Test profile creation
- [ ] Test discovery/swiping
- [ ] Test matching
- [ ] Test messaging
- [ ] Test image uploads

### Admin Dashboard

- [ ] Verify stats are loading
- [ ] Check recent matches display
- [ ] Verify user growth chart
- [ ] Test on mobile devices

## Monitoring

### Supabase Dashboard

- Monitor database performance
- Check API usage
- Review authentication logs
- Monitor storage usage

### Vercel Dashboard

- Monitor deployment status
- Check build logs
- Review analytics
- Monitor error rates

## Troubleshooting

### Common Issues

1. **RLS Policy Errors**
   - Check user authentication
   - Verify policies are enabled
   - Check policy conditions

2. **Image Upload Failures**
   - Verify storage bucket exists
   - Check bucket permissions
   - Verify file size limits

3. **Realtime Not Working**
   - Check Supabase Realtime is enabled
   - Verify subscription setup
   - Check network connectivity

4. **Build Failures**
   - Check environment variables
   - Verify dependencies are installed
   - Check build logs for errors

## Scaling Considerations

### Database

- Monitor query performance
- Add indexes as needed
- Consider read replicas for high traffic

### Storage

- Implement image optimization
- Use CDN for static assets
- Monitor storage usage

### API

- Monitor rate limits
- Implement caching where appropriate
- Consider API gateway for future microservices

