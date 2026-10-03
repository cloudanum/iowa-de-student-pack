# Day 2 Schedule — Tuesday, October 6, 2026

"Your target operating model: lakehouse & medallion" · 9:00 AM–4:30 PM CT · virtual. Day 2 turns yesterday's mechanics into your architecture: the lakehouse, Bronze/Silver/Gold on Google's own slides, the Power BI last mile, and a capstone you take back to work.

| Time | Block | What you'll walk away with |
|---|---|---|
| 09:00–09:15 | **[Recap quiz](01_recap-quiz/quiz.md)** | A fast, low-stakes game of "which GCP tool replaces which piece of your stack?" — extracts, Agent jobs, SSIS and all |
| 09:15–09:45 | **[Lake, warehouse, lakehouse](02_m7-intro-modern-de/student-notes.md)** | The vocabulary of your own architecture doc, pinned down: what a lakehouse is and why it's your target shape |
| 09:45–10:30 | **[Building the lakehouse](03_m8-building-data-lakehouse/student-notes.md)** | Why Cloud Storage + open formats (Parquet, Iceberg) is your Bronze foundation, and how federated queries reach data you haven't moved yet |
| 10:30–10:45 | **Break** | |
| 10:45–11:15 | **[Lab: federated queries](04_lab-federated-query-bigquery/lab-companion.md)** — *Federated Query with BigQuery* | A live join between BigQuery data and an operational database — your linked-server/`OPENQUERY` instinct, working on GCP |
| 11:15–11:35 | **[Hands-on: external tables — Bronze made tangible](05_activity-external-tables/activity-guide.md)** | A queryable table over Hive-partitioned Parquet in the `jwd-gcp-demos` bucket — no load job, partition pruning on raw files (DIN §30) |
| 11:35–12:00 | **[Modernizing your warehouse](06_m9-modernizing-data-warehouses/student-notes.md)** | Your SQL Server pain points, answered: partitioning, clustering, and how BigQuery compute (slots) changes the tuning game |
| 12:00–13:00 | **Lunch** | |
| 13:00–13:45 | **[Lab: external data & Iceberg](07_lab-external-data-iceberg/lab-companion.md)** — *Querying External Data and Iceberg Tables* | A BigQuery Lakehouse (Iceberg) table over files in Cloud Storage, queried without loading anything — the Bronze pattern, hands-on |
| 13:45–14:00 | **[Iceberg deep-dive](08_iceberg/iceberg-explained.md)** | What's under an Iceberg table: snapshots, partitioning, and what BigQuery actually does when you hit RUN |
| 14:00–14:35 | **[Governance + the medallion (Bronze/Silver/Gold)](09_m10-governance-medallion/student-notes.md)** | Google's own Bronze/Silver/Gold zone slides held up next to your design — plus Knowledge Catalog, sensitive-data protection, and fine-grained access: the pieces that make one source of truth safe |
| 14:35–14:50 | **Break** | |
| 14:50–15:20 | **[ML in BigQuery + the Power BI last mile](10_m11-bqml-powerbi/student-notes.md)** | A quick look at BigQuery ML (so you know it exists), then the part you asked for: your Gold marts feeding the Power BI you already have — Import vs. DirectQuery, auth, gateways |
| 15:20–15:50 | **[Capstone: map one of your real jobs](11_capstone-workshop/worksheet.md)** | A filled-in migration map for one real DOM DoIT extract job — backlog draft zero, on paper, yours to keep |
| 15:50–16:10 | **[Course summary](12_course-summary/student-notes.md)** | The two days retraced against your migration map, one more time, fast |
| 16:10–16:30 | **Q&A + what's next** | Open questions (the parking lot gets emptied), and where the follow-on *Data Warehousing with BigQuery* course goes deeper |

## Worth knowing before you arrive

- **Every block title above links to its module notes or lab/activity companion in this folder.** Open the companions before the hands-on blocks — they carry the gotchas.

- **Bring a real job to the capstone.** Think ahead about one extract job your team owns — not the biggest, not the simplest, the most typical. At 15:20 your group maps it onto the GCP target architecture using the [migration map](../reference/migration-map.md).
- **Labs live in the [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990)**, same as yesterday — temporary projects, timers, disposable sandboxes.
- **"DIN" = the Do-It-Now activities page:** <https://roitraining.github.io/gcp-demos/bigquery.html> — today uses §30 (external tables over Hive-partitioned Parquet).
- **The Power BI segment is built for you.** The standard course never mentions Power BI; this custom segment exists because your endgame is Gold marts feeding the reports the state already runs on. Details live in the [Power BI ↔ BigQuery connector guide](../reference/powerbi-bigquery-connector-guide.md).

## Reference cards to keep open today

- [Migration map](../reference/migration-map.md) — the one-page architecture card; have it open during the medallion block and the capstone
- [T-SQL → BigQuery SQL](../reference/tsql-to-bigquery-sql.md) — the Iceberg lab is where dialect differences bite
- [Glossary](../reference/glossary.md) — lakehouse vocabulary lands fast today; look things up as they fly by

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
