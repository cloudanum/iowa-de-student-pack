# Your Migration Map — SQL Server DW to a BigQuery Medallion Lakehouse

Your end-to-end target architecture on one page, built up piece by piece across the two days and completed at the Day-2 capstone. This is the card to print and pin by your desk.

## The whole flow

```
SOURCES                          INGEST — land it once, in one place
==============================   ==================================================================
SQL Server databases       --->  Datastream: log-based CDC — backfill + continuous changes.
(case mgmt, finance, ...)        No triggers, no polling, no nightly window.
                                 SQL Server is a supported source.

County file drops          --->  Files land in a GCS bucket (Storage Transfer or scheduled copy),
(SFTP shares, counties)          then LOAD DATA with a PINNED schema — never autodetect
                                 for anything recurring.

SaaS applications          --->  BigQuery Data Transfer Service: managed, scheduled pulls.

Ad-hoc / one-off files     --->  Console upload, bq load, or LOAD DATA.
====================================================================================================
                                   |
                                   v
BRONZE — raw, immutable, replayable
  GCS buckets: Parquet in Hive layout (county=X/period=YYYY-MM/), kept as-landed forever.
  BigLake / Iceberg tables over the files + Datastream-landed raw tables beside them.
  Queryable from minute one; the source of every future replay.
                                   |
                                   |  Dataform staging + incremental models, with assertions
                                   |  (all .sqlx in git, reviewed in PRs — your CI/CD discipline)
                                   v
SILVER — cleaned & conformed
  Deduped, typed, joined to reference data; one staging model per source variant.
  Assertions catch schema drift and surprise NULL rates before your analysts do.
                                   |
                                   |  Dataform release configuration (Silver -> Gold, on a schedule)
                                   v
GOLD — data marts, the single source of truth
  BigQuery mart tables, partitioned by date, clustered by the columns you filter on.
  Governed: IAM, Knowledge Catalog, sensitive-data protection for PII.
                                   |
                                   |  Google BigQuery connector (Get Data in Power BI)
                                   v
SERVING — the Power BI you already have
  Same reports, authors, workspaces, DAX. Import + scheduled refresh by default;
  DirectQuery only when a mart genuinely needs intra-day freshness.

ORCHESTRATION SPINE (runs the whole flow, everything defined in git):
  Cloud Scheduler (= SQL Agent)  ->  Dataform release runs  ->  Power BI refresh follows the release.
  Datastream runs itself — M&O watches a freshness metric instead of restarting a 2 AM job.
```

## Stage by stage

| Stage | GCP tool(s) | What it does | Replaces in your current stack |
|---|---|---|---|
| Ingest — databases | **Datastream** | Log-based change data capture: initial backfill plus continuous inserts/updates/deletes into BigQuery | Nightly extract jobs, replication |
| Ingest — files | **GCS + Storage Transfer**, then **`LOAD DATA`** | Drops land in a bucket once; loaded with a pinned schema JSON | SSIS file-sweep packages |
| Ingest — SaaS | **BigQuery Data Transfer Service** | Managed, scheduled pulls from SaaS sources | Vendor exports + manual loads |
| **Bronze** | **GCS (Parquet, Hive layout) + BigLake/Iceberg** | Raw landing: immutable, replayable, queryable in place | Staging shares + staging tables |
| **Silver** | **Dataform** staging + incremental models, assertions | Cleaning, conforming, dedupe — with tests in the repo | Transform sprocs / SSIS data flows |
| **Gold** | **BigQuery marts** (partitioned + clustered) | Curated marts — the single source of truth for reporting | Reporting database / mart tables |
| Serving | **Power BI + Google BigQuery connector** | Import (default) or DirectQuery against Gold | The reports you already run |
| Orchestration | **Cloud Scheduler + Dataform release configs**, in git | Schedule → release → refresh, boring on purpose | SQL Agent jobs + your CI/CD pipelines |
| Governance | **IAM, Knowledge Catalog, Sensitive Data Protection** | One governed source of truth; PII discovered and protected | Your security & PII controls, centralized |

## Rules of the map

- **Every box gets one tool, not three.** A cell that says "Datastream or DTS or Dataflow" is a deferred decision — acceptable in backlog draft zero, but name it as one.
- **Bronze answers "what did the source say"; Silver answers "what does it mean."** No cleaning rules in Bronze — that separation is what makes reprocessing possible, the thing your current extract jobs can't do.
- **Dataform owns Silver→Gold, and it's in git.** Transforms living anywhere else (heavy scheduled queries, Power Query in Power BI) need a stated reason.
- **Orchestration is boring.** Scheduler + Dataform release configurations cover nearly everything you mapped in class. Composer (managed Airflow) enters when you have many interdependent pipelines or non-BigQuery tasks — not on day one.
- **Power BI is Import-first.** DirectQuery appears only with a stated freshness need, and refresh cadence names the pipeline event it follows ("after the Dataform release"), not a wall-clock guess.
- **Fill in "first thing that breaks" honestly.** Schema drift, PII, a county that re-sends files, 10× volume — that row becomes your migration risk register.

## Dig deeper

- [Datastream — sources (incl. SQL Server)](https://cloud.google.com/datastream/docs/sources) · [Storage Transfer Service](https://cloud.google.com/storage-transfer/docs) · [`LOAD DATA`](https://cloud.google.com/bigquery/docs/reference/standard-sql/load-statements)
- [Iceberg tables](https://cloud.google.com/bigquery/docs/iceberg-tables) · [BigLake](https://cloud.google.com/bigquery/docs/biglake-intro) · [Partitioned tables](https://cloud.google.com/bigquery/docs/partitioned-tables) · [Clustered tables](https://cloud.google.com/bigquery/docs/clustered-tables)
- [Dataform](https://cloud.google.com/dataform/docs/overview) · [Scheduled queries](https://cloud.google.com/bigquery/docs/scheduling-queries) · [Cloud Scheduler](https://cloud.google.com/scheduler/docs/overview)
- The Dataform repo walked through in class on Day 1: <https://github.com/jwdavis/dataform-demo>
- The last mile in detail: [Power BI ↔ BigQuery connector guide](powerbi-bigquery-connector-guide.md)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
