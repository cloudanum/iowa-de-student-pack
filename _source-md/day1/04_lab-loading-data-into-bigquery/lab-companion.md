# Lab Companion: Loading Data into BigQuery

Companion notes for the first lab of Day 1 (10:40–11:10 AM CT). The lab's own step-by-step instructions live in the [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990) (Course 1, Module 1 lab) — this page adds orientation and gotchas around them, not a second copy of the steps.

## What you'll do

- Load data into BigQuery from various sources
- Load using both the Google Cloud console and the `bq` command-line tool
- Use DDL to create tables

## Why it matters for your migration

This is the simplest possible version of what your nightly extract jobs do: a file becomes a queryable table. It's the Bronze-landing mechanic for file-based sources, and it's deliberately easy — your first win in an unfamiliar console, not a skills test. By 13:45 you'll have loaded data four more ways, each one closer to how your real migration will run.

## Before you start

- [ ] The lab is launched from the Skills classroom and the **lab timer is running** — having the instructions open is not the same as having the lab started.
- [ ] You're signed in to the console with the **lab credentials** the classroom gave you, not a personal or organizational account.
- [ ] The **project picker** in the top bar shows your lab project.
- [ ] Your `class` dataset exists (you created it in the [10:10 console orientation](../03_activity-console-orientation/activity-guide.md)). This lab doesn't strictly require it, but the 13:45 loading block does — if it's missing, create it now: your project's ⋮ menu → **Create dataset** → ID `class`.

## Common gotchas

> **The autodetect-schema checkbox.** Miss it — or feed it a file it can't make sense of — and BigQuery builds a table with a single `string` column holding whole rows. If that happens to you: note it and move on; don't spend lab time fixing it. At 13:45 we reproduce this failure on purpose, and you'll see exactly why it happens and how to load around it.
>
> **"Enable API" prompts.** Normal on first use of a service in a fresh lab project. Click **Enable** and keep moving — don't stop to read the API catalog page.
>
> **Cloud Shell's first open.** Expect a few consent / authorize / continue clicks the first time you launch it. One-time per project; later opens are instant.
>
> **Wrong project.** The console defaults to the last-used project. If a menu item "doesn't exist," check the picker before anything else.
>
> **Can't find BigQuery?** Navigation (hamburger) menu → **BigQuery** — hover and pin it — or use the search bar.

## If you finish early

Finishing in 10–12 minutes is expected for people who write SQL all day. Use the extra time on **§24 of the [Do-It-Now (DIN) activities page](https://roitraining.github.io/gcp-demos/bigquery.html)**: load a CSV from the public `jwd-gcp-demos` Cloud Storage bucket into **your own `class` dataset** using the console. That's exactly what the whole group does at 13:45 — you'll be the resident expert.

**Note your load time.** It feeds the CSV-vs-Parquet race this afternoon (DIN §26).

## Debrief: three ways in, same destination

1. **Console click-through** — point, click, table. The GUI your one-off imports always wanted.
2. **`bq load`** — the same job from the command line: scriptable, repeatable, the shape of automation.
3. **DDL (`CREATE TABLE` / `LOAD DATA`)** — load logic as code, where it can live in source control and ride your CI/CD discipline.

Your SSIS packages are the fourth way in. Datastream — next hour — is the fifth, and it's the one that kills the nightly extract entirely.

## Self-check

- [ ] You loaded at least one table through the console
- [ ] You ran (or watched run) a `bq load` from Cloud Shell
- [ ] You created a table with DDL
- [ ] Your `class` dataset still exists — and if you did the early-finisher activity, it now holds a table and you've written down the load time

## What this replaces in your current stack

| You do this today | On GCP |
|---|---|
| SQL Server Import and Export Wizard / one-off flat-file SSIS package | Console **Create table** load |
| BCP / `BULK INSERT` scripts | `bq load` from Cloud Shell |
| DDL deployment scripts in your CI/CD repo | `CREATE TABLE` / `LOAD DATA` DDL (GoogleSQL) |

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
