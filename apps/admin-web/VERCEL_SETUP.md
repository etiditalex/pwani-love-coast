# Vercel Deployment Setup - IMPORTANT

## ⚠️ Critical Configuration Steps

### Step 1: Set Root Directory in Vercel Dashboard

1. Go to your project in Vercel Dashboard
2. Click **Settings** → **General**
3. Scroll to **Root Directory**
4. Click **Edit** and set it to: `apps/admin-web`
5. Click **Save**

**This is the most important step!** Without this, Vercel won't find your Next.js app.

### Step 2: Add Environment Variables

Go to **Settings** → **Environment Variables** and add:

**Variable 1:**
- **Name**: `NEXT_PUBLIC_SUPABASE_URL`
- **Value**: `https://rtmxrgbqdfeucqfsgepx.supabase.co`
- **Environments**: ✅ Production, ✅ Preview, ✅ Development

**Variable 2:**
- **Name**: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- **Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0bXhyZ2JxZGZldWNxZnNnZXB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjM1MjMsImV4cCI6MjA3ODkzOTUyM30.jNCwkVrP9NYCOHA60HbWzWb7xpeN4a1cnZkr5-IIwsI`
- **Environments**: ✅ Production, ✅ Preview, ✅ Development

### Step 3: Redeploy

After setting the Root Directory:
1. Go to **Deployments** tab
2. Click the **⋯** menu on the latest deployment
3. Click **Redeploy**

Or push a new commit to trigger automatic deployment.

## Troubleshooting 404 Error

### If you still see 404: NOT_FOUND

1. **Verify Root Directory is set correctly:**
   - Must be exactly: `apps/admin-web` (not `apps/admin-web/` or anything else)
   - Go to Settings → General and double-check

2. **Check Build Logs:**
   - Go to Deployments → Click on the deployment → View Build Logs
   - Look for errors like:
     - "Cannot find module"
     - "Build failed"
     - "Missing dependencies"

3. **Verify Build Success:**
   - The deployment should show "Ready" status
   - If it shows "Error" or "Failed", check the logs

4. **Check Framework Detection:**
   - Vercel should auto-detect Next.js
   - If not, manually set Framework to "Next.js" in Settings

5. **Clear Cache and Redeploy:**
   - In deployment settings, enable "Clear Cache and Build Assets"
   - Redeploy

## Expected File Structure

Vercel should see this structure when Root Directory is `apps/admin-web`:

```
apps/admin-web/
├── app/
│   ├── layout.tsx
│   ├── page.tsx
│   └── globals.css
├── components/
├── lib/
├── package.json
├── next.config.js
└── vercel.json
```

## Still Having Issues?

1. Check that `package.json` exists in `apps/admin-web/`
2. Verify `next.config.js` is present
3. Ensure all dependencies are listed in `package.json`
4. Check Vercel build logs for specific error messages
