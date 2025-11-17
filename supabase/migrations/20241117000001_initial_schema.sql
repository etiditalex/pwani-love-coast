-- Pwani Love: Initial Schema
-- Creates profiles, likes, matches, and messages tables with RLS

-- Enable UUID extension
create extension if not exists "uuid-ossp";

-- Profiles table (one per user, linked to auth.users)
create table public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  display_name text not null,
  age int check (age >= 18),
  gender text,          -- e.g. 'male','female','nonbinary'
  looking_for text,     -- e.g. 'male','female','everyone'
  bio text,
  interests text[],
  avatar_url text,
  photos text[],
  latitude double precision,
  longitude double precision,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- Likes table (swipes/likes)
create table public.likes (
  id bigserial primary key,
  from_user uuid references auth.users(id) on delete cascade not null,
  to_user uuid references auth.users(id) on delete cascade not null,
  created_at timestamptz default now(),
  unique (from_user, to_user),
  check (from_user != to_user)
);

-- Matches table (mutual likes)
create table public.matches (
  id bigserial primary key,
  user_a uuid references auth.users(id) on delete cascade not null,
  user_b uuid references auth.users(id) on delete cascade not null,
  created_at timestamptz default now(),
  last_activity_at timestamptz default now(),
  unique (user_a, user_b),
  check (user_a < user_b) -- Ensures consistent ordering
);

-- Messages table
create table public.messages (
  id bigserial primary key,
  match_id bigint references public.matches(id) on delete cascade not null,
  sender_id uuid references auth.users(id) on delete cascade not null,
  body text not null,
  read_at timestamptz,
  created_at timestamptz default now()
);

-- Indexes for performance
create index idx_likes_from_user on public.likes(from_user);
create index idx_likes_to_user on public.likes(to_user);
create index idx_matches_user_a on public.matches(user_a);
create index idx_matches_user_b on public.matches(user_b);
create index idx_messages_match_id on public.messages(match_id);
create index idx_messages_created_at on public.messages(created_at);
create index idx_profiles_location on public.profiles using gist (point(longitude, latitude));

-- Enable Row Level Security
alter table public.profiles enable row level security;
alter table public.likes enable row level security;
alter table public.matches enable row level security;
alter table public.messages enable row level security;

-- RLS Policies for profiles
-- Users can read their own profile
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

-- Users can update their own profile
create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Users can insert their own profile
create policy "Users can insert own profile"
  on public.profiles for insert
  with check (auth.uid() = id);

-- Users can view profiles they haven't liked (for discovery)
create policy "Users can view discoverable profiles"
  on public.profiles for select
  using (
    auth.uid() is not null
    and id != auth.uid()
    and id not in (
      select to_user from public.likes where from_user = auth.uid()
    )
    and (
      gender = (select looking_for from public.profiles where id = auth.uid())
      or (select looking_for from public.profiles where id = auth.uid()) = 'everyone'
    )
  );

-- RLS Policies for likes
-- Users can view their own likes (sent and received)
create policy "Users can view own likes"
  on public.likes for select
  using (auth.uid() = from_user or auth.uid() = to_user);

-- Users can create likes from themselves
create policy "Users can create likes"
  on public.likes for insert
  with check (auth.uid() = from_user);

-- RLS Policies for matches
-- Users can view matches they're part of
create policy "Users can view own matches"
  on public.matches for select
  using (auth.uid() = user_a or auth.uid() = user_b);

-- RLS Policies for messages
-- Users can view messages in their matches
create policy "Users can view messages in own matches"
  on public.messages for select
  using (
    exists (
      select 1 from public.matches
      where id = match_id
      and (user_a = auth.uid() or user_b = auth.uid())
    )
  );

-- Users can send messages in their matches
create policy "Users can send messages in own matches"
  on public.messages for insert
  with check (
    auth.uid() = sender_id
    and exists (
      select 1 from public.matches
      where id = match_id
      and (user_a = auth.uid() or user_b = auth.uid())
    )
  );

-- Function to automatically create matches when there's a mutual like
create or replace function public.handle_mutual_like()
returns trigger as $$
declare
  existing_like record;
begin
  -- Check if there's a reverse like
  select * into existing_like
  from public.likes
  where from_user = new.to_user
    and to_user = new.from_user;

  -- If mutual like exists, create a match
  if found then
    insert into public.matches (user_a, user_b)
    values (
      least(new.from_user, new.to_user),
      greatest(new.from_user, new.to_user)
    )
    on conflict (user_a, user_b) do nothing;
  end if;

  return new;
end;
$$ language plpgsql security definer;

-- Trigger to create matches on mutual likes
create trigger on_mutual_like
  after insert on public.likes
  for each row
  execute function public.handle_mutual_like();

-- Function to update match activity timestamp
create or replace function public.update_match_activity()
returns trigger as $$
begin
  update public.matches
  set last_activity_at = now()
  where id = new.match_id;
  return new;
end;
$$ language plpgsql;

-- Trigger to update match activity on new messages
create trigger on_new_message
  after insert on public.messages
  for each row
  execute function public.update_match_activity();

-- Function to update profile updated_at timestamp
create or replace function public.update_updated_at_column()
returns trigger as $$
begin
  new.updated_at = now();
  return new;
end;
$$ language plpgsql;

-- Trigger to update profile updated_at
create trigger update_profiles_updated_at
  before update on public.profiles
  for each row
  execute function public.update_updated_at_column();

