# Vercel Deployment Setup

## Important: Configure in Vercel Dashboard

When deploying this monorepo to Vercel, you MUST configure these settings in the Vercel Dashboard (not just vercel.json):

### Project Settings → General

1. **Root Directory**: Leave empty (or set to repo root)
   - The vercel.json handles the path to apps/admin-web

2. **Framework Preset**: Next.js

3. **Build Command**: (Already in vercel.json)
   ```
   cd apps/admin-web && npm install && npm run build
   ```

4. **Output Directory**: (Already in vercel.json)
   ```
   apps/admin-web/.next
   ```

5. **Install Command**: (Already in vercel.json)
   ```
   cd apps/admin-web && npm install
   ```

### Environment Variables

Add these in Vercel Dashboard → Settings → Environment Variables:

- `NEXT_PUBLIC_SUPABASE_URL` = `https://rtmxrgbqdfeucqfsgepx.supabase.co`
- `NEXT_PUBLIC_SUPABASE_ANON_KEY` = `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0bXhyZ2JxZGZldWNxZnNnZXB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjM1MjMsImV4cCI6MjA3ODkzOTUyM30.jNCwkVrP9NYCOHA60HbWzWb7xpeN4a1cnZkr5-IIwsI`

## Common Errors

### Build Fails
- Check that all dependencies are in package.json
- Verify Node.js version (should be 18+)

### 404 Error
- Ensure Root Directory is NOT set to `apps/admin-web` (leave empty)
- The vercel.json handles the path navigation

### Environment Variables Not Working
- Make sure they start with `NEXT_PUBLIC_` for client-side access
- Redeploy after adding environment variables

