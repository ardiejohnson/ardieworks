---
name: starting-an-app-from-chat
description: The workflow for turning a prototype built in a Claude chat (an HTML page or JSX/React component) into a full ardiejohnson.com portfolio app. Use when Ardie says he has an idea/file from a chat ready to build out, or asks "how do I start a new app". Covers phone, web, and laptop.
---

# From a Claude chat prototype to a live app

Ardie prototypes ideas in the Claude chat app, reaches a working HTML/JSX artifact, then moves to Claude Code to build it out with the ArdieWorks agency. This is that handoff.

## The one thing that can't be automated
There is **no bridge between the Claude chat app and Claude Code** — separate products, no shared file access. So the code has to move by hand *once*. The low-friction way: **don't export a file at all — paste the code straight into the first Claude Code message.** (Saving the artifact to Files and attaching it also works, and is nicer for very large files, but it's optional.)

Everything after that is automatable.

## The fast path (laptop, or any session with GitHub create rights)
When the session can create repos (`gh` CLI on the laptop, or a GitHub token with repo-create scope in the environment), the agent does it in one command — no "Use this template" tapping:

```
gh repo create ardiejohnson/<name> --template ardiejohnson/app-template --private --clone
```

That clones a repo already carrying the agency (agents + CLAUDE.md + skills). Then hand the prototype to **new-app** → **launch** → preview → reviewer → **promote**.

So the whole thing is one message:

> Start a new app called <Name>: <one-line description>. Here's the prototype from a chat: <paste code>. Create the repo from app-template (private), onboard it with new-app, then launch it and open a preview PR.

## The portable path (phone / web, no create rights yet)
If the session can't create repos, one manual step remains — make the repo:
1. github.com/ardiejohnson/app-template → **Use this template → Create a new repository** → name it, choose **Private**.
2. Open a Claude Code session on the new repo.
3. First message: paste the prototype code and say *"new-app: onboard this, then launch and open a preview PR."*

## Why the fast path is laptop-only (a security boundary, not an oversight)
The fully-automated path needs credentials (GitHub create token, Supabase, Vercel). On the **laptop** those live in the shell profile and Claude's MCP config — proper credential storage. On **claude.ai/code (web)** the only place to set values is the environment's "Environment variables" field, which is **plaintext and explicitly not for secrets** (the UI warns: "visible to anyone using this environment — don't add secrets or credentials"). So do NOT put account tokens there.

Result: run the fully-automated `launch` from the **laptop**; from **phone/web**, use the portable path above (one manual repo-create step, then the agents take over). If a real secrets store appears in Claude Code on the web later, revisit this — until then, laptop is where token automation lives.

## Rules carried in from the rest of ArdieWorks
- App repos are **private by default** (see the visibility policy in CLAUDE.md).
- Never push to `main`; everything ships branch → PR → preview → review → merge.
- After it's live, walk the **go-live** checklist (domain, DNS, Supabase Site URL, homepage card).
