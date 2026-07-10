# Supabase Usage Audit — ArdieWorks Portfolio

**Date:** 2026-07-10
**Scope:** All 13 repos on the `ardiejohnson` GitHub account (12 app/infra repos scanned + `ardieworks` itself).
**Method:** Read-only code scan — env files, `vercel.json`, config, source, and SQL/migration files. No keys or secrets are printed in this report; only project refs and variable *names*.

---

## Summary table

| App | Supabase project ref | Auth? | DB tables (rough count) | Storage? | Realtime? | RLS? | Edge functions? | Migration difficulty |
|---|---|---|---|---|---|---|---|---|
| **artcoach** | *not in code* — set via env (`VITE_SUPABASE_URL` / `SUPABASE_URL` in Vercel) | ✅ Yes (email/password, reset, sessions) | 4 (`profiles`, `artworks`, `analyses`, `knowledge`) | ✅ Yes (private `artworks` bucket) | ❌ No | ✅ Yes (extensive) | ❌ No (uses Vercel `/api`) | **Hard** |
| **fsy-card-maker** | `fdsdsaieqkdshakskzoa` (hardcoded in `index.html`) | ✅ Yes (email/password) | 1 (`user_cards`) | ✅ Yes (public `card-audio` bucket) | ❌ No | ✅ Yes | ❌ No (uses Vercel `/api`) | **Medium–Hard** |
| pet2get | — (mentioned in agent docs only, no client) | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — no database |
| moodcast | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — localStorage only |
| svg-maker-app | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — no database (calls Claude API) |
| arcade | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — localStorage only |
| ardiejohnson-com | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — static site |
| wealthlab | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — in-memory only (no persistence found) |
| ai-compass | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — localStorage only |
| auction-app *(old, not deployed)* | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — Next.js, no database |
| testapp | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — placeholder repo (docs only) |
| ardieworks | — | ❌ | 0 | ❌ | ❌ | ❌ | ❌ | n/a — agency HQ / infra repo |

**Bottom line: only 2 of 13 repos actually use Supabase — artcoach and fsy-card-maker.** Everything else is client-side (localStorage or no persistence at all).

---

## Shared project vs. own project

- **fsy-card-maker** points at project ref `fdsdsaieqkdshakskzoa` (hardcoded in `index.html` alongside a `sb_publishable_` anon key — public by design, that's fine).
- **artcoach** keeps its project URL entirely in environment variables (Vercel env + `.env.local`); the ref never appears in the code, so **the code alone can't confirm whether artcoach shares fsy-card-maker's project or has its own**. To settle it: open the Vercel dashboard → artcoach project → Environment Variables and compare the `SUPABASE_URL` subdomain against `fdsdsaieqkdshakskzoa`. (Keeping the ref out of code is good practice — no action needed either way.)

## Per-app detail (the two Supabase apps)

### artcoach — the deep integration
- **Auth:** full email/password lifecycle — `signUp`, `signInWithPassword`, `resetPasswordForEmail`, `updateUser`, `getSession`, `onAuthStateChange` in the React client, plus server-side `auth.getUser()` token verification in `api/analyze.ts`.
- **Database:** 4 tables across 3 migration files (`supabase/migrations/001_init.sql`, `002_knowledge_seed.sql`, `003_onboarding.sql`). Queried heavily from the client (`artworks` ×14, `profiles` ×5, `analyses` ×3, `knowledge` ×1).
- **Storage:** private `artworks` bucket where every user is confined to their own folder via storage RLS policies (`storage.foldername(name)[1] = auth.uid()`).
- **RLS:** ~17 policy/RLS statements in `001_init.sql`, covering both tables and storage. The security model *is* RLS — the client talks to the database directly with the anon key.
- **No realtime, no Supabase edge functions** (server logic lives in Vercel `/api`).

### fsy-card-maker — the lighter integration
- **Auth:** email/password (`signUp`, `signInWithPassword`, `getSession`, `onAuthStateChange`) in the single-file `index.html`.
- **Database:** 1 table (`user_cards`) with RLS, defined in `supabase-setup.sql`.
- **Storage:** public `card-audio` bucket used as an MP3 cache; created and written server-side by `api/generate-audio.js` using the service-role key **from Vercel env vars only** — ✅ verified no secret keys are committed anywhere in the repo.
- **No realtime, no edge functions.**

## Apps on a *different* (or no) database

| App | What it actually uses |
|---|---|
| moodcast, arcade (hoarder-patrol), ai-compass, pet2get | Browser `localStorage` — data lives on the user's device |
| svg-maker-app | No database; calls the Claude API for generation |
| wealthlab | Nothing — state is in-memory, lost on refresh |
| ardiejohnson-com, app-template, ardieworks, testapp | Static/infra, no data layer |
| auction-app | Next.js starter, no database wired up (old project, not deployed) |

Note: ai-compass *mentions* Supabase, Firebase, Neon, MongoDB etc. — but only as entries in its tool-directory content, not as dependencies. Same for pet2get, where Supabase appears only in `.claude/agents/launch.md` docs (a planned feature, never built).

---

## Recommendation

**Short version: there is nothing worth migrating, and nothing that *can* migrate easily.**

1. **No app is "trivially portable" to Neon/plain Postgres** — because no app uses Supabase as *just* a Postgres database. The only two Supabase apps both lean on Auth + Storage + RLS, which are exactly the features plain Postgres hosts don't provide. Moving either one means replacing login (e.g. Clerk/Auth.js), file storage (e.g. S3/Vercel Blob), and rewriting the RLS security model as server-side checks.

2. **artcoach should stay put.** It's the textbook "deeply tied" app: client-direct database access secured entirely by RLS, private per-user storage, and auth woven through every view. Migrating it is a rewrite of its security architecture, not a data move.

3. **fsy-card-maker should also stay, but it's the escape hatch if you ever consolidate.** One table, one public bucket, simple auth — if you ever wanted off Supabase, this is a weekend job (swap auth provider, move MP3 cache to Vercel Blob, put the one table behind an API route). Not worth doing proactively.

4. **Everything else already costs you $0 in database hosting** — localStorage and static apps have nothing to migrate. If any of them later needs a backend, decide then whether it joins an existing Supabase project or gets Neon (Neon is the better fit for a future app that needs *only* SQL, no auth/storage).

5. **One follow-up worth 2 minutes:** confirm in the Vercel dashboard whether artcoach and fsy-card-maker share one Supabase project or run two. Two small apps on the free tier is fine either way, but knowing the blast radius (one project pausing/breaking affects which apps) is worth having written down — add it to the table above once confirmed.

*Hygiene note (all good):* no service-role keys, JWTs, or other secrets are committed in any repo — fsy-card-maker's service-role key correctly lives only in Vercel env vars, and artcoach ships only `.env.example` placeholders.
