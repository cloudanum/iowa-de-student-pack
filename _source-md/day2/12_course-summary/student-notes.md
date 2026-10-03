# Course summary — the two days against your migration map

Student notes for Day 2 (Tue Oct 6), 3:50–4:10 PM CT: the fast retrace of everything you did, mapped onto your own migration, plus where to go next.

## The two days, retraced against your migration

**Day 1 — landing your data in BigQuery:**

1. The reframe: two days = your migration story — **kill the nightly extracts → land in BigQuery → Bronze/Silver/Gold → Dataform → the Power BI you already have.** Everything you did hangs on that spine.
2. GCP orientation: console, projects, IAM, billing. You starred `bigquery-samples`, `bigquery-public-data`, and `roi-bq-demos`, and created your own `class` dataset — your scratch space for the rest of the course.
3. The resource hierarchy: **project → dataset → table** — your instance → database → schema.table mental model, translated.
4. First lab: you loaded data into BigQuery in minutes. First win in an unfamiliar console.
5. **Datastream = the extract-killer.** Log-based CDC: no triggers, no polling, no production load — and SQL Server is a supported source. You changed a row in the source and watched it land in BigQuery over lunch. No nightly job, no extract window.
6. Loading files three ways — console, `bq load`, and `LOAD DATA` SQL — from the `jwd-gcp-demos` bucket into your `class` dataset. The console form and the CLI are two front-ends for the same load job, and batch loads are free.
7. The autodetect pitfall (DIN §25): `N/A` in a numeric column — a loud failure on one file, a silent STRING column on another. **Pin schemas, declare null markers, fail loudly.**
8. The CSV-vs-Parquet race (DIN §26): 60M rows — about two minutes vs seconds. Formats decide speed and cost before you write a line of SQL.
9. ELT: transforms run inside BigQuery, in SQL. Scheduled queries hooked your SQL Agent instincts; BigQuery scripting and stored procedures map to your T-SQL habits.
10. **Dataform = your Silver→Gold tool.** SQLX models, assertions, release configs, and git — your existing CI/CD discipline translates directly.
11. Automation: Cloud Scheduler ≈ SQL Agent jobs; Composer when pipelines get many and interdependent; Dataform release configs chain the transforms. M&O's job shifts from "restart the failed job" to "watch a freshness metric."

**Day 2 — your target operating model:**

12. Lakehouse vocabulary, then Bronze made tangible: GCS + open formats (Parquet, Iceberg), external and BigLake tables — and federated queries, your linked-server/`OPENQUERY` mental model without moving any data (DIN §30).
13. Modernizing the warehouse: partitioning and clustering previewed (the Data Warehousing course goes deep), and Iceberg tables for an open Bronze layer.
14. Governance + the medallion: Google's own Bronze/Silver/Gold zone slides matched your architecture document. Knowledge Catalog, Sensitive Data Protection, and fine-grained security back your single-source-of-truth requirement.
15. The last mile, closed: BQML showed a door that exists for later; the Google BigQuery connector puts your Gold marts in the Power BI you already have — Import-first, service account in the service. Same authors, same workspaces, same DAX; only the connection string changes. And in the capstone, your group mapped a real job: that page is backlog draft zero.

## Your SQL Server world → GCP world (the whole course on one table)

| Your SQL Server world | GCP world |
|---|---|
| Nightly extract jobs / SSIS sweeps | Datastream (CDC) for databases; Storage Transfer + `LOAD DATA` for files |
| SQL Agent jobs | Cloud Scheduler, scheduled queries, Dataform release configs |
| SSIS package transforms | Dataform SQLX models (Silver→Gold), in git |
| T-SQL stored procedures | BigQuery scripting / stored procedures, or Dataform operations |
| Linked servers / `OPENQUERY` | Federated queries; external and BigLake tables |
| SQL Agent proxy accounts | Service accounts with least-privilege IAM roles |
| Instance → database → schema.table | Project → dataset → table |
| The reporting copy your reports read | Gold marts in BigQuery |
| Power BI's SQL Server connection | The Google BigQuery connector — [the last-mile guide](../../reference/powerbi-bigquery-connector-guide.md) |

## Where to go next

- **Data Warehousing with BigQuery (3 days, being scheduled).** Goes deep on everything Day 2 previewed: partitioning and clustering, query optimization and cost control, Iceberg, and governance. That is the training behind this one — ask your coordinator about dates.
- **Optional homework: the serverless Spark lab** from Day 1's ETL module, still waiting in your Skills classroom (<https://www.skills.google/ilt/classrooms/37990>). Worth an hour if you want to see the "when SQL isn't enough" escape hatch for yourself.
- **Keep practicing — it costs nothing to stay sharp:**
  - BigQuery's free tier gives every billing account 1 TiB of queries and 10 GiB of storage per month, and batch loads are always free — see [BigQuery pricing](https://cloud.google.com/bigquery/pricing).
  - The `bigquery-public-data` project you starred on Day 1 is hundreds of real datasets you pay nothing to store — you only pay for queries, inside the free tier above. Details: [BigQuery public datasets](https://cloud.google.com/bigquery/public-data).
  - The [Do-It-Now (DIN) activities page](https://roitraining.github.io/gcp-demos/bigquery.html) has everything you did in class — §3 (console orientation), §24–§27 (loading, the autodetect pitfall, the format race, `LOAD DATA`), §29 (derived tables), §30 (external tables) — plus many more you haven't touched (time travel, caching, clustering, execution details). Each activity is self-contained and labeled by cost.
  - The Dataform demo repository from class — <https://github.com/jwdavis/dataform-demo> — is public; clone it and rebuild the staging → mart workflow in a scratch project.
- **Your capstone map.** Photograph it if you haven't. It's backlog draft zero for the migration project — see the [capstone worksheet](../11_capstone-workshop/worksheet.md).

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
