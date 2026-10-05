# Activity Guide: Console Orientation — Projects, Datasets, and Tables

Guided follow-along on Day 1 (10:10–10:25 AM CT), right after M1: your first hands-on tour of the BigQuery console. Based on §3 ("Exploring projects, datasets, and tables") of the [Do-It-Now (DIN) activities page](https://roitraining.github.io/gcp-demos/bigquery.html). No cost; everything happens in the console.

## What you'll do

- Open the BigQuery console and pin it for the day
- Star three projects into your Explorer: `bigquery-samples`, `bigquery-public-data`, `roi-bq-demos`
- Explore a public dataset and a 100-billion-row table (schema, details, preview — no query, no cost)
- Create your own dataset named `class` — **required** for this afternoon's loading activities

## Why it matters for your migration

- **Project → dataset → table** is the GCP resource hierarchy — the same shape as your **instance → database → schema.table**. Everything you build on GCP hangs off this skeleton.
- **Starring is your first taste of "query data where it lives."** Starred projects belong to someone else and stay read-only, yet you can query across them without copying a byte. That is the mechanic behind BigQuery as a single source of truth.
- **The `class` dataset is your landing zone.** Every load this afternoon lands there — think of it as your Bronze layer in miniature.
- **The 100-billion-row table is the scale story, felt.** You're about to browse 100B rows with zero servers provisioned.

## Before you start

- You are signed in to the Google Cloud console with the lab user account from your [Skills classroom](https://www.skills.google/ilt/classrooms/37990) lab.
- You know how to check which project is selected: the **project picker** in the top bar.

## Steps

Follow your instructor's screen; the annotations below tell you what to notice at each stop.

### 1. Get to BigQuery

1. Open the Google Cloud console.
2. Open the navigation menu (the "hamburger" icon, top left) and choose **BigQuery** — or type "BigQuery" into the search bar at the top.
3. Hover over **BigQuery** in the navigation menu and click the pin, so it stays at the top all day.
4. In the **Explorer** pane (left), expand your project. Notice it's empty — nothing exists yet.

### 2. Star three projects

Starring pins someone else's project into your Explorer so you can browse and query it.

5. Open the project in the console — the quickest way is the direct URL: `https://console.cloud.google.com/bigquery?project=bigquery-samples` (or find it in the **project picker** at the top).
6. In the Explorer pane, click the **star outline** next to the project's name so it turns solid — the project is now starred (pinned) in your Explorer.
7. Repeat for: `bigquery-public-data`
8. Repeat for: `roi-bq-demos`
9. Star any additional projects your instructor calls out.

(Console docs: [starring a project](https://cloud.google.com/bigquery/docs/bigquery-web-ui#starring_adding_a_project). The console changes often — older instructions say "+ Add → Star a project by name"; today you open the project and click its star in the Explorer. The recorded walkthrough shows both this and everything below.)

### 3. Explore datasets

10. Expand **bigquery-samples** in the Explorer. Each entry under it is a **dataset** — a collection of tables and views that is secured as a unit and lives in a specific location.
11. Click **wikipedia_benchmark** and read the metadata shown in the right pane.
12. Click the three-dot menu (⋮) next to a dataset name and note the available actions. **This menu is where `Create table` lives** — you'll use it at 10:40.

### 4. Create your `class` dataset — required

13. Click the ⋮ menu next to **your own project** → **Create dataset**.
14. Dataset ID: `class` — exactly that, lowercase, no spaces. The other defaults are fine for class; note the **location** shown before you confirm.
15. Click **Create dataset**, then expand your project to confirm it appears.

**Do not skip this step.** The afternoon loading activities (DIN §24–§27) write into your `class` dataset. If it doesn't exist by 13:45, you'll be creating it while everyone else is loading data.

### 5. Explore tables

16. Expand **bigquery-samples → wikipedia_benchmark** and review its tables.
17. Click the **100B** table — yes, that's 100 billion rows.
18. **Schema** tab: column names and types — the same idea as the SSMS columns view or `sp_help`.
19. **Details** tab: storage size, row count, last-modified time.
20. **Preview** tab: sample rows *without running a query* — free browsing of a 100-billion-row table.
21. Open the ⋮ menu next to the table name and note the table-level actions.

## Common gotchas

> **Wrong project selected.** The console remembers your last-used project and happily shows it to you. If you "can't see what the instructor sees," check the **project picker in the top bar first**. This is the number-one cause of confusion today.
>
> **Starred projects are read-only.** You cannot create anything inside `bigquery-samples`, `bigquery-public-data`, or `roi-bq-demos` — permission errors there are expected. Create things in **your** project.
>
> **Dataset location is permanent.** You choose it at creation and cannot change it afterward — fixing it means recreating or copying the dataset. For class, the default is fine; for your real warehouse, it's an architecture decision.
>
> **The three-dot (⋮) menus hide the actions.** Create dataset, Create table, Delete — if you can't find a button, look for the ⋮.
>
> **New dataset not showing?** Expand your project node in the Explorer pane, or click the refresh icon at the top of the pane.

## If you finish early

- Browse into `bigquery-public-data`, pick any dataset that looks interesting, and open a table's **Preview** tab.
- On the 100B table's **Details** tab, find the exact row count and total size.
- Open your own `class` dataset's ⋮ menu and locate **Create table** — your next stop at 10:40.

## Self-check

- [ ] Three starred projects appear in your Explorer: `bigquery-samples`, `bigquery-public-data`, `roi-bq-demos`
- [ ] Your own project contains a dataset named exactly `class`
- [ ] You can open the Schema, Details, and Preview tabs on `bigquery-samples.wikipedia_benchmark.100B`
- [ ] You know where the project picker is, and which project is yours
- [ ] You found **Create table** in your dataset's ⋮ menu

## What this replaces in your current stack

| You do this today | On GCP |
|---|---|
| SSMS Object Explorer: server → databases → tables | BigQuery Explorer pane: projects → datasets → tables |
| Linked servers / browsing another instance | Starred projects — query across projects without copying data |
| `CREATE DATABASE` plus file and filegroup sizing | Create dataset — one dialog, nothing to size |

**Next:** [Lab 1 companion — Loading Data into BigQuery](../04_lab-loading-data-into-bigquery/lab-companion.md)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
