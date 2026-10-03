# Module 3 Notes — Extract and Load (EL): landing files in BigQuery

Your notes for the first after-lunch module on Day 1 (Mon Oct 5, 2026, 13:15–13:45 CT). It sets up the hands-on [loading block](../08_loading-block/activity-guide.md) that follows at 13:45, where you'll do all of this yourself.

## Key takeaways

- **Extract & Load is your Bronze-landing pattern for files.** Datastream (this morning) covers databases that never stop changing; EL covers the other half of your world — files that arrive on a schedule. Land the file in BigQuery as-is, transform later. That "land first, transform later" shape is exactly your Bronze layer.
- **One load job, three front doors.** The console's Create-table form, the `bq load` command, and the `LOAD DATA` SQL statement all submit the same kind of load job. Pick per situation: console for exploring, CLI for scripts, SQL for anything that must live in a procedure or a scheduled query.
- **Batch loads are free.** Loads run on a shared pool of load capacity, not on your query slots. Queries bill by bytes scanned; loads don't bill at all. (You'll verify "Bytes billed: 0 B" with your own eyes in the loading block.)
- **Loads append by default.** Re-running a load adds the rows again; a replace/overwrite flag truncates first. Decide deliberately which one each pipeline means.
- **Autodetect is a starting point, not a pipeline.** It samples the start of a file and guesses types. Fine for a first look; never for a recurring feed. Pin schemas for anything that runs more than once — the loading block shows you the failure that taught this rule.
- **File formats decide load speed.** A single gzipped CSV can't be split across workers; Parquet is splittable, columnar, binary, and carries its own schema. You'll race the same 60 million rows both ways — minutes versus seconds.
- **BigQuery Data Transfer Service is scheduled ingest as a service.** It automates recurring loads — from SaaS applications, Cloud Storage, and more — on a schedule. Think of it as the managed answer to the SQL Agent import job.
- **External tables let you query data where it lives.** You define a table in BigQuery over files that stay in Cloud Storage (or Google Sheets); there is no load step and the data doesn't move. Good for exploration and for data you rarely scan.
- **BigLake tables are external tables with warehouse manners.** They add governance and performance features — fine-grained security, metadata caching — over files in open formats. This is the bridge to Day 2's lakehouse and your Bronze → Silver → Gold design.
- **The table-type choice is per dataset, not per platform.** Managed, external, and BigLake tables coexist in the same project and the same queries. Your medallion layers can mix them deliberately.

## Your SQL Server world → GCP world

| Your SQL Server world today | The GCP world you're moving to |
|---|---|
| BULK INSERT / OPENROWSET(BULK) | `bq load`, or `LOAD DATA ... FROM FILES` in SQL |
| Import and Export wizard | Console: Create table from Google Cloud Storage |
| SSIS flat-file import package | A scripted `bq load`, or `LOAD DATA` inside a scheduled query |
| SQL Agent job importing a daily file | BigQuery Data Transfer Service (or a scheduled query) |
| Staging file share (`\\server\drops`) | A Cloud Storage bucket — your Bronze landing zone |
| Linked server pointing at external files | External table over a Cloud Storage bucket |
| Fixed staging-table schema in source control | A pinned schema JSON file in source control |

## Managed vs external vs BigLake (lakehouse) tables

| | Managed table | External table | BigLake table |
|---|---|---|---|
| Where the bytes live | BigQuery-managed storage | Your files (Cloud Storage, Sheets, ...) | Your files in Cloud Storage, in open formats |
| Where the schema/types come from | BigQuery | Declared in BigQuery, read from the files at query time | Declared in BigQuery; formats like Parquet carry real types |
| Query performance | Full BigQuery storage optimizations | Files read at query time | External, plus performance features such as metadata caching |
| Governance | Full BigQuery security | Limited | Fine-grained (row/column) security over the files |
| Likely fit in your migration | Silver/Gold data marts | Exploration; rarely-scanned data | The Bronze lakehouse zone — Day 2's subject |

## Dig deeper

- [Loading data into BigQuery](https://cloud.google.com/bigquery/docs/loading-data)
- [The bq command-line tool](https://cloud.google.com/bigquery/docs/bq-command-line-tool)
- [LOAD DATA statement reference](https://cloud.google.com/bigquery/docs/reference/standard-sql/load-statements)
- [BigQuery Data Transfer Service](https://cloud.google.com/bigquery-transfer/docs/introduction)
- [Querying external data sources](https://cloud.google.com/bigquery/docs/external-data-sources)
- [BigLake tables](https://cloud.google.com/bigquery/docs/biglake-intro)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
