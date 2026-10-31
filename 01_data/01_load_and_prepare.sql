-- ============================================================
-- 01_load_and_prepare: data loading and cleansing
-- Run order: 2/4
-- Prerequisite: both CSVs uploaded to /Volumes/ifc/raw/raw_files/
-- Outputs: ifc.raw.{projects, monitoring}
--          ifc.curated.{projects, monitoring, portfolio}
-- Key decision: project_url is the only reliable key
--               (project_number has 1,126 duplicated values)
-- ============================================================


-- ------------------------------------------------------------
-- Layer 1: raw -- landing only (column renaming + type casting)
-- ------------------------------------------------------------

-- multiLine => true is mandatory: Project Description contains line
-- breaks. Without it, 5,000 rows silently become 5,638 rows.
CREATE OR REPLACE TABLE ifc.raw.projects AS
SELECT
  TRY_CAST(`Date Disclosed` AS DATE)                                      AS date_disclosed,
  `Project Name`                                                          AS project_name,
  `Document Type`                                                         AS document_type,
  TRY_CAST(`Project Number` AS BIGINT)                                    AS project_number,
  `Project Url`                                                           AS project_url,
  `Product Line`                                                          AS product_line,
  `Region`                                                                AS region,
  `Country`                                                               AS country,
  `Project Description`                                                   AS project_description,
  `Industry`                                                              AS industry,
  `Environmental Category`                                                AS environmental_category,
  `Department`                                                            AS department,
  `Status`                                                                AS status,
  TRY_CAST(`Projected Board Date` AS DATE)                                AS projected_board_date,
  TRY_CAST(`IFC Approval Date` AS DATE)                                   AS approval_date,
  TRY_CAST(`IFC Signed Date` AS DATE)                                     AS signed_date,
  TRY_CAST(`IFC Invested Date` AS DATE)                                   AS invested_date,
  TRY_CAST(`IFC investment for Risk Management(Million - USD)` AS DOUBLE) AS risk_mgmt_usd_mm,
  TRY_CAST(`IFC investment for Guarantee(Million - USD)` AS DOUBLE)       AS guarantee_usd_mm,
  TRY_CAST(`IFC investment for Loan(Million - USD)` AS DOUBLE)            AS loan_usd_mm,
  TRY_CAST(`IFC investment for Equity(Million - USD)` AS DOUBLE)          AS equity_usd_mm,
  TRY_CAST(`Total IFC investment as approved by Board(Million - USD)` AS DOUBLE) AS total_approved_usd_mm,
  `WB Country Code`                                                       AS wb_country_code,
  TRY_CAST(`As of Date` AS DATE)                                          AS as_of_date
FROM read_files(
  '/Volumes/ifc/raw/raw_files/synthetic_ifc_projects_5000.csv',
  format      => 'csv',
  header      => true,
  inferSchema => true,
  multiLine   => true
);

CREATE OR REPLACE TABLE ifc.raw.monitoring AS
SELECT
  `Project Url`                                             AS project_url,
  TRY_CAST(`Project Number` AS BIGINT)                      AS project_number,
  `Client ID`                                               AS client_id,
  `Client Name`                                             AS client_name,
  TRY_CAST(`Internal Risk Rating` AS INT)                   AS internal_risk_rating,
  `Currency`                                                AS currency,
  `Climate Flag`                                            AS climate_flag,
  TRY_CAST(`IFC Disbursed Amount(Million - USD)` AS DOUBLE) AS disbursed_usd_mm,
  `Performance Status`                                      AS performance_status,
  TRY_CAST(`Days Since Last Review` AS INT)                 AS days_since_review
FROM read_files(
  '/Volumes/ifc/raw/raw_files/synthetic_project_monitoring.csv',
  format      => 'csv',
  header      => true,
  inferSchema => true,
  multiLine   => true
);


-- ------------------------------------------------------------
-- Layer 2: curated -- normalisation, derived measures, join
-- ------------------------------------------------------------

CREATE OR REPLACE TABLE ifc.curated.projects AS
SELECT
  project_url, project_number, project_name, document_type, product_line,
  CASE region
    WHEN 'Latin America & Caribbean'  THEN 'Latin America'
    WHEN 'Middle East & North Africa' THEN 'Middle East'
    ELSE region
  END                                                          AS region,
  country, wb_country_code, industry, department,
  environmental_category, status, project_description,
  date_disclosed, projected_board_date, approval_date, signed_date, invested_date, as_of_date,
  risk_mgmt_usd_mm, guarantee_usd_mm, loan_usd_mm, equity_usd_mm, total_approved_usd_mm,
  YEAR(approval_date)                                          AS approval_year,
  YEAR(signed_date)                                            AS signed_year,
  YEAR(invested_date)                                          AS invested_year,
  DATEDIFF(signed_date, approval_date)                         AS days_approval_to_sign,
  DATEDIFF(invested_date, signed_date)                         AS days_sign_to_invest,
  ROUND(COALESCE(risk_mgmt_usd_mm,0) + COALESCE(guarantee_usd_mm,0)
      + COALESCE(loan_usd_mm,0)      + COALESCE(equity_usd_mm,0), 6)      AS product_sum_usd_mm,
  ROUND(total_approved_usd_mm
      - (COALESCE(risk_mgmt_usd_mm,0) + COALESCE(guarantee_usd_mm,0)
      +  COALESCE(loan_usd_mm,0)      + COALESCE(equity_usd_mm,0)), 6)    AS product_total_diff_usd_mm,
  (CASE WHEN COALESCE(risk_mgmt_usd_mm,0) > 0 THEN 1 ELSE 0 END
 + CASE WHEN COALESCE(guarantee_usd_mm,0)   > 0 THEN 1 ELSE 0 END
 + CASE WHEN COALESCE(loan_usd_mm,0)        > 0 THEN 1 ELSE 0 END
 + CASE WHEN COALESCE(equity_usd_mm,0)      > 0 THEN 1 ELSE 0 END)        AS product_count
FROM ifc.raw.projects;

CREATE OR REPLACE TABLE ifc.curated.monitoring AS
SELECT
  project_url, project_number, client_id, client_name,
  internal_risk_rating, currency, climate_flag,
  disbursed_usd_mm, performance_status, days_since_review,
  CASE
    WHEN internal_risk_rating >= 5 THEN 'High'
    WHEN internal_risk_rating >= 3 THEN 'Medium'
    WHEN internal_risk_rating IS NOT NULL THEN 'Low'
  END                                                                   AS risk_band,
  CASE WHEN performance_status IN ('Past Due','Watchlist') THEN TRUE ELSE FALSE END AS is_flagged
FROM ifc.raw.monitoring;

-- Primary analysis table: every WS2 / WS3 query reads from here.
-- Dropped projects have no monitoring record (1,232), so performance
-- fields are NULL after the LEFT JOIN -- this is expected, not an error.
CREATE OR REPLACE TABLE ifc.curated.portfolio AS
SELECT
  p.*,
  m.client_id, m.client_name, m.internal_risk_rating, m.risk_band,
  m.currency, m.climate_flag, m.disbursed_usd_mm,
  m.performance_status, m.days_since_review, m.is_flagged
FROM ifc.curated.projects p
LEFT JOIN ifc.curated.monitoring m
  ON p.project_url = m.project_url;


-- ------------------------------------------------------------
-- Acceptance check: expect 5000 / 3768 / 5000 / 1232 / 6477
-- rows_if_join_on_number is the counter-evidence: joining on
-- project_number inflates the row count by 29.5%.
-- ------------------------------------------------------------
SELECT
  (SELECT COUNT(*) FROM ifc.curated.projects)                          AS projects_rows,
  (SELECT COUNT(*) FROM ifc.curated.monitoring)                        AS monitoring_rows,
  (SELECT COUNT(*) FROM ifc.curated.portfolio)                         AS portfolio_rows,
  (SELECT COUNT(*) FROM ifc.curated.portfolio WHERE client_id IS NULL) AS unmatched_dropped,
  (SELECT COUNT(*) FROM ifc.curated.projects p
     JOIN ifc.curated.monitoring m ON p.project_number = m.project_number) AS rows_if_join_on_number;
