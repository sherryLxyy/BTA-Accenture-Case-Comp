-- ============================================================
-- 02_data_quality_checks: data quality audit
-- Run order: 3/4
-- Purpose: turn "the data has issues" into reproducible evidence
--          instead of prose claims.
-- Output:  ifc.curated.data_quality_checks
-- ============================================================

CREATE OR REPLACE TABLE ifc.curated.data_quality_checks AS

SELECT 'P1' AS check_id, 'Duplicate Project Number' AS check_name,
       COUNT(*) AS affected_rows, ROUND(COUNT(*)*100.0/5000,2) AS pct_of_5000,
       '1,126 numbers map to multiple projects; never use for JOIN / GROUP BY / dedup' AS remedy
FROM (SELECT project_number FROM ifc.raw.projects
      GROUP BY project_number HAVING COUNT(*) > 1) x

UNION ALL
SELECT 'P2', 'Non-standard Region values', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'Normalised: Latin America & Caribbean -> Latin America; Middle East & North Africa -> Middle East'
FROM ifc.raw.projects
WHERE region NOT IN ('East Asia & Pacific','Europe & Central Asia','Latin America',
                     'Middle East','North America','South Asia','Sub-Saharan Africa')

UNION ALL
SELECT 'P3', 'Approved total differs from product sum by > $1M', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'Use total_approved_usd_mm as primary measure; the diff list is the Q28 answer'
FROM ifc.raw.projects
WHERE ABS(total_approved_usd_mm
        - (COALESCE(risk_mgmt_usd_mm,0)+COALESCE(guarantee_usd_mm,0)
        +  COALESCE(loan_usd_mm,0)+COALESCE(equity_usd_mm,0))) > 1

UNION ALL
SELECT 'P4a', 'Signed Date earlier than Approval Date', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'Keep raw values; document exclusion rule in time-interval answers'
FROM ifc.raw.projects WHERE signed_date < approval_date

UNION ALL
SELECT 'P4b', 'Status Pending but Approval Date present', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'Needs business confirmation; status field takes precedence'
FROM ifc.raw.projects WHERE status = 'Pending' AND approval_date IS NOT NULL

UNION ALL
SELECT 'P5', 'Invested Date is null', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'NULL excluded from denominators; naturally empty for Pending / Dropped'
FROM ifc.raw.projects WHERE invested_date IS NULL

UNION ALL
SELECT 'P6', 'Projects without monitoring record', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'All Dropped (100%); performance fields are NULL after LEFT JOIN'
FROM ifc.curated.projects p
LEFT JOIN ifc.curated.monitoring m ON p.project_url = m.project_url
WHERE m.project_url IS NULL

UNION ALL
SELECT 'P7', 'Active/Closed projects with no capacity stated', COUNT(*), ROUND(COUNT(*)*100.0/5000,2),
       'Q24 must report the "not stated" count separately, never treat as 0'
FROM ifc.curated.projects
WHERE status IN ('Active','Closed')
  AND LOWER(COALESCE(project_description,'')) NOT LIKE '%mw%'
  AND LOWER(COALESCE(project_description,'')) NOT LIKE '%megawatt%';

-- Inspect audit results
SELECT * FROM ifc.curated.data_quality_checks ORDER BY check_id;

-- Acceptance check: expect 5000 / 7 / 0 / 0 / 0
SELECT
  COUNT(*)                                                                   AS rows_total,
  COUNT(DISTINCT region)                                                     AS region_values,
  SUM(CASE WHEN region IN ('Latin America & Caribbean',
                           'Middle East & North Africa') THEN 1 ELSE 0 END)  AS dirty_region_rows,
  SUM(CASE WHEN total_approved_usd_mm < 0 THEN 1 ELSE 0 END)                 AS negative_amounts,
  SUM(CASE WHEN approval_date > as_of_date THEN 1 ELSE 0 END)                AS approval_after_asof
FROM ifc.curated.projects;
