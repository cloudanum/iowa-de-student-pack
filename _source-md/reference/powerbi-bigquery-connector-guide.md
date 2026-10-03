# Power BI ↔ BigQuery: connecting your Gold marts

The last-mile guide from Day 2 (Tue Oct 6, ~3:05 PM CT), written to keep: how to point your existing Power BI reports at BigQuery Gold marts — desktop connection, the Import vs DirectQuery decision, service-side credentials, and the gateway answer for the M&O team.

## Why this matters for your migration

Your migration's endgame is one sentence: **your reports don't change, their source does.** The state's Power BI estate stays exactly as it is — same report authors, same workspaces, same consumers. The only thing that changes is where "Get Data" points. This guide is that change, end to end.

## Before you start

- **Power BI Desktop, June 2021 or newer.** Google sign-in from Power BI requires it (Google discontinued embedded-browser sign-ins in 2021).
- **Your own Google account**, with access to the GCP project that holds the Gold dataset. To connect and query, your account needs `roles/bigquery.dataViewer` on the Gold dataset and `roles/bigquery.jobUser` on the project — your GCP admin grants both. If you can query the mart in the BigQuery console, you can connect to it from Power BI.
- **Know your target's full name:** project → dataset → table — the same hierarchy you used in the console all course long.
- Reference doc to bookmark: Microsoft keeps the connector's supported-features table and auth notes at [Google BigQuery connector (Power Query)](https://learn.microsoft.com/en-us/power-query/connectors/google-bigquery). Check it when you set this up for real — the details below are stable, the dialogs evolve.

## Step 1: Connect from Power BI Desktop

1. **Home → Get Data → More…**, then find **Google BigQuery** (search for it, or look in the Database category) → **Connect**. The connector ships in the box; it is the same Power Query connector Excel uses.
2. Leave **Advanced options** alone for a first connection (that is where a billing project or a custom SQL statement would go). Select **OK**.
3. **Sign in.** Choose the organizational-account sign-in, then **Sign In**. A "Sign in with Google" dialog appears: pick your Google account and approve connecting to Power BI Desktop. Select **Connect**.
4. **Navigator.** Expand the tree — project → dataset → table — and pick your mart table. Projects and datasets appear exactly as they do in the GCP console: the resource hierarchy you learned on Day 1, surfacing inside your existing BI tool.
5. **Choose Import or DirectQuery** when the dialog offers both. For a first look, pick **Import** and load — the decision deserves the table below, not a coin flip.
6. Select **Load**. The table lands in the model, in the Fields pane. From here everything is the Power BI you already know — DAX, visuals, publish to the service. Nothing on the report side changes.

**What the Google sign-in actually means:** the connector uses OAuth, so **BigQuery sees the report author as a person.** IAM on the Gold dataset applies to each author individually — including any row- or column-level security you define there — and the BigQuery audit trail shows real people running real queries, not a shared SQL login. Access is granted and revoked in IAM, per person. That is a feature: treat it as one, and never share a single Google account across authors.

## Step 2: The decision — Import vs DirectQuery

The connector supports both. They are not interchangeable; choose per mart.

| | **Import** (data cached in Power BI) | **DirectQuery** (live queries to BigQuery) |
|---|---|---|
| **Latency** | Stale until the next refresh — fine for daily marts | Current on every visual interaction |
| **BigQuery cost** | One query per refresh — small and predictable | A query per visual, per user, per click — bills scan bytes continuously; on on-demand pricing this needs watching |
| **Report performance** | Fastest — data sits in-memory in Power BI | Bounded by BigQuery response time — usually seconds; fine on well-partitioned Gold tables |
| **Features** | Full DAX, all visuals | Some DAX and visual limitations (standard DirectQuery rules) |
| **Fits Iowa when…** | **Default for your nightly-built Gold marts** — Dataform rebuilds the marts on a schedule anyway, so a refresh right after the build matches reality | Executives need intra-day freshness, or a dataset is too large to cache |

**Recommendation: start with Import plus scheduled refresh, aligned to the Dataform release schedule.** Your marts are rebuilt nightly by design — DirectQuery buys freshness the pipeline does not have yet. Revisit per mart when streaming use cases appear; and note the cost math changes if you move to slot/flat-rate pricing — that is a Data Warehousing course conversation.

## Step 3: Publish — auth in the Power BI service

Two identities, two stories. Keep them distinct.

- **Power BI Desktop (report authors):** each author signs in with their **own Google account (OAuth)**, as above. BigQuery sees the person; IAM and row/column security apply per author; the audit trail is real people. No service accounts on desktops.
- **Power BI service (published reports, scheduled refresh):** the stored data-source credentials should be a **service account** — a non-human identity whose only job is "read the Gold dataset." Minimum roles: `roles/bigquery.dataViewer` on the Gold dataset, plus `roles/bigquery.jobUser` on the project so it can run query jobs. Set this under the semantic model's **Settings → Data source credentials** in the service; the connector supports service-account sign-in (account email plus JSON key). Scheduled refresh of an Import dataset runs as this identity.

You already enforce this discipline today — a service account for the Power BI service is the same instinct as a SQL Agent proxy account: a least-privilege, non-human identity that owns exactly one job. Same rule, new console.

One honest caveat: the exact credential options in the service evolve. The pattern — user OAuth on the desktop, service account in the service — is stable; confirm the current dialogs on the [Microsoft connector page](https://learn.microsoft.com/en-us/power-query/connectors/google-bigquery) when you set it up.

## Gateway note — for the M&O team

BigQuery is a **cloud** source: scheduled refresh from the Power BI service to BigQuery needs **no on-premises data gateway**. The gateway enters the picture only if a report **mashes up BigQuery with on-prem sources** (your SQL Server, file shares) — then one on-premises data gateway serves the on-prem legs, the same gateway infrastructure you run today. As sources move to the cloud, your gateway footprint gets quieter, not bigger.

## Common gotchas

- **Signed in with the wrong Google account.** Lab accounts, personal Gmail, work identity — the OAuth dialog happily uses whichever browser session is active, and Power BI caches it. Symptom: Navigator shows the wrong projects, or none. Fix: **File → Options and settings → Data source settings**, clear the BigQuery permission, and sign in again deliberately.
- **Can't see your project or dataset in the Navigator.** That is almost always IAM, not the connector: your account needs `dataViewer` on the dataset and `jobUser` on the project. Test in the BigQuery console first — if you can query the table there, the connector will see it.
- **Wrong project picked.** Same wrong-project trap as the console picker on Day 1 — in an estate with many projects, confirm the project name before you expand anything.
- **DirectQuery bill shock.** Every visual interaction by every user issues a live BigQuery query. On on-demand pricing, a popular DirectQuery dashboard is a metering device. This is why the default above is Import.
- **Scheduled refresh fails after publish.** You loaded data in Desktop, so it must be fine — no: the service needs its own stored credentials (the service account above), and that account needs `jobUser` or every refresh job fails to run.
- **Google sign-in fails or loops.** Check the Power BI Desktop version — pre-June-2021 builds cannot complete Google sign-in.
- **IT policy demands a gateway.** Only true if the report also touches on-prem sources. BigQuery alone never needs one.

## Verify it works

- [ ] The mart table appears in the Fields pane after Load, with the expected row count (compare against a `COUNT(*)` in the BigQuery console).
- [ ] A visual you already own (reuse an existing report page) renders against the new source with no measure changes.
- [ ] After publish, the semantic model's data-source credentials hold the service account, and a manual **Refresh now** succeeds in the service.
- [ ] BigQuery's job history shows your queries under your identity (desktop) and the service account's identity (service refresh) — the audit story you will be asked about.

## What this replaces in your current stack

- The SSIS extract → reporting-copy tables that exist only so Power BI has something stable to read — Gold marts in BigQuery take that role.
- The ODBC DSN / SQL Server connection entries in every author's Power BI Desktop — replaced by the Google BigQuery connector and per-person OAuth.
- The shared SQL login embedded in published datasets — replaced by a least-privilege service account, with real people in the audit trail.

## The closing idea

> Your Gold marts land in the Power BI you already have. Same report authors, same workspaces, same DAX, same consumers — the only thing that changes is the connection string. Nothing on the report side changes. That is the whole migration, end to end: kill the extracts, land in BigQuery, Bronze/Silver/Gold with Dataform, and the reports keep working.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../day2/00_schedule.md`._
