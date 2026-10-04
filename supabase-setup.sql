create table if not exists public.leaderboard (
  player_key text primary key,
  player_name text not null check (char_length(player_name) between 1 and 18),
  wins integer not null default 0 check (wins >= 0),
  updated_at timestamptz not null default now()
);

alter table public.leaderboard enable row level security;

drop policy if exists "Anyone can read the leaderboard" on public.leaderboard;
create policy "Anyone can read the leaderboard"
  on public.leaderboard
  for select
  to anon, authenticated
  using (true);

grant select on public.leaderboard to anon, authenticated;
revoke insert, update, delete on public.leaderboard from anon, authenticated;

create or replace function public.record_win(p_player_name text)
returns void
language plpgsql
security definer
set search_path = ''
as $$
declare
  clean_name text := pg_catalog.btrim(p_player_name);
begin
  if clean_name is null or clean_name !~ '^[A-Za-z0-9 _-]{1,18}$' then
    raise exception 'Nickname must be 1 to 18 letters, numbers, spaces, dashes, or underscores.'
      using errcode = '22023';
  end if;

  insert into public.leaderboard (player_key, player_name, wins, updated_at)
  values (pg_catalog.lower(clean_name), clean_name, 1, pg_catalog.now())
  on conflict (player_key) do update
    set player_name = excluded.player_name,
        wins = public.leaderboard.wins + 1,
        updated_at = pg_catalog.now();
end;
$$;

revoke all on function public.record_win(text) from public;
grant execute on function public.record_win(text) to anon, authenticated;
