# Vercel Deployment Checklist ✅

## Critical Steps (Do These Now)

### 1. ✅ Set Root Directory in Vercel Dashboard

1. Go to: https://vercel.com/dashboard
2. Select your **pwani-love-coast** project
3. Click **Settings** → **General**
4. Scroll to **Root Directory**
5. Click **Edit** and enter: `apps/admin-web`
6. Click **Save**

**⚠️ This is the MOST IMPORTANT step! Without this, you'll get 404 errors.**

---

### 2. ✅ Add Environment Variables

Go to **Settings** → **Environment Variables** and add these:

**Variable 1:**
- **Key**: `NEXT_PUBLIC_SUPABASE_URL`
- **Value**: `https://rtmxrgbqdfeucqfsgepx.supabase.co`
- **Environments**: ✅ Production ✅ Preview ✅ Development

**Variable 2:**
- **Key**: `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- **Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InJ0bXhyZ2JxZGZldWNxZnNnZXB4Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjMzNjM1MjMsImV4cCI6MjA3ODkzOTUyM30.jNCwkVrP9NYCOHA60HbWzWb7xpeN4a1cnZkr5-IIwsI`
- **Environments**: ✅ Production ✅ Preview ✅ Development

**Important**: Make sure to check all three environment checkboxes!

---

### 3. ✅ Verify Framework Settings

In **Settings** → **General**:
- **Framework Preset**: Should be **Next.js** (auto-detected)
- **Build Command**: Leave as default or `npm run build`
- **Output Directory**: Leave as default or `.next`
- **Install Command**: Leave as default or `npm install`

---

### 4. ✅ Redeploy

After setting Root Directory and Environment Variables:

1. Go to **Deployments** tab
2. Find the latest deployment
3. Click the **⋯** (three dots) menu
4. Click **Redeploy**
5. Or simply push a new commit to trigger auto-deployment

---

## What's Already Fixed in Code ✅

The following fixes are already in the codebase (pushed to GitHub):

✅ **Resilient Supabase Client** - Won't crash if env vars are missing
✅ **Error Handling** - Dashboard handles missing Supabase gracefully  
✅ **vercel.json** - Configuration file in apps/admin-web directory
✅ **Environment Variable Checks** - App checks for proper configuration

---

## Verification Steps

After redeploying, check:

1. **Build Status**: Should show "Ready" (green checkmark)
2. **Build Logs**: Should show successful build without errors
3. **Live URL**: Should show the dashboard (not 404)
4. **Console**: Open browser console - no Supabase errors

---

## Troubleshooting

### Still Getting 404?

1. **Double-check Root Directory**: Must be exactly `apps/admin-web` (no trailing slash)
2. **Check Build Logs**: Look for errors in the deployment logs
3. **Verify Environment Variables**: Make sure they're set for all environments
4. **Clear Cache**: In deployment, enable "Clear Cache and Build Assets"

### Build Fails?

1. Check build logs for specific error messages
2. Verify all dependencies are in `package.json`
3. Check that Node.js version is 18+ (Vercel auto-detects)

### Environment Variables Not Working?

1. Must start with `NEXT_PUBLIC_` for client-side access
2. Redeploy after adding/changing variables
3. Check that variables are enabled for the correct environment

---

## Quick Test

Once deployed, your dashboard should:
- ✅ Load without 404 error
- ✅ Show "Pwani Love Admin Dashboard" heading
- ✅ Display 4 stats cards (may show 0 if database is empty)
- ✅ Show "Recent Matches" and "User Growth" sections

If all these work, your deployment is successful! 🎉

