# TrustNet — Deploy in 4 Steps

## What you have
- `index.html` — public homepage with verify widget
- `login.html` — sign in page
- `apply.html` — provider application form
- `dashboard.html` — provider dashboard (logged-in)
- `admin.html` — admin dashboard
- `verify.html` — public verification profile page
- `styles/main.css` — all styling
- `src/lib/supabase.js` — database connection (needs your keys)
- `setup.sql` — run once in Supabase to create all tables

---

## Step 1 — Create your Supabase project (free)

1. Go to **supabase.com** and sign up
2. Click **"New project"**, give it a name (e.g. `trustnet`), choose a region closest to South Africa
3. Wait ~2 minutes for it to set up
4. Go to **SQL Editor** → **New query**
5. Open `setup.sql` from this folder, copy everything, paste it in, click **Run**
6. You should see "Success" — your database is ready

---

## Step 2 — Get your API keys

1. In Supabase, go to **Project Settings** → **API**
2. Copy your **Project URL** (looks like `https://xxxxx.supabase.co`)
3. Copy your **anon public** key (long string starting with `eyJ...`)
4. Open `src/lib/supabase.js` in a text editor
5. Replace `YOUR_SUPABASE_URL` with your Project URL
6. Replace `YOUR_SUPABASE_ANON_KEY` with your anon key
7. Save the file

---

## Step 3 — Deploy to Vercel (free)

1. Go to **vercel.com** and sign up (use GitHub login if you have one)
2. Click **"Add New Project"** → **"Deploy from your computer"**
3. Drag the entire `trustnet` folder onto the upload area
4. Click **Deploy**
5. In ~30 seconds you get a live URL like `trustnet-xyz.vercel.app`

---

## Step 4 — Create your admin account

1. Go to your live site and click **"Get verified"**
2. Sign up with your own email and password
3. Go back to **Supabase** → **SQL Editor** and run:

```sql
UPDATE public.profiles
SET role = 'admin'
WHERE id = (SELECT id FROM auth.users WHERE email = 'YOUR_EMAIL_HERE');
```

Replace `YOUR_EMAIL_HERE` with the email you signed up with.

4. Sign in at `/login.html` — you'll be redirected to the admin dashboard

---

## Optional: Custom domain

1. In Vercel → your project → **Settings** → **Domains**
2. Add your domain (e.g. `trustnet.co.za`)
3. Update your DNS records as shown — usually takes a few minutes

---

## Monthly costs

| Service  | Cost         |
|----------|--------------|
| Supabase | Free (up to 50,000 users) |
| Vercel   | Free (hobby plan) |
| Domain   | ~R200/year from domains.co.za |
| **Total**| **~R200/year to start** |

---

## Need help?

If you get stuck on any step, copy the error message and ask Claude —
paste the exact error and which step you're on.

