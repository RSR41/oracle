# Supabase Cloud Sync (Free Tier)

## 1) Create Table
Run this SQL in Supabase SQL Editor.

```sql
create table if not exists public.history_records (
  id text primary key,
  type text not null,
  title text not null,
  summary text,
  content text,
  overall_score int,
  date text not null,
  created_at text not null,
  payload_json jsonb,
  media_paths jsonb,
  updated_at timestamptz default now()
);

alter table public.history_records enable row level security;

create policy "allow anon read"
on public.history_records
for select
using (true);

create policy "allow anon upsert"
on public.history_records
for all
using (true)
with check (true);
```

## 2) Run with Cloud Sync Enabled
Use dart-define values when running/building.

```bash
flutter run \
  --dart-define=CLOUD_SYNC=true \
  --dart-define=SUPABASE_URL=https://YOUR_PROJECT.supabase.co \
  --dart-define=SUPABASE_ANON_KEY=YOUR_ANON_KEY
```

## 3) Behavior
- If `CLOUD_SYNC=false` or Supabase values are missing, app stays local-only (SQLite).
- If enabled, startup sync does:
  - local -> cloud upsert
  - cloud -> local merge (upsert by id)

## 4) Notes
- Current auth mode is anonymous sign-in.
- For production, tighten RLS policies and connect user auth id to row ownership.
