# Closr

Overnight shutdown checklist with photo & video proof. Live at **closr.ardiejohnson.com**.

An employee picks a location, works through its checklist, attaches proof photos
and/or short videos (10 seconds max), and signs off. Managers set up locations and
checklist items from the Locations tab.

## How it's built

- A single self-contained `index.html` — no build step, mobile-first.
- Checklist and record data live in the browser's localStorage.
- Photos and videos live in the browser's IndexedDB (localStorage is far too small
  for video). Storage is per-device, per-browser — clearing the browser's site data
  deletes the records. The app asks the browser for persistent storage to reduce
  the chance of automatic cleanup.
- Videos longer than 10 seconds are rejected at selection time (when the phone
  reports a duration).
- "Export Records" downloads the record list as JSON; media stays on the device.

## Ship flow

Standard portfolio flow — branch → PR → Vercel preview URL → QA → merge to `main`
(production). Never push straight to `main`. See `CLAUDE.md` for the full rules.
