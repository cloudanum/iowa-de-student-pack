# Glossary — GCP Vocabulary for SQL Server People

One line per term, in the order you'll meet them. When a word flies past in class, look it up here and keep moving.

## The platform

- **GCP project** — the top-level container for resources, permissions, and billing; loosely your SQL Server instance's scope, with nothing to patch.
- **BigQuery** — Google Cloud's serverless data warehouse: tables and SQL at any scale, no instances to size; the engine your warehouse migrates to.
- **Dataset** — BigQuery's container for tables and views (≈ a database); lives in a fixed location you choose at creation.
- **GCS (Google Cloud Storage)** — object storage; the file share of GCP and the physical home of your Bronze layer.
- **Bucket** — a GCS container for files (≈ a share root); "folders" are just naming conventions in object keys.
- **Slot** — BigQuery's unit of compute capacity; invisible on on-demand pricing, reserved in blocks on flat-rate.

## Storage & formats

- **Parquet** — compressed columnar file format; loads and scans dramatically faster than CSV (the Day-1 format race makes this felt).
- **External table** — a read-only BigQuery table that's only a metadata pointer at files in GCS (or another source); the file is the table, no load ever ran.
- **BigLake** — BigQuery tables over open-format files in GCS, adding table semantics (metadata, governance, security) to the lake.
- **Apache Iceberg** — an open table format on object storage that gives raw files snapshots, schema evolution, and ACID-ish table behavior; your Bronze/Silver candidate.
- **Medallion architecture** — the Bronze → Silver → Gold layering of raw, conformed, and curated data; the pattern in your own architecture doc, and in Google's slides.
- **Bronze / Silver / Gold** — raw-as-landed and replayable / cleaned and conformed / curated marts; the separation is what makes reprocessing possible.

## Moving data

- **CDC (change data capture)** — streaming inserts/updates/deletes from the source's transaction log instead of re-extracting whole tables nightly.
- **Datastream** — Google Cloud's managed CDC service: log-based replication from SQL Server, Oracle, MySQL, or PostgreSQL into BigQuery; the extract-killer.
- **Storage Transfer Service** — managed, scheduled movement of files into GCS from shares, other clouds, or other buckets.
- **BigQuery Data Transfer Service (DTS)** — managed, scheduled pulls from SaaS apps (and Google sources) straight into BigQuery tables.
- **Pub/Sub** — managed messaging/queueing (think Service Broker at cloud scale); the front door for streaming data.
- **Federated query** — querying a live external database from BigQuery SQL via a connection resource and `EXTERNAL_QUERY`; ≈ linked server + `OPENQUERY`.

## Transform, schedule, orchestrate

- **ELT** — extract, load, *then* transform: land raw first, transform inside the warehouse with SQL; your SSIS transforms move into Dataform models.
- **Dataform** — SQL workflow tooling for ELT inside BigQuery: models, dependencies, assertions, releases, all in git; your Silver→Gold engine, and where your CI/CD discipline lands.
- **Cloud Scheduler** — managed cron (≈ SQL Server Agent schedules); triggers queries, Dataform runs, and anything else on a timer.
- **Scheduled query** — a SQL statement saved to run on a schedule inside BigQuery; the cheapest automation on the platform (you build one on Day 1).
- **Composer** — managed Apache Airflow for complex, multi-system orchestration; more than you need on day one.
- **Dataflow** — managed Apache Beam for heavy or streaming transforms when SQL genuinely isn't enough; the escape hatch, not the default.

## Security & access

- **IAM (Identity and Access Management)** — who (people, groups, service accounts) can do what on which resource; applies from project down to dataset and table.
- **Service account** — a non-human Google identity for jobs and apps; ≈ your SQL Agent proxy accounts, same least-privilege discipline.
- **OAuth** — the "sign in with Google" consent flow; how a Power BI Desktop author authenticates to BigQuery as themselves, so IAM sees a real person.
- **Knowledge Catalog (Dataplex)** — Google Cloud's data catalog and governance layer: discovery, metadata, and lineage across lakes and warehouses; the console and docs may still say Dataplex.

## Serving & cost

- **DirectQuery** — a Power BI storage mode that queries the source live on every interaction; against BigQuery it bills scan bytes continuously, which is why Import is your default.
- **On-demand vs slots pricing** — BigQuery's two compute billing models: pay per byte scanned per query (on-demand) or reserve capacity flat-rate (slots/editions); start on-demand, revisit in the data-warehousing course.
- **BigQuery ML (BQML)** — training and serving ML models with SQL inside BigQuery (`CREATE MODEL` → `ML.PREDICT`); a Day-2 teaser, not your day-one path.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
