# M1: Data Engineering Tasks and Components — Student Notes

Notes for the first module of Day 1 (9:25–10:10 AM CT): the moving parts of a data platform on Google Cloud, mapped to the SQL Server stack you already run. You already know the concepts — this module is about where each one lives in GCP.

## Key takeaways

- **Sources → transforms → sinks is your SSIS mental model, unchanged.** Data sources (databases, files, streams), transforms (clean, join, aggregate), sinks (where the result lands). GCP swaps the tools, not the shape of the pipeline.
- **BigQuery is serverless: there is no "instance."** No service to start, no version to patch, no capacity to provision. You create datasets and tables and run queries; Google allocates the compute. In the next activity you'll browse a 100-billion-row table without provisioning anything.
- **File format matters more than file location.** CSV is row-oriented text: every consumer re-parses every byte, and the schema is guesswork. Parquet is columnar, compressed, and carries its schema with it. Hold that thought — this afternoon you'll race the same ~60-million-row dataset loaded from CSV vs. Parquet (minutes vs. seconds) and never look at a flat-file extract the same way again.
- **Cloud Storage (GCS) and BigQuery do different jobs.** GCS is object storage: files at rest, cheap, any format — your landing zone and the future home of your Bronze layer. BigQuery is the analytics engine and managed table store — your Silver/Gold and the single source of truth. Day 2 shows how they combine into one lakehouse.
- **First pass at the vocabulary:** a *data lake* is raw files in open formats on object storage; a *data warehouse* is curated, governed, query-optimized tables; a *lakehouse* aims to be both over one copy of the data. Day 2's opening module teaches this properly — for now, just recognize the words.
- **GCP organizes everything as organization → folders → projects → resources.** BigQuery adds one level of its own: **project → dataset → table**. A dataset is a collection you secure as a unit, and it lives in a specific location.
- **IAM and billing attach at the project.** Who can do what, and who pays for it, are project-level decisions; datasets and tables inherit. In class your lab project is pre-built; in your real migration, project layout is an architecture decision, not an administrative afterthought.
- **Locations are chosen once.** A dataset's region (or multi-region) is fixed at creation. Where your warehouse lives is a decision to make deliberately.
- **Scheduling exists natively.** Cloud Scheduler and BigQuery scheduled queries cover what SQL Agent does for you today — you'll see one scheduled before the end of Day 1.

## Your SQL Server world → GCP world

| Your SQL Server world | GCP world (this course) | Where you'll see it |
|---|---|---|
| SQL Server instance | GCP **project** — the boundary for billing, IAM, and quotas | Every lab runs in its own project |
| Database | BigQuery **dataset** — the security and location unit | You create your own at 10:10 |
| `schema.table` (e.g., `dbo.FactOrders`) | **table** in a dataset, fully qualified as `project.dataset.table` | This morning's lab |
| SSIS packages | **Dataform** (SQL ELT — your Silver→Gold) and **Dataflow** (heavy-duty, programmatic transforms) | Preview: Dataform this afternoon, Dataflow in the M5 segment |
| SQL Server Agent jobs | **Cloud Scheduler** and BigQuery **scheduled queries** | Preview: Day 1 close |
| T-SQL | **GoogleSQL**, BigQuery's SQL dialect | You'll write it within the hour |
| Stored procedures | BigQuery **scripting** and Dataform operations | Preview: Day 1 afternoon |

## Dig deeper

- [BigQuery resource hierarchy](https://cloud.google.com/bigquery/docs/resource-hierarchy) — organization → project → dataset → table, and where quotas and billing attach
- [Introduction to datasets](https://cloud.google.com/bigquery/docs/datasets-intro) — locations, and why they're permanent
- [BigQuery IAM roles and permissions](https://cloud.google.com/bigquery/docs/access-control)
- [Cloud Storage overview](https://cloud.google.com/storage/docs/introduction) — buckets, objects, storage classes
- [Loading Parquet data from Cloud Storage](https://cloud.google.com/bigquery/docs/loading-data-cloud-storage-parquet) — the columnar path you'll race this afternoon
- [About Cloud Scheduler](https://cloud.google.com/scheduler/docs/overview) — the SQL Agent analogue

## What's next

[Console orientation activity](../03_activity-console-orientation/activity-guide.md) — put the hierarchy in your hands: star projects, explore a 100-billion-row table, and create the `class` dataset the afternoon depends on.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
