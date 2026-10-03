# Day 1 Schedule — Monday, October 5, 2026

"Landing your data in BigQuery" · 9:00 AM–4:30 PM CT · virtual. Day 1 is about console confidence and getting data in: loading files, streaming database changes live, and your first Dataform pipeline.

| Time | Block | What you'll walk away with |
|---|---|---|
| 09:00–09:25 | **[Welcome & your migration story](01_welcome-and-intro/student-notes.md)** | The shape of the two days: kill the extracts → land in BigQuery → Bronze/Silver/Gold → your existing Power BI reports |
| 09:25–10:10 | **[DE building blocks on GCP](02_m1-de-tasks-components/student-notes.md)** | The GCP moving parts — projects, datasets, Cloud Storage, BigQuery — mapped to the sources/transforms/sinks model you already think in |
| 10:10–10:25 | **[Hands-on: find your way around the console](03_activity-console-orientation/activity-guide.md)** | Three starred projects (`bigquery-samples`, `bigquery-public-data`, `roi-bq-demos`) and your own `class` dataset, created by you (DIN §3 — see note below) |
| 10:25–10:40 | **Break** | |
| 10:40–11:10 | **[Lab: your first BigQuery load](04_lab-loading-data-into-bigquery/lab-companion.md)** — *Loading Data into BigQuery* | Your first finished lab in an unfamiliar console: a real table, loaded by you |
| 11:10–11:50 | **[Killing the nightly extracts](05_m2-data-replication-migration/student-notes.md)** | Why log-based change data capture (Datastream) replaces the extract window — SQL Server is a supported source, with no triggers and no load on production |
| 11:50–12:00 | **[Lab: set up a live replication stream (part 1)](06_lab-datastream-postgres-to-bq/lab-companion.md)** — *Datastream: PostgreSQL → BigQuery* | A running stream replicating a database into BigQuery before lunch |
| 12:00–13:00 | **Lunch** — your stream keeps replicating | |
| 13:00–13:15 | **[Lab part 2: watch changes land](06_lab-datastream-postgres-to-bq/lab-companion.md)** | The CDC moment, felt: rows changed at the source appear in BigQuery with no job run |
| 13:15–13:45 | **[Loading files the right way](07_m3-extract-and-load/student-notes.md)** | The extract-and-load pattern for file drops: console loads, the `bq` CLI, scheduled ingest with the BigQuery Data Transfer Service, and when an external table beats a load |
| 13:45–14:30 | **[Hands-on: four ways to load (and the format race)](08_loading-block/activity-guide.md)** | Console & CLI load, the autodetect N/A pitfall, the 60-million-row CSV-vs-Parquet race, and `LOAD DATA` SQL (DIN §24–§27) — plus the rule: pin schemas for anything recurring |
| 14:30–14:45 | **Break** | |
| 14:45–15:25 | **[ELT & Dataform — your Silver→Gold tool](09_m4-elt-and-dataform/student-notes.md)** | How Dataform turns your SQL into a versioned, tested, scheduled pipeline — the tool your own architecture doc already names |
| 15:25–16:05 | **[Lab: build a SQL workflow in Dataform](10_lab-dataform-sql-workflow/lab-companion.md)** — *Create & Execute a SQL Workflow in Dataform* | A working workflow you built yourself: models, dependencies, assertions |
| 16:05–16:20 | **[When SQL isn't enough + automation](11_m5-m6-etl-and-automation/student-notes.md)** | The escape hatches (Pub/Sub, Dataflow) and the automation map: Cloud Scheduler ≈ SQL Agent, Composer ≈ the orchestrator, Dataform release configs ≈ your CI/CD |
| 16:20–16:30 | **[Wrap-up: schedule your first query](12_close-scheduled-query/activity-guide.md)** | Your first piece of BigQuery automation: a query on a daily schedule overwriting a table (DIN §29, step 5) — no SQL Agent box required |

## Worth knowing before you arrive

- **Every block title above links to its module notes or lab/activity companion in this folder.** Open the companions before the hands-on blocks — they carry the gotchas.
- **The `class` dataset matters.** You create it yourself at 10:10, in your own lab project. Every loading activity this afternoon writes into it — it's the one step that can't be skipped or made up later.
- **Labs live in the [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990).** Launching a lab starts its timer and hands you a temporary GCP project. The lab's own steps are in the classroom; the companions in this folder add orientation and gotchas.
- **"DIN" = the Do-It-Now activities page:** <https://roitraining.github.io/gcp-demos/bigquery.html> — a public set of short BigQuery exercises referenced by section number (§) all day. All four loading DINs this afternoon are free.
- **The Datastream lab uses PostgreSQL** because it's free-tier friendly. The mechanics — connection, stream, backfill, change capture — are identical for SQL Server, which is a supported Datastream source ([docs](https://cloud.google.com/datastream/docs/sources)).
- **Demo data you'll touch today:** the public `roi-bq-demos` and `bigquery-public-data` projects, and the public GCS bucket `jwd-gcp-demos`.

## Reference cards to keep open today

- [BigQuery console survival guide](../reference/bigquery-console-survival-guide.md) — during the 10:10 console orientation and every lab
- [T-SQL → BigQuery SQL](../reference/tsql-to-bigquery-sql.md) — the moment you start typing queries
- [GCP for SQL Server professionals](../reference/gcp-for-sql-server-professionals.md) — the mapping card behind every block today

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
