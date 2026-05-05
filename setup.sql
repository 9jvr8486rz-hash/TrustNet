-- =============================================
-- TrustNet Database Setup
-- Paste this entire file into:
-- Supabase → SQL Editor → New query → Run
-- =============================================

-- Enable UUID generation
create extension if not exists "pgcrypto";

-- ── PROFILES TABLE ──
-- Extends Supabase's built-in auth.users
create table if not exists public.profiles (
  id              uuid references auth.users(id) on delete cascade primary key,
  name            text,
  phone           text,
  service_category text,
  selfie_url      text,
  id_document_url text,
  verification_status text default 'pending',
  verification_date   timestamptz,
  expiry_date         timestamptz,
  public_id           text unique,
  role                text default 'provider',
  created_at          timestamptz default now()
);

-- ── AUTO-CREATE PROFILE ON SIGNUP ──
create or replace function public.handle_new_user()
returns trigger as $$
begin
  insert into public.profiles (id)
  values (new.id);
  return new;
end;
$$ language plpgsql security definer;

drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created
  after insert on auth.users
  for each row execute procedure public.handle_new_user();

-- ── GENERATE PUBLIC ID FUNCTION ──
create or replace function generate_public_id()
returns text as $$
declare
  chars text := 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  result text := 'TN-';
  i int;
begin
  for i in 1..8 loop
    result := result || substr(chars, floor(random() * length(chars) + 1)::int, 1);
  end loop;
  return result;
end;
$$ language plpgsql;

-- ── STORAGE BUCKETS ──
insert into storage.buckets (id, name, public)
values ('selfies', 'selfies', true)
on conflict do nothing;

insert into storage.buckets (id, name, public)
values ('id-documents', 'id-documents', false)
on conflict do nothing;

-- ── ROW LEVEL SECURITY ──
alter table public.profiles enable row level security;

-- Public can read safe fields only (for /verify page)
create policy "Public can view verified profiles"
  on public.profiles for select
  using (public_id is not null);

-- Users can read/update their own profile
create policy "Users can view own profile"
  on public.profiles for select
  using (auth.uid() = id);

create policy "Users can update own profile"
  on public.profiles for update
  using (auth.uid() = id);

-- Admins can do everything
create policy "Admins have full access"
  on public.profiles for all
  using (
    exists (
      select 1 from public.profiles
      where id = auth.uid() and role = 'admin'
    )
  );

-- Storage policies
create policy "Anyone can view selfies"
  on storage.objects for select
  using (bucket_id = 'selfies');

create policy "Users can upload their own selfie"
  on storage.objects for insert
  with check (bucket_id = 'selfies' and auth.uid()::text = (storage.foldername(name))[1]);

create policy "Admins can view ID documents"
  on storage.objects for select
  using (
    bucket_id = 'id-documents' and
    exists (
      select 1 from public.profiles
      where id = auth.uid() and role = 'admin'
    )
  );

create policy "Users can upload their own ID document"
  on storage.objects for insert
  with check (bucket_id = 'id-documents' and auth.uid()::text = (storage.foldername(name))[1]);

-- ── CREATE FIRST ADMIN ──
-- After running this file, sign up normally on the site with your email.
-- Then come back here and run this with YOUR email to make yourself admin:
--
-- update public.profiles
-- set role = 'admin'
-- where id = (select id from auth.users where email = 'your@email.com');
