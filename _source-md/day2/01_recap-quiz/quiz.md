# Day 2 warm-up quiz — "Which GCP tool replaces which piece of your stack?"

Day 2 (Tue Oct 6), 09:00–09:15. A no-stakes group warm-up: before the lakehouse modules start, prove that Day 1 stuck — in your own vocabulary.

## How it works

Your instructor reads each question aloud. Confer with your table for about 30 seconds, then someone answers for the group. Nothing is scored and there are no trick questions — the point is retrieval practice: naming, out loud, what each piece of your current SQL Server stack becomes on Google Cloud. Jot your answers down as you go; the key is at the bottom (no peeking).

## The questions

1. **Your nightly extract jobs** — the SQL Server Agent tasks that dump tables to files or stage them to another server. Which GCP service replaces them for ongoing database replication?
2. **SQL Server Agent** — the scheduler that fires your jobs at 2 AM. What's the GCP equivalent?
3. **SSIS** — your extract-transform-load packages. What replaces it on GCP?
4. **Your staging file drops** — CSVs arriving from counties and vendors. Where do they land first in the target design, and what loads them?
5. **Your linked servers and cross-database queries.** What's the BigQuery way to query data that lives somewhere else?
6. **Your T-SQL stored procedures and deployment scripts** that build reporting tables. Where does that discipline live in the target?
7. **Your SSAS cubes / pre-aggregated reporting tables.** What's the BigQuery analogue?
8. **Yesterday's race:** the 60-million-row file that took ~2 minutes to load as CSV and seconds as Parquet. What was the lesson?
9. **Who pays when a query runs,** and what does a query actually bill on?
10. **Bronze, Silver, Gold** — in one sentence each, what are they in *your* target design?

---

## Answers

1. **Datastream** — change data capture (CDC) that streams database changes into BigQuery continuously: log-based, no triggers, no production load. That's why it beats your nightly window — yesterday, a row changed in the source while we ate lunch, with no extract job at all. (BigQuery Data Transfer Service is the right answer only for *file/SaaS* sources, not database CDC.)
2. **Cloud Scheduler** — plus **Dataform release configurations** on the transform side. For a one-statement job, a BigQuery **scheduled query** is the cheapest version — that was the closing demo yesterday: one click, a daily overwriting query, no pipeline.
3. Two answers, and the distinction matters: **Dataform** for ELT — transform in SQL, inside BigQuery, your Silver→Gold path — and **Dataflow** for when SQL genuinely isn't enough (streaming, heavy custom logic). Your architecture doc names Dataform; Dataflow is the escape hatch, not the plan.
4. They land in **Cloud Storage** — the Bronze layer — and load via **Storage Transfer Service, `bq load`, `LOAD DATA` SQL**, or scheduled through **BigQuery Data Transfer Service**. GCS first because it's a cheap, durable, replayable raw copy: the lake holds what the warehouse hasn't modeled yet.
5. **Federated queries over external connections** (this morning's [lab](../04_lab-federated-query-bigquery/lab-companion.md)) and **external tables** over GCS (the [11:15 activity](../05_activity-external-tables/activity-guide.md)). The trade-off versus loading: no copy and always current, but no BigQuery storage optimizations — and the source system takes the load.
6. **Dataform** — SQLX definitions, a dependency graph, assertions, release configurations, all in git, wired to your CI/CD. A Dataform assertion replaces the hand-rolled validation queries and job-step checks you run after loads today.
7. **Materialized views** — BigQuery maintains the refresh for you, with nobody running a cube-processing job. More broadly: your **Gold-layer marts**, built and scheduled by Dataform.
8. **Open columnar formats matter.** Parquet on GCS is the Bronze foundation — and it's what Iceberg and BigLake build on (today's story). If your current extracts land as CSV, changing the format is a free, immediate win in the migration.
9. Queries bill on **bytes scanned** under on-demand pricing; **loads are free** — every load yesterday showed "Bytes billed: 0 B." Which makes the cheapest automation you built yesterday the daily overwriting scheduled query: one statement, no pipeline. (Slots and flat-rate exist; the data-warehousing course goes deeper.)
10. **Bronze** = raw lands as-is (GCS files, Datastream replicas, external/BigLake tables). **Silver** = cleaned, conformed, deduplicated BigQuery tables. **Gold** = business-ready marts that feed Power BI. Dataform does Silver→Gold — and your Power BI reports touch Gold only. Today we make all three concrete.

---

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
