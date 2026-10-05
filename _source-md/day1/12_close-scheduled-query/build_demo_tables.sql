-- build_demo_tables.sql
-- Builds the nested/repeated demo tables this course's DIN-derived activities
-- (§11 clustered tables, §29 derived tables, Day-1 closing scheduled query)
-- expect to find in the instructor's project.
--
-- Why this file exists: the DIN page's own copies live in `roi-bq-demos.bq_demo`,
-- which is not reachable from our lab accounts, and ROI's generator
-- (schema-demo/load_data.sql) derives 7.5B-order tables from those same
-- unreachable base tables at ~$200 a run. This script rebuilds the same
-- schemas at class size (~1.2M orders, 3M line items) from pure SQL —
-- no external data, no cost beyond a few cents of slot time.
--
-- How to run: paste into the BigQuery editor in the instructor project
-- (roigcp-imran-ahmad) and run the three statements in order. Creates:
--   bq_demo.nested_once                        -- one row per order, line_items repeated
--   bq_demo.table_nested_partitioned           -- same, partitioned by order_date
--   bq_demo.table_nested_partitioned_clustered -- same, + clustered by cust_zip

CREATE SCHEMA IF NOT EXISTS `roigcp-imran-ahmad.bq_demo`;

CREATE OR REPLACE TABLE `roigcp-imran-ahmad.bq_demo.nested_once` AS
WITH ords AS (
  SELECT
    10000000 + a * 1000 + b AS order_num,
    DATE_ADD(DATE '2018-01-01', INTERVAL MOD(a * 1000 + b, 181) DAY) AS order_date,  -- Jan 1 - Jun 30 2018
    100000 + MOD(a * 1000 + b, 75000) AS cust_id
  FROM UNNEST(GENERATE_ARRAY(0, 1199)) a, UNNEST(GENERATE_ARRAY(0, 999)) b  -- 1.2M orders; one big GENERATE_ARRAY overflows
),
items AS (
  SELECT
    ords.*,
    li AS line_item_num,
    1000 + MOD(order_num + li, 9000) AS prod_code,
    1 + MOD(order_num + li, 5) AS qty,
    ROUND(5 + MOD(order_num * (li + 1), 20000) / 100, 2) AS prod_price
  FROM ords, UNNEST(GENERATE_ARRAY(1, 1 + MOD(order_num, 4))) AS li
)
SELECT
  cust_id,
  CONCAT('Customer ', cust_id) AS cust_name,
  CONCAT(CAST(cust_id AS STRING), ' Main Street') AS cust_address,
  ['IL','IA','AK','TX','CA','NY','FL','WA','CO','MO'][OFFSET(MOD(cust_id, 10))] AS cust_state,
  IF(MOD(cust_id, 25) = 0, 8754, 10000 + MOD(cust_id, 89999)) AS cust_zip,
  CONCAT('cust', cust_id, '@example.com') AS cust_email,
  CONCAT('555-', LPAD(CAST(MOD(cust_id, 10000000) AS STRING), 7, '0')) AS cust_phone,
  order_num,
  order_date,
  ARRAY_AGG(
    STRUCT(line_item_num, prod_code, qty,
           CONCAT('Product ', prod_code) AS prod_name,
           CONCAT('Description for product ', prod_code) AS prod_desc,
           prod_price)
    ORDER BY line_item_num
  ) AS line_items
FROM items
GROUP BY order_num, order_date, cust_id;

CREATE OR REPLACE TABLE `roigcp-imran-ahmad.bq_demo.table_nested_partitioned`
PARTITION BY order_date AS
SELECT * FROM `roigcp-imran-ahmad.bq_demo.nested_once`;

CREATE OR REPLACE TABLE `roigcp-imran-ahmad.bq_demo.table_nested_partitioned_clustered`
PARTITION BY order_date
CLUSTER BY cust_zip AS
SELECT * FROM `roigcp-imran-ahmad.bq_demo.nested_once`;
