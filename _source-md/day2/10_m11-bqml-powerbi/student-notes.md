# BQML and the Power BI last mile — student notes

Student notes for Day 2 (Tue Oct 6), 2:50–3:20 PM CT: a short live demo of BigQuery ML, then how your Gold marts reach the Power BI reports the state already runs on.

## BigQuery ML: ML where the data lives, in SQL

Everything over these two days has been about not moving data — Bronze stays in the bucket, transforms run as SQL inside BigQuery. Machine learning gets the same treatment: no CSV export, no Python notebook to secure, no separate ML platform to patch. A model is an object in your dataset, created by a SQL statement, and it shows up in the Explorer pane next to your tables — with IAM, Information Schema entries, and a place in Dataform pipelines if you want one.

The demo trains a linear regression that predicts a penguin's body mass from its bill and flipper measurements, using the public `bigquery-public-data.ml_datasets.penguins` table (~344 rows). Three SQL statements do the whole job — train, evaluate, predict:

```sql
-- 1. TRAIN (runs ~1–2 minutes) — `class` is any dataset you can create models in,
-- e.g. the `class` dataset you created on Day 1
CREATE OR REPLACE MODEL class.penguins_model
OPTIONS(model_type = 'linear_reg', input_label_cols = ['body_mass_g']) AS
SELECT culmen_length_mm, culmen_depth_mm, flipper_length_mm,
       species, island, sex, body_mass_g
FROM `bigquery-public-data.ml_datasets.penguins`
WHERE body_mass_g IS NOT NULL;

-- 2. EVALUATE — the unit test for a model (seconds)
SELECT * FROM ML.EVALUATE(MODEL class.penguins_model);

-- 3. PREDICT — actual vs predicted, side by side (seconds)
SELECT species, body_mass_g AS actual_grams,
       predicted_body_mass_g AS predicted_grams
FROM ML.PREDICT(MODEL class.penguins_model,
  (SELECT * FROM `bigquery-public-data.ml_datasets.penguins`
   WHERE body_mass_g IS NOT NULL));
```

Try it yourself: the table is a few hundred rows and the queries scan kilobytes, so this sits comfortably inside the free tier — paste all three into your own project and run them. One gotcha: the public datasets live in the US multi-region location, so the dataset holding your model must be location-compatible (a `class` dataset created with console defaults in the lab is fine).

## The honest framing for your project

Nothing in your migration points at ML — and these notes are not a quiet suggestion that it should. Your priority is the warehouse: kill the extracts, land Bronze/Silver/Gold, feed Power BI. That is the next two quarters. What the demo buys you is a door you now know exists: the day someone asks "can we predict case volumes, backlog, demand?", the answer is "the data is already here, and so is the tool." `model_type` has dozens of options — boosted trees, time-series ARIMA, DNNs — and the syntax keeps this exact shape. Revisit when a real use case appears; the Data Warehousing course goes deeper.

## Key takeaways

- BigQuery ML trains and serves models with SQL, inside BigQuery. If you can write a SELECT, you can train a model.
- A model is a first-class object in a dataset — it sits next to tables in the Explorer pane and gets IAM like any other resource.
- `CREATE MODEL` trains, `ML.EVALUATE` measures error, `ML.PREDICT` scores rows — three statements, and the data never leaves the warehouse.
- `ML.EVALUATE` is the same discipline as your Dataform assertions: assertions check data, `ML.EVALUATE` checks predictions.
- Notice what did not happen in the demo: no extract job, no staging server, no ODBC export. The training data never moved — the whole two days in miniature.
- When a data-science team shows up, your Gold marts are already their training data.
- ML is a possible future for DOM DoIT, not a priority. Know the door exists; keep building the warehouse.

## Your SQL Server world → GCP world (this block)

| Your SQL Server world | GCP world |
|---|---|
| Export to CSV, then R/Python on someone's desktop | `CREATE MODEL` in SQL, where the data lives |
| SQL Server Machine Learning Services (R/Python inside the database) | BigQuery ML — same idea, pure SQL, no server to manage |
| A model file on a share | A model object in your dataset (IAM, Information Schema) |
| A scoring stored procedure | `ML.PREDICT()` in a query — schedulable like any query |
| A model validation report | `ML.EVALUATE()` |
| Reports pointed at the reporting copy | The same Power BI reports pointed at Gold marts — see the connector guide below |

## Dig deeper

- [Introduction to BigQuery ML](https://cloud.google.com/bigquery/docs/bqml-introduction) — supported model types, syntax, and pricing.
- [Power BI ↔ BigQuery connector guide](../../reference/powerbi-bigquery-connector-guide.md) — the companion how-to for the second half of this block; keep it for when you connect your first Gold mart.

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../00_schedule.md`._
