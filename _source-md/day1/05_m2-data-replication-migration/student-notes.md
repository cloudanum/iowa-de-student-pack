# Module 2 Notes — Data Replication and Migration

Your notes for the late-morning module on Day 1 (Mon Oct 5, 2026, 11:10–11:50 CT) — the module about killing the nightly extracts. It leads straight into the [Datastream lab](../06_lab-datastream-postgres-to-bq/lab-companion.md) that starts just before lunch.

## Key takeaways

- **Replication is not migration.** Migration moves data once; replication keeps a target continuously in sync with a live source. Your project needs both: an initial copy of the warehouse, then a continuous feed of every change after it. Datastream does the two as one operation — backfill first, then a live change stream.
- **Datastream is change data capture (CDC) as a managed service.** Instead of exporting tables on a schedule, it reads the source database's own change log and applies every INSERT, UPDATE, and DELETE to the destination — in your case, BigQuery.
- **Log-based capture answers the M&O objection.** Because Datastream reads the database's transaction/change log, there are **no triggers on your tables, no polling queries, and no batch window loading down production**. The source keeps serving its workload; Datastream reads a log the database is already writing.
- **SQL Server IS a supported Datastream source.** The module deck pictures Oracle, MySQL, and PostgreSQL, but SQL Server is on the supported-source list — self-managed or cloud-hosted. Your SQL Server → BigQuery path is a first-class Datastream scenario, and the next lab is its pilot.
- **Backfill + continuous changes in one stream.** When a stream starts, it copies the existing rows (backfill), then keeps applying changes as they happen. You never re-extract a whole table after the first copy — think about what that means for your largest table.
- **Changes arrive with context.** Replicated rows carry Datastream metadata such as `change_type` and `is_deleted`, so downstream you can tell an insert from an update from a delete — something a nightly truncate-and-reload could never give you.
- **The extract window disappears.** There is no "we can only touch the source between 1 AM and 4 AM" anymore. Replication is always on, and freshness stops being tied to a schedule.
- **Two other migration tools you'll see named — one line each:** Database Migration Service (DMS) is for one-time database engine migrations, e.g. moving onto Cloud SQL — **not your path**. Transfer Appliance ships petabytes of offline data on physical hardware — **not your path**. Your path is Datastream → BigQuery.

## Your SQL Server world → GCP world

| Your SQL Server world today | The GCP world you're moving to |
|---|---|
| Nightly extract window (off-hours batch) | Continuous CDC replication — no window |
| SQL Agent job that runs the nightly extract | A Datastream stream — always on, no schedule |
| SSIS extract package writing flat files | Datastream writing change events straight into BigQuery |
| SQL Server CDC / change tracking on source tables | Datastream log-based capture at the source |
| Triggers or polling queries for change detection | Not needed — the change log already knows |
| Truncate-and-reload of staging tables | One-time backfill, then incremental changes forever |
| Instance → database → schema.table | Project → dataset → table |

## Dig deeper

- [Datastream overview](https://cloud.google.com/datastream/docs/overview)
- [Datastream supported sources](https://cloud.google.com/datastream/docs/sources)
- [Configure a source SQL Server database for Datastream](https://cloud.google.com/datastream/docs/configure-your-source-sql-server-database)
- [Database Migration Service docs](https://cloud.google.com/database-migration/docs) (one-time engine migrations — not your path)
- [Transfer Appliance](https://cloud.google.com/transfer-appliance) (offline petabyte moves — not your path)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
