# Set up the shared leaderboard

The leaderboard needs a Supabase project to store scores so everyone sees the same list.

1. Ask a grown-up to create a free project at [supabase.com](https://supabase.com/).
2. In the project's **SQL Editor**, open `supabase-setup.sql`, paste its contents, and run it.
3. In the project settings, find the **Project URL** and the legacy **anon/public key**.
4. In `index.html`, replace the two empty values near the start of the script:

   ```js
   const SUPABASE_URL = "paste the Project URL here";
   const SUPABASE_ANON_KEY = "paste the anon/public key here";
   ```

5. Save the file and refresh the game. The shared leaderboard should load. Commit and push the changes to publish them.

Only use the public anon key in the website. **Never put a `service_role` or secret key in `index.html`**—those keys must stay private.

Players' nicknames and win totals are visible to anyone who visits the site. This is a fun scoreboard, not a cheat-proof competition: people can use someone else's nickname or send pretend scores.
