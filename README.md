# ArdieWorks HQ

The single source of truth for **ArdieWorks** — the agentic system that builds,
previews, and ships the [ardiejohnson.com](https://ardiejohnson.com) app
portfolio. The agents and conventions used to be photocopied into every app
repo via `app-template`; now they live here, and everything else is a
distribution channel.

```
ardieworks (this repo)  ← edit agents/skills/conventions HERE
 ├── Claude Code plugin  → installed once on the laptop, available in every project
 └── scripts/sync-template.sh → refreshes app-template, so new repos are born current
```

## Install on the laptop (one time)

In any Claude Code session:

```
/plugin marketplace add ardiejohnson/ardieworks
/plugin install ardieworks@ardieworks
```

After that, every project on the machine has the full agency (frontend-builder,
backend-supabase, reviewer, preview, promote, new-app, launch) plus the
go-live skill. To pick up updates later: `/plugin marketplace update ardieworks`.

Web and phone sessions get the agency from each repo's own `.claude/` folder —
keep those fresh by running the template sync after meaningful changes here:

```
./scripts/sync-template.sh /path/to/app-template
```

## Layout

| Path | What it is |
|---|---|
| `CLAUDE.md` | Canonical portfolio conventions (stack, shipping rules, repo↔subdomain table) |
| `plugins/ardieworks/agents/` | The agency: builder, backend, reviewer, preview, promote, new-app, **launch** |
| `plugins/ardieworks/skills/go-live/` | The go-live checklist (born from the ArtCoach launch) |
| `scripts/sync-template.sh` | Pushes canonical files into `app-template` |

## The agents

Build with **frontend-builder** / **backend-supabase** → **preview** (PR + preview URL)
→ QA + **reviewer** → **promote** (merge → live). **new-app** onboards a loose
HTML/JSX file into a repo; **launch** wires up hosting, backend, domain, and
branch protection around it — automating whatever it has credentials for
(Supabase MCP, `VERCEL_TOKEN`, the GoDaddy script) and printing a short manual
checklist for the rest.

## Rules that never change

- Never push straight to `main` — branch → PR → preview → review → merge.
- Never commit secrets. Client apps get the Supabase anon/publishable key only.
- Mobile-first; every app carries the back-to-home pill and a homepage card.
