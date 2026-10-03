# BigQuery Console Survival Guide

Written for your first hours in the Google Cloud console — Day 1 at 10:10, then every lab after. Everything here is clickable in your lab project; nothing here can break anything.

## The project picker (check it first, every time)

The bar at the very top of the console shows the **currently selected project** next to the Google Cloud logo. Every page you open shows resources for *that* project only.

> **Gotcha — the wrong-project trap:** if the console looks empty, a dataset you just made has "disappeared," or a lab step's screenshots don't match what you see, you're probably in the wrong project. Click the project name in the top bar and switch. In this course your labs hand you one project each — if the picker shows something else, fix that before anything else.

## Starring (pinning) projects

Your own project appears in the BigQuery **Explorer** pane automatically. To see *other people's* projects — the public datasets and demo data we use all course — you star them:

1. Open **BigQuery** (hamburger menu → BigQuery, under Analytics — or search "BigQuery" in the top search bar).
2. In the **Explorer** pane, click **+ ADD** → **Star a project by name**.
3. Enter the project name, e.g. `bigquery-public-data`, and click **STAR**.

On Day 1 you star three: `bigquery-samples`, `bigquery-public-data`, `roi-bq-demos`. Starred projects are read-only windows into someone else's data — you query across projects without copying anything. ([Docs](https://cloud.google.com/bigquery/docs/bigquery-web-ui#starring_adding_a_project))

## The Explorer pane

The left-hand tree is **project → dataset → table** — your instance → database → schema.table instinct applies, minus the schema layer.

- Expand a dataset to see its tables and views.
- The **three-dot menu** next to any project, dataset, or table is where the actions hide: **Create dataset**, **Create table**, open, delete, and so on. When you're stuck, look for a three-dot menu.

## Schema / Details / Preview — the three tabs that save you money

Click any table and three tabs open:

- **Schema** — column names, types, modes. The first place you look in a new dataset.
- **Details** — row count, size, location, labels, last modified.
- **Preview** — a free peek at actual rows, *without running a query and without scanning bytes*.

> **Gotcha:** `SELECT * FROM big_table LIMIT 10` bills a scan of the columns it reads; the Preview tab shows you rows for free. Use Preview to look, use queries to compute.

## The query editor

- Open a new query tab with the **+** ("Compose new query") at the top of the editor area.
- **RUN** executes. Right beside it, the editor shows a **bytes-processed estimate** ("This query will process N when run") — the single most important habit of the course: **read that number before you press RUN**, especially against public datasets with billions of rows. A 100-billion-row table is free to browse and preview, expensive to `SELECT *`.
- **RUN ≈ executing in SSMS; the estimate ≈ glancing at the execution plan first.** Same instinct you already have.
- **Query history:** the bottom panel's **Personal history** / **Project history** lists every job you've run — click one to re-open its SQL. Nothing you ran is lost; you can always get yesterday's query back.
- Worth memorizing: **Ctrl+Enter** (Windows) / **Cmd+Enter** (Mac) runs the query. BigQuery Studio has a built-in keyboard-shortcut reference for the rest; the full web-UI tour is in the [docs](https://cloud.google.com/bigquery/docs/bigquery-web-ui).

## Cloud Shell

The **terminal icon (`>_`)** at the top right opens Cloud Shell: a small temporary VM in your browser with `gcloud` and the `bq` CLI preinstalled and already authenticated as you.

- **First launch:** it asks you to click **Continue** to start, and may show an **Authorize** consent dialog before running commands. Clicking through these is normal and expected — everyone does it once per environment.
- The `bq` command line is the workhorse for scripting loads: `bq load`, `bq show --schema`, `bq query`. The Day-1 loading block uses it; the files to paste are in your Day-1 activity companions.
- If Cloud Shell asks which project to use, pick your lab project (same wrong-project trap, different room).

## "Enable API?" — not an error

The first time you open certain services in a fresh project (Datastream, Dataform, Cloud Scheduler, …), the console may offer an **Enable API** button. That's the platform turning that service on for your project — click **Enable**, give it a moment, continue. In labs this is routine, not a problem to report.

## Where IAM and Billing live

- **Hamburger menu → IAM & Admin → IAM** — who (people, groups, service accounts) can do what on this project. This is where the service-account discipline from your SQL Agent proxy world lands.
- **Hamburger menu → Billing** — what this project costs. In labs, billing is handled for you; back home, this is where your FinOps questions get answered.

You won't administer either in class — but know where they are. ([IAM & service accounts](https://cloud.google.com/iam/docs/service-accounts))

## If you get lost

- **The search bar at the top of the console finds everything** — services, pages, settings. Type "BigQuery", "Storage", "Datastream", "Scheduler".
- **Hamburger menu → BigQuery** returns you to BigQuery Studio from anywhere.
- Bookmark **<https://console.cloud.google.com/bigquery>** — it goes straight to the studio.
- Still lost? Say so. Sixteen people navigating one new console — someone else is lost in the same place.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
