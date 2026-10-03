# M5 + M6 Student Notes — ETL Options and Automation

Notes for the compressed Day 1 block (4:05–4:20 PM CT). M5 surveys the tools for "when SQL is not enough" — conceptual only, no lab. M6 covers automation techniques: the block that maps most directly to your SQL Agent jobs and CI/CD world.

## M5 — when SQL is not enough (conceptual)

- **Default to ELT in BigQuery.** Reach for M5 tools only when transformation needs more than SQL — custom code, streaming latency, or non-BigQuery destinations.
- **Batch vs streaming is a latency decision, not a religion.** Nightly or micro-batch loads cover most warehouse work; streaming is for when the business genuinely needs seconds-to-minutes freshness.
- **Pub/Sub** is the managed messaging backbone: producers publish events, subscribers consume them — the durable, serverless landing pad for anything streaming into GCP.
- **Dataflow** is the managed runner for Apache Beam pipelines (batch and stream), and **templates** are prebuilt pipelines you configure rather than code (for example, Pub/Sub → BigQuery) — common patterns without Beam development.
- **Depth lives elsewhere:** Spark and the streaming material are later-course topics (Course 4); the M5 Spark lab is optional homework. Today's goal is knowing the names and when to reach for each.

> **Who on your team cares — M5:** **Developers**, if ingestion ever goes real-time (Pub/Sub and Dataflow become your problem then). **M&O**, awareness level only — these are the boxes that will show up on future architecture diagrams.

## M6 — automation: your CI/CD analogue

- **Cloud Scheduler ≈ SQL Agent.** Managed cron that triggers targets (HTTP endpoints, Pub/Sub messages). The general-purpose timer — no scheduler VM to patch.
- **Scheduled queries** (the 4:20 PM closing demo) are the simplest case of all: one SQL statement on a schedule, overwriting a destination table. A SQL Agent job reduced to its essence.
- **Dataform release configurations + scheduled workflow invocations** put your Silver→Gold runs on a cadence, compiled from a git commit — the lab you just finished, productionalized. This is your deployment discipline applied to SQL in git.
- **Cloud Composer** is managed Apache Airflow: the orchestrator for when you have many interdependent pipelines — cross-system dependencies, retries, SLAs. More than you need on day one; the answer when "run A, then B, then C across three systems" gets complicated.
- **Eventarc** routes events (a file lands in a bucket, a log entry appears) to targets — the trigger half of event-driven loads. **Cloud Run functions** execute small pieces of code in response — the action half.

> **Who on your team cares — M6:** **M&O, this is your block.** Scheduling, orchestration, and failure visibility are the operating model for the new platform. **Developers** care mainly about how their Dataform releases get triggered — a scheduled invocation, Composer, or your existing CI/CD calling the API.

### Choosing an automation tool

| Service | What it is | Reach for it when | Your analogue |
|---|---|---|---|
| Scheduled queries | A saved query on a schedule | The whole job is one SQL statement | Single-step SQL Agent job |
| Cloud Scheduler | Managed cron triggering HTTP/Pub/Sub targets | "Every day at 6 AM, start something" | SQL Agent schedule |
| Dataform release + workflow schedule | Compile-from-git plus scheduled execution | Running your Silver→Gold workflow on a cadence | Deployment pipeline + job |
| Cloud Composer | Managed Apache Airflow (DAGs) | Many interdependent, cross-system pipelines | Master package / enterprise scheduler |
| Eventarc | Event routing between services | "When X happens, kick off Y" | File-watcher / event-driven triggers |
| Cloud Run functions | Small event-triggered code | Glue logic too small for a pipeline | Script Task / custom .NET glue |

## Key takeaways

- Pick by shape, not by fashion: one statement → **scheduled query**; your transform flow → **Dataform release config**; arbitrary things on a timer → **Cloud Scheduler**; many pipelines with dependencies → **Composer**; events instead of clocks → **Eventarc + Cloud Run functions**.
- Automation in GCP is serverless: no scheduler box to maintain, no agent service — you declare the schedule or the trigger, Google runs it.
- Nothing here changes your discipline — source control, review, staged deployment, monitoring. It changes where the buttons are.
- The M5 tools are not a detour from your medallion plan; they are the escape hatches you will reach for at the edges (streaming sources, non-SQL transforms) once the core is running.

## Your SQL Server world → GCP world

| In your current stack | In GCP |
|---|---|
| SQL Agent job (single T-SQL step) | Scheduled query |
| SQL Agent job schedule | Cloud Scheduler |
| Deployment pipeline for SQL changes | Dataform release configuration + workflow schedule |
| Master SSIS package orchestrating many packages | Cloud Composer (managed Airflow) |
| File/event watchers kicking off jobs | Eventarc |
| Custom .NET / Script Task glue | Cloud Run functions |
| Service Broker / queue-based decoupling | Pub/Sub |

## Dig deeper

- [Cloud Scheduler documentation](https://cloud.google.com/scheduler/docs)
- [Cloud Composer (managed Apache Airflow)](https://cloud.google.com/composer/docs)
- [Pub/Sub overview](https://cloud.google.com/pubsub/docs/overview)
- [Dataflow overview](https://cloud.google.com/dataflow/docs/overview)
- [Eventarc overview](https://cloud.google.com/eventarc/docs/overview)
- [Cloud Run functions overview](https://cloud.google.com/functions/docs/concepts/overview)
- [Scheduling queries in BigQuery](https://cloud.google.com/bigquery/docs/scheduling-queries)

Related: the [closing activity guide](../12_close-scheduled-query/activity-guide.md) — schedule your first query tonight, in five minutes.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
