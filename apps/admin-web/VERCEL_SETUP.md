# Vercel Deployment Setup

## Configuration Steps

### 1. In Vercel Dashboard → Project Settings → General:

**Root Directory**: `apps/admin-web`

**Framework Preset**: Next.js (auto-detected)

**Build Command**: (leave default or set to)
```
npm run build
```

**Output Directory**: (leave default)
```
.next
```

**Install Command**: (leave default)
```
npm install
```

### 2. Environment Variables

Go to **Settings → Environment Variables** and add:

- **Name**: `NEXT_PUBLIC_SUPABASE_URL`
  **Value**: `https://rtmxrgbqdfeucqfsgepx.supabase.co`

- **Name**: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
  **Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0bXhyZ2JxZGZldWNxZnNnZXB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjM1MjMsImV4cCI6MjA3ODkzOTUyM30.jNCwkVrP9NYCOHA60HbWzWb7xpeN4a1cnZkr5-IIwsI`

**Important**: Make sure to select all environments (Production, Preview, Development)

### 3. Redeploy

After setting the Root Directory to `apps/admin-web`, Vercel will automatically redeploy or you can trigger a new deployment manually.

## Troubleshooting

### "Could not parse File as JSON: vercel.json"
- **Solution**: Don't use vercel.json at root. Set Root Directory in dashboard instead.

### Build Fails
- Check that Root Directory is set to `apps/admin-web`
- Verify all dependencies are in `package.json`
- Check build logs for specific errors

### 404 Error
- Ensure Root Directory is `apps/admin-web` (not empty)
- Verify environment variables are set
- Check that the build completed successfully

### Environment Variables Not Working
- Must start with `NEXT_PUBLIC_` for client-side access
- Redeploy after adding/changing environment variables
- Check that they're enabled for the correct environment
