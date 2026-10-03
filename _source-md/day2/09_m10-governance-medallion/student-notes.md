# M10 — Governance and the Medallion Architecture: Student Notes

Notes for the Day 2 (Tue Oct 6) mid-afternoon module, 14:00–14:35 — the governance tooling behind your "single source of truth" requirement, and the module where Google's own slides draw your Bronze → Silver → Gold architecture. This is the anchor block of Day 2.

## Key takeaways

- **Governance is what turns BigQuery into a single source of truth instead of one more copy.** Your problem today isn't storing data — it's that extracts scatter it. Discovery, lineage, sensitivity classification, and fine-grained access control are what let one governed copy serve everyone.
- **Knowledge Catalog is the metadata hub.** A universal catalog across BigQuery, Cloud Storage, and Lakehouse assets: discover data, trace lineage, manage and enrich metadata. One reference source, so "which table is the real one?" has an answer. (It evolved from Dataplex Universal Catalog — you will still see "Dataplex" in the console and older docs.)
- **Sensitive Data Protection finds and defuses PII.** It scans your lakehouse to discover sensitive fields, classifies them by sensitivity level, and protects them with techniques like masking and tokenization (think `******9787`) — so analytics and ML can use the data without exposing it.
- **Fine-grained security is built in, at column and row level.** Column-level security restricts who can select specific columns (the classic PII case: purchase history yes, contact info no). Row-level security filters which rows a user can see (the regional manager sees only their region). On Lakehouse tables in Cloud Storage, Sensitive Data Protection can apply dynamic data masking — even to files that never left the lake.
- **The medallion architecture on these slides is your architecture doc's vocabulary.** Bronze = landing zone for raw data, the historical record of what was received. Silver = cleansed and conformed, initial transformations. Gold = curated, aggregated, optimized for analytics and reporting. Your design is the pattern Google teaches — hold your doc next to the deck and they line up zone for zone.
- **Each zone has a natural home.** Bronze: raw files on Cloud Storage in open formats, queryable in place (BigLake/Iceberg — this morning and the 13:00 lab). Silver: often open format in Cloud Storage but queried through BigQuery — Dataform territory. Gold: normally native BigQuery tables for maximum query performance — what your Power BI reports point at.
- **The audience narrows as value rises.** Bronze and Silver are data-engineering territory; Gold is where BI, data science, and business users live. The zones give you both flexibility (raw data never destroyed) and governance (consumers touch only curated data).
- **Migration is phased, not big-bang.** A one-time migration is too risky and disruptive; a phased, use-case-driven approach wins: core infrastructure first, then one high-impact use case end to end, then iterate and decommission.
- **Cost management is a habit, not a rescue.** Right Cloud Storage class for access frequency; partitioning, clustering, and efficient SQL to cut bytes scanned; capacity (flat-rate) pricing once workloads are predictable; budgets and alerts in Cloud Billing so nothing surprises you.

## Governance: your "single source of truth" requirement, tooled

**Metadata** is data about data: who created it, when, what it contains, how it relates to other data, who owns it, and how sensitive it is. In your current estate this knowledge lives in people's heads, in a wiki, or in extended properties nobody maintains. The three governance tools in this module operationalize it:

| Your requirement | The GCP tool | Your SQL Server analogue |
|---|---|---|
| Find the right table and trust it | **Knowledge Catalog** — discovery, lineage, metadata enrichment across BQ, GCS, Lakehouse | Data dictionaries, extended properties, "ask Dave" |
| Know where the PII lives | **Sensitive Data Protection** — scan, discover, classify by sensitivity | SSMS Data Discovery & Classification |
| Hide sensitive values from most users | **Column-level security** (policy tags) + **dynamic data masking** | Column-level `GRANT`/`DENY` + Dynamic Data Masking |
| Users see only their rows | **Row access policies** (row-level security) | SQL Server row-level security predicates |
| Prove where a column came from | **Lineage in Knowledge Catalog** | Hand-drawn data-flow diagrams, SSIS package archaeology |

Two connections to what you already did today: the BigLake/Iceberg tables from the 13:00 lab can carry column-level security, row access policies, and dynamic masking on files still sitting in the bucket — Bronze can be governed before a single transformation runs. And when you change a Silver table, lineage is what tells you which Gold marts (and therefore which Power BI reports) you just touched.

## The medallion: your architecture, in Google's slides

This is the moment the two days have pointed at. The deck's zone diagram uses the same Bronze → Silver → Gold vocabulary as your own architecture document — the design you already committed to is the pattern Google teaches as the modern lakehouse.

**Zone definitions, in your vocabulary:**

- **Bronze — the raw landing zone.** Data exactly as received: county file drops, Datastream CDC events, batch exports of source systems. Immutable — the historical record of what arrived, kept forever, never edited. Queryable in place (you proved that at 13:00), but not yet trusted.
- **Silver — cleansed and conformed.** The initial transformations happen here: columns typed, dates and code sets standardized, duplicates resolved, keys conformed across sources. This is the layer your SSIS data flows produce today — and the layer Dataform builds as incremental, tested models in the target design.
- **Gold — curated business-level data.** Aggregated and optimized for analytics and reporting: the marts, the star schemas, the "customer/county/service 360" tables. This is what your existing Power BI reports repoint at — same reports, new source.

**What lives in each zone, and what serves it:**

| | Bronze | Silver | Gold |
|---|---|---|---|
| **What lives here** | Raw, immutable landings (files, CDC events, exports as received) | Cleaned, conformed, integrated tables | Aggregated marts and business-level tables |
| **In your current stack** | The extract output plus staging tables | What your SSIS packages produce mid-pipeline | The star schema your Power BI reads |
| **Typical GCP services** | Cloud Storage + BigLake/Iceberg tables, queried in place by BigQuery | Dataform staging + incremental models over BigQuery/Iceberg | Native BigQuery tables, partitioned and clustered; built by Dataform release configs |
| **Who consumes it** | Data engineers | Data engineers + the analysts building marts | Power BI, business users, data science |
| **Trust level** | Received, unverified | Verified, conformed | Decision-grade |

The slides put it plainly: the zones are a **balance of flexibility and governance** — Bronze keeps everything (flexibility, replay, audit), Gold controls everything (governance, performance, one version of the numbers). Your Dataform-for-Silver→Gold plan slots into the middle of that diagram exactly as designed.

## Migration strategy, cost basics, best practices

The deck's closing section is the bridge from "nice architecture" to "how do we actually get there":

- **Don't do a one-time migration.** A complete, single-shot move off a traditional warehouse is too risky and disruptive. Phase it by use case.
- **The five-step strategy:** (1) set up the core infrastructure on Google Cloud; (2) start with one high-impact use case; (3) migrate the relevant data; (4) build the new pipelines and reports; (5) decommission and iterate. For you: pick one painful extract chain, run it end to end — Datastream or files → Bronze → Dataform Silver → Gold mart → the Power BI report that already exists — prove it, then repeat. This afternoon's capstone workshop starts exactly that exercise on paper with one of your real jobs.
- **Cost basics:** you pay for storage (choose the right Cloud Storage class by access frequency — hot Bronze vs. cold archive) and for queries (bytes scanned on-demand, or capacity/flat-rate pricing once workloads are predictable). Partitioning, clustering, and disciplined SQL from this morning's M9 module are your main cost levers.
- **Best practices from the deck:** choose the right storage class; optimize BigQuery queries (partition, cluster, write efficient SQL — `SELECT *` on a big table is a billing decision); use flat-rate pricing for predictable workloads; set budgets and alerts in Cloud Billing from day one.

## Your SQL Server world → GCP world (this module)

| In your current stack | In this module's GCP world |
|---|---|
| "The warehouse" plus dozens of scattered extracts | One governed BigQuery store as the single source of truth |
| Data dictionary wiki / tribal knowledge | Knowledge Catalog (metadata, discovery, lineage) |
| SSMS Data Discovery & Classification | Sensitive Data Protection (scan, classify, protect) |
| Column-level `GRANT`/`DENY`, Dynamic Data Masking | Column-level security (policy tags), dynamic data masking |
| Row-level security predicates | Row access policies |
| Staging database | Bronze zone — GCS + BigLake/Iceberg, queryable in place |
| SSIS cleansing/conforming data flows | Silver zone — Dataform models (staging, incremental, tested) |
| Star-schema DW feeding Power BI | Gold zone — native BigQuery marts feeding the same Power BI |
| Big-bang replacement project | Phased, use-case-driven migration with decommission steps |

## Dig deeper

- [Knowledge Catalog overview](https://cloud.google.com/dataplex/docs/overview) (evolved from Dataplex Universal Catalog)
- [Sensitive Data Protection documentation](https://cloud.google.com/sensitive-data-protection/docs)
- [BigQuery column-level access control](https://cloud.google.com/bigquery/docs/column-level-security)
- [Introduction to BigQuery row-level security](https://docs.cloud.google.com/bigquery/docs/row-level-security-intro)
- [Apache Iceberg managed tables](https://cloud.google.com/bigquery/docs/iceberg-tables) — the Bronze/Silver storage option from the [Iceberg explainer](../08_iceberg/iceberg-explained.md)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
