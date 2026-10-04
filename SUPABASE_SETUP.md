# Set up the shared game

Supabase stores the shared leaderboard and extra answers. The game also has over 100 built-in answers so it can still play if the extra-word table is unavailable.

## Update the database

1. Open your Supabase project and choose **SQL Editor**.
2. Open `supabase-setup.sql`, paste the whole file into a new query, and click **Run**. It is safe to run again after earlier leaderboard setup; it creates the extra-answer table and its access rules too.
3. Wait for the query to finish successfully.

Everyone can read the word list. Only a signed-in account with the admin flag set in Supabase can add answers. The public anon key alone does not let visitors change the list.

## Approve one grown-up account

Do these steps as the project owner:

1. In Supabase, go to **Authentication → Users** and create a user for the grown-up using an email address and password. Do not put that password in this project.
2. In **SQL Editor**, replace `GROWN_UP_EMAIL` in the statement below with that account's email, then run the statement:

   ```sql
   update auth.users
   set raw_app_meta_data =
     coalesce(raw_app_meta_data, '{}'::jsonb) || '{"is_game_admin": true}'::jsonb
   where email = 'GROWN_UP_EMAIL';
   ```

3. Check the SQL results say one row was updated. If the user had already signed in, sign out and back in so Supabase issues a fresh admin session.
4. Open `https://pantinpo.github.io/kiddoVC/admin.html` and sign in with that grown-up account.

The database checks admin permission itself, so visitors cannot add answers by bypassing the page. To remove admin access, run the same update with `{"is_game_admin": false}` for that email.

## Public keys and privacy

The Project URL and **public anon** key are used by the browser. Never put a `service_role` or secret key in a website file. The admin account's password also stays private; type it only into the grown-up sign-in page.

Player nicknames, leaderboard scores, and extra answers can be seen by anyone visiting the public site. Use fun nicknames, not full names or private information. This is a fun scoreboard, not a cheat-proof competition.
