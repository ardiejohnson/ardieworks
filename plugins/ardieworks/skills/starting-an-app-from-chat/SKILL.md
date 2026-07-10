---
name: starting-an-app-from-chat
description: The workflow for turning a prototype built in a Claude chat (an HTML page or JSX/React component) into a full ardiejohnson.com portfolio app. Use when Ardie says he has an idea/file from a chat ready to build out, or asks "how do I start a new app".
---

# From a Claude chat prototype to a live app

Ardie prototypes ideas in the Claude chat app, reaches a working HTML/JSX artifact, then moves to Claude Code to build it out with the ArdieWorks agency. This is that handoff.

## First, know which Claude Code you're in (this is the thing that matters, NOT which machine)
There are two, and both can be open on the same computer. The difference is credentials, not device — do not say "laptop vs phone."

| | **Terminal Claude Code** | **claude.ai/code (browser)** |
|---|---|---|
| What it is | The app in the Mac terminal where Ardie ran `/plugin install` and set up tokens | The web version, opened in a browser tab (desktop or phone) |
| Has the tokens? | **Yes** — Supabase + Vercel in the shell profile / MCP config, `gh` CLI available | **No** — runs in a cloud container with none of Ardie's credentials |
| Can create a repo? | **Yes**, in one command | **No** — only lists repos that already exist |
| Path to use | Fast path (below) | Portable path (below) |

Opening claude.ai/code on the desktop is still the browser version — it does **not** gain the tokens.

## The one thing that can't be automated (either way)
There is **no bridge between the Claude chat app and Claude Code** — separate products, no shared file access. The code moves by hand *once*: **paste it straight into the first Claude Code message.** (Saving the artifact to Files and attaching it also works, nicer for very large files, but it's optional — no file export needed.)

## Fast path — Terminal Claude Code (recommended)
It has `gh` and the tokens, so the agent creates the repo from the template in one command (no "Use this template" clicking):

```
gh repo create ardiejohnson/<name> --template ardiejohnson/app-template --private --clone
```

That gives a repo already carrying the agency (agents + CLAUDE.md + skills). The whole thing is one message:

> Start a new app called <Name>: <one-line description>. Here's the prototype from a chat: <paste code>. Create the repo from app-template (private), onboard it with new-app, then launch it and open a preview PR.

Then: new-app → **launch** → preview → reviewer → **promote**.

## Portable path — claude.ai/code browser (desktop or phone)
The browser version can't create repos, and its repo picker only shows repos that already exist — so **don't pick `app-template` or `ardieworks` and work there** (that pollutes the template/agency). Instead, make the repo first:
1. github.com/ardiejohnson/app-template → **Use this template → Create a new repository** → name it, choose **Private**.
2. Refresh claude.ai/code and select the new repo in the picker.
3. First message: paste the prototype code and say *"new-app: onboard this, then open a preview PR."*
4. Hosting/backend wiring (`launch`) needs the tokens, so run that step from Terminal Claude Code (or via the dashboards on the go-live checklist).

## Why the browser version can't just be given the tokens
Its only place to set values is the environment's "Environment variables" field, which is **plaintext and explicitly not for secrets** (the UI warns: "visible to anyone using this environment — don't add secrets or credentials"). So do NOT put account tokens there. Token automation stays in Terminal Claude Code, where credentials are stored properly. If a real secrets store appears in the browser version later, revisit this.

## Rules carried in from the rest of ArdieWorks
- App repos are **private by default** (see the visibility policy in CLAUDE.md).
- Never push to `main`; everything ships branch → PR → preview → review → merge.
- After it's live, walk the **go-live** checklist (domain, DNS, Supabase Site URL, homepage card).
