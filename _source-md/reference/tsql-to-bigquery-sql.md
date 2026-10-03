# T-SQL → BigQuery SQL — Dialect Cheat Sheet

BigQuery speaks **GoogleSQL** (standard SQL). Most of your T-SQL transfers directly; this card is the differences you'll actually hit, first used on Day 1 afternoon and hardest-needed in the Day-2 Iceberg lab. Every row below matches the BigQuery docs (links at the bottom).

## The everyday rows

| T-SQL | BigQuery GoogleSQL | Notes |
|---|---|---|
| `[Order ID]` | `` `Order ID` `` | **Backticks, not square brackets.** Quote the whole three-part name as one: `` `project.dataset.table` `` |
| `SELECT TOP 100 *` | `SELECT * ... LIMIT 100` | **`LIMIT`, not `TOP`** — and it goes at the end of the query |
| `ISNULL(col, 0)` | `IFNULL(col, 0)` or `COALESCE(col, 0)` | Prefer `COALESCE` (standard, takes multiple fallbacks) |
| `CAST(x AS INT)` (errors on bad data) | `SAFE_CAST(x AS INT64)` | `SAFE_CAST` returns `NULL` instead of failing the query — put it in Silver-layer models that absorb vendor-file dirt |
| `GETDATE()` | `CURRENT_TIMESTAMP()` | Returns `TIMESTAMP` (UTC). Also `CURRENT_DATE()`, `CURRENT_DATETIME()` |
| `DATEADD(day, -7, d)` | `DATE_SUB(d, INTERVAL 7 DAY)` | Add with `DATE_ADD`, subtract with `DATE_SUB`; also `TIMESTAMP_ADD` / `DATETIME_ADD` / `TIMESTAMP_SUB` |
| `DATEDIFF(day, a, b)` | `DATE_DIFF(b, a, DAY)` | **Argument order flips**: later date first. Also `TIMESTAMP_DIFF` |
| `LEN(s)` | `LENGTH(s)` | |
| `SUBSTRING(s, 1, 3)` | `SUBSTR(s, 1, 3)` | `SUBSTRING` also works as an alias; positions are 1-based in both |
| `CHARINDEX('x', s)` | `STRPOS(s, 'x')` | Haystack first, needle second — the argument order flips |
| `s1 + s2` | `CONCAT(s1, s2)` or `s1 \|\| s2` | `CONCAT` treats `NULL` as empty string (no `CONCAT_NULL_YIELDS_NULL` setting to remember) |
| `5 / 2` → `2` | `5 / 2` → `2.5` | Division always returns a floating-point type. Integer division is `DIV(5, 2)` → `2` |
| divide by zero → error | also an error | Use `SAFE_DIVIDE(x, y)` to get `NULL` instead |
| `int` / `bigint` | `INT64` | One integer type. `datetime` ≈ `TIMESTAMP` (UTC) **or** `DATETIME` (civil time, no zone) — pick deliberately per column |
| Stored procedures, batches | **Scripting**: `DECLARE x INT64; SET x = ...;` plus `IF ... END IF;`, `WHILE ... END WHILE;` | Multi-statement scripts run straight in the query editor — your "anonymous sproc" instinct works |
| `MERGE` | `MERGE` | Exists, same purpose: upsert by match condition |
| CTEs (`WITH`), window functions (`ROW_NUMBER() OVER (PARTITION BY ...)`) | identical | Work exactly as you expect |
| `USE mydb` | — | **No `USE`.** Always fully qualify: `` `project.dataset.table` `` |

## Things that will bite you

1. **Case sensitivity.** String comparisons are case-sensitive (`'smith' ≠ 'Smith'`), and dataset and table names are case-sensitive by default. If your SQL Server collation is the usual case-insensitive sort, this is the difference most likely to produce "the same" rows not joining.
2. **Project IDs contain dashes — backtick the whole name.** Lab projects have IDs like `qwiklabs-gcp-01-ab12cd34ef56`. `` `qwiklabs-gcp-01-ab12cd34ef56.class.orders` `` works; unquoted or partially quoted versions fail.
3. **Integer math doesn't truncate, and zero divides loudly.** `/` returns a float; divide-by-zero errors out the whole query. Reach for `DIV()` and `SAFE_DIVIDE()`.
4. **Nested/repeated columns need `UNNEST`.** BigQuery tables can hold `ARRAY<STRUCT<...>>` columns (an order with its line items inside the row). You can't treat them like a child table until you flatten: `FROM orders, UNNEST(line_items) AS li`. You'll meet this in the derived-tables activity (DIN §29).
5. **`TIMESTAMP` ≠ `DATETIME`.** Comparing or joining the two types errors instead of implicitly converting. Decide per column: `TIMESTAMP` for event instants, `DATETIME` for "wall-clock" values like a business date.
6. **External-table DDL is metadata-only and returns instantly.** If a `CREATE EXTERNAL TABLE` seems to hang, the statement is wrong (usually the URI) — it's not "reading the files."

## Pleasant surprises

- `SELECT * EXCEPT (cust_email, cust_phone)` — project everything *but* the PII, no column list.
- `SELECT * REPLACE (SAFE_CAST(minutes AS INT64) AS minutes)` — re-type a column inline.
- `QUALIFY` — filter on a window function without a subquery: `... QUALIFY ROW_NUMBER() OVER (PARTITION BY case_id ORDER BY updated_at DESC) = 1` — your "latest record per key" pattern in one line.

## Dig deeper

- [Query syntax (identifiers, `LIMIT`, CTEs, `UNNEST`, `QUALIFY`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/query-syntax)
- [Conditional expressions (`IFNULL`, `COALESCE`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/conditional_expressions)
- [Conversion functions (`SAFE_CAST`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/conversion_functions)
- [Date functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/date_functions) · [Timestamp functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/timestamp_functions) · [String functions](https://cloud.google.com/bigquery/docs/reference/standard-sql/string_functions) · [Operators (`DIV`, `SAFE_DIVIDE`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/operators)
- [Scripting (`DECLARE`, `SET`, `IF`, `WHILE`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/scripting)
- [DML (`MERGE`)](https://cloud.google.com/bigquery/docs/reference/standard-sql/dml-syntax)

_Part of the Iowa DOM DoIT Data Engineering student pack — see `../README.md`._
