# M8 — Building a Data Lakehouse with Cloud Storage, Open Formats, and BigQuery: student notes

Day 2 (Tue Oct 6), 09:45–10:30. Slides come from Course 2 Module 2; this module is the bridge from "lakehouse vocabulary" (M7) to the hands-on morning — the 10:45 federated-query lab and the 11:15 external-tables activity.

## Key takeaways

- **GCS + open formats is your Bronze foundation.** Parquet files — and Iceberg tables built on them — sitting in Cloud Storage buckets: that sentence ties this module directly to your architecture doc.
- **Parquet** is an open, column-oriented file format: compressed, splittable, and fast to scan. You felt this yesterday — 60 million rows took ~2 minutes as CSV and seconds as Parquet.
- **Apache Iceberg** is an open *table* format layered over files in a bucket. It gives raw lake files warehouse behavior: ACID transactions, schema evolution that never rewrites the table, hidden partitioning, and time travel/rollback — while staying readable by multiple engines (BigQuery, Spark, Trino...).
- **BigQuery is the central processing engine.** It queries managed tables and open-format tables in GCS alike, with storage and compute scaling independently. One SQL surface over Bronze, Silver, and Gold.
- **AlloyDB** — Google's fully managed, PostgreSQL-compatible database for operational/OLTP workloads — is the *operational sibling*, **not your path**. You meet it in the next lab only as a stand-in for a live operational store.
- **Federated queries** close the module: sending a query from BigQuery to data that lives in an external system, in real time, without moving it. That is exactly what you'll do hands-on at 10:45 — see the [lab companion](../04_lab-federated-query-bigquery/lab-companion.md).
- After the lab, the [external-tables activity](../05_activity-external-tables/activity-guide.md) applies the same "query it where it lives" idea to files in GCS — the open-formats slides made tangible.

## Your SQL Server world → GCP world

| Your SQL Server world | GCP world (this module's terms) |
|---|---|
| Staging file shares and county/vendor CSV drops | Cloud Storage buckets holding Parquet files — the Bronze layer |
| Extract files nobody can query until an SSIS load runs | Open formats queryable in place: external tables and Iceberg tables |
| SQL Server DW tables | BigQuery-managed tables — your Silver and Gold |
| SQL Server OLTP source systems | The operational side (AlloyDB/Cloud SQL on GCP) — reachable by federation while it stays put |
| Linked servers and four-part names | BigQuery connection resources + `EXTERNAL_QUERY` (the 10:45 lab) |
| SSIS data flows over staged files | BigQuery SQL over open formats — no staging hop required |

## Dig deeper

- [Apache Parquet](https://parquet.apache.org/) — the columnar file format
- [Apache Iceberg](https://iceberg.apache.org/) — the open table format (schema evolution, hidden partitioning, time travel)
- [Introduction to BigLake tables](https://cloud.google.com/bigquery/docs/biglake-intro) — governed tables over GCS files
- [Introduction to federated queries](https://cloud.google.com/bigquery/docs/federated-queries-intro) — the mechanics behind the next lab
- [AlloyDB overview](https://cloud.google.com/alloydb/docs/overview) — for context only; not your migration target

---

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
