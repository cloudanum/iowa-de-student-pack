# Data Engineering on Google Cloud — Student Pack

Welcome to your two-day course. This pack is everything handed to you directly: schedules, module notes, lab companions, and the reference cards you'll want back at your desk.

## The course at a glance

| | |
|---|---|
| **Course** | Data Engineering on Google Cloud |
| **Dates** | Monday October 5 – Tuesday October 6, 2026 |
| **Time** | 9:00 AM–4:30 PM CT (lunch 12:00–1:00, morning and afternoon breaks) |
| **Format** | Virtual, instructor-led, hands-on throughout |
| **Join** | [Google Meet — both days](https://meet.google.com/ogk-ivdv-bhi) |
| **Labs** | [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990) |

## Joining, check-in, and ground rules

- **Join the Meet** at 9:00 AM CT both days: https://meet.google.com/ogk-ivdv-bhi. Tip: if you're signed into several Google accounts, run the Meet in an incognito window and the labs in your normal one (or vice versa) — multi-account sign-in can kick you out.
- **Check in for Google** when you arrive: [Google check-in form](https://docs.google.com/forms/d/e/1FAIpQLSeluwTkhuq7YxgHYVNHlzBSqjCLaHVOjE5ARh71moUpd-J53Q/viewform?usp=pp_url?usp=pp_url&entry.341732991=Oct%205-76444) ([QR code](https://api.qrserver.com/v1/create-qr-code/?size=300x300&data=https%3A%2F%2Fdocs.google.com%2Fforms%2Fd%2Fe%2F1FAIpQLSeluwTkhuq7YxgHYVNHlzBSqjCLaHVOjE5ARh71moUpd-J53Q%2Fviewform%3Fusp%3Dpp_url%3Fusp%3Dpp_url%26entry.341732991%3DOct%25205-76444)) — Google keeps an attendance record for the class.
- **No recording.** Recording is not permitted for this course (course copyrights) — the pack you're holding is the take-away.
- **Lab window.** Google Skills labs open **Monday Oct 5 at 6:00 AM CT** and close **Tuesday at 11:00 PM CT**. Everything in a lab project disappears when the lab ends — if something matters, screenshot it.
- **Free credits after class.** You can request [50 Google Skills On-Demand credits per training day](https://docs.google.com/forms/d/1T6lBng3rkOtz5QQDklW0suwJ1J7YhkLO4xok9eXq_iI/viewform?edit_requested=true) — they arrive within a week and last 30 days. Perfect for re-running the Datastream and Dataform labs back at your desk.
- **Course evaluation.** At the end of Day 2, please take 3 minutes for the [event evaluation](https://cloudlx.sjc1.qualtrics.com/jfe/form/SV_e2wogp4l1a2ByZL?qualtricsID=v88mg1hxsk) — it's how courses like this get tuned for the next team.

## Before class: tell us who's in the room (5 minutes)

Fill in **your row** in the [pre-course survey](https://survey.anum.cloud) (anyone with the link can edit — no sign-in needed). Your name is already there. Rate yourself 0–3 on the tools you use today, and — most valuable of all — name **one real extract job you own**. That job becomes your group's raw material for the Day-2 capstone, where you map it onto the GCP target architecture. This calibrates the pace of the two days; it is not a quiz.

## Who this course is for

You — the Iowa DOM DoIT data team. Roughly ten SQL Server/SSIS ETL developers, the M&O team that keeps the jobs running, and the Power BI report authors the state relies on. You're senior in data engineering: ETL and ELT, change data capture, scheduling, source control, CI/CD pipelines for SQL Server deployments. What you're new to is the Google Cloud console — so these two days map what you already know onto where things live in GCP, instead of re-teaching concepts you own.

**Your instructor:** Imran Ahmad, PhD — Google Cloud Authorized Trainer and certified Professional Data Engineer, who builds large-scale production data pipelines for the Canadian federal government and writes the books on AI agents. See the [instructor profile](instructor-profile.md).

The course is built around your real project:

- Retire the legacy nightly extracts.
- Migrate the SQL Server data warehouse to BigQuery as the single source of truth.
- Build a Bronze → Silver → Gold medallion lakehouse.
- Use Dataform for the ELT work between Silver and Gold.
- Feed your existing Power BI reports from the Gold data marts.

## How the two days fit your migration

**Day 1 — Landing your data in BigQuery.** Console confidence first, then data in: four ways to load files, a live replication stream replacing the nightly extract window, and Dataform — your Silver→Gold tool. You end the day by scheduling your first query. See the [Day 1 schedule](day1/00_schedule.md).

**Day 2 — Your target operating model: lakehouse & medallion.** Lakes vs. warehouses vs. lakehouses, external tables and Apache Iceberg (Bronze made tangible), governance and Google's own Bronze/Silver/Gold architecture, the Power BI last mile, and a capstone where you map one of your real extract jobs onto the GCP design — an artifact you take back to work. See the [Day 2 schedule](day2/00_schedule.md).

## How the labs work

- Labs run in the [Google Skills classroom](https://www.skills.google/ilt/classrooms/37990). Open the classroom, sign in, and launch the lab when it's called.
- Each lab gives you a **temporary GCP project** with real credentials. When you start a lab, **the lab timer starts** — watch it. When time expires, the project is deleted. Nothing in a lab project is permanent, and that's by design: it's a disposable sandbox.
- Lab projects are safe to break. You cannot damage anything that matters.
- The lab's own step-by-step instructions live in the classroom. The companions in this pack add orientation, gotchas, and context around them — they don't replace the lab instructions.
- One thing you create yourself (not in a lab): on Day 1 morning you create a dataset named `class` in your lab project. Every afternoon loading activity writes into it — don't skip that step.

## What's in this pack

| Folder | What you'll find |
|---|---|
| [day1/](day1/00_schedule.md) | Day-1 schedule, a notes file per teaching block, and companions for every hands-on activity and lab |
| [day2/](day2/00_schedule.md) | Same treatment for Day 2 |
| [reference/](reference/gcp-for-sql-server-professionals.md) | Keep-forever reference cards (listed below) |

Every module folder also contains the **slide deck** for that module (`slides.pdf`), and every document comes in both **Word (.docx)** and **PDF** form — use whichever you prefer; the content is identical.

The reference cards:

- [GCP for SQL Server professionals](reference/gcp-for-sql-server-professionals.md) — the big mental-model mapping card
- [T-SQL → BigQuery SQL](reference/tsql-to-bigquery-sql.md) — dialect cheat sheet
- [BigQuery console survival guide](reference/bigquery-console-survival-guide.md) — where everything lives, for first-time console users
- [Migration map](reference/migration-map.md) — your end-to-end target architecture on one page
- [Power BI ↔ BigQuery connector guide](reference/powerbi-bigquery-connector-guide.md) — the last mile to your existing reports
- [Glossary](reference/glossary.md) — the GCP vocabulary in SQL Server terms

## Ground rules

- **Ask anything.** You're senior engineers who are new to one console. "Where do I click?" questions are expected and welcome — sixteen people learning one new UI goes faster when nobody sits stuck.
- **Parking lot.** Questions that would pull the room off the day's path get written down visibly and answered before the day ends.
- **Labs are safe to break.** Temporary projects, free or pennies of cost, nothing connected to state systems. If something fails, that's a learning moment — say so and we'll look at it together.
- **This pack is yours.** Take it with you. The reference cards were written to be useful at your desk the week after class, not just during it.
