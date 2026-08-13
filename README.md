# ArdieWorks HQ

The single source of truth for **ArdieWorks** — the agentic system that builds,
previews, and ships the [ardiejohnson.com](https://ardiejohnson.com) app
portfolio. The agents and conventions used to be photocopied into every app
repo via `app-template`; now they live here, and everything else is a
distribution channel.

```
ardieworks (this repo)  ← edit agents/skills/conventions HERE
 ├── Claude Code plugin  → installed once on the laptop, available in every project
 └── sync-template (GitHub Action + script) → refreshes app-template, so new repos are born current
```

## Install on the laptop (one time)

In any Claude Code session:

```
/plugin marketplace add ardiejohnson/ardieworks
/plugin install ardieworks@ardieworks
```

After that, every project on the machine has the full agency (frontend-builder,
backend-supabase, reviewer, preview, promote, new-app, launch) plus all the
skills. To pick up updates later: `/plugin marketplace update ardieworks`.

Web and phone sessions get the agency from each repo's own `.claude/` folder.
The `sync-template` GitHub Action keeps `app-template` fresh automatically —
when canonical files change on `main` it opens a PR on app-template (needs the
`TEMPLATE_SYNC_TOKEN` secret; see the workflow file for one-time setup). Manual
fallback:

```
./scripts/sync-template.sh /path/to/app-template
```

## Layout

| Path | What it is |
|---|---|
| `CLAUDE.md` | Canonical portfolio conventions (stack, shipping rules, repo↔subdomain table) |
| `plugins/ardieworks/agents/` | The agency: builder, backend, reviewer, preview, promote, new-app, **launch** |
| `plugins/ardieworks/skills/` | The skills: **go-live**, **audit-app**, **starting-an-app-from-chat**, **portfolio-status**, **fewer-prompts** |
| `template/` | Files every new app is born with: CI workflow, permissions allowlist, the HomeButton pill (React + static) |
| `scripts/sync-template.sh` | Pushes canonical files into `app-template` |
| `.github/workflows/sync-template.yml` | Auto-opens the app-template sync PR when canonical files change |

## The agents

Build with **frontend-builder** / **backend-supabase** → **preview** (PR + the
actual preview URL, verified built) → QA + **reviewer** (real phone-size browser
pass when Chromium is available) → **promote** (merge → live, deploy verified
green). **new-app** onboards a loose HTML/JSX file into a repo; **launch** wires
up hosting, backend, domain, and branch protection around it — automating
whatever the session has capabilities for (Vercel/Supabase/GitHub MCP connectors
in web sessions, tokens + the GoDaddy script on the laptop) and printing a short
manual checklist for the rest.

## Rules that never change

- Never push straight to `main` — branch → PR → preview → review → merge.
- Never commit secrets. Client apps get the Supabase anon/publishable key only.
- Mobile-first; every app carries the back-to-home pill and a homepage card.
