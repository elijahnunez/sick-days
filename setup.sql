-- Sick Day Diary: run this once in your Supabase project
-- (Dashboard -> SQL Editor -> New query -> paste -> Run)

create table if not exists public.sick_episodes (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  start_date  date not null,
  end_date    date,                        -- blank = still sick, or end not recorded
  ongoing     boolean not null default false,
  title       text,                        -- e.g. "Strep?", "Cold"
  symptoms    text[] not null default '{}',
  severity    smallint check (severity between 1 and 5),
  notes       text,
  created_at  timestamptz not null default now(),
  constraint end_after_start check (end_date is null or end_date >= start_date)
);

create index if not exists sick_episodes_user_start
  on public.sick_episodes (user_id, start_date desc);

-- Row Level Security: each signed-in person can only see and change their own records.
alter table public.sick_episodes enable row level security;

drop policy if exists "own rows: read"   on public.sick_episodes;
drop policy if exists "own rows: add"    on public.sick_episodes;
drop policy if exists "own rows: edit"   on public.sick_episodes;
drop policy if exists "own rows: delete" on public.sick_episodes;

create policy "own rows: read"   on public.sick_episodes for select to authenticated
  using ((select auth.uid()) = user_id);
create policy "own rows: add"    on public.sick_episodes for insert to authenticated
  with check ((select auth.uid()) = user_id);
create policy "own rows: edit"   on public.sick_episodes for update to authenticated
  using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy "own rows: delete" on public.sick_episodes for delete to authenticated
  using ((select auth.uid()) = user_id);
