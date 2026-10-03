# Welcome and Course Intro — Student Notes

Opening block of Day 1 (Monday, October 5, 2026, 9:00–9:25 AM CT): what the two days cover, why the course is built around your migration project, and how labs and logistics work.

## The two days at a glance

Both days run 9:00 AM–4:30 PM CT, virtual, with lunch 12:00–1:00 PM and a 15-minute break each morning and afternoon.

| Day | Theme | What you'll walk away with |
|---|---|---|
| Day 1 (Mon Oct 5) | Landing your data in BigQuery | Console fluency; five ways to get data into BigQuery, including change data capture (CDC) that replaces a nightly extract; ELT with Dataform |
| Day 2 (Tue Oct 6) | Your target operating model: lakehouse and medallion | Lake vs. warehouse vs. lakehouse vocabulary; external tables and Apache Iceberg; governance; your Bronze → Silver → Gold design; the BigQuery → Power BI last mile; a capstone mapping one of your real extract jobs |

## This course is your migration story

This delivery is organized around the project you're actually running, not a generic tour of Google Cloud. The through-line:

1. **Kill the legacy nightly extracts.** Change data capture streams changes from the source database into BigQuery continuously — no extract window, no nightly batch. On Day 1 you'll watch a row changed over lunch land in BigQuery with no job having run.
2. **Land in BigQuery as the single source of truth.** Your SQL Server data warehouse migrates to BigQuery: serverless, no instances to patch, storage and compute scaled independently.
3. **Build the Bronze → Silver → Gold medallion lakehouse.** Raw landings (Bronze), conformed and cleaned data (Silver), business-ready data marts (Gold) — Day 2 is taught around exactly this vocabulary.
4. **Dataform does the Silver → Gold ELT.** SQL workflows, assertions, and release configurations — the discipline of your SQL Server CI/CD pipelines, applied to the warehouse itself.
5. **Power BI keeps working.** Your Gold data marts feed the Power BI reports you already have. That last mile is covered explicitly on Day 2 afternoon.

Every module, demo, and lab hangs on one of those five steps.

## The hands-up survey — help your instructor calibrate

In the first few minutes your instructor will ask for hands: who's an ETL developer, who's on the M&O team, who authors Power BI reports — and who has ever opened the Google Cloud console.

Answer honestly, including "never opened it." The room is senior in data engineering and new to this specific platform, so the course deliberately compresses concepts you live daily (sources, transforms, scheduling, CDC) and slows down on where things live in GCP. The survey is how the instructor tunes that mix to the actual room — it's calibration, not a quiz.

## Course logistics

- **Lab instructions and environments:** the [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990). All official lab steps live there — the companions in this pack add orientation and gotchas around them, not duplicate steps.
- **You work in lab-provided GCP projects.** Each lab gives you temporary credentials and a temporary Google Cloud project. Nothing you build persists after class, and nothing bills to you or your organization. Break things freely; that's what the projects are for.
- **Some hands-on activities run outside the timed labs**, from the [Do-It-Now (DIN) activities page](https://roitraining.github.io/gcp-demos/bigquery.html). Your instructor will tell you when to use your running lab project for these.
- **Have two browser tabs ready each morning:** the Skills classroom and the Google Cloud console.
- **Timing:** 9:00 AM–4:30 PM CT both days; 15-minute breaks morning and afternoon; lunch 12:00–1:00 PM.

## Key takeaways

- Two days, one story: kill the extracts, land in BigQuery, go Bronze → Silver → Gold with Dataform, keep Power BI working.
- You're the experts on the concepts; the course's job is to move them onto GCP. Ask "where does X live in GCP?" whenever it isn't obvious — that question is the point of the two days.
- Labs are disposable and experiments are free.
- Your first hands-on task this morning — creating a `class` dataset — is load-bearing: every load this afternoon lands there.

## What's next this morning

- [M1 student notes](../02_m1-de-tasks-components/student-notes.md) — the GCP moving parts mapped to your SQL Server stack
- [Console orientation activity](../03_activity-console-orientation/activity-guide.md) — your first guided tour, and the required `class` dataset
- [Lab 1 companion](../04_lab-loading-data-into-bigquery/lab-companion.md) — Loading Data into BigQuery

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
