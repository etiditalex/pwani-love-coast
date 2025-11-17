# Supabase Setup

This directory contains database migrations and configuration for the Pwani Love app.

## Migrations

### Initial Schema (`20241117000001_initial_schema.sql`)

Creates the core database schema:

- **profiles**: User profile information
- **likes**: Swipe/like actions
- **matches**: Mutual matches
- **messages**: Chat messages

Includes:
- Row Level Security (RLS) policies
- Database triggers for automatic match creation
- Indexes for performance

## Setup

1. **Install Supabase CLI:**
   ```bash
   npm install -g supabase
   ```

2. **Link to your project:**
   ```bash
   supabase link --project-ref your-project-ref
   ```

3. **Run migrations:**
   ```bash
   supabase db push
   ```

## Storage Buckets

Create these buckets in Supabase Dashboard:

1. **avatars**
   - Public: Yes
   - File size limit: 5MB
   - Allowed MIME types: image/*

2. **photos**
   - Public: Yes
   - File size limit: 10MB
   - Allowed MIME types: image/*

## RLS Policies

All tables have Row Level Security enabled:

- Users can only view/edit their own data
- Discovery profiles are filtered by preferences
- Messages are restricted to match participants

See migration file for detailed policy definitions.

## Testing

Test RLS policies in Supabase SQL Editor:

```sql
-- Test profile access
SELECT * FROM profiles WHERE id = auth.uid();

-- Test discovery query
SELECT * FROM profiles 
WHERE id != auth.uid()
  AND id NOT IN (SELECT to_user FROM likes WHERE from_user = auth.uid());
```

