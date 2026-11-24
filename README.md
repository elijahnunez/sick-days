# ~*~ Sick Day Diary ~*~

Live at **https://elijahnunez.github.io/sick-days/**

A web 1.0, girly-pop sickness tracker. Log each time you get sick with a start date, an end date and symptoms, then see it all as a **Timeline** or as **Records** (totals, symptoms that keep coming back, and a "Copy for Doctor" button).

- `index.html`: the whole app (HTML, CSS and JS in one file)
- `setup.sql`: the Supabase table and row-level security rules (already applied to the live project)

## How it works

- Data lives in Supabase (`sick_episodes` table). Each signed-in person can only read and change their own rows, enforced by row-level security.
- The page holds only the project URL and the **publishable** key, which are meant to be public. Never commit the secret / service_role key.
- Sign-in is email + password through Supabase Auth.

## Hosting

Served with GitHub Pages from the `main` branch root. In Supabase, set **Authentication → URL Configuration → Site URL** to the Pages address so confirmation emails link back to the app.

*Not medical advice. If you're really sick, call your doctor!*
